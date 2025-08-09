import 'package:flutter/cupertino.dart';

class SizeConfig {
  // Screen dimensions in logical pixels
  static double _screenWidth=0;
  static double _screenHeight=0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  // Multipliers for responsive sizing in UI
  static double textMultiplier=0;
  static double imageSizeMultiplier=0;
  static double heightMultiplier=0;
  static double widthMultiplier=0;
  // Orientation flags
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  // Initialize sizing values based on layout constraints and orientation
  void initFromConstraints(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 480) {
        isMobilePortrait = true;
      }
    } else {
      // In landscape, width and height swap roles
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    // Calculate 1% of screen width and height for flexible sizing
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    // Assign multipliers for use throughout UI for responsive scaling
    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }
}