import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 20,
  });

  bool get _isNetworkImage =>
      imageUrl != null &&
      (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

  bool get _isLocalImage => imageUrl != null && imageUrl!.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppTheme.greyColor,
        backgroundImage: CachedNetworkImageProvider(
          imageUrl!,
          errorListener: (error) =>
              debugPrint('Error loading profile image: $error'),
        ),
      );
    }

    if (_isLocalImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppTheme.greyColor,
        backgroundImage: AssetImage(imageUrl!),
      );
    }

    // 이미지가 없는 경우 이름의 첫 글자를 보여줌
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final Color avatarColor = _getAvatarColor(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarColor,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 이름에 따라 다른 색상을 반환하는 메서드
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.purple[700]!,
      Colors.orange[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
    ];

    // 이름의 각 문자 ASCII 값을 더해서 색상 인덱스 결정
    final int hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return colors[hash % colors.length];
  }
}