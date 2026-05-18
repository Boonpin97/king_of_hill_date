# AGENTS.md

## Mission

Work inside this repo as a careful, low-drag coding agent. Optimize for keeping the Flutter app stable while making content and UX changes quickly.

## Repo Summary

- Framework: Flutter
- Main target: Web
- Data source for ideas: `assets/data/date_ideas.json`
- Navigation model: single-state app with intro, comparison, and result screens
- Hosting/deploy target: Firebase project `date-with-xinyi`

## What To Check First

Before making changes, read:

1. `README.md`
2. `lib/main.dart`
3. The specific screen, widget, or data file being changed

If the task is content-only, start with `assets/data/date_ideas.json` and confirm the existing schema in `lib/models/date_idea.dart`.

## Safe Change Patterns

- For content updates, prefer editing `assets/data/date_ideas.json` only.
- For visual tweaks, keep the current romantic design language unless explicitly asked to redesign.
- For logic changes, preserve the three-screen flow and the comparison algorithm unless the task requires otherwise.
- Reuse existing assets when possible to avoid broken image references.

## Commands

Common local commands:

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build web
firebase login:list
firebase deploy
```

## Data Contract

Every date idea must include:

```json
{
  "id": "1",
  "name": "Idea name",
  "description": "Short description",
  "time": "~2 hours",
  "imagePath": "assets/images/example.jpg"
}
```

Rules:

- `id` should remain a string
- `imagePath` should point to an existing bundled asset
- Descriptions should feel natural in a dating app, not like raw event listings

## Verification Expectations

After code edits:

- Run `flutter test` when feasible
- Run `flutter analyze` for logic or widget changes when feasible

After content-only edits:

- Validate JSON syntax
- Check that referenced image files exist

If you cannot run verification, say so clearly.

## Firebase Expectations

- Active repo aliases in `.firebaserc` should target `date-with-xinyi`
- Expected Firebase account for this repo: `firebasedoubleo7@gmail.com`
- Do not change Firebase project mappings casually

## Editing Style

- Keep changes minimal and local
- Avoid unnecessary dependency additions
- Preserve current naming unless a rename is part of the task
- Prefer updating documentation when workflows or project targets change
