import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_button_bloc.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_icon_definition.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_icon_selection.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/widget_position.dart';

class ReactiveIcon extends StatefulWidget {
  ReactiveIcon({
    Key? key,
    required this.iconWidth,
    required this.icon,
    required this.bloc,
    required this.growRatio,
    required this.roundIcon,
    required this.onTap,
  }) : super(key: key);

  /// Width of each individual icons
  final double iconWidth;

  /// The icon definition
  final ReactiveIconDefinition icon;

  /// The BLoC to handle events
  final ReactiveButtonBloc bloc;

  /// The ratio to be used to highlight an icon when hovered
  final double growRatio;

  /// Is the icon round
  final bool roundIcon;

  final Function onTap;

  @override
  _ReactiveIconState createState() => _ReactiveIconState();
}

class _ReactiveIconState extends State<ReactiveIcon>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription _streamSubscription;
  late final AnimationController _animationController;

  // Flag to know whether this icon is currently hovered
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Reset
    _isHovered = false;

    // Initialize the animation to highlight the hovered icon
    _animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    // Start listening to pointer position changes
    _streamSubscription =
        widget.bloc.outPointerPosition.listen(_onPointerPositionChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      widget.icon.assetIcon,
      width: widget.iconWidth,
      height: widget.iconWidth,
    );
    if (widget.roundIcon) {
      icon = CircleAvatar(
        radius: widget.iconWidth / 2,
        backgroundColor: Colors.black12,
        child: icon,
      );
    }

    return Transform.scale(
      scale: 1.0 + _animationController.value * widget.growRatio,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: icon,
      ),
    );
  }

  //
  // The pointer position has changed
  // We need to check whether it hovers this icon
  // If yes, we need to highlight this icon (if not yet done)
  // If no, we need to remove any highlight
  // Also, we need to notify whomever interested in knowning
  // which icon is highlighted or lost its highlight
  //
  void _onPointerPositionChanged(Offset position) {
    final widgetPosition = WidgetPosition.fromContext(context);
    final isHit = widgetPosition.rect!.contains(position);
    if (isHit) {
      if (!_isHovered) {
        _isHovered = true;
        _animationController.forward();
        _sendNotification();
      }
    } else {
      if (_isHovered) {
        _isHovered = false;
        _animationController.reverse();
        _sendNotification();
      }
    }
  }

  void onTap() {
    _isHovered = true;
    _sendNotification();
    Future.delayed(const Duration(milliseconds: 100), widget.onTap());
  }

  //
  // Send a notification to whomever is interesting
  // in knowning the current status of this icon
  //
  void _sendNotification() {
    widget.bloc.inIconSelection.add(ReactiveIconSelectionMessage(
      icon: widget.icon,
      isSelected: _isHovered,
    ));
  }
}
