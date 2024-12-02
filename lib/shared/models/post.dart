class Post {
  final String id;
  final String userId;
  final String username;
  final String? userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int replies;
  final bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.replies,
    this.isLiked = false,
  });
}
