import 'dart:math';
import 'package:flutter/material.dart';
import 'src/nav_custom_clipper.dart';
import 'src/nav_button.dart';
import 'src/nav_custom_painter.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBar extends StatefulWidget {
  final List<Widget> items;
  final List<String> labels; // Add labels for the navigation bar
  final int index;
  final Color color;
  final Color? buttonBackgroundColor;
  final Color backgroundColor;
  final Color labelColor; // Label text color customization
  final ValueChanged<int>? onTap;
  final _LetIndexPage letIndexChange;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;
  final double? maxWidth;

  CurvedNavigationBar({
    Key? key,
    required this.items,
    required this.labels, // Add labels in the constructor
    this.index = 0,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    this.labelColor = Colors.black, // Customize label color
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
    this.maxWidth,
  })  : assert(items.length == labels.length, 'Items and labels must have equal length'),
        letIndexChange = letIndexChange ?? ((_) => true),
        assert(items.isNotEmpty),
        assert(0 <= index && index < items.length),
        super(key: key);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  late int _endingIndex;
  late double _pos;
  double _buttonHide = 0;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _icon = widget.items[widget.index];
    _length = widget.items.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _endingIndex = widget.index;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = widget.items[_endingIndex];
        }
        _buttonHide = (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
    if (!_animationController.isAnimating) {
      _icon = widget.items[_endingIndex];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SizedBox(
      height: widget.height , // Extra space for the label
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = min(constraints.maxWidth, widget.maxWidth ?? constraints.maxWidth);
          return Align(
            alignment: textDirection == TextDirection.ltr ? Alignment.bottomLeft : Alignment.bottomRight,
            child: Container(
              color: widget.backgroundColor,
              width: maxWidth,
              child: ClipRect(
                clipper: NavCustomClipper(deviceHeight: MediaQuery.sizeOf(context).height),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    // Curve and button setup
                    Positioned(
                      bottom:  0 - (85.0 - widget.height), // Remove space above curve
                      left: textDirection == TextDirection.rtl ? null : _pos * maxWidth,
                      right: textDirection == TextDirection.rtl ? _pos * maxWidth : null,
                      width: maxWidth / _length,
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(0, -(1 - _buttonHide) * 45),
                          child: Material(
                            color: widget.buttonBackgroundColor ?? widget.color,
                            type: MaterialType.circle,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _icon,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Custom Painter for curve
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0 - (85.0 - widget.height),
                      child: CustomPaint(
                        painter: NavCustomPainter(_pos, _length, widget.color, textDirection),
                        child: Container(
                          height: 85.0,
                        ),
                      ),
                    ),
                    // Items (Icons) and Labels under the curve
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0, // Adjust label position so it doesn't float above
                      child: SizedBox(
                        height: 95.0,
                        child: Column(
                          children: [
                            // Row for icons
                            Row(
                              children: widget.items.map((item) {
                                return Expanded(
                                  child: NavButton(

                                    onTap: _buttonTap,
                                    position: _pos,
                                    length: _length,
                                    index: widget.items.indexOf(item),
                                    child: Center(child: item),
                                  ),
                                );
                              }).toList(),
                            ),
                            // Row for labels with opacity animation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: widget.labels.map((label) {
                                int index = widget.labels.indexOf(label);
                                return Expanded(
                                  child: Center(
                                    child: AnimatedOpacity(
                                      opacity: index == _endingIndex ? 1.0 : 0.0, // Full opacity for the selected item, hidden otherwise
                                      duration: widget.animationDuration,
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          color: widget.labelColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index) || _animationController.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }
}
