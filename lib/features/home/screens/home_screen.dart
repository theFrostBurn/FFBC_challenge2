import 'dart:math'; // Random 클래스를 위한 import 추가
import 'package:flutter/material.dart';
import '../../../shared/models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/fancy_title.dart';
import '../../../app/theme.dart'; // AppTheme import 추가

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Post> _posts = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialPosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // 실제 API 호출 시뮬레이션
    setState(() {
      // 초기 데이터도 랜덤하게 5개 생성
      _posts.addAll(_generateMorePosts(count: 5));
      _isLoading = false;
    });
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _posts.addAll(_generateMorePosts(count: 3)); // 3개씩 추가 로드
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.greyColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const FancyTitle(),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _posts.clear());
          await _loadInitialPosts();
        },
        child: Scrollbar(
          controller: _scrollController,
          thickness: 8,
          radius: const Radius.circular(4),
          thumbVisibility: true,
          interactive: true,
          child: ListView.builder(
            primary: false,
            controller: _scrollController,
            itemCount: _posts.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _posts.length) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('새로운 게시글을 불러오는 중...'),
                    ],
                  ),
                );
              }
              return PostCard(
                post: _posts[index],
                onLike: () {},
                onReply: () {},
              );
            },
          ),
        ),
      ),
    );
  }

  List<Post> _generateMorePosts({int count = 3}) {
    final lastId = _posts.length;
    final random = Random();

    // 더 자연스러운 일상 대화 스타일의 컨텐츠 목록
    final contents = [
      '아침부터 달달한 초코 쿠키 구웠어요~ 한 입 크기로 만들었더니 자꾸 집어먹게 되네요 😋',
      '오늘의 실패작ㅋㅋㅋ 마카롱 다 터졌어... 그래도 맛은 있으니까 괜찮아! 😅',
      '와... 오늘 빵이 날개 달렸나봐요! 오픈 1시간 만에 완판이라니 ㅠㅠ 감사합니다 💕',
      '크로와상 만드는데 버터가 녹아서 난리났어요 ㅋㅋㅋ 그래도 겉바속촉 성공! 🥐✨',
      '새로 배운 티라미수 레시피 연습 중~ 커피향 솔솔~ 내일 메뉴에 추가할 예정이에요 ☕️',
      '손님이 써준 후기 보고 울뻔... 이런 말씀 들으면 더 열심히 하게 되네요 🥺',
      '오늘은 딸기 생크림 케이크 만들었어요! 계절과일이라 더 맛있는듯... 🍓',
      '신메뉴 연구하다가 실수로 만든 조합인데 의외로 맛있어서 깜놀 😳 내일도 출시할까 고민중!',
      '주말 한정 메뉴로 뭐가 좋을까요? 여러분의 의견을 들려주세요! 👂',
      '오늘의 행복한 순간... 단골손님이 주신 커피 한잔 ❤️ 역시 달달한 게 최고야~',
      '새벽부터 반죽하느라 힘들었는데 손님들 반응 보니까 힘이 나요! 내일도 파이팅 💪',
      '앗... 타이머 안 맞춰놓고 잠깐 졸았더니 쿠키가 살짝 탔어요 ㅠㅠ 그래도 먹을만해!',
    ];

    final usernames = ['김파티시에', '이베이커', '박제빵', '최디저트', '정과자'];

    return List.generate(
      count,
      (index) {
        // 컨텐츠 2개를 랜덤하게 선택하고, 20% 확률로 두 개를 합침
        final mainContent = contents[random.nextInt(contents.length)];
        final useDoubleContent = random.nextDouble() < 0.2; // 20% 확률
        final finalContent = useDoubleContent
            ? '$mainContent\n\n${contents[random.nextInt(contents.length)]}'
            : mainContent;

        final randomUsername = usernames[random.nextInt(usernames.length)];
        final hasImage = random.nextBool();

        return Post(
          id: '${lastId + index + 1}',
          userId: 'user${lastId + index + 1}',
          username: randomUsername,
          userAvatar: null,
          content: finalContent,
          imageUrl: hasImage
              ? 'https://picsum.photos/400/300?random=${lastId + index}'
              : null,
          createdAt: DateTime.now().subtract(Duration(
            hours: random.nextInt(24),
            minutes: random.nextInt(60),
          )),
          likes: random.nextInt(1000) + 1,
          replies: random.nextInt(100) + 1,
        );
      },
    );
  }
}
