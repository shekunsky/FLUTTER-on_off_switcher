# on_off_switcher

**on_off_switcher** widget for Flutter project.

![](on_off_switcher.gif)

## Getting Started

For use **on_off_switcher** widget in your project:
1. Add dependency in the **pubspec.yaml** file
```dart
    dependencies:
        flutter:
            sdk: flutter
        on_off_switcher:
            git:
                url: git@github.com:shekunsky/FLUTTER-on_off_switcher.git
```

2. Import widget in the dart file:
```dart
    import 'package:on_off_switcher/on_off_switcher.dart';
    import 'package:on_off_switcher/on_off_switcher_state.dart';
```

3. Make an instance of the widget.

    ```dart
         OnOffSwitcher(
                state: OnOffSwitcherState.switchOn,
                valueChanged: (state) {
                  if (state == OnOffSwitcherState.switchOn) {
                    print('State is ON');
                  } else {
                    print('State is OFF');
                  }
                },
              )
    ```
    
    
    ## License

    Windmill Smart Solutions 2020 ©