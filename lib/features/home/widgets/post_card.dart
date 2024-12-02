import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/models/post.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/profile_avatar.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 행
            Row(
              children: [
                ProfileAvatar(
                  imageUrl: post.userAvatar,
                  name: post.username,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        _getTimeAgo(post.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),

            // 게시글 내용
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // 이미지가 있는 경우 표시
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppTheme.greyColor,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],

            // 좋아요, 답글 버튼
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : null,
                    ),
                    onPressed: onLike,
                  ),
                  Text(
                    '${post.likes}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: onReply,
                  ),
                  Text(
                    '${post.replies}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
