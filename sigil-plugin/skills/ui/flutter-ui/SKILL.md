---
name: flutter-ui
description: Implements Flutter widgets from design specifications. Supports Flutter 3+, Material 3, and Cupertino design.
version: 1.0.0
category: ui
chainable: true
invokes: []
invoked_by: [developer]
tools: [Read, Write, Edit, Bash, Glob]
inputs: [component_spec, design_tokens, accessibility_requirements]
outputs: [widget_files, test_files]
---

# Skill: Flutter UI

## Purpose

Implement Flutter widgets from design specifications. This skill generates production-ready Dart code with proper widget composition.

## When to Invoke

- Developer receives task to implement UI widget
- Constitution specifies Flutter as UI framework
- pubspec.yaml indicates Flutter project

## Inputs

**Standard Contract:**
- `component_spec`: object
- `design_tokens`: object
- `accessibility_requirements`: object

**Optional:**
- `design_system`: string — "material" (default) | "cupertino" | "custom"
- `state_management`: string — "provider" | "riverpod" | "bloc" | "none"

## Process

### Step 1: Detect Project Setup

```bash
# Check Flutter version
flutter --version

# Check for state management
grep -E "provider|riverpod|bloc" pubspec.yaml

# Check existing widget patterns
ls lib/widgets/*.dart lib/components/*.dart
```

### Step 2: Generate Widget

```dart
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final Widget child;
  final bool disabled;

  const CustomButton({
    super.key,
    required this.variant,
    this.size = ButtonSize.medium,
    this.onPressed,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !disabled,
      child: Material(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Padding(
            padding: _padding,
            child: DefaultTextStyle(
              style: _textStyle,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (variant) {
      case ButtonVariant.primary:
        return const Color(0xFF3B82F6);
      case ButtonVariant.secondary:
        return const Color(0xFFF3F4F6);
    }
  }

  double get _borderRadius => 8.0;

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    }
  }

  TextStyle get _textStyle {
    final color = variant == ButtonVariant.primary
        ? Colors.white
        : const Color(0xFF111827);
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: size == ButtonSize.small ? 14 : 16,
    );
  }
}
```

### Step 3: Implement Accessibility

Flutter accessibility:

```dart
Semantics(
  label: 'Submit button',
  hint: 'Double tap to submit form',
  button: true,
  enabled: !disabled,
  child: // widget
)
```

### Step 4: Generate Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/widgets/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('renders with primary variant', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              variant: ButtonVariant.primary,
              child: const Text('Click me'),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('handles tap events', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              variant: ButtonVariant.primary,
              child: const Text('Click'),
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not respond when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              variant: ButtonVariant.primary,
              disabled: true,
              child: const Text('Click'),
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(tapped, isFalse);
    });

    testWidgets('has correct semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              variant: ButtonVariant.primary,
              child: const Text('Submit'),
              onPressed: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CustomButton));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });
  });
}
```

## Output Format

### File Structure
```
lib/widgets/custom_button/
├── custom_button.dart
└── custom_button_test.dart (in test/widgets/)
```

Or flat structure:
```
lib/widgets/
├── custom_button.dart
test/widgets/
├── custom_button_test.dart
```

## Handoff Data

```json
{
  "files_created": [
    "lib/widgets/custom_button.dart",
    "test/widgets/custom_button_test.dart"
  ],
  "design_system": "material",
  "state_management": "none",
  "accessibility_implemented": true
}
```

## Flutter Patterns

### Widget Composition
- Prefer composition over inheritance
- StatelessWidget when no local state
- StatefulWidget only when needed
- const constructors for performance

### Theming
- Use Theme.of(context) for consistency
- Define in ThemeData
- Support dark mode via ThemeMode
- Material 3 design tokens

### State Management
- Provider for simple state
- Riverpod for complex apps
- BLoC for enterprise patterns
- setState for widget-local state

### Performance
- const constructors everywhere possible
- Minimize rebuilds with selective state
- Use RepaintBoundary wisely
- ListView.builder for long lists

### Platform Adaptation
- Platform.isIOS / Platform.isAndroid
- Cupertino widgets for iOS feel
- Adaptive widgets when available

## Human Checkpoint

**Tier:** Auto

## Error Handling

| Error | Resolution |
|-------|------------|
| Missing dependency | Add to pubspec.yaml, run flutter pub get |
| State management not installed | Suggest installation or use setState |
| Theme not configured | Create basic ThemeData |
| Test setup incomplete | Add flutter_test dependency |
