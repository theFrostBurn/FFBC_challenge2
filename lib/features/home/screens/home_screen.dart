import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/post_shimmer.dart';
import '../widgets/fancy_title.dart';

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
      _posts.addAll(_dummyPosts);
      _isLoading = false;
    });
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // 실제 API 호출 시뮬레이션
    setState(() {
      _posts.addAll(_generateMorePosts());
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const FancyTitle(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _posts.clear());
          await _loadInitialPosts();
        },
        child: _posts.isEmpty && _isLoading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => const PostShimmer(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return const PostShimmer();
                  }
                  return PostCard(
                    post: _posts[index],
                    onLike: () {},
                    onReply: () {},
                  );
                },
              ),
      ),
    );
  }

  List<Post> _generateMorePosts() {
    final lastId = _posts.length;
    return List.generate(
      2,
      (index) => Post(
        id: '${lastId + index + 1}',
        userId: 'user${lastId + index + 1}',
        username: '사용자${lastId + index + 1}',
        userAvatar: 'https://i.pravatar.cc/150?img=${lastId + index + 1}',
        content: '${lastId + index + 1}번째 게시글입니다. #새글 #무한스크롤',
        imageUrl: index % 2 == 0
            ? 'https://picsum.photos/400/300?random=$lastId'
            : null,
        createdAt: DateTime.now().subtract(Duration(minutes: lastId * 10)),
        likes: (lastId + index) * 5,
        replies: (lastId + index) * 2,
      ),
    );
  }

  // 더미 데이터
  static final List<Post> _dummyPosts = [
    Post(
      id: '1',
      userId: 'user1',
      username: '김철수',
      userAvatar: null, // 이미지 없음 - 이니셜 'ㄱ' 표시
      content: '오늘은 날씨가 정말 좋네요! 다들 즐거운 하루 보내세요 😊',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 42,
      replies: 5,
    ),
    Post(
      id: '2',
      userId: 'user2',
      username: '이영희',
      userAvatar: '', // 빈 문자열 - 이니셜 'ㅇ' 표시
      content: '새로운 프로젝트를 시작했어요! 열심히 해보겠습니다 💪',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 128,
      replies: 12,
    ),
  ];
}
