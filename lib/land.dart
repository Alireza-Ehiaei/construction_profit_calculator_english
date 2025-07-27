import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'ad_mob.dart';
import 'all_projects.dart';
import 'database.dart';
import 'main.dart';
import 'navigation_service.dart';
import 'costPrices.dart';

class LandInputs extends StatefulWidget {
  final String? givenProjectName;

  const LandInputs({
    super.key,
    required this.givenProjectName,

  });

  @override
  State<LandInputs> createState() => _LandInputsState();
}

class _LandInputsState extends State<LandInputs> {

  late String projectName1;
  TextEditingController landAreaController = TextEditingController();
  TextEditingController firstFloorNumberController = TextEditingController();
  TextEditingController landPricePerMeterController = TextEditingController();


  int givenStartingFloor1 = -4321;
  bool obscureText = true;
  List<AreaTableRowData> areaTableData = [];
  List<PriceTableRowData> priceTableData = [];

  int rowIndex = 0;
  int columnIndex = 0;
 // late InterstitialAdManager interstitialAdManager;

  TextEditingController rowController = TextEditingController();

  TextEditingController columnIndexController2 = TextEditingController();
  TextEditingController columnIndexController3 = TextEditingController();
  TextEditingController columnIndexController4 = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController numberOfSegmentsController = TextEditingController();
  TextEditingController similarFloorController = TextEditingController();

  int constructionValue = 1;
  List<List<PriceTableRowData>> priceTables = [];
  bool hasData = false;
  int selectedValue = 0;
  bool showLandPrice = true;
//  var projectData = Provider.of<ProjectData>(context, listen: false).firstStartingFloor;
 // late int firstStartingFloor;


  @override
  void initState() {
    super.initState();
    projectName1 = widget.givenProjectName!;
    checkBasicData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onDropdownChanged(selectedValue);
    });
 //   interstitialAdManager = InterstitialAdManager();
 //   interstitialAdManager.loadInterstitialAd();
  }

  void _onDropdownChanged(int? newValue) {
    setState(() {
      selectedValue = newValue!;
    });
  }

  @override
  void dispose() {
 //   interstitialAdManager.dispose();
    super.dispose();
  }

  void checkBasicData()
  async {
    final projectBasicData = await
       CompleteCalculationDatabaseHelper.getProjectBasicData(projectName1);
    if (projectBasicData.isNotEmpty)
    {
      // Assign the retrieved data to associated variables
      landAreaController.text = projectBasicData[0].projectBasicTableLandArea.toString();
      landPricePerMeterController.text = projectBasicData[0].projectBasicTableLandPricePerMeter.toString();
      firstFloorNumberController.text = projectBasicData[0].projectBasicTableFirstFloorNumber.toString();

        selectedValue = int.tryParse(projectBasicData[0].projectBasicTableShortNumbersNumberOfZeroRemoved.toString())!;
    }
  }

  Future<void> _onBackButtonPressedCallback(BuildContext context)
   async {
    if (((projectName1 != '_oozz') && (landAreaController.text.isNotEmpty &&
        isValidNumber(landAreaController.text) &&
        landPricePerMeterController.text.isNotEmpty &&
        isValidNumber(landPricePerMeterController.text) &&
        firstFloorNumberController.text.isNotEmpty &&
        isValidNumber(firstFloorNumberController.text) &&
        int.tryParse(firstFloorNumberController.text) != null )) ) {
      //    await insert to ();
      NavigationService().navigateToScreen(
        const AllProjectsPage(),
      );
    }
    else if
    (projectName1 != '_oozz')
    {
      showErrorDialog1(context);
    }
    else {
      NavigationService().navigateToScreen(
        const AllProjectsPage(),
      );
    }
  }


  void showErrorDialog1(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0; // or your preferred breakpoint

    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 25.0 : 20.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Error', style: TextStyle(fontSize: textFontSize,
            fontWeight: FontWeight.bold,color: Colors.red,)),
          content:  Text(
              "Please fill all required fields. \n\nInputs should be a valid number "
                  "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                  "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                  " Also a trailing decimal point (e.g., '1.') is not allowed.",
              style: TextStyle(
                fontSize: textFontSize,)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                fontWeight: FontWeight.bold,color: Colors.red,
              ),),
            ),
          ],
        );
      },
    );
  }

  void showSaveConfirmationDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0; // or your preferred breakpoint

    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 30.0 : 20.0;

    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text(''),
          content:  Text("You didn't save this project. For saving you should be ensured that "
              "construction cost, sell price and permit fees for all parts of all floors "
              "have been entered then in the last page press save icon "
              "and set a name for this project. \n\nDo you want to save it?",
            style: TextStyle(
              fontSize: textFontSize,
            ),),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Background color for Save button
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                NavigationService().navigateToScreen(
                  CostPrices(
                    givenProjectName: projectName1,
                   // firstStartingFloor: int.parse(firstFloorNumberController.text.replaceAll(',', '')),
                    givenCppValue: 1,
                  ),
                );
              },
              child:  Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white,          // Text color for contrast
                   fontSize: textFontSize,
                ),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Background color for No button
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                NavigationService().navigateToScreen(
                  const AllProjectsPage(),
                );
              },
              child:  Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white,          // Text color for contrast
                   fontSize: textFontSize,
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  bool isValidNumber(String input) {
    // Trim any leading or trailing whitespace
    input = input.trim();

    // Check if the input is empty after trimming
    if (input.isEmpty) {
      return false;
    }

    // Check if the input consists only of digits and at most one decimal point
    if (!RegExp(r'^[0-9]+(\.[0-9]*)?$').hasMatch(input)) {
      return false;
    }

    // Ensure the input doesn't end with a decimal point
    if (input.endsWith('.')) {
      return false;
    }

    // Try parsing the input as a double for final validation
    try {
      double.parse(input);
      return true;
    } on FormatException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.7;
    const double fontSizePhone = 18.0;
    const double titleFontSizePhone = 22.0;
    const double iconSizeLargePhone = 30.0;
    const double iconSizeSmallPhone = 28.0;

// iPad sizes (larger)
    final double buttonWidthPad = screenWidth *  0.5;
    const double fontSizePad = 37.0;
    const double titleFontSizePad = 40.0;
    const double iconSizeLargePad = 55.0;
    const double iconSizeSmallPad = 42.0;

    const ipadBreakpoint = 850.0;


    final bool isIpad = screenWidth > ipadBreakpoint;

    final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 20 : 10;


    return  Consumer<ProjectData>(
        builder: (context, projectData, child) {

          return Scaffold(
            body: Container(
              color: Colors.brown[200],
              child: SafeArea(
                child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Column(
                            children: [
                          //     const SizedBox(height: 18),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8,2,8,0),
                                child: Container(color: const Color(0xFF5E0209),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: screenWidth * 0.7,
                                          ),
                                          child: Text(
                                            projectData.projectName == "***" ? " Basic Data"
                                                : projectData.projectName == "_oozz" ? " Basic Data"
                                                : '${projectData.projectName} Basic Data',
                                            style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox.shrink(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'step 1/4 ',
                                          style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              SizedBox(height: spacingHeight),
                
                
                              Row(
                                children: [
                                   SizedBox(width: textFontSize),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                
                                      child: Text(
                                        'Shorthand:' ,
                                        style: TextStyle(fontSize: textFontSize,
                                          fontWeight: FontWeight.bold,),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 63.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton<int>(
                                        value: selectedValue,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedValue = newValue!;
                                          });
                                        },
                                        style: TextStyle(fontSize: textFontSize, color: Colors.black),
                                        items: const [
                                          DropdownMenuItem<int>(
                                            value: 0,
                                            child: Text('0'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 1,
                                            child: Text('1'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 2,
                                            child: Text('2'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 3,
                                            child: Text('3'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 4,
                                            child: Text('4'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 5,
                                            child: Text('5'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 6,
                                            child: Text('6'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 7,
                                            child: Text('7'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 8,
                                            child: Text('8'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 9,
                                            child: Text('9'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 10,
                                            child: Text('10'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 11,
                                            child: Text('11'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 12,
                                            child: Text('12'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 13,
                                            child: Text('13'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 14,
                                            child: Text('14'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 15,
                                            child: Text('15'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 16,
                                            child: Text('16'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 17,
                                            child: Text('17'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 18,
                                            child: Text('18'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 19,
                                            child: Text('19'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: 20,
                                            child: Text('20'),
                                          ),
                                          DropdownMenuItem<int>(
                                            value: -1,
                                            child: Text(''),
                                          )
                                        ]
                                    ),
                                  ),
                
                
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                      title:  Text('Simplify Large Numbers for Prices and Costs',
                                                        style: TextStyle(
                                                        fontWeight: FontWeight.bold,color: Colors.deepPurple,
                                                          fontSize: textFontSize
                                                      ),),
                
                                                content: SingleChildScrollView(
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                
                                                        TextSpan(
                                                          text: '\nInstead of writing out the full number, you can select the '
                                                              'corresponding  level to indicate how many zeros should'
                                                              ' be considered in front of the number for prices and costs.',
                                                          style: TextStyle(
                                                          fontSize: textFontSize,
                                                        ),
                                                        ),
                                                         TextSpan(
                                                          text: '\n\nFor example, if you have a price or cost like 25,000,000, you '
                                                              'can select " 6" from the dropdown. This will automatically add 6 '
                                                              'zeros in front of the number you enter for calculations, allowing you to just '
                                                              'type "25" instead of the full 25,000,000. Another example, by entering "33" with " 9" selected, '
                                                              'the actual value in calculations of the app will be 33,000,000,000.',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                         TextSpan(
                                                          text: '\n\nIt is important to note that all measurements like land area '
                                                              'or unit area should be written completely with all necessary zeros. '
                                                              'These  options are specifically designed to simplify the entry '
                                                              'of prices and costs that would otherwise have many zeros in some currencies.',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                         TextSpan(
                                                          text: '\n\nHowever, if you prefer a more compact representation and do not '
                                                              'want to see a large number of zeros, you can select " 0" from '
                                                              'the dropdown. When " 0" is selected, you can enter prices and costs with '
                                                              'as many zeros removed as you like. This will keep the number you enter exactly as-is, '
                                                              'without any additional zeros added. Just remember to mentally adjust the '
                                                              'entered value based on the number of zeros you have removed.',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                         TextSpan(
                                                          text: ' For instance, entering "500" instead of "500,000" with " 0" '
                                                              'selected will result in the actual price being considered as 500. In this '
                                                              'case, you will need to mentally add "000" to the displayed results.',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.red,
                                                    ),),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.brown,),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: spacingHeight),
                                ],
                              ),
                
                              Column(
                                children: [
                                  SizedBox(height: spacingHeight),
                
                              Row(
                                children: [  SizedBox(width: textFontSize),
                                   Expanded(
                                    flex: 3,
                                    child:
                                    Text('Area of Land', style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: textFontSize,
                                    ),),
                                  ),
                
                                  Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: landAreaController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                        ),
                                        keyboardType: TextInputType.number, // Set the keyboard type to number input
                                        style: TextStyle(fontSize: textFontSize),)
                                  ),
                                  const SizedBox(width: 3.0),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text('Area of Land', style: TextStyle(
                                              fontWeight: FontWeight.bold,color: Colors.deepPurple,
                                              fontSize: textFontSize,),),
                                            content:  Text('\nThe total size of the plot of land, '
                                                'measured in ft² or m².', style: TextStyle(
                                              fontSize: textFontSize,
                                            ),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.red,
                                                ),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.brown,),
                                  ),
                                   SizedBox(width: spacingHeight),
                                ],
                              ),
                
                              SizedBox(height: spacingHeight),
                
                              Row(
                                children: [  SizedBox(width: textFontSize),
                                   Expanded(
                                    flex: 3,
                                    child:
                                    Text('Land Price (ft²)', style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: textFontSize,
                                    ),),
                                  ),
                
                                  Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: landPricePerMeterController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          hintText:  '' ,
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: textFontSize),)
                                  ),
                                  const SizedBox(width: 3.0),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text('Land Price', style: TextStyle(
                                              fontWeight: FontWeight.bold,color: Colors.deepPurple,fontSize: textFontSize
                                            ),),
                                            content:  Text('\nEnter the price of purchasing one square ft²/m² of land.', style: TextStyle(
                                              fontSize: textFontSize,
                                            ),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.red,
                                                ),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.brown,),
                                  ),
                                   SizedBox(width: spacingHeight),
                                ],
                              ),
                              SizedBox(height: spacingHeight),
                              Row(
                                children: [  SizedBox(width: textFontSize),
                                  Expanded(
                                    flex: 3,
                                    child:
                                    Text('First Floor Number', style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: textFontSize,
                                    ),),
                                  ),
                
                                  Expanded(
                                      flex: 2,
                                      child: TextField(
                                        controller: firstFloorNumberController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                        ),
                                        keyboardType: TextInputType.number, // Set the keyboard type to number input
                                        style: TextStyle(fontSize: textFontSize),)
                                  ),
                                  const SizedBox(width: 1.0),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text('First Floor Number', style: TextStyle(
                                                fontWeight: FontWeight.bold,color: Colors.deepPurple,fontSize: textFontSize
                                            ),),
                                            content:  SingleChildScrollView(
                                              child: Text('\nThe "First Floor Number" refers to the floor '
                                                  'level at which the construction of the building will start. '
                                                  'This is not necessarily the same as the actual floor numbering of the completed building.'
                                                  '\n\nFor example: '
                                                  '\nIf the building is built-up on the ground surface, with no floors below '
                                                  'ground level, enter 0 as the "First Floor Number", as the ground '
                                                  'floor is considered the first floor regardless of the fact that it is parking or residential-commercial floor.'
                                                  ' If the building has 3 floors underground, the "First Floor Number" would '
                                                  'be -3, as the construction starts from the basement level.'
                                                  '\n\nIn some cases, the building may be an addition or renovation to an '
                                                  'existing structure. For instance, if the existing building has 2 '
                                                  'floors on the ground, including the ground floor 0 and floor 1, '
                                                  'the "First Floor Number" for the new construction would be 2, as '
                                                  'the construction starts from the 3rd floor.'
                                                  '\n\nThe key principle is that the "First Floor Number" should reflect '
                                                  'the floor level at which the new construction begins, regardless '
                                                  'of the overall floor numbering of the completed building. \n',  style: TextStyle(
                                                fontSize: textFontSize,
                                              ),),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.red,
                                                ),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon:  Icon(Icons.question_mark,
                                      size: iconSizeSmall,  color: Colors.brown,),
                                  ),
                                  SizedBox(width: spacingHeight),
                                ],
                              ),
                                ],
                              ),
                            ],
                          ),
                        )
                    )
                    ),
                
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return SingleChildScrollView (
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                 SizedBox(width: textFontSize),
                
                                IconButton(
                                  icon: Icon(Icons.home, color: Colors.purple[900], size: iconSizeLarge),
                                  onPressed: () async {
                             //       await interstitialAdManager.showInterstitialAd(context);
                                    // This callback will be executed after the ad is shown
                                    NavigationService().navigateToScreen(const AllProjectsPage());
                
                                  },
                                ),
                
                                const SizedBox(width: 46),
                
                                IconButton(
                                  icon:  Icon(Icons.arrow_back_ios,
                                      color: Colors.deepPurple, size: iconSizeLarge),
                                  onPressed: () {
                                    if (projectName1== '_oozz') {
                                      showSaveConfirmationDialog(context);}
                                    else {
                                      _onBackButtonPressedCallback(context);
                                    } },),
                
                                const SizedBox(width: 46),
                
                                IconButton(
                                  icon:  Icon(Icons.arrow_forward_ios,
                                      color: Colors.deepPurple, size: iconSizeLarge),
                                  onPressed: () async {
                
                                    if (landAreaController.text.isNotEmpty &&
                                        isValidNumber(landAreaController.text) &&
                                        landPricePerMeterController.text.isNotEmpty &&
                                        isValidNumber(landPricePerMeterController.text) &&
                                        firstFloorNumberController.text.isNotEmpty &&
                                        isValidNumber(firstFloorNumberController.text) &&
                                        int.tryParse(firstFloorNumberController.text) != null
                                    ) {
                
                                      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectBasicData(
                                        projectName1,
                                        double.parse(landAreaController.text),
                                        double.parse(landPricePerMeterController.text),
                                        int.tryParse(firstFloorNumberController.text) ?? 0,
                                          selectedValue ?? 0
                                      );
                
                                      // Save the project basic data to the database
                                     /* await CompleteCalculationDatabaseHelper.insertOrUpdateProjectBasicData(
                                        ProjectBasicData(
                                          projectBasicTableId: await CompleteCalculationDatabaseHelper.getNextProjectBasicId(),
                                          projectBasicTableProjectName: projectName1,
                                          projectBasicTableLandArea: double.parse(landAreaController.text),
                                          projectBasicTableLandPricePerMeter: double.parse(landPricePerMeterController.text),
                                          projectBasicTableRoofAndYardConstructionCosts: double.parse(roofAndYardConstructionCostsController.text),
                                          projectBasicTableTransactionCosts: double.parse(transactionCostsController.text),
                                          projectBasicTableOtherCosts: double.parse(otherCostController.text),
                                          projectBasicTableFirstFloorNumber: int.tryParse(firstFloorNumberController.text) ?? 0,
                                          projectBasicTableNumberOfSaleableProperties: double.parse(numberOfSaleablePropertiesController.text),
                                          projectBasicTableShortNumbersNumberOfZeroRemoved: (selectedValue),
                                        ),
                                      );*/
                
                                /*      if (givenStartingFloor1 != -4321 &&
                                          int.parse(firstFloorNumberController.text.replaceAll(',', '')) != givenStartingFloor1){
                                        String startingFloorProjectName = projectName1;
                                        int differenceStartingFloor = givenStartingFloor1 - int.parse(firstFloorNumberController.text.replaceAll(',', ''));
                
                                        // Update the starting floor for the rows with the matching project name
                                        await CompleteCalculationDatabaseHelper.updateStartingFloorForInTableStartingSimilar(
                                            startingFloorProjectName, differenceStartingFloor);
                                      }*/
                
                                      givenStartingFloor1 = int.parse(firstFloorNumberController.text.replaceAll(',', ''));
                
                                      projectData.setFirstStartingFloor(givenStartingFloor1);
                
                                      NavigationService().navigateToScreen(
                                        CostPrices(
                                          givenProjectName: projectName1,
                                //          firstStartingFloor: int.parse(firstFloorNumberController.text.replaceAll(',', '')),
                                          givenCppValue: 1,
                                        ),
                                      );

                                    }
                                    else {
                                      // Show a popup dialog with an error message
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text('Error'
                                                , style: TextStyle(fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,color: Colors.red,)),
                                            content:  SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    '\nAll fields must be filled with valid values.\n\n '
                                                        "The first floor number should be an integer, not a decimal value."
                                                        "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                        "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                        " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                                    style: TextStyle(fontSize: textFontSize),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.red,
                                                ),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                
                                const SizedBox(width: 36),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:  Text('Introduction', style: TextStyle(
                                            fontSize: textFontSize,color: Colors.brown,fontWeight: FontWeight.bold,
                                          ),),
                                          content:  SingleChildScrollView(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                
                                                  TextSpan(
                                                    text: '\nSimilar to the Simple Calculation part of the app, this part called '
                                                        'Complete Calculation is a financial calculator specifically designed '
                                                        'for feasibility studies and analyzing the cost benefits of constructing a building. '
                                                        '\n\nUnlike the simple calculation, this tool has a differentiated pricing model '
                                                        'that allows you to input varying construction cost, '
                                                        'permission cost and sell prices for different units '
                                                        'defined on each floor and across multiple floors. This '
                                                        'approach is closer to reality, as modern buildings typically '
                                                        'have higher prices for upper floors due to better lighting, '
                                                        'views, and probably more luxurious materials, might have '
                                                        'higher costs per ft²/m². Assigning segment-specific '
                                                        'sell prices that accurately reflect real-world conditions helps '
                                                        'make more informed financial decisions for investments and '
                                                        'enables effective budgeting and resource allocation. '
                                                        'Currently you are in the first step of the complete calculator.',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                
                                                  TextSpan(
                                                    text: '\n\nSteps to Use This Calculator',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.pink,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n\n1. Project\'s Basic Data',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nIn this page, as the first step of complete calculation tool, '
                                                        'enter the basic project information, such as:',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n- Land area (plot area)',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),

                                                  TextSpan(
                                                    text: '\n- Land price',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n\n2. Construction cost and sell price',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nIn the next pages for each ft²/m² of all '
                                                        'cost-price segments (explained below) you will need to '
                                                        'define construction cost and sell price',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                
                                                  TextSpan(
                                                    text: '\n\n3. Permission cost',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nFor each ft²/m² of all permission segments (explained below) '
                                                        ' in total built-up area defined in step two, you '
                                                        'should enter permission cost in the third step.',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n\n4. Other Basic Data',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.blue,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\nEnter data, such as:',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n- Transaction costs',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n- Number of properties',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '\n\n\nImportant Notes',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,color: Colors.pink,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "\n\n■ Unlike the simple calculation, in this part"
                                                        " there is no need to define the number of common or sealable "
                                                        "floors, or specifying their associated areas "
                                                        "at first. Instead, for all segments in each floor, you must "
                                                        "set both the construction costs and sell prices.",
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                
                                                  TextSpan(
                                                    text: '\n\n■ In the complete calculation you can set the area of each floor '
                                                        'independently of the land area on which the building is built-up . '
                                                        'In reality, it\'s possible for a building to have a larger built-up '
                                                        'area on certain floors than the area of the land itself. For example, '
                                                        'consider two buildings located on opposite sides of a street. If floors '
                                                        '5 to 10 are connected by a building structure that serves as a bridge between '
                                                        'the two buildings, the built-up area on those floors exceeds the '
                                                        'total land area of the two buildings. '
                                                        '\n\nAdditionally, floors can vary in area. For example, in a five-story building,'
                                                        ' each floor starting from the first can have 10% less built-up area than '
                                                        'the floor below it or, for example, 20% more built-up area than '
                                                        'the floor below, regardless of the land area. '
                                                        '\n\nThis flexibility in defining floor areas '
                                                        'reflects real-world scenarios. Therefore, you can use this financial '
                                                        'calculator to assess the cost-benefit of any unique architectural design. ',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                
                                                  TextSpan(
                                                    text:
                                                    '\n\nEach page has its own dedicated guidance '
                                                        'that you can access by pressing the question icon next to the relevant'
                                                        ' section. Additionally, there is an overall guidance for each page that '
                                                        'you can read by pressing the question icon located at the bottom of that page.',
                                                    style: TextStyle(
                                                      fontSize: textFontSize,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,color: Colors.red,
                                              ),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon:  Icon(Icons.help_center_rounded,
                                      color: Colors.purple[900], size: iconSizeLarge),
                                ),
                              ],
                            ),
                
                          );
                        },
                      ),
                    ),
                             //     const MyBannerAdWidget(),
                    SizedBox(height:  spacingHeight  ),
                  ],
                ),
              ),

            ),
          );
        }
    );
  }

}
