import 'package:flutter/material.dart';

class Expandable extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Curve outCurve;
  final bool expanded;
  final Widget child;
  final Axis axis;
  final Alignment alignment;

  const Expandable(
      {Key key,
      @required this.expanded,
      @required this.child,
      this.axis = Axis.vertical,
      this.duration = const Duration(milliseconds: 300),
      this.curve = Curves.easeIn,
      this.outCurve,
      this.alignment = Alignment.center})
      : assert(expanded != null),
        assert(curve != null),
        assert(duration != null),
        assert(axis != null),
        assert(alignment != null),
        super(key: key);

  @override
  _ExpandableState createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Animation _reverseAnimation;

  void _init({bool expanded}) {
    _animation?.removeListener(() => setState(() => null));
    _reverseAnimation?.removeListener(() => setState(() => null));

    if (_controller == null)
      _controller = AnimationController(duration: widget.duration, vsync: this);
    else
      _controller.duration = widget.duration;

    _animation = CurveTween(curve: widget.curve).animate(_controller)
      ..addListener(() => setState(() => null));
    _reverseAnimation = CurveTween(curve: widget.outCurve ?? widget.curve)
        .animate(_controller)
          ..addListener(() => setState(() => null));

    if (expanded == true) _controller.value = 1;
  }

  @override
  void initState() {
    _init(expanded: widget.expanded);

    super.initState();
  }

  @override
  void didUpdateWidget(Expandable oldWidget) {
    _init();
  }

  @override
  Widget build(BuildContext context) {
    widget.expanded ? _controller.forward() : _controller.reverse();

    return ClipRect(
      child: Align(
        alignment: widget.alignment,
        widthFactor: widget.axis == Axis.horizontal
            ? (widget.expanded ? _animation.value : _reverseAnimation.value)
            : null,
        heightFactor: widget.axis == Axis.vertical
            ? (widget.expanded ? _animation.value : _reverseAnimation.value)
            : null,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }
}
