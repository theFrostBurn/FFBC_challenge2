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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatar': userAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'replies': replies,
      'isLiked': isLiked,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userAvatar: json['userAvatar'] as String?,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int,
      replies: json['replies'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }
}
