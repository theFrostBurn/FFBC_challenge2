import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../../../shared/models/post.dart';
import '../../home/widgets/post_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // 설정 메뉴를 표시하는 로직을 추가할 수 있습니다.
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const ProfileHeader(
            username: 'johndoe',
            name: '홍길동',
            bio: '플러터 개발자 | UI/UX 디자이너\n취미로 사진 찍는 걸 좋아합니다 📸',
            avatar: 'https://i.pravatar.cc/150?img=8',
            posts: 42,
            followers: 1234,
            following: 567,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyPosts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: _dummyPosts[index],
                onLike: () {},
                onReply: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  // 더미 게시물 데이터
  static final List<Post> _dummyPosts = [
    Post(
      id: 'p1',
      userId: 'johndoe',
      username: '홍길동',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      content: '오늘은 새로운 프로젝트를 시작했습니다. Flutter로 만드는 SNS 앱! 🚀',
      imageUrl: 'https://picsum.photos/400/300?random=10',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likes: 89,
      replies: 12,
    ),
    Post(
      id: 'p2',
      userId: 'johndoe',
      username: '홍길동',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      content: '주말에 찍은 사진 한 장 📸✨',
      imageUrl: 'https://picsum.photos/400/300?random=11',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      likes: 156,
      replies: 8,
    ),
  ];
}
