import 'package:construction_profit_calculator_english/uniformPricing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'land.dart';
import 'main.dart';
import 'navigation_service.dart';

class SwipeDetector extends StatefulWidget {
  const SwipeDetector({super.key});

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset _startSwipeOffset = Offset.zero;  // Initialize with a default value
  Offset _endSwipeOffset = Offset.zero;    // Initialize with a default value
  bool isReviewMode = false;
  String errorMessage = '';

  void _onVerticalSwipeStart(DragStartDetails details) {
    _startSwipeOffset = details.globalPosition;
    print('Swipe started at: $_startSwipeOffset');
  }

  void _onVerticalSwipeUpdate(DragUpdateDetails details) {
    _endSwipeOffset = details.globalPosition;
    print('Swipe updated to: $_endSwipeOffset');
  }

  void _onVerticalSwipeEnd(DragEndDetails details) {
    final dy = _endSwipeOffset.dy - _startSwipeOffset.dy;
    print('Swipe ended with delta: $dy');

    if (dy < -100) { // Swiped up
      _showReviewModeDialog();
    }
  }

  void _showReviewModeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String username = '';
        String password = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Reviewer Credentials'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateCredentials(username, password)) {
                        setState(() {
                          isReviewMode = true;
                          errorMessage = '';
                        });
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          errorMessage = 'The username or password you entered is incorrect.';
                        });
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _validateCredentials(String username, String password) {
    return username == 'demouser@example.com' && password == 'DemoPassword123';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Swipe Detector')),
      body: GestureDetector(
        onVerticalDragStart: _onVerticalSwipeStart,
        onVerticalDragUpdate: _onVerticalSwipeUpdate,
        onVerticalDragEnd: _onVerticalSwipeEnd,
        child: Container(
          color: Colors.transparent, // Use a color to see the container for debugging
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (isReviewMode) {
                    NavigationService().navigateToScreen(
                      const UniformCalculationPage1(givenUniformProjectName: 'wwmm'),
                      arguments: 'wwmm',
                    );
                  } else {
                    const snackBar = SnackBar(
                      content: Text('The username or password you entered is incorrect.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  ' Uniform Pricing ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isReviewMode) {
                    final projectData = Provider.of<ProjectProviderData>(context, listen: false);
                    await DifferentiatedCalculationDatabaseHelper.deleteProjectBasicData("_oozz");
                    await DifferentiatedCalculationDatabaseHelper.deletePermitFeeDataByProjectName('_oozz');
                    final projectNames = await DifferentiatedCalculationDatabaseHelper.getAllProjectNames();
                    if (projectNames.contains("_oozz")) {
                      await DifferentiatedCalculationDatabaseHelper.deleteProjectOfDifferentiatedCalculationDatabase("_oozz");
                    }
                    projectData.projectNameList.clear();
                    projectData.setProjectName('_oozz');
                    NavigationService().navigateToScreen(
                      const LandInputs(givenProjectName: '_oozz'),
                      arguments: '_oozz',
                    );
                  } else {
                    const snackBar = SnackBar(
                      content: Text('The username or password you entered is incorrect.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  ' Differentiated Pricing ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



