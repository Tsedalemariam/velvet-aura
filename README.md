# Velvet Aura

Velvet Aura is a mobile perfume shopping application built with Flutter and Dart. It provides users with an intuitive way to explore fragrances, discover different perfume variants, manage favorites, and organize their shopping carts.

## Features

- **Perfume Discovery:** Browse and explore available perfumes.
- **Fragrance Filtering:** Filter perfumes by fragrance type and gender.
- **Product Variants:** View different perfume images based on selected options.
- **Size Selection:** Choose available perfume volumes in milliliters (ml).
- **Shopping Cart:** Add perfumes to the cart, manage selected items, and view the calculated total.
- **Favorites:** Save and manage favorite perfumes for easy access.
- **Currency Selection:** Display prices in different supported currencies.
- **Multilingual Support:** Switch between supported languages.

## Technologies Used

- **Flutter** — Cross-platform mobile application development.
- **Dart** — Application programming language.
- **Provider** — State management.
- **Git and GitHub** — Version control and source code management.

## Getting Started

### Prerequisites

Before running the project, make sure you have installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- An IDE such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- An emulator or a compatible physical device

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Tsedalemariam/velvet-aura.git
   ```

2. Navigate to the project directory:

   ```bash
   cd velvet-aura
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Project Structure

```text
velvet_aura/
├── assets/       # Application assets and perfume images
├── lib/          # Dart source code
├── test/         # Automated tests
├── android/      # Android platform configuration
├── ios/          # iOS platform configuration
├── web/          # Web platform configuration
├── windows/      # Windows platform configuration
├── linux/        # Linux platform configuration
├── macos/        # macOS platform configuration
├── pubspec.yaml  # Project configuration and dependencies
├── pubspec.lock  # Locked dependency versions
└── README.md     # Project documentation
```

## Testing and Code Analysis

Run the automated tests:

```bash
flutter test
```

Check the code for potential issues:

```bash
flutter analyze
```

## Notes

- Currency conversion uses predefined exchange rates and does not currently retrieve live exchange rates.
- Payment processing is not currently implemented.

## Author

**Tsedalemariam Getu**

GitHub: [@Tsedalemariam](https://github.com/Tsedalemariam)
