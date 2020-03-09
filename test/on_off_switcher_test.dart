import 'package:flutter_test/flutter_test.dart';
import 'package:on_off_switcher/on_off_switcher.dart';
import 'package:on_off_switcher/on_off_switcher_state.dart';

void main() {
  testWidgets('Widget changed his state on tap and callback is executed',
      (WidgetTester tester) async {
    int _callbackCounter = 0;
    OnOffSwitcherState _currentState = OnOffSwitcherState.switchOn;

    // Create the widget by telling the tester to build it.
    OnOffSwitcher _switcher = OnOffSwitcher(
      state: _currentState,
      valueChanged: (state) {
        _currentState = state;
        _callbackCounter++;
      },
    );

    // Build the widget.
    await tester.pumpWidget(_switcher);

    // Tap the switcher while current state is 'ON'.
    await tester.tap(find.byType(OnOffSwitcher));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expect to state changed to 'OFF' and callback executed
    expect(_currentState, OnOffSwitcherState.switchOff);
    expect(_callbackCounter, 1);

    // Tap the switcher while current state is 'OFF'.
    await tester.tap(find.byType(OnOffSwitcher));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expect to state changed to 'ON' and callback executed
    expect(_currentState, OnOffSwitcherState.switchOn);
    expect(_callbackCounter, 2);
  });
}
