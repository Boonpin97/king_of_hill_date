# Our Perfect Date 💕

A romantic Flutter Web app for choosing your perfect date idea together! Uses a fun "King of the Hill" style comparison where date ideas compete head-to-head until one winner remains.

## Features

- **Intro Screen** - Beautiful welcome with a romantic feel
- **Comparison Screen** - Two cards compete, pick your favorite
- **Result Screen** - Celebrate the winning date idea
- **Responsive Design** - Works great on mobile and desktop
- **Smooth Animations** - Polished transitions between rounds
- **Material 3** - Modern, elegant design language
- **Dark Mode Support** - Follows system theme

## How the Comparison Works

The app uses a simple "King of the Hill" algorithm:

1. First date idea starts as the "champion"
2. Second idea becomes the "challenger"
3. You tap your preferred card
4. The winner becomes the new champion
5. Next challenger appears from the remaining ideas
6. This continues until all 8 ideas have competed
7. The final champion is your perfect date!

After 7 rounds of comparison, you'll have your winner.

## Project Structure

```
lib/
├── main.dart                    # App entry point & navigation
├── models/
│   └── date_idea.dart           # DateIdea model class
├── data/
│   └── date_ideas.dart          # Sample date ideas data
├── widgets/
│   └── date_card.dart           # Reusable date card widget
└── screens/
    ├── intro_screen.dart        # Welcome screen
    ├── comparison_screen.dart   # Main comparison logic
    └── result_screen.dart       # Winner display

assets/
├── images/                      # Your date idea images
│   └── README.md                # Image guidelines
└── data/
    └── date_ideas.json          # JSON version of data (reference)
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.9.2 or later)
- A web browser (Chrome recommended for development)

### Installation

1. **Clone or navigate to the project:**
   ```bash
   cd kill_of_hill_date
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Add your images:**
   Place your images in `assets/images/` with these filenames:
   - `picnic.jpg`
   - `stargazing.jpg`
   - `cooking.jpg`
   - `museum.jpg`
   - `beach.jpg`
   - `movie.jpg`
   - `coffee.jpg`
   - `garden.jpg`

   Don't have images yet? The app will show placeholders until you add them.

## Run Instructions

### Development (with hot reload)

```bash
flutter run -d chrome
```

Or for a specific port:
```bash
flutter run -d chrome --web-port=8080
```

### Run on Edge or other browsers

```bash
flutter run -d edge
```

## Web Build Instructions

### Build for production

```bash
flutter build web
```

The build output will be in `build/web/`.

### Build with specific renderer (recommended for best quality)

```bash
flutter build web --web-renderer canvaskit
```

### Deploy

Simply copy the contents of `build/web/` to any static hosting service:

- **GitHub Pages** - Push to `gh-pages` branch
- **Netlify** - Drag and drop the folder
- **Vercel** - Connect your repo
- **Firebase Hosting** - Use `firebase deploy`
- **Any web server** - Just serve the static files

### Quick local preview of build

```bash
cd build/web
python -m http.server 8000
```
Then open http://localhost:8000

## Customization

### Change Date Ideas

Edit `lib/data/date_ideas.dart` to customize the date options:

```dart
const DateIdea(
  id: '1',
  name: 'Your Idea Name',
  description: 'A lovely description of the date.',
  time: 'Evening, ~2 hours',
  imagePath: 'assets/images/your-image.jpg',
),
```

### Change the Color Theme

Edit `lib/main.dart` and modify the `seedColor`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFE57373), // Change this color
  brightness: Brightness.light,
),
```

Some romantic color suggestions:
- `0xFFE57373` - Soft rose (default)
- `0xFFCE93D8` - Lavender
- `0xFFFFAB91` - Peach
- `0xFF90CAF9` - Soft blue
- `0xFFA5D6A7` - Sage green

### Change Messages

- **Intro title/subtitle** - Edit `lib/screens/intro_screen.dart`
- **Result message** - Edit `lib/screens/result_screen.dart`

## Technical Notes

- Uses a simple `StatefulWidget` for state management
- No external packages required beyond Flutter SDK
- Images use error boundaries with placeholder fallbacks
- Responsive layout switches at 700px width
- Animations use Flutter's built-in animation system

## License

Made with 💕 for your special someone!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
