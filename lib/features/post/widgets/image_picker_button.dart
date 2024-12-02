import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(String) onImageSelected;
  final bool isLoading;

  const ImagePickerButton({
    super.key,
    required this.onImageSelected,
    this.isLoading = false,
  });

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        onImageSelected(pickedFile.path);
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ImageSource>(
      enabled: !isLoading,
      icon: Icon(
        Icons.add_photo_alternate,
        color: isLoading ? Colors.grey : AppTheme.secondaryColor,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ImageSource.gallery,
          child: Row(
            children: [
              Icon(Icons.photo_library),
              SizedBox(width: 8),
              Text('갤러리에서 선택'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ImageSource.camera,
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('카메라로 촬영'),
            ],
          ),
        ),
      ],
      onSelected: _pickImage,
    );
  }
}
