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
        itemCount: _dummyActivities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = _dummyActivities[index];
          return ActivityItem(
            userAvatar: activity['userAvatar']!,
            username: activity['username']!,
            action: activity['action']!,
            time: DateTime.parse(activity['time']!),
            postImage: activity['postImage'],
            onTap: () {
              // 해당 게시물이나 프로필로 이동하는 로직을 추가할 수 있습니다.
            },
          );
        },
      ),
    );
  }

  // 더미 활동 데이터
  static final List<Map<String, String?>> _dummyActivities = [
    {
      'userAvatar': '', // 빈 문자열 - 이니셜 표시
      'username': '김철수',
      'action': '님이 회원님의 게시물을 좋아합니다.',
      'time':
          DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
    },
    {
      'userAvatar': null, // null - 이니셜 표시
      'username': '이영희',
      'action': '님이 회원님을 팔로우하기 시작했습니다.',
      'time':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      'userAvatar': '', // 빈 문자열 - 이니셜 표시
      'username': '박지민',
      'action': '님이 회원님의 게시물에 댓글을 남겼습니다: "멋져요! 👍"',
      'time':
          DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    },
  ];
}
