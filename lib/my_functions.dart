import 'package:assignment_task_asymetrii/my_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MyFunctions {
  static RxInt totalBars = 0.obs; // Total number of loading widgets
  static RxInt barsPerLine = 0.obs; // Number of widgets per line
  static RxBool reverseAnimation = false.obs; // Reverse animation toggle
  static RxDouble animationSpeed = 1.0.obs; // Animation speed
  static RxString selectedColor = 'Blue'.obs; // Selected loading bar color
  static RxString errorMessage = "".obs; // Error message state
  static const String imageUrl = MyData.imageUrl;

  // List of color options
  static List<String> colorOptions = ['Blue', 'Red', 'Green', 'Purple'];

  // Show an error message and hide it after 3 seconds
  static void showError(String message) {
    errorMessage.value = message;
    Future.delayed(const Duration(seconds: 3), () {
      errorMessage.value = "";
    });
  }

  // Get the selected color for loading bar
  static Color getSelectedColor() {
    switch (selectedColor.value) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Purple':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}