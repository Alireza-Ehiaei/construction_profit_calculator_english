
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'all_projects.dart';
import 'database.dart';
import 'land.dart';
import 'main.dart';
import 'navigation_service.dart';
import 'permit_fees.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';


class CostPrices extends StatefulWidget {
  final String givenProjectName;
  final int givenCppValue; 

  const CostPrices({
    super.key,
    required this.givenProjectName,
    required this.givenCppValue,
  });

  @override
  State<CostPrices> createState() => _CostPricesState();
}
class _CostPricesState extends State<CostPrices> {

  late String projectName1;
  late int givenCppValue;
  late int maxCcpValue;
  late int firstStartingFloor;

  List<AreaTableRowData> areaTableData = [];
  List<PriceTableRowData> priceTableData = [];
  Set<int> nonSalableSegments = {};


  TextEditingController nameController1 = TextEditingController();
  TextEditingController rowController = TextEditingController();
  TextEditingController columnIndexController1 = TextEditingController();
  TextEditingController columnIndexController2 = TextEditingController();
  TextEditingController columnIndexController3 = TextEditingController();
  TextEditingController columnIndexController4 = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController numberOfSegmentsController = TextEditingController();
  TextEditingController similarFloorController = TextEditingController();
  final ScrollController scrollController1 = ScrollController();
  bool areaTableVisible = false;
  bool similarFloorVisible = false;
  bool priceTableVisible = false;
  int cppValue = 1;
  int numberOfSegmentsSaved = 0;
  int numberOfSimilarFloorsSaved = 0;
  late int startingFloor;
  bool checkMaxCPP = false;
  bool hasData = false;
  late bool _costPercentageSelected;
  late bool _costPerMeterSelected;
  late bool _costPricingFixedSelected;
  final _costPercentageController = TextEditingController();
  final _costPerMeterController = TextEditingController();
  late bool _sellPricePercentageSelected;
  late bool _sellPricePerMeterSelected;
  late bool _sellPriceFixedSelected;
  final _sellPricePercentageController = TextEditingController();
  final _sellPricePerMeterController = TextEditingController();
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    startingFloor = Provider.of<ProjectData>(context, listen: false).firstStartingFloor;
    projectName1 = widget.givenProjectName;
    givenCppValue = widget.givenCppValue;
    _costPercentageSelected = false;
    _costPerMeterSelected = false;
    _costPricingFixedSelected = true;
    _sellPricePercentageSelected = false;
    _sellPricePerMeterSelected = false;
    _sellPriceFixedSelected = true;
    checkCostPriceData();
  //  AdManager().loadInterstitialAd();
  }

  @override
  void dispose() {
    _costPercentageController.dispose();
    _costPerMeterController.dispose();
    _sellPricePercentageController.dispose();
    _sellPricePerMeterController.dispose();
    super.dispose();
  }

// the check Data method is not typically used within the build method of a widget,
// where the Consumer widget is commonly used. The Consumer widget is typically used
// within the build method of a widget to listen for changes to a ChangeNotifier and
// rebuild the UI when the ChangeNotifier changes. the Provider.of method is used
// to access the projectData within the check Data method. The listen: false parameter
// is used to prevent the check Data method from rebuilding when the projectData changes.


  void checkCostPriceData() async {
    List<ProjectTableData> data =
        await CompleteCalculationDatabaseHelper.getCostPricingDataByCpp(
            widget.givenProjectName, 1);
    setState(() {
      hasData = data.isNotEmpty;
    });
    if (hasData) { // by pressing edit project if the given project name isn't _oozz comes up
       isReadOnly = true;
      _onNextCPP(widget.givenProjectName, 1);
    }
  }

  Future<void> _updatePercentageData(BuildContext context, int segmentNumber1, int similarFloor, int startingFloor,
      int numberOfSegments,  double costPercent, double costPerMeter,   double sellPercent, double sellPerMeter)
  async {
  await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData
    (ProjectStartingSimilarTableData(
      startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
      startingSimilarTableProjectName: projectName1,
      startingSimilarTableCpp: cppValue,
      startingSimilarTableStartingFloor: startingFloor,
      startingSimilarTableSegmentNumber: segmentNumber1,
      startingSimilarTableSegmentSalable: nonSalableSegments.contains(segmentNumber1) ? 0 : 1,
      startingSimilarTableSimilarFloor: similarFloor,
      startingSimilarTableNumberOfSegments: numberOfSegments,
      startingSimilarTableCostPercentage: costPercent,
      startingSimilarTableCostPerMeter: costPerMeter,
      startingSimilarTableSellPricePercentage: sellPercent,
      startingSimilarTableSellPricePerMeter: sellPerMeter,
    ));
  ProjectStartingSimilarTableData? data =
  await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
      projectName1, cppValue, segmentNumber1);
  }


  void _costSellDataGenerating(
      BuildContext context,
      String projectName1,
      int ccpValue,
      int segmentNumber,
      Set<int> nonSalableSegmentsInCostSellDataGenerating,
      double costPercentage,
      double costPerMeter,
      double sellPercent,
      double sellPerMeter,
      ) async {
    // Retrieve the data from the StartingSimilar table in the database
    ProjectStartingSimilarTableData? dataSimilarStarting =
    await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
        projectName1, ccpValue, segmentNumber);

    List<ProjectTableData> projectDataByCpp =
    await CompleteCalculationDatabaseHelper.getCostPricingDataByCpp(projectName1, ccpValue);

    int? startingFloor = dataSimilarStarting?.startingSimilarTableStartingFloor;
    int startingFloorIndex = 0;
    late double startingFloorSegmentCost;
    late double startingFloorSegmentPrice;
    late double updatedSegmentCost;
    late double updatedSegmentPrice;

    // Find the starting floor index for this segment
    for (int i = 0; i < projectDataByCpp.length; i++) {
      if (projectDataByCpp[i].costPricingTableSegmentNumber == segmentNumber &&
          projectDataByCpp[i].costPricingTableFloorNumber == startingFloor) {
        startingFloorIndex = i;
        break;
      }
    }

    int j = 0;
    int k = 0;

    for (int i = 0; i < projectDataByCpp.length; i++) {
      if (projectDataByCpp[i].costPricingTableSegmentNumber == segmentNumber) {
        // Always generate cost price as before
        if (projectDataByCpp[i].costPricingTableFloorNumber == startingFloor) {
          // Optionally, set or update starting floor values here if needed
        } else {
          // Calculate cost price as usual
          projectDataByCpp[i].costPricingTableSegmentCostPerMeter = 0;
          priceTableData[i].textField3Controller.text = '';

          startingFloorSegmentCost = projectDataByCpp[startingFloorIndex].costPricingTableSegmentCostPerMeter;

          if (costPercentage != -4321 && costPercentage != 0) {
            updatedSegmentCost = startingFloorSegmentCost * pow(1 + costPercentage / 100, j + 1);
          } else if (costPerMeter != -4321 && costPerMeter != 0) {
            updatedSegmentCost = startingFloorSegmentCost + costPerMeter * (j + 1);
          } else {
            updatedSegmentCost = startingFloorSegmentCost;
          }

          String updatedSegmentCostString = updatedSegmentCost.toStringAsFixed(2);
          projectDataByCpp[i].costPricingTableSegmentCostPerMeter =
              double.parse(updatedSegmentCostString);
          j++;
          priceTableData[i].textField3Controller.text = updatedSegmentCost.toStringAsFixed(2);
        }

        // --- Handle Sell Price ---
        if (nonSalableSegmentsInCostSellDataGenerating.contains(segmentNumber)) {
          // For non-salable: Sell price is always zero
          projectDataByCpp[i].costPricingTableSegmentSellPricePerMeter = 0;
          priceTableData[i].textField4Controller.text = "0";
        } else {
          // For salable: Calculate sell price as usual
          if (projectDataByCpp[i].costPricingTableFloorNumber != startingFloor) {
            projectDataByCpp[i].costPricingTableSegmentSellPricePerMeter = 0;
            priceTableData[i].textField4Controller.text = '';

            startingFloorSegmentPrice = projectDataByCpp[startingFloorIndex].costPricingTableSegmentSellPricePerMeter;

            if (sellPercent != -4321 && sellPercent != 0) {
              updatedSegmentPrice = startingFloorSegmentPrice * pow(1 + sellPercent / 100, k + 1);
            } else if (sellPerMeter != -4321 && sellPerMeter != 0) {
              updatedSegmentPrice = startingFloorSegmentPrice + sellPerMeter * (k + 1);
            } else {
              updatedSegmentPrice = startingFloorSegmentPrice;
            }

            String updatedSegmentSellString = updatedSegmentPrice.toStringAsFixed(2);
            projectDataByCpp[i].costPricingTableSegmentSellPricePerMeter = double.parse(updatedSegmentSellString);
            k++;
            priceTableData[i].textField4Controller.text = updatedSegmentPrice.toStringAsFixed(2);
          }
        }
      }
    }

    setState(() {});
  }


/*
void _costSellDataGenerating(BuildContext context, String projectName1, int ccpValue, int segmentNumber,
      Set<int> nonSalableSegments,
      double costPercentage, double costPerMeter, double sellPercent, double sellPerMeter)
  async {
    // Retrieve the data from the StartingSimilar table in the database
    ProjectStartingSimilarTableData? dataSimilarStarting = await
    CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
        projectName1, ccpValue, segmentNumber);

    // Loop through the data and update the segmentCost values for the other floors
    // with the same segmentNumber, so we don't need to pass segment number as argument here
    List<ProjectTableData> projectDataByCpp = await
    CompleteCalculationDatabaseHelper.getCostPricingDataByCpp(projectName1, ccpValue);

    int? startingFloor = dataSimilarStarting?.startingSimilarTableStartingFloor;
    int startingFloorIndex = 0;
    late double startingFloorSegmentCost;
    late double startingFloorSegmentPrice;
    late double updatedSegmentCost;
    late double updatedSegmentPrice;

    for (int i = 0; i < projectDataByCpp.length; i++) {
      if (projectDataByCpp[i].costPricingTableSegmentNumber == segmentNumber &&
          projectDataByCpp[i].costPricingTableFloorNumber == startingFloor) {
        startingFloorIndex = i;
        break;
      }
    }

    int j = 0;
    int k = 0;

    // For floors other than the starting floor, data of constant price is generated here
    for (int i = 0; i < projectDataByCpp.length; i++) {
      if (projectDataByCpp[i].costPricingTableSegmentNumber == segmentNumber &&
          projectDataByCpp[i].costPricingTableFloorNumber !=
              projectDataByCpp[startingFloorIndex].costPricingTableFloorNumber) {

        // Reset segment cost and price to ensure they don't retain previous values
        projectDataByCpp[i].costPricingTableSegmentCostPerMeter = 0;
        priceTableData[i].textField3Controller.text = '';
        projectDataByCpp[i].costPricingTableSegmentSellPricePerMeter = 0;
        priceTableData[i].textField4Controller.text = '';

        startingFloorSegmentCost = projectDataByCpp[startingFloorIndex].costPricingTableSegmentCostPerMeter;
        startingFloorSegmentPrice = projectDataByCpp[startingFloorIndex].costPricingTableSegmentSellPricePerMeter;
        //  -4321 is sentinel value
        if (costPercentage != -4321) {
          updatedSegmentCost = startingFloorSegmentCost * pow(1 + costPercentage / 100, j + 1);
        }
        else if (costPerMeter != -4321) {
          updatedSegmentCost = startingFloorSegmentCost + costPerMeter * (j + 1);
        }
        else  {
          updatedSegmentCost = startingFloorSegmentCost;
        }

        String updatedSegmentCostString = updatedSegmentCost.toStringAsFixed(2);
        projectDataByCpp[i].costPricingTableSegmentCostPerMeter = double.parse(updatedSegmentCostString);
        j++;

        priceTableData[i].textField3Controller.text = updatedSegmentCost.toStringAsFixed(2);

        if (sellPercent != -4321) {
          updatedSegmentPrice = startingFloorSegmentPrice * pow(1 + sellPercent / 100, k + 1);
        } else if (sellPerMeter != -4321) {
          updatedSegmentPrice = startingFloorSegmentPrice + sellPerMeter * (k + 1);
        } else  {
          updatedSegmentPrice = startingFloorSegmentPrice;
        }

        String updatedSegmentSellString = updatedSegmentPrice.toStringAsFixed(2);
        projectDataByCpp[i].costPricingTableSegmentSellPricePerMeter = double.parse(updatedSegmentSellString);
        k++;
        priceTableData[i].textField4Controller.text = updatedSegmentPrice.toStringAsFixed(2);
      }
    }

    setState(() {});
  }*/

  // Each project has a starting similar table that equal to the number of cost-price
  // plans multiplied number of segments of starting floor in that cost-price plan,
// has rows saved in database. For example if a project has two cost-price plans 
// and cost-price plan one has three floors each one with two segments and 
// cost-price plan 2 has three floors each one with 4 segments,
// totally there are 6 records in database for this project in StartingSimilarTableData
  // So the number of floors doesn't matter, Just the number of segments of the starting floors count. 



  // save CurrentSegmentOfStartingFloor is called once setting icon is pressed, otherwise data generated using icon will not be save and shown in price table
  void saveCurrentSegmentOfStartingFloor(int segmentNumber2) async
  {
    // Retrieve existing data
    ProjectStartingSimilarTableData? data =
    await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
        projectName1, cppValue, segmentNumber2);

    bool isSalable = !(nonSalableSegments.contains(segmentNumber2));

    // Prepare sell price values depending on sellability
    double sellPricePercentage = 0;
    double sellPricePerMeter = 0;

    if (isSalable) {
      sellPricePercentage = (_sellPricePercentageSelected && _sellPricePercentageController.text.isNotEmpty)
          ? double.parse(_sellPricePercentageController.text)
          : (data?.startingSimilarTableSellPricePercentage ?? 0);

      sellPricePerMeter = (_sellPricePerMeterSelected && _sellPricePerMeterController.text.isNotEmpty)
          ? double.parse(_sellPricePerMeterController.text)
          : (data?.startingSimilarTableSellPricePerMeter ?? 0);
    }

    // Insert or update StartingSimilarTableData with correct sellability and prices
    await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData(
      ProjectStartingSimilarTableData(
        startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
        startingSimilarTableProjectName: projectName1,
        startingSimilarTableCpp: cppValue,
        startingSimilarTableStartingFloor: startingFloor,
        startingSimilarTableSegmentNumber: int.parse(priceTableData[segmentNumber2 - 1].name.split(' ')[3]),
        startingSimilarTableSegmentSalable: isSalable ? 1 : 0,
        startingSimilarTableSimilarFloor: numberOfSimilarFloorsSaved,
        startingSimilarTableNumberOfSegments: numberOfSegmentsSaved,
        startingSimilarTableCostPercentage: _costPercentageSelected && _costPercentageController.text.isNotEmpty
            ? double.parse(_costPercentageController.text)
            : (data?.startingSimilarTableCostPercentage ?? 0),
        startingSimilarTableCostPerMeter: _costPerMeterSelected && _costPerMeterController.text.isNotEmpty
            ? double.parse(_costPerMeterController.text)
            : (data?.startingSimilarTableCostPerMeter ?? 0),
        startingSimilarTableSellPricePercentage: sellPricePercentage,
        startingSimilarTableSellPricePerMeter: sellPricePerMeter,
      ),
    );

    // Save ProjectTableData for all segments
    int nextId = await CompleteCalculationDatabaseHelper.getNextProjectId();
    for (int i = 0; i < priceTableData.length; i++) {
      int segNum = int.parse(priceTableData[i].name.split(' ')[3]);
      bool segmentIsSalable = !(nonSalableSegments.contains(segNum));

      double sellPrice = segmentIsSalable ?
         (priceTableData[i].textField4Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField4Controller.text)
          : 0)
          : 0; // force zero for non-salable segments

      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectData(
        ProjectTableData(
          costPricingTableProjectId: nextId++,
          costPricingTableProjectName: projectName1,
          costPricingTableCpp: cppValue,
          costPricingTableFloorNumber: int.parse(priceTableData[i].name.split(' ')[1]),
          costPricingTableSegmentNumber: segNum,
          costPricingTableSegmentArea: priceTableData[i].textField2Controller.text.isNotEmpty
              ? double.parse(priceTableData[i].textField2Controller.text)
              : 0,
          costPricingTableSegmentCostPerMeter: priceTableData[i].textField3Controller.text.isNotEmpty
              ? double.parse(priceTableData[i].textField3Controller.text)
              : 0,
          costPricingTableSegmentSellPricePerMeter: sellPrice,
          costPricingTableCostOfSegment: (priceTableData[i].textField3Controller.text.isNotEmpty &&
              priceTableData[i].textField2Controller.text.isNotEmpty)
              ? double.parse(priceTableData[i].textField3Controller.text) *
              double.parse(priceTableData[i].textField2Controller.text)
              : 0,
          costPricingTableIncomeOfSegment: (sellPrice > 0 &&
              priceTableData[i].textField2Controller.text.isNotEmpty)
              ? sellPrice * double.parse(priceTableData[i].textField2Controller.text)
              : 0,
          costPricingTableProfitOfSegment: (priceTableData[i].textField2Controller.text.isNotEmpty &&
              priceTableData[i].textField3Controller.text.isNotEmpty)
              ? (sellPrice -
              double.parse(priceTableData[i].textField3Controller.text)) *
              double.parse(priceTableData[i].textField2Controller.text)
              : 0,
          costPricingTableIndex3: 0,
        ),
      );
    }
  }

/*  void saveCurrentSegmentOfStartingFloor(int segmentNumber2)
  async {
    // saving data with same segment numbers
    // Saving data for starting similar data table
    ProjectStartingSimilarTableData? data =
       await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
        projectName1, cppValue, segmentNumber2);

    // If StartingSimilar data is not null, set the text of the corresponding text fields and toggle buttons
    if (data != null) {
      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData(
          ProjectStartingSimilarTableData(
            startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
            startingSimilarTableProjectName: projectName1,
            startingSimilarTableCpp: cppValue,
            startingSimilarTableStartingFloor: startingFloor,
            startingSimilarTableSegmentNumber: int.parse(priceTableData[segmentNumber2 - 1].name.split(' ')[3]),
            startingSimilarTableSegmentSalable: nonSalableSegments.contains(segmentNumber2) ? 0 : 1,            startingSimilarTableSimilarFloor: numberOfSimilarFloorsSaved,
            startingSimilarTableNumberOfSegments: numberOfSegmentsSaved,
            startingSimilarTableCostPercentage: _costPercentageSelected && _costPercentageController.text.isNotEmpty ?
            double.parse(_costPercentageController.text) : data.startingSimilarTableCostPercentage,
            startingSimilarTableCostPerMeter: _costPerMeterSelected && _costPerMeterController.text.isNotEmpty
                ? double.parse(_costPerMeterController.text) : data.startingSimilarTableCostPerMeter,
            startingSimilarTableSellPricePercentage: _sellPricePercentageSelected && _sellPricePercentageController.text.isNotEmpty
                ? double.parse(_sellPricePercentageController.text) : data.startingSimilarTableSellPricePercentage,
            startingSimilarTableSellPricePerMeter: _sellPricePerMeterSelected && _sellPricePerMeterController.text.isNotEmpty
                ? double.parse(_sellPricePerMeterController.text) : data.startingSimilarTableSellPricePerMeter,
          ));

    }
    else {
      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData(
          ProjectStartingSimilarTableData(
            startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
            startingSimilarTableProjectName: projectName1,
            startingSimilarTableCpp: cppValue,
            startingSimilarTableStartingFloor: startingFloor,
           // startingSimilarTableFloorNumber: int.parse(priceTableData[segmentNumber2 - 1].name.split(' ')[1]),
            startingSimilarTableSegmentNumber: int.parse(priceTableData[segmentNumber2 - 1].name.split(' ')[3]),
            startingSimilarTableSegmentSalable: nonSalableSegments.contains(segmentNumber2) ? 0 : 1,
            startingSimilarTableSimilarFloor: numberOfSimilarFloorsSaved,
            startingSimilarTableNumberOfSegments: numberOfSegmentsSaved,
            startingSimilarTableCostPercentage: _costPercentageSelected
                && _costPercentageController.text.isNotEmpty ?
            double.parse(_costPercentageController.text) : -4321,
            startingSimilarTableCostPerMeter: _costPerMeterSelected
                && _costPerMeterController.text.isNotEmpty ?
            double.parse(_costPerMeterController.text) : -4321,
            startingSimilarTableSellPricePercentage: _sellPricePercentageSelected
                && _sellPricePercentageController.text.isNotEmpty ?
            double.parse(_sellPricePercentageController.text) : -4321,
            startingSimilarTableSellPricePerMeter: _sellPricePerMeterSelected
                && _sellPricePerMeterController.text.isNotEmpty ?
            double.parse(_sellPricePerMeterController.text) : -4321,
          ));
    }


    int nextId = await CompleteCalculationDatabaseHelper.getNextProjectId();
    for (int i = 0; i < priceTableData.length; i++) {
      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectData(ProjectTableData(
        costPricingTableProjectId: nextId++,
        costPricingTableProjectName: projectName1,
        costPricingTableCpp: cppValue,
        costPricingTableFloorNumber: int.parse(priceTableData[i].name.split(' ')[1]),
        costPricingTableSegmentNumber: int.parse(priceTableData[i].name.split(' ')[3]),
        costPricingTableSegmentArea: priceTableData[i].textField2Controller.text.isNotEmpty
            ? double.parse(priceTableData[i].textField2Controller.text)
            : 0,
        costPricingTableSegmentCostPerMeter: priceTableData[i].textField3Controller.text.isNotEmpty
            ? double.parse(priceTableData[i].textField3Controller.text)
            : 0,
        costPricingTableSegmentSellPricePerMeter: priceTableData[i].textField4Controller.text.isNotEmpty
            ? double.parse(priceTableData[i].textField4Controller.text)
            : 0,
        costPricingTableCostOfSegment: (priceTableData[i].textField3Controller.text.isNotEmpty &&
            priceTableData[i].textField2Controller.text.isNotEmpty) ?
        double.parse(priceTableData[i].textField3Controller.text) *
            double.parse(priceTableData[i].textField2Controller.text)
            : 0,
        costPricingTableIncomeOfSegment: (priceTableData[i].textField4Controller.text.isNotEmpty &&
            priceTableData[i].textField2Controller.text.isNotEmpty) ?
        double.parse(priceTableData[i].textField4Controller.text) *
            double.parse(priceTableData[i].textField2Controller.text)
            : 0,
        costPricingTableProfitOfSegment: (priceTableData[i].textField2Controller.text.isNotEmpty &&
            priceTableData[i].textField3Controller.text.isNotEmpty &&
            priceTableData[i].textField4Controller.text.isNotEmpty) ?
        (double.parse(priceTableData[i].textField4Controller.text) -
            double.parse(priceTableData[i].textField3Controller.text)) *
            double.parse(priceTableData[i].textField2Controller.text)
            : 0,
        costPricingTableIndex3: 0,
      ));
    }
  }*/

  Future<void> profitCalculationForEachSegment() async {
    int nextId = await CompleteCalculationDatabaseHelper.getNextProjectId();
    for (int i = 0; i < priceTableData.length; i++) {
      double segmentArea = priceTableData[i].textField2Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField2Controller.text)
          : -4321;
      double segmentCost = priceTableData[i].textField3Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField3Controller.text)
          : -4321;
      double segmentPrice = priceTableData[i].textField4Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField4Controller.text)
          : -4321;
      double costOfSegment = (segmentCost != -1 && segmentArea != -1)
          ? segmentCost * segmentArea
          : -4321;
      double incomeOfSegment = (segmentPrice != -1 && segmentArea != -1)
          ? segmentPrice * segmentArea
          : -4321;
      double profitOfSegment = (segmentPrice != -1 && segmentCost != -1 && segmentArea != -1)
          ? (segmentPrice - segmentCost) * segmentArea
          : -4321;

      int floor = int.parse(priceTableData[i].name.split(' ')[1]);
      int segment = int.parse(priceTableData[i].name.split(' ')[3]);

  /*    // --- Handle non-salable segments ---
      if (nonSalableSegments.contains(segment)) {
        segmentPrice = 0;
        incomeOfSegment = 0;
        profitOfSegment = 0;
      }*/

      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectData(ProjectTableData(
        costPricingTableProjectId: nextId++,
        costPricingTableProjectName: projectName1,
        costPricingTableCpp: cppValue,
        costPricingTableFloorNumber: floor,
        costPricingTableSegmentNumber: segment,
        costPricingTableSegmentArea: segmentArea,
        costPricingTableSegmentCostPerMeter: segmentCost,
        costPricingTableSegmentSellPricePerMeter: segmentPrice,
        costPricingTableCostOfSegment: costOfSegment,
        costPricingTableIncomeOfSegment: incomeOfSegment,
        costPricingTableProfitOfSegment: profitOfSegment,
        costPricingTableIndex3: -1,
      ));

      // The following fetch method should not be deleted because if you directly call insert method it will replace percentage data being saved with -4321, and also if both fetch and insert methods are deleted then If data is generated without pressing setting icon they won't be saved into the database

      List<Map<String, dynamic>> data = await CompleteCalculationDatabaseHelper.fetchProjectStartingSimilarData(
          projectName1, cppValue, startingFloor);
      bool isDataFound = false;
      for (int j = 0; j < data.length; j++) {
        if (data[j]['floor'] == startingFloor && data[j]['segmentNnnumber'] == segment) {
          isDataFound = true;
          break;
        }
      }
      if (!isDataFound) {
        await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData(
          ProjectStartingSimilarTableData(
            startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
            startingSimilarTableProjectName: projectName1,
            startingSimilarTableCpp: cppValue,
            startingSimilarTableStartingFloor: startingFloor,
            startingSimilarTableSegmentNumber: segment,
            startingSimilarTableSegmentSalable: nonSalableSegments.contains(segment) ? 0 : 1,
            startingSimilarTableSimilarFloor: numberOfSimilarFloorsSaved,
            startingSimilarTableNumberOfSegments: numberOfSegmentsSaved,
            startingSimilarTableCostPercentage: _costPercentageSelected && _costPercentageController.text.isNotEmpty
                ? double.parse(_costPercentageController.text)
                : -4321,
            startingSimilarTableCostPerMeter: _costPerMeterSelected && _costPerMeterController.text.isNotEmpty
                ? double.parse(_costPerMeterController.text)
                : -4321,
            startingSimilarTableSellPricePercentage: nonSalableSegments.contains(segment)
                ? 0
                : (_sellPricePercentageSelected && _sellPricePercentageController.text.isNotEmpty
                ? double.parse(_sellPricePercentageController.text)
                : -4321),
            startingSimilarTableSellPricePerMeter: nonSalableSegments.contains(segment)
                ? 0
                : (_sellPricePerMeterSelected && _sellPricePerMeterController.text.isNotEmpty
                ? double.parse(_sellPricePerMeterController.text)
                : -4321),
          ),
        );
      }
    }
  }


/*  Future<void> profitCalculationForEachSegment() async {
    int nextId = await CompleteCalculationDatabaseHelper.getNextProjectId();
    for (int i = 0; i < priceTableData.length; i++) {
      double segmentArea = priceTableData[i].textField2Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField2Controller.text)
          : -4321;
      double segmentCost = priceTableData[i].textField3Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField3Controller.text)
          : -4321;
      double segmentPrice = priceTableData[i].textField4Controller.text.isNotEmpty
          ? double.parse(priceTableData[i].textField4Controller.text)
          : -4321;
      double costOfSegment = (segmentCost != -1 && segmentArea != -1)
          ? segmentCost * segmentArea
          : -4321;
      double incomeOfSegment = (segmentPrice != -1 && segmentArea != -1)
          ? segmentPrice * segmentArea
          : -4321;
      double profitOfSegment = (segmentPrice != -1 && segmentCost != -1 && segmentArea != -1)
          ? (segmentPrice - segmentCost) * segmentArea
          : -4321;
      //  print('Segment $i: segmentArea=$segmentArea, segmentCost=$segmentCost, 
      //  segmentPrice=$segmentPrice, costOfSegment=$costOfSegment, incomeOfSegment=$incomeOfSegment, profitOfSegment=$profitOfSegment');

      int floor = int.parse(priceTableData[i].name.split(' ')[1]);
      int segment = int.parse(priceTableData[i].name.split(' ')[3]);
      await CompleteCalculationDatabaseHelper.insertOrUpdateProjectData(ProjectTableData(
        costPricingTableProjectId: nextId++,
        costPricingTableProjectName: projectName1,
        costPricingTableCpp: cppValue,
        costPricingTableFloorNumber: floor,
        costPricingTableSegmentNumber: segment,
        costPricingTableSegmentArea: segmentArea,
        costPricingTableSegmentCostPerMeter: segmentCost,
        costPricingTableSegmentSellPricePerMeter: segmentPrice,
        costPricingTableCostOfSegment: costOfSegment,
        costPricingTableIncomeOfSegment: incomeOfSegment,
        costPricingTableProfitOfSegment: profitOfSegment,
        costPricingTableIndex3: -1,
      )
      );

      // The following fetch method should not be deleted because if you directly call insert method it will replace percentage data being saved with -4321, and also if both fetch and insert methods are deleted then If data is generated without pressing setting icon they won't be saved into the database

      List<Map<String, dynamic>> data = await CompleteCalculationDatabaseHelper.fetchProjectStartingSimilarData(
          projectName1,cppValue, startingFloor);
      bool isDataFound = false;
      for (int j = 0; j < data.length; j++) {
        if (data[j]['floor'] == startingFloor && data[j]['segmentNnnumber'] == segment) {

          isDataFound = true;
          break;
        }
      }
      if (!isDataFound) {
        await CompleteCalculationDatabaseHelper.insertOrUpdateProjectStartingSimilarPercentageData
          (ProjectStartingSimilarTableData(
          startingSimilarTableId: await CompleteCalculationDatabaseHelper.getNextProjectStartingSimilarID(),
          startingSimilarTableProjectName: projectName1,
          startingSimilarTableCpp: cppValue,
          startingSimilarTableStartingFloor: startingFloor,
      //    startingSimilarTableFloorNumber: floor,
          startingSimilarTableSegmentNumber: segment,
          startingSimilarTableSimilarFloor: numberOfSimilarFloorsSaved,
          startingSimilarTableNumberOfSegments: numberOfSegmentsSaved,
          startingSimilarTableCostPercentage: _costPercentageSelected && _costPercentageController.text.isNotEmpty ?
          double.parse(_costPercentageController.text) : -4321,
          startingSimilarTableCostPerMeter: _costPerMeterSelected && _costPerMeterController.text.isNotEmpty ?
          double.parse(_costPerMeterController.text) : -4321,
          startingSimilarTableSellPricePercentage: _sellPricePercentageSelected &&
              _sellPricePercentageController.text.isNotEmpty ?
          double.parse(_sellPricePercentageController.text) : -4321,
          startingSimilarTableSellPricePerMeter: _sellPricePerMeterSelected &&
              _sellPricePerMeterController.text.isNotEmpty ?
          double.parse(_sellPricePerMeterController.text) : -4321,
        ));
      }
    }
  }*/

  // icon in popup of CostPrices
  void myIconButtonFunction
      (BuildContext context,  int segmentNumber1,
      int similarFloor, int startingFloor, int numberOfSegments, Set<int> nonSalableSegmentsInMyIcon)
     {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return PriceTypeDialog(
            onPercentageUpdate:  _updatePercentageData,
            costPercentageSelected: _costPercentageSelected,
            onCostSellDataGenerating: _costSellDataGenerating,
            costPerMeterSelected: _costPerMeterSelected,
            costPricingFixedSelected: _costPricingFixedSelected,
            onCostPercentageSelectedChanged: (bool value) {
              setState(() {
                _costPercentageSelected = value;
              });
            },
            onCostPerMeterSelectedChanged: (bool value) {
              setState(() {
                _costPerMeterSelected = value;
              });
            },
            onCostPricingFixedSelectedChanged: (bool value) {
              setState(() {
                _costPricingFixedSelected = value;
              });
            },
            sellPricePercentageSelected: _sellPricePercentageSelected,
            sellPricePerMeterSelected: _sellPricePerMeterSelected,
            sellPriceFixedSelected: _sellPriceFixedSelected,
            onSellPricePercentageSelectedChanged: (bool value) {
              setState(() {
                _sellPricePercentageSelected = value;
              });
            },
            onSellPricePerMeterSelectedChanged: (bool value) {
              setState(() {
                _sellPricePerMeterSelected = value;
              });
            },
            onSellPricingFixedSelectedChanged: (bool value) {
              setState(() {
                _sellPriceFixedSelected = value;
              });
            },
            similarFloor: numberOfSimilarFloorsSaved,  
            startingFloor: startingFloor,
            projectName : projectName1, 
            CPPNumber : cppValue,
            numberOfSegments : numberOfSegmentsSaved,
        //    floor_ : floor,
            segmentNumber1 : segmentNumber1,
          nonSalableSegmentsInPriceType: nonSalableSegmentsInMyIcon,
        );
      },
    );
  }

  Future<void> checkVisibility() async {
    String project_ = projectName1;
    Map<String, int?> maxValues = await  
        CompleteCalculationDatabaseHelper.getMaxFloorCppByProject(project_);
    int maxCpp = maxValues['maxCpp'] ?? 1;
    setState(() {
      checkMaxCPP = cppValue <= maxCpp;
    });
  }

  void retrieveRowByCondition(String projectName, int cppValue) async {
    //  await CompleteCalculationDatabaseHelper.retriveRowByCondition(projectName, cppValue);
  }

  void showSaveDialog(BuildContext context, VoidCallback onSave) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 37.0 : 17.0;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title:  const Text(''),
          content:  Text("You didn't save this project. Do you want to save it?",
            style: TextStyle(fontSize: textFontSize,
                color: Colors.white),),
          actions: [
            TextButton(
              onPressed: () {
                onSave();
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


  void showErrorDialog1(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    final textFontSize = isIpad ? 37.0 : 17.0;

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
              "Please fill all required fields. Inputs should be a valid number "
              "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
              "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                  " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
              style: TextStyle(fontSize: textFontSize )),
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

  Future<bool> _onNextCPP(String projectName, int cppValue)
  async {

    // Retrieve the data associated with project name and cost-price plan value
    List<ProjectTableData> retrievedPriceTableData =
    await CompleteCalculationDatabaseHelper.getCostPricingDataByCpp(projectName, cppValue);

 /*   if (retrievedPriceTableData.isEmpty) {
      // Handle empty data gracefully
      return false;
    }
*/
   // int segmentNumber = retrievedPriceTableData[0].costPricingTableSegmentNumber;

    // Retrieve all segments data for the starting floor (includes sealability)
    List<ProjectStartingSimilarTableData> projectStartingSimilarData =
    await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegments(projectName, cppValue);

    // --- Build a map from segmentNumber to sealability ---
    Map<int, bool> segmentSalableMap = {
      for (var segmentData in projectStartingSimilarData)
        segmentData.startingSimilarTableSegmentNumber:
        segmentData.startingSimilarTableSegmentSalable == 1
    };

    nonSalableSegments.clear();
    // Each entry in the map is a key-value pair:
    // entry.key is the segment number
    // entry.value is whether it is salable (true or false)
    nonSalableSegments = {
      for (var entry in segmentSalableMap.entries)
        if (!entry.value) entry.key
    };


    // --- Update area table data ---
    areaTableData.clear();

    // Both area table and price table data should be retrieved from starting similar and project tables
    for (int i = 0; i < projectStartingSimilarData.length; i++) { // length is Equal to the number of segments
      final segmentData = projectStartingSimilarData[i];

      // Extract the floor and segment numbers from your data model
      int floorNumber = segmentData.startingSimilarTableStartingFloor;
      int segmentNumber = segmentData.startingSimilarTableSegmentNumber;

      String rowName = 'Floor $floorNumber Segment $segmentNumber';

      TextEditingController textField1Controller = TextEditingController(
        text: retrievedPriceTableData[i].costPricingTableSegmentArea.toString(),
      );

      bool isSalable = segmentData.startingSimilarTableSegmentSalable == 1;

      areaTableData.add(AreaTableRowData(
        name: rowName,
        floorNumber: floorNumber,
        segmentNumber: segmentNumber,
        textField1Controller: textField1Controller,
        isSalableInArea: isSalable,
      ));
    }


    // --- Update price table data ---
    priceTableData.clear();
    List<String> segmentNumbers = [];

    // Use first segment's data as reference for floors and segments count
    int startingFloorGotten =
    projectStartingSimilarData[0].startingSimilarTableStartingFloor;
    int similarFloorCount =
     projectStartingSimilarData[0].startingSimilarTableSimilarFloor;
    int numberOfSegments =
     projectStartingSimilarData[0].startingSimilarTableNumberOfSegments;

    numberOfSegmentsController.text = numberOfSegments.toString();
    numberOfSegmentsSaved = numberOfSegments;

    // Generate segment labels for all floors and segments
    for (int floorOffset = 0; floorOffset < similarFloorCount + 1; floorOffset++) {
      for (int segIndex = 0; segIndex < numberOfSegments; segIndex++) {
        segmentNumbers.add(
            'Floor ${(startingFloorGotten + floorOffset).toString()} segment ${segIndex + 1}');
      }
    }

    for (int i = 0; i < retrievedPriceTableData.length; i++) {
      String segmentName = segmentNumbers[i];

      // Extract segment and floor numbers from your data model
      final segmentNum = retrievedPriceTableData[i].costPricingTableSegmentNumber;
      final floorNum = retrievedPriceTableData[i].costPricingTableFloorNumber; // <-- adjust as per your data model

      bool isSalable = segmentSalableMap[segmentNum] ?? true;

      TextEditingController textField2Controller = TextEditingController(
        text: retrievedPriceTableData[i].costPricingTableSegmentArea.toString(),
      );
      TextEditingController textField3Controller = TextEditingController(
        text: retrievedPriceTableData[i].costPricingTableSegmentCostPerMeter.toString(),
      );

      // For non-salable segments, sell price text is "0"
      String sellPriceText = isSalable
          ? retrievedPriceTableData[i].costPricingTableSegmentSellPricePerMeter.toString()
          : "0";

      TextEditingController textField4Controller = TextEditingController(text: sellPriceText);

      priceTableData.add(PriceTableRowData(
        name: segmentName,
        floorNumber: floorNum,
        segmentNumber: segmentNum,
        textField2Controller: textField2Controller,
        textField3Controller: textField3Controller,
        textField4Controller: textField4Controller,
        isSalableInPrice: isSalable,
      ));
    }

   /* for (int i = 0; i < retrievedPriceTableData.length; i++) {
      String segmentName = i < segmentNumbers.length ? segmentNumbers[i] : 'Segment $i';

      final segmentNum = retrievedPriceTableData[i].costPricingTableSegmentNumber;
      bool isSalable = segmentSalableMap[segmentNum] ?? true;

      TextEditingController textField2Controller = TextEditingController(
        text: retrievedPriceTableData[i].costPricingTableSegmentArea.toString(),
      );
      TextEditingController textField3Controller = TextEditingController(
        text: retrievedPriceTableData[i].costPricingTableSegmentCostPerMeter.toString(),
      );

      // For non-salable segments, sell price text is "0"
      String sellPriceText = isSalable
          ? retrievedPriceTableData[i].costPricingTableSegmentSellPricePerMeter.toString()
          : "0";

      TextEditingController textField4Controller = TextEditingController(text: sellPriceText);

      priceTableData.add(PriceTableRowData(
        name: segmentName,
        textField2Controller: textField2Controller,
        textField3Controller: textField3Controller,
        textField4Controller: textField4Controller,
        isSalable: isSalable,
      ));
    }*/

    // Update controllers for UI state
    similarFloorController.text = similarFloorCount.toString();
    numberOfSimilarFloorsSaved = similarFloorCount;
    startingFloor = startingFloorGotten;

    // Update the visibility of the area and price tables
    areaTableVisible = true;
    priceTableVisible = true;

    // Refresh UI
    setState(() {});

    // Prevent default back button behavior
    return false;
  }


/*  Future<bool> _onNextCPP(String projectName, int cppValue)
       async {

    // Retrieve the data associated with project name and cost-price plan value
    List<ProjectTableData> retrievedPriceTableData = await CompleteCalculationDatabaseHelper.
      getCostPricingDataByCpp(projectName, cppValue);

    int segmentNumber = retrievedPriceTableData[0].costPricingTableSegmentNumber;

    final ProjectStartingSimilarTableData? projectStartingSimilarData = await CompleteCalculationDatabaseHelper.
            getStartingSimilarTableSegmentData(projectName, cppValue, segmentNumber);
    numberOfSegmentsController.text = projectStartingSimilarData!.startingSimilarTableNumberOfSegments.toString();
    numberOfSegmentsSaved = projectStartingSimilarData.startingSimilarTableNumberOfSegments;
    // Update the area table data
    areaTableData.clear();
    for (int i = 0; i < projectStartingSimilarData.startingSimilarTableNumberOfSegments; i++) {
      String rowName = 'Floor ${projectStartingSimilarData.startingSimilarTableStartingFloor.toString()} segment ${i + 1}';
      TextEditingController textField1Controller = TextEditingController(text: retrievedPriceTableData[i].
               costPricingTableSegmentArea.toString());
      areaTableData.add(AreaTableRowData(name: rowName,
        textField1Controller: textField1Controller));
    }

    // Update the price table data
    priceTableData.clear();
    List<String> segmentNumbers = [];
    for (int i = 0; i < projectStartingSimilarData.startingSimilarTableSimilarFloor + 1; i++){
      for (int j = 0; j < projectStartingSimilarData.startingSimilarTableNumberOfSegments; j++) {
        segmentNumbers.add('Floor ${(projectStartingSimilarData.startingSimilarTableStartingFloor + i).
        toString()} segment ${j + 1}');
      }}

    for (int i = 0; i < retrievedPriceTableData.length; i++) {
      String segmentNumber = segmentNumbers[i];
      TextEditingController textField2Controller = TextEditingController(text: retrievedPriceTableData[i].costPricingTableSegmentArea.toString());
      TextEditingController textField3Controller = TextEditingController(text: retrievedPriceTableData[i].costPricingTableSegmentCostPerMeter.toString());
      TextEditingController textField4Controller = TextEditingController(text: retrievedPriceTableData[i].costPricingTableSegmentSellPricePerMeter.toString());
      similarFloorController.text = projectStartingSimilarData.startingSimilarTableSimilarFloor.toString();
      numberOfSimilarFloorsSaved =projectStartingSimilarData.startingSimilarTableSimilarFloor;
      startingFloor = projectStartingSimilarData.startingSimilarTableStartingFloor;

      priceTableData.add(PriceTableRowData(
        name: segmentNumber,
        textField2Controller: textField2Controller,
        textField3Controller: textField3Controller,
        textField4Controller: textField4Controller,
      ));
    }

    // Update the visibility of the area and price tables
    areaTableVisible = true;
    priceTableVisible = true;

    // Update the UI
    setState(() {});

    // Prevent the default back button behavior
    return false;
  }*/


  Future<void> _onBackButtonPressedCallback(BuildContext context)
       async {
         if (priceTableVisible)
         {
           bool allFieldsAreNotEmpty = true;

           for (int i = 0; i < priceTableData.length; i++) {
             // final sellPriceText = priceTableData[i].textField4Controller.text;

             if (priceTableData[i].textField2Controller.text.isEmpty ||
                 !isValidNumber(priceTableData[i].textField2Controller.text) ||
                 priceTableData[i].textField3Controller.text.isEmpty ||
                 !isValidNumber(priceTableData[i].textField3Controller.text) ||
                 priceTableData[i].textField4Controller.text.isEmpty ||
                 !isValidNumber(priceTableData[i].textField4Controller.text)) {
               allFieldsAreNotEmpty =
               false; // Set to false if any field is empty or invalid
               break; // Exit the loop if any field is empty or invalid
             }
           }


    if ((allFieldsAreNotEmpty &&
        numberOfSegmentsController.text.isNotEmpty &&
        similarFloorController.text.isNotEmpty)) {

      await profitCalculationForEachSegment();
      cppValue--;

      if (cppValue > 0) {
        // If checkmaxfeeSegmentNumber is true, execute this code block
        _onNextCPP(projectName1, cppValue);
        setState(() {});
      } else {
        if (cppValue == 0) { // The project had been saved before
          NavigationService().navigateToScreen(
            LandInputs(
              givenProjectName: projectName1,
            ),
          );
        }
      }
    }}
         else if (!priceTableVisible) {
// no need to profitCalculationForEachSegment
      cppValue--;

      if (cppValue > 0) {
        areaTableData.clear();
        numberOfSegmentsController.clear();
        similarFloorController.clear();
         numberOfSegmentsSaved = 0;
         numberOfSimilarFloorsSaved = 0;
        setState(() {
          areaTableVisible = false;
          similarFloorVisible = false;
          priceTableVisible = false;
        });
        _onNextCPP(projectName1, cppValue);
        setState(() {});
      } else {

        NavigationService().navigateToScreen(
          LandInputs(
            givenProjectName: projectName1,
          ),
        );
      }
    } else {
      // Show error dialog if any fields are empty or invalid
      showErrorDialog1(context);
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

  return  Consumer<ProjectData>(
      builder: (context, projectData, child) {

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

        const ipadBreakpoint = 850.0; // or your preferred breakpoint

        final bool isIpad = screenWidth > ipadBreakpoint;

        final textFontSize = isIpad ? fontSizePad : fontSizePhone;
        final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
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
                  Expanded(child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(padding: const EdgeInsets.fromLTRB(8,2,8,0),
                        /*padding: EdgeInsets.only(
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
                                          projectData.projectName == "***" ? " Cost Price Data"
                                              : projectData.projectName == "_oozz" ? " Cost Price Data"
                                              : '${projectData.projectName} Cost Price Data',
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
                                        'step 2/4 ',
                                        style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 5 ),
                              Container(color: const Color(0xFF1877C5),
                                child: Row(
                                  children: [
                                     const SizedBox(width: 10.0),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Cost-Price Plan  ',
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: textFontSize, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        cppValue.toString(),
                                        style:  TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: titleFontSize, color: Colors.yellow),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              bool? shouldDelete = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return SimpleDialog(
                                                    title:  Text('Delete the cost-price plan?'
                                                        ,style: TextStyle(fontSize: textFontSize)),
                                                    children: [
                                                      SimpleDialogOption(
                                                        child: Container(
                                                          color: Colors.red, // Set your desired background color here
                                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                          child:  Text(
                                                            'Yes',
                                                            style: TextStyle(fontSize: textFontSize, color: Colors.blue,),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context, true);
                                                        },
                                                      ),
                                                      SimpleDialogOption(
                                                        child: Container(
                                                          color: Colors.green, // Set your desired background color here
                                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                          child:  Text(
                                                            'No',
                                                            style: TextStyle(fontSize: textFontSize,color: Colors.blue,),
                                                            textAlign: TextAlign.center,
                                                          ),
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
                                                await CompleteCalculationDatabaseHelper.deleteCpp(
                                                    projectName1, cppValue);

                                          //      cppValue--;
                                               /* if (cppValue>0) {
                                                  // If checkmaxfeeSegmentNumber is true, execute this code block
                                               //   _onN extCPP(projectName1, cppValue);
                                                  _onBackButtonPressedCallback(context);
                                                  setState(() {});
                                                  // if (maxfloor + permitFeeSimilarFloor > totalFloor)
                                                }
                                                else*/
                                                {
                                                  setState(() {});
                                                  NavigationService().navigateToScreen(
                                                  LandInputs(givenProjectName: projectName1, ),
                                                  arguments: projectName1,
                                                );}
                                              }
                                              else
                                              {
                                                NavigationService().navigateToScreen(
                                                  LandInputs(
                                                    givenProjectName: projectName1,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.delete,size: iconSizeSmall, color: Colors.white,),
                                          ),
                                           SizedBox(width: spacingHeight),
              
              
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  final ScrollController scrollController1 = ScrollController();
                                                  return AlertDialog(
                                                    title:  Text('Examples',
                                                      style: TextStyle(
                                                        color: Colors.red, 
                                                        fontSize: titleFontSize,      
                                                        fontWeight: FontWeight.bold, 
                                                      ),),
                                                    content: SizedBox(
                                                      width: double.maxFinite, // Set a maximum width for the dialog
                                                      height: screenHeight * .8,
                                                      child: DraggableScrollbar.semicircle(
                                                        controller: scrollController1,
                                                        child: ListView(
                                                          controller: scrollController1,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                             child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                     TextSpan(
                                                                      text: 'In this section, you will find examples to help you better'
                                                                          ' understand how to define the cost-price segments and plans of your construction '
                                                                          'project. It may be beneficial to read each example thoroughly and write '
                                                                          'numbers of examples on paper before implementing them in the app. '
                                                                          'If you haven\'t read the guidance section yet, please '
                                                                          'click ',
                                                                      style: TextStyle(
                                                                        fontSize: textFontSize,
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
                                                                      text: ' icon at the bottom of the page and review it carefully before returning '
                                                                          'here to see these examples: \n\n',
                                                                      style: TextStyle(
                                                                        fontSize: textFontSize,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "Example 1. Single-Floor Villa\n\n"
                                                                          "Example 2. Duplex Villa\n\n"
                                                                          "Example 3. Two-Floor Apartments\n\n"
                                                                          "Example 4. Five-Floor Apartments With Parking\n\n"
                                                                          "Example 5. Seven-Floor Apartments With Parking and Terrace\n\n"
                                                                          "Example 6. Tower with 100 Properties\n\n"
                                                                          "Example 7, Repairment-Renovation Cost-Benefit Analysis\n\n",
              
                                                                      style: TextStyle(
                                                                        color: Colors.teal, fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "Example 1. Single-Floor Villa",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\nAssume you want to find the return on investment (ROI) for '
                                                                          'a project involving the construction of a villa on a 3,000 '
                                                                          'ft² plot of land with a single floor of 1,700 ft² built-up '
                                                                          'area that totally is salable. To do this, after opening the app,'
                                                                          'adding a new Complete Calculation project and entering '
                                                                          'the basic project data, such as land information, then in the next '
                                                                          'page, you need to define the cost-price segments for the built-up '
                                                                          'area of the project in this page.'
                                                                          '\n\n■ Since the project includes only one floor with a fully '
                                                                          'salable area, you can define the project as a single cost-price '
                                                                          'segment in cost-price plan 1. Follow these steps:\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Enter 1 as the number of cost-price segments of the first "
                                                                          "floor (floor 0) in this cost-price plan (CPP 1)."
                                                                          " .\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Areas button.'
                                                                          "\n▶ In the displayed table, for Floor 0 - Segment 1, enter 1,700, "
                                                                          "Keep the switch ON since the segment is salable.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Input 0 in front of the number of similar floors "
                                                                          "because there is no other floor in the project.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "4. Set Cost and Sell prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          "▶ In the displayed table, for Floor 0 Segment 1 enter the desired "
                                                                          "construction cost (that always in the app "
                                                                          "is considered cost per ft²) "
                                                                          "and desired sell price (that similarly, always "
                                                                          "is considered price per ft²).\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Click ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon to go to the next section "
                                                                          "to define the permit cost for the 1700 ft² area. Then after passing step 3, you will get"
                                                                          " the results, which includes total costs, "
                                                                          "income, profit, and other related metrics.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nA Numerical Example:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Let\'s calculate return on investment in this project given the following parameters:'
                                                                          '\n\n▶ Land Price: \$200/ft² \n'
                                                                          '➔ Land Purchasing Cost = 3,000 ft² × \$200 = \$600,000\n\n'
                                                                          '▶ construction cost: \$300/ft²\n'
                                                                          '➔ construction cost = 1,700 ft² × \$300 = \$510,000\n\n'
                                                                          '▶ Permit Fee: \$20/ft² (you can insert it in the next step of the app)\n'
                                                                          '➔ Permit Cost = 1,700 ft² × \$20 = \$34,000\n\n'
                                                                          '▶ Total Cost = Land Purchasing Cost + construction cost + '
                                                                          'Permit Cost = \$600,000 + \$510,000 + \$34,000 = \$1,144,000\n\n'
              
                                                                          '▶ sell price: \$1,000/ft² of salable area\n'
                                                                          '➔ sell price = 1,700 ft² × \$1,000 = \$1,700,000\n\n'
                                                                          '▶ Total Income = \$1,700,000\n\n'
                                                                          '▶ Profit = Total Income - Total Cost = \$1,700,000 - \$1,144,000 = \$556,000\n\n'
                                                                          '▶ Profit Percentage = (Profit / Total Cost) × 100 = (\$556,000 / \$1,144,000) × 100 = 48.6%\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "■ Please remember that data regarding the purchase of the land "
                                                                          " should be entered on the first part, and permit fees will "
                                                                          "be addressed in the next part. This part focuses solely on the construction cost and sell "
                                                                          "price of segments that contribute to the salable and built-up areas. This example "
                                                                          "is intended to clarify the concept of cost-price segments, assuming that we have "
                                                                          "necessary data for land and permit fees. "
                                                                          "\n\nAs some practices, go back and enter similar numbers for land area and"
                                                                          " land cost in step 1, "
                                                                          " and enter floor-related data in this part. Then in step 3, "
                                                                          "set permit fees that in this example is 20/ft², and put 0 for other basic data "
                                                                          "in step 4 to see the same results.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nExample 2. Duplex Villa",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nThis project is similar to Example 1, involving a 3,000 ft² '
                                                                          'plot of land, but with a duplex villa. The property '
                                                                          'consists of two floors connected by an internal staircase, offering '
                                                                          'a total salable area of 3,400 ft² (1,700 ft² per floor). '
              
                                                                          '\n\n■ Assuming the staircase is a part of the salable area that can '
                                                                          'be sold and has a similar construction cost and sell price '
                                                                          'to the other areas on the floor, you can consider both the '
                                                                          'staircase and other areas on each floor as one unified '
                                                                          'cost-price segment '
                                                                          'in each floor. Because the floors are similar, both '
                                                                          'can be defined in cost-price plan 1. To do this:',
                                                                      style: TextStyle(
                                                                        fontSize: textFontSize,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n1. Set Number of Cost-Price Segments of the First Floor:",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n▶ Enter 1 because the first floor has just one segment. ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button.\n"
                                                                          "▶ In front of Floor 0 Segment 1 enter the area as 1,700 ft². "
                                                                          " Keep the switch ON since the segment is salable.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Enter 1 since there is just one floor (floor 1) "
                                                                          "similar to the floor 0 (ground floor)"
                                                                          " having one segment with 1,700 ft² area.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "4. Set Cost and Sell Prices for the First Floor:",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(text: '\n▶ Press the Set Prices button.'
                                                                        "\n▶ In the displayed table, for Floor 0 - Segment 1 input the cost/ft² "
                                                                        "and sell price/ft².",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n▶ For the second floor, choose one of the following options:"
                                                                          "\n    ➔ Option A: Manually enter cost and sell price."
                                                                          "\n    ➔ Option B: Press ⚙️ icon in the first floor to define cost-price segments in"
                                                                          "the second floor based on the values entered for the first floor segments."
                                                                          "\nFor this case, which involves a few segments, we manually enter the construction cost and sale "
                                                                          "price for the second floor. You can choose to enter different construction costs; however, since "
                                                                          "both floors are components of a single duplex property, it is more logical "
                                                                          "to enter the same sell price for the second floor as you "
                                                                          'did for the first floor but this is opt to you. Ultimately, the decision is yours.',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Since there is no other floors, press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                    WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon at the bottom of the page and proceed through "
                                                                          "the next part to enter permit fees and obtain the results.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\nA Numerical Example:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Let\'s calculate return on investment in this project given the following parameters:'
                                                                          '\n\n ▶ Land Price: \$200/ft² \n'
                                                                          ' ➔ Land Purchasing Cost = 3,000 ft² × \$200 = \$600,000\n\n'
                                                                          ' ▶ construction cost for\n'
                                                                          ' ➔ floor 0 = 1,700 ft² × \$300 = \$510,000\n'
                                                                          ' ➔ floor 1 = 1,700 ft² × \$400 = \$680,000\n'
                                                                          ' ➔ Total construction cost = 680,000 + 510,000 = 1,190,000'
                                                                          '\n\n ▶ Permit Fee of first floor: \$20/ft² (you can insert it in next section)\n'
                                                                          ' ➔ Permit Cost = 1,700 ft² × \$20 = \$34,000\n\n'
                                                                          ' ➔ Total Permit Cost = 2 × \$34,000 = \$68,000\n\n'
                                                                          ' ▶ Total Cost = Land Purchasing Cost + Total construction cost + '
                                                                          'Permit Cost = \$600,000 + \$1,190,000 + \$68,000 = \$1,858,000\n\n'
              
                                                                          ' ▶ Sell price: \$750/ft² of salable area\n'
                                                                          ' ➔ Total Income  = Total salable area × sell price/ft² = 3,400 ft² × \$750 = \$2,550,000\n\n'
              
                                                                          ' ▶ Profit = Total Income - Total Cost = \$2,550,000 - \$1,858,000 = \$692,000\n\n'
                                                                          ' ▶ Profit Percentage = (Profit / Total Cost) × 100 = (\$692,000 / \$1,858,000) × 100 = 37.2%\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '■ As you can see, we inserted two different construction costs/ft² '
                                                                          'for each floor, even though the floors are components of a single property to be '
                                                                          'sold as a duplex at a unique price. Having two different construction costs might be strange but indeed '
                                                                          'this demonstrates the advantage of this app, '
                                                                          'which allows you to enter different construction costs and sell prices for'
                                                                          ' individual parts of a property if you face with such cases.\n\n',
                                                                      style: TextStyle(
                                                                        fontSize: textFontSize,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "Example 3. Two-Floor Apartments",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\nAssume that, similar to Example 2, a project involves "
                                                                          "a 3,000 ft² plot of land with two separate floors "
                                                                          "(Floor 0 and Floor 1), designed as individual properties rather "
                                                                          "than a duplex. Each floor has a salable area of 1,500 ft², along with "
                                                                          "an external staircase that occupies an additional 200 ft² as common area."
              
                                                                          "\n\n■ The staircase, which is not part of the salable area "
                                                                          "in this project, along with the properties, creates two distinct "
                                                                          "cost-price segments in each floor. "
                                                                          "Since the floors are the same, their cost-price segments can be defined in "
                                                                          "cost-price plan 1. "
                                                                          '\n\nSo, after opening the app and adding a new complete calculation project and inputting'
                                                                          ' basic data of the project, define the cost-price segments as below:\n\n',
                                                                      style: TextStyle(
                                                                        fontSize: textFontSize,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Enter 2 as the number of segments for the first floor."
                                                                          " We consider the property as one cost-price segment and the staircase as another.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ For the Floor 0 - Segment 1 (salable area), enter 1,500 ft² and '
                                                                          'keep its switch ON.\n'
                                                                          "▶ For the Floor 0 - Segment 2 (staircase), enter 200 ft² "
                                                                          "and turn off its switch as a non salable segment.\n ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:
                                                                      "▶ Enter 1 because there is just one floor (floor 1) that similar to floor 0 "
                                                                          "has two cost-price segments with area 1,500 ft² and 200 ft².\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Prices button and in the displayed table,"
                                                                          "\n▶ for Floor 0 - Segment 1 (salable area) input cost and sell price/ft²."
                                                                          "\n▶ for Floor 0 - Segment 2 (staircase) input cost/ft² as a common area."
                                                                          "\n▶ Similarly, for the next floor (Floor 1), enter the cost and sell "
                                                                          "price/ft² manually for segment 1 (salable area) and segment 2 "
                                                                          "(staircase). In the next example, we'll learn how to set costs and "
                                                                          "prices for other floors based on the first floor's cost and prices "
                                                                          "in a construction project.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n▶ Since there are no additional floors, you do not "
                                                                          "need to define a new cost-price plan. So, press the ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon to proceed with defining the permit costs for "
                                                                          "the floors you have specified in this section.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "A Numerical Illustration:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Let\'s calculate the return on investment for this project '
                                                                          'given the following parameters:\n\n'
                                                                          '■ Land Price: \$200/ft²\n'
                                                                          '➔ Land Purchasing Cost = 3,000 ft² × \$200 = \$600,000\n\n'
                                                                          '■ construction cost of Floor 0/ft²: \$300\n'
                                                                          '➔ construction cost of Floor 0 = 1,700 ft² × \$300 = \$510,000\n\n'
                                                                          '■ construction cost of Floor 1/ft²: \$400\n'
                                                                          '➔ construction cost of Floor 1 = 1,700 ft² × \$400 = \$680,000\n\n'
                                                                          '■ Total construction cost = \$680,000 + \$510,000 = \$1,190,000\n\n'
              
                                                                          '■ Permit Fee: \$20/ft² (you can insert it in the next section)\n'
                                                                          '➔ Permit Cost = 1,700 ft² × \$20 = \$34,000\n\n'
                                                                          ' ➔ Total Permit Cost = 2 × \$34,000 = \$68,000\n\n'
                                                                          '■ Total Cost = Land Purchasing Cost + Total construction cost + Permit Cost\n'
                                                                          '   = \$600,000 + \$1,190,000 + \$68,000 = \$1,858,000\n\n'
                                                                          '■ Sell Price/ft² for Floor 1 of salable area: \$800 \n'
                                                                          '➔ sell price for Floor 1 = 1,500 ft² × \$850 = \$1,275,000\n\n'
                                                                          '■ Sell Price/ft² for Floor 2 of salable area: \$900\n'
                                                                          '➔ sell price for Floor 2 = 1,500 ft² × \$900 = \$1,350,000\n\n'
                                                                          '■ Total Income = \$1,360,000 + \$1,530,000 = \$2,625,000\n\n'
                                                                          '■ Profit = Total Income - Total Cost\n'
                                                                          '   = \$2,625,000 - \$1,858,000 = 767,000\n\n'
                                                                          '■ Profit Percentage = (Profit / Total Cost) × 100\n'
                                                                          '   = (\$767,000 / \$1,858,000) × 100 = 41.2%\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "□ In this example, the only difference compared to the previous "
                                                                          "one was that we are considering two different sell prices for the "
                                                                          "floors. This is because the floors represent two distinct properties "
                                                                          "not a duplex villa, allowing them to be sold at different "
                                                                          "prices. This scenario illustrates the flexibility of "
                                                                          "pricing individual properties and we can better reflect the unique value "
                                                                          "and market demand for each property.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "Example 4. Five-Floor Apartments With Parking",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nIn this construction project, we are assuming a total of five floors, '
                                                                          'including a parking floor, built on a plot of land measuring 5,000 ft² '
                                                                          'with purchasing price \$400/ft². '
                                                                          'The specifications of floors are as follows:\n\n'
                                                                          '▶ Floor 0 (Parking): This floor has a total area of 3,500 ft², which '
                                                                          'includes 3,200 ft² for parking and 300 ft² for the staircase.\n\n'
                                                                          '▶ Floors 1 to 4: Each of these floors has a total area of 3,000 ft², '
                                                                          'which includes 2,700 ft² for the property and 300 ft² for the staircase. '
                                                                          'This results in four properties available for sale.\n\n'
              
                                                                          '■ construction cost:\n'
                                                                          '  ➔ For parking and staircase areas, the construction cost is \$300/ft².\n'
                                                                          '  ➔ For the property on Floor 1, the construction cost is \$400/ft².\n'
                                                                          '  ➔ The construction costs for properties on Floors 2 to 4 follow an '
                                                                          'arithmetic progression (constant amount added) compared to the construction costs of the property with 2,700 ft² '
                                                                          'area on Floor 1, increasing by \$20 per square foot for each subsequent floor.\n\n'
              
                                                                          '■ Sell Price:\n'
                                                                          '  ➔ For parking and staircase areas, the sell price will be considered 0.\n'
                                                                          '  ➔ The sell price for the property on Floor 1 is \$1,000/ft².\n'
                                                                          '  ➔ The sell prices for the properties on Floors 2 to 4 follow a '
                                                                          'geometric progression compared to the sell price of the property on Floor 1,'
                                                                          ' increasing by 2% per floor.\n\n'
                                                                          '■ Therefore, we can define this investment in two cost-price plans:\n'
                                                                          '▲ cost-price plan 1: Parking floor, with one cost-price segment.\n'
                                                                          '▲ cost-price plan 2: Floors 1 to 4, each with two cost-price segments. \n'
              
                                                                          '\n■ This is because the parking floor and the other floors have different plans in terms of the '
                                                                          'number and area of cost-price segments. In the parking floor, both the parking area '
                                                                          'and staircase are common areas'
                                                                          ' and not salable, also they have same construction cost per ft²,'
                                                                          ' allowing them to be considered '
                                                                          'as a one cost-price segment. Upper floors, which contain '
                                                                          'one property and a staircase, can be classified as two cost-price segments per floor '
                                                                          'because the sell price of the staircase is zero, differing from the sell '
                                                                          'price of the properties. '
                                                                          'Since all upper floors have two segments with the '
                                                                          'same area for both '
                                                                          'the staircase and the properties, they can be defined within one cost-price plan. '
                                                                          '\n\nHowever, at this stage, there is no '
                                                                          'need to understand and calculate the number of cost-price plans. Just follow the steps '
                                                                          'below to configure the cost-price segments for the first floor that here is parking floor. Once '
                                                                          'you reach the last floor, you will find the number of '
                                                                          'cost-price plans as well as total number of floors. So, configure the cost-price segments as follows:',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 1, parking floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.purple, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ The first floor is parking (floor 0), enter 1 as "
                                                                          "the number of cost-price segments in this floor,"
                                                                          " because the parking and staircase spaces have same construction cost/ft². \n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ For the Floor 0 - Segment 1 (parking + staircase), enter 3,500 ft², '
                                                                          'Let the switch be in default mode.\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:
                                                                      "▶ Enter 0 because there is no floor similar to parking floor. \n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "4. Set construction cost:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Prices button and in the displayed table,"
                                                                          "\n▶ for Floor 0 - Segment 1 (parking + staircase) input cost \$300.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                          "through the next cost-price plan to define the cost-price segments for the upper floors.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "cost-price plan 2, floors 1 to 4:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.purple, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ The first floor in cost-price plan 2 is designated as Floor 1. '
                                                                          'This floor includes a property and a staircase, each with distinct '
                                                                          'sell prices. Therefore, enter 2 as the number of cost-price segments for this floor.'
                                                                          '\n\n■ Usually in buildings with separate floors, there is typically at least one '
                                                                          'common area, such as a staircase, in addition to the '
                                                                          'properties available for sale. Consequently, staircase and other '
                                                                          'common areas differ from other salable cost-price segments.'
                                                                          ' As a result, in such buildings there will always be a minimum of two '
                                                                          'cost-price segments, although there may be more depending on '
                                                                          'the financial configuration of the segments.\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Press Set Area button and for the Floor 1 - Segment 1, enter 2,700 '
                                                                          'and for the Floor 1 - Segment 2, enter 300 and turn of switch for the smaller segment.\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:
                                                                      "▶ In the section for the number of similar floors, "
                                                                          "enter 3. This is because Floors 2, 3, and 4 share the "
                                                                          "same cost-price segment configuration as Floor 1. Each of "
                                                                          "these floors consists of 2 segments: a 300 ft² common space "
                                                                          "and a 2,700 ft² property available for sale. \n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          "\n▶ In the displayed table, there are two rows for each floor, totaly 8 "
                                                                          "rows, with each row assigned to a cost-price segment. "
                                                                          "\n\n➔ For Floor 1 - Segment 1 (property with 2,700 ft² area), "
                                                                          'manually enter the construction cost of \$400/ft² and the sell price of \$1,000/ft².'
                                                                          '\n\n➔ For the corresponding segments on the upper floors (Floors 2, 3, and 4) in '
                                                                          'this cost-price plan (number 2), you can either manually enter the cost-price plan '
                                                                          'costs and sell prices as prompted or use ⚙️ icon button at the end '
                                                                          'of the rows for Floor 1. In this example, we will use the icon option. '
                                                                          'By pressing ⚙️ icon, a window will appear with two sections: one for construction '
                                                                          'cost and one for sell price.'
              
                                                                          '\n\n➔ Since the construction cost/ft² for segments 1 of '
                                                                          'floors 2, 3, and 4 should increase by \$20 based on the construction cost of '
                                                                          'Floor 1 - Segment 1, set the "Incremental" switch to "On" and enter 20 in the associated text field, '
                                                                          'this makes an arithmetic progression (constant amount added) for setting costs of segment 1 of the upper floors.'
                                                                          '\n\n➔ Additionally, since the sell price of these segments should increase by 2% based on '
                                                                          'the sell price of Floor 1 - Segment 1, set the "Percentage" switch to On and enter 2. '
                                                                          '\n\n➔ Press the OK button. The window will disappear, and you can check the results '
                                                                          'in the table. You will see that the costs for segments 1 of floors 2, 3, and 4 '
                                                                          'are \$420, \$440, and \$460, respectively, while their sell prices '
                                                                          'are \$1,020, \$1,040.40, and \$1,061.20. Increasing prices by 2% is a geometric progression.'
              
                                                                          '\n\n➔ For Floor 1 - Segment 2 (staircase with 300 ft² area), '
                                                                          'manually enter the construction cost of \$300/ft².'
                                                                          '\n\n➔ For the corresponding segments on the upper floors (floors 2, 3, and 4) in '
                                                                          'this cost-price plan press ⚙️ icon button at the end '
                                                                          'of the row for Floor 1 - Segment 2 and keep Fixed switches "On" for '
                                                                          'both construction cost and '
                                                                          'just press Ok. Then you will get construction cost of '
                                                                          'segment 2 in floors 2, 3, and 4 \$300.  ',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Since there are no additional floors, you do not need "
                                                                          "to define a new cost-price plan. Press the ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon to proceed with defining the permit costs for the floors you "
                                                                          "have specified in this section.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "A Numerical Illustration:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Let’s determine the return on investment for this project '
                                                                          'given the following parameters:\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Floor Information:\n',
                                                                      style: TextStyle(color: Colors.deepPurple, fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '➔ Floor 0 (Parking): Total Area: 3,500 ft², \nParking Area: 3,200 ft², '
                                                                          '\nStaircase Area: 300 ft².\n\n'
                                                                          '➔ Floors 1 to 4: Each Floor Total Area: 3,000 ft², \nProperty Area: '
                                                                          '2,700 ft², \nStaircase Area: 300 ft², \nTotal Properties Available for Sale: 4.\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Cost and Pricing Details:\n',
                                                                      style: TextStyle(color: Colors.deepPurple, fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Land Cost:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize,fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Land Price = \$400/ft²'
                                                                          '\n➔ Land Purchasing Cost = 5,000 '
                                                                          '× \$400 = \$2,000,000\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'construction cost:\n',
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontSize: textFontSize,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Floor 0 (Parking):\n'
                                                                          '   - Parking Area: 3,200 ft²\n'
                                                                          '   - Staircase Area: 300 ft²\n'
                                                                          '   - Total Area: 3,500 ft²\n'
                                                                          '   ➔ construction cost: 3,500 × \$300 = \$1,050,000\n\n'
                                                                          '▶ Floor 1:\n'
                                                                          '   - Property Area: 2,700 ft²\n'
                                                                          '   - Staircase Area: 300 ft²\n'
                                                                          '   ➔ construction cost: 2,700 × \$400 + 300 × \$300 = \$1,170,000\n\n'
                                                                          '▶ Floors 2 to 4:\n'
                                                                          '   - Each Floor Total Area: 3,000 ft²\n'
                                                                          '   - Property Area: 2,700 ft²\n'
                                                                          '   - Staircase Area: 300 ft²\n'
                                                                          '   ➔ construction costs of:\n\n'
                                                                          '     - Floor 2: 2,700 × \$420  + 300 × \$300 = \$1,224,000\n\n'
                                                                          '     - Floor 3: 2,700 × \$440  + 300 × \$300 =  \$1,278,000\n\n'
                                                                          '     - Floor 4: 2,700 × \$460  + 300 × \$300 =  \$1,332,000\n\n'
                                                                          '▶ Total construction cost: \$6,054,000\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Permit Fee:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize,fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Permit Fee = \$30/ft² of total built-up area'
                                                                          '\n - Total built-up '
                                                                          'Area = 15,500 ft²'
                                                                          '\n ➔ Total Permit Cost = \$465,000\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Total Cost:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize,fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Total Cost = Land Purchasing Cost + Total construction cost + '
                                                                          'Permit Cost'
                                                                          '\n➔ Total Cost = \$8,519,000\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Selling  Price (Income) of Segment 1 in:\n',
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontSize: textFontSize,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Floor 1:\n'
                                                                          '   - Segment 1 Area: 2,700 ft²\n'
                                                                          '   - sell price/ft²: \$1,000\n'
                                                                          '   ➔ Total sell price: \$2,700,000\n\n'
                                                                          '▶ Floor 2:\n'
                                                                          '   - Segment 1 Area: 2,700 ft²\n'
                                                                          '   - sell price/ft²: \$1,020 (2% increase from Floor 1)\n'
                                                                          '   ➔ Total sale price: 2,700 × \$1,020 = \$2,754,000\n\n'
                                                                          '▶ Floor 3:\n'
                                                                          '   - Segment 1 Area: 2,700 ft²\n'
                                                                          '   - sell price/ft²: \$1,040.4 (2% increase from Floor 2)\n'
                                                                          '   ➔ Total sale price: 2,700 × \$1,040.4 = \$2,809,080\n\n'
                                                                          '▶ Floor 4:\n'
                                                                          '   - Segment 1 Area: 2,700 ft²\n'
                                                                          '   - sell price/ft²: \$1,061.2 (2% increase from Floor 3)\n'
                                                                          '   ➔ Total sale price: 2,700 × \$1,061.2 = \$2,865,240\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Total Income = \$11,128,347\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Profit:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize,fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Profit = Total Income - Total Cost'
                                                                          '\n➔ Profit = \$2,609,347\n\n',
                                                                      style: TextStyle(  color: Colors.black,
                                                                        fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Profit Percentage:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize,fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Profit Percentage = (Profit / Total Cost) × '
                                                                          '100'
                                                                          '\n➔ Profit Percentage = 30.6%\n\n',
                                                                      style: TextStyle( color: Colors.black,fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\nExample 5. Seven-Floor Apartments With Parking and Terrace",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nIn this cost-price plan project, there are five floors, including a '
                                                                          'parking floor, built on a plot of land measuring 5,000 ft², with a '
                                                                          'purchasing price of \$400/ft². '
                                                                          'The specifications of the floors are as follows:\n\n'
                                                                          '➔ Floor 0 (Parking): This floor has a total area of 3,000 ft², with construction '
                                                                          'cost \$350/ft² which includes'
                                                                          ' 2,700 ft² for parking and 300 ft² for the staircase.\n\n'
                                                                          '➔ Floors 1, 2, and 3: Each of these floors has a total area of 3,000 ft², '
                                                                          'with 1700 ft² for property 1, 1000 ft² for property 2 and 300 ft² for staircase.'
              
                                                                          '\n\n➔ Floors 4, 5, and 6: Each of these floors also has a total area of 3,000 ft², '
                                                                          'which includes a 2,500 ft² for one property, a 300 ft² for the staircase, '
                                                                          'and a 200 ft² for the terrace. The terrace is not fully enclosed and '
                                                                          'climate-controlled, so only 100 ft² of it constitutes salable area according '
                                                                          'to local regulations. \n\nThis configuration results in a total of 9 properties available for sale.\n\n'
              
                                                                          '■ construction cost:'
                                                                          '\nFor parking and staircase areas on all floors: \$300/ft².'
                                                                          'For the property on Floor 1: \$400/ft².'
                                                                          'For properties on Floors 2 to 6, the cost increases by \$20/ft² for each '
                                                                          'subsequent floor compared to Floor 1.'
                                                                          'Terrace construction costs on Floors 4, 5, and 6: \$300/ft².'
                                                                          '\n\n■ Sell Price:'
                                                                          '\nFloor 1 - Segment 1 (1,700 ft²): \$1,200/ft²; Segment 2 (1,000 ft²): \$1,000/ft².'
                                                                          'Sell prices for Floors 2 and 3 increase by 2% per floor. For example, '
                                                                          'Floor 1 - Segment 1: \$1,224/ft².'
                                                                          'Floor 4 (2,500 ft²): \$1,500/ft²; Floors 5 and 6 increase by \$50/ft².'
                                                                          ' For example, Floor 5: \$1,550/ft².'
              
                                                                          '\n\n■ Therefore, without knowing sell prices and due to different construction costs for '
                                                                          'segments in floors 1, 2 and 3 we can define this investment in 3 cost-price plans: '
                                                                          '\n▲ cost-price plan 1: The parking floor'
                                                                          '\n▲ cost-price plan 2: Floors 1, 2, and 3 with three cost-price '
                                                                          'segments, including the staircase and two properties with different sell price/ft²'
                                                                          '\n▲ cost-price plan 3: Floors 4, 5, and 6 that has three cost-price segments, '
                                                                          'including the staircase, one '
                                                                          'property for sale, and half of the terrace. To configure the cost-price segments '
                                                                          'efficiently and enter numbers faster, it\'s recommended to read through '
                                                                          'this example, write down the numbers on paper, and then implement them in the app.'
                                                                          '\n\nConfigure the cost-price segments as follows:'
                                                                      ,
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 1, Floor 0 (parking):\n",
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segment of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Enter 1 as the number of cost-price segments of first "
                                                                          "floor in the cost-price plan 1 (floor 0).\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Areas button.'
                                                                          "\n▶ In the displayed table, for Floor 0 - Segment 1, enter 3,000, "
                                                                          "and turn off its switch to be recognized as non sealable",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Input 0 in front of the number of similar floors "
                                                                          "because there is no other floor similar to parking.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "4. Set Cost:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          "▶ Enter 300 for construction cost.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                          "through the next cost-price plan to define the cost-price segments "
                                                                          "for the upper floors.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 2, Floor 1, 2, 3:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ The first floor in cost-price plan 2 is floor number 1, "
                                                                          "that includes 2 properties and staircase, "
                                                                          "totally 3 cost-price segments, so enter 3.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button."
                                                                          "\n▶ In front of Floor 0 segment 1 enter the area as 1,700 ft². "
                                                                          "\n▶ In front of Floor 0 segment 2 enter the area as 1,000 ft². "
                                                                          "\n▶ In front of Floor 0 segment 3 enter the area as 3,00 ft². ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\n▶ Enter 2 as the number of similar floors, as floors 2 and 3 '
                                                                          'are similar to floor 1. Each of these floors has 3 cost-price segments, with a '
                                                                          'corresponding segment on floor 1 for every segment on these floors.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\n▶  Press the Set Prices button.'
                                                                          '\n▶ In the displayed table, for Floor 1:\n'
                                                                          '   △ For segment with 1,700 ft²:\n'
                                                                          '   ➔ Input the construction cost as \$400/ft².\n'
                                                                          '   ➔ Input the sell price as \$1,200/ft².\n'
                                                                          '   △ For segment with 1,000 ft²:\n'
                                                                          '   ➔ Input the construction cost as \$400/ft².\n'
                                                                          '   ➔ Input the sell price as \$1,000/ft².\n'
                                                                          '   △ For segment with 300 ft² (staircase):\n'
                                                                          '   ➔ Input the construction cost as \$300/ft².\n'

                                                                          '\n▶ Press ⚙️ icon at the end of the rows of segments 1 and 2.'
                                                                          ' In the window that appears:\n'
                                                                          '   ➔ For construction cost, turn the "Incremental" switch ON and enter 20.\n'
                                                                          '   ➔ For sell price, turn the "Percentage" switch ON '
                                                                          'and enter 2 as the rate of increase For sell prices of these segments on the upper floors '
                                                                          'in this cost-price plan, floors 2 and 3.'
                                                                          '\n▶ Press "OK" to save the changes.'
                                                                          '\n▶ Press ⚙️ icon at the end of the row of segment 3 (staircase).\n'
                                                                          '   ➔ For construction cost, keep the "Fixed" switch ON and enter 300.\n'
                                                                          '   ➔ For sell price, keep the "Fixed" switch ON and enter 0.\n'
                                                                          '▶ Press "OK" to save the changes.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                      text: " icon and input data regarding the last cost-price plan.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 3, Floor 4, 5, 6:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'The first floor in cost-price plan 3 is Floor 4, '
                                                                          'which includes one property of 2,500 ft², a staircase, '
                                                                          'and one terrace of 200 ft². Since half of the terrace is '
                                                                          'considered salable area, we treat it as two distinct parts: '
                                                                          'one part as a separate property and the other as a common '
                                                                          'area that is not salable.\n\n'
                                                                          '■ So enter 3, since we can identify 3 cost-price segments:\n'
                                                                          '➔ Property Segment: The property of 2,500 ft².\n'
                                                                          '➔ Salable Terrace Segment: The 100 ft² of the terrace '
                                                                          'that is salable, which has a different construction cost.\n'
                                                                          '➔ Non-Salable Segment: The remaining 100 ft² of the terrace '
                                                                          'and 300 ft² the staircase, in total 400 ft² which are not salable and '
                                                                          'share the same construction cost.'
                                                                          'Thus, you should enter "3" for the number of cost-price segments.\n\n'
                                                                          '■ If the second part of the terrace and the staircase have different '
                                                                          'construction costs/ft², we should consider them as two separate cost-price '
                                                                          'segments. However, in this example, we can treat them as one cost-price segment '
                                                                          'to reduce the amount of data entry and simplify operations',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button."
                                                                          "\n▶ In front of Floor 0 segment 1 enter the area as 2,500 ft². "
                                                                          "\n▶ In front of Floor 0 segment 2 enter the area as 1,00 ft². "
                                                                          "\n▶ In front of Floor 0 segment 3 enter the area as 4,00 ft² and just for this turn switch off. ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Enter 2 as the number of similar floors, as floors 5 and 6'
                                                                          'are similar to floor 4. Each of these floors has 3 cost-price segments, with a '
                                                                          'corresponding segment on floor 1 for every segment on these floors.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.'
                                                                          "\n\n▶ In the displayed table for Floor 4,"
                                                                          "\n ➔ For the segment 1 with 2,500 ft²:"
                                                                          "\n ➔ Input the sell price as \$1,500/ft², and enter the construction cost 460"
                                                                          " as it should be equal to the construction cost of the properties in Floor 3 plus \$20."
                                                                          "\n\n▶ Press ⚙️ icon at the end of the row to set the cost-price plan and sell "
                                                                          "prices for corresponding segment on the floors 5 and 6. In the window that appears:"
                                                                          "\n - For construction cost, turn the 'Incremental' switch ON and enter 20."
                                                                          "\n - For sell price, turn the 'Percentage' switch ON and enter 2."
                                                                          "\n\n▶ Press 'OK' to save the changes."
              
                                                                          "\n\n ➔ For the segment 2 with 100 ft² (salable area of terrace):"
                                                                          " ➔ Input the sell price as \$1,500/ft² and enter the construction cost 300."
                                                                          ' Press ⚙️ icon at the end of the row of this segment and similarly '
                                                                          "\n - For construction cost, keep the 'Fixed' switch ON."
                                                                          "\n - For sell price, turn the 'Percentage' switch ON "
                                                                          "and enter 2 and enter nothing."
              
                                                                          "\n ➔ For the segment 3 with 400 ft²:"
                                                                          "\n ➔ Input the construction cost 300."
                                                                          '\n\n Press ⚙️ icon at the end of the row of this segment and similarly '
                                                                          "\n - For construction cost, keep the 'Fixed' switch ON.",
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Since there are no additional floors, press the ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon to proceed with defining the permit costs for the floors you "
                                                                          "have specified in this section.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "A Numerical Illustration:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\nFloor Price Specifications:\n',
                                                                      style: TextStyle(color: Colors.deepPurple, fontSize: textFontSize,
                                                                        fontWeight: FontWeight.bold,),
              
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:  '■ construction cost Review:'
                                                                          '\n ➔ For parking, terrace and staircase areas on all floors, the construction cost is \$300/ft².'
                                                                          '\n\n ➔ For the property on Floor 1, the construction cost is \$400/ft².'
                                                                          '\n\n ➔ The construction costs for properties on Floors 2 to 6 follow an arithmetic '
                                                                          'progression compared to the construction cost of the property on the first floor. '
                                                                          'The cost increases by \$20 per square foot for each subsequent floor, starting from '
                                                                          'the base cost on the first floor.'
                                                                          '\n\n ➔ The construction costs for the terrace on Floors 4, 5, and 6 are \$300/ft².'
                                                                          '\n■ Sell Price Review:'

                                                                          '\n\n ➔ The sell price for the property on Floor 1 - Segment 1 (1,700 ft²) is \$1,200/ft², '
                                                                          'and for Floor 1 - Segment 2 (1,000 ft²) it is \$1,000/ft².'
                                                                          '\n\n ➔ The sell prices for the corresponding properties on Floors 2 and 3 follow a geometric '
                                                                          'progression, increasing by 2% per floor. For example, the sell price for the property on '
                                                                          'Floor 1 - Segment 1 (1,700 ft²) is \$(1,200 + 2% × 1,200) = \$1,224/ft².'
              
                                                                          '\n\n ➔ The sell price for the property on Floor 4 (2,500 ft²) is \$1,500/ft², '
                                                                          'and the sell prices for the corresponding properties on Floors 5 and 6 follow '
                                                                          'an arithmetic progression, increasing by \$50/ft². For example, the sell price '
                                                                          'for the property on Floor 5 (2,500 ft²) is \$(1,500 + 50) = \$1,550/ft².\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: 'Costs:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                    TextSpan(
                                                                      text: '▲ construction cost of:'
                                                                          '\n\n▶ Parking: 3,000 ft² × \$300/ft² = \$900,000\n'
              
                                                                          '\n▶ Floor 1:'
                                                                          '\n➔ Segment 1: 1,700 ft² × \$400/ft² = \$680,000\n'
                                                                          '\n➔ Segment 2: 1,000 ft² × \$400/ft² = \$400,000\n'
                                                                          '\n➔ Segment 2: 300 ft² × \$300/ft² = \$90,000\n'
                                                                          '\n▶ Floor 2:'
                                                                          '\n➔ Segment 1: 1,700 ft² × \$420/ft² = \$714,000\n'
                                                                          '\n➔ Segment 2: 1,000 ft² × \$420/ft² = \$420,000\n'
                                                                          '\n➔ Segment 2: 300 ft² × \$300/ft² = \$90,000\n'
                                                                          '\n▶ Floor 3:'
                                                                          '\n➔ Segment 1: 1,700 ft² × \$440/ft² = \$748,000\n'
                                                                          '\n➔ Segment 2: 1,000 ft² × \$440/ft² = \$440,000\n'
                                                                          '\n➔ Segment 2: 300 ft² × \$300/ft² = \$90,000\n'
                                                                          '\n▶ Floor 4:'
                                                                          '\n➔ Segment 1: 2,500 ft² × \$460/ft² = \$1,150,000\n'
                                                                          '\n➔ Segment 2: 100 ft² × \$300/ft² = \$30,000\n'
                                                                          '\n➔ Segment 2: 400 ft² × \$300/ft² = \$120,000\n'
                                                                          '\n▶ Floor 5:'
                                                                          '\n➔ Segment 1: 2,500 ft² × \$480/ft² = \$1,200,000\n'
                                                                          '\n➔ Segment 2: 100 ft² × \$300/ft² = \$30,000\n'
                                                                          '\n➔ Segment 2: 400 ft² × \$300/ft² = \$120,000\n'
                                                                          '\n▶ Floor 6:'
                                                                          '\n➔ Segment 1: 2,500 ft² × \$500/ft² = \$1,250,000\n'
                                                                          '\n➔ Segment 2: 100 ft² × \$300/ft² = \$30,000\n'
                                                                          '\n➔ Segment 2: 400 ft² × \$300/ft² = \$120,000\n'
                                                                          '\n▶ Total construction costs:\n'
                                                                          '    = 900,000 + 680,000 + 400,000 + 714,000 + 420,000 + 748,000 + 440,000 + '
                                                                          '1,150,000 + 1,200,000 + 1,250,000 + 3 × 90,000 + 3 × 30,000 + 3 × 120,000= \$8,622,000\n\n'
                                                                          '▲ Permit Cost:'
                                                                          '\n➔ Permit Fee per ft²: \$30'
                                                                          '\n➔ Total built-up area: 21,000 ft²'
                                                                          '\n▶ Total Permit Costs:\n'
                                                                          '     21,000 ft² × \$30/ft² = \$630,000\n\n'
                                                                          '\n■ Total Costs:'
                                                                          '\n   ➔ Total Costs = Total Land Cost + Total construction costs + Total Permit Costs'
                                                                          '\n   ➔ Total Costs = \$2,000,000 + \$8,622,000 + \$630,000 = \$11,252,000\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Sell Prices:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▲ Sell Price of:\n\n'
                                                                          '▶ Floor 1\n'
                                                                          '  ➔ Segment 1: 1,700 ft² × \$1,200/ft² = \$2,040,000\n'
                                                                          '  ➔ Segment 2: 1,000 ft² × \$1,000/ft² = \$1,000,000\n\n'
                                                                          '▶ Floor 2\n'
                                                                          '  ➔ Segment 1: 1,700 ft² × (\$1,200 + 2% increase) = 1,700 ft² × \$1,224/ft² = \$2,080,800\n'
                                                                          '  ➔ Segment 2: 1,000 ft² × (\$1,000 + 2% increase) = 1,000 ft² × \$1,020/ft² = \$1,020,000\n\n'
                                                                          '▶ Floor 3\n'
                                                                          '  ➔ Segment 1: 1,700 ft² × (\$1,224 + 2% increase) = 1,700 ft² × \$1,248.48/ft² = \$2,122,416\n'
                                                                          '  ➔ Segment 2: 1,000 ft² × (\$1,020 + 2% increase) = 1,000 ft² × \$1,040.40/ft² = \$1,040,400\n\n'
                                                                          '▶ Floor 4\n'
                                                                          '  ➔ Segment 1: 2,500 ft² × \$1,500/ft² = \$3,750,000\n'
                                                                          '  ➔ Segment 2: 100 ft² × \$1,500/ft² = \$150,000\n\n'
                                                                          '▶ Floor 5\n'
                                                                          '  ➔ Segment 1: 2,500 ft² × (\$1,500 + \$50) = \$3,875,000\n'
                                                                          '  ➔ Segment 2: 100 ft² × \$1,550/ft² = \$155,000\n\n'
                                                                          '▶ Floor 6\n'
                                                                          '  ➔ Segment 1: 2,500 ft² × (\$1,550 + \$50) = \$4,000,000\n'
                                                                          '  ➔ Segment 2: 100 ft² × \$1,600/ft² = \$160,000\n\n'
                                                                          '■ Total Income:\n'
                                                                          '  = \$2,040,000 + \$1,000,000 + \$2,080,800 + \$1,020,000 + \$2,122,416 '
                                                                          '+ \$1,040,400 + \$3,750,000 + \$150,000 + \$3,875,000 + \$155,000 + \$4,000,000 + \$160,000'
                                                                          '  = \$21,393,616\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nProfit:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text:
                                                                      '▶ Profit = Total Sales - Total Costs\n'
                                                                          '   = 21,393,616 - 11,252,000 = \$10,141,616\n\n'
                                                                          '➔ Profit Percentage:\n'
                                                                          '   Profit Percentage = (Profit / Cost) × 100\n'
                                                                          '   = (5,713,800 / 11,252,000) × 100 = 90.1%\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Summary of Results:\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '➔ Total Land Cost: \$2,000,000\n'
                                                                          '➔ Total construction cost: \$8,622,000\n'
                                                                          '➔ Total Permit Cost: \$630,000\n'
                                                                          '➔ Total Cost: \$11,252,000\n'
                                                                          '➔ Total Sale: \$21,393,616\n'
                                                                          '➔ Profit: \$10,141,616\n'
                                                                          '➔ Profit Percentage: 90.1%\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\nExample 6. Tower with 100 Properties",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nIn this construction project, there are 30 floors above ground, built on a plot of '
                                                                          'land measuring 15,000 ft², with a purchasing price of \$500/ft². The specifications '
                                                                          'of the floors are as follows:\n\n'

                                                                          '▲ Floors -3, -2, and -1 (Underground Parking floors): Each of these '
                                                                          'floors has a total area of 9,500 ft².\n\n'
                                                                          '▲ Ground Floor (Floor 0): This floor serves as the main lobby, providing access to the '
                                                                          'building and connecting to the underground parking floors with area 9,500 ft².\n\n'

                                                                          '▲ Floors 1 to 24: Each of these floors has a total area of 9,500 ft², which includes:\n'
                                                                          '   ➔ Three properties, each with an area of 2,000 ft² (totaling 6,000 ft²)\n'
                                                                          '   ➔ One larger property with an area of 3,000 ft²\n'
                                                                          '   ➔ 500 ft² allocated for staircases and elevators.\n\n'

                                                                          '▲ Floors 25 to 28: Each of these floors contains one penthouse property '
                                                                          'with a total area of 9,000 ft², and 500 ft² for staircases and elevators.\n\n'

                                                                          '▲ Floor 29: This floor is designated for cooling, heating equipments and maintenance facilities.\n\n'
                                                                          '■ construction cost:\n'
                                                                          ' ➔ Floor 1: \$500/ft²\n'
                                                                          ' ➔ Floors 2 to 24: Increases by \$2 for each subsequent floor\n'
                                                                          ' ➔ Penthouses (Floors 25 to 28): Starts at \$600/ft², increasing by \$50/ft² for each subsequent floor\n\n'
                                                                          '■ Sell Price:\n'
                                                                          ' ➔ Floor 1 (2,000 ft²): \$1,500/ft²\n'
                                                                          ' ➔ Larger properties (3,000 ft²): \$1,800/ft²\n'
                                                                          ' ➔ Floors 2 to 24: Increases by 2% per floor\n'
                                                                          'Penthouses (Floors 25 to 28): Starts at \$4,000/ft², increasing by \$100/ft² for each subsequent floor'
                                                                          '\n\n◆ This configuration results in a total of 100 properties available for sale, '
                                                                          'with a mix of standard apartments and luxury penthouses.\n\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: '◆ Therefore, we can define this investment simply in 4 cost-price plans:\n'
                                                                          '▲ cost-price plan 1: Parking floors, and ground floor (lobby) having one cost-price segment.\n'
                                                                          '▲ cost-price plan 2: Floors 1 to 24, which have 5 cost-price segments '
                                                                          'each, 4 properties and the staircase/elevator.\n'
                                                                          '▲ cost-price plan 3: The penthouses on Floors 25 to 28, which have two segments, '
                                                                          'one property each and staircase/elevator.\n'
                                                                          '▲ cost-price plan 4: Floor 29 (maintenance floor) having one cost-price segment.\n\n'
                                                                          'Configure the cost-price segments as follows:',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n\nCost-price plan 1, Floors -3, -2, -1:",
                                                                      style: TextStyle(
                                                                        color: Colors.purple, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ The first floor in cost-price plan 1 is floor number -3, "
                                                                          "that includes parking and elevator-staircase spaces "
                                                                          "that can be considered as one cost-price segment because all have same construction cost/ft²."

                                                                          '\n\n Note that if your keyboard does not allow you to enter '
                                                                          'negative numbers (e.g., -3), you can enter zero as the '
                                                                          'first floor of the project on the first page of the app, which corresponds to the first parking '
                                                                          'floor. This adjustment will not affect the financial '
                                                                          'results of the project, but the total number of floors will differ '
                                                                          'from those mentioned in the example.',
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button."
                                                                          "\n▶ In front of Floor -3 segment 1 enter the area as 9,500 ft². Turn off its switch to be non salable.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Enter 3 as the number of similar floors, as floors -2, -1 and 0 (ground Floor) '
                                                                          'are similar to Floor -3. Each of these floors has 1 cost-price segment with 9,500 ft² area.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          '▶ In the displayed table, for Floor -3 - segment 1:\n'
                                                                          ' ➔ Input the construction cost as \$400/ft².\n'
                                                                       
                                                                          '▶ Press ⚙️ icon at the end of all rows. In the window that appears:\n'
                                                                          ' ➔ For construction cost, do not '
                                                                          'change any switches or enter any values.\n'
                                                                          '▶ Press "OK" to save the changes.'
                                                                          '\n\nYou will see that the construction cost for all floors '
                                                                          ' are set to \$400, respectively.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                      text: " icon and input data regarding the cost-price plan 2.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 2, Floors 1 to 24:",
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ The first floor in cost-price plan 2 is floor 1 which "
                                                                          "is the upper floor above Floor 0 (lobby), "
                                                                          "that includes 4 property and elevator-staircase spaces "
                                                                          "totally 5 cost-price segments, so enter 5.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button."
                                                                          "\n▶ In front of Floor 0 segment 1, 2 and 3 enter the area as 2,000 ft²."
                                                                          "\n▶ In front of Floor 0 segment 4 enter the area as 3,000 ft². "
                                                                          "\n▶ In front of Floor 0 segment 5 enter the area as 500 ft² With salable switch off. ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Enter 23 as the number of similar floors, as floors 2 to 24 (including Floor 2) '
                                                                          'are similar to Floor 1. Each of these floors has 5 cost-price segments, with a '
                                                                          'corresponding segment on Floor 1 for every segment on these floors.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          '\n▶ In the displayed table, for Floor 1:\n'
                                                                          '   ➔ For segments with 2,000 ft²:\n'
                                                                          '     - Input the construction cost as \$500/ft².\n'
                                                                          '     - Input the sell price as \$1,500/ft².\n\n'
                                                                          '   ➔ For segments with 3,000 ft²:\n'
                                                                          '     - Input the construction cost as \$500/ft².\n'
                                                                          '     - Input the sell price as \$1,800/ft².\n\n'
              
                                                                          '▶ Press ⚙️ icon at the end of the rows with area 3,000 ft² and 2,000 ft².'
                                                                          ' In the window that appears:\n'
                                                                          '   ➔ For construction cost, turn the Incremental switch ON and enter 2 to increase cost by '
                                                                          '\$2 for each subsequent floor.\n'
                                                                          '   ➔ For sell price, turn the Percentage switch ON '
                                                                          'and enter 2 as the rate of increase For sell prices of these segments on the upper floors.\n\n'
                                                                          '▶ Press "OK" to save the changes.'
                                                                          '   ➔ For segments with 500 ft²:\n'
                                                                          '     - Input construction cost as \$400/ft².\n'
                                                                          '▶ Press ⚙️ icon at the end of the row with area 500 ft², and '
                                                                          'do not change any switches or enter any values.\n'
                                                                          '▶ Press "OK" to save the changes.'
                                                                          '\n\nYou should see that the construction cost for all floors '
                                                                          'from 2 to 24 for this segment.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                      text: " icon and input data regarding the cost-price plan 3.\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\nCost-price plan 3, Floors 25 to 28:",
                                                                      style: TextStyle(
                                                                        color: Colors.purple,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ The first floor in cost-price plan 3 is floor 25 which "
                                                                          "includes one property and elevator-staircase spaces "
                                                                          "totally 2 cost-price segments, so enter 2.",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Area button."
                                                                          "\n▶ In front of Floor 25 segment 1 enter the area as 9,000 ft²."
                                                                          "\n▶ In front of Floor 25 segment 2 enter the area as 500 ft² and change its salable switch to off ",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Main text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Enter 3 as the number of similar floors, as floors 26 to 28 '
                                                                          'are similar to floor 25. Each of these floors has 2 cost-price segments '
                                                                          'with 9,000 and 500 ft² areas.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          '\n▶ In the displayed table, for Floor 25:\n'
                                                                          '   ➔ For segments with 9,000 ft²:\n'
                                                                          '     - Input the construction cost as \$600/ft².\n'
                                                                          '     - Input the sell price as \$4,000/ft².\n\n'
              
                                                                          '▶ Press ⚙️ icon at the end of the rows with area 3,000 ft² and 2,000 ft².'
                                                                          ' In the window that appears:\n'
                                                                          '   ➔ For construction cost, turn the Incremental switch ON and enter 50 to increase cost by '
                                                                          '\$50 for each subsequent floors.\n'
                                                                          '   ➔ For sell price, turn the Percentage switch ON '
                                                                          'and enter 100 as the rate of increase For sell prices of this segment on the upper floors.\n\n'
                                                                          '▶ Press "OK" to save the changes.'
                                                                          '   ➔ For segments with 500 ft²:\n'
                                                                          '     - Input construction cost as \$400/ft².\n'
                                                                          '▶ Press ⚙️ icon at the end of the row with area 500 ft², and '
                                                                          'do not change any switches or enter any values.\n'
                                                                          '▶ Press "OK" to save the changes.'
                                                                          '\n\nYou will see that the construction cost and sell price.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
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
                                                                      text: " icon and input data regarding the last cost-price plan.\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\nCost-price plan 4, floor number 29:",
                                                                      style: TextStyle(
                                                                        color: Colors.purple, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '▶ The only floor in this cost-price plan is Floor 29 '
                                                                          '(the maintenance floor), which is entirely assigned for '
                                                                          'equipment spaces and elevator/staircase spaces. '
                                                                          'Therefore, enter 2 as the number of cost-price segments for this floor.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "\n\n2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(text: '▶ For the first segment enter 9,000.\n'
                                                                        '▶ For the second segment enter 500. Turn off salable switch of both segments.\n',
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(text: "\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(text: '▶ Enter 0, because there is no other floors.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ Press the Set Prices button.\n'
                                                                          '▶ In the displayed table, for Floor 29 - Segment 1:\n'
                                                                          '   ➔ Input the construction cost as \$700/ft².\n'

                                                                          '▶ For Floor 29 - Segment 2:\n'
                                                                          '   ➔ Input the construction cost as \$400/ft².\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Section:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: "▶ Press ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     WidgetSpan(
                                                                      child: Icon(
                                                                        Icons.done_all_outlined,
                                                                        size: iconSizeSmall, // Adjust size as needed
                                                                        color: Colors.red, // Match the text color
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: " icon at the bottom of the page and proceed "
                                                                          "through the next section to define permit fees for floors -3 to 29.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\nA Numerical Illustration:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\nCost and Pricing Details:\n',
                                                                      style: TextStyle(color: Colors.deepPurple, fontSize: textFontSize,fontWeight: FontWeight.bold,),
                                                                    ),
                                                                     TextSpan(
                                                                      text: '\n■ construction cost:'
                                                                          '\n\n ➔ For parking, ground floor (lobby) and staircase areas on all '
                                                                          'floors, the construction cost is \$400/ft².'
                                                                          '\n\n ➔ For properties on floor 1 the construction cost is \$500/ft² '
                                                                          'and for properties on floors 2 to 24, increases \$2 for each subsequent floor.'
                                                                          '\n\n ➔ The construction costs for the penthouses on floors 25 to 28 '
                                                                          'increase by \$50/ft² for each subsequent floor, starting at \$600/ft² for floor 25.'
                                                                          '\n\n ➔ The construction cost for the maintenance floor (floor 29) is \$700/ft².',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\n\n■ Sell Price:'
                                                                          '\n\n ➔ For parking and staircase areas, the sell price is \$0.'
                                                                          '\n\n ➔ The sell price for the property on floor 1 (2,000 ft²) is \$1,500/ft².'
                                                                          '\n\n ➔ The sell price for the larger property on each of these floors (3,000 ft²) is \$1,800/ft².'
                                                                          '\n\n ➔ The sell price for the properties on floors 2 to 24 '
                                                                          'increase by 2% per floor. For example, the sell price for the properties with area 2,000 ft² on '
                                                                          'floor 2 is \$(1,500 + 2% × 1,500) = \$1,530/ft² and for the same properties on floor 24 it is \$2,412,66/ft².'
                                                                          '\n\n ➔ The sell prices for the penthouses is \$4,000/ft² for floor 25, '
                                                                          'increasing by \$100/ft² for each subsequent floor.'
                                                                          '\n\n ➔ The sell price for the maintenance floor (floor 29) is \$0, as it is not for sale.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize,),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'If you implement the calculations based on the above data '
                                                                          'in the app, you\'ll get the following results:\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:'▶ Land Cost \n'
                                                                          ' ➔ Land Area: 15,000 ft²\n'
                                                                          ' ➔ Land Cost per Square Foot: \$500\n'
                                                                          ' ➔ Total Land Cost: 15,000 ft² × \$500 = \$7,500,000\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:'▶ Total built-up area: Floor Area for Floors -3 to 29: 33 × 9,500 ft² = 313,500'
                                                                      ,
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\n\n▶ Permit Fee \n'
                                                                          ' ➔ Total Permit Fee = Total built-up area × Permit Fee per ft²\n'
                                                                          ' ➔ Total Permit Fee = 313,500 ft² × \$30 = \$9,405,000\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: '▬ Typical Floor (Floor 1)\n'
                                                                          ' ➔ construction cost for Floor 1 = \$500 × 2,000 ft² × 3 + \$500 × 3,000 ft² '
                                                                          '+ 400 × 500 = \$4,700,000'
                                                                          '\n ➔ Income of selling Floor 1 = \$1,500 × 2,000 ft² × 3 + \$1,800 × 3,000 ft² = \$14,400,000'
                                                                          '\n\nCalculating the construction costs and sale prices of '
                                                                          'properties across different floors can be time-consuming, often '
                                                                          'taking hours to complete. However, with this app, you can obtain '
                                                                          'the project\'s results in just a few minutes.',
                                                                          style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\n\nBy implementing calculations in the app you '
                                                                          'should get this results:'
              
                                                                          '\n\n ▶ Total Cost of Project: \$181,473,000\n'
                                                                          ' ▶ Total Income: \$587,474,760\n'
                                                                          ' ▶ Total Profit: \$406,001,760\n'
                                                                          ' ▶ Profit Percentage: 223.7%\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
              
                                                                     TextSpan(
                                                                      text: 'Repairment-Modification Cost-Benefit Analysis\n',
                                                                      style: TextStyle(color: Colors.pink, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Although the financial calculator of this app is primarily designed '
                                                                          'for calculating the return on investment of a new construction project '
                                                                          'built from scratch on land, it can also be used for analyzing the '
                                                                          'cost-benefit of repairing an existing building.\n\n'
                                                                          'Assume a building has two floors constructed on a plot '
                                                                          'which are separate properties connected by a staircase, and you want to add an elevator.'
                                                                          'You might also want to repair the property on the second floor, and these repairs '
                                                                          'affect price of both properties.'
                                                                          '\n\nTherefore, you need to add the differences in price for both '
                                                                          'properties you will offer for sale. This will help you determine '
                                                                          'the positive income that will result from the repairs. '
                                                                          'Then, deduct the total costs of repairs from this income. This includes '
                                                                          'the cost related to the elevator and the cost of repairing the second floor.\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Implementing Calculations\n',
                                                                      style: TextStyle(color: Colors.purple, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'To implement these calculations related to a repairment-renovation in the app:'
                                                                          '\n\n1. define a new project construction.\n'
                                                                          'Include just all cost-price segments that are affected by the repairs for this project.\n'
                                                                           '\n2. Input the cost of Repairs for each cost-price segment that is repaired.'
                                                                            '\n\n3. Input the expected Difference in sell price for each segment that you expect '
                                                                            'to have a different price after the repair.\n\n'
              
                                                                          'Therefore, do not enter the cost of construction and sell price as for a new building project. '
                                                                          'Instead, enter the cost of repairs and the expected difference in sell price.\n\n'
                                                                          'For segments that have no repairs but their sell price would change, enter zero as the repair costs, '
                                                                          'then, enter the expected difference in sell prices.\n'
                                                                          'Read example 7 to know the instructions well.\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '■ Do not enter the land price, \n'
                                                                          'unless you have repairs in the yard or roof of the building. To do that, enter their '
                                                                          'repair or renovation costs of yard-roof on the third step.\n\n '
                                                                          '■ If there are permit fees for the repairs, enter their costs '
                                                                          'in the permit fee part. '
                                                                          'Otherwise, input zero for all permit fees since the original '
                                                                          'permit fees should be entered for a new construction of a new '
                                                                          'building not the old buildings that you want to renovate.\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Results and Profit Analysis\n',
                                                                      style: TextStyle(color: Colors.teal, fontSize: textFontSize, fontWeight: FontWeight.bold),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'Finally, you will receive the results of the difference in income and '
                                                                          'costs associated with the repairment.\n'
                                                                          'If income is positive, the repairs and modifications have a positive financial output.\n'
                                                                          'If not, you may not recover more than you spend on repairs and modifications.\n'
                                                                          'However, this may still positively affect the time it takes to sell your home.\n'
                                                                          'In other words, your home may sell sooner.',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n\nExample 7. Repair of a Three-Floor Apartments",
                                                                      style: TextStyle(
                                                                        color: Colors.pink,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '\n\nAssume that an existing building constructed on a 3,000 ft² plot of land '
                                                                          'has three separate floors (Floor 0, 1 and 2), designed as distinct '
                                                                          'properties. Each floor has a salable area of 1,500 ft², along with '
                                                                          'an external staircase that occupies an additional 200 ft² as common '
                                                                          'area. The project was constructed several years ago, and you want to '
                                                                          'modify it by inserting an elevator at a purchasing cost of \$30,000. '
                                                                          'The elevator will occupy 50 ft² of the common area, leaving 150 ft² '
                                                                          'for the staircase. The reconstruction of the common area to install '
                                                                          'the elevator will cost \$100/ft² for the 50 ft² area on each floor.\n\n'
                                                                          'Additionally, there is a repair cost of \$120/ft² for the second '
                                                                          'floor (Floor 1). Finally, the sell price for properties in floors 1 and 2 will increase '
                                                                          'by \$150 per square foot.'
                                                                          '\n\nTo implement the cost benefit analysis of the repairment of this project:\n'
              
                                                                          '▶ Open app and add a new complete calculation, on the first page of '
                                                                          'defining the new project, enter 0 for land area and the price of '
                                                                          'land and costs related to the roof-yard and transaction cost since there is no '
                                                                          'purchase cost for land or renovations in the yard or roof.'
                                                                          '\n▶ Enter \$30,000 in "other costs" part to account elevator cost in the total cost. '
                                                                          'Enter 0 for the first floor number. No matter what you enter as the number of properties, because '
                                                                          'this gives you a metric when you have a new construction not repairment, you can enter 3. \n'
                                                                          '\n▶ To define the cost-price segments of the floors, for analyzing the cost-benefit of the '
                                                                          'repairs remember that you need to enter the cost of repairs, not the construction cost.\n'
                                                                          '\nTo do that, go to the next part and follow these steps:\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n1. Set Number of Cost-Price Segments of the First Floor:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: 'First floor affected by repairment is floor 0. '
                                                                          'Enter 2 as the number of segments for the first floor, the 1,500 ft² property'
                                                                          ' as one cost-price '
                                                                          'segment and the elevator as another. Since there is no cost '
                                                                          'associated with the staircase repair, and the staircase is'
                                                                          ' not for sale or affected by the overall improvement of the '
                                                                          'building, we can ignore defining the staircase as another cost-price segment.\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "2. Input Segment Area:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: '▶ For the Floor 0 - Segment 1 (salable area), enter 1,500.\n'
                                                                          "▶ For the Floor 0 - Segment 2 (elevator), enter 50.\n ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n3. Enter Number of Similar Floors:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: 'Enter 2 as the number of similar floors to the floor 0. '
                                                                          'Similar to floor 0, floors 1 and 2 has two cost-price segments '
                                                                          'including at least one segment affected by '
                                                                          'the repairs: either the property with an area of 1,500 ft² or the elevator area or both.\n\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "4. Set construction cost and Sell Prices:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
                                                                     TextSpan(
                                                                      text: "▶ Press the Set Prices button and in the displayed table,"
                                                                          "\n▶ For Floor 0 - Segment 1 (salable area) input repair cost to "
                                                                          "0 and also sell price 0, because property in the first floor has no repairment and "
                                                                          "no increment in sell price."
                                                                          "\n▶ For Floor 0 - Segment 2 (elevator) input repair cost 100 and sell price 0."
              
                                                                          "\n▶ For Floor 1 - Segment 0 (salable area) input repair cost to 120, and sell "
                                                                          "price 150, that is the the increment if sell price not sell price to offer."
                                                                          "\n▶ For Floor 1 - Segment 1 (elevator) input repair cost to 100, and sell price 0."
                                                                          "\n▶ For Floor 2 - Segment 0 (salable area) input repair cost to 0, and sell "
                                                                          "price 150."
                                                                          "\n▶ For Floor 2 - Segment 1 (elevator) input repair cost to 100, and sell price 0.",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "\n\n5. Finalize this Part:\n",
                                                                      style: TextStyle(
                                                                        color: Colors.blue, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "▶ Press done-all icon at the bottom of the page "
                                                                          "and proceed through the next part.\n\n"
                                                                          "In the next part, permit fee part, enter one as "
                                                                          "the number of fee segments of floor 0, then press Set Areas and enter "
                                                                          "1550 as the area and 2 as similar floor number, then"
                                                                          " press Set Fees button and enter 0 for both segments"
                                                                          " fees of all floors and press the result icon to see the cost benefit "
                                                                          "result of repairment of the project.\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.black, // Text color
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text: "A Numerical Illustration:\n\n",
                                                                      style: TextStyle(
                                                                        color: Colors.teal, // Title color
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: textFontSize,
                                                                      ),
                                                                    ),
              
                                                                     TextSpan(
                                                                      text:
                                                                          '▶ Cost of the Elevator Installation:\n'
                                                                          ' ➔ Elevator Cost = \$30,000\n'
                                                                          ' ➔ Common Area Reconstruction cost = \$100 × 50 ft² × 3 = \$15,000\n'
                                                                          ' ➔ Total Cost for Elevator Installation = \$30,000 + \$15,000 = \$45,000\n\n'
                                                                          '▶ Repair Cost for Floor 1:\n'
                                                                          ' ➔ Repair Cost = \$120 × 1,500 ft² = \$180,000\n\n'
                                                                          '▶ Total Costs:\n'
                                                                          ' ➔ Total Costs = Cost of Elevator + Installation + Repair Cost = '
                                                                              '\$45,000 + \$180,000 = \$225,000\n\n'
              
                                                                          '▶ Total Income Increase:\n'
                                                                          ' ➔ Total sell price Increase for floors 1 and 2, not floor 0 = \$150 × 1,500 ft² × 2 = \$450,000\n\n'
                                                                          '▶ Profit from Repair Investment:\n'
                                                                          ' ➔ Profit = Total Income Increase - Total Repairment Costs = \$450,000 - \$225,000 = \$225,000\n\n'
                                                                          '▶ Profit Percentage = (Profit / Total Costs) × 100\n'
                                                                          ' ➔ Profit Percentage = (\$225,000 / \$225,000) × 100\n'
                                                                          ' ➔ Profit Percentage = 100%\n',
                                                                      style: TextStyle(color: Colors.black, fontSize: textFontSize),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            // Add more Padding/Text.rich widgets for additional examples
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
                                                      )
                                                      ,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.light_outlined, size: iconSizeLarge,color: Colors.white,),
                                          ),
              
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
              
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Text('Number of ', style:  TextStyle(fontWeight: FontWeight.bold,
                                               fontSize:  textFontSize )),
                                          Row(
                                            children: [
                                               Text('Segments of Floor '
                                                   , style:  TextStyle(fontWeight: FontWeight.bold,
                                                       fontSize:  textFontSize )),
                                              Text(
                                                startingFloor.toString(),
                                                style:  TextStyle(fontWeight: FontWeight.bold,
                                                    fontSize:  textFontSize * 1.2, color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
              
                                    Expanded(
                                        flex: 1,
                                        child: TextField(
                                          controller: numberOfSegmentsController,
                                          style:  TextStyle(fontSize:  textFontSize),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                          readOnly: priceTableVisible? isReadOnly : false,
                                          keyboardType: TextInputType.number,
                                        )
                                    ),
              
                                    SizedBox(width: spacingHeight * 0.5),
              
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () async
                                        {
                                          priceTableData.clear();
                                          nonSalableSegments.clear();
                                          priceTableVisible = false;
                                          bool? userConfirmed = false;
                                          similarFloorController.text = "";
                                          if (numberOfSegmentsController.text.isNotEmpty &&
                                              isValidNumber(numberOfSegmentsController.text) &&
                                          (int.tryParse(numberOfSegmentsController.text)!>0))
                                          {
                                             numberOfSegmentsSaved = int.parse(numberOfSegmentsController.text);
                                            if (numberOfSegmentsSaved > 10)
                                            {
                                               userConfirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:  Text('Confirm Input', style: TextStyle(fontSize: textFontSize)),
                                                    content:  Text('You have entered a big number. Are you sure '
                                                        'you have this number of cost-price segments?'
                                                        , style: TextStyle(fontSize: textFontSize)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(false);
                                                        },
                                                        child:  Text('No', style: TextStyle(fontSize: textFontSize)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(true);
                                                        },
                                                        child:  Text('Yes'
                                                          , style: TextStyle(fontSize: textFontSize, color: Colors.blue,),),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );   if (userConfirmed == true) {
                                                 areaTableData.clear();
                                              await   checkVisibility();
                                                 for (int i = 0; i < numberOfSegmentsSaved; i++) {
                                                   int floorNumber = startingFloor;
                                                   int segmentNumber = i + 1; // Segments are usually 1-based

                                                   String rowName = 'Floor $floorNumber Segment $segmentNumber';

                                                   areaTableData.add(AreaTableRowData(
                                                     name: rowName,
                                                     floorNumber: floorNumber,
                                                     segmentNumber: segmentNumber,
                                                     textField1Controller: TextEditingController(),
                                                     isSalableInArea: true, // Default value
                                                   ));
                                                 }

                                                 setState(() { areaTableVisible = true;
                                                 similarFloorVisible = true;});
              
                                               } else {setState(() { areaTableVisible = false;
                                               similarFloorVisible = false;});
              
                                               }
                                            }
                                            else
                                            {
                                                areaTableData.clear();
                                              await  checkVisibility();
                                                for (int i = 0; i < numberOfSegmentsSaved; i++) {
                                                  int floorNumber = startingFloor;
                                                  int segmentNumber = i + 1; // Usually segments start from 1

                                                  String rowName = 'Floor $floorNumber Segment $segmentNumber';

                                                  areaTableData.add(AreaTableRowData(
                                                    name: rowName,
                                                    floorNumber: floorNumber,
                                                    segmentNumber: segmentNumber,
                                                    textField1Controller: TextEditingController(),
                                                    isSalableInArea: true, // Default value
                                                  ));
                                                }

                                                setState(() {
                                                  areaTableVisible = true;
                                                  similarFloorVisible = true;
                                                });
                                              }
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
                                                      "Please fill all required fields. \n\nNumber of segments can't be zero or negative."
                                                          "\n\nInputs should be a valid number "
                                                          "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                          "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                          " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
                                                      style: TextStyle(fontSize: textFontSize, )),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text(  'OK',
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
                                          backgroundColor: Colors.blue,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2),
                                              bottomRight: Radius.circular(2),
                                              topRight: Radius.circular(2),
                                              bottomLeft: Radius.circular(2),
                                            ),
                                          ),
                                       //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      //    minimumSize: const Size(120, 40),
                                        ),
                                        child:  Text(
                                          'Set Areas',
                                      //    overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:  textFontSize ,
                                          ),
                                        ),
                                      ),),
                                  ],
                                ),
                            ),
              
                            Visibility(
                              visible: ((int.tryParse(numberOfSegmentsController.text) != null &&
                                  int.tryParse(numberOfSegmentsController.text)! > 0) && areaTableVisible),
                              child: Column(
                                children: [
                                  LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      int? numRows = 2;
                                      double rowHeight = screenHeight * 0.06;
                                      double contentHeight = rowHeight * numRows + rowHeight;
                                      double maxHeight = contentHeight > rowHeight *3 ? rowHeight *3 : contentHeight;
                                      return Container(
                                        color: Colors.white60,
                                        height: maxHeight,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: isIpad ?

                                          DataTable(
                                            columnSpacing: 11,
                                            horizontalMargin: 11,
                                             headingRowHeight: rowHeight ,
                                            dataRowMaxHeight: rowHeight * 0.8,
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                              return const Color(0xFF00B8D4); // Set the background color of the header row to a pale brick color
                                            }),
                                            columns: [
                                              DataColumn(
                                                label: Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Segment Number',
                                                    style: TextStyle(fontSize: textFontSize),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Area of Segment',
                                                    style: TextStyle(fontSize: textFontSize),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Sale\nable',
                                                    style: TextStyle(fontSize: textFontSize),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],

                                            rows: [
                                              ...areaTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name, style: TextStyle(fontSize: textFontSize))),
                                                  DataCell(
                                                    Container(
                                                      color: Colors.white,
                                                      child: TextField(
                                                        controller: row.textField1Controller,
                                                        style: TextStyle(fontSize: textFontSize),
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Switch(
                                                      value: !(nonSalableSegments.contains(row.segmentNumber)),
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          row.isSalableInArea = value;
                                                          if (!value) {
                                                            nonSalableSegments.add(row.segmentNumber);
                                                          } else {
                                                            nonSalableSegments.remove(row.segmentNumber);
                                                          }

                                                          // --- Synchronize saleability with priceTableData ---
                                                      /*    for (var priceRow in priceTableData) {
                                                            if (priceRow.segmentNumber == row.segmentNumber) {
                                                              priceRow.isSalableInPrice = value;
                                                              // Optionally, set sell price to "0" if not salable
                                                              if (!value) {
                                                                priceRow.textField4Controller.text = "0";
                                                              }
                                                            }
                                                          }*/
                                                          // ---------------------------------------------------
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ],

                                          )
                                          :
                                          DataTable(
                                            columnSpacing: 12,
                                            horizontalMargin: 11,
                                            headingRowHeight: rowHeight ,
                                            //     dataRowMaxHeight: rowHeight * 0.8,
                                            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                              return const Color(0xFF00B8D4); // Set the background color of the header row to a pale brick color
                                            }),
                                            columns: [
                                              DataColumn(
                                                label: Text(
                                                  'Segment\n Number',
                                                  style: TextStyle(fontSize: textFontSize),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Area of\n Segment',
                                                  style: TextStyle(fontSize: textFontSize),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              DataColumn(
                                                label: SizedBox(width: screenWidth * 0.1,
                                                  child: Text(
                                                    'Sale\nable',
                                                    style: TextStyle(fontSize: textFontSize),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],

                                            rows: [
                                              ...areaTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name, style: TextStyle(fontSize: textFontSize))),
                                                  DataCell(
                                                    Container(
                                                      color: Colors.white,
                                                      child: TextField(
                                                        controller: row.textField1Controller,
                                                        style: TextStyle(fontSize: textFontSize),
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Switch(
                                                      value: !(nonSalableSegments.contains(row.segmentNumber)),
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          row.isSalableInArea = value;
                                                          if (!value) {
                                                            nonSalableSegments.add(row.segmentNumber);
                                                          } else {
                                                            nonSalableSegments.remove(row.segmentNumber);
                                                          }

                                                          // --- Synchronize saleability with priceTableData ---
                                                        /*  for (var priceRow in priceTableData) {
                                                            if (priceRow.segmentNumber == row.segmentNumber) {
                                                              priceRow.isSalableInPrice = value;
                                                              // Optionally, set sell price to "0" if not salable
                                                              if (!value) {
                                                                priceRow.textField4Controller.text = "0";
                                                              }
                                                            }
                                                          }*/
                                                          // ---------------------------------------------------
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ],

                                          ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                   SizedBox(height: spacingHeight,),
                                  SizedBox(// height: screenHeight * 0.04,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                       Expanded(
                                           flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Text('Number of Similar ',style: TextStyle(
                                                 fontSize:  textFontSize,fontWeight: FontWeight.bold
                                               ),),
                                              Row(
                                                children: [
                                                    Text('Floors to Floor   '
                                                      ,style: TextStyle(
                                                      fontSize:  textFontSize,fontWeight: FontWeight.bold
                                                    ),),
                                                  Text(
                                                    startingFloor.toString(),
                                                    style:   TextStyle(fontSize:  textFontSize * 1.2,
                                                        color: Colors.blue,fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                       ),
              
                                      SizedBox(width: spacingHeight * 0.5),
              
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.grey[100],
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: textFontSize),
                                              controller: similarFloorController,
                                        //      readOnly: priceTableVisible? isReadOnly : false,
                                            //  decoration: const InputDecoration(hintText: 'Similar floors'),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                      ),
              
                                        SizedBox(width: spacingHeight * 0.5),
                                            Expanded(
                                              flex: 2,
                                              child: ElevatedButton(
                                                onPressed: () async
                                                {

                                                      // Check if all areaTableData text fields are not empty
                                                      bool isAllAreaTableDataFieldsFilled = true;
                                                      for (int i = 0; i <areaTableData.length; i++) {
                                                        if (areaTableData[i].textField1Controller.text.isEmpty ||
                                                            !isValidNumber(areaTableData[i].textField1Controller.text)) {

                                                          isAllAreaTableDataFieldsFilled =false;
                                                          break;
                                                        }
                                                      }

                                                      if (isAllAreaTableDataFieldsFilled &&
                                                          (numberOfSegmentsController.text.isNotEmpty) &&
                                                          isValidNumber(numberOfSegmentsController.text) &&
                                                          (similarFloorController.text.isNotEmpty) &&
                                                          isValidNumber(similarFloorController.text))
                                                      {
                                                        bool? userConfirmed = false;

                                                        if (nonSalableSegments.isEmpty &&
                                                            numberOfSegmentsSaved > 1)
                                                          {
                                                            userConfirmed = await showDialog<bool>(
                                                            context: context,
                                                            builder: (BuildContext context)
                                                            {
                                                              return AlertDialog(
                                                                title:  Text('Confirm Input', style: TextStyle(
                                                                  fontSize:  textFontSize,color: Colors.green,
                                                                ),),
                                                                content:  Text(
                                                                  'You haven\'t defined any segment as a common (non-salable) segment, '
                                                                      'like stairwells or elevator. If you have salable segments '
                                                                      ' press Modify here and switch their salable icon to off. Otherwise, '
                                                                      'If all of segments in this floor are salable,'
                                                                      ' press Continue to set costs and sell prices.',
                                                                  style: TextStyle(fontSize: textFontSize),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(false); // Return false

                                                                    },
                                                                    child:  Text(
                                                                      'Modify',
                                                                      style: TextStyle(
                                                                        color: Colors.red,
                                                                        fontSize: textFontSize,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(true);
                                                                    },
                                                                    child:  Text(
                                                                      'Continue',
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
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
                                                        if (
                                                        nonSalableSegments.isNotEmpty ||
                                                            (nonSalableSegments.isEmpty && userConfirmed == true) ||
                                                            numberOfSegmentsSaved == 1
                                                        ) {
                                                          numberOfSimilarFloorsSaved = int.tryParse(similarFloorController.text) ?? 0;

                                                          List<String> segmentName = [];
                                                          for (int i = 0; i < numberOfSimilarFloorsSaved + 1; i++) {
                                                            for (int j = 0; j < numberOfSegmentsSaved; j++) {
                                                              segmentName.add('Floor ${startingFloor + i} Segment ${j + 1}');
                                                            }
                                                          }

                                                          await CompleteCalculationDatabaseHelper.deleteCpp(projectName1, cppValue);
                                                          priceTableData.clear();
                                                          await checkVisibility();

                                                          // --- Create price table data ---
                                                          for (int i = 0; i < segmentName.length; i++) {
                                                            final parts = segmentName[i].split(' ');
                                                            int floorNumber = int.tryParse(parts[1]) ?? 0;
                                                            int segmentNumber = int.tryParse(parts[3]) ?? 0;

                                                            // Saleability is determined by the set
                                                            bool isSalable = !(nonSalableSegments.contains(segmentNumber));

                                                            priceTableData.add(
                                                              PriceTableRowData(
                                                                name: segmentName[i],
                                                                floorNumber: floorNumber,
                                                                segmentNumber: segmentNumber,
                                                                textField2Controller: TextEditingController(),
                                                                textField3Controller: TextEditingController(),
                                                                textField4Controller: TextEditingController(),
                                                                isSalableInPrice: isSalable,
                                                              ),
                                                            );
                                                          }

                                                          // --- Initialize price table segment area ---
                                                          int row_ = 0;
                                                          for (int i = 0; i <= numberOfSimilarFloorsSaved; i++) {
                                                            for (int j = 0; j < numberOfSegmentsSaved; j++) {
                                                              priceTableData[row_].textField2Controller.text =
                                                                  areaTableData[j].textField1Controller.text;

                                                              // Again, use the set to determine saleability
                                                              if (nonSalableSegments.contains(priceTableData[row_].segmentNumber)) {
                                                                priceTableData[row_].textField4Controller.text = "0";
                                                              }
                                                              row_++;
                                                            }
                                                          }
                                                          priceTableVisible = true;
                                                        }

                                                      }
                                                 else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                        title:  Text(
                                                            'Error',  style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: textFontSize,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
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
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child:  Text(
                                                              'OK',style: TextStyle(
                                                              fontSize: textFontSize ,color: Colors.pink,
                                                            ),),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(2),
                                                      bottomRight: Radius.circular(2),
                                                      topRight: Radius.circular(2),
                                                      bottomLeft: Radius.circular(2),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                  minimumSize: const Size(120, 40),
                                                ),
                                                child:  Text('Set Prices',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                  fontSize:  textFontSize,
                                                ),
                                                ),
                                              ),
                                            ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
              
                            const SizedBox(height: 7 ),
              
                            Visibility(
                              visible: priceTableVisible ,
                              child: Container(
                                color: Colors.white60,
                          //      height: screenHeight * 0.4,
                                child:  ScrollbarTheme(
                              data: ScrollbarThemeData(
                              thumbColor: WidgetStateProperty.all(Colors.brown),
                              radius: const Radius.circular(15),),
                        child: Scrollbar(
                     //         thumbVisibility: true,
                              controller: scrollController1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: scrollController1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    child: isIpad ? //  don't comment horizontalMargin: 15,
                                    DataTable(
                                      headingRowHeight: screenHeight * 0.06,
                                      dataRowMaxHeight: screenHeight * 0.04,
                                      headingRowColor: WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) => const Color(0xFF00B8D4),
                                      ),
                                      columnSpacing: 11,
                                      horizontalMargin: 11,

                                      columns:   [
                                        DataColumn(label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Floor-Segment \nNumber'
                                              ,style: TextStyle(fontSize:  textFontSize ,)),
                                        )),
                                        DataColumn(label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Segment Area',style: TextStyle(
                                            fontSize:  textFontSize ,)),
                                        )),
                                        DataColumn(label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Construction \nCost (ft²/m²)',style: TextStyle(
                                            fontSize:  textFontSize ,)),
                                        )),
                                        DataColumn(label: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Sell Price \n(ft²/m²)',style: TextStyle(
                                            fontSize:  textFontSize ,)),
                                        )),
                                        DataColumn(
                                          label: (priceTableData.isNotEmpty &&
                                              priceTableData.last.floorNumber == startingFloor &&
                                              numberOfSimilarFloorsSaved > 0)
                                              ?  const Text('')
                                              :  const Text(''),
                                        ),],
                                      rows: [
                                        ...priceTableData.map((row) => DataRow(
                                          cells: [
                                            DataCell(Text(row.name
                                                ,style: TextStyle(fontSize:  textFontSize ,) )),
                                            DataCell(TextField(
                                              controller: row.textField2Controller, //segment area
                                              keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                              readOnly: true,style: TextStyle(
                                              fontSize:  textFontSize ,),
                                            )),
                                            DataCell(Container(color: Colors.white, //segment cost
                                              child: TextField(
                                                controller: row.textField3Controller,
                                                style: TextStyle(
                                                fontSize:  textFontSize ,),
                                                keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                              ),
                                            )),
                                            // Segment Sell Price DataCell: emoji for non-salable, editable for salable
                                           nonSalableSegments.contains(row.segmentNumber)

                                                ? DataCell(
                                                    Center(
                                                      child: Text('🔒', style: TextStyle(fontSize: textFontSize + 4)),
                                                    ),
                                                  )
                                                  : DataCell(
                                                    Container(
                                                      color: Colors.white,
                                                      child: TextField(
                                                        controller: row.textField4Controller,
                                                        style: TextStyle(fontSize: textFontSize),
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                       /*     nonSalableSegments.contains(row.segmentNumber) ? DataCell(
                                              Container(
                                                color: Colors.white,
                                                child: TextField(
                                                  controller: row.textField4Controller,
                                                  style: TextStyle(fontSize: textFontSize),
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                                : DataCell(
                                              Center(
                                                child: Text('🔒', style: TextStyle(fontSize: textFontSize + 4)),
                                              ),
                                            ),*/

                                      ( (row.name.split(' ')[1]== startingFloor.toString())
                                                && int.parse(similarFloorController.text)>0 ) ?
                                            DataCell(IconButton(
                                              icon:  Icon(Icons.settings_applications_sharp,
              
                                                color: Colors.purple,size: iconSizeLarge ,),
                                              onPressed: () {
                                                String rowName = row.name.split(' ')[0];
                                                String rowSegment = row.name.split(' ')[3];
                                                String numberOfSegments = numberOfSegmentsController.text;
                                                if (rowName.isNotEmpty && numberOfSegments.isNotEmpty &&
                                                    rowSegment.isNotEmpty) {
                                              //    int floor = int.parse(row.name.split(' ')[1]);
                                                  int segmentNumber2 = int.parse(row.name.split(' ')[3]);
                                               //   int givenNumberOfSegments = int.parse(numberOfSegmentsController.text);
                                                  saveCurrentSegmentOfStartingFloor(segmentNumber2);
                                                  myIconButtonFunction(context, segmentNumber2,
                                                      numberOfSimilarFloorsSaved,
                                                      startingFloor, numberOfSegmentsSaved, nonSalableSegments);

                                                } else {
                                                  showEmptyPopup(context);
                                                }
                                              },
              
                                            )) : DataCell(Container()), // show IconButton if condition is true, otherwise show empty container
                                          ],
                                        )),
                                      ],
                                    )
                                    :
                                    DataTable(
                                      headingRowHeight: screenHeight * 0.07,
                                         //          dataRowMaxHeight: screenHeight * 0.04,
                                      headingRowColor: WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) => const Color(0xFF00B8D4),
                                      ),
                                     columnSpacing: 10,
                               //     horizontalMargin: 15,
              
                                            columns:   [
                                               DataColumn(label: Text('Floor-Segment \nNumber'
                                                   ,style: TextStyle(fontSize:  textFontSize ,))),
                                               DataColumn(label: Padding(
                                                 padding: const EdgeInsets.all(8.0),
                                                 child: Text('Segment Area',style: TextStyle(
                                                   fontSize:  textFontSize ,)),
                                               )),
                                               DataColumn(label: Padding(
                                                 padding: const EdgeInsets.all(8.0),
                                                 child: Text('Construction \nCost (ft²/m²)',style: TextStyle(
                                                   fontSize:  textFontSize ,)),
                                               )),
                                               DataColumn(label: Padding(
                                                 padding: const EdgeInsets.all(8.0),
                                                 child: Text('Sell Price \n(ft²/m²)',style: TextStyle(
                                                   fontSize:  textFontSize ,)),
                                               )),
                                              DataColumn(
                                                label: (priceTableData.isNotEmpty
                                                    && priceTableData.last.floorNumber == startingFloor
                                                    && numberOfSimilarFloorsSaved > 0)
                                                    ?  const Text('')
                                                    :  const Text(''),
                                              ),],
                                            rows: [
                                              ...priceTableData.map((row) => DataRow(
                                                cells: [
                                                  DataCell(Text(row.name
                                                      ,style: TextStyle(fontSize:  textFontSize ,) )),
                                                  DataCell(TextField(
                                                    controller: row.textField2Controller, //segment area
                                                    keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                    readOnly: true,style: TextStyle(
                                                    fontSize:  textFontSize ,),
                                                  )),
                                                  DataCell(Container(color: Colors.white, //segment cost
                                                    child: TextField(
                                                      controller: row.textField3Controller,style: TextStyle(
                                                      fontSize:  textFontSize ,),
                                                      keyboardType: TextInputType.number,textAlign: TextAlign.center,
                                                    ),
                                                  )),
                                                  // Segment Sell Price DataCell: emoji for non-salable, editable for salable
                                                  nonSalableSegments.contains(row.segmentNumber)

                                                      ? DataCell(
                                                    Center(
                                                      child: Text('🔒', style: TextStyle(fontSize: textFontSize + 4)),
                                                    ),
                                                  )
                                                      : DataCell(
                                                    Container(
                                                      color: Colors.white,
                                                      child: TextField(
                                                        controller: row.textField4Controller,
                                                        style: TextStyle(fontSize: textFontSize),
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),

                                             /*     nonSalableSegments.contains(row.segmentNumber) ? DataCell
                                                      (
                                                    Container(
                                                      color: Colors.white,
                                                      child: TextField(
                                                        controller: row.textField4Controller,
                                                        style: TextStyle(fontSize: textFontSize),
                                                        keyboardType: TextInputType.number,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                      : DataCell(
                                                    Center(
                                                      child: Text('🔒', style: TextStyle(fontSize: textFontSize + 4)),
                                                    ),
                                                  ),
*/

                                                  ( (row.name.split(' ')[1]== startingFloor.toString())
                                                      && int.parse(similarFloorController.text)>0 ) ?
                                                  DataCell(IconButton(
                                                    icon:  Icon(Icons.settings_applications_sharp,
              
                                                      color: Colors.purple,size: iconSizeLarge ,), // setting
                                                    onPressed: () {
                                                      String rowName = row.name.split(' ')[0];
                                                      String rowSegment = row.name.split(' ')[3];
                                                      String numberOfSegments = numberOfSegmentsController.text;
              
                                                      if (rowName.isNotEmpty && numberOfSegments.isNotEmpty && rowSegment.isNotEmpty) {
                                                    //    int floor = int.parse(row.name.split(' ')[1]);
                                                        int segmentNumber2 = int.parse(row.name.split(' ')[3]);
                                                     //   int givenNumberOfSegments = int.parse(numberOfSegmentsController.text);
                                                        saveCurrentSegmentOfStartingFloor(segmentNumber2);
                                                        myIconButtonFunction(context, segmentNumber2
                                                            , numberOfSimilarFloorsSaved, startingFloor,
                                                            numberOfSegmentsSaved, nonSalableSegments);

                                                      } else {
                                                        showEmptyPopup(context);
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return SingleChildScrollView (
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
              
                              IconButton(
                                icon: Icon(Icons.home, color: Colors.purple[900], size: iconSizeLarge),
                                onPressed: ()  {
                                    // This callback will be executed after the ad is shown
                                  NavigationService().navigateToScreen(
                                    LandInputs(
                                      givenProjectName: projectName1,
                                    ),
                                  );  NavigationService().navigateToScreen(
                                    LandInputs(
                                      givenProjectName: projectName1,
                                    ),
                                  );
                                },
                              ),
                               const SizedBox(width: 39,),
                              IconButton(
                                  icon:  Icon(Icons.arrow_back_ios,
                                      color: Colors.deepPurple, size: iconSizeLarge),
                                  onPressed: () {
                                    _onBackButtonPressedCallback(context);
                                  }
                                  ),
              
                               const  SizedBox(width: 16),
              
                              Visibility(
                                visible: (priceTableVisible),
              
                                child: IconButton(
                                  icon:  Icon(Icons.arrow_forward_ios,
                                      color: Colors.deepPurple, size: iconSizeLarge),
                                  onPressed: () async {
                                    bool allFieldsAreNotEmpty = true;

                                    for (int i = 0; i < priceTableData.length; i++) {
                                    //  final sellPriceText = priceTableData[i].textField4Controller.text;

                                      if (priceTableData[i].textField2Controller.text.isEmpty ||
                                          !isValidNumber(priceTableData[i].textField2Controller.text) ||
                                          priceTableData[i].textField3Controller.text.isEmpty ||
                                          !isValidNumber(priceTableData[i].textField3Controller.text) ||
                                          priceTableData[i].textField4Controller.text.isEmpty ||
                                          !isValidNumber(priceTableData[i].textField4Controller.text) ) {
                                        allFieldsAreNotEmpty = false;
                                        break; // Exit the loop if any field is empty or invalid
                                      }
                                    }

                                    if (priceTableVisible && allFieldsAreNotEmpty &&
                                        numberOfSegmentsController.text.isNotEmpty)
                                    {
                                      // since if the icon buttons is pressed just data of their own row goes to the database
                                      // other rows in price table has no data regarding to their profit in the database therefore
                                      // first we save all of them into the database then navigates to next page
                                      await profitCalculationForEachSegment();
                                      cppValue++;
                                      await checkVisibility();// if other cco exist retrieve their data by on nextCPP
                                      if (checkMaxCPP) {
                                        _onNextCPP(projectName1, cppValue);
                                        setState(() {});
                                      }
                                      else {
                                        areaTableData.clear();
                                        numberOfSegmentsController.clear();
              
                                        await  checkVisibility();
                                        setState(() {
                                          areaTableVisible = false;
                                          similarFloorVisible = false;
                                          priceTableVisible = false;
                                        });
                                        // Save current price table and rerun the page with no priceTableData
                                        // priceTables.add(List.from(priceTableData));
                                        // priceTableData.clear();
              
                                        setState(() {
                                           startingFloor = startingFloor + (numberOfSimilarFloorsSaved ) + 1;
                                            //  int.parse(similarFloorController.text)
                                   
                                        });
                                      }
                                    }
              
                                    else {
                                      // Show a popup dialog with an error message
                                      showErrorDialog1(context);
                                    }
                                  },
                                ),
                              ),
              
              
                               const SizedBox(width: 16),
              
                              Visibility(
                                visible: (priceTableVisible),
                                child:
              
                                IconButton(
                                    icon:  Icon(Icons.done_all,
                                        color: Colors.deepPurple, size: iconSizeLarge),
                                  onPressed: () async {
                                    bool allFieldsAreNotEmpty = true;
                                    for (PriceTableRowData data in priceTableData)
                                    {
                                      if (data.textField2Controller.text.isEmpty ||
                                          !isValidNumber(data.textField2Controller.text) ||
                                          data.textField3Controller.text.isEmpty ||
                                          !isValidNumber(data.textField3Controller.text) ||
                                          data.textField4Controller.text.isEmpty ||
                                          !isValidNumber(data.textField4Controller.text)
                                    ) {
                                        allFieldsAreNotEmpty = false;
                                        break;
                                      }
                                    }
                                    if (priceTableVisible &&
                                        allFieldsAreNotEmpty &&
                                        numberOfSegmentsController.text.isNotEmpty &&
                                        similarFloorController.text.isNotEmpty) {
                                      await profitCalculationForEachSegment();
              
                                      NavigationService().navigateToScreen(
                                        FloorRangesPage(
                                          givenProjectName: projectName1,
                                //          firstStartingFloor: firstStartingFloor,
                                        ),
                                        arguments: {
                                          'givenProjectName': projectName1,
                                 //         'firstStartingFloor': firstStartingFloor,
                                        },
                                      );
                                    } else {
                                      showErrorDialog1(context);
                                    }
                                  },),
                              ),
              
                               const SizedBox(width: 36),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:  Text('Introduction', style: TextStyle(
                                          fontSize: titleFontSize * 1.2,
                                          color: Colors.deepPurple ,fontWeight: FontWeight.bold,
                                        ),),
                                        content: SingleChildScrollView(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                 TextSpan(
                                                  text: '\nAfter obtaining basic data like land cost, this '
                                                      'part is dedicated to calculating the construction costs of the built-up '
                                                      'area and the income from selling the salable area. '
                                                      'Before starting calculations, it’s good to review the key terms: '
                                            '\n\n- Plot Area: The plot area is the total land on which a '
                                                'property is constructed; it may also be called land area or site area.'
                                                

                                            '\n\n- Built-Up Area (BUA): The built-up area is the total constructed area '
                                                      'of a project, including internal walls, balconies, and other '
                                                      'covered spaces; sometimes referred to as constructed area. '


                                          'Salable Area: The salable area is the portion of the built-up area '
                                                      'that can be sold to buyers, typically excluding common '
                                                      'areas; also known as usable area or carpet area. '
                                                      'Salable area is always part of the built-up area. '
                                            '\nNow we can start calculation of construction costs and income of the salable parts.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\n\nBrief Introduction:\nIn this app, each construction project includes one '
                                                      'or more cost-price plans (CPPs). Each CPP encompasses one floor or several '
                                                      'contiguous floors, and every floor contains one or more '
                                                      'cost-price segments (CPSs).\n',
                                                  style: TextStyle(
                                                      fontSize: textFontSize * 1.1,
                                                      color: Colors.deepPurple, fontWeight: FontWeight.bold
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\nWhat is a cost-price segment?\n',
                                                  style: TextStyle(
                                                      fontSize: titleFontSize * 1.2,
                                                      color: Colors.pink, fontWeight: FontWeight.bold
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\nIn this app, each cost-price segment (CPS) on a floor refers to a specific '
                                                      'area of that floor which has'
                                                      ' a different cost or sell price per square foot/meter (ft²/m²) compared'
                                                      ' to other areas on the floor. '

                                                      '\n\nFor example, if a floor with 2,550 ft² has three segments with '
                                                      'areas of 1,500 ft², 1,000 ft², and 50 ft², each having '
                                                      'different costs per ft² or different sell price per ft², or both, '
                                                      'the floor has three cost-price segments.'

                                                      '\n\n■ It is not necessary for the segments on each floor to represent '
                                                      'individual properties for sale. For example, on the floor mentioned, '
                                                      'the segment with an area of 1,500 ft² can include two properties '
                                                      'of 750 ft² each, that can be sold to different buyers, but sharing '
                                                      'the same construction cost per ft² and sell price per ft². '
                                                      'In this case, we consider them as one cost-price segment '
                                                      'to simplify calculations.\n\n'

                                                   'Therefore, define cost-price segments on each floor as needed,'
                                                      ' regardless of the number of properties on that floor, so '
                                                      'that cost price segments represent a unique financial '
                                                      'design of the floor. This approach simplifies the process '
                                                      'of inputting diversified construction costs and selling '
                                                      'prices for the project, enabling you to obtain accurate'
                                                      ' and detailed results efficiently.'
              
                                                      '\n\nTo clarify why we use the CPS (Cost-Price Segment) concept here:'
                                                   'Projects often include properties with different sale prices, so a '
                                                      'project may have multiple CPS segments to reflect these variations. '
                                                      'Additionally, construction costs themselves can justify creating '
                                                      'different CPS segments. Although construction cost per square foot '
                                                      'is typically assumed to be uniform across a building—mainly because, '
                                                      'before the project begins, you rely on estimates from similar projects '
                                                      'rather than precise, segment-specific cost data. '
                                                      'However, if your project includes unique features or modifications in certain '
                                                      'areas, you can assign different construction costs per square foot '
                                                      'to those areas by defining them as separate CPS segments. For example, if '
                                                      'you determine your general construction cost based on a reference project and plan '
                                                      'to build your building similarly, with just adding smart features to the '
                                                      'highest salable floor (unlike the reference project), this floor will incur extra '
                                                      'costs. Using this app, you can assign a higher construction cost per sqft specifically '
                                                      'to the smartened floor, while keeping the construction costs for the other '
                                                      'floors the same as the reference project.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\n\nWhat is a cost-price plan?',
                                                  style: TextStyle(
                                                    fontSize: titleFontSize * 1.2,
                                                    color: Colors.pink,fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\nIn this app, each cost-price plan (CPP) represents a '
                                                      'unique financial design of a floor, in terms of number and area '
                                                      'of cost-price segments, that can be applied to a set of '
                                                      'contiguous floors starting from the floor.'

                                                      '\n\nIndeed, every floor within a CPP contains one or '
                                                      'more cost-price segments (CPSs) and share similar CPS '
                                                      'configurations—both in number and area—with other floors in that CPP, if CPP'
                                                      'has more than one floor, but has'
                                                      ' different CPS configurations compared to floors of other CPPs.'
                                                      ' As a result, all floors of a project can be grouped into different'
                                                      ' CPPs, with each floor belonging exclusively to a single CPP. '

                                                      'This structure allows for clear categorization and streamlined '
                                                      'financial analysis across the entire project By defining CPS configurations '
                                                      'of the first floor of each CPP, and setting number of other flows in that CPP.'
                                                      '\n\nFor example, If a project has a ground floor area of 2,550 ft² allocated '

                                                      '■ ground floor: 2,550 ft² allocated to parking floor with parking and 50 ft² staircase'
                                                      ', both with the same construction '
                                                      'cost per square foot, and obviously sell price zero because parking '
                                                      'and staircase are common areas not for sale.\n'

                                                      '■ Floors 1, 2, and 3, Each having three segments with 1,000 ft² '
                                                      '1,500 ft² and 50 ft² areas, so that they have different costs per ft² '
                                                      'or sell prices per ft² or both.\n'
                                                      'each with three cost-price '
                                                      'segments: one of 1,000 ft² another of 1,500 ft² and one 50 ft² area, '
                                                      'each having '
                                                      'different costs per ft² or sell prices per ft² or both.\n'

                                                      '■ Floors 4, 5, and 6, '
                                                      'each with three segments: two with 1,250 ft² and one 50 ft² area, with'
                                                      'different costs per ft² or sell prices per ft² or both.\n'

                                                      'Therefore, you can define the '
                                                      'cost-price plans and segments as follows:\n\n'
                                                      '▶ cost-price plan 1: Ground floor with parking and staircase as one'
                                                      ' cost-price segment with 2,550 ft² area.\n'
                                                      '▶ cost-price plan 2: Floors 1, 2, and 3, each with three cost-price '
                                                      'segments: one of 1,000 ft² another of 1,500 ft² and one 50 ft² area.\n'
                                                      '▶ cost-price plan 3: Floors 4, 5, and 6, each with three cost-price '
                                                      'segments, two of 1,250 ft² and one 50 ft² area.\n\n'
              
                                                  'For example, for '
                                                      'floors 1, 2, and 3 with three cost-price segments, '
                                                      'two potential scenarios leading to this segmentation are shown below\n\n'
                                                      '(construction cost per square foot (CC), sell price per square foot (SP)):\n\n'
              
                                                      'Scenario 1, for each floor of floors 1, 2, and 3:\n\n'
                                                      '  - Segment 1: 1,500 ft² area — CC: 150, SP: 200\n'
                                                      '  - Segment 2: 1,000 ft² area — CC: 150, SP: 220 (different SP)\n'
                                                      '  - Segment 3: 50 ft² area — CC: 150, SP: 0\n\n'
              
                                                      'Scenario 2,  for each floor of floors 1, 2, and 3:\n\n'
                                                      '  - Segment 1: 1,500 ft² area — CC: 150, SP: 200\n'
                                                      '  - Segment 2: 1,000 ft² area — CC: 160, SP: 200 (different CC)\n'
                                                      '  - Segment 3: 50 ft² area — CC: 150, SP: 0\n\n'
              
                                                      'And it is clear why we have two different cost-price plans (2 and 3) for '
                                                      'floors above the parking even though they have the same number '
                                                      'of cost-price segments. It is because the areas '
                                                      'of the segments differ (1,500 + 1,000 vs. 1,250 + 1,250). '
                                                      'Therefore, if the number of segments or their areas change across '
                                                      'floors, you need to define a new cost-price plan.\n\n'
              
              
                                                      '■ There is no need to know the total number of cost-price plans in '
                                                      'advance. Simply proceed with the steps for defining cost-price '
                                                      'segments of the first cost-price plan, then if available define cost-price '
                                                      'segments for upper cost-price plans'
                                                      ', and once you reach the highest floor in your project, '
                                                      'the number of cost-price plans and floors will be determined.\n',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
              
                                                 TextSpan(
                                                  text: '\n\n\nTo summarize, each floor in a building belongs '
                                                      'to a single cost-price plan (CPP) and can be divided into one or more '
                                                      'cost-price segments (CPSs). '
                                                      'All floors within a CPP share the same number and area of CPSs. '
                                                      'To be distinct, each CPS on a floor must have at least a different'
                                                      ' construction cost or selling price per square foot/meter (ft²/m²)'
                                                      ' compared to other CPSs on that floor.'
              
                                                    'For example, a construction project with ten floors might be '
                                                      'structured as follows: \n\n- CPP 1 applies to floor 0 (parking) with'
                                                      ' one CPS; \n- CPP 2 applies to floors 1–4, each with two CPSs;'
                                                      '\n- CPP 3 applies to floors 5–9, each with three CPSs.'
                                                      '\n\nThis enables'
                                                      ' flexible financial modeling of the project’s components.',
                                                  style: TextStyle(
                                                      fontSize: textFontSize * 1.1,
                                                      color: Colors.deepPurple, fontWeight: FontWeight.bold
                                                  ),
                                                ),
              
                                                TextSpan(
                                                  text:  '\n\nNote that if floors are similar but not contiguous, they must be'
                                                      ' defined in separate CPPs. For example, if floors 8 and 9 each'
                                                      ' have two CPSs with equal areas matching those in CPP 2 '
                                                      '(floors 1–4), they cannot be included in CPP 2 and must be '
                                                      'defined as a separate CPP (e.g., CPP 4). Later, you will learn '
                                                      'how to define cost-price segments for each floor in a CPP and '
                                                      'specify the number of contiguous floors in that CPP to '
                                                      'streamline the process. Only contiguous floors can be grouped'
                                                      ' within a single CPP.\n',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
              
                                                 TextSpan(
                                                  text: '\n\nHow to set cost-price segments?',
                                                  style: TextStyle(
                                                    fontSize: titleFontSize * 1.2,
                                                    color: Colors.pink, fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\n▶ 1. First, enter the number of cost-price segments for the first '
                                                      'floor of the first cost-price plan in the text field specified in top of the page.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\n▶ 2. Press the "Set Areas" button next to the text field and define the area of '
                                                      'each cost-price segment. The total built-up area '
                                                      'in each floor in this cost-price plan will be the sum of these areas. '
                                                      '\n\nBy default, each segment has a switch turned on, indicating that the segment '
                                                      'is for sale. If you have a common area—such as a staircase or elevator—that '
                                                      'is typically not salable, simply turn the switch off. later you won’t need to '
                                                      'define a sale price for these segments, and a lock icon will appear in '
                                                      'place of their sale price to indicate they are not for sale.'

                                                      ' \n\nFor the example above, CPP 1 has just one floor that includes parking and staircase as '
                                                      'one cost-price segment, so insert one as number of segments, then insert the '
                                                      'area of the floor (2,550 ft²) and turn off the switch as the segment is not salable.'
                                                  ' But for the CPP number 2, you should insert three as number of segments and input their associated '
                                                      'areas and just turn off the switch for the segment with 50 ft² area.'
                                                   '\n\nNext, you should enter the number of similar floors, which refers to floors that '
                                                      'have the same segment layout as the first floor—meaning each segment on these '
                                                      'floors matches the corresponding segment on the first floor in both number and '
                                                      'area. In other words, for every segment on the first floor of a cost-price plan (CPP), '
                                                      'there is a segment of equal area in the same position on each of the similar '
                                                      'floors within that CPP.'

                                                   '\n\nSo, each cost-price plan consists of the first floor plus the '
                                                      'number of its similar floors.'

                                                   '\n\nIn the example above, CPP 1 has just one floor, so enter 0 as number of segments. '
                                                      'in CPP two, the first floor is floor 1, and '
                                                      'the similar floors are floors 2 and 3. Therefore, you should enter 2 as '
                                                      'the number of similar floors. This means the total number of floors in '
                                                      'cost-price plan two is 3.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\n▶ 3. By pressing "Set Prices" button you can enter the cost for each '
                                                      'cost-price segment and and sell price for salable segments. If the segment is '
                                                      'a common area like staircase, sell price will be considered '
                                                      'zero. If the sell price of a'
                                                      ' segment is greater than zero the area of '
                                                      'that segment will be considered as a salable area (usable or liveable area), and multiplying it by '
                                                      'the price will generate the income that can be earned by selling that segment.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\n▶ 4. You can enter the cost and sell price of the segments of upper '
                                                      'floors in each cost-price plan manually or use ⚙️ icon available '
                                                      'for all segments of the first floor '
                                                      'in each cost-price plan. Pressing this icon will allow you to set the '
                                                      'cost and price of similar segments in the upper floors in each cost-price plan '
                                                      'by choosing either fixed or an arithmetic progression or a geometric progression.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\n▶ 5. If you want to have cost for a segment '
                                                      'in upper floors equal to the cost of that segment in '
                                                      'the first floor of each cost-price plan, '
                                                      'instead of entering manually costs,'
                                                      ' simply press the ⚙️ icon but do not enter any values for '
                                                      'arithmetic progression (incremental) or geometric progression (percentage);'
                                                      ' just keep switch of Fixed on and press "OK" on the dialog to set the same cost for '
                                                      'the corresponding segments on the upper floors in the cost-price plan. You can use '
                                                      'the same approach for sell prices if you want to maintain the '
                                                      'same prices for the corresponding segments on the upper floors in the cost-price plan.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                                 TextSpan(
                                                  text: '\n\n ◆ Arithmetic progression (constant amount added) here means that the cost or sell prices '
                                                      'of each segment will increase by a constant amount from the first segment in the current CPP to the same segment in upper floors. '
                                                      'For example, if the sell price of segments with an area of 1000 ft² on '
                                                      'the first floor of this cost-price plan is set to \$1,000, and you set an arithmetic '
                                                      'progression of \$50 for similar segments on the upper floors in the cost-price plan, '
                                                      'then by pressing OK, the sell price for the segments with an area of 1000 ft² on '
                                                      'the floor 2 will be \$1,050, and for the floor number 3, it will be \$1,100.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\n ◆ Geometric progression (increase by a percentage rate) here means that the '
                                                      'cost or sell prices of each '
                                                      'segment will increase by a constant percentage from the first segment '
                                                      'in the current CPP to the same segment in upper floors of the CPP. '
                                                      '\n\nFor example, if the cost per ft² of the segment with an area of 1500'
                                                      ' ft² on the first floor of the cost-price plan is \$300, '
                                                      'and you set a geometric progression '
                                                      'of 2, then the construction cost/ft² for similar segments '
                                                      'with an area of 1500 ft² on floors 2 and 3 will increase by 2% to \$306 '
                                                      'and \$312.12, respectively.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 TextSpan(
                                                  text: '\n\n▶ 6. Once you have set all costs and sell prices for all segments '
                                                      'of all floors in this cost-price plan, press ',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 WidgetSpan(
                                                  child: Icon(
                                                    Icons.arrow_forward_ios, // Use the settings icon from Material Icons
                                                    size: iconSizeLarge, // Adjust size as needed
                                                    color: Colors.red,
                                                  ),),
                                                 TextSpan(
                                                  text: ' icon if '
                                                      'you want to define a new cost-price plan for other floors, this '
                                                      'icon will be shown when '
                                                      'you press Set Prices button. '
                                                      'But if you do not have any other floors, press ',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 WidgetSpan(
                                                  child: Icon(
                                                    Icons.done_all,
                                                    size: iconSizeLarge, // Adjust size as needed
                                                    color: Colors.red,
                                                  ),),
                                                 TextSpan(
                                                  text:
                                                      ' icon to define permit costs for the floors you have defined and '
                                                          'obtain the results.  The total built-up '
                                                          'area In this app, is defined as the summation of all cost-price segments, '
                                                          'regardless of their sell price.'
                                                      'For further clarification, refer to the examples by pressing the ',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                 WidgetSpan(
                                                  child: Icon(
                                                    Icons.light_outlined,
                                                    size: iconSizeLarge, // Adjust size as needed
                                                    color: Colors.red,
                                                  ),),
                                                 TextSpan(
                                                  text: ' icon at the top of the page. There, you will find six examples '
                                                      'of various new construction projects and one example of a cost-benefit '
                                                      'analysis for the renovation of an old building, all fully explained. '
                                                      '\n\n■ If you have previously defined and saved the project, '
                                                      'you can delete a cost-price plan from that project by pressing the '
                                                      'delete icon button at the top of this page. However, '
                                                      'try to avoid repeating deletion, as it negatively impacts the '
                                                      'app\'s performance, because all data related to that cost-price plan will be '
                                                      'deleted, including all cost-price segments for all floors within that '
                                                      'cost-price plan. Additionally, the number of the upper floors, if any, will '
                                                      'need to be updated, and all calculations and results will be '
                                                      'recalculated. Therefore, it is advisable to carefully consider and '
                                                      'define the floors within their associated cost-price plans to avoid the need for deletion.'
                                                      '\n\n■ If you have previously defined and saved a construction project, '
                                                      'you can change costs and prices when you return to it. However, '
                                                      'you cannot modify the number of segments '
                                                      'floors above the first floor of the cost-price plan. Therefore, be cautious about the segments'
                                                      ' and floors you define for each cost-price plan to avoid the need to create '
                                                      'a new project. It may be helpful to outline your plans and specify '
                                                      'the number of cost-price segments and so number of cost-price plans on paper before '
                                                      'implementing them in the app.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),
              
                                             /*   TextSpan(
                                                  text: '\n\n■ There is no need to define the top roof and yard as cost-price segments, '
                                                      'because either they will be calculated separately on the last step '
                                                      'or, if you have considered the construction cost of '
                                                      'the top roof and yard within the construction cost of the built-up area which you are '
                                                      'segmenting here.\n\n'
              
                                                      'But if none of the above cases occurs, and you want to define them as cost-price '
                                                      'segments to captures their construction costs with a sell price of zero '
                                                      '(because they are not salable), it won\'t affect costs or profitability. '
                                                      'However, the area '
                                                      'of these segments will still be counted as built-up area, therefore, this will lead to '
                                                      'inaccuracies in the total built-up area, which should '
                                                      'only include areas with a roof. This is because the built-up '
                                                      'area In this app, is defined as the summation of all cost-price segments, '
                                                      'regardless of their sell price. So it is recommended to not define '
                                                      'top roof and yard as cost-price segments.',
                                                  style: TextStyle(
                                                    fontSize: textFontSize * 1.1,
                                                    color: Colors.black,
                                                  ),
                                                ),*/
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
                                icon:  Icon(Icons.help_center_rounded,color: Colors.purple[900], size: iconSizeLarge),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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



class PriceTypeDialog extends StatefulWidget {
  final bool costPercentageSelected;
  final bool costPerMeterSelected;
  final bool costPricingFixedSelected;
  final ValueChanged<bool> onCostPercentageSelectedChanged;
  final ValueChanged<bool> onCostPerMeterSelectedChanged;
  final ValueChanged<bool> onCostPricingFixedSelectedChanged;
  final bool sellPricePercentageSelected;
  final bool sellPricePerMeterSelected;
  final bool sellPriceFixedSelected;
  final ValueChanged<bool> onSellPricePercentageSelectedChanged;
  final ValueChanged<bool> onSellPricePerMeterSelectedChanged;
  final ValueChanged<bool> onSellPricingFixedSelectedChanged;
  final Function(BuildContext context, int, int,int, int, double,
      double,double, double) onPercentageUpdate;
  final String projectName;
  final int CPPNumber;
  final int similarFloor;
  final int startingFloor;
  final int segmentNumber1;
  final int numberOfSegments;
  final Set<int> nonSalableSegmentsInPriceType;
 // final int floor_;
  final Function(BuildContext context, String, int, int,Set<int>, double,
      double,double, double ) onCostSellDataGenerating;
//  final VoidCallback onSavePopup;

  const PriceTypeDialog({
    super.key,
    required this.costPercentageSelected,
    required this.costPerMeterSelected,
    required this.costPricingFixedSelected,
    required this.onCostPercentageSelectedChanged,
    required this.onCostPerMeterSelectedChanged,
    required this.onCostPricingFixedSelectedChanged,
    required this.sellPricePercentageSelected,
    required this.sellPricePerMeterSelected,
    required this.sellPriceFixedSelected,
    required this.onSellPricePercentageSelectedChanged,
    required this.onSellPricePerMeterSelectedChanged,
    required this.onSellPricingFixedSelectedChanged,
    required this.onPercentageUpdate,
    required this.onCostSellDataGenerating,
    required this.projectName, required this.CPPNumber,
    required this.similarFloor,required this.startingFloor,
    required this.nonSalableSegmentsInPriceType,
   // required this.floor_,
    required this.segmentNumber1, required this.numberOfSegments,
    //   required this.onSavePopup
  });

  @override
  State<PriceTypeDialog> createState() => _PriceTypeDialogState();
}

class _PriceTypeDialogState extends State<PriceTypeDialog> {
  late bool _costPercentageSelected;
  late bool _costPerMeterSelected;
  late bool _costPricingFixedSelected;
  final _costPercentageController = TextEditingController();
  final _costPerMeterController = TextEditingController();
  late bool _sellPricePercentageSelected;
  late bool _sellPricePerMeterSelected;
  late bool _sellPriceFixedSelected;
  final _sellPricePercentageController = TextEditingController();
  final _sellPricePerMeterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _costPercentageSelected = widget.costPercentageSelected;
    _costPerMeterSelected = widget.costPerMeterSelected;
    _costPricingFixedSelected = widget.costPricingFixedSelected;
    _sellPricePercentageSelected = widget.sellPricePercentageSelected;
    _sellPricePerMeterSelected = widget.sellPricePerMeterSelected;
    _sellPriceFixedSelected = widget.sellPriceFixedSelected;
    checkPercetagesData();
  }

  @override
  void dispose() {
    _costPercentageController.dispose();
    _costPerMeterController.dispose();
    _sellPricePercentageController.dispose();
    _sellPricePerMeterController.dispose();
    super.dispose();
  }

  Future<void> checkPercetagesData()
  async {
    // Retrieve the project starting similar data from the database
    ProjectStartingSimilarTableData? data = 
    await CompleteCalculationDatabaseHelper.getStartingSimilarTableSegmentData(
        widget.projectName, widget.CPPNumber, widget.segmentNumber1);

    // If the data is not null, set the text of the corresponding text fields and toggle buttons
  if (data != null) {
  if (data.startingSimilarTableCostPerMeter != -4321 && data.startingSimilarTableCostPerMeter != 0) {
        _costPerMeterController.text = data.startingSimilarTableCostPerMeter.toString();
        _costPercentageController.text = '';
            setState(() {
          _costPerMeterSelected = true;
          _costPricingFixedSelected = false;
          _costPercentageSelected = false;
        });
      } else if (data.startingSimilarTableCostPercentage != -4321 && data.startingSimilarTableCostPercentage != 0){
        _costPerMeterController.text = "";
        _costPercentageController.text = data.startingSimilarTableCostPercentage.toString();
        setState(() {
          _costPerMeterSelected = false;
          _costPricingFixedSelected = false;
          _costPercentageSelected = true;
        });
      } else   if (data.startingSimilarTableCostPerMeter == 0
      && data.startingSimilarTableCostPercentage == 0) {
    _costPerMeterController.text = "";
    _costPercentageController.text = "";

    setState(() {
      _costPercentageSelected = false;
      _costPricingFixedSelected = true;
      _costPerMeterSelected = false;
    });
  }



        if (data.startingSimilarTableSellPricePerMeter != -4321) {
        _sellPricePerMeterController.text =
            data.startingSimilarTableSellPricePerMeter.toString();
        _sellPricePercentageController.text = '';
        setState(() {
          _sellPricePerMeterSelected = true;
          _sellPriceFixedSelected = false;
          _sellPricePercentageSelected = false;
        });
      } else if (data.startingSimilarTableSellPricePercentage != -4321) {
        _sellPricePerMeterController.text = '';
    _sellPricePercentageController.text =
        data.startingSimilarTableSellPricePercentage.toString();
    setState(() {
      _sellPricePercentageSelected = true;
      _sellPriceFixedSelected = false;
      _sellPricePerMeterSelected = false;
    });
  }else if (_sellPriceFixedSelected) {
          _sellPricePerMeterController.text = "";
          _sellPricePercentageController.text = "";
          setState(() {
            _sellPricePerMeterSelected = false;
            _sellPriceFixedSelected = true;
            _sellPricePercentageSelected = false;
          });
        }
    }

  else { // if (data is null)
      setState(() {
        _costPerMeterSelected = false;
        _costPricingFixedSelected = true;
        _costPercentageSelected = false;
        _sellPricePerMeterSelected = false;
        _sellPriceFixedSelected = true;
        _sellPricePercentageSelected = false;
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
    final isSalable = !(widget.nonSalableSegmentsInPriceType.contains(widget.segmentNumber1));

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      // title:    Text('Setting cost and selling price of upper segments'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(visible: !isSalable,
              child: Column(
                children: [
                  Container(
                    //  color: Colors.purpleAccent[900],mainAxisSize: MainAxisSize.min,
                    padding: const EdgeInsets.all(10),
                    child: Text('Based on the construction cost (per ft²/m²) of segment '
                        '${widget.segmentNumber1} on this floor, specify construction cost '
                        'of segments ${widget.segmentNumber1} on the upper floors of this cost-price plan by selecting one of '
                        'the options below.',
                      style:  TextStyle(
                        color: Colors.white, fontSize:  isIpad ? 30 : 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*Text('Based on the construction cost and selling price (per ft²/m²) of segment '
                        '${widget.segmentNumber1} on this floor, specify the construction cost and selling price '
                        'of segments ${widget.segmentNumber1} on the upper floors of this cost-price plan by selecting one of '
                        'the options below.',
                      style:  TextStyle(
                        color: Colors.white, size:  isIpad ? 30 : 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),*/
                  ),

            Container(
              color: Colors.red[900],
              padding: const EdgeInsets.all(10),
              child:  SizedBox(
                child: Text('Construction Cost', //'هزینه',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,fontSize:  textFontSize
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text(
                  'Fixed',
                  style: TextStyle(color: Colors.white,
                      fontSize:  textFontSize),
                ),
                const Spacer(),
                Switch(
                  value: _costPricingFixedSelected,
                  onChanged: (bool value) {
                    _costPerMeterController.text = "";
                    _costPercentageController.text = "";
                    setState(() {
                      _costPercentageSelected = false;
                      _costPerMeterSelected = false;
                      _costPricingFixedSelected = value;
                    });
                    widget.onCostPricingFixedSelectedChanged(value); },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(flex: 2,
                  child: Text(
                    'Percentage',
                    style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: TextField(
                      controller: _costPercentageController,
                      readOnly: !_costPercentageSelected,
                      decoration: const InputDecoration(
                        hintText: 'Enter percentage',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: TextInputType.number,
                      style:  const TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 1,
                  child: Switch(
                    value: _costPercentageSelected,
                    onChanged: (bool value) {
                      _costPerMeterController.text = "";
                      setState(() {
                        _costPercentageSelected = value;
                        _costPerMeterSelected = false;
                        _costPricingFixedSelected = false;
                        if (!_costPercentageSelected) {
                          _costPercentageController.text = '';
                        }
                      });
                      widget.onCostPercentageSelectedChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(flex: 2,
                  child: Text(
                    'Incremental',
                    style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    child: TextField(
                      controller: _costPerMeterController,
                      readOnly: !_costPerMeterSelected,
                      decoration: const InputDecoration(
                        //   hintText: 'Enter per ft²/m²',
                        hintStyle: TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: TextInputType.number,
                      style:  const TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 1,
                  child: Switch(
                    value: _costPerMeterSelected,
                    onChanged: (bool value) {
                      _costPercentageController.text = "";
                      setState(() {
                        _costPercentageSelected = false;
                        _costPerMeterSelected = value;
                        _costPricingFixedSelected = false;
                        if (!_costPerMeterSelected) {
                          _costPercentageController.text = '';
                        }
                      });
                      widget.onCostPerMeterSelectedChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
                ],
              ),
            ),

            Visibility(visible: isSalable,
              child: Column(
                children: [
                  Container(
                    //  color: Colors.purpleAccent[900],mainAxisSize: MainAxisSize.min,
                    padding: const EdgeInsets.all(10),
                    child: Text('Based on the construction cost and selling price (per ft²/m²) of segment '
                        '${widget.segmentNumber1} on this floor, specify construction cost and selling price '
                        'of segments ${widget.segmentNumber1} on the upper floors of this cost-price plan by selecting one of '
                        'the options below.',
                      style:  TextStyle(
                        color: Colors.white, fontSize:  isIpad ? 30 : 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*Text('Based on the construction cost and selling price (per ft²/m²) of segment '
                  '${widget.segmentNumber1} on this floor, specify the construction cost and selling price '
                  'of segments ${widget.segmentNumber1} on the upper floors of this cost-price plan by selecting one of '
                  'the options below.',
                style:  TextStyle(
                  color: Colors.white, size:  isIpad ? 30 : 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),*/
                  ),
                  Container(
                    color: Colors.red[900],
                    padding: const EdgeInsets.all(10),
                    child:  SizedBox(
                      child: Text('Construction Cost', //'هزینه',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,fontSize:  textFontSize
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        'Fixed',
                        style: TextStyle(color: Colors.white,
                            fontSize:  textFontSize),
                      ),
                      const Spacer(),
                      Switch(
                        value: _costPricingFixedSelected,
                        onChanged: (bool value) {
                          _costPerMeterController.text = "";
                          _costPercentageController.text = "";
                          setState(() {
                            _costPercentageSelected = false;
                            _costPerMeterSelected = false;
                            _costPricingFixedSelected = value;
                          });
                          widget.onCostPricingFixedSelectedChanged(value); },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 2,
                        child: Text(
                          'Percentage',
                          style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(flex: 2,
                        child: Container(
                          color: Colors.grey[100],
                          child: TextField(
                            controller: _costPercentageController,
                            readOnly: !_costPercentageSelected,
                            decoration: const InputDecoration(
                              hintText: 'Enter percentage',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            keyboardType: TextInputType.number,
                            style:  const TextStyle(color: Colors.black, fontSize: 23),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(flex: 1,
                        child: Switch(
                          value: _costPercentageSelected,
                          onChanged: (bool value) {
                            _costPerMeterController.text = "";
                            setState(() {
                              _costPercentageSelected = value;
                              _costPerMeterSelected = false;
                              _costPricingFixedSelected = false;
                              if (!_costPercentageSelected) {
                                _costPercentageController.text = '';
                              }
                            });
                            widget.onCostPercentageSelectedChanged(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 2,
                        child: Text(
                          'Incremental',
                          style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(flex: 2,
                        child: Container(
                          color: Colors.grey[200],
                          child: TextField(
                            controller: _costPerMeterController,
                            readOnly: !_costPerMeterSelected,
                            decoration: const InputDecoration(
                              //   hintText: 'Enter per ft²/m²',
                              hintStyle: TextStyle(color: Colors.black38),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            keyboardType: TextInputType.number,
                            style:  const TextStyle(color: Colors.black, fontSize: 23),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(flex: 1,
                        child: Switch(
                          value: _costPerMeterSelected,
                          onChanged: (bool value) {
                            _costPercentageController.text = "";
                            setState(() {
                              _costPercentageSelected = false;
                              _costPerMeterSelected = value;
                              _costPricingFixedSelected = false;
                              if (!_costPerMeterSelected) {
                                _costPercentageController.text = '';
                              }
                            });
                            widget.onCostPerMeterSelectedChanged(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),


                  Container(
                    color: Colors.green[700],
                    padding: const EdgeInsets.all(10),
                    child:  SizedBox(
                      child: Text('Sell Price',//'بها فروش',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,fontSize: textFontSize,
                        ),
                      ),
                    ),
                  ),


             const SizedBox(height: 10),
            Row(
              children: <Widget>[
                 Expanded(flex: 2,
                  child: Text(
                    'Fixed',
                    style: TextStyle(color: Colors.white,
                      fontSize: textFontSize,),
                  ),
                ),
                const Spacer(),
                 const SizedBox(width: 10),
                Expanded(flex: 1,
                  child: Switch(
                    value: _sellPriceFixedSelected,
                    onChanged: (bool value) {
                      _sellPricePercentageController.text = "";
                      _sellPricePerMeterController.text = "";
                      setState(() {
                        _sellPricePercentageSelected = false;
                        _sellPricePerMeterSelected = false;
                        _sellPriceFixedSelected = value;
                      });
                      widget.onSellPricingFixedSelectedChanged(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                 Expanded(flex: 2,
                  child: Text(
                    'Percentage',
                    style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                  ),
                ),
                 const  SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: TextField(
                      controller: _sellPricePercentageController,
                      readOnly: !_sellPricePercentageSelected,
                      decoration: const InputDecoration(
                        hintText: 'Enter percentage',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: TextInputType.number,
                      style:  const TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                ),
                 const SizedBox(width: 10),
                Expanded(flex: 1,
                  child: Switch(
                    value: _sellPricePercentageSelected,
                    onChanged: (bool value) {
                      _sellPricePerMeterController.text = "";
                      setState(() {
                        _sellPricePercentageSelected = value;
                        _sellPricePerMeterSelected = false;
                        _sellPriceFixedSelected = false;
                        if (!_sellPricePercentageSelected) {
                          _sellPricePercentageController.text = '';
                        }
                      });
                      widget.onSellPricePercentageSelectedChanged(value);
                    },
                  ),
                ),
              ],
            ),
             const SizedBox(height: 10),
            Row(
              children: <Widget>[
                 Expanded(flex: 2,
                  child: Text(
                    'Incremental',
                    style: TextStyle(color: Colors.white, fontSize: textFontSize * 0.8,),
                  ),
                ),
                 const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    color: Colors.grey[100],
                    child: TextField(
                      controller: _sellPricePerMeterController,
                      readOnly: !_sellPricePerMeterSelected,
                      decoration: const InputDecoration(
                    //    hintText: 'Enter per ft²/m²',
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      keyboardType: TextInputType.number,
                      style:  const TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                ),
                 const SizedBox(width: 10),
                Expanded(flex: 1,
                  child: Switch(
                    value: _sellPricePerMeterSelected,
                    onChanged: (bool value) {
                      _sellPricePercentageController.text = "";
                      setState(() {
                        _sellPricePercentageSelected = false;
                        _sellPricePerMeterSelected = value;
                        _sellPriceFixedSelected = false;
                        if (!_sellPricePerMeterSelected) {
                          _sellPricePercentageController.text = '';
                        }
                      });
                      widget.onSellPricePerMeterSelectedChanged(value);
                    },
                  ),
                ),
              ],
            ),
                ],),
            ),
          ],
        ),
      ),

      actions: <Widget>[
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Single blue background for the whole button
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding inside the button
            ),
            onPressed: () async {

              // Perform action when OK button is pressed
              double costPercent = -4321;
              double costPerMeter = -4321;
              double sellPercent = -4321;
              double sellPerMeter = -4321;

              // Check which toggle button is selected and get the associated text field value
              if (_costPercentageSelected) {
                final text = _costPercentageController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  costPercent = double.parse(text);
                }
              }
              else if (_costPerMeterSelected) {
                final text = _costPerMeterController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  costPerMeter = double.parse(text);
                }
              }
              else {
                _costPricingFixedSelected = true;
                costPercent = 0;
                costPerMeter = 0;
              }

              if (_sellPricePercentageSelected) {
                final text = _sellPricePercentageController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  sellPercent = double.parse(text);
                }
              } else if (_sellPricePerMeterSelected) {
                final text = _sellPricePerMeterController.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  sellPerMeter = double.parse(text);
                }
              } else {
                _sellPriceFixedSelected = true;
                sellPercent = 0;
                sellPerMeter = 0;
              }

              if ( (_costPercentageController.text.isNotEmpty &&
                  !isValidNumber(_costPercentageController.text.replaceAll(',', ''))) ||
                 (_costPerMeterController.text.isNotEmpty &&
                  !isValidNumber(_costPerMeterController.text.replaceAll(',', ''))) ||
                 ( _sellPricePercentageController.text.isNotEmpty &&
                  !isValidNumber(_sellPricePercentageController.text.replaceAll(',', ''))) ||
                   (_sellPricePerMeterController.text.isNotEmpty &&
                  !isValidNumber(_sellPricePerMeterController.text.replaceAll(',', '')))  )

            /*  if (!_costPricingFixedSelected && (_costPercentageController.text.isEmpty ||
                  !isValidNumber(_costPercentageController.text.replaceAll(',', ''))) &&
                  !_costPricingFixedSelected && (_costPerMeterController.text.isEmpty ||
                      !isValidNumber(_costPerMeterController.text.replaceAll(',', ''))) &&
                  !_sellPriceFixedSelected && ( _sellPricePercentageController.text.isEmpty ||
                      !isValidNumber(_sellPricePercentageController.text.replaceAll(',', ''))) &&
                  !_sellPriceFixedSelected && (_sellPricePerMeterController.text.isEmpty ||
                      !isValidNumber(_sellPricePerMeterController.text.replaceAll(',', '')))  )*/
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
                        'Please ensure all fields are filled with valid numbers.\n\n '
                            'Percentage cannot be greater than 100, and does not need % symbol.\n\n'
                            'If you have chosen to enter built-up area directly, '
                            'the value should not exceed the land area.',
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
              else {
                // Call the on PercentageUpdate method to save the data to the database
                await widget.onPercentageUpdate(context, widget.segmentNumber1, widget.similarFloor, widget.startingFloor,
                    widget.numberOfSegments, costPercent, costPerMeter, sellPercent, sellPerMeter );

                await widget.onCostSellDataGenerating(context, widget.projectName,widget.CPPNumber,
                    widget.segmentNumber1, widget.nonSalableSegmentsInPriceType,
                    costPercent,costPerMeter, sellPercent,sellPerMeter );

                Navigator.of(context).pop();

            }
            },
            child:  Text(
              'Set Rates',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make font bold
                color: Colors.white,
                backgroundColor: Colors.blue, // Optional: set text color for contrast
                fontSize: textFontSize,                 // Optional: adjust font size
              ),
            ),
          ),
        ),
      ],
    );
  }
}

