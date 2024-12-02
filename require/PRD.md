
### Project overview 

1. '쓰레드' 스타일의 SNS 앱 (UI만 디자인) ✅
2. 간단한 포스팅 기능만 구현 ✅
3. 블랙 위주의 심플한 디자인 ✅


### 작업 체크리스트

#### 1단계: 기본 설정 및 패키지 설치
- [x] Flutter 프로젝트 생성 완료
- [x] 필수 패키지 추가
  - [x] cupertino_icons: ^1.0.8
  - [x] image_picker: ^1.0.7
  - [x] cached_network_image: ^3.3.1
  - [x] provider: ^6.1.1
  - [x] shared_preferences: ^2.2.2
  - [x] google_fonts: ^6.1.0
  - [x] flutter_svg: ^2.0.9
  - [x] shimmer: ^3.0.0

#### 2단계: 기본 UI 구조 설정
- [x] 기본 화면 구조 생성 (홈, 검색, 포스팅, 활동, 프로필)
- [x] 하단 네비게이션 바 구현
- [x] 다크 테마 설정

#### 3단계: 홈 피드 구현
- [x] 포스트 카드 위젯 생성
- [x] 더미 데이터 생성
- [x] 무한 스크롤 구현
- [x] 로딩 효과 추가

#### 4단계: 포스팅 기능 구현
- [x] 이미지 선택/촬영 기능
- [x] 포스트 작성 UI
- [x] 임시 저장 기능

#### 5단계: 검색 기능
- [x] 검색 UI 구현
- [x] 더미 검색 결과 표시

#### 6단계: 활동 및 프로필
- [x] 활동 알림 UI
- [x] 프로필 페이지 레이아웃

#### 7단계: 디자인 마무리
- [x] 다크 테마 색상 조정
- [x] 애니메이션 효과 추가
- [x] UI 일관성 검토

먼저 1단계부터 시작하겠습니다. pubspec.yaml 파일을 수정하여 필요한 패키지들을 추가하겠습니다:


### Core functionalities

1. 사용자는 홈 피드에서 다른 사람의 게시글을 볼 수 있다. ✅
   (개발 환경에서는 더미로 다른 사용자의 게시글을 생성)
2. 홈 피드에서는 스크롤을 통해 게시글을 볼 수 있으며, ✅
   스크롤을 아래로 내리면서 새로운 게시글이 로딩된다.
3. 하단 네비게이션 바는 홈, 검색, 포스팅, 활동, 프로필 탭으로 구성된다. ✅
4. 포스팅 탭에서는 새로운 게시글을 작성할 수 있으며, ✅
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

추가된 주요 기능:
1. 프로필 페이지에 쿠키몬스터 캐릭터 프로필 구현
2. 무한 스크롤 시 랜덤 컨텐츠 생성
3. 활동 알림 페이지 구현
4. 검색 기능 구현
5. 캐시된 네트워크 이미지 처리
6. 프로필 아바타 자동 생성 기능