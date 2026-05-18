# CLAUDE.md

## Project Overview

This repository contains a small Flutter app for choosing a date idea with a head-to-head "King of the Hill" flow.

- App name: `Our Perfect Date`
- Package name: `kill_of_hill_date`
- Primary target: Flutter Web
- Current Firebase project: `date-with-xinyi`
- Current Firebase account for this repo: `firebasedoubleo7@gmail.com`

The app loads date ideas from JSON at runtime and walks the user through:

1. Intro screen
2. Comparison screen
3. Result screen

## Important Files

- [lib/main.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/main.dart:1): app entry point, theming, screen state, idea loading
- [lib/screens/intro_screen.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/screens/intro_screen.dart:1): landing experience
- [lib/screens/comparison_screen.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/screens/comparison_screen.dart:1): comparison flow
- [lib/screens/result_screen.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/screens/result_screen.dart:1): final winner display
- [lib/widgets/date_card.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/widgets/date_card.dart:1): reusable date card UI
- [lib/models/date_idea.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/models/date_idea.dart:1): data model
- [lib/data/date_ideas.dart](/C:/Users/pohbo/Flutter/king_of_hill_date/lib/data/date_ideas.dart:1): runtime JSON loader
- [assets/data/date_ideas.json](/C:/Users/pohbo/Flutter/king_of_hill_date/assets/data/date_ideas.json:1): editable date-idea content
- [pubspec.yaml](/C:/Users/pohbo/Flutter/king_of_hill_date/pubspec.yaml:1): dependencies and asset registration
- [.firebaserc](/C:/Users/pohbo/Flutter/king_of_hill_date/.firebaserc:1): Firebase project aliases

## Development Commands

Run these from the repo root.

```bash
flutter pub get
flutter run -d chrome
flutter test
flutter build web
firebase deploy
```

If a web build has already been created, output lives in `build/web/`.

## Content Workflow

Date ideas are stored in `assets/data/date_ideas.json`. Each item must include:

- `id`
- `name`
- `description`
- `time`
- `imagePath`

Keep IDs unique and string-typed. If you add or rename images, make sure the referenced file exists under `assets/images/`.

## UI Notes

- The app uses Material 3 theming.
- The visual direction is soft, romantic, and mobile-first.
- `shuffleIdeas` in `lib/main.dart` controls whether ideas appear in fixed or randomized order.
- The app currently prefers preserving existing local image assets rather than requiring new ones for every content change.

## Guardrails

- Prefer small, focused changes.
- Keep the JSON schema backward-compatible unless the UI/model is being updated in the same change.
- If changing the app copy or content, preserve the warm tone.
- If changing screen flow, make sure intro, comparison, and result states still transition cleanly.
- Run at least `flutter test` after code changes when feasible.

## Firebase Notes

- `.firebaserc` currently maps `default` and `prod` to `date-with-xinyi`.
- Before deploying, verify the active account with `firebase login:list`.
- If hosting behavior changes, also check `firebase.json`.
