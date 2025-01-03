import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../../../shared/models/post.dart';
import '../../home/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 더미 게시물 데이터를 State 클래스의 필드로 이동
  final List<Post> _dummyPosts = [
    Post(
      id: 'p1',
      userId: 'cookiemonster',
      username: 'Cookie Monster',
      userAvatar: 'assets/images/cookie_monster.png',
      content: '오늘의 쿠키 리뷰! 초코칩이 가득한 이 쿠키는 정말 환상적이에요! '
          'OM NOM NOM NOM! 🍪✨\n\n'
          '#쿠키스타그램 #쿠키맛집 #쿠키리뷰 #COOKIEEEEE',
      imageUrl: 'https://picsum.photos/400/300?random=10',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 42,
      replies: 12,
    ),
    Post(
      id: 'p2',
      userId: 'cookiemonster',
      username: 'Cookie Monster',
      userAvatar: 'assets/images/cookie_monster.png',
      content: '쿠키가 없어서 슬픈 날... 😭\n'
          '누가 나에게 쿠키를 줄 착한 사람 없나요?\n'
          'ME NEED COOKIE NOW! 🍪\n'
          '#쿠키없음 #쿠키앓이 #쿠키중독 #도와줘요',
      imageUrl: 'https://picsum.photos/400/300?random=11',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 67,
      replies: 23,
    ),
    Post(
      id: 'p3',
      userId: 'cookiemonster',
      username: 'Cookie Monster',
      userAvatar: 'assets/images/cookie_monster.png',
      content: '새로운 쿠키 레시피를 배웠어요! 🧁\n'
          '하지만... 반죽을 다 먹어버렸네요 😅\n'
          'ME SORRY... BUT ME LOVE COOKIE DOUGH TOO!\n'
          '#쿠키실패 #그래도맛있다 #쿠키반죽 #냠냠',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likes: 31,
      replies: 8,
    ),
  ];

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
            username: 'cookiemonster',
            name: 'Cookie Monster',
            bio: '쿠키를 사랑하는 털복숭이 괴물 🍪\n'
                '쿠키 먹방 전문가 | 세서미 스트리트 주민\n'
                'ME WANT COOKIE! ME EAT COOKIE! OM NOM NOM! 🤤',
            avatar: 'assets/images/cookie_monster.png',
            posts: 1234,
            followers: 9999,
            following: 42,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyPosts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: _dummyPosts[index],
                onLike: (bool isLiked) {
                  setState(() {
                    final post = _dummyPosts[index];
                    _dummyPosts[index] = Post(
                      id: post.id,
                      userId: post.userId,
                      username: post.username,
                      userAvatar: post.userAvatar,
                      content: post.content,
                      imageUrl: post.imageUrl,
                      createdAt: post.createdAt,
                      likes: post.likes + (isLiked ? 1 : -1),
                      replies: post.replies,
                      isLiked: isLiked,
                    );
                  });
                },
                onReply: () {},
                onDelete: null,
              );
            },
          ),
        ],
      ),
    );
  }
}
