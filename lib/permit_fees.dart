import 'dart:math';
import 'package:construction_profit_calculator_english/otherCost.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ad_mob.dart';
import 'land.dart';
import 'main.dart';
import 'database.dart';
import 'navigation_service.dart';
import 'costPrices.dart';

Future<Map<String, dynamic>> getFloorRanges(String projectName, int startingFloor)
async {
  // Retrieve project data from the database
  final List<ProjectTableData> projectProviderData =
  await DifferentiatedCalculationDatabaseHelper.getCostPricingData(projectName);

  // SIMPLER APPROACH: Calculate total constructed area directly from projectProviderData
  double totalConstructedArea = projectProviderData.fold(0.0, (sum, data) =>
  sum + double.parse(data.costPricingTableSegmentArea.toString()));

  // Step 1: Create a map to hold total area for each floor
  Map<int, double> floorAreaMap = {};

  for (final currentData in projectProviderData) {
    final int currentFloorNumber =
    int.parse(currentData.costPricingTableFloorNumber.toString());

    // Initialize the area for the current floor number if not already present
    floorAreaMap[currentFloorNumber] = (floorAreaMap[currentFloorNumber] ?? 0.0) +
        double.parse(currentData.costPricingTableSegmentArea.toString());
  }

  // Convert the floorAreaMap to a sorted list of floor numbers and their total areas
  List<List<dynamic>> floorToArea = floorAreaMap.entries
      .map((entry) => [entry.key, entry.value])
      .toList()
    ..sort((a, b) => a[0].compareTo(b[0]));

  // Step 2: Create a list of floor ranges with their total area
  List<List<dynamic>> floorRanges = [];
  List<dynamic> currentRange = [floorToArea[0][0], floorToArea[0][0], floorToArea[0][1]];

  for (int i = 1; i < floorToArea.length; i++) {
    if (floorToArea[i][1] == currentRange[2]) {
      // Extend the current range if the area is the same
      currentRange[1] = floorToArea[i][0];
    } else {
      // Add the current range to the list and start a new range
      floorRanges.add(currentRange);
      currentRange = [floorToArea[i][0], floorToArea[i][0], floorToArea[i][1]];
    }
  }
  // Add the last range to the list
  floorRanges.add(currentRange);

  // Step 3: Compare the floor areas in costPricingTable with permit fee floor areas
  List<int> floorsHaveChanged = [];
  final List<List<dynamic>> permitFeeFloorAreas =
  await DifferentiatedCalculationDatabaseHelper.getPermitFeeFloorArea(projectName);

  // First, check all floors in costPricingTable are in permitFeeFloorAreas and match area
  if (permitFeeFloorAreas.isNotEmpty) {
    for (final floor in floorToArea) { // floors in costPricingTable
      final int floorNumber = floor[0];
      final double floorArea = floor[1];
      bool found = false;

      for (final permitFloor in permitFeeFloorAreas) {
        if (floorNumber == permitFloor[0]) {
          found = true;
          if (floorArea != permitFloor[1]) {
            floorsHaveChanged.add(floorNumber);
          }
          break;
        }
      }
      if (!found) {
        floorsHaveChanged.add(floorNumber);
      }
    }

    // Now check for extra floors in permitFeeFloorAreas not in costPricingTable
    for (final permitFloor in permitFeeFloorAreas) {
      final int permitFloorNumber = permitFloor[0];
      bool found = false;
      for (final floor in floorToArea) {
        if (permitFloorNumber == floor[0]) {
          found = true;
          break;
        }
      }
      if (!found) {
        floorsHaveChanged.add(permitFloorNumber);
      }
    }
  }

  // Return the results as a map
  return {
    'floorRanges': floorRanges,
    'floorsHaveChanged': floorsHaveChanged,
    'totalConstructedArea': totalConstructedArea,
  };
}


Future<Map<int, double>> getFloorNumberToAreaMap(String projectName)
async {
  final List<ProjectTableData> projectProviderData = await DifferentiatedCalculationDatabaseHelper.getCostPricingData(projectName);
  final Map<int, double> floorNumberToAreaMap = {};

  for (int i = 0; i < projectProviderData.length; i++) {
    final ProjectTableData currentData = projectProviderData[i];
    final int currentFloor = currentData.costPricingTableFloorNumber.toInt();
    final double unitArea = currentData.costPricingTableSegmentArea;

    if (floorNumberToAreaMap.containsKey(currentFloor)) {
      floorNumberToAreaMap[currentFloor] = (floorNumberToAreaMap[currentFloor] ?? 0.0) + unitArea;
    } else {
      floorNumberToAreaMap[currentFloor] = unitArea;
    }
  }

  return floorNumberToAreaMap;
}


class FloorRangesPage extends StatefulWidget
  {
  final String givenProjectName;

  const FloorRangesPage({
    super.key,
    required this.givenProjectName,
  });

  @override
 // _FloorRangesPageState createState() => _FloorRangesPageState();
  State createState() => _FloorRangesPageState();
}

class _FloorRangesPageState extends State<FloorRangesPage> {
  List<List<dynamic>> floorRangesData = [];
  List<int> floorsHaveChangedData = [];
  late String projectName1;
  int maxFloorNumberCalculatedInRangeFloorsPage = 0;
  double maxFloorArea = 0.0;
  double totalConstructedArea = 0;
  late int startingFloor;
  bool floorsHaveChangedBool = false;
  bool _isUniquePermitFeePerMeterBool = false;
  bool _isUniquePermitFeeTotalBool = false;
  bool _isDifferentiatedPermitFeeBool = true;
  final _uniquePermitFeeController = TextEditingController();
  final _uniqueTableTotalPermitFeeController = TextEditingController();
  double totalPermitFee = 0;


  @override
  void initState() {
    super.initState();
    // Call the method to retrieve floor ranges data
    projectName1 = widget.givenProjectName;
    startingFloor = Provider.of<ProjectProviderData>(context, listen: false).firstStartingFloor;
    getFloorRangesAndMaxFloorData();
  }


  Future<void> getFloorRangesAndMaxFloorData()
     async {
    final result = await getFloorRanges(projectName1, startingFloor);
    final floorRanges = result['floorRanges'];
    final floorsHaveChanged = result['floorsHaveChanged'];
    var totalConstructedArea_ = result['totalConstructedArea'];
    // Find the maximum floor number
    int maxFloor = floorRanges.isNotEmpty ? floorRanges.last[1] : startingFloor;

    // Update the state with the retrieved data
    setState(() {
      floorRangesData = floorRanges;
      floorsHaveChangedData = floorsHaveChanged;
      maxFloorNumberCalculatedInRangeFloorsPage = maxFloor;
      totalConstructedArea = totalConstructedArea_;
      floorsHaveChangedBool = floorsHaveChangedData.isNotEmpty;
    });


    final uniquePermitFeeData = await DifferentiatedCalculationDatabaseHelper.getUniquePermitFeeData(projectName1);

    if (uniquePermitFeeData.isNotEmpty) {
      setState(() {

        _isUniquePermitFeePerMeterBool =
            uniquePermitFeeData[0].uniquePermitFeeTableIsUniquePermitFeePerMeterBool == 1
        ;
        _isUniquePermitFeeTotalBool = (uniquePermitFeeData[0]
            .uniquePermitFeeTableIsUniquePermitFeeTotalBool == 1);

        _isDifferentiatedPermitFeeBool =
        (_isUniquePermitFeeTotalBool || _isUniquePermitFeePerMeterBool)
            ? false
            : true;

        _uniquePermitFeeController.text = _isUniquePermitFeePerMeterBool  ?
        uniquePermitFeeData[0].uniquePermitFeeTableUniquePermitFeePerMeter.toString() : '';

        _uniqueTableTotalPermitFeeController.text = _isUniquePermitFeeTotalBool ?
        uniquePermitFeeData[0]
            .uniquePermitFeeTableUniquePermitFeeTotal.toString() : '';
      });
    }

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
    return  Consumer<ProjectProviderData>(
        builder: (context, projectProviderData, child) {

      double screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.7;
    const double fontSizePhone = 20.0;
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

 //   final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
 //   final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
 //   final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
 //   final double spacingHeight = isIpad ? 16.0 : 10.0;

    return Scaffold(

      body: Container(
        color: const Color.fromRGBO(100, 19, 26, 1.0), // Add a background color to the entire page
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: const Color(0xFF440106),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.7,
                        ),
                        child: Text(
                          projectProviderData.projectName == "***" ? " Permit Fee"
                              : projectProviderData.projectName == "_oozz" ? "Permit Fee"
                              : 'Permit Fee - ${projectProviderData.projectName}',
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
                        'step 3/4 ',
                        style: TextStyle(color: Colors.white, fontSize: textFontSize),
                      ),
                    ),
                  ],
                ),
              ),


              Expanded(flex: 6,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Visibility(
                          visible: (_isDifferentiatedPermitFeeBool && floorsHaveChangedBool  ),
                          child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RichText( // Changed to RichText
                                  text: TextSpan(
                                    style:  TextStyle(color: Colors.yellow,  fontSize: textFontSize),
                                    children: [
                                       TextSpan(text: 'It seems you added or removed some floors in previous part, or'
                                           ' changed their areas that do not match with the current plans'
                                           ' in the permit fees part, so again:'
                                //      '  for the following floors. '
                                           , style: TextStyle(fontSize: textFontSize)),
                                      // TextSpan(text: floorsHaveChangedData.join(', ')),
                                    ],
                                  ),
                                ),
                              ),
                        ),

                                const SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'You have defined the floors below in the previous step. In '
                                          'this step, determine the permit cost by filling one of '
                                          'the uniform options on this page or the differentiated option on the next page.',
                                      style: TextStyle(
                                        color: Colors.white, // Set the color of the text to red
                                      //  fontWeight: FontWeight.bold,
                                           fontSize:  textFontSize * 0.8,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),
                                SingleChildScrollView(
                                  child: Container(
                                    color: Colors.white60,
                                    child: SizedBox(
                                      height:  MediaQuery.of(context).size.height * .4, // Fixed maximum height for the table
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                              return Colors.orange; // Color(0xFFF4EDE3); // Set the background color of the header row to a pale brick color
                                            }),
                                            columnSpacing: 44, // Optional: Adjust the column spacing if needed
                                            horizontalMargin: 33,
                                            columns: <DataColumn>[
                                              DataColumn(label: Text('Floor     ',style: TextStyle(color: Colors.black87,
                                                  fontSize: textFontSize))),
                                              DataColumn(label: Text('Area    ',style: TextStyle(color: Colors.black87,
                                                  fontSize: textFontSize))),
                                            ],
                                            rows: floorRangesData.map(
                                                  (floorRange) {
                                                return DataRow(
                                                  color: WidgetStateProperty.resolveWith<Color>(
                                                        (Set<WidgetState> states) {
                                                      if (floorRangesData.indexOf(floorRange).isEven) {
                                                        return const Color(0xFF55B430); // Light rose color
                                                      } else {
                                                        return const Color(0xFF388A01); // Rose color
                                                      }
                                                    },
                                                  ),
                                                  cells: <DataCell>[
                                                    (floorRange[0] == floorRange[1])
                                                        ? DataCell(Text('${floorRange[0]}',
                                                        style:  TextStyle( fontSize: textFontSize)))
                                                        : DataCell(Text('${floorRange[0]} to ${floorRange[1]}', style:  TextStyle( fontSize: textFontSize))),
                                                    DataCell(Text('${floorRange[2]}',
                                                        style:  TextStyle( fontSize: textFontSize))), // Assuming floorRange[2] is total area
                                                  ],
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            color: Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Switch
                                      Switch(
                                        value: _isDifferentiatedPermitFeeBool,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _isDifferentiatedPermitFeeBool = value;
                                            if (value) {
                                              _isUniquePermitFeePerMeterBool = false;
                                              _isUniquePermitFeeTotalBool = false;
                                              _uniquePermitFeeController.clear();
                                              _uniqueTableTotalPermitFeeController.clear();
                                            }
                                          });
                                        },
                                      ),

                                      const SizedBox(width: 10),
                                      // Text
                                      Text(
                                        'Differentiated permit fee ',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isIpad ? 30 : 18,
                                        ),
                                      ),
                                      // Spacer to align with first row's text field (empty space)
                                //      Spacer(),

                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  Row(
                                    children: [
                                      // Text field - Move Expanded to be direct child of Row
                                      Switch(
                                        value: _isUniquePermitFeePerMeterBool,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _isUniquePermitFeePerMeterBool = value;
                                            if (value) {
                                              _isDifferentiatedPermitFeeBool = false;
                                              _isUniquePermitFeeTotalBool = false;
                                              _uniquePermitFeeController.clear();
                                              _uniqueTableTotalPermitFeeController.clear();

                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Uniform permit fee',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isIpad ? 30 : 18,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      // Switch

                                      Expanded(
                                        flex: 2,
                                        child: TextField(
                                          controller: _uniquePermitFeeController,
                                          readOnly: !_isUniquePermitFeePerMeterBool,
                                          decoration: InputDecoration(
                                            hintText: 'per ft²/m²',
                                            fillColor: Colors.white54, 
                                            filled: true, 
                                            border: const OutlineInputBorder(),
                                            hintStyle: TextStyle(color: Colors.black38,
                                                fontSize: isIpad ? 30 : 15),
                                          ),
                                          style: TextStyle(fontSize: textFontSize * 0.8),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,

                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  Row(
                                    children: [
                                      Switch(
                                        value: _isUniquePermitFeeTotalBool,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _isUniquePermitFeeTotalBool = value;
                                            if (value) {
                                              _isDifferentiatedPermitFeeBool = false;
                                              _isUniquePermitFeePerMeterBool = false;
                                              _uniquePermitFeeController.clear();
                                              _uniqueTableTotalPermitFeeController.clear();
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        'Total permit fee',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isIpad ? 30 : 20,
                                        ),
                                      ),
                                      const SizedBox(width: 20),

                                      Expanded(
                                        flex: 2,
                                        child: TextField(
                                          controller: _uniqueTableTotalPermitFeeController,
                                          readOnly: !_isUniquePermitFeeTotalBool,
                                          decoration:  InputDecoration(
                                            hintText: 'total fee',
                                            fillColor: Colors.white54, 
                                            filled: true, 
                                            border: OutlineInputBorder(),
                                            hintStyle: TextStyle(color: Colors.black38, fontSize: isIpad ? 30 : 20),
                                          ),
                                          style: TextStyle(fontSize: isIpad ? 30 : textFontSize * 0.8),
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,

                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],),
                  ),
                ),
              ),
              Container(color: const Color.fromRGBO(77, 1, 7, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,1),
                  child: Row(
                    children: [

                      Expanded(
                        flex: 3,
                        child: IconButton(
                          icon:  Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: iconSizeLarge),
                          onPressed: () async {

                            if (_isUniquePermitFeePerMeterBool || _isUniquePermitFeeTotalBool)
                            {
                              if (_isUniquePermitFeePerMeterBool)
                              {
                                if (_uniquePermitFeeController.text.isNotEmpty
                                    && isValidNumber(_uniquePermitFeeController.text))

                                {totalPermitFee = totalConstructedArea *
                                      double.parse(_uniquePermitFeeController.text);

                                  UniquePermitFeeData data = UniquePermitFeeData(

                                    uniquePermitFeeTableProjectName: projectName1,
                                    uniquePermitFeeTableIsUniquePermitFeePerMeterBool: 1,
                                    uniquePermitFeeTableIsUniquePermitFeeTotalBool: 0,
                                    uniquePermitFeeTableUniquePermitFeePerMeter: double.parse(_uniquePermitFeeController.text),
                                    uniquePermitFeeTableUniquePermitFeeTotal: totalPermitFee,
                                  );

                                  await DifferentiatedCalculationDatabaseHelper
                                      .insertOrUpdateUniquePermitFeeData(data);

                                  NavigationService().navigateToScreen(
                                    CostPrices(
                                      givenProjectName: projectName1,
                                      givenCppValue: 1,
                                    ),
                                  );

                                }
                                else
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:  Text(
                                          'Error',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content:  Text(
                                          'If you selected uniform permit fee or total permit fee options you should'
                                              'enter a valid number for it, '
                                              "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                              "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                              " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                          style: TextStyle(fontSize: textFontSize),
                                        ),
                                        actions: [
                                          TextButton(
                                            child:  Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }

                              else if (_isUniquePermitFeeTotalBool)

                              {
                                if (_uniqueTableTotalPermitFeeController.text.isNotEmpty
                                    && isValidNumber(_uniqueTableTotalPermitFeeController.text))

                                {
                                  totalPermitFee =  double.parse(_uniqueTableTotalPermitFeeController.text);
                                  double uniquePermitFe = (totalPermitFee / totalConstructedArea);
                                  UniquePermitFeeData data = UniquePermitFeeData(
                                    uniquePermitFeeTableProjectName: projectName1,
                                    uniquePermitFeeTableIsUniquePermitFeePerMeterBool: 0,
                                    uniquePermitFeeTableIsUniquePermitFeeTotalBool:  1 ,
                                    uniquePermitFeeTableUniquePermitFeePerMeter: uniquePermitFe,
                                    uniquePermitFeeTableUniquePermitFeeTotal: totalPermitFee,
                                  );

                                  await DifferentiatedCalculationDatabaseHelper.insertOrUpdateUniquePermitFeeData(data);

                                  NavigationService().navigateToScreen(
                                    CostPrices(
                                      givenProjectName: projectName1,
                                      givenCppValue: 1,
                                    ),
                                  );
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:  Text(
                                          'Error',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text("If you selected permit fee uniformly either per ft²/m² or in total, input"
                                      " cannot be empty and should be a valid number "
                                      "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                        "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                        "A trailing decimal point (e.g., '1.') is not allowed.",style: TextStyle(
                                        fontSize: textFontSize,
                                      ),),
                                        actions: [
                                          TextButton(
                                            child:  Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            }
                            else
                            {
                              NavigationService().navigateToScreen(
                                CostPrices(
                                  givenProjectName: projectName1,
                                  givenCppValue: 1,
                                ),
                              );
                            }
                          }
                          ),
                      ),

                      Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:  Text(
                                      'Permit fee',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: textFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content:  SingleChildScrollView(
                                      child: Text('\nYou defined the floors with their areas in the table in '
                                          'the previous step. In this step, you must enter the construction permit fee (building permit fee).'
                                                                        
                                          '\n\nYou can enter the permit fee uniformly (per square meter) for all '
                                          'floors on this page, which the software will multiply by the total floor'
                                          ' area to calculate the total permit fee. Alternatively, you can select the'
                                          ' total fee option and enter the total permit fee yourself.'
                                          '\n\nIf the permit fees for the units are not uniform or if you do not know the total'
                                          ' permit fee, select the differentiated permit fee option. In the subsequent '
                                          'pages, you can split each floor into the required number of permit sections '
                                          'and enter the permit fee for each section.'
                                          '\n\nFor example: If a floor has 150 square meters of floor area and the construction '
                                          'permit fee is 20\$ per square meter (uniform permit fee), you can'
                                          ' select the uniform permit fee option and enter the 20 next to it, or '
                                          'you can choose the total permit fee option and enter 3000.'
                                          '\n\nHowever, if the municipality has determined a permit fee for 100 square meters'
                                          ' of it at one rate and for the remaining 50 square meters at a different '
                                          'rate, you must select the differentiated permit fee option on this '
                                          'page. Then, in the following pages, define two permit fee sections for '
                                          'this floor (100 m² and 50 m²) and enter the specific fee for each section.',
                                          style: TextStyle(color: Colors.black87, fontSize: textFontSize)
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child:  Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: textFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon:  Icon(Icons.question_mark,color: Colors.white,size: iconSizeLarge,)
                        ),
                      ),
                     // const SizedBox(width: 8.0),
                      Expanded(
                        flex: 3,
                        child: IconButton(
                          icon:   Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: iconSizeLarge),
                          onPressed: () async {
                            if (_isUniquePermitFeePerMeterBool || _isUniquePermitFeeTotalBool)
                            {
                              if (_isUniquePermitFeePerMeterBool)
                              {
                                if (_uniquePermitFeeController.text.isNotEmpty
                                    && isValidNumber(_uniquePermitFeeController.text))
                                {

                                  totalPermitFee = totalConstructedArea *
                                      double.parse(_uniquePermitFeeController.text);

                                  UniquePermitFeeData data = UniquePermitFeeData(

                                    uniquePermitFeeTableProjectName: projectName1,
                                    uniquePermitFeeTableIsUniquePermitFeePerMeterBool: 1,
                                    uniquePermitFeeTableIsUniquePermitFeeTotalBool: 0,
                                    uniquePermitFeeTableUniquePermitFeePerMeter:
                                    double.parse(_uniquePermitFeeController.text),
                                    uniquePermitFeeTableUniquePermitFeeTotal: totalPermitFee,
                                  );
                                  await DifferentiatedCalculationDatabaseHelper
                                      .insertOrUpdateUniquePermitFeeData(data);

                                  await NavigationService().navigateToScreen(
                                    OtherCosts(
                                      givenProjectName: widget.givenProjectName,
                                      //             givenFloorRangesData: floorRangesData,
                                      //            maxFloorParsedToPermitFeeNumberInOtherCosts: maxFloorNumberCalculatedInRangeFloorsPage,
                                    ),
                                    arguments: {
                                      'givenProjectName': widget
                                          .givenProjectName,
                                      //             'givenFloorRangesData': floorRangesData,
                                      //             'maxFloorParsedToPermitFeeNumberInOtherCosts': maxFloorNumberCalculatedInRangeFloorsPage,
                                    },
                                  );

                                }
                                else
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:  Text(
                                          'Error',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        content:  Text("If you selected permit fee uniformly either per ft²/m² or in total, input"
                                            " cannot be empty and should be a valid number "
                                            "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                            "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                            "A trailing decimal point (e.g., '1.') is not allowed.",style: TextStyle(

                                          fontSize: textFontSize,
                                        ),),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child:  Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }

                              else if (_isUniquePermitFeeTotalBool)

                              {
                                if (_uniqueTableTotalPermitFeeController.text.isNotEmpty
                                    && isValidNumber(_uniqueTableTotalPermitFeeController.text))

                                {
                                  totalPermitFee =  double.parse(_uniqueTableTotalPermitFeeController.text);
                                  double uniquePermitFe = (totalPermitFee / totalConstructedArea);
                                  UniquePermitFeeData data = UniquePermitFeeData(
                                    uniquePermitFeeTableProjectName: projectName1,
                                    uniquePermitFeeTableIsUniquePermitFeePerMeterBool: 0,
                                    uniquePermitFeeTableIsUniquePermitFeeTotalBool:  1 ,
                                    uniquePermitFeeTableUniquePermitFeePerMeter: uniquePermitFe,
                                    uniquePermitFeeTableUniquePermitFeeTotal: totalPermitFee,
                                  );

                                  await DifferentiatedCalculationDatabaseHelper.insertOrUpdateUniquePermitFeeData(data);

                                  await NavigationService().navigateToScreen(
                                    OtherCosts(
                                      givenProjectName: widget.givenProjectName,
                                      //              givenFloorRangesData: floorRangesData,
                                      //              maxFloorParsedToPermitFeeNumberInOtherCosts: maxFloorNumberCalculatedInRangeFloorsPage,
                                    ),
                                    arguments: {
                                      'givenProjectName': widget.givenProjectName,
                                      //             'givenFloorRangesData': floorRangesData,
                                      //              'maxFloorParsedToPermitFeeNumberInOtherCosts': maxFloorNumberCalculatedInRangeFloorsPage,
                                    },
                                  );
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:  Text(
                                          'Error',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        content:  Text("If you selected permit fee uniformly either per ft²/m² or in total, input"
                                            " cannot be empty and should be a valid number "
                                            "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                            "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                            "A trailing decimal point (e.g., '1.') is not allowed.",style: TextStyle(

                                          fontSize: textFontSize,

                                        ),),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child:  Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            }
                            else if (_isDifferentiatedPermitFeeBool) {
                              if (!floorsHaveChangedBool) {
                                await DifferentiatedCalculationDatabaseHelper.deleteUniquePermitFeeDataByProjectName(projectName1);
                                NavigationService().navigateToScreen(
                                  PermitFeeInputs(
                                    givenProjectName: widget.givenProjectName,
                                    floorRangesData: floorRangesData,
                                    maxFloorParsedToPermitFee: maxFloorNumberCalculatedInRangeFloorsPage,
                                  ),
                                  arguments: {
                                    'givenProjectName': widget.givenProjectName,
                                    'floorRangesData': floorRangesData,
                                    'maxFloorParsedToPermitFee': maxFloorNumberCalculatedInRangeFloorsPage,
                                  },
                                );
                              } else {
                                await DifferentiatedCalculationDatabaseHelper.deleteUniquePermitFeeDataByProjectName(projectName1);
                                await DifferentiatedCalculationDatabaseHelper.deletePermitFeeDataByProjectName(projectName1);
                                NavigationService().navigateToScreen(
                                  PermitFeeInputs(
                                    givenProjectName: widget.givenProjectName,
                                    floorRangesData: floorRangesData,
                                    maxFloorParsedToPermitFee: maxFloorNumberCalculatedInRangeFloorsPage,
                                  ),
                                  arguments: {
                                    'givenProjectName': widget.givenProjectName,
                                    'floorRangesData': floorRangesData,
                                    'maxFloorParsedToPermitFee': maxFloorNumberCalculatedInRangeFloorsPage,
                                  },
                                );
                              }
                            }
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            //  if (MediaQuery.of(context).viewInsets.bottom == 0)
            //    const MyBannerAdWidget(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
    );}}

class SegmentAreaTableRowData {
  String name;
  TextEditingController textField1Controller;
  int floorNumber;      
  int segmentNumber;
  SegmentAreaTableRowData({required this.name, required this.textField1Controller,
    required this.floorNumber,
    required this.segmentNumber,  });
}

class SegmentPermitFeeTableRowData {
  String name;
  TextEditingController textField2Controller;
  TextEditingController textField3Controller;
  int floorNumber;      // ADD THIS
  int segmentNumber;    // ADD THIS

  SegmentPermitFeeTableRowData({
    required this.name,
    required this.textField2Controller,
    required this.textField3Controller,
    required this.floorNumber,
    required this.segmentNumber,
  });
}

class SegmentAreaData {
  int id;
  String segmentNumber;
  double area;

  SegmentAreaData({required this.id, required this.segmentNumber, required this.area});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'segmentNumber': segmentNumber,
      'area': area,
    };
  }
}

class PermitFeeInputs extends StatefulWidget {
  final String givenProjectName;
  final List<List<dynamic>> floorRangesData;
  final int maxFloorParsedToPermitFee;
//  final int firstStartingFloorForPermitFee;

  const PermitFeeInputs({
    super.key, // Add the key parameter here
    required this.givenProjectName,
    required this.floorRangesData,
    required this.maxFloorParsedToPermitFee,
 //   required this.firstStartingFloorForPermitFee,
  }); // Pass the key to the superclass constructor

  @override
  State createState() => _PermitFeeInputsState();

}


class _PermitFeeInputsState extends State<PermitFeeInputs> {

  late String projectName1;
  late int givenMaxConstructionValue;
  List<SegmentAreaTableRowData> segmentAreaTableData = [];
  List<SegmentPermitFeeTableRowData> permitFeeTableData = [];
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController numberOfSegmentsController = TextEditingController();
  TextEditingController feeSimilarFloorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool segmentAreaTableVisible = false;
  bool feeSimilarFloorVisible = false;
  bool feeTableVisible = false;
  int permitFeePlanValue = 1;
  int floor = 0;
  int numberOfFeeSegmentsSaved = 0;
  int permitFeeNumberOfSimilarFloorsSaved = 0;
  late int startingFloor;
  bool checkMaxFeePlanNumber = false;
  bool hasData = false;
  late bool _permitFeePercentageSelected;
  late bool _permitFeePerMeterSelected;
  late bool _permitFeePricingFixedSelected;
  final _permitFeePercentageController = TextEditingController();
  final _permitFeePerMeterController = TextEditingController();
  double areaOfStartingFloor =0;
  List<List<dynamic>> floorRangesData =[];
  late int maxFloorGivenInPermitFee;
  int feeSimilarFloor = 0;
 

  @override
  void initState() {
    super.initState();
    projectName1 = widget.givenProjectName;
//    givenMaxConstructionValue = widget.givenMaxConstructionValue;
    floorRangesData = widget.floorRangesData;
    // This is the starting floor of the fee Plan 1, and next starting floors will be updated
    startingFloor = Provider.of<ProjectProviderData>(context, listen: false).firstStartingFloor;
    maxFloorGivenInPermitFee = widget.maxFloorParsedToPermitFee;
    _permitFeePercentageSelected = false;
    _permitFeePerMeterSelected = false;
    _permitFeePricingFixedSelected = true;

    checkPermitFeeData();
    _getMaxFloorNumber();
  }

  @override
  void dispose() {
    _permitFeePercentageController.dispose();
    _permitFeePerMeterController.dispose();
    super.dispose();
  }

// the check PermitFeeData method is not typically used within the build method of a widget,
// where the Consumer widget is commonly used. The Consumer widget is typically used
// within the build method of a widget to listen for changes to a ChangeNotifier and
// rebuild the UI when the ChangeNotifier changes. the Provider.of method is used
// to access the projectProviderData within the check PermitFeeData method. The listen: false parameter
// is used to prevent the check PermitFeeData method from rebuilding when the projectProviderData changes.

  void checkPermitFeeData() async {
    List<PermitFeeSegmentPricingData> data = await
        DifferentiatedCalculationDatabaseHelper.getPermitFeeSegmentFeeDataByFeePlan(
        widget.givenProjectName, 1);
    setState(() {
      hasData = data.isNotEmpty;
    });
    if (hasData) { // by pressing edit project if the given project name isn't _oozz comes up
      _onNewPermitFeePlanDataRetrieving(widget.givenProjectName, 1);
    }

    areaOfStartingFloor = getAreaForStartingFloor(startingFloor);
  }

  Future<void> _getMaxFloorNumber() async {
   // maxFloorGivenInPermitFee = (await DifferentiatedCalculationDatabaseHelper
    // .getMaxFloorNumberByProject(projectName1))!;
  /*  setState(() {
      // Update any UI that depends on maxFloor
    });*/
  }


  double getAreaForStartingFloor(int startingFloor) {
    for (List<dynamic> range in floorRangesData) {
      if ( startingFloor >= range[0] && startingFloor <= range[1]) {
        return range[2]; // Calculate and return the area for the starting floor
      }
    }
    throw Exception('Starting floor not found in any range');
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
              "Please fill all required fields. Inputs should be a valid number "
                  "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                  "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                  " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
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

  // generating fees if pricing manually is off
  void _permitFeeDataGenerating(BuildContext context, String projectName1, int feePlanValue, int permitFeeFloor,
      int permitFeeSegmentNumber, double permitFeePercentage, double permitFeePerMeter )
  async {

    // Retrieve the data from the StartingSimilar table in database
    PermitFeeStartingSimilarTableData? permitFeeStartingSimilarTableSegmentData = await
    DifferentiatedCalculationDatabaseHelper.getPermitFeeStartingSimilarTableSegmentData(
        projectName1, feePlanValue, permitFeeSegmentNumber);

    // Loop through the data and update the unitCost values for the other floors with the same segmentNumber
    List<PermitFeeSegmentPricingData> permitFeeSegmentPricingDataByFeePlan = await
    DifferentiatedCalculationDatabaseHelper.getPermitFeeSegmentFeeDataByFeePlan(projectName1, feePlanValue);
    // startingFloor Is a starting floor number but i- in the following lines is the number of
    // row in the price table shown in the screen
    int? stf = permitFeeStartingSimilarTableSegmentData?.permitFeeStartingSimilarTableStartingFloor;

    int feeTableStartingFloorIndex = 0;
    late double feeTableStartingFloorSegmentFee;
    late double updatedFeeTableStartingFloorSegmentFee;

    for (int i = 0; i < permitFeeSegmentPricingDataByFeePlan.length; i++) {
      if (permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableSegmentNumber == permitFeeSegmentNumber &&
          permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableFloorNumber == stf) {
        feeTableStartingFloorIndex = i;
        break;
      }
    }

    int j = 0;

    //  For floors other than starting floor data of permit fee is generating here
    for (int i = 0; i < permitFeeSegmentPricingDataByFeePlan.length; i++) {
      if (((permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableSegmentNumber) == permitFeeSegmentNumber) &&
          ((permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableFloorNumber) !=
              permitFeeSegmentPricingDataByFeePlan[feeTableStartingFloorIndex].permitFeeSegmentPricingTableFloorNumber)) {

        // first make the segmentPermitFee zero to be ensured they haven't previous values then initialize them later
        permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableSegmentFeePerMeter =0;
        permitFeeTableData[i].textField3Controller.text = '';

        feeTableStartingFloorSegmentFee =
            permitFeeSegmentPricingDataByFeePlan[feeTableStartingFloorIndex].permitFeeSegmentPricingTableSegmentFeePerMeter;

        if (permitFeePercentage != -4321) {
        updatedFeeTableStartingFloorSegmentFee = feeTableStartingFloorSegmentFee * pow(1 + permitFeePercentage / 100, j + 1);
        }
        else if (permitFeePerMeter!= -4321) {
        updatedFeeTableStartingFloorSegmentFee = feeTableStartingFloorSegmentFee + permitFeePerMeter* (j + 1);
        }else  {
          updatedFeeTableStartingFloorSegmentFee = feeTableStartingFloorSegmentFee;
        }

        String updatedSegmentFeeString = updatedFeeTableStartingFloorSegmentFee.toStringAsFixed(2);

        permitFeeSegmentPricingDataByFeePlan[i].permitFeeSegmentPricingTableSegmentFeePerMeter =
            double.parse(updatedSegmentFeeString);
        j++;

        permitFeeTableData[i].textField3Controller.text = updatedFeeTableStartingFloorSegmentFee.toStringAsFixed(2);
      }
    }

    setState(() {});
  }

  Future<void> _updatePermitFeePercentageData(int permitFeeStartingSimilarTableFloorNumber,
      int permitFeeStartingSimilarTableSegmentNumber,
      int permitFeeStartingSimilarTableSimilarFloor, int permitFeeStartingSimilarTableStartingFloor,
      int permitFeeStartingSimilarTableNumberOfSegments,  double permitFeeStartingSimilarTableFeePercentage,
      double permitFeeStartingSimilarTableFeePerMeter) 
  async {
    await DifferentiatedCalculationDatabaseHelper.insertOrUpdatePermitFeeStartingSimilarPercentageData(PermitFeeStartingSimilarTableData(
   //   permitFeeStartingSimilarTableId: await DifferentiatedCalculationDatabaseHelper.getNextPermitFeeStartingSimilarID(),
      permitFeeStartingSimilarTableProjectName: projectName1,
      permitFeeStartingSimilarTableSegmentNumber: permitFeeStartingSimilarTableSegmentNumber,
      permitFeeStartingSimilarTableStartingFloor:  permitFeeStartingSimilarTableStartingFloor,
      permitFeeStartingSimilarTableFeePlanNumber: permitFeePlanValue,
      permitFeeStartingSimilarTableSimilarFloor: permitFeeStartingSimilarTableSimilarFloor,
      permitFeeStartingSimilarTableNumberOfSegments: permitFeeStartingSimilarTableNumberOfSegments,
      permitFeeStartingSimilarTableFeePercentage: permitFeeStartingSimilarTableFeePercentage,
      permitFeeStartingSimilarTableFeePerMeter: permitFeeStartingSimilarTableFeePerMeter,
    ));
  }


  void saveCurrentSegmentOfFeeTableStartingFloor(int segmentNumber2) async {
    // Retrieve existing data
    PermitFeeStartingSimilarTableData? data =
    await DifferentiatedCalculationDatabaseHelper.getPermitFeeStartingSimilarTableSegmentData(
        projectName1, permitFeePlanValue, segmentNumber2);

    final similarFloor = feeSimilarFloorController.text.isNotEmpty
        ? permitFeeNumberOfSimilarFloorsSaved
        : (data?.permitFeeStartingSimilarTableSimilarFloor ?? 0);

    final numberOfSegments = numberOfSegmentsController.text.isNotEmpty
        ? numberOfFeeSegmentsSaved
        : (data?.permitFeeStartingSimilarTableNumberOfSegments ?? 0);

    final feePercentage = _permitFeePercentageSelected &&
        _permitFeePercentageController.text.isNotEmpty
        ? double.parse(_permitFeePercentageController.text)
        : (data?.permitFeeStartingSimilarTableFeePercentage ?? 0);

    final feePerMeter = _permitFeePerMeterSelected &&
        _permitFeePerMeterController.text.isNotEmpty
        ? double.parse(_permitFeePerMeterController.text)
        : (data?.permitFeeStartingSimilarTableFeePerMeter ?? 0);


    // Insert or update
    await DifferentiatedCalculationDatabaseHelper.insertOrUpdatePermitFeeStartingSimilarPercentageData(
      PermitFeeStartingSimilarTableData(
        permitFeeStartingSimilarTableProjectName: projectName1,
        permitFeeStartingSimilarTableSegmentNumber:
        int.parse(permitFeeTableData[segmentNumber2 - 1].name.split(' ')[4]),
        permitFeeStartingSimilarTableStartingFloor: startingFloor,
        permitFeeStartingSimilarTableFeePlanNumber: permitFeePlanValue,
        permitFeeStartingSimilarTableSimilarFloor: similarFloor,
        permitFeeStartingSimilarTableNumberOfSegments: numberOfSegments,
        permitFeeStartingSimilarTableFeePercentage: feePercentage,
        permitFeeStartingSimilarTableFeePerMeter: feePerMeter,
      ),
    );

    // Insert or update fee segments
    for (int i = 0; i < permitFeeTableData.length; i++) {
      await DifferentiatedCalculationDatabaseHelper.insertOrUpdatePermitFeeSegmentPricingData(
        PermitFeeSegmentPricingData(
          permitFeeSegmentPricingTableProjectName: projectName1,
          permitFeeSegmentPricingTableSegmentNumber:
          int.parse(permitFeeTableData[i].name.split(' ')[4].trim()),
          permitFeeSegmentPricingTableFloorNumber:
          int.parse(permitFeeTableData[i].name.split(' ')[1].trim()),
          permitFeeSegmentPricingTableFeePlanNumber: permitFeePlanValue,
          permitFeeSegmentPricingTableSegmentArea:
          permitFeeTableData[i].textField2Controller.text.isNotEmpty
              ? double.parse(permitFeeTableData[i].textField2Controller.text)
              : -4321,
          permitFeeSegmentPricingTableSegmentFeePerMeter:
          permitFeeTableData[i].textField3Controller.text.isNotEmpty
              ? double.parse(permitFeeTableData[i].textField3Controller.text)
              : -4321,
          permitFeeSegmentPricingTableTotalSegmentPermitFee:
          (permitFeeTableData[i].textField3Controller.text.isNotEmpty &&
              permitFeeTableData[i].textField2Controller.text.isNotEmpty)
              ? double.parse(permitFeeTableData[i].textField3Controller.text) *
              double.parse(permitFeeTableData[i].textField2Controller.text)
              : -4321,
        ),
      );
    }
  }

  Future<void> permitFeeCalculationForEachSegment()
    async {
      // The following fetch method should not be deleted because if you directly call insert method it will replace percentage data being saved with -4321, and also if both fetch and insert methods are deleted then If data is generated without pressing setting icon they won't be saved into the database
      List<Map<String, dynamic>> fetchPermitFeeStartingSimilarTableData = await
      DifferentiatedCalculationDatabaseHelper.fetchPermitFeeStartingSimilarTableData(projectName1,
          permitFeePlanValue);

    for (int i = 0; i < permitFeeTableData.length; i++) {
      double segmentArea = permitFeeTableData[i].textField2Controller.text.isNotEmpty
          ? double.parse(permitFeeTableData[i].textField2Controller.text)
          : -4321;
      double segmentFeePerMeter = permitFeeTableData[i].textField3Controller.text.isNotEmpty
          ? double.parse(permitFeeTableData[i].textField3Controller.text)
          : -4321;
      double segmentTotalFee = (segmentFeePerMeter != -4321 && segmentArea != -4321)
          ? segmentFeePerMeter * segmentArea
          : -4321;
      //  print('Segment $i: unitArea=$unitArea, unitCost=$unitCost, unitPrice=$unitPrice, costOfSegment=$costOfSegment, incomeOfSegment=$incomeOfSegment, profitOfSegment=$profitOfSegment');

      int floorNumber = int.parse(permitFeeTableData[i].name.split(' ')[1]);
      int segmentNumber = int.parse(permitFeeTableData[i].name.split(' ')[4]);
      await DifferentiatedCalculationDatabaseHelper.insertOrUpdatePermitFeeSegmentPricingData(PermitFeeSegmentPricingData(
        permitFeeSegmentPricingTableProjectName: projectName1,
        permitFeeSegmentPricingTableSegmentNumber: segmentNumber,
        permitFeeSegmentPricingTableFloorNumber: floorNumber,
        permitFeeSegmentPricingTableFeePlanNumber: permitFeePlanValue,
        permitFeeSegmentPricingTableSegmentArea: segmentArea,
        permitFeeSegmentPricingTableSegmentFeePerMeter: segmentFeePerMeter,
        permitFeeSegmentPricingTableTotalSegmentPermitFee: segmentTotalFee,
      ));


      bool isDataFound = false;
      for (int j = 0; j < fetchPermitFeeStartingSimilarTableData.length; j++) {
        if (fetchPermitFeeStartingSimilarTableData[j]['permitFeeStartingSimilarTableSegmentNumber']
            == segmentNumber) {
          isDataFound = true;
          break;
        }
      }
      if (!isDataFound) {
        await DifferentiatedCalculationDatabaseHelper.insertOrUpdatePermitFeeStartingSimilarPercentageData
          (PermitFeeStartingSimilarTableData(
          permitFeeStartingSimilarTableProjectName: projectName1,
          permitFeeStartingSimilarTableSegmentNumber: segmentNumber ,
          permitFeeStartingSimilarTableStartingFloor:  startingFloor,
     //     permitFeeStartingSimilarTableFloorNumber: floorNumber,
          permitFeeStartingSimilarTableFeePlanNumber: permitFeePlanValue,
          permitFeeStartingSimilarTableSimilarFloor: permitFeeNumberOfSimilarFloorsSaved,
          permitFeeStartingSimilarTableNumberOfSegments: numberOfFeeSegmentsSaved,
          permitFeeStartingSimilarTableFeePercentage: _permitFeePercentageSelected &&
              _permitFeePercentageController.text.isNotEmpty ?
          double.parse(_permitFeePercentageController.text) : -4321,
          permitFeeStartingSimilarTableFeePerMeter: _permitFeePerMeterSelected &&
              _permitFeePerMeterController.text.isNotEmpty ?
          double.parse(_permitFeePerMeterController.text) : -4321,
        ));
    }
    }
  }


  // icon in popup of MyTableOfInputs
  void permitFeeSettingIconButtonFunction(BuildContext context, int permitFeeIconButtonFloorNumber,
      int permitFeeIconButtonSegmentNumber, int permitFeeIconButtonSimilarFloor,
      int  permitFeeIconButtonStartingFloor, int permitFeeIconButtonNumberOfSegments)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeeChangeRateDialog(
            onPermitFeePercentageUpdate:  _updatePermitFeePercentageData,
            permitFeePercentageSelected: _permitFeePercentageSelected,
            onPermitFeeDataGenerating: _permitFeeDataGenerating,
            permitFeePerMeterSelected: _permitFeePerMeterSelected,
            permitFeeFixedSelected: _permitFeePricingFixedSelected,
            onPermitFeePercentageSelectedChanged: (bool value) {
              setState(() {
                _permitFeePercentageSelected = value;
              });
            },
            onPermitFeePerMeterSelectedChanged: (bool value) {
              setState(() {
                _permitFeePerMeterSelected = value;
              });
            },
            onPermitFeeFixedSelectedChanged: (bool value) {
              setState(() {
                _permitFeePricingFixedSelected = value;
              });
            },
            permitFeeTableSimilarFloor: permitFeeNumberOfSimilarFloorsSaved,
            startingFloor:  startingFloor,
            permitFeeTableProjectName : projectName1,
            permitFeeTableSegmentNumber : permitFeeIconButtonSegmentNumber,
            permitFeeTableNumberOfSegments : numberOfFeeSegmentsSaved,
            permitFeeTableFloorNumber : permitFeeIconButtonFloorNumber,
            permitFeeTableFeePlanNumber : permitFeePlanValue
        );
      },
    );
  }


  Future<void> checkPermitFeeVisibility() async {
    String project_ = projectName1;
    Map<String, int?> maxValues = await
       DifferentiatedCalculationDatabaseHelper.getMaxFeePlanFloorNumberByProjectName(project_);

    int maxFeePlanNumber = maxValues['maxFeePlan'] ?? 1;

    setState(() {
      checkMaxFeePlanNumber = permitFeePlanValue <= maxFeePlanNumber;
    }
    );
  }

  void retrieveRowByCondition(String projectName, int permitFeePlanValue) async {
    //  await DifferentiatedCalculationDatabaseHelper.retrieveRowByCondition(projectName, feeSegmentValue);
  }


  Future<bool> _onNewPermitFeePlanDataRetrieving(String projectName, int permitFeePlanValue)
  async {

    // Retrieve the data associated with project name and cpp value
    List<PermitFeeSegmentPricingData> retrievedPermitFeeTableData = await
      DifferentiatedCalculationDatabaseHelper.getPermitFeeSegmentFeeDataByFeePlan
      (projectName, permitFeePlanValue);

    int segmentNumber = retrievedPermitFeeTableData[0].permitFeeSegmentPricingTableSegmentNumber;

    if (retrievedPermitFeeTableData.isEmpty) {
    //  print('Debug: No permit fee data retrieved for projectName=$projectName, permitFeePlanValue=$permitFeePlanValue');
      return false;
    }

    //  int segmentNumber = retrievedPermitFeeTableData[0].permitFeeSegmentPricingTableSegmentNumber;

    List<PermitFeeStartingSimilarTableData> projectStartingSimilarData =
    await DifferentiatedCalculationDatabaseHelper.getPermitFeeStartingSimilarData(
      projectName,
      permitFeePlanValue,
    );

    // Update the area table data
    segmentAreaTableData.clear();
    for (int i = 0; i < projectStartingSimilarData[0].permitFeeStartingSimilarTableNumberOfSegments; i++) {
      String rowName = 'Floor ${projectStartingSimilarData[0].permitFeeStartingSimilarTableStartingFloor.toString()} Fee Segment ${i + 1}';
      int floorNumber = projectStartingSimilarData[0].permitFeeStartingSimilarTableStartingFloor;

      TextEditingController textField1Controller = TextEditingController(text:
      retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableSegmentArea.toString());
      segmentAreaTableData.add(SegmentAreaTableRowData(
          name: rowName, textField1Controller: textField1Controller,
        floorNumber: floorNumber,          // Index 2
        segmentNumber: segmentNumber, ));
    }

    // Use first segment's data as reference for floors and segments count
    int startingFloorGotten =
        projectStartingSimilarData[0].permitFeeStartingSimilarTableStartingFloor;
    int similarFloorCount =
        projectStartingSimilarData[0].permitFeeStartingSimilarTableSimilarFloor;
    int numberOfSegments =
        projectStartingSimilarData[0].permitFeeStartingSimilarTableNumberOfSegments;
    print('startingFloorGotten=$startingFloorGotten, permitFeePlanValue=$permitFeePlanValue');
    numberOfSegmentsController.text = numberOfSegments.toString();
    numberOfFeeSegmentsSaved = numberOfSegments;

    // Update the price table data
    permitFeeTableData.clear();
    List<String> segmentNumbers = [];
    for (int i = 0; i < similarFloorCount+1; i++)
    { for (int j = 0; j < numberOfSegments; j++) {
      segmentNumbers.add('Floor ${(startingFloorGotten+i).toString()} '
          'Fee Segment ${j + 1}');
    }}

    // Showing retrieved data in permit fee  table
    for (int i = 0; i < retrievedPermitFeeTableData.length; i++) {
      // Create the English format segment name
      String segmentName = 'Floor ${retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableFloorNumber} '
          'Fee Segment ${retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableSegmentNumber}';

      // Extract the raw segment number and floor number
      final segmentNumber = retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableSegmentNumber;
      final floorNumber = retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableFloorNumber;

      TextEditingController textField2Controller = TextEditingController(
        text: retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableSegmentArea.toString(),
      );

      TextEditingController textField3Controller = TextEditingController(
        text: retrievedPermitFeeTableData[i].permitFeeSegmentPricingTableSegmentFeePerMeter.toString(),
      );

      permitFeeTableData.add(SegmentPermitFeeTableRowData(
        name: segmentName,  // English format: "Floor X Fee Segment Y"
        textField2Controller: textField2Controller,
        textField3Controller: textField3Controller,
        floorNumber: floorNumber,     // Use extracted floor number
        segmentNumber: segmentNumber, // Use extracted segment number
      ));
    }


    // Update controllers for UI state
    feeSimilarFloorController.text = similarFloorCount.toString();
    permitFeeNumberOfSimilarFloorsSaved = similarFloorCount;
    startingFloor = startingFloorGotten;

    // Update the visibility of the area and price tables
    segmentAreaTableVisible = true;
    feeTableVisible = true;

    // Update the UI
    setState(() {});

    // Prevent the default back button behavior
    return false;
  }

  Future<void> _onBackPermitFeeButtonPressedCallback(BuildContext context)
  async {
    if (feeTableVisible)
    {
      bool allFieldsAreNotEmpty = true;

      //   for (SegmentPermitFeeTableRowData data in permitFeeTableData) {
      for (int i = 0; i < permitFeeTableData.length; i++) {
        if (permitFeeTableData[i].textField2Controller.text.isEmpty ||
            !isValidNumber(permitFeeTableData[i].textField2Controller.text) ||
            permitFeeTableData[i].textField3Controller.text.isEmpty ||
            !isValidNumber(permitFeeTableData[i].textField3Controller.text)) {
          allFieldsAreNotEmpty = false;
          // Show pop-up error here
          break;
        }
      }

      if (( allFieldsAreNotEmpty &&
          numberOfSegmentsController.text.isNotEmpty &&
          feeSimilarFloorController.text.isNotEmpty))
      {
        await permitFeeCalculationForEachSegment().then((_)
        {
          permitFeePlanValue--;
          if (permitFeePlanValue > 0) {
            segmentAreaTableData.clear();
            numberOfSegmentsController.clear();
            feeSimilarFloorController.clear();
            numberOfFeeSegmentsSaved = 0;
            permitFeeNumberOfSimilarFloorsSaved = 0;
            setState(() {
              segmentAreaTableVisible = false;
              feeSimilarFloorVisible = false;
              feeTableVisible = false;
            });
            _onNewPermitFeePlanDataRetrieving(projectName1, permitFeePlanValue);
            setState(() {});
          }
          else if (permitFeePlanValue == 0)
          {
            NavigationService().navigateToScreen(
              FloorRangesPage(
                givenProjectName: projectName1,
                // givenMaxConstructionValue: givenMaxConstructionValue,
                //    firstStartingFloorForFloorRangesPage: startingFloor,
              ),
            );
          }
        });}
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:  const Text(
                'Error',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              content:  const Text(
                "Please fill all required fields. \n\nNumber of segments can't be zero or negative."
                    "\n\nInputs should be a valid number "
                    "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                    "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                    " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                style: TextStyle(
                  fontSize:  20,
                ),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:  const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );}
    }
    else  {
      permitFeePlanValue--;
      if (permitFeePlanValue > 0) {
        _onNewPermitFeePlanDataRetrieving(projectName1, permitFeePlanValue);
        setState(() {});
      } else {
        NavigationService().navigateToScreen(
          FloorRangesPage(
            givenProjectName: projectName1,
            // givenMaxConstructionValue: givenMaxConstructionValue,
            //     firstStartingFloorForFloorRangesPage: startingFloor,
          ),
        );
      }
    }
  }

  void showEmptyRow(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Blank fields',  style: TextStyle(
            color: Colors.red,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),),
          content: const Text('To proceed, first enter the permit fee for this segment, '
              ' without modifying other data you entered before.',  style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
         //   fontWeight: FontWeight.bold,
          ),),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK',   style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkFloorAreaRange(BuildContext context,
      List<List<dynamic>> floorRangesData,
      int maxFloor,
      int startingFloor,
      int permitFeeSimilarFloor,
      double areaOfFeePlan,)
  async {
    bool isPossible = true;
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 37.0 : 20.0;
    
    for (int i = startingFloor;
    i <= startingFloor + permitFeeSimilarFloor; i++) {
      if (i > maxFloor) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:  Text(
              'Error',
              style: TextStyle(
                color: Colors.red, 
                fontSize: textFontSize,      
                fontWeight: FontWeight.bold, 
              ),
            ),

              content: SingleChildScrollView( // Wrap the content in SingleChildScrollView
                child: Text(
                  'It is not possible to have floor $i, because the highest '
                      'floor defined in the previous part is $maxFloor.'
                      '\n\nBe cautious: if you have designated the first floor as 0, your project '
                      'will have one additional floor. If you have also defined some underground levels, '
                      'the total number of floors in your project will equal the number of underground floors '
                      'plus the maximum floor plus one. '
                        '\n\n'
                    'For example, when a project has 3 basement floors and 5 above-ground floors, '
                              'the -3rd floor becomes the starting floor of the project, the ground floor '
                              'becomes floor 0, and the 5th above-ground floor becomes floor number 4.'
                              ' Therefore, in total, 8 floors are constructed. If, in this example,'
                              ' you consider the starting floor as floor 0 instead of the -3rd floor, '
                              'then the ground floor becomes floor 3, and the top floor becomes floor 7.'
                              ' However, it is better to start with negative numbers here since we have a basement, '
                              'as this provides a clearer description of the project and avoids confusion with'
                              ' buildings that have 8 above-ground floors.',
                  style:  TextStyle(color: Colors.black, 
                      fontSize:  isIpad ? 36 : 18, ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child:  Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.red, 
                      fontSize: textFontSize,   
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
      else {
        // Find the floor range that contains the current floor number
        int floorNumber = i;
        double floorArea = 0.0;
        for (List<dynamic> floorRange in floorRangesData) {
          if (floorNumber >= floorRange[0] && floorNumber <= floorRange[1]) {
            floorArea = floorRange[2];
            break;
          }
        }

        if (floorArea != areaOfFeePlan) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:  Text(
                    'Error',
                    style: TextStyle(
                      color: Colors.red, 
                      fontSize: textFontSize,      
                      fontWeight: FontWeight.bold, 
                    ),
                  ),

                content: Text('\nMake sure that the area for each floor among similar floors you entered '
                    'is equal to the area of the Fee Plan ($areaOfFeePlan) shown'
                    ' at the top of the page. '
                  'If there are any floors with different areas, they must belong to'
                    ' different fee plans and cannot be defined on the same page. \n\n '
                    'If there is just '
                    'one floor in the fee plan you should enter zero as the number of similar floors.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold,
                  ),),
                actions: [
                  ElevatedButton(
                    child:  Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.red, 
                        fontSize: textFontSize,      
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          isPossible = false;
        }
      }
    }

    return isPossible;
  }

  /*String formatNumberWithThousandSeparator(num number) {
    if (number == 0) {
      return '0';
    }

    if (number.isInfinite || number.isNaN) {
      return number.toString();
    }

    bool isNegative = number < 0;
    number = number.abs(); // Convert the number to its absolute value

    String formattedNumber = number.toStringAsFixed(
      number.truncateToDouble() == number ? 0 : 1,
    );

    // Check if the decimal part is zero
    bool isDecimalZero = number.truncateToDouble() == number;

    if (isDecimalZero) {
      // Number is an integer or has a decimal part that starts with 0
      if (number < 1000000) {
        formattedNumber = NumberFormat("#,###").format(int.parse(formattedNumber));
      } else {
        formattedNumber = NumberFormat("#,###.##").format(double.parse(formattedNumber));
      }
    } else {
      // Number has a non-zero decimal part
      formattedNumber = NumberFormat("#,###.#").format(double.parse(formattedNumber));
    }

    // Add the negative sign back if the original number was negative
    if (isNegative) {
      formattedNumber = "-$formattedNumber";
    }

    return formattedNumber;
  }*/

  bool isValidNumber(String input)
  {
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


  /* the tenX coefficient is calculated by finding the largest
  power of 10 that is a factor of the total cost, which is
  done by removing digits from the right side of the total
  cost until the remaining number of digits is divisible by 3.
   This allows for a consistent and easily comparable metric across different projects.*/



  @override
  Widget build(BuildContext context) {
    return  Consumer<ProjectProviderData>(
        builder: (context, projectProviderData, child) {
          
          double screenHeight = MediaQuery.of(context).size.height;

          final screenWidth = MediaQuery.of(context).size.width;
            // iPhone sizes (base)
          final double buttonWidthPhone = screenWidth *  0.7;
          const double fontSizePhone = 17.0;
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

          final textFontSize = isIpad ? fontSizePad : fontSizePhone;
          final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
          final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
          final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
          final double spacingHeight = isIpad ? 16.0 : 10.0;

          return Scaffold(
            body: Container(
              color: Colors.brown[100],
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding( padding: const EdgeInsets.fromLTRB(8,8,8,0),
                        /*  padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),*/
                          child: Column(
                            children: [

                             Container(
                               color: const Color(0xFF5E0209),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: screenWidth * 0.7,
                                          ),
                                          child: Text(
                                            projectProviderData.projectName == "***" ? " Permit Fee"
                                                : projectProviderData.projectName == "_oozz" ? "Permit Fee"
                                                : 'Permit Fee - ${projectProviderData.projectName}',
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
                                          'step 3/4 ',
                                          style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                         const SizedBox(height: 5,),
                
                             Container(
                               color: const Color(0xFF6E225A), // Set the background color of the container to purple
                              child: Row(
                                children: [
                                  const SizedBox(width: 15,),
                                   Text(
                                    'Fee Plan ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                       fontSize:  textFontSize,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: permitFeePlanValue.toString(),
                                          style:  TextStyle(
                                            color: const Color(0XFFEEFF41),
                                            fontWeight: FontWeight.bold,
                                             fontSize:  titleFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                
                                  // Expanded space
                                  const Expanded(
                                    child: SizedBox.shrink(),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      bool? shouldDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title:  Text('Delete this permit Fee Plan data?',
                                              style: TextStyle(
                                                fontSize: textFontSize,
                
                                                color: Colors.black54,
                                              ),),
                                            children: [
                                              SimpleDialogOption(
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(fontSize: textFontSize,
                                                    color: Colors.red,),
                                                  textAlign: TextAlign.center,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                              SimpleDialogOption(
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(fontSize: textFontSize,
                                                    color: Colors.blue,),
                                                  textAlign: TextAlign.center,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (shouldDelete == true) {
                                     await   DifferentiatedCalculationDatabaseHelper.deletePermitFeePlan
                                       (projectName1, permitFeePlanValue);
                                      permitFeePlanValue--;
                                      if (permitFeePlanValue > 0) {
                                        // If checkMaxFeePlanNumber is true, execute this code block
                                        _onNewPermitFeePlanDataRetrieving(projectName1, permitFeePlanValue);
                                        setState(() {});
                                        // if (maxFloor + permitFeeSimilarFloor > totalFloor)
                                      }}
                                    },
                                    icon: Icon(Icons.delete, color: Colors.white
                                      , size: iconSizeSmall,),
                                  ),
                
                                  IconButton(
                                      icon:  Icon(Icons.light_outlined,
                                          color: Colors.white, size: iconSizeLarge),
                                      onPressed: ()
                                        {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:  Text('Examples',  style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: titleFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                                content: Scrollbar(
                                                  thickness: 8.0, // Set the thickness of the scrollbar
                                                  radius: const Radius.circular(10), // Set the radius for rounded corners
                                                  thumbVisibility: true, // Always show the scrollbar thumb
                                                  child: SingleChildScrollView(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'In this part, you will find examples to help you better'
                                                                ' understand how to define the permit fee segments of the floor '
                                                                'you have defined in previous part. '
                                                                ' If you haven\'t read the guidance section yet, please '
                                                                'first click ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize * 1.2,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.help_center_rounded,
                                                              size: iconSizeSmall, // Adjust size as needed
                                                              color: Colors.deepPurple, // Match the text color
                                                            ),
                                                          ),
                                                           TextSpan(
                                                            text: ' icon at the bottom of the page and review it carefully. '
                                                                'Since working with permit fee tools is very similar to working '
                                                                'with cost price segments, which we covered in seven examples in the '
                                                                'previous part, we will provide just one example here to clarify the permit fee tools.'
                                                                '\n\n ',style: TextStyle(
                                                              fontSize: textFontSize * 1.2,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                
                                                             TextSpan(
                                                              text: "Example 1. Five-Floor Apartments With Parking",
                                                              style: TextStyle(
                                                                color: Colors.pink,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: '\nIn this construction project, we are assuming a total of five floors, '
                                                                  'including a parking floor, built on a plot of land measuring 5,000 ft². '
                
                                                              "The specifications of the floors are as follows:\n\n"
                                                            "▶ Floor 0 (Parking): This floor has a total area of 3,000 ft², which "
                                                                  "includes 2,700 ft² for parking and 300 ft² for the staircase, "
                                                                  "all with a permit fee of \$50/ft².\n\n"
                                                            "▶ Floor 1: This floor has a total area of 3,000 ft², which "
                                                                  "includes 2,000 ft² with a base permit fee of \$50/ft², "
                                                                  "800 ft² with an additional \$10 permit fee (totaling \$60/ft²), "
                                                                  "and the remaining 200 ft² with a permit fee of \$70/ft².\n\n"
                                                            "▶ Floors 2 to 4: Each of these floors also has a total area "
                                                                  "of 3,000 ft², which includes 2,000 ft², 800 ft², and 200 ft², "
                                                                  "with an arithmetic progression of \$2 in permit fees for each segment "
                                                                  "compared to its associated segment in Floor 1.\n\n"
                                                            "Therefore, to calculate the payment fee cost of the project, "
                                                                  "you can define two permit Fee Plans."
                
                                                                  '■ Permit Fee Plan 1:\n'
                                                                  '  ➔ The parking floor, that has one permit fee segment with 3,000 ft² area.\n'
                
                                                                  '■ Permit Fee Plan 2:\n'
                                                                  '  ➔ floors 1, 2, 3 and 4 each with 3 permit fee segments which areas 2,000 ft²,'
                                                                  ' 800 ft² and 200 ft².\n'
                
                                                                  'Configure permit fee segments as follows:',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "\n\nFee Plan 1, parking floor:\n",
                                                              style: TextStyle(
                                                                color: Colors.green, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: "1. Set Number of Permit Fee Segments of the First Floor:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: "▶ The first floor is parking (floor 0), enter 1 as "
                                                                  "the number of permit fee segments in this floor,"
                                                                  " because the parking has a unique permit fee per ft².\n\n",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: "2. Input Area Measurements:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: '▶ For the Floor 0 - Segment 1 enter 3,000 ft².\n',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "\n3. Enter Number of Similar Floors:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text:
                                                              "▶ Enter 0 because there is no floor similar to parking floor. \n\n",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "4. Set Permit Fee:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: '▶ Press the Set Fees button and in the displayed table,'
                                                                  "\n▶ for Floor 0 - Segment 1 (full parking floor) input "
                                                                  "cost 50 that will be considered per ft².",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "\n\n5. Finalize this FeePlan:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                
                                                             TextSpan(
                                                              text: "▶ Press ",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                            WidgetSpan(
                                                              child: Icon(
                                                                Icons.arrow_forward_ios,
                                                                size: iconSizeSmall, // Adjust size as needed
                                                                color: Colors.red, // Match the text color
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: " icon at the bottom of the page and proceed "
                                                                  "through the next permit Fee Plan to define the permit fee segments for the upper floors.\n\n",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "Fee Plan 2, floors 1 to 4:\n",
                                                              style: TextStyle(
                                                                color: Colors.green, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "1. Set Number of Permit Fee Segments of the First Floor:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: '▶ The first floor in permit fee 2 is floor 1. '
                                                                  'This floor includes segments with \$50, \$60 and \$70 permit fees. '
                                                                  'Therefore, enter 3 as the number of permit fee segments for this floor.',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: "2. Input Area Measurements:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: '▶ Press Set Area button and for the Floor 0 - Segment 1, enter 3,000.'
                                                                  'for the Floor 0 - Segment 2, enter 800 and for the Floor 0 - Segment 3, enter 200.\n',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "\n3. Enter Number of Similar Floors:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text:
                                                              "▶ In the section for the number of similar floors, "
                                                                  "enter 3. This is because Floors 2, 3, and 4 share the "
                                                                  "same permit fee segment configuration as Floor 1. \n\n",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "4. Set Permit Fees:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: '▶ Press the Set Fees button.\n'
                                                                  "\n▶ In the displayed table, there are three rows for each floor, totaling 6 "
                                                                  "rows, with each row assigned to a permit fee segment. "
                                                                  "\n\n▲ ➔ For Floor 1 - Segment 1 (property with 2,000 ft² area), "
                                                                  'manually enter the permit fee of 50 (meaning \$50/ft²).'
                                                                  '\n\n➔ For the corresponding segments on the upper floors (Floors 2, 3, and 4) '
                                                                   ' you can either manually enter the permit fees '
                                                                  ' or press ⚙️ icon at the end '
                                                                  'of the row for Floor 1 - Segment 1. If you press ⚙️ icon, a window will appear '
                                                                  'enter 2 in "Incremental" and press ok'
                                                                  "\n\n▲ ➔ For Floor 1 - Segment 2 (property with 800 ft² area), "
                                                                  'manually enter the permit fee of 60.'
                                                                  '\n\n➔ For the corresponding segments, with 800 ft², on the upper floors (Floors 2, 3, and 4) '
                                                                  ' press ⚙️ icon in Floor 1 - Segment 2 and enter 2 in "Incremental" and press ok'
                                                                  "\n\n▲ ➔ For Floor 1 - Segment 3 (property with 200 ft² area), "
                                                                  'manually enter the permit fee of 70.'
                                                                  '\n\n➔ For the corresponding segments on the upper floors (Floors 2, 3, and 4) '
                                                                  ' press ⚙️ icon in Floor 1 - Segment 3 and enter 2 in "Incremental" and press ok',
                
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "\n\n5. Finalize this FeePlan:\n",
                                                              style: TextStyle(
                                                                color: Colors.blue, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                
                                                             TextSpan(
                                                              text: "▶ Since there are no additional floors, you do not need "
                                                                  "to define a new permit fee, just fill other costs in"
                                                                  " next page then press the ",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                                                            WidgetSpan(
                                                              child: Icon(
                                                                Icons.leaderboard_outlined,
                                                                size: iconSizeSmall, // Adjust size as needed
                                                                color: Colors.red, // Match the text color
                                                              ),
                                                            ),
                                                             TextSpan(
                                                              text: " icon to see the result of your investment. "
                                                                  "This icon is only visible if the permit fees for "
                                                                  "all floors have been defined.\n\n",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: "A Numerical Illustration:\n",
                                                              style: TextStyle(
                                                                color: Colors.teal, // Title color
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text: 'Let’s determine the return on investment for this project '
                                                                  'given the following parameters:\n\n',
                                                              style: TextStyle(  color: Colors.black,
                                                                fontSize: textFontSize * 1.2,),
                                                            ),
                                                             TextSpan(
                                                              text: 'Floor Specifications and Calculations\n\n'
                                                                  'Floor 0 (Parking)\n'
                                                                  'Total Area: 3,000 ft²\n'
                                                                  'Permit Fee: \$50/ft²\n'
                
                                                                  'Permit Cost = 3,000 ft² × 50 USD/ft² = 150,000 USD\n\n'
                                                                  'Floor 1\n'
                                                                  'Total Area: 3,000 ft²\n'
                                                                  'Permit Fees:\n'
                                                                  '2,000 ft² at \$50/ft²\n'
                                                                  '800 ft² at \$60/ft²\n'
                                                                  '200 ft² at \$70/ft²\n'
                
                                                                  'Floor 1 Permit Cost = (2,000 ft² × 50 USD/ft²) + (800 ft² × 60 USD/ft²) + (200 ft² × 70 USD/ft²)\n'
                                                                  'Floor 1 Permit Cost = 100,000 USD + 48,000 USD + 14,000 USD = 162,000 USD\n\n'
                                                                  'Floor 2\n'
                                                                  'Total Area: 3,000 ft²\n'
                                                                  'Permit Fees:\n'
                                                                  '2,000 ft² at \$52/ft² (increased by \$2 from Floor 1)\n'
                                                                  '800 ft² at \$62/ft² (increased by \$2 from Floor 1)\n'
                                                                  '200 ft² at \$72/ft² (increased by \$2 from Floor 1)\n'
                
                                                                  'Floor 2 Permit Cost = (2,000 ft² × 52 USD/ft²) + (800 ft² × 62 USD/ft²) + (200 ft² × 72 USD/ft²)\n'
                                                                  'Floor 2 Permit Cost = 104,000 USD + 49,600 USD + 14,400 USD = 168,000 USD\n\n'
                                                                  'Floor 3\n'
                                                                  'Total Area: 3,000 ft²\n'
                                                                  'Permit Fees:\n'
                                                                  '2,000 ft² at \$54/ft² (increased by another \$2 from Floor 2)\n'
                                                                  '800 ft² at \$64/ft² (increased by another \$2 from Floor 2)\n'
                                                                  '200 ft² at \$74/ft² (increased by another \$2 from Floor 2)\n'
                
                                                                  'Floor 3 Permit Cost = (2,000 ft² × 54 USD/ft²) + (800 ft² × 64 USD/ft²) + (200 ft² × 74 USD/ft²)\n'
                                                                  'Floor 3 Permit Cost = 108,000 USD + 51,200 USD + 14,800 USD = 174,000 USD\n\n'
                                                                  'Floor 4\n'
                                                                  'Total Area: 3,000 ft²\n'
                                                                  'Permit Fees:\n'
                                                                  '2,000 ft² at \$56/ft² (increased by another \$2 from Floor 3)\n'
                                                                  '800 ft² at \$66/ft² (increased by another \$2 from Floor 3)\n'
                                                                  '200 ft² at \$76/ft² (increased by another \$2 from Floor 3)\n'
                
                                                                  'Floor 4 Permit Cost = (2,000 ft² × 56 USD/ft²) + (800 ft² × 66 USD/ft²) + (200 ft² × 76 USD/ft²)\n'
                                                                  'Floor 4 Permit Cost = 112,000 USD + 52,800 USD + 15,200 USD = 180,000 USD\n\n'
                                                                  'Summary of Permit Costs\n'
                                                                  'Floor 0 (Parking): 150,000 USD\n'
                                                                  'Floor 1: 162,000 USD\n'
                                                                  'Floor 2: 168,000 USD\n'
                                                                  'Floor 3: 174,000 USD\n'
                                                                  'Floor 4: 180,000 USD\n\n'
                                                                  'Total Permit Cost Calculation\n'
                                                                  'Total Permit Cost = Floor 0 + Floor 1 + Floor 2 + Floor 3 + Floor 4\n'
                                                                  'Total Permit Cost = 150,000 USD + 162,000 USD + 168,000 USD + 174,000 USD + 180,000 USD = 834,000 USD',
                                                              style: TextStyle(
                                                                fontSize: textFontSize * 1.2,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                
                                                             TextSpan(
                                                              text:  '\n\nAssume that the following parameters have been established:\n\n'
                                                                  '➔ Total Land Cost: \$2,000,000\n'
                                                                  '➔ Total Construction Costs: \$5,454,000\n'
                
                                                                  '➔ Total Income: \$11,124,000\n\n'
                                                                  'To determine the total costs, we will sum the land cost, total construction costs, and permit fees that is calculated above,'
                                                                  ' and then deduct this sum from the total income:\n\n'
                                                                  '➔ Total Permit Fees: \$834,000\n\n'
                                                                  '➔ Total Costs = Total Land Cost + Total Construction Costs + Total Permit Fees\n'
                                                                  '   = \$2,000,000 + \$5,454,000 + \$834,000 = \$8,288,000\n\n'
                
                                                                  '➔ Profit Calculation:\n'
                                                                  '   - Profit = Total Income - Total Costs\n'
                                                                  '   - Profit = \$11,124,000 - \$8,288,000 = \$2,836,000\n\n'
                                                                  '➔ Profit Percentage:\n'
                                                                  '   - Profit Percentage = (Profit / Total Income) × 100\n'
                                                                  '   - Profit Percentage = (\$2,836,000 / \$11,124,000) × 100 ≈ 25.5%\n',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: textFontSize * 1.2,
                                                              ),
                                                            ),
                
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: textFontSize * 1.2,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                        Container(
                          color: const Color(0xFF794764),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text('Area of floor',style: TextStyle(
                                    fontSize:  textFontSize, color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Expanded( flex: 2,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: startingFloor.toString(),
                                          style:  TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                             fontSize:  titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '  =  ',
                                          style:  TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:  titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: areaOfStartingFloor.toString(),
                                          style:  TextStyle(
                                            color: const Color(0xffEEFF41),
                                            fontWeight: FontWeight.bold,
                                            fontSize:  titleFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                
                                    ],
                                  ),
                                ),
                              ),
                
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      //  const SizedBox(height: 10.0),
                                         Text('Number of Fee '
                                           ,style:  TextStyle(fontWeight: FontWeight.bold,
                                                 fontSize: textFontSize)),
                                        Row(
                                          children: [
                                             Text('Segments of Floor '
                                               ,style:  TextStyle(fontWeight: FontWeight.bold,
                                                 fontSize:  textFontSize,
                                               ),),
                                            Text(
                                              startingFloor.toString(),
                                              style:  TextStyle( fontSize:  titleFontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                
                                  Expanded(
                                      flex: 1,
                                      child: TextField(
                                      style:  TextStyle(fontSize:  textFontSize),
                                        controller: numberOfSegmentsController,
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white70,
                                        ),
                                        keyboardType: TextInputType.number,
                                      )
                                  ),
                
                              //    SizedBox(width: spacingHeight * 0.2),
                
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: ()
                                        async {
                                          permitFeeTableData.clear();
                                          feeTableVisible = false;
                                          bool? userConfirmed = false;
                                          feeSimilarFloorController.text = "";
                                          if (numberOfSegmentsController.text.isNotEmpty &&
                                              isValidNumber(numberOfSegmentsController.text) &&
                                              int.parse(numberOfSegmentsController.text)>0) {
                                            numberOfFeeSegmentsSaved = int.parse(numberOfSegmentsController.text);
                                            if (numberOfFeeSegmentsSaved > 10)
                                            {
                                              userConfirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:  Text('Confirm Input', style: TextStyle(
                                                      fontSize:  textFontSize,
                                                    ),),
                                                    content:  Text('You have entered a big '
                                                        'number. Here you should enter permit fee segments not the area '
                                                        'of the floor or other data. Are you sure '
                                                        'you have this number of fee segments?', style: TextStyle(
                                                      fontSize:  textFontSize,
                                                    ),),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(false);
                                                        },
                                                        child:  Text('No', style: TextStyle(
                                                          fontSize:  textFontSize,
                                                        ),),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(true);
                                                        },
                                                        child:  Text('Yes', style: TextStyle(
                                                          fontSize:  textFontSize,
                                                        ),),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (userConfirmed == true)
                                              {
                                                segmentAreaTableData.clear();
                                                await checkPermitFeeVisibility();
                                                for (int i = 0; i < numberOfFeeSegmentsSaved; i++) {
                                                  String segmentName = 'Floor $startingFloor Fee Segment ${i + 1}';
                                                  int floorNumber = startingFloor;
                                                  int segmentNumber = i + 1;
                                                  segmentAreaTableData.add(SegmentAreaTableRowData(
                                                    name: segmentName,
                                                    textField1Controller: TextEditingController(),
                                                    floorNumber: floorNumber,
                                                    segmentNumber: segmentNumber,
                                                  ));
                                                }
                                                setState(() {});
                                                segmentAreaTableVisible = true;
                                                feeSimilarFloorVisible = true;
                                              } else {
                                                setState(() { segmentAreaTableVisible = false;
                                              feeSimilarFloorVisible = false;});
                                              }
                                            }
                                            else {
                                              segmentAreaTableData.clear();
                
                                            await checkPermitFeeVisibility();
                                            for (int i = 0; i < numberOfFeeSegmentsSaved; i++)
                                            {
                                              String segmentName = 'Floor $startingFloor Fee Segment ${i + 1}';
                                              int floorNumber = startingFloor;
                                              int segmentNumber = i + 1;
                                              segmentAreaTableData.add(SegmentAreaTableRowData(
                                                name: segmentName,
                                                textField1Controller: TextEditingController(),
                                                floorNumber: floorNumber,
                                                segmentNumber: segmentNumber,
                                              ));
                                            }
                                            setState(() {
                                              segmentAreaTableVisible = true;
                                            feeSimilarFloorVisible = true;});
                                            {
                                          }}}
                                          else
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text(
                                                    'Error',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: textFontSize,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                
                                                  content:  Text(
                                                    "Please fill all required fields. \n\nNumber of segments can't be zero or negative."
                                                        "\n\nInputs should be a valid number "
                                                        "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                        "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                        " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                                    style: TextStyle(
                                                      fontSize:  textFontSize,
                                                    ),),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              204, 8, 107, 1.0),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                
                                            ),
                                          ),
                                        ),
                                        child:  Text('Set Areas',
                                          overflow: TextOverflow.ellipsis, // Prevent text from wrapping
                                          style: TextStyle(
                                             fontSize: textFontSize, // Adjust font size if necessary
                                          ),),
                                      ),
                                    ),
                                  ),
                
                             //    SizedBox(width: spacingHeight * .5),
                                 ],
                              ),
                            ),
                
                            Visibility(
                              visible: ((int.tryParse(numberOfSegmentsController.text) != null &&
                                  (int.tryParse(numberOfSegmentsController.text)! > 0)) || segmentAreaTableVisible),
                              child: Column(
                                children: [
                                  LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      int? numRows = 2;
                                      double rowHeight = screenHeight * 0.05;
                                      double contentHeight = rowHeight * numRows + rowHeight;
                                      double maxHeight = contentHeight > rowHeight *3 ?
                                       rowHeight *3 : contentHeight;
                
                                      return Container(
                                        color: Colors.white60,
                                        height: maxHeight,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: isIpad ?
                                          DataTable(
                                            headingRowHeight: rowHeight,
                                            dataRowMaxHeight: rowHeight * 0.8,
                
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                            return const Color.fromRGBO(150, 1, 76, 1.0); // Set the background color of the header row to a pale brick color
                                          }),
                                            columnSpacing: 10, // Optional: Adjust the column spacing if needed
                                            horizontalMargin: 18, // Decrease the horizontal margin to make the columns closer
                
                                            columns:   [
                                              DataColumn(label: Text('Segment Number',
                                                  style: TextStyle(color: Colors.white
                                                      , fontSize:  textFontSize ))),
                                              DataColumn(label: Text('Segment Area',
                                                  style: TextStyle(color: Colors.white
                                                      , fontSize:  textFontSize ))),
                                            ],
                                            rows: [
                                              ...segmentAreaTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name,
                                                      style: TextStyle(fontSize: textFontSize))),
                                                  DataCell(Container(color: Colors.white,
                                                    child: TextField(
                                                      controller: row.textField1Controller,
                                                      keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: textFontSize ) ),
                                                  )),
                                                ],
                                              )),
                                            ],
                                          )
                                          :
                                          DataTable(
                                            headingRowHeight: rowHeight,
                                            //             dataRowMaxHeight: rowHeight * 0.8,
                
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                              return const Color.fromRGBO(150, 1, 76, 1.0); // Set the background color of the header row to a pale brick color
                                            }),
                                            columnSpacing: 10, // Optional: Adjust the column spacing if needed
                                            horizontalMargin: 18, // Decrease the horizontal margin to make the columns closer
                
                                            columns:   [
                                              DataColumn(label: Text('Segment Number',
                                                  style: TextStyle(color: Colors.white
                                                      , fontSize:  textFontSize ))),
                                              DataColumn(label: Text('Segment Area',
                                                  style: TextStyle(color: Colors.white
                                                      , fontSize:  textFontSize ))),
                                            ],
                                            rows: [
                                              ...segmentAreaTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name,
                                                      style: TextStyle(fontSize: textFontSize))),
                                                  DataCell(Container(color: Colors.white,
                                                    child: TextField(
                                                        controller: row.textField1Controller,
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: textFontSize ) ),
                                                  )),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                 SizedBox(height: spacingHeight,),
                
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                  //          (!(maxFloorGivenInPermitFee == (startingFloor )) )?
                                       //     Text('Number of floors with \nsimilar permit segments?')
                                            Expanded( flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //  const SizedBox(height: 10.0),
                                                   Text('Number of Similar '
                                                       ,style: TextStyle(fontWeight: FontWeight.bold,
                                                           fontSize: textFontSize)),
                                                  Row(
                                                    children: [
                                                       Text('Floors to Floor  '
                                                           ,style: TextStyle(fontWeight: FontWeight.bold,
                                                               fontSize: textFontSize )),
                                                      Text(
                                                        startingFloor.toString(),
                                                        style:  TextStyle( fontSize:  titleFontSize ,
                                                            fontWeight: FontWeight.bold,color: Colors.teal),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ) ,
                                                 //:   SizedBox(width: isIpad ? 26.0 : 5.0),
                
                                //            (!(maxFloorGivenInPermitFee == (startingFloor )) ) ?
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                color: Colors.white,
                                                child: TextField(
                                                  style:  TextStyle(fontSize:  textFontSize),
                                                  controller: feeSimilarFloorController,
                                                  decoration: const InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white70,
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ),
                                            ),
                                     //           : SizedBox(width: isIpad ? 60.0 : 45.0),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Expanded(
                                                flex: 2,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // ✅ Close keyboard immediately
                                                    FocusScope.of(context).unfocus();
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                 //   int numberOfSegments = int.tryParse(numberOfSegmentsController.text) ?? 0;
                
                                                    if ( //(!(maxFloorGivenInPermitFee == (startingFloor )) ) &&
                                                        (numberOfSegmentsController.text.isEmpty ||
                                                            !isValidNumber(numberOfSegmentsController.text)) ||
                                                            int.parse(numberOfSegmentsController.text) <= 0)
                                                    {
                                                      // Show error dialog if similarFloor or numberOfSegments is invalid
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title:  Text(
                                                              'Error',
                                                              style: TextStyle(
                                                                color: Colors.red,       
                                                                fontSize: textFontSize,            
                                                                fontWeight: FontWeight.bold, 
                                                              ),
                                                            ),
                                                            content:  Text(
                                                              "Number of segments can not be zero or negative or decimal.",
                                                              style: TextStyle(fontSize: textFontSize),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child:  Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                    color: Colors.red, 
                                                                    fontSize: textFontSize,      // Optional: adjust size as needed
                                                                    fontWeight: FontWeight.bold, 
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    else // Validate emptiness of similar floors input
                                                      if (!(maxFloorGivenInPermitFee == startingFloor) &&
                                                          (feeSimilarFloorController.text.isEmpty || !isValidNumber(feeSimilarFloorController.text)))
                                                      {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                'Error',
                                                                style: TextStyle(
                                                                color: Colors.red,
                                                                fontSize: textFontSize,
                                                                fontWeight: FontWeight.bold,
                                                            ),
                                                            ),
                                                              content: Text('Number of similar floors can not be negative or decimal. if'
                                                                  ' this is the only floor with this permit fee enter zero as the number of similar floors.',
                                                                style: TextStyle(fontSize: textFontSize),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child:  Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                      color: Colors.red,
                                                                      fontSize: textFontSize,      // Optional: adjust size as needed
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }

                                                    else {

                                                        // Calculate the sum of areas entered for the segments
                                                        double sumOfSegmentAreas = 0.0;
                                                        for (var segment in segmentAreaTableData) {
                                                          if (!isValidNumber(segment.textField1Controller.text)) {
                                                            await showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title:  Text(
                                                                    'Error',
                                                                    style: TextStyle(
                                                                      color: Colors.red,
                                                                      fontSize: textFontSize,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  content: Text(
                                                                    "Area of all segments should be a valued number. \n\nInputs should be a valid number "
                                                                        "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                                        "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                                        " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                                                    style: TextStyle(fontSize: textFontSize),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.of(context).pop(),
                                                                      child: const Text('OK',
                                                                          style: TextStyle(fontSize: 22,
                                                                              color: Colors.blue, fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            return;
                                                          }
                                                          sumOfSegmentAreas += double.parse(segment.textField1Controller.text);
                                                        }


                                                        if (sumOfSegmentAreas != areaOfStartingFloor)
                                                        {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  'Error',
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: textFontSize,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),

                                                                content: Text('The area of the segment, or the total area of '
                                                                    'the segments, you entered for this floor does not equal to '
                                                                    'the area of the floor indicated at the top of the page.',
                                                                  style: TextStyle(
                                                                    fontSize: textFontSize,
                                                                    color: Colors.black87, fontWeight: FontWeight.bold,
                                                                  ),),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                        color: Colors.red,
                                                                        fontSize: textFontSize,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          return;
                                                        }


                                                        int numberOfFloorsDifferences = (int.parse(feeSimilarFloorController.text)) - permitFeeNumberOfSimilarFloorsSaved;

                                                        // Set numberOfFeeSegmentsSaved
                                                        numberOfFeeSegmentsSaved =
                                                            int.parse(numberOfSegmentsController.text);
                                                        permitFeeNumberOfSimilarFloorsSaved =
                                                            int.parse(feeSimilarFloorController.text);

                                                        bool isValid = true;

                                                        isValid = await checkFloorAreaRange(
                                                          context,
                                                          floorRangesData,
                                                          maxFloorGivenInPermitFee,
                                                          startingFloor,
                                                          permitFeeNumberOfSimilarFloorsSaved,
                                                          sumOfSegmentAreas,
                                                        );

                                                        if (!isValid) {
                                                          print('Debug: checkFloorAreaRange returned false');
                                                          return;
                                                        }

                                                        permitFeeTableData.clear();
                                                        await checkPermitFeeVisibility();

                                                        List<String> segmentName = [];
                                                        permitFeeNumberOfSimilarFloorsSaved = feeSimilarFloorController.text.isEmpty ? 0 :
                                                        int.tryParse(feeSimilarFloorController.text) ?? 0;

                                                        for (int i = 0; i < permitFeeNumberOfSimilarFloorsSaved + 1; i++) {
                                                          for (int j = 0; j < numberOfFeeSegmentsSaved; j++) {
                                                            String segmentName = 'Floor ${startingFloor + i} Fee Segment ${j + 1}';
                                                            int floorNumber = startingFloor + i;
                                                            int segmentNumber = j + 1;
                                                            permitFeeTableData.add(SegmentPermitFeeTableRowData(
                                                              name: segmentName,
                                                              segmentNumber: segmentNumber,
                                                              floorNumber: floorNumber,
                                                              textField2Controller: TextEditingController(),
                                                              textField3Controller: TextEditingController(),
                                                            ));
                                                          }
                                                        }


                                                          // Initializing Segmentareas in permit fee  table
                                                          int row_ = 0;
                                                          for (int i = 0; i < permitFeeNumberOfSimilarFloorsSaved + 1; i++) {
                                                            for (int j = 0; j < numberOfFeeSegmentsSaved; j++) {
                                                              permitFeeTableData[row_].textField2Controller.text =
                                                                  segmentAreaTableData[j].textField1Controller.text;
                                                              row_++;
                                                            }
                                                          }
                                                          feeTableVisible = true;
                                                        if (checkMaxFeePlanNumber && (numberOfFloorsDifferences!= 0)) {
                                                          await DifferentiatedCalculationDatabaseHelper.updatePermitFeeData(projectName1,
                                                              permitFeePlanValue, numberOfFloorsDifferences);
                                                        }
                                                        }


                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor:  const Color.fromRGBO(
                                                        194, 3, 99, 1.0),
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                       topLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10),
                
                                                      ),
                                                    ),
                                                  ),
                                                  child:  Text('Set Fees',
                                                    overflow: TextOverflow.ellipsis, // Prevent text from wrapping
                                                    style: TextStyle(
                                                       fontSize: textFontSize, // Adjust font size if necessary
                                                    ),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                
                            Visibility(
                              visible: feeTableVisible ,
                              child: Padding(padding: const EdgeInsets.all(8),
                                           //         padding: const EdgeInsets.fromLTRB(30, 10, 38, 5),
                
                                child: Container(
                                  color: Colors.white60,
                               //   height: 230.0,
                                child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: WidgetStateProperty.all(Colors.brown[500]), // Set the color of the scrollbar thumb
                                      radius: const Radius.circular(25), // Add rounded corners to the scrollbar thumb
                                    ),
                
                                    child: Scrollbar(
                          //            thumbVisibility: true,
                                      controller: _scrollController,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _scrollController,
                            //            scrollbarOrientation: ScrollbarOrientation.top,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: isIpad ?
                                          DataTable(
                                            headingRowHeight: screenHeight * 0.06,
                                            dataRowMaxHeight: screenHeight * 0.04,
                
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                            return const Color.fromRGBO(150, 1, 76, 1.0); // Set the background color of the header row to a pale brick color
                                          }),
                                            columnSpacing: 11, // Optional: Adjust the column spacing if needed
                                            horizontalMargin: 11,
                                            columns:  [
                                               DataColumn(label: Text('Floor-Segment \nNumber'
                                                   , style: TextStyle(color: Colors.white,
                                                fontSize: textFontSize  ,))),
                                               DataColumn(label: Text('Segment \n Area'
                                                   ,  style: TextStyle(color: Colors.white,
                                                     fontSize: textFontSize  ,))),
                                               DataColumn(label: Text('Permit Fee \n(ft²/m²)'
                                                   ,style: TextStyle(color: Colors.white,
                                                     fontSize: textFontSize ,))),
                                              const DataColumn(label: Text('', style: TextStyle(fontSize: 16))
                                              ),
                                            ],
                                            rows: [
                                              ...permitFeeTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name
                                                      ,style: TextStyle(fontSize:  textFontSize ,) )),
                                                  DataCell(TextField(
                                                    controller: row.textField2Controller, //unit area
                                                    keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                    readOnly: true, style: TextStyle(fontSize: textFontSize )
                                                  )),
                                                  DataCell(Container(color: Colors.white,
                                                    child: TextField(
                                                      controller: row.textField3Controller,
                                                      keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: textFontSize ) ),
                                                  )),
                                                  (row.name.split(' ')[1]==  startingFloor.toString()
                                                      ) ?
                                                  DataCell(IconButton(
                                                      icon:  Icon(Icons.settings_applications_sharp,
                                                      size: iconSizeLarge,), // setting
                                                    onPressed: () {
                                                      String rowName = row.name.split(' ')[0];
                                                      String segmentNumber = row.name.split(' ')[4];  // ✅ Index 4 for permit fee
                                                      String numberOfSegmentsValue = numberOfSegmentsController.text;

                                                      // ✅ Permit Fee: ONLY textField3 (fee) + basic fields
                                                      if (rowName.isNotEmpty &&
                                                          numberOfSegmentsValue.trim().isNotEmpty &&
                                                          segmentNumber.isNotEmpty &&
                                                          row.textField3Controller.text.trim().isNotEmpty) {  // ✅ ALWAYS check fee field

                                                        int? floor = int.tryParse(row.name.split(' ')[1]);
                                                        int? segmentNumberInt = int.tryParse(segmentNumber);

                                                        if (floor != null && segmentNumberInt != null) {
                                                          saveCurrentSegmentOfFeeTableStartingFloor(segmentNumberInt);
                                                          permitFeeSettingIconButtonFunction(context, floor, segmentNumberInt,
                                                              permitFeeNumberOfSimilarFloorsSaved, startingFloor, numberOfFeeSegmentsSaved);
                                                        } else {
                                                          showEmptyRow(context);
                                                        }
                                                      } else {
                                                        showEmptyRow(context);  // ✅ Triggers when fee field (textField3) is empty
                                                      }
                                                    },

                                                  )) : DataCell(Container()), // show IconButton if condition is true, otherwise show empty container
                                                ],
                                              )),
                                            ],
                                          )
                                          :
                                          DataTable(
                                            headingRowHeight: screenHeight * 0.06,
                                            //    dataRowMaxHeight: screenHeight * 0.04,
                
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                              return const Color.fromRGBO(150, 1, 76, 1.0); // Set the background color of the header row to a pale brick color
                                            }),
                                            columnSpacing: 11, // Optional: Adjust the column spacing if needed
                                            horizontalMargin: 11,
                                            columns:  [
                                              DataColumn(label: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text('Floor-Segment \nNumber'
                                                    , style: TextStyle(color: Colors.white,
                                                      fontSize: textFontSize  ,)),
                                              )),
                                              DataColumn(label: Text('Segment \n Area'
                                                  ,  style: TextStyle(color: Colors.white,
                                                    fontSize: textFontSize  ,))),
                                              DataColumn(label: Text('Permit Fee \n(ft²/m²)'
                                                  ,style: TextStyle(color: Colors.white,
                                                    fontSize: textFontSize ,))),
                                              const DataColumn(
                                                label:  Text(''),
                                              ),
                                            ],
                                            rows: [
                                              ...permitFeeTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name
                                                      ,style: TextStyle(fontSize:  textFontSize ,) )),
                                                  DataCell(TextField(
                                                      controller: row.textField2Controller, //unit area
                                                      keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                      readOnly: true, style: TextStyle(fontSize: textFontSize )
                                                  )),
                                                  DataCell(Container(color: Colors.white,
                                                    child: TextField(
                                                        controller: row.textField3Controller,
                                                        keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: textFontSize ) ),
                                                  )),
                                                  (row.name.split(' ')[1]==  startingFloor.toString()
                                                      && (permitFeeNumberOfSimilarFloorsSaved) > 0) ?
                                                  DataCell(IconButton(
                                                      icon:  Icon(Icons.settings_applications_sharp,
                                                        size: iconSizeLarge,), // setting
                                                    onPressed: () {
                                                      String rowName = row.name.split(' ')[0];
                                                      String segmentNumber = row.name.split(' ')[4];  // ✅ Index 4 for permit fee
                                                      String numberOfSegmentsValue = numberOfSegmentsController.text;


                                                      // ✅ Permit Fee: ONLY textField3 (fee) + basic fields
                                                      if (rowName.isNotEmpty &&
                                                          numberOfSegmentsValue.trim().isNotEmpty &&
                                                          segmentNumber.isNotEmpty &&
                                                          row.textField3Controller.text.trim().isNotEmpty) {  // ✅ ALWAYS check fee field

                                                        int? floor = int.tryParse(row.name.split(' ')[1]);
                                                        int? segmentNumberInt = int.tryParse(segmentNumber);

                                                        if (floor != null && segmentNumberInt != null) {
                                                          saveCurrentSegmentOfFeeTableStartingFloor(segmentNumberInt);
                                                          permitFeeSettingIconButtonFunction(context, floor, segmentNumberInt,
                                                              permitFeeNumberOfSimilarFloorsSaved, startingFloor, numberOfFeeSegmentsSaved);
                                                        } else {
                                                          showEmptyRow(context);
                                                        }
                                                      } else {
                                                        showEmptyRow(context);  // ✅ Triggers when fee field (textField3) is empty
                                                      }
                                                    },
                                                  )) : DataCell(Container()), // show IconButton if condition is true, otherwise show empty container
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                        //scrollbar        ),
                              ),
                            ),
                          ),
                            ) ],
                            ),
                        ),
                      ),
                      ),
                
                
                    SafeArea(
                      top: false,
                  child: LayoutBuilder (
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView (
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.home,  color: Colors.purple[900],
                                    size: iconSizeLarge),
                                onPressed: () async {
                                  if (!feeTableVisible){
                                    NavigationService().navigateToScreen(
                                      LandInputs(
                                          givenProjectName: projectName1),
                                    );
                                  }
                                  else {
                                    bool allFieldsAreNotEmpty = true;
                                    for (SegmentPermitFeeTableRowData data in permitFeeTableData) {
                                      if (data.textField2Controller.text.isEmpty ||
                                          !isValidNumber(data.textField2Controller.text) ||
                                          data.textField3Controller.text.isEmpty ||
                                          !isValidNumber(data.textField3Controller.text)) {
                                        allFieldsAreNotEmpty = false;
                                        break;
                                      }
                                    }
                                    if (allFieldsAreNotEmpty &&
                                        numberOfSegmentsController.text.isNotEmpty ) {
                                      await permitFeeCalculationForEachSegment();
                                      NavigationService().navigateToScreen(
                                        LandInputs(givenProjectName: projectProviderData.projectName),
                                      );
                                    }
                                    else if (
                                    (!allFieldsAreNotEmpty || numberOfSegmentsController.text.isEmpty)) {
                                      // Show confirmation dialog
                                      bool? shouldProceed = await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        // Prevent dismissing by tapping outside
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text(
                                              'Confirm Return and Deletion',
                                             
                                              style: TextStyle(fontSize: isIpad ? 40.0 : 22.0, color: Colors.purple, fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              'Are you sure you want to return to the first page without filling in all the entries'
                                                  ' and saving this section\'s information? If you press yes this permit fee plan and its data will be deleted.',
                                              
                                              style: TextStyle(fontSize: isIpad ? 37.0 : 20.0, color: Colors.black87),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false), // No
                                                child: Text(
                                                  'No',
                                                  
                                                  style: TextStyle(fontSize: isIpad ? 37.0 : 20.0, color: Colors.red, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(true), // Yes
                                                child: Text(
                                                  'Yes',
                                                  
                                                  style: TextStyle(fontSize: isIpad ? 37.0 : 20.0, color: Colors.blue, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // If user confirmed OR dismissed dialog (null), proceed with deletion and navigation
                                      if (shouldProceed == true) {
                                        Navigator.of(context).pop();
                                        await DifferentiatedCalculationDatabaseHelper
                                            .deletePermitFeePlan(
                                            projectName1,
                                            permitFeePlanValue
                                        );

                                        NavigationService().navigateToScreen(
                                          LandInputs(givenProjectName: projectName1),
                                        );
                                      }
                                      else {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                }
                                ),
                            const SizedBox(width: 22,),
                
                            IconButton(
                                icon:  Icon(Icons.arrow_back_ios,  color: Colors.purple[900],
                                    size: iconSizeLarge),
                              onPressed: () async {
                                areaOfStartingFloor = getAreaForStartingFloor(startingFloor);
                                _onBackPermitFeeButtonPressedCallback(context);

                              },
                            ),
                
                            const SizedBox(width: 22.0),
                
                            IconButton(
                                icon:
                                Icon(Icons.arrow_forward_ios,  color: Colors.purple[900],
                                    size: iconSizeLarge),
                                onPressed: ()
                                async {
                                  bool allFieldsAreNotEmpty = true;

                                  for (SegmentPermitFeeTableRowData data in permitFeeTableData) {
                                    if (data.textField2Controller.text.isEmpty ||
                                        !isValidNumber(data.textField2Controller.text) ||
                                        data.textField3Controller.text.isEmpty ||
                                        !isValidNumber(data.textField3Controller.text)) {
                                      allFieldsAreNotEmpty = false;
                                      break;
                                    }
                                  }

                                  if (!allFieldsAreNotEmpty || numberOfSegmentsController.text.isEmpty
                                      || !feeTableVisible) {
                                    //   print('Debug: Missing or invalid fields in permitFeeTableData');
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:  Text(
                                            'Error',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          content:  Text(
                                            "Please fill all required fields. You must click the "
                                            'Set Fee button and fill in all the entries in the table. '
                                                "\n\nInputs should be a valid number "
                                                "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                            style: TextStyle(
                                              fontSize:  textFontSize,
                                            ),),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child:  Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  await permitFeeCalculationForEachSegment();

                                  if ((startingFloor + permitFeeNumberOfSimilarFloorsSaved) < maxFloorGivenInPermitFee)
                                  {
                                    permitFeePlanValue++;
                                    await checkPermitFeeVisibility();

                                    if (checkMaxFeePlanNumber) {

                                      await _onNewPermitFeePlanDataRetrieving(projectName1, permitFeePlanValue);
                                    } else {
                                      segmentAreaTableData.clear();
                                      numberOfSegmentsController.clear();
                                      feeSimilarFloorController.clear();
                                      setState(() {
                                        segmentAreaTableVisible = false;
                                        feeSimilarFloorVisible = false;
                                        feeTableVisible = false;
                                        startingFloor = startingFloor + permitFeeNumberOfSimilarFloorsSaved + 1;
                                        areaOfStartingFloor = getAreaForStartingFloor(startingFloor);
                                      });
                                    }
                                  }
                                  else {

                                    try {
                                      await NavigationService().navigateToScreen(
                                        OtherCosts(
                                          givenProjectName: widget.givenProjectName,
                                          //                givenFloorRangesData: floorRangesData,
                                          //                  givenMaxFloorNumberInOtherCosts: maxFloorGivenInPermitFee,
                                        ),
                                        arguments: {
                                          'givenProjectName': widget.givenProjectName,
                                          //                    'givenFloorRangesData': floorRangesData,
                                          //                    'givenMaxFloorNumberInOtherCosts': maxFloorGivenInPermitFee,
                                        },
                                      );
                                    }
                                    catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text(
                                              'Error',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            content:  Text(
                                              'Error navigating to the next page.',
                                              style: TextStyle(
                                                fontSize:  textFontSize,
                                              ),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:  Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: textFontSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                  setState(() {});

                                },
                              ),
                
                            const SizedBox(width: 22.0),
                
                          /*  Visibility(
                              visible: (feeTableVisible && (maxFloorGivenInPermitFee ==
                                  (startingFloor + (int.tryParse(feeSimilarFloorController.text) ?? 0)))),
                
                              child: IconButton(
                                icon:
                                Icon(Icons.add_chart_outlined,  color: Colors.purple[900],
                                    size: iconSizeLarge),
                                onPressed: () async {
                                  bool allFieldsAreNotEmpty = true;
                
                                  for (SegmentPermitFeeTableRowData data in permitFeeTableData) {
                                    if (data.textField2Controller.text.isEmpty ||
                                        !isValidNumber(data.textField2Controller.text) ||
                                        data.textField3Controller.text.isEmpty ||
                                        !isValidNumber(data.textField3Controller.text)
                                    ) {
                                      allFieldsAreNotEmpty = false;
                                      break;
                                    }
                                  }
                
                                  if (feeTableVisible && allFieldsAreNotEmpty
                                      && numberOfSegmentsController.text.isNotEmpty)
                                  {
                
                
                                    setState(() {
                                      showOtherCost = false;
                                      feeTableVisible = false;
                                      segmentAreaTableVisible = false;
                                      feeSimilarFloorVisible = false;
                                      showResult = true;
                                    });
                                    await permitFeeCalculationForEachSegment();
                                  }
                                  else
                                  {
                                    // Show a popup dialog with an error message
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:  Text(
                                            'Error',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                
                                          content:  Text('Please fill in all text fields in the price table.',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child:  Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              ),
                            ),*/
                
                            Visibility( visible: (feeTableVisible && hasData) ,
                              child: IconButton(
                                icon:  Icon(Icons.done_all,
                                    color: Colors.deepPurple, size: iconSizeLarge),
                                onPressed: () async {
                                  await permitFeeCalculationForEachSegment();
                                  NavigationService().navigateToScreen(
                                    OtherCosts(
                                      givenProjectName: widget.givenProjectName,
                                      //        givenMaxConstructionValue: widget.givenMaxConstructionValue,
                                //      givenFloorRangesData: floorRangesData,
                                //      maxFloorParsedToPermitFeeNumber: maxFloorGivenInPermitFee,
                               //                     givenFirstStartingFloorForPermitFee: startingFloor,
                                    ),
                                    arguments: {
                                      'givenProjectName': widget
                                          .givenProjectName,
                                      //      'givenMaxConstructionValue': widget.givenMaxConstructionValue,
                              //        'givenFloorRangesData': floorRangesData,
                              //        'maxFloorParsedToPermitFeeNumber': maxFloorGivenInPermitFee,
                              //                      'givenFirstStartingFloorForPermitFee': startingFloor,
                                    },
                                  );
                                },),
                            ),
                
                            const SizedBox(width: 22.0),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:  Text('Permit Fee',  style: TextStyle(
                                        fontSize: titleFontSize,
                                        color: Colors.teal,fontWeight: FontWeight.bold,
                                      ),),
                                      content: SingleChildScrollView(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'What is permit fee?',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  color: Colors.pink,fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\nThe permit fee in real estate construction refers to the '
                                                    'charges imposed by municipality or other local governments for the approval and '
                                                    'issuance of permits necessary for construction projects. '
                                                    'These fees can vary significantly based on several factors, '
                                                    'including the type of project, the built-up area, and the '
                                                    'project\'s estimated value, etc. Therefore, it is essential '
                                                    'to obtain permit fee information from municipality '
                                                    'authorities or construction experts in the region where you plan to invest.'
                                                   '\n\nIn this app, the permit fee should be defined for each square foot/meter of '
                                                    'the built-up area of the floors you defined in the previous part. '
                                                    'This includes common areas such as staircases that are not for sale, as '
                                                    'well as usable areas that are for sale. This calculation should be made '
                                                    'regardless of their sell price or construction costs. '
                                                    'If you have the total permit fee, not permit fee per square foot/meter, you can skip '
                                                    'this part by entering zero for all permit fees. Instead,'
                                                    ' add total permit cost to the "other costs" on the first page.'
                                                    '\n\nJust as we used the concepts of "Cost-Price Segment" and "Cost-Price Plan" '
                                                    'in the previous part, to provide flexibility in defining permit fees, we '
                                                    'will now use similar concepts called "Permit Fee Segment" and "Fee Plan"'
                                                    ' in this app, defined as follows:',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                
                                               TextSpan(
                                                text: '\n\n\nWhat is a Permit Fee Segment?\n',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  color: Colors.pink,fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nIn this app, each "permit fee segment" represents an area of a floor '
                                                    'with a different permit fee per square foot/meter (ft²/m²) compared to other areas on that floor.\n\n'
                                                    'For example, if a floor has a total area of 2,500 ft² '
                                                    'divided into segment areas of 1,400 ft² and 1,100 ft², '
                                                    'each with different permit fees, the floor will have two permit fee segments.\n\n'
                                                    '■ It is not necessary for the permit fee segments on each floor '
                                                    'to correspond to individual properties for sale. \n\nFor instance, '
                                                    'on the mentioned floor, the segment of 1,400 ft² could include '
                                                    'two properties of 750 ft² each. \n\n'
                                                    '■ There is no relationship between number of saleable units, the permit fee segments '
                                                    'and the cost-price segments on each floor. \n\nFor instance, one floor '
                                                    'may have \n- Two saleable units of 100 ft² each,'
                                                    '\n -Only one cost-price segment if '
                                                    'the construction cost and sell price per ft² is constant across the floor '
                                                    '\n - Three permit fee segments with areas of 120, 50, and '
                                                    '30 ft² with different permit fees.\n\n'
                                                    'Therefore, define permit fee segments on each floor as needed, '
                                                    'regardless of the number of properties or number of cost-price '
                                                    'segments on that floor.\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                
                                               TextSpan(
                                                text: '\n\nWhat is a Fee Plan?',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  color: Colors.pink,fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\nEach Fee Plan represents a unique financial design of a floor’s '
                                                    'permit fee structure that can be applied to a set of '
                                                    'contiguous floors starting from the floor. Each '
                                                    'floor within a Fee Plan contains one or '
                                                    'more permit fee segments, and may share similar fee plan '
                                                    'configurations—both in number and area—with other floors. '
                                                    '\n\nFor example, if a building has a parking floor of 2,500 ft² '
                                                    'as the ground floor, and three floors above it with '
                                                    'segment areas of 1,400 ft² and 1,100 ft², each having '
                                                    'different permit fees per ft², you can define the '
                                                    'Fee Plans and segments as follows:\n\n'
                                                    '▲ Fee Plan 1: Parking floor with one permit fee segment with 2,500 ft²\n\n'
                                                    '▲ Fee Plan 2: Floors 1, 2, and 3, each with two permit fee '
                                                    'segments: one of 1,000 ft² and another of 1,500 ft².\n\n'
                                                    '■ There is no need to know the total number of Fee Plans in '
                                                    'advance. Simply proceed with the steps for defining permit fee '
                                                    'segments, and once you reach the highest floor in your project, '
                                                    'the number of Fee Plans will be determined.\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                
                                               TextSpan(
                                                text: '\n\nHow to set permit fee segments?',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  color: Colors.pink,fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n▶ 1. First, define the number of permit fee segments for the first '
                                                    'floor of the current Fee Plan and press the "Set Areas" button to set '
                                                    'the area of fee segments in table that will be shown.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n▶ 2. To define the area of each segment on a floor, it is essential that '
                                                    'the sum of the areas of these fee segments equals the total area of that floor, '
                                                    'which is indicated at the top of the page in yellow. Next, you should enter the '
                                                    'number of similar floors, which refers to floors that have the same number'
                                                    ' of permit fee segments with identical areas. This means that for each fee segment on the first '
                                                    'floor in the Fee Plan, there is a fee segment with an equal area in the other '
                                                    'floors of the Fee Plan.'
                                                    '\n\nEach Fee Plan consists of the first floor plus the number of similar floors. '
                                                    'In our example, the first floor of Fee Plan 2 is Floor 1, so you should enter '
                                                    '2 as the number of similar floors. Therefore, the total '
                                                    'number of floors in Fee Plan 2 is 3.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n▶ 3. By pressing "Set Fees" button you can enter the permit fee per ft²/m²'
                                                    ' for each segment.' ,
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                
                                               TextSpan(
                                                text: '\n\n▶ 4. Use ⚙️'
                                                    ' icon available to set the permit fee for the segments of the first floor '
                                                    'in this Fee Plan. Pressing this icon will allow you to set the '
                                                    'permit fee of similar segments in upper floors in this Fee Plan '
                                                    'by choosing either an arithmetic progression or a geometric progression, otherwise, '
                                                    'You can enter the permit fee for each fee segment manually.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n▶ 5. If you do not want to change the permit fee of each segment, '
                                                    'instead of entering manually costs,'
                                                    ' simply press the ⚙️ icon and Do Not enter any values for '
                                                    'arithmetic progression or geometric progression;'
                                                    ' just press OK on the dialog to set the same permit fee for '
                                                    'the corresponding segments on the upper floors. ',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n ◆ Arithmetic progression means that the permit fee per ft² '
                                                    'of each segment will increase or decrease by a fixed amount from one segment to the next. '
                                                    'For example, if the permit fee of segments with an area of 1000 ft² on '
                                                    'the first floor of this Fee Plan is set to \$10, and you set an arithmetic '
                                                    'progression of \$5 for similar segments on the upper floors in the Fee Plan, '
                                                    'then by pressing OK, the permit fee for the segments with an area of 1000 ft² on '
                                                    'the floor 2 will be \$15, and for the floor number 3, it will be \$20.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n ◆ Geometric progression means that the permit fee per ft² of each fee '
                                                    'segment will increase or decrease by a fixed percentage from one segment to the next. '
                                                    'For example, if the cost/ft² of the segment with an area of 1500'
                                                    ' ft² on the first floor of the Fee Plan is \$300, and you set a geometric progression '
                                                    'of 2, then the Fee Plan cost/ft² for similar segments meaning segments with an '
                                                    'area of 1500 ft² on floors 2 and 3 will increase by 2% to \$306 and \$312.12, respectively.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\n▶ 6. Once you have set all permit fees for all segments '
                                                    'of all floors in this Fee Plan, press ',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.arrow_forward_ios, // Use the settings icon from Material Icons
                                                  size: iconSizeSmall, // Adjust size as needed
                                                  color: Colors.red,
                                                ),
                                              ),
                                               TextSpan(
                                                text: ' icon if '
                                                    'you want to define a new Fee Plan for other floors, this icon will be shown when '
                                                    'you press Set Fees button. '
                                                    'When you reach to the highest floor, ',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.leaderboard_outlined,
                                                  size: iconSizeSmall, // Adjust size as needed
                                                  color: Colors.red,
                                                ),),
                                               TextSpan(
                                                text:
                                                ' icon appears and after filling last costs inputs like transaction costs, '
                                                    'you can press it to get the results. '
                                                    'For more clarification about permit fees, see the examples by pressing the icon ',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.light_outlined,
                                                  size: iconSizeSmall, // Adjust size as needed
                                                  color: Colors.red,
                                                ),),
                                               TextSpan(
                                                text: ' at the top of the page. '
                                                    '\n\n■ If you have previously defined and saved the project, '
                                                    'you can delete a Fee Plan from that project by pressing the '
                                                    'delete icon button at the top of this page. However, '
                                                    'it is advisable to carefully consider and '
                                                    'define the floors within their associated Fee Plans to avoid the need for deletion.'
                                                    '\n\n■ If you make any changes to the number of floors or the total area of '
                                                    'any floors in the cost-price segments part, you must redefine the permit '
                                                    'fees for all floors. Therefore, be cautious about defining the floors and '
                                                    'their areas before reaching this section for setting the permit fees.',
                                                style: TextStyle(
                                                  fontSize: textFontSize * 1.2,
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
                                          child:  Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon:  Icon(Icons.help_center_rounded
                                  ,color: Colors.purple[900], size: iconSizeLarge),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                     //     const MyBannerAdWidget(),
                            SizedBox(height:  spacingHeight *2),
                 ],
                ),
              ),
        ),
      );
     }
    );
  }
}

class FeeChangeRateDialog extends StatefulWidget {
  final bool permitFeePercentageSelected;
  final bool permitFeePerMeterSelected;
  final bool permitFeeFixedSelected;
  final ValueChanged<bool> onPermitFeePercentageSelectedChanged;
  final ValueChanged<bool> onPermitFeePerMeterSelectedChanged;
  final ValueChanged<bool> onPermitFeeFixedSelectedChanged;
  final Function(int, int,int, int,int, double, double) onPermitFeePercentageUpdate;
  final String permitFeeTableProjectName;
  final int permitFeeTableSegmentNumber;
  final int permitFeeTableSimilarFloor;
  final int startingFloor;
  final int permitFeeTableFeePlanNumber;
  final int permitFeeTableNumberOfSegments;
  final int permitFeeTableFloorNumber;
  final Function(BuildContext context, String, int, int, int, double, double) onPermitFeeDataGenerating;


  const FeeChangeRateDialog({
    super.key,
    required this.permitFeePercentageSelected,
    required this.permitFeePerMeterSelected,
    required this.permitFeeFixedSelected,
    required this.onPermitFeePercentageSelectedChanged,
    required this.onPermitFeePerMeterSelectedChanged,
    required this.onPermitFeeFixedSelectedChanged,
    required this.onPermitFeePercentageUpdate,
    required this.onPermitFeeDataGenerating,
    required this.permitFeeTableProjectName, required this.permitFeeTableSegmentNumber,
    required this.permitFeeTableSimilarFloor,required this.startingFloor,
    required this.permitFeeTableFloorNumber,required this.permitFeeTableFeePlanNumber,
    required this.permitFeeTableNumberOfSegments,
    //   required this.onSavePopup
  });

  @override
  FeeChangeRateDialogState createState() => FeeChangeRateDialogState();
}

class FeeChangeRateDialogState extends State<FeeChangeRateDialog> {
  late bool _permitFeePercentageSelected;
  late bool _permitFeePerMeterSelected;
  late bool _permitFeePricingFixedSelected;
  final _permitFeePercentageController = TextEditingController();
  final _permitFeePerMeterController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _permitFeePercentageSelected = widget.permitFeePercentageSelected;
    _permitFeePerMeterSelected = widget.permitFeePerMeterSelected;
    _permitFeePricingFixedSelected = widget.permitFeeFixedSelected;
    checkPermitFeePercentageData();
  }

  @override
  void dispose() {
    _permitFeePercentageController.dispose();
    _permitFeePerMeterController.dispose();
    super.dispose();
  }


  Future<void> checkPermitFeePercentageData()
  async {
    // Retrieve the project starting similar data from the database
    PermitFeeStartingSimilarTableData? data = await
         DifferentiatedCalculationDatabaseHelper.getPermitFeeStartingSimilarTableSegmentData(
        widget.permitFeeTableProjectName, widget.permitFeeTableFeePlanNumber,
             widget.permitFeeTableSegmentNumber);
    //   print('daaata.permitFeeStartingSimilarTableFeePercentage ${data?.permitFeeStartingSimilarTableFeePercentage}');

    // If the data is not null, set the text of the corresponding text fields and toggle buttons
    if (data != null ) {
// Never change these conditions, checking just boolean variables are wrong Because they're not saved in database to be retrieved
      if ( data.permitFeeStartingSimilarTableFeePercentage != -4321  &&
         data.permitFeeStartingSimilarTableFeePercentage != 0 ) {
        _permitFeePercentageController.text = data.permitFeeStartingSimilarTableFeePercentage.toString();
        _permitFeePerMeterController.text = '';
        setState(() {
          _permitFeePercentageSelected = true;
          _permitFeePricingFixedSelected = false;
          _permitFeePerMeterSelected = false;
        });
      }
      else if ( data.permitFeeStartingSimilarTableFeePerMeter != -4321
          && data.permitFeeStartingSimilarTableFeePerMeter != 0 ) {
        _permitFeePerMeterController.text = data.permitFeeStartingSimilarTableFeePerMeter.toString();
        _permitFeePercentageController.text = '';

        setState(() {
          _permitFeePerMeterSelected = true;
          _permitFeePricingFixedSelected = false;
          _permitFeePercentageSelected = false;
        });
      }  else
      { _permitFeePerMeterController.text = "";
      _permitFeePercentageController.text = "";
      setState(() {
        _permitFeePerMeterSelected = false;
        _permitFeePricingFixedSelected = true;
        _permitFeePercentageSelected = false;
      });}

    } else {
      setState(() {
        _permitFeePerMeterSelected = false;
        _permitFeePricingFixedSelected = true;
        _permitFeePercentageSelected = false;
      });
    }

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
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 37.0 : 20.0;
    
    return AlertDialog(
      backgroundColor: Colors.grey[900],

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
            //  color: Colors.purple,
              padding: const EdgeInsets.all(4),
              child:  Text('Based on the permit fee (per ft²/m²) of segment '
                        '${widget.permitFeeTableSegmentNumber} on this floor, specify the permit fee '
                        'of segments ${widget.permitFeeTableSegmentNumber} on the upper floors'
                                  ' of this Fee Plan by selecting one of '
                          'the options below.',
                          style:  TextStyle(
                            color: Colors.white, fontSize: textFontSize,
                          ),
                        ),
                            ),
            const SizedBox(height: 20),
            Container(alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Switch(
                    value: _permitFeePricingFixedSelected,
                    onChanged: (bool value) {
                      _permitFeePerMeterController.text = "";
                      _permitFeePercentageController.text = "";
                      setState(() {
                        _permitFeePercentageSelected = false;
                        _permitFeePerMeterSelected = false;
                        _permitFeePricingFixedSelected = value;
                      });
                      widget.onPermitFeeFixedSelectedChanged(value); },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Fixed',
                    style: TextStyle(
                      color: Colors.white, fontSize: textFontSize,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[

                Expanded(flex: 1,
                  child: Switch(
                    value: _permitFeePercentageSelected,
                    onChanged: (bool value) {
                      _permitFeePerMeterController.text = "";
                      setState(() {
                        _permitFeePercentageSelected = value;
                        _permitFeePerMeterSelected = false;
                        _permitFeePricingFixedSelected = false;
                        if (!_permitFeePercentageSelected) {
                          _permitFeePercentageController.text = '';
                        }
                      });
                      widget.onPermitFeePercentageSelectedChanged(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Text(
                    'Percentage',
                    style: TextStyle(
                      color: Colors.white, fontSize: textFontSize * 0.9,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _permitFeePercentageController,
                        readOnly: !_permitFeePercentageSelected,
                        decoration: InputDecoration(
                          hintText: '%',
                          hintStyle: TextStyle(color: Colors.black45,
                              fontSize: isIpad ? 30 : 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        keyboardType: TextInputType.number,
                        style:  TextStyle(color: Colors.black,
                            fontSize: isIpad ? 30 : 20),
                      ),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[

                Expanded(flex: 1,
                  child: Switch(
                    value: _permitFeePerMeterSelected,
                    onChanged: (bool value) {
                      _permitFeePercentageController.text = "";
                      setState(() {
                        _permitFeePercentageSelected = false;
                        _permitFeePerMeterSelected = value;
                        _permitFeePricingFixedSelected = false;
                        if (!_permitFeePerMeterSelected) {
                          _permitFeePercentageController.text = '';
                        }
                      });
                      widget.onPermitFeePerMeterSelectedChanged(value);
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(flex: 2,
                  child: Text(
                    'Incremental',
                    style: TextStyle(
                      color: Colors.white, fontSize: textFontSize * 0.9,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: _permitFeePerMeterController,
                        readOnly: !_permitFeePerMeterSelected,
                        decoration: InputDecoration(
                          hintText: 'per ft²/m²',
                          hintStyle: TextStyle(color: Colors.black38,
                              fontSize: isIpad ? 30 : 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        keyboardType: TextInputType.number,
                        style:   TextStyle(color: Colors.black,
                            fontSize: isIpad ? 30 : 20),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),

      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {

                // Perform action when OK button is pressed
                double permitFeePercent = -4321;
                double feePerMeter= -4321;

                // Check which toggle button is selected and get the associated text field value
                if (_permitFeePercentageSelected) {
                final text = _permitFeePercentageController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  permitFeePercent = double.parse(text);
                }
                } 
                else if (_permitFeePerMeterSelected) {
                final text = _permitFeePerMeterController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  feePerMeter= double.parse(text);
                }
                } 
                else  {
                  _permitFeePricingFixedSelected = true;
                permitFeePercent = 0;
                feePerMeter= 0;
                }

                if ((!_permitFeePricingFixedSelected && _permitFeePercentageController.text.isNotEmpty &&
                    isValidNumber(_permitFeePercentageController.text.replaceAll(',', ''))) ||
                    (!_permitFeePricingFixedSelected && _permitFeePerMeterController.text.isNotEmpty &&
                        isValidNumber(_permitFeePerMeterController.text.replaceAll(',', ''))) ||
                    _permitFeePricingFixedSelected)
                {
                  // Call the onPermitFeePercentageUpdate method to save the data to the database
                  widget.onPermitFeePercentageUpdate(widget.permitFeeTableFloorNumber, widget.permitFeeTableSegmentNumber,
                      widget.permitFeeTableSimilarFloor, widget.startingFloor,
                      widget.permitFeeTableNumberOfSegments, permitFeePercent, feePerMeter);

                  widget.onPermitFeeDataGenerating(context, widget.permitFeeTableProjectName, widget.permitFeeTableFeePlanNumber,
                      widget.permitFeeTableFloorNumber , widget.permitFeeTableSegmentNumber, permitFeePercent,feePerMeter);
                  Navigator.of(context).pop();
                } 
                else
                {
                  // Show error dialog if any input is invalid
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:  Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.red, 
                            fontSize: textFontSize,      
                            fontWeight: FontWeight.bold, 
                          ),
                        ),

                        content:  Text(
                          'Please ensure all fields are filled with valid numbers. '
                          'If you choose fixed switch to be On, Percentage and incremental'
                              ' text fields become empty so you should not input anything for them.\n\n '

                              'Digits and an optional decimal point only, like: 123, 123.5, '
                              '0.66, and must not include letters (e.g., a, b, c) or symbols '
                              '(e.g., \$, %, &). Additionally, trailing (e.g., .1)'
                              ' decimal points are not allowed.'
                              'Also, percentage value cannot be greater than 100.',
                          style: TextStyle(fontSize: textFontSize ),
                        ),
                        actions: [
                          TextButton(
                            child:  Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.red, 
                                fontSize: textFontSize,      
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

              },
              child:  Text('Set Rates'
                , style:  TextStyle(fontSize:  textFontSize),),
            ),
          ],
        ),
      ],
    );
  }
}



