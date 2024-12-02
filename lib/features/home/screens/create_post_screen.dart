import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../shared/models/post.dart';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  final Random _random = Random();
  String? _previewImageUrl;

  @override
  void initState() {
    super.initState();
    _generatePreviewImage();
  }

  void _generatePreviewImage() {
    setState(() {
      _previewImageUrl =
          'https://picsum.photos/400/300?random=${_random.nextInt(1000)}';
    });
  }

  Future<void> _createPost() async {
    if (_contentController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // 새 포스트 생성
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'me',
      username: 'Cookie Monster',
      userAvatar: 'assets/images/cookie_monster.png',
      content: _contentController.text,
      imageUrl: _previewImageUrl,
      createdAt: DateTime.now(),
      likes: 0,
      replies: 0,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final posts = prefs.getStringList('my_posts') ?? [];
      posts.insert(0, jsonEncode(newPost.toJson()));
      await prefs.setStringList('my_posts', posts);

      if (mounted) {
        Navigator.pop(context, newPost);
      }
    } catch (e) {
      debugPrint('Error saving post: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시글'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentColor,
                  AppTheme.accentColor.withBlue(255),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                onPressed: _contentController.text.isNotEmpty && !_isLoading
                    ? () async {
                        // 게시 버튼 클릭 시 애니메이션
                        final overlay = Overlay.of(context);
                        final renderBox =
                            context.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);

                        final entry = OverlayEntry(
                          builder: (context) => TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeInOutCubic,
                            builder: (context, value, child) {
                              return Positioned(
                                left: position.dx +
                                    (MediaQuery.of(context).size.width -
                                            position.dx) *
                                        value,
                                top: position.dy +
                                    (MediaQuery.of(context).size.height * 0.3 -
                                            position.dy) *
                                        (1 - value),
                                child: Transform.scale(
                                  scale: 1.0 + value * 2,
                                  child: Opacity(
                                    opacity: 1 - value * 0.7,
                                    child: const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                        overlay.insert(entry);
                        await Future.delayed(
                            const Duration(milliseconds: 1000));
                        await _createPost();
                        entry.remove();
                      }
                    : null,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.send_rounded,
                    key: ValueKey(_contentController.text.isNotEmpty),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '무슨 생각을 하고 계신가요?',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              ),
              if (_previewImageUrl != null) ...[
                const SizedBox(height: 16),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: _previewImageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generatePreviewImage,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
