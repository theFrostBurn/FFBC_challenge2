import 'package:flutter/material.dart';
import '../../../shared/widgets/profile_avatar.dart';

class SearchResultCard extends StatelessWidget {
  final String username;
  final String userAvatar;
  final String bio;
  final VoidCallback? onTap;

  const SearchResultCard({
    super.key,
    required this.username,
    required this.userAvatar,
    required this.bio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ProfileAvatar(
              imageUrl: userAvatar,
              name: username,
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    bio,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
