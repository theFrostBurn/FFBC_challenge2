import 'package:flutter/material.dart';
import '../widgets/image_picker_button.dart';
import '../../../app/theme.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _contentController = TextEditingController();
  String? _selectedImagePath;
  bool _isLoading = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateDirtyState);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _updateDirtyState() {
    final newIsDirty =
        _contentController.text.isNotEmpty || _selectedImagePath != null;
    if (_isDirty != newIsDirty) {
      setState(() => _isDirty = newIsDirty);
    }
  }

  void _onImageSelected(String path) {
    setState(() {
      _selectedImagePath = path;
      _isDirty = true;
    });
  }

  Future<void> _post() async {
    if (_contentController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // 실제 게시 로직을 구현할 수 있습니다.
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시글'),
        actions: [
          TextButton(
            onPressed: _isDirty && !_isLoading ? _post : null,
            child: Text(
              '게시',
              style: TextStyle(
                color: _isDirty && !_isLoading
                    ? AppTheme.accentColor
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: '무슨 일이 있었나요?',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              if (_selectedImagePath != null)
                Stack(
                  children: [
                    Image.asset(
                      _selectedImagePath!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _selectedImagePath = null;
                          _updateDirtyState();
                        }),
                      ),
                    ),
                  ],
                ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.greyColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    ImagePickerButton(
                      onImageSelected: _onImageSelected,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
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
