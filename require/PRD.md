
### Project overview 

1. '쓰레드' 스타일의 SNS 앱 (UI만 디자인)
2. 간단한 포스팅 기능만 구현
3. 블랙 위주의 심플한 디자인


### Core functionalities

1. 사용자는 홈 피드에서 다른 사람의 게시글을 볼 수 있다. 
   (개발 환경에서는 더미로 다른 사용자의 게시글을 생성)
2. 홈 피드에서는 스크롤을 통해 게시글을 볼 수 있으며, 
   스크롤을 아래로 내리면서 새로운 게시글이 로딩된다.
3. 하단 네비게이션 바는 홈, 검색, 포스팅, 활동, 프로필 탭으로 구성된다.
4. 포스팅 탭에서는 새로운 게시글을 작성할 수 있으며, 
   이미지 촬영 및 업로드 기능이 포함되어 있다.


### Doc

1. Frontend Framework:
   - Flutter SDK
   - Dart 언어

2. 필수 패키지:
   - cupertino_icons: ^1.0.8 (iOS 스타일 아이콘)
   - image_picker: ^1.0.7 (이미지 선택/촬영)
   - cached_network_image: ^3.3.1 (이미지 캐싱)
   - provider: ^6.1.1 (상태 관리)
   - shared_preferences: ^2.2.2 (로컬 데이터 저장)


3. UI/UX 관련:
   - google_fonts: ^6.1.0 (구글 폰트)
   - flutter_svg: ^2.0.9 (SVG 아이콘)
   - shimmer: ^3.0.0 (로딩 효과)

4. 참고 문서:
   - Flutter 공식 문서: https://docs.flutter.dev
   - Material Design 가이드: https://m3.material.io
   - Flutter 위젯 카탈로그: https://docs.flutter.dev/ui/widgets


### Current file structure (현재 파일 구조)

lib/
├── main.dart
├── app/
│ ├── app.dart
│ └── theme.dart
├── features/
│ ├── home/
│ │ ├── screens/
│ │ │ └── home_screen.dart
│ │ └── widgets/
│ │ ├── post_card.dart
│ │ └── story_circle.dart
│ ├── search/
│ │ └── screens/
│ │ └── search_screen.dart
│ ├── post/
│ │ ├── screens/
│ │ │ └── post_screen.dart
│ │ └── widgets/
│ │ └── image_picker.dart
│ ├── activity/
│ │ └── screens/
│ │ └── activity_screen.dart
│ └── profile/
│ └── screens/
│ └── profile_screen.dart
├── shared/
│ ├── models/
│ │ ├── post.dart
│ │ └── user.dart
│ ├── providers/
│ │ └── app_state.dart
│ └── widgets/
│ ├── bottom_nav.dart
│ └── custom_button.dart
└── utils/
├── constants.dart
└── helpers.dart