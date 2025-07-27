import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ad_mob.dart';
import 'all_projects.dart';
import 'database.dart';
import 'land.dart';
import 'main.dart';
import 'navigation_service.dart';


class ResultPage1 extends StatefulWidget {
  const ResultPage1({super.key});


  @override
  State createState() => _ResultPage1State();
}

class _ResultPage1State extends State<ResultPage1> {

  bool _isFloorExpanded = false;
  bool _isConstructionExpanded = false;
  bool _isProjectExpanded = true;
  bool _isFloorSortedAscending = true;
  bool _isConstructionSortedAscending = true;
  int sortColumnIndex = 0;


  bool _isKeyMetricsExpanded = false;

  List<String> columnTitles = [
    'Land Area',
    'Total Number of Floors',
    'Ground Floor Constructed Area',
    'Ground Floor Constructed Percentage',
    'Total Common Area',
    'Total Salable Area',
    'Total Constructed Area',
    'Salable Area to Land Area',
    'Min Sell Price \n(ft²/m²)',
    'Max Sell Price \n(ft²/m²)',
    'Weighted Average Sale Price (ft²/m²)',
    'Land Price (ft²/m²) to Average Sale Price (ft²/m²)',
    'Average \nConstruction Cost \n(ft²/m²)',
    'Average Permission Cost \n(ft²/m²)',
    'Cost of Land',
    'Total Construction Cost',
    'Total Permission Cost',
    'Top roof and Yard Construction Costs',
    'Transaction Costs',
    'Other Costs',
    'Total Cost',
    'Total Income',
    'Total Profit',
    'Profit %',
    'Salable Area Required to Finance Land and Permission Costs',
    'Land and Permission Costs to Total Costs',
    'Total Cost per ft²/m² of Salable Area',
    'Profit per Salable Area',
    'Salable Area Constructed per 10x Currency Segments',
    'Number of Salable Properties',
    'Number of Salable Properties per 10x Currency Segments',
  ];

// Define a global key for the bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<List<List<dynamic>>> _getResultFloorData(String projectName) async {
    List<ProjectResultFloorData> floorData = await CompleteCalculationDatabaseHelper.getProjectResultFloorData(projectName);
    List<List<dynamic>> data = [];
    for (int i = 0; i < floorData.length; i++) {
      data.add([
        floorData[i].resultFloorTableCostPricePlan,
        floorData[i].resultFloorTableFloorNumber,
        floorData[i].resultFloorTableIncomeOfFloor,
        floorData[i].resultFloorTableCostOfFloor,

      ]);
    }
    return data;
  }

  Future<List<List<dynamic>>> _getResultConstructionData(String projectName) async {
    List<projectResultCppData> constructionData =
    await CompleteCalculationDatabaseHelper.getProjectResultCppData(projectName);
    List<List<dynamic>> data = [];
    for (int i = 0; i < constructionData.length; i++) {
      data.add([
        constructionData[i].resultCppTableCostPricePlan,
        constructionData[i].resultCppTableIncomeOfCostPricePlan,
        constructionData[i].resultCppTableCostOfCostPricePlan,
      ]);
    }
    return data;
  }

  Future<List<List<dynamic>>> _getResultTotalData(String projectName) async {
    List<ResultProjectColumnsClassData> projectData = await
    CompleteCalculationDatabaseHelper.getResultProjectColumnsClassData(projectName);
    List<List<dynamic>> data = [];
    for (int i = 0; i < projectData.length; i++) {
      data.add( [
        projectData[i].resultProjectTableLandArea,
        projectData[i].resultProjectTableTotalNumberOfFloorsText,
        projectData[i].resultProjectTableFloorZeroConstructedArea,
        projectData[i].resultProjectTableFloorZeroConstructedPercentage,
        projectData[i].resultProjectTableTotalCommonArea,
        projectData[i].resultProjectTableTotalSalableArea,
        projectData[i].resultProjectTableTotalConstructedArea,
        projectData[i].resultProjectTableTotalSalableAreaToLandArea,

        projectData[i].resultProjectTableSegmentMinSellPricePerMeter,
        projectData[i].resultProjectTableSegmentMaxSellPricePerMeter,
        projectData[i].resultProjectTableSegmentAverageSellPricePerMeter,
        projectData[i].resultProjectTableLandPricePerMeterToAverageSellPricePerMeter,

        projectData[i].resultProjectTableAverageConstructionCostPerMeter,
        projectData[i].resultProjectTableAveragePermissionCostPerMeter,
        projectData[i].resultProjectTableCostOfLand,
        projectData[i].resultProjectTableTotalConstructionCost,
        projectData[i].resultProjectTableTotalPermissionCost,
        projectData[i].resultProjectTableRoofAndYardConstructionCostsText,
        projectData[i].resultProjectTableTransactionCostsText,
        projectData[i].resultProjectTableOtherCostsText,
        projectData[i].resultProjectTableTotalCosts,
        projectData[i].resultProjectTableTotalIncome,
        projectData[i].resultProjectTableTotalProfit,
        projectData[i].resultProjectTableProfitPercentageOfProject,

        projectData[i].resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost,
        projectData[i].resultProjectTableLandPermissionCostsPerTotalCosts,
        projectData[i].resultProjectTableAllCostsIncurredPerMeterOfSalableArea,
        projectData[i].resultProjectTableProfitPerSalableArea,

        projectData[i].resultProjectTableSalableAreaConstructedPerMillionCurrencySegments,
        projectData[i].resultProjectTableNumberOfSalableProperties,
        projectData[i].resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments,
      ]
      );
    }
    return data;
  }

  Future<List<List<dynamic>>> getResultData(String projectName) async {
    List<ResultProjectColumnsClassData> projectData = await
    CompleteCalculationDatabaseHelper.getResultProjectColumnsClassData(projectName);
    List<List<dynamic>> resultData = [];

    for (int i = 0; i < projectData.length; i++) {
      resultData.add([
        projectData[i].resultProjectTableTotalIncome,
        projectData[i].resultProjectTableTotalCosts,
        projectData[i].resultProjectTableTotalProfit,
        projectData[i].resultProjectTableProfitPercentageOfProject,
      ]);
    }

    return resultData;
  }



  @override
  void initState() {
    super.initState();
  }

  List<List<dynamic>> sortData(List<List<dynamic>> data, int columnIndex, bool ascending) {
    data.sort((a, b) {
      if (ascending) {
        return a[columnIndex].compareTo(b[columnIndex]);
      } else {
        return b[columnIndex].compareTo(a[columnIndex]);
      }
    });
    return List.from(data); // Return a new instance of the sorted data
  }


  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<List<dynamic>> _sortData(List<List<dynamic>> data, int columnIndex, bool isAscending) {
    data.sort((a, b) {
      if (a[columnIndex] is String && b[columnIndex] is String) {
        return a[columnIndex].compareTo(b[columnIndex]) * (isAscending ? 1 : -1);
      } else if (a[columnIndex] is num && b[columnIndex] is num) {
        return (a[columnIndex] - b[columnIndex]) ~/ 1 * (isAscending ? 1 : -1);
      } else {
        return 0;
      }
    });
    return data;
  }

  void _showAddressBottomSheet(BuildContext context, String givenProjectName)
  async {

    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 30.0 : 20.0;


    final TextEditingController projectNameController = TextEditingController();
    final TextEditingController sociallyFriendlyController = TextEditingController();
    final TextEditingController environmentallyFriendlyController = TextEditingController();
    final TextEditingController provinceController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController buildingNumberController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController otherController = TextEditingController();


    double environmentallyFriendly = 1;
    double sociallyFriendly = 1;
    String costOfProject = '';
    String incomeOfProject = '';
    String profitOfProject = '';
    String profitPercentageOfProject = '';
    String nameOfProject = '';
    String calculationType = '';
    var projectData = context.read<ProjectData>();
    ProjectAddressData? addressData = await
        CompleteCalculationDatabaseHelper.getAddressProjectData(givenProjectName);

    // Update the text field and dropdown values based on the retrieved address data
    if (addressData != null && givenProjectName != "_oozz") {
      projectNameController.text = givenProjectName;
      provinceController.text = addressData.addressTableProvinceName;
      sociallyFriendlyController.text = addressData.addressTableSociallyFriendly;
      environmentallyFriendlyController.text = addressData.addressTableEnvironmentallyFriendly;
      cityController.text = addressData.addressTableCity;
      streetController.text = addressData.addressTableStreet;
      buildingNumberController.text = addressData.addressTableBuildingNumber;
      phoneNumberController.text = addressData.addressTablePhoneNumber;
      otherController.text = addressData.addressTableOther;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    controller: projectNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name of Project',
                      prefixIcon: Icon(Icons.home_filled),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),


                  TextField(
                    controller: environmentallyFriendlyController,
                    decoration: const InputDecoration(
                      labelText: 'Environmentally-friendly',
                      prefixIcon: Icon(Icons.energy_savings_leaf),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: sociallyFriendlyController,
                    decoration: const InputDecoration(
                      labelText: 'socially-friendly',
                      prefixIcon: Icon(Icons.favorite_border_rounded),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: provinceController,
                    decoration: const InputDecoration(
                      labelText: 'Province',
                      prefixIcon: Icon(Icons.message),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: streetController,
                    decoration: const InputDecoration(
                      labelText: 'Street',
                      prefixIcon: Icon(Icons.streetview),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: buildingNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Building number',
                      prefixIcon: Icon(Icons.business),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone,),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                  TextField(
                    controller: otherController,
                    decoration: const InputDecoration(
                      labelText: 'Other',
                      prefixIcon: Icon(Icons.info),
                    ),style: TextStyle(fontSize:  textFontSize ,)
                  ),
                ],
              ),
            ),
            // "Save  Address" button is placed here, outside the ListView


            ElevatedButton(
              onPressed: () async {
                if (projectNameController.text.isEmpty || projectNameController.text == '_oozz') {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(''),
                        content: Text(
                          'Please enter a project name.',
                          style: TextStyle(fontSize: textFontSize),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the popup
                            },
                            child: Text('OK', style: TextStyle(fontSize: textFontSize)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final String projectNameControllerText = projectNameController.text;
                  final List<String> existingProjectNames =
                  await CompleteCalculationDatabaseHelper.getAllProjectNames();

                  if (existingProjectNames.contains(projectNameControllerText) &&
                      projectNameControllerText != givenProjectName) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'A project with this name already exists. Please choose another name.',
                            style: TextStyle(fontSize: textFontSize),
                          ),
                          backgroundColor: const Color(0xFF9A87BE),
                        ),
                      );
                    }
                  } else {
                    // Move this line here BEFORE any await


                    if (givenProjectName != projectNameController.text) {
                      await CompleteCalculationDatabaseHelper.updateProjectNameInAllTables(
                        projectNameController.text,
                        projectData.projectName,
                      );
                      projectData.setProjectName(projectNameController.text);
                      givenProjectName = projectData.projectName;
                    }

                    final ProjectAddressData projectAddressData = ProjectAddressData(
                      addressTableId: await CompleteCalculationDatabaseHelper.getNextAddressProjectID(),
                      addressTableProjectName: projectNameController.text,
                      addressTableEnvironmentallyFriendly: environmentallyFriendlyController.text,
                      addressTableSociallyFriendly: sociallyFriendlyController.text,
                      addressTableProvinceName: provinceController.text,
                      addressTableCity: cityController.text,
                      addressTableStreet: streetController.text,
                      addressTableBuildingNumber: buildingNumberController.text,
                      addressTablePhoneNumber: phoneNumberController.text,
                      addressTableOther: otherController.text,
                    );

                    await CompleteCalculationDatabaseHelper.insertOrUpdateAddressProjectData(projectAddressData);

                    List<ResultProjectColumnsClassData> resultProjectData =
                    await CompleteCalculationDatabaseHelper.getResultProjectColumnsClassData(givenProjectName);

                    if (resultProjectData.isNotEmpty) {
                      nameOfProject = resultProjectData[0].resultProjectTableProjectName;
                      incomeOfProject = (resultProjectData[0].resultProjectTableTotalIncome);
                      costOfProject = (resultProjectData[0].resultProjectTableTotalCosts);
                      profitOfProject = (resultProjectData[0].resultProjectTableTotalProfit);
                      profitPercentageOfProject = (resultProjectData[0].resultProjectTableProfitPercentageOfProject);

                      environmentallyFriendly = (environmentallyFriendlyController.text.isNotEmpty)
                          ? double.parse(environmentallyFriendlyController.text.replaceAll(',', ''))
                          : 1;
                      sociallyFriendly = (sociallyFriendlyController.text.isNotEmpty)
                          ? double.parse(sociallyFriendlyController.text.replaceAll(',', ''))
                          : 1;
                      calculationType = 'complete';
                    }

                    String city = cityController.text;
                    String street = streetController.text;

                    final allProjectsPageDataArguments = AllProjectsPageData1(
                      allProjectsPageProjectName: nameOfProject,
                      allProjectsPageCostOfProject: costOfProject,
                      allProjectsPageIncomeOfProject: incomeOfProject,
                      allProjectsPageProfitOfProject: profitOfProject,
                      allProjectsPageProfitPercentageOfProject: profitPercentageOfProject,
                      allProjectsPageEnvironmentallyFriendly: environmentallyFriendly,
                      allProjectsPageSociallyFriendly: sociallyFriendly,
                      allProjectsPageCity: city,
                      allProjectsPageStreet: street,
                      allProjectsPageCalculationName: calculationType,
                    );

                    await AllProjectsPageDatabase.insertOrUpdateAllProjectsPageData(
                        allProjectsPageDataArguments);
                  }
                }

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: textFontSize),
                backgroundColor: const Color.fromRGBO(81, 23, 194, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text('Save Project'),
            ),

            const SizedBox(height:30),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.7;
    const double fontSizePhone = 20.0;
    const double titleFontSizePhone = 22.0;
    const double iconSizeLargePhone = 32.0;
    const double iconSizeSmallPhone = 28.0;

// iPad sizes (larger)
    final double buttonWidthPad = screenWidth *  0.5;
    const double fontSizePad = 37.0;
    const double titleFontSizePad = 40.0;
    const double iconSizeLargePad = 55.0;
    const double iconSizeSmallPad = 42.0;

    const ipadBreakpoint = 850.0; // or your preferred breakpoint


    final bool isIpad = screenWidth > ipadBreakpoint;

    final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 7.0;


    return  Consumer<ProjectData>(
        builder: (context, projectData, child) {
          return Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true, // Automatically resize the body to avoid the bottom inset (keyboard)
              body: SingleChildScrollView( // Wrap the entire Scaffold with SingleChildScrollView
                child: Container(
                  color: const Color.fromRGBO(141, 192, 233, 1.0),
                  height: screenHeight,
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,2,8,0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [

                             Container(color: const Color(0xFF5E0209),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.7,
                                        ),
                                        child: Text(
                                          projectData.projectName == "***" ? " Result"
                                              : projectData.projectName == "_oozz" ? " Project Result"
                                              : '${projectData.projectName} Result',
                                          style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox.shrink(),
                                    ),
                    
                                  ],
                                ),
                              ),
                    
                             SizedBox(height:spacingHeight ),
                    
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isProjectExpanded = !_isProjectExpanded;
                                  _isFloorExpanded = false;
                                  _isConstructionExpanded = false;
                                  _isKeyMetricsExpanded = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, // Set the text color to black
                                textStyle:  TextStyle(fontSize: textFontSize), // Set the font size to 20
                                backgroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9), // Set the border radius
                              //    side: const BorderSide(color: Colors.black), // Set the border color to black
                                ),
                              ),
                              child:   Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('            Total Result            '
                                  ,style:  TextStyle( fontSize: titleFontSize),
                                ),
                              ),
                            ),
                    
                             SizedBox(height:spacingHeight ),
                    
                            if (_isProjectExpanded)
                              Visibility(
                                visible: _isProjectExpanded,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: FutureBuilder<List<List<dynamic>>>(
                                        future: getResultData(projectData.projectName),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<List<dynamic>> data = snapshot.data!;
                                            const double dataRowHeight = 40.0; // or your adaptive value
                                            const double headingRowHeight = 30.0; // or your adaptive value
                                            // Calculate total height
                                            final double tableHeight = headingRowHeight +
                                                (data.length * dataRowHeight);
                                            Color rowColor =Colors.teal;
                                            return DataTable(
                                              columnSpacing: tableHeight,
                                              headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                return Colors.orange; // Set the background color of the header row
                                              }),
                                              columns:  [
                    
                                                DataColumn(label: Text('Income',
                                                  style: TextStyle(
                                                    fontSize: textFontSize,
                                                  ),)),
                                                DataColumn(label: Text('Total Cost',
                                                  style: TextStyle(
                                                    fontSize: textFontSize, //color: Colors.red,
                                                  ),)),
                                                DataColumn(label: Text('   Profit',
                                                  style: TextStyle(
                                                    fontSize: textFontSize,
                                                  ),)),
                                                DataColumn(label: Text('Profit %',
                                                  style: TextStyle(
                                                    fontSize: textFontSize, //color: Colors.blueGrey
                                                  ),)),
                                              ],
                                              rows: data.asMap().entries.map((rowEntry) {
                                                final rowIndex = rowEntry.key;
                                                final row = rowEntry.value;
                                                return DataRow(
                                                  color: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                    if (states.contains(WidgetState.selected)) {
                                                      return Theme.of(context).colorScheme.primary.withAlpha(20);
                                                    }
                                                    return rowColor;
                                                  }),
                                                  cells: row.asMap().entries.map((cellEntry) {
                                                    final colIndex = cellEntry.key;
                                                    final cell = cellEntry.value;
                                                    String displayValue;
                                                    if (cell is double) {
                                                      if (colIndex == 3) { // Profit % column
                                                        displayValue = '${cell.toStringAsFixed(0)}%';
                                                      } else {
                                                        displayValue = (cell.truncateToDouble() == cell)
                                                            ? cell.toInt().toString()
                                                            : cell.toStringAsFixed(1);
                                                      }
                                                    } else {
                                                      displayValue = cell.toString();
                                                    }
                                                    return DataCell(
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          displayValue,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }).toList(),

                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    
                                   SizedBox(height:spacingHeight ),
                                  Visibility(visible: projectData.projectNameList.isEmpty,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isConstructionExpanded = !_isConstructionExpanded;
                                          _isFloorExpanded = false;
                                          _isProjectExpanded = false;
                                          _isKeyMetricsExpanded = false;
                                          _isConstructionSortedAscending = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, // Set the text color to black
                                        textStyle:  TextStyle(fontSize: textFontSize), // Set the font size to 20
                                        backgroundColor: Colors.black54, //const Color.fromRGBO(190, 203, 204, 1.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(9), // Set the border radius
                                      //    side: const BorderSide(color: Colors.black), // Set the border color to black
                                        ),
                                      ),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text('   Cost-Price Plan Result    '
                                          ,style:  TextStyle( fontSize: titleFontSize),),
                                      ),
                                    ),
                                  ),
                                   SizedBox(height:spacingHeight),
                                  Visibility(
                                    visible: _isConstructionExpanded,
                                    child:  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: FutureBuilder<List<List<dynamic>>>(
                                        future: _getResultConstructionData(projectData.projectName),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<List<dynamic>> data = snapshot.data!;
                                            const double dataRowHeight = 40.0; // or your adaptive value
                                            const double headingRowHeight = 30.0; // or your adaptive value
                                            // Calculate total height
                                            final double tableHeight = headingRowHeight + (data.length * dataRowHeight);
                                            if (!_isConstructionSortedAscending) {
                                              data = sortData(data, sortColumnIndex, _isConstructionSortedAscending);
                                            }
                                            else {data.sort((a, b) => a[sortColumnIndex].compareTo(b[sortColumnIndex]));}
                    
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: DataTable(
                                                columnSpacing: tableHeight,
                                                sortAscending: _isConstructionSortedAscending,
                                                sortColumnIndex: sortColumnIndex,
                                                headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                  return Colors.orange; // Set the background color of the header row
                                                }),
                                                columns: [
                                                  DataColumn(
                                                    label:  Text('Cost-Price Plan',   style: TextStyle(
                                                      fontSize: textFontSize,
                                                    ),),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isConstructionSortedAscending = ascending;
                                                        _sortData(data, columnIndex, ascending);
                                                        sortColumnIndex = columnIndex;
                                                      });
                                                    },
                                                  ),
                                                  DataColumn(
                                                    label:  Text('Income',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isConstructionSortedAscending = ascending;
                                                        _sortData(data, columnIndex, ascending);
                                                        sortColumnIndex = columnIndex;
                                                      });
                                                    },
                                                  ),
                                                  DataColumn(
                                                    label:  Text('Construction Cost',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isConstructionSortedAscending = ascending;
                                                        _sortData(data, columnIndex, ascending);
                                                        sortColumnIndex = columnIndex;
                                                      });
                                                    },
                                                  ),
                                                ],
                                                rows: data.map((row) {
                                                  int index = data.indexOf(row);
                                                  Color rowColor = index % 2 == 0 ? const Color.fromRGBO(
                                                      10, 19, 70, 0.4627450980392157)
                                                      : const Color.fromRGBO(
                                                      22, 38, 107, 0.4627450980392157);
                                                  return DataRow(
                                                    color: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                      if (states.contains(WidgetState.selected)) {
                                                        return Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
                                                      }
                                                      return rowColor;
                                                    }),
                                                    cells: row.map((cell) {
                                                      return DataCell(
                                                          Align( alignment: Alignment.center,
                                                            child: Text(
                                                              cell is double ?
                                                              '${cell.truncateToDouble() == cell ? cell.toInt() : cell.toStringAsFixed(1)}'
                                                                  : cell.toString(),
                                                              style:  TextStyle(
                                                                color: Colors.white,
                                                                fontSize: textFontSize,
                                                              ),
                                                            ),
                                                          ));
                                                    }).toList(),
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  ),
                    
                                   SizedBox(height:spacingHeight ),
                                  Visibility(visible: projectData.projectNameList.isEmpty,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isFloorExpanded = !_isFloorExpanded;
                                          _isConstructionExpanded = false;
                                          _isProjectExpanded = false;
                                          _isKeyMetricsExpanded = false;
                                          _isFloorSortedAscending = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, // Set the text color to black
                                        textStyle:  TextStyle(fontSize: textFontSize), // Set the font size to 20
                                        backgroundColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(9), // Set the border radius
                                   //       side: const BorderSide(color: Colors.black), // Set the border color to black
                                        ),
                                      ),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text('            Floor Result             '
                                            ,style:  TextStyle( fontSize: titleFontSize)),
                                      ),
                                    ),
                                  ),
                    
                                 SizedBox(height:spacingHeight ),
                                  Visibility(
                                    visible: _isFloorExpanded,
                                    child:  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: FutureBuilder<List<List<dynamic>>>(
                                        future: _getResultFloorData(projectData.projectName),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<List<dynamic>> data = snapshot.data!;
                                            const double dataRowHeight = 40.0; // or your adaptive value
                                            const double headingRowHeight = 30.0; // or your adaptive value
                                            // Calculate total height
                                            final double tableHeight = headingRowHeight + (data.length * dataRowHeight);
                                            if (!_isFloorSortedAscending) {
                                              data = sortData(data, sortColumnIndex, _isFloorSortedAscending);
                                            }
                                            else {data.sort((a, b) => a[sortColumnIndex].compareTo(b[sortColumnIndex]));}
                    
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: DataTable(
                                                                      //         columnSpacing: tableHeight > screenHeight * .4 ? screenHeight * .4 : screenHeight,
                                                sortAscending: _isFloorSortedAscending,
                                                sortColumnIndex: sortColumnIndex,
                                                headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                  return Colors.orange; // Set the background color of the header row
                                                }),
                                                columns: [
                                                  DataColumn(
                                                    label:  Text('Cost-Price Plan'
                                                        ,style:  TextStyle( fontSize: titleFontSize)),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isFloorSortedAscending = ascending;
                                                        sortColumnIndex = columnIndex;
                                                        data = sortData(data, columnIndex, ascending);
                                                      });
                                                    },
                                                  ),
                                                  DataColumn(
                                                    label:  Text('Floor'
                                                        ,style:  TextStyle( fontSize: titleFontSize)),
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isFloorSortedAscending = ascending;
                                                        sortColumnIndex = columnIndex;
                                                        data = sortData(data, columnIndex, ascending);
                                                      });
                                                    },
                                                  ),
                                                  DataColumn(
                                                    label:  Text('Income      '
                                                        ,style:  TextStyle( fontSize: titleFontSize)),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isFloorSortedAscending = ascending;
                                                        sortColumnIndex = columnIndex;
                                                        data = sortData(data, columnIndex, ascending);
                                                      });
                                                    },
                                                  ),
                                                  DataColumn(
                                                    label:  Text('Construction Cost'
                                                        ,style:  TextStyle( fontSize: titleFontSize)),
                                                    numeric: true,
                                                    onSort: (columnIndex, ascending) {
                                                      setState(() {
                                                        _isFloorSortedAscending = ascending;
                                                        sortColumnIndex = columnIndex;
                                                        data = sortData(data, columnIndex, ascending);
                                                      });
                                                    },
                                                  ),
                    
                                                ],
                                                rows: data.map((row) {
                                                  int index = data.indexOf(row);
                                                  Color rowColor;
                                                  if (index % 2 == 0) {
                                                    rowColor =  const Color.fromRGBO(
                                                        145, 57, 3, 0.4627450980392157);
                                                  } else {
                                                    rowColor =  const Color.fromRGBO(
                                                        80, 31, 1, 0.4627450980392157);
                                                  }
                                                  return DataRow(
                                                    color: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                                      if (states.contains(WidgetState.selected)) {
                                                        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                                                      }
                                                      return rowColor;    // Return the calculated row color
                                                    }),
                                                    cells: row.map((cell) {
                                                      return DataCell(
                                                        Align( alignment: Alignment.center,
                                                          child: Text(
                                                            cell is double ?
                                                            '${cell.truncateToDouble() == cell ? cell.toInt() :
                                                            cell.toStringAsFixed(1)}'
                                                                : cell.toString(),
                                                            style:  TextStyle(
                                                              color: Colors.white,
                                                              fontSize: textFontSize, // Increase the text size
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  ),
                    
                                   SizedBox(height:spacingHeight),
                    
                                   const SizedBox(width:60),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isKeyMetricsExpanded = !_isKeyMetricsExpanded;
                                        _isFloorExpanded = false;
                                        _isConstructionExpanded = false;
                                        _isProjectExpanded = false;
                                      });
                    
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      textStyle:  TextStyle(fontSize: textFontSize),
                                      backgroundColor: Colors.deepPurple,
                                      // const Color.fromRGBO(81, 23, 194, 1.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(19),
                                     //   side: const BorderSide(color: Colors.red),
                                      ),
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text('       Analytical Insights       '
                                        ,style:  TextStyle( fontSize: titleFontSize)),
                                    ),
                                  ),
                    
                                  //   SizedBox(height:spacingHeight ),
                    
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text('Key Metrics'
                                                ,style:  TextStyle( fontSize: titleFontSize, color: Colors.pink),   ),
                                            content: SingleChildScrollView(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '\nIn the "Total Results" section at the top of the page,'
                                                          ' you can see the outcome of the project. The total '
                                                          'income minus the total cost equals the profit. The total '
                                                          'cost includes construction costs, permit fees, and any other '
                                                          'costs entered on the first page, such as land cost.'
                                                          '\n\nIn the "Plan Result" and "Floor Result" sections,'
                                                          ' you can see result associated with Cost-Price Plans or floors defined. '
                                                          'However, only the income earned and the total construction costs '
                                                          'for these sections are included, excluding other costs. Therefore, '
                                                          'profit is not meaningful in these sections, as costs like land cost '
                                                          'are not accounted for.'
                                                          '\n\nThe Analytical Insights section provides key metrics '
                                                          'for your project. Below are the definitions of each metric, '
                                                          'which help assess performance and inform decision-making.\n\n',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '1. Land Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total area of land that needs to be '
                                                          'purchased for the project, upon which the construction will take place.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n2. Total Number of Floors',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total number of floors '
                                                          'constructed in the building, including the ground floor and '
                                                          'any underground floors that have been built.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n3. Ground Floor Constructed Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe area of the land that has been '
                                                          'assigned to the ground floor construction.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n4. Ground Floor Constructed Percentage',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe percentage of the land area assigned to the ground floor construction.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n5. Total Common Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total area of the common spaces in the building, '
                                                          'including non-saleable areas such as stairs, elevators, '
                                                          'lobbies, and other spaces that are part of the overall '
                                                          'construction and have a roof, but are not included in the area of saleable properties.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n6. Total Salable Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total area of the saleable properties in the building. '
                                                          'refers to the units or spaces within the building that can be sold '
                                                          'or leased to generate revenue for the project.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n7. Total Constructed Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe sum of the total common area and the total saleable area.'
                                                          ' The yard area that is the space without roof is not considered.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n8. Total Salable Area to Land Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe ratio of the total saleable area to the land area. '
                                                          'This metric is useful for comparing different projects to '
                                                          'determine which one provides more saleable area per square '
                                                          'meter of land, as maximizing saleable area is a primary goal of construction projects.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n9. Min Sale Price (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe minimum sale price per square foot / square meter (ft²/m²) '
                                                          'for the saleable properties.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n10. Max Sale Price (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe maximum sale price per ft²/m² for the saleable properties.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n11. Weighted Average Sale Price (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe weighted average sale price per square '
                                                          'meter for the saleable properties. The weighted average '
                                                          'price is the price that, if multiplied by the total saleable '
                                                          'area, would equal the total expected revenue from selling all the saleable units.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n12. Land Price (ft²/m²) to Average Sale Price (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe ratio of the land price per ft²/m² to the average '
                                                          'sale price per ft²/m². Some developers believe that the '
                                                          'more expensive the land, the more expensive the properties can be, '
                                                          'ultimately leading to higher profits. However, this ratio of land '
                                                          'price per ft²/m² to average sale price per ft²/m² allows '
                                                          'us to test this argument and compare the profitability of '
                                                          'different projects based on their land costs.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n13. Average Construction Cost (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe average cost per ft²/m² for construction of total constructed area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n14. Average Permission Cost (ft²/m²)',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe average cost per ft²/m² for obtaining permissions for construction of total constructed area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n15. Cost of Land',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe cost of purchasing the land.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n16. Total Construction Cost',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total cost of construction of total constructed area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n17. Total Permission Cost',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total cost of obtaining permissions for construction of total constructed area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n18. Top roof and Yard Construction Costs',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe costs associated with constructing the Top roof and yard.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n19. Transaction Costs',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe transaction costs associated with property ownership transfers including transfer taxes and fees, '
                                                          'title insurance, etc.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n20. Other Costs',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nAny other costs such as financial consultation expenses'
                                                          ' that are not considered in the previous list of transaction costs.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n21. Total Cost',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe summation of purchasing land cost, '
                                                          'construction cost, permission cost, transaction costs, and other costs.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n22. Total Income',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,                                                  ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total income generated from selling all properties at '
                                                          'the specified prices, which is equal to the summation of income '
                                                          'from selling each property generated by multiplying unit area '
                                                          'and given selling price per ft²/m², represents the total revenue potential of the project.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n23. Total Profit',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe output of deduction of total costs from total income.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n24. Profit %',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe result of dividing the total profit by the '
                                                          'total costs and multiplying by 100 represents the percentage of profit.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n25. Salable Area Required to Finance Land and Permission Costs',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total ft²/m²s of the project that must be sold at the average '
                                                          'price per ft²/m² to cover the costs of buying the land and getting construction permits. '
                                                          'Sometimes, developers need to use this calculation to determine '
                                                          'how much of the project they need '
                                                          'to sell to pay for the upfront land and permit expenses before construction can begin.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n26. Land and Permission Costs to Total Costs',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe ratio of land and permission costs to the total costs, which usually '
                                                          'indicates what percentage of the total project budget needs to be available '
                                                          'at the start of the project, because land acquisition and permission costs '
                                                          'are often paid at the very start of a project, before any construction takes place.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n27. Total Cost per ft²/m² of Salable Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total cost divided to the total saleable area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n28. Profit per Salable Area',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe profit of each ft²/m² of saleable area. This is generated by '
                                                          'dividing the total profit, to the total saleable area.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n29. Salable Area Constructed per 10x Currency Segments',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.pink,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe saleable area produced per an amount of money '
                                                          'invested, which is divisible by 10. The amount of money is calculated based '
                                                          'on the total cost of the project and the currency (e.g., \$, €) value of the country.'
                    
                                                          '\n\nFor example, If the total cost is 22 million in your currency, the amount will be '
                                                          'considered 1 million. This means the metric indicates how much saleable area can '
                                                          'be produced for each 1 million invested in this project if total '
                                                          'saleable area is constructed by 22 million.'
                                                          'As another example, if the total cost is 4.3 billion, the amount is 1 billion. Similarly, '
                                                          'this metric shows how much saleable area can be produced for each 1 billion invested in the project '
                                                          'if total saleable area is constructed by 4.3 billion.'
                    
                                                          '\n\nThe metric simplifies comparing the efficiency of different projects in generating '
                                                          'saleable area per comparable amount of currency unit invested. For example, if Project A with '
                                                          '12,000 currency units produces 80 m², while Project B with 15,000 currency '
                                                          'units produces 110 m², which is more efficient at generating m² per 1,000 currency units?'
                                                          ' You can get answer for such comparison using this metric.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n30. Number of Salable Properties',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.pink,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe total number of saleable properties in the project. '
                                                          'You entered this number at the first page.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\n\n31. Number of Salable Properties per 10x Currency Segments',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.pink,
                                                      ),
                                                    ),
                                                     TextSpan(
                                                      text: '\nThe number of saleable properties produced per an amount of money '
                                                          'invested, which is divisible by 10. This amount is calculated based '
                                                          'on the total cost of the project and the currency value of the country.'
                    
                                                          '\n\nThe metric simplifies the comparison of the effectiveness of different projects by'
                                                          ' quantifying how many properties each project can produce based on the investment made.'
                                                          '\n\nFor example, if construction project A with a 170,000 currency units investment '
                                                          'produces 6 properties, and project B with a 210,000 currency units investment '
                                                          'produces 7 properties, then each 1,000 currency units invested in project A generates '
                                                          '0.35 properties, while project B generates 0.33 properties per 1,000 currency units. '
                                                          'Since 0.35 is greater than 0.33, the social investment effectiveness '
                                                          'of project A is higher. Even if the investor has enough money to '
                                                          'invest in project B, they could select project A and invest the '
                                                          'remaining funds in other projects that are more socially effective '
                                                          'than project B.'
                                                          '\n\nOn the first page of '
                                                          'the app in the part Home and Society, it '
                                                          'is explained that project with a higher number of properties, '
                                                          'while maintaining constant investment and construction quality, represents a more socially '
                                                          'effective real estate investment.',
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
                                                child:  Text('OK',style:  TextStyle( fontSize: titleFontSize, color: Colors.pink),
                                              ),)
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon:  Icon(Icons.help_center
                                        ,size: iconSizeLarge,
                                        color:  Colors.deepPurple),
                                  ),
                    
                                  Visibility(
                                    visible: _isKeyMetricsExpanded,
                                    child: Flexible(flex: 24,
                                      child: FutureBuilder<List<List<dynamic>>>(
                                        future: _getResultTotalData(projectData.projectName),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<List<dynamic>> data = snapshot.data!;
                                            return SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  for (int i = 0; i < columnTitles.length; i++)
                                                    Container(
                                                      color: i % 2 == 0 ? Colors.grey[200] : Colors.grey[300],
                                                      constraints: const BoxConstraints(
                                                        minHeight: 60,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                           const SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  '${i + 1}',
                                                                  style:  TextStyle(
                                                                    fontSize: textFontSize,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                 const SizedBox(height: 5,),
                    
                                                              ],
                                                            ),
                                                          ),
                                                           const SizedBox(width: 20),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                columnTitles[i],
                                                                style: TextStyle(
                                                                  color: i < 8
                                                                      ? Colors.blue
                                                                      : i >= 8 && i < 12
                                                                      ? Colors.purple
                                                                      : i >= 12 && i < 21
                                                                      ? Colors.red[900]
                                                                      : i >= 21 && i < 28
                                                                      ? Colors.green[900]
                                                                      : i >= 28 && i < 33
                                                                      ? Colors.pink
                                                                      : Colors.red,
                                                                  fontSize: textFontSize,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child: SizedBox.shrink(),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    data[0][i].toString(),
                                                                    style: TextStyle(
                                                                      color: i % 2 == 0 ? Colors.black : Colors.black,
                                                                      fontSize: textFontSize,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                    
                                  const Spacer(),
                                   SizedBox(height:spacingHeight ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.home,  color: const Color(0xFF5E0209),
                                              size: iconSizeLarge),
                                          onPressed: () {
                                            if (projectData.projectName == '_oozz') {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:  const Text(''),
                                                    content:  Text('The project isn\'t saved. For saving, press '
                                                        'the save icon and set a name for the project.',
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    actions: [
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor: Colors.red, // Background color for No button
                                                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                                                        ),
                                                        onPressed: () {
                                                          NavigationService().navigateToScreen(
                                                            const LandInputs(givenProjectName: '_oozz'),
                                                          );
                                                          Navigator.of(context).pop();
                                                        },
                                                        child:  Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: textFontSize,
                                                          ),
                                                        ),
                                                      ),
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
                                            else {
                                              NavigationService().navigateToScreen(
                                                LandInputs(
                                                  givenProjectName: projectData.projectName,
                                                ),
                                              );
                                            }
                                          }
                                          ),
                    
                                      IconButton(
                                          icon: Icon(Icons.save,  color: const Color(0xFF5E0209),
                                              size: iconSizeLarge),
                                          onPressed: () {
                                            _showAddressBottomSheet(context, projectData.projectName);
                                          }
                                      ),
                    
                                    ],
                                  ),
                            //      const MyBannerAdWidget(),
                         //   SizedBox(height: spacingHeight *3,),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              )
          );
        });
  }
}
