# SociAI

Flutter prototype for the SociAI mobile designs. The app includes sign in and
sign up, brand setup, a home dashboard, a monthly/weekly content calendar, an
AI creation flow, post editing and details, comment classification, insights,
and settings.

## Run

```bash
flutter pub get
flutter run
```

Run the widget tests and static analysis with:

```bash
flutter test
flutter analyze
```

## Project structure

- `lib/core/` — app theme, content models, and in-memory demo state.
- `lib/features/` — authentication, onboarding, dashboard, scheduling,
  creation, comments, insights, settings, and post details.
- `lib/shared/widgets/` — reusable buttons, cards, form controls, status
  indicators, navigation, and generated artwork.

## Demo behavior

Content and preferences are stored in memory and reset when the app restarts.
The artwork is a local visual preview; AI generation, authentication, social
account linking, uploads, comment replies, analytics, and publishing are not
connected to external services.
