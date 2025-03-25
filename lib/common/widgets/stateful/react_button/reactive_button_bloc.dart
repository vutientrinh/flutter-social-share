import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_icon_selection.dart';
import 'package:rxdart/rxdart.dart';

class ReactiveButtonBloc {
  //
  // Stream that allows broadcasting the pointer movements
  //
  final _pointerPositionController = PublishSubject<Offset>();
  Sink<Offset> get inPointerPosition => _pointerPositionController.sink;
  Stream<Offset> get outPointerPosition => _pointerPositionController.stream;

  //
  // Stream that allows broadcasting the icons selection
  //
  final _iconSelectionController =
      PublishSubject<ReactiveIconSelectionMessage>();
  Sink<ReactiveIconSelectionMessage> get inIconSelection =>
      _iconSelectionController.sink;
  Stream<ReactiveIconSelectionMessage> get outIconSelection =>
      _iconSelectionController.stream;

  //
  // Dispose the resources
  //
  void dispose() {
    _iconSelectionController.close();
    _pointerPositionController.close();
  }
}
