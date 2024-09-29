import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_functions.dart';void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      );
    });
  }
}

// Main Screen with Dynamic Loading Bars, Reverse Toggle, Speed Slider, and Color Dropdown
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Image.network(MyFunctions.imageUrl,fit: BoxFit.contain,),
              SizedBox(height:10),
              ErrorDisplay(), // Displays error at the top if input exceeds limits
              SizedBox(height:10),
              ColorDropdown(),
              SizedBox(height: 10),
              SpeedSlider(), // Slider for controlling speed
              SizedBox(height: 10),
              LoadingBarControl(),
              ReverseToggle(), // Toggle for reverse direction
              SizedBox(height: 20),
              DynamicLoadingDisplay(), // Dynamic loading bars
            ],
          ),
        ),
      ),
    );
  }
}

// Text Fields for controlling the number of loading bars and bars per line
class LoadingBarControl extends StatelessWidget {
  const LoadingBarControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Column(
        children: [
          // Text Field for total number of loading bars (in-box style)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color:MyFunctions.getSelectedColor() ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Total number of loading bars",
                labelStyle: TextStyle(color: MyFunctions.getSelectedColor()),
                errorText:
                MyFunctions.totalBars.value > 30 ? 'Cannot exceed 30' : null,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                int intValue = int.tryParse(value) ?? 0;
                if (intValue <= 30) {
                  MyFunctions.totalBars.value = intValue;
                } else {
                  MyFunctions.showError(
                      "Total number of loading bars cannot exceed 30");
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          // Text Field for number of bars per line (in-box style)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyFunctions.getSelectedColor()),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Number of bars per line",
                labelStyle: TextStyle(color: MyFunctions.getSelectedColor()),
                errorText:
                MyFunctions.barsPerLine.value > 15 ? 'Cannot exceed 15' : null,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                int intValue = int.tryParse(value) ?? 0;
                if (intValue <= 15) {
                  MyFunctions.barsPerLine.value = intValue;
                } else {
                  MyFunctions.showError(
                      "Number of bars per line cannot exceed 15");
                }
              },
            ),
          ),
        ],
      );
    });
  }
}

// Toggle switch to reverse the animation direction
class ReverseToggle extends StatelessWidget {
  const ReverseToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SwitchListTile(
        activeColor: MyFunctions.getSelectedColor(),
        inactiveThumbColor: MyFunctions.getSelectedColor(),
        title: const Text("Reverse"),
        value: MyFunctions.reverseAnimation.value,
        onChanged: (value) {
          MyFunctions.reverseAnimation.value = value;
        },
      );
    });
  }
}

// Slider to control the speed of the animation
class SpeedSlider extends StatelessWidget {
  const SpeedSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            activeColor: MyFunctions.getSelectedColor(),
            min: 0.5,
            max: 5.0,
            divisions: 10,
            value: MyFunctions.animationSpeed.value,
            onChanged: (value) {
              MyFunctions.animationSpeed.value = value;
            },
          ),
        ],
      );
    });
  }
}

// Dropdown to select the color of the loading bar (expanded to full width)
class ColorDropdown extends StatelessWidget {
  const ColorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: MyFunctions.getSelectedColor()),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          underline: Container(color: Colors.transparent),
          value: MyFunctions.selectedColor.value,
          isExpanded: true, // Expands to full width
          items: MyFunctions.colorOptions.map((String color) {
            return DropdownMenuItem<String>(
              value: color,
              child: Center(
                child: Text(color,
                  style: TextStyle(color: MyFunctions.getSelectedColor()) ,),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            MyFunctions.selectedColor.value = newValue!;
          },
        ),
      );
    });
  }
}

// Dynamic display of loading bars
class DynamicLoadingDisplay extends StatelessWidget {
  const DynamicLoadingDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int totalBars = MyFunctions.totalBars.value;
      int barsPerLine = MyFunctions.barsPerLine.value;

      if (totalBars == 0 || barsPerLine == 0) {
        return const SizedBox.shrink(); // No loading widgets if values are zero
      }

      // Calculate how many rows are needed
      List<Widget> rows = [];
      for (int i = 0; i < totalBars; i += barsPerLine) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              (i + barsPerLine) > totalBars ? totalBars - i : barsPerLine,
                  (index) => Expanded(child: const LoadingWidget()),
            ),
          ),
        );
      }

      return Column(
        children: rows,
      );
    });
  }
}

// Loading bar widget with sequential and reverse logic
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.all(5),
        width: 100,
        height: 10,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: MyFunctions.reverseAnimation.value ? 1.0 : 0.0,
            end: MyFunctions.reverseAnimation.value ? 0.0 : 1.0,
          ),
          duration: Duration(
            seconds: (5 / MyFunctions.animationSpeed.value).toInt(),
          ),
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(
                  MyFunctions.getSelectedColor()),
              backgroundColor: Colors.grey.shade300,
            );
          },
        ),
      );
    });
  }
}

// Error message display widget
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (MyFunctions.errorMessage.isEmpty) {
        return const SizedBox.shrink(); // No error to display
      }

      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        color: Colors.transparent,
        child: Text(
          MyFunctions.errorMessage.value,
          style: const TextStyle(color: Colors.black),
        ),
      );
    });
  }
}


