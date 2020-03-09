library on_off_switcher;

import 'package:flutter/material.dart';
import 'on_off_switcher_controler.dart';
import 'on_off_switcher_state.dart';
import 'on_off_switcher_painter.dart';

typedef ValueChanged = Function(OnOffSwitcherState state);

class OnOffSwitcher extends StatefulWidget {
  static const double widthDefault = 60; //Default width for switcher
  static const double heightDefault = 30; //Default height for switcher
  static const OnOffSwitcherState stateDefault =
      OnOffSwitcherState.switchOff; //Default state for switcher
  static const double heightToRadiusRatioDefault = 0.70;
  static const Color switchColorDefault = Color.fromARGB(255, 255, 255, 255);
  static const Color backgroundSwitchOnDefault =
      Color.fromARGB(255, 0, 230, 148);
  static const Color backgroundSwitchOffDefault =
      Color.fromARGB(255, 236, 86, 85);

  final double width;
  final double height;
  final double heightToRadiusRatio;
  final Color switchColor;
  final OnOffSwitcherState state;
  final Color backgroundSwitchOn;
  final Color backgroundSwitchOff;
  final ValueChanged valueChanged;

  OnOffSwitcher(
      {@required this.valueChanged,
      this.state = stateDefault,
      this.width = widthDefault,
      this.height = heightDefault,
      this.switchColor = switchColorDefault,
      this.backgroundSwitchOn = backgroundSwitchOnDefault,
      this.backgroundSwitchOff = backgroundSwitchOffDefault,
      this.heightToRadiusRatio = heightToRadiusRatioDefault}) {
    assert(_colorIsValid(switchColor));
    assert(_colorIsValid(backgroundSwitchOn));
    assert(_colorIsValid(backgroundSwitchOff));
    assert(_heightToRadiusIsValid(heightToRadiusRatio));
    assert(_sizeIsValid(width, height));
  }

  @override
  _SwitcherState createState() => _SwitcherState();

  bool _sizeIsValid(double width, double height) {
    assert(width != null, 'Width argument was null.');
    assert(height != null, 'Height argument was null.');
    assert(width > height,
        'Width argument should be greater than height argument.');
    return true;
  }

  bool _colorIsValid(Color color) {
    assert(color != null, 'Color argument was null.');
    return true;
  }

  bool _heightToRadiusIsValid(double heightToRadius) {
    assert(heightToRadius != null, 'Height to radius argument was null.');
    assert(heightToRadius > 0 && heightToRadius < 1,
        'Height to radius argument Must be in the range 0 to 1');
    return true;
  }
}

class _SwitcherState extends State<OnOffSwitcher>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  SwitcherController _slideController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _slideController = SwitcherController(
        widget.backgroundSwitchOff, widget.backgroundSwitchOn,
        vsync: this, state: widget.state)
      ..addListener(() => setState(() {}));
    _setSwitcherState();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: GestureDetector(
          onTap: () {
            _updateSwitcherState();
            widget.valueChanged(_slideController.state);
          },
          onHorizontalDragUpdate: _updateStateOnHorizontalDrag,
          child: Container(
            height: widget.height,
            width: widget.width,
            child: CustomPaint(
              painter: SwitchPainter(_slideController.progress,
                  backgroundColor: _slideController.background,
                  switcherColor: widget.switchColor,
                  heightToRadiusRatio: widget.heightToRadiusRatio),
            ),
          )),
    );
  }

  void _updateSwitcherState() {
    if (_slideController.state == OnOffSwitcherState.switchOn) {
      _slideController.setSwitchOffState();
    } else {
      _slideController.setSwitchOnState();
    }
    setState(() {});
    _slideController.prevState = _slideController.state;
  }

  void _setSwitcherState() {
    if (_slideController.state == OnOffSwitcherState.switchOff) {
      _slideController.setSwitchOffState();
    } else {
      _slideController.setSwitchOnState();
    }
    setState(() {});
  }

  void _updateStateOnHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      // swiping in right direction
      _slideController.setSwitchOnState();
    } else {
      // swiping in left direction
      _slideController.setSwitchOffState();
    }
    setState(() {});
    if (_slideController.prevState != _slideController.state) {
      widget.valueChanged(_slideController.state);
      _slideController.prevState = _slideController.state;
    }
  }
}
