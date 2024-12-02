import 'package:flutter/material.dart';
import '../widgets/activity_item.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('활동'),
      ),
      body: ListView.separated(
        primary: false,
        itemCount: _dummyActivities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = _dummyActivities[index];
          return ActivityItem(
            userAvatar: activity['userAvatar'] ?? '',
            username: activity['username'] ?? '',
            action: activity['action'] ?? '',
            time: DateTime.parse(
                activity['time'] ?? DateTime.now().toIso8601String()),
            postImage: activity['postImage'],
            onTap: () {},
          );
        },
      ),
    );
  }

  // 더미 활동 데이터
  static final List<Map<String, dynamic>> _dummyActivities = [
    // String? 대신 dynamic 사용
    {
      'userAvatar': '',
      'username': '김철수',
      'action': '님이 회원님의 게시물을 좋아합니다.',
      'time':
          DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'postImage': null,
    },
    {
      'userAvatar': null,
      'username': '이영희',
      'action': '님이 회원님을 팔로우하기 시작했습니다.',
      'time':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'postImage': null,
    },
    {
      'userAvatar': '',
      'username': '박지민',
      'action': '님이 회원님의 게시물에 댓글을 남겼습니다: "멋져요! 👍"',
      'time':
          DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'postImage': null,
    },
  ];
}
