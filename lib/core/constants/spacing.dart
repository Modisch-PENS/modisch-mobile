import 'package:flutter/material.dart';

Map<double, SizedBox> _verticalSpaces = {};
Map<double, SizedBox> _horizontalSpaces = {};

/// Returns a cached [SizedBox] with the specified [height].
///
/// This method optimizes the creation of vertical spacing widgets by
/// caching instances of [SizedBox] for reuse, reducing widget rebuilds.
///
/// - [height]: The height of the vertical space.
SizedBox verticalSpace(double height) {
  if (!_verticalSpaces.containsKey(height)) {
    _verticalSpaces[height] = SizedBox(height: height);
  }

  return _verticalSpaces[height]!;
}

/// Returns a cached [SizedBox] with the specified [width].
///
/// This method optimizes the creation of horizontal spacing widgets by
/// caching instances of [SizedBox] for reuse, reducing widget rebuilds.
///
/// - [width]: The width of the horizontal space.
SizedBox horizontalSpace(double width) {
  if (!_horizontalSpaces.containsKey(width)) {
    _horizontalSpaces[width] = SizedBox(width: width);
  }

  return _horizontalSpaces[width]!;
}
