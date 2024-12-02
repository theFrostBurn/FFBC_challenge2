import 'dart:math'; // Random 클래스를 위한 import 추가
import 'package:flutter/material.dart';
import '../../../shared/models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/fancy_title.dart';
import '../../../app/theme.dart'; // AppTheme import 추가
import 'create_post_screen.dart'; // 추가
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Post> _posts = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _loadSavedPosts();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '새 포스트를 작성했습니다!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        width: 240,
        behavior: SnackBarBehavior.floating,
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1),
          curve: Curves.easeOutCirc,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.only(
          bottom: kToolbarHeight + 16,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.accentColor.withOpacity(0.9),
        elevation: 8,
      ),
    );
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
      floatingActionButton: SizedBox(
        width: 48,
        height: 48,
        child: FloatingActionButton(
          onPressed: () async {
            _animationController.forward(from: 0.0);
            final BuildContext currentContext = context;

            final newPost = await Navigator.push<Post>(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostScreen(),
              ),
            );

            if (newPost != null && mounted) {
              setState(() {
                _posts.insert(0, newPost);
              });
              _showSnackBar(currentContext);
            }
          },
          backgroundColor: AppTheme.accentColor, // 원래 색상으로 복구
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.add,
            color: AppTheme.secondaryColor,
            size: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
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
                    onLike: (bool isLiked) {
                      setState(() {
                        // 좋아요 상태 변경 시 처리할 로직
                        final post = _posts[index];
                        _posts[index] = Post(
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
                    onDelete: _posts[index].userId == 'me'
                        ? () => _deletePost(_posts[index])
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Post> _generateMorePosts({int count = 3}) {
    final lastId = _posts.length;
    final random = Random();

    // 더 자연스러운 일상 대화 스타일의 컨텐츠 목록
    final contents = [
      '아침부터 달달한 초코 쿠키 구웠어요~ 한 입 크기로 만들었더니 자꾸 집먹게 되네요 😋',
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

    final usernames = ['김파티시', '이베이커', '박제빵', '최디저트', '정과자'];

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

        // 더 현실적인 랜덤 숫자 생성
        final baseLikes = random.nextInt(30); // 기본 0~30
        final viralBonus = random.nextDouble() < 0.1 // 10% 확률로 인기 게시물
            ? random.nextInt(70) // 추가 0~70
            : 0;
        final likes = baseLikes + viralBonus; // 최대 100까지
        final replies =
            (likes * (random.nextDouble() * 0.4)).round(); // 좋아요의 0~40%

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
          likes: likes,
          replies: replies,
          isLiked: false, // 초기값은 항상 false
        );
      },
    );
  }

  Future<void> _loadSavedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPosts = prefs.getStringList('my_posts') ?? [];

      if (savedPosts.isNotEmpty) {
        setState(() {
          _posts.insertAll(
            0,
            savedPosts.map((json) => Post.fromJson(jsonDecode(json))).toList(),
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading saved posts: $e');
    }
  }

  Future<void> _deletePost(Post post) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final posts = prefs.getStringList('my_posts') ?? [];

      // 저장된 포스트에서 해당 게시물 찾아서 삭제
      final updatedPosts = posts.where((json) {
        final p = Post.fromJson(jsonDecode(json));
        return p.id != post.id;
      }).toList();

      await prefs.setStringList('my_posts', updatedPosts);

      // UI 업데이트
      setState(() {
        _posts.removeWhere((p) => p.id == post.id);
      });
    } catch (e) {
      debugPrint('Error deleting post: $e');
    }
  }
}
