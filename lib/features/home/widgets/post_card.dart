import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/models/post.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/profile_avatar.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(bool)? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onReply,
    this.onDelete,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimController;
  bool _isLiked = false;
  int _likeCount = 0;
  final GlobalKey _likeButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likes;
    _heartAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    widget.onLike?.call(_isLiked);

    if (_isLiked) {
      _heartAnimController.forward(from: 0.0);

      final RenderBox? likeButton =
          _likeButtonKey.currentContext?.findRenderObject() as RenderBox?;
      if (likeButton == null) return;

      final position = likeButton.localToGlobal(Offset.zero);
      final size = likeButton.size;

      final entry = OverlayEntry(
        builder: (context) => AnimatedBuilder(
          animation: _heartAnimController,
          builder: (context, child) {
            return Positioned(
              left: position.dx + (size.width / 2) - 12,
              top: position.dy +
                  (size.height / 2) -
                  24 -
                  (_heartAnimController.value * 40),
              child: Opacity(
                opacity: 1 - _heartAnimController.value,
                child: Transform.scale(
                  scale: 1 + (_heartAnimController.value * 0.5),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),
      );

      final overlay = Overlay.of(context);
      overlay.insert(entry);
      Future.delayed(const Duration(milliseconds: 800), () {
        entry.remove();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMyPost = widget.post.userId == 'me';

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
                  imageUrl: widget.post.userAvatar,
                  name: widget.post.username,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        _getTimeAgo(widget.post.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
                if (isMyPost)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      // 삭제 확인 다이얼로그
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppTheme.darkGreyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('게시물 삭제'),
                          content: const Text('이 게시물을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                // 삭제 애니메이션
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final position = box.localToGlobal(Offset.zero);
                                final size = box.size;

                                final entry = OverlayEntry(
                                  builder: (context) =>
                                      TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutQuart,
                                    builder: (context, value, child) {
                                      return Positioned(
                                        left: position.dx,
                                        top: position.dy,
                                        width: size.width,
                                        height: size.height,
                                        child: Transform.translate(
                                          offset: Offset(
                                              0, size.height * value * 0.3),
                                          child: Opacity(
                                            opacity: 1 - value,
                                            child: Transform.scale(
                                              scale: 1 - value * 0.2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme.greyColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );

                                final overlay = Overlay.of(context);
                                overlay.insert(entry);
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                widget.onDelete?.call();
                                entry.remove();
                              },
                              child: Text(
                                '삭제',
                                style: TextStyle(color: Colors.red[400]),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),

            // 게시글 내용
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                widget.post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // 이미지가 있는 경우 표시
            if (widget.post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrl!,
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
                    key: _likeButtonKey,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isLiked),
                        color: _isLiked ? Colors.red : null,
                      ),
                    ),
                    onPressed: _handleLike,
                  ),
                  Text(
                    _likeCount.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: widget.onReply,
                  ),
                  Text(
                    '${widget.post.replies}',
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
