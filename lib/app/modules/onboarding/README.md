# Onboarding Module

This module contains the onboarding screens and flows for new users.

## Structure
```
onboarding/
├── ui/              # UI screens for onboarding flow
├── controller/      # Controllers for onboarding screens
└── bindings/        # Bindings for dependency injection
```

## Usage
Add onboarding screens here following the same pattern as auth screens:
- Numbered file naming (e.g., `1_welcome.dart`, `2_setup.dart`)
- One controller per screen (e.g., `1_welcome_controller.dart`)
- One binding per screen (e.g., `1_welcome_binding.dart`)
- Register routes in `app_routes.dart` and `app_pages.dart`
