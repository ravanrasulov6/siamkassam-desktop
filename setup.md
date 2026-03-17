# Siam Kassam Flutter Setup

This project is a high-fidelity Flutter migration of the Siam Kassam React application.

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (latest stable)
- Supabase account and project

### 2. Environment Configuration
Update the following files with your credentials:
- `lib/core/api/supabase_provider.dart`

### 3. Dependency Setup
Run the following commands:
```powershell
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🛡️ Architecture Principles

### Clean Architecture
- **Entities**: Business objects found in `lib/features/*/domain/entities`.
- **UseCases**: Business logic found in `lib/features/*/domain/use_cases`.
- **Repositories**: Interfaces in `domain` and implementations in `data`.

### Offline-First Logic (Isar)
All data-fetching repositories follow this pattern:
1. Return local data from Isar immediately.
2. Trigger background sync from Supabase if online.
3. Update local data and notify UI.

### UI / UX
The project uses a custom **Glassmorphism** system found in `lib/shared/widgets`. Always use these components to maintain the premium look.
