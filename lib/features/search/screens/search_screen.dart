import 'package:flutter/material.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Map<String, String?>> _getFilteredResults() {
    if (_searchQuery.isEmpty) return [];
    return _dummyUsers.where((user) {
      final username = user['username']?.toLowerCase() ?? '';
      final bio = user['bio']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return username.contains(query) || bio.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredResults();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _focusNode.unfocus();
                    },
                  )
                : null,
          ),
          onTap: () => setState(() => _isSearching = true),
        ),
      ),
      body: Column(
        children: [
          if (_searchQuery.isEmpty && !_isSearching)
            const Expanded(
              child: Center(
                child: Text('검색어를 입력하세요'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredResults.length,
                itemBuilder: (context, index) {
                  final user = filteredResults[index];
                  return SearchResultCard(
                    username: user['username'] ?? '',
                    userAvatar: user['avatar'] ?? '',
                    bio: user['bio'] ?? '',
                    onTap: () {
                      // 프로필 페이지로 이동하는 로직을 추가할 수 있습니다.
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // 더미 사용자 데이터
  static final List<Map<String, String?>> _dummyUsers = [
    {
      'username': '김철수',
      'avatar': '',
      'bio': '프로그래머 | 플러터 개발자',
    },
    {
      'username': '이영희',
      'avatar': null,
      'bio': '디자이너 | UI/UX 전문가',
    },
    {
      'username': '박지민',
      'avatar': '',
      'bio': '사진작가 | 여행 블로거',
    },
  ];
}
