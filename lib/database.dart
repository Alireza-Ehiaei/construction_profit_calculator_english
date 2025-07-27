import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'ad_mob.dart';
import 'all_projects.dart';
import 'land.dart';
import 'main.dart';
import 'navigation_service.dart';
import 'permit_fees.dart';
import 'costPrices.dart';

class AreaTableRowData {
  final String name;
  final int segmentNumber;
  final int floorNumber; // Optional, if you want to track floor
  final TextEditingController textField1Controller;
  bool isSalableInArea;

  AreaTableRowData({
    required this.name,
    required this.segmentNumber,
    required this.floorNumber, // Optional
    required this.textField1Controller,
    this.isSalableInArea = true,
  });
}



class PriceTableRowData {
  String name;
  final int floorNumber;
  final int segmentNumber;
  TextEditingController textField2Controller;
  TextEditingController textField3Controller;
  TextEditingController textField4Controller;
  late final bool isSalableInPrice;

  PriceTableRowData({
    required this.name,
    required this.floorNumber,
    required this.segmentNumber,
    required this.textField2Controller,
    required this.textField3Controller,
    required this.textField4Controller,
    this.isSalableInPrice = true,
  });
}

class AreaData {
  int id;
  String segmentNumber;
  double area;

  AreaData({required this.id, required this.segmentNumber, required this.area});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'segmentNumber': segmentNumber,
      'area': area,
    };
  }
}

class ProjectBasicData {
  int projectBasicTableId;
  String projectBasicTableProjectName;
  double projectBasicTableLandArea;
  double projectBasicTableLandPricePerMeter;
  double projectBasicTableRoofAndYardConstructionCosts;
  double projectBasicTableTransactionCosts;
  double projectBasicTableOtherCosts;
  int projectBasicTableFirstFloorNumber;
  double projectBasicTableNumberOfSalableProperties;
  int projectBasicTableShortNumbersNumberOfZeroRemoved;

  ProjectBasicData({
    required this.projectBasicTableId,
    required this.projectBasicTableProjectName,
    required this.projectBasicTableLandArea,
    required this.projectBasicTableLandPricePerMeter,
    required this.projectBasicTableRoofAndYardConstructionCosts,
    required this.projectBasicTableTransactionCosts,
    required this.projectBasicTableOtherCosts,
    required this.projectBasicTableFirstFloorNumber,
    required this.projectBasicTableNumberOfSalableProperties,
    required this.projectBasicTableShortNumbersNumberOfZeroRemoved,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectBasicTableId': projectBasicTableId,
      'projectBasicTableProjectName': projectBasicTableProjectName,
      'projectBasicTableLandArea': projectBasicTableLandArea,
      'projectBasicTableLandPricePerMeter': projectBasicTableLandPricePerMeter,
      'projectBasicTableRoofAndYardConstructionCosts': projectBasicTableRoofAndYardConstructionCosts,
      'projectBasicTableTransactionCosts': projectBasicTableTransactionCosts,
      'projectBasicTableOtherCosts': projectBasicTableOtherCosts,
      'projectBasicTableFirstFloorNumber': projectBasicTableFirstFloorNumber,
      'projectBasicTableNumberOfSalableProperties': projectBasicTableNumberOfSalableProperties,
      'projectBasicTableShortNumbersNumberOfZeroRemoved': projectBasicTableShortNumbersNumberOfZeroRemoved,
    };
  }
}

class ProjectTableData {
  int costPricingTableProjectId;
  String costPricingTableProjectName;
  int costPricingTableCpp;
  int costPricingTableFloorNumber;
  int costPricingTableSegmentNumber;
  double costPricingTableSegmentArea;
  double costPricingTableSegmentCostPerMeter;
  double costPricingTableSegmentSellPricePerMeter;
  double costPricingTableIncomeOfSegment;
  double costPricingTableCostOfSegment;
  double costPricingTableProfitOfSegment;
  int costPricingTableIndex3;

  ProjectTableData({
    required this.costPricingTableProjectId,
    required this.costPricingTableProjectName,
    required this.costPricingTableCpp,
    required this.costPricingTableFloorNumber,
    required this.costPricingTableSegmentNumber,
    required this.costPricingTableSegmentArea,
    required this.costPricingTableSegmentCostPerMeter,
    required this.costPricingTableSegmentSellPricePerMeter,
    required this.costPricingTableIncomeOfSegment,
    required this.costPricingTableCostOfSegment,
    required this.costPricingTableProfitOfSegment,
    required this.costPricingTableIndex3,
  });

  Map<String, dynamic> toMap() {
    return {
      'costPricingTableProjectId': costPricingTableProjectId,
      'costPricingTableProjectName': costPricingTableProjectName,
      'costPricingTableCpp': costPricingTableCpp,
      'costPricingTableFloorNumber': costPricingTableFloorNumber,
      'costPricingTableSegmentNumber': costPricingTableSegmentNumber,
      'costPricingTableSegmentArea': costPricingTableSegmentArea,
      'costPricingTableSegmentCostPerMeter': costPricingTableSegmentCostPerMeter,
      'costPricingTableSegmentSellPricePerMeter': costPricingTableSegmentSellPricePerMeter,
      'costPricingTableIncomeOfSegment': costPricingTableIncomeOfSegment,
      'costPricingTableCostOfSegment': costPricingTableCostOfSegment,
      'costPricingTableProfitOfSegment': costPricingTableProfitOfSegment,
      'costPricingTableIndex3': costPricingTableIndex3,
    };
  }
}

// Each table has equal to the number of cpps multiplied number of segments of floors in that cpp
//  records in starting similar table in database  For example if a project has two cpps and cpp one
// has three floors each one with two segments and cpp 2 has three floors each one with 4 segments totally there are
// 6 records in database (4 segments + 2 segments) for this project in StartingSimilarTableData because from each cpp
// data of one floor is saved in StartingSimilarTableData

class ProjectStartingSimilarTableData {
  final int startingSimilarTableId;
  final String startingSimilarTableProjectName;
  final int startingSimilarTableCpp;
  late final int startingSimilarTableStartingFloor;
  final int startingSimilarTableSimilarFloor;
  final int startingSimilarTableSegmentSalable;
  final int startingSimilarTableNumberOfSegments;
  final int startingSimilarTableSegmentNumber;
  final double startingSimilarTableCostPercentage;
  final double startingSimilarTableCostPerMeter;
  final double startingSimilarTableSellPricePercentage;
  final double startingSimilarTableSellPricePerMeter;

  ProjectStartingSimilarTableData({
    required this.startingSimilarTableId,
    required this.startingSimilarTableProjectName,
    required this.startingSimilarTableCpp,
    required this.startingSimilarTableStartingFloor,
    required this.startingSimilarTableSimilarFloor,
    required this.startingSimilarTableSegmentSalable,
    required this.startingSimilarTableNumberOfSegments,
    required this.startingSimilarTableSegmentNumber,
    required this.startingSimilarTableCostPercentage,
    required this.startingSimilarTableCostPerMeter,
    required this.startingSimilarTableSellPricePercentage,
    required this.startingSimilarTableSellPricePerMeter,
  });

  Map<String, dynamic> toMap() {
    return {
      'startingSimilarTableId': startingSimilarTableId,
      'startingSimilarTableProjectName': startingSimilarTableProjectName,
      'startingSimilarTableCpp': startingSimilarTableCpp,
      'startingSimilarTableStartingFloor': startingSimilarTableStartingFloor,
      'startingSimilarTableSimilarFloor': startingSimilarTableSimilarFloor,
      'startingSimilarTableSegmentSalable': startingSimilarTableSegmentSalable,
      'startingSimilarTableNumberOfSegments': startingSimilarTableNumberOfSegments,
      'startingSimilarTableSegmentNumber': startingSimilarTableSegmentNumber,
      'startingSimilarTableCostPercentage': startingSimilarTableCostPercentage,
      'startingSimilarTableCostPerMeter': startingSimilarTableCostPerMeter,
      'startingSimilarTableSellPricePercentage': startingSimilarTableSellPricePercentage,
      'startingSimilarTableSellPricePerMeter': startingSimilarTableSellPricePerMeter,
    };
  }
}

class PermitFeeSegmentPricingData {
  int permitFeeSegmentPricingTableId;
  String permitFeeSegmentPricingTableProjectName;
  int permitFeeSegmentPricingTableSegmentNumber;
  int permitFeeSegmentPricingTableFloorNumber;
  int permitFeeSegmentPricingTableFeePlanNumber;
  double permitFeeSegmentPricingTableSegmentArea;
  double permitFeeSegmentPricingTableSegmentFeePerMeter;
  double permitFeeSegmentPricingTableTotalSegmentPermitFee;

  PermitFeeSegmentPricingData({
    required this.permitFeeSegmentPricingTableId,
    required this.permitFeeSegmentPricingTableProjectName,
    required this.permitFeeSegmentPricingTableSegmentNumber,
    required this.permitFeeSegmentPricingTableFloorNumber,
    required this.permitFeeSegmentPricingTableFeePlanNumber,
    required this.permitFeeSegmentPricingTableSegmentArea,
    required this.permitFeeSegmentPricingTableSegmentFeePerMeter,
    required this.permitFeeSegmentPricingTableTotalSegmentPermitFee,
  });

  Map<String, dynamic> toMap() {
    return {
      'permitFeeSegmentPricingTableId': permitFeeSegmentPricingTableId,
      'permitFeeSegmentPricingTableProjectName': permitFeeSegmentPricingTableProjectName,
      'permitFeeSegmentPricingTableSegmentNumber': permitFeeSegmentPricingTableSegmentNumber,
      'permitFeeSegmentPricingTableFloorNumber': permitFeeSegmentPricingTableFloorNumber,
      'permitFeeSegmentPricingTableFeePlanNumber': permitFeeSegmentPricingTableFeePlanNumber,
      'permitFeeSegmentPricingTableSegmentArea': permitFeeSegmentPricingTableSegmentArea,
      'permitFeeSegmentPricingTableSegmentFeePerMeter': permitFeeSegmentPricingTableSegmentFeePerMeter,
      'permitFeeSegmentPricingTableTotalSegmentPermitFee': permitFeeSegmentPricingTableTotalSegmentPermitFee,
    };
  }
}

class PermitFeeStartingSimilarTableData {
  int permitFeeStartingSimilarTableId;
  String permitFeeStartingSimilarTableProjectName;
  int permitFeeStartingSimilarTableFeePlanNumber;
  int permitFeeStartingSimilarTableStartingFloor;
  int permitFeeStartingSimilarTableSimilarFloor;
//  int permitFeeStartingSimilarTableFloorNumber;
  int permitFeeStartingSimilarTableNumberOfSegments;
  int permitFeeStartingSimilarTableSegmentNumber;
  double permitFeeStartingSimilarTableFeePercentage;
  double permitFeeStartingSimilarTableFeePerMeter;

  PermitFeeStartingSimilarTableData({
    required this.permitFeeStartingSimilarTableId,
    required this.permitFeeStartingSimilarTableProjectName,
    required this.permitFeeStartingSimilarTableSegmentNumber,
    required this.permitFeeStartingSimilarTableStartingFloor,
    required this.permitFeeStartingSimilarTableSimilarFloor,
 //   required this.permitFeeStartingSimilarTableFloorNumber,
    required this.permitFeeStartingSimilarTableNumberOfSegments,
    required this.permitFeeStartingSimilarTableFeePlanNumber,
    required this.permitFeeStartingSimilarTableFeePercentage,
    required this.permitFeeStartingSimilarTableFeePerMeter,
  });

  Map<String, dynamic> toMap() {
    return {
      'permitFeeStartingSimilarTableId': permitFeeStartingSimilarTableId,
      'permitFeeStartingSimilarTableProjectName': permitFeeStartingSimilarTableProjectName,
      'permitFeeStartingSimilarTableSegmentNumber': permitFeeStartingSimilarTableSegmentNumber,
      'permitFeeStartingSimilarTableStartingFloor': permitFeeStartingSimilarTableStartingFloor,
      'permitFeeStartingSimilarTableSimilarFloor': permitFeeStartingSimilarTableSimilarFloor,
   //   'permitFeeStartingSimilarTableFloorNumber': permitFeeStartingSimilarTableFloorNumber,
      'permitFeeStartingSimilarTableNumberOfSegments': permitFeeStartingSimilarTableNumberOfSegments,
      'permitFeeStartingSimilarTableFeePlanNumber': permitFeeStartingSimilarTableFeePlanNumber,
      'permitFeeStartingSimilarTableFeePercentage': permitFeeStartingSimilarTableFeePercentage,
      'permitFeeStartingSimilarTableFeePerMeter': permitFeeStartingSimilarTableFeePerMeter,
    };
  }
}

class ProjectResultFloorData {
  int resultFloorTableId;
  String resultFloorTableProjectName;
  int resultFloorTableCostPricePlan;
  int resultFloorTableFloorNumber;
  String resultFloorTableIncomeOfFloor;
  String resultFloorTableCostOfFloor;
  String resultFloorTableProfitOfFloor;

  ProjectResultFloorData({
    required this.resultFloorTableId,
    required this.resultFloorTableProjectName,
    required this.resultFloorTableCostPricePlan,
    required this.resultFloorTableFloorNumber,
    required this.resultFloorTableIncomeOfFloor,
    required this.resultFloorTableCostOfFloor,
    required this.resultFloorTableProfitOfFloor,
  });

  Map<String, dynamic> toMap() {
    return {
      'resultFloorTableId': resultFloorTableId,
      'resultFloorTableProjectName': resultFloorTableProjectName,
      'resultFloorTableCostPricePlan': resultFloorTableCostPricePlan,
      'resultFloorTableFloorNumber': resultFloorTableFloorNumber,
      'resultFloorTableIncomeOfFloor': resultFloorTableIncomeOfFloor,
      'resultFloorTableCostOfFloor': resultFloorTableCostOfFloor,
      'resultFloorTableProfitOfFloor': resultFloorTableProfitOfFloor,
    };
  }
}

class projectResultCppData {
  int resultCppTableId;
  String resultCppTableProjectName;
  int resultCppTableCostPricePlan;
  String resultCppTableIncomeOfCostPricePlan;
  String resultCppTableCostOfCostPricePlan;
  String resultCppTableProfitOfCostPricePlan;

  projectResultCppData({
    required this.resultCppTableId,
    required this.resultCppTableProjectName,
    required this.resultCppTableCostPricePlan,
    required this.resultCppTableIncomeOfCostPricePlan,
    required this.resultCppTableCostOfCostPricePlan,
    required this.resultCppTableProfitOfCostPricePlan,
  });

  Map<String, dynamic> toMap() {
    return {
      'resultCppTableId': resultCppTableId,
      'resultCppTableProjectName': resultCppTableProjectName,
      'resultCppTableCostPricePlan': resultCppTableCostPricePlan,
      'resultCppTableIncomeOfCostPricePlan': resultCppTableIncomeOfCostPricePlan,
      'resultCppTableCostOfCostPricePlan': resultCppTableCostOfCostPricePlan,
      'resultCppTableProfitOfCostPricePlan': resultCppTableProfitOfCostPricePlan,
    };
  }
}

class ResultProjectColumnsClassData {
  int resultProjectTableId;
  String resultProjectTableProjectName;
  String resultProjectTableCostOfLand;
  String resultProjectTableLandArea;
  String resultProjectTableTotalNumberOfFloorsText;
  String resultProjectTableFloorZeroConstructedArea;
  String resultProjectTableFloorZeroConstructedPercentage;
  String resultProjectTableTotalCommonArea;
  String resultProjectTableTotalSalableArea;
  String resultProjectTableTotalSalableAreaToLandArea;
  String resultProjectTableAverageConstructionCostPerMeter;
  String resultProjectTableTotalConstructionCost;
  String resultProjectTableAveragePermissionCostPerMeter;
  String resultProjectTableTotalPermissionCost;
  String resultProjectTableOtherCostsText;
  String resultProjectTableTransactionCostsText;
  String resultProjectTableRoofAndYardConstructionCostsText;
  String resultProjectTableTotalConstructedArea;
  String resultProjectTableSegmentAverageSellPricePerMeter;
  String resultProjectTableLandPricePerMeterToAverageSellPricePerMeter;
  String resultProjectTableSegmentMinSellPricePerMeter;
  String resultProjectTableSegmentMaxSellPricePerMeter;
  String resultProjectTableTotalIncome;
  String resultProjectTableTotalCosts;
  String resultProjectTableTotalProfit;
  String resultProjectTableProfitPercentageOfProject;
  String resultProjectTableAllCostsIncurredPerMeterOfSalableArea;
  String resultProjectTableProfitPerSalableArea;
  String resultProjectTableLandPermissionCostsPerTotalCosts;
  String resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost;
  String resultProjectTableSalableAreaConstructedPerMillionCurrencySegments;
  String resultProjectTableCalculationType;
  String resultProjectTableNumberOfSalableProperties;
  String resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments;


  ResultProjectColumnsClassData({
    required this.resultProjectTableId,
    required this.resultProjectTableProjectName,
    required this.resultProjectTableLandArea,
    required this.resultProjectTableCostOfLand,
    required this.resultProjectTableTotalNumberOfFloorsText,
    required this.resultProjectTableFloorZeroConstructedArea,
    required this.resultProjectTableFloorZeroConstructedPercentage,
    required this.resultProjectTableTotalCommonArea,
    required this.resultProjectTableTotalSalableArea,
    required this.resultProjectTableTotalSalableAreaToLandArea,
    required this.resultProjectTableAverageConstructionCostPerMeter,
    required this.resultProjectTableTotalConstructionCost,
    required this.resultProjectTableAveragePermissionCostPerMeter,
    required this.resultProjectTableOtherCostsText,
    required this.resultProjectTableTotalPermissionCost,
    required this.resultProjectTableTransactionCostsText,
    required this.resultProjectTableRoofAndYardConstructionCostsText,
    required this.resultProjectTableTotalConstructedArea,
    required this.resultProjectTableSegmentAverageSellPricePerMeter,
    required this.resultProjectTableLandPricePerMeterToAverageSellPricePerMeter,
    required this.resultProjectTableSegmentMinSellPricePerMeter,
    required this.resultProjectTableSegmentMaxSellPricePerMeter,
    required this.resultProjectTableTotalIncome,
    required this.resultProjectTableTotalCosts,
    required this.resultProjectTableTotalProfit,
    required this.resultProjectTableProfitPercentageOfProject,
    required this.resultProjectTableAllCostsIncurredPerMeterOfSalableArea,
    required this.resultProjectTableProfitPerSalableArea,
    required this.resultProjectTableSalableAreaConstructedPerMillionCurrencySegments,
    required this.resultProjectTableLandPermissionCostsPerTotalCosts,
    required this.resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost,
    required this.resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments,
    required this.resultProjectTableNumberOfSalableProperties,
    required this.resultProjectTableCalculationType,
  });

  Map<String, dynamic> toMap() {
    return {
      'resultProjectTableId': resultProjectTableId,
      'resultProjectTableProjectName': resultProjectTableProjectName,
      'resultProjectTableLandArea': resultProjectTableLandArea,
      'resultProjectTableTotalNumberOfFloorsText': resultProjectTableTotalNumberOfFloorsText,
      'resultProjectTableCostOfLand': resultProjectTableCostOfLand,
      'resultProjectTableFloorZeroConstructedArea': resultProjectTableFloorZeroConstructedArea,
      'resultProjectTableFloorZeroConstructedPercentage': resultProjectTableFloorZeroConstructedPercentage,
      'resultProjectTableTotalCommonArea': resultProjectTableTotalCommonArea,
      'resultProjectTableTotalSalableArea': resultProjectTableTotalSalableArea,
      'resultProjectTableTotalSalableAreaToLandArea': resultProjectTableTotalSalableAreaToLandArea,
      'resultProjectTableAverageConstructionCostPerMeter': resultProjectTableAverageConstructionCostPerMeter,
      'resultProjectTableTotalConstructionCost': resultProjectTableTotalConstructionCost,
      'resultProjectTableAveragePermissionCostPerMeter': resultProjectTableAveragePermissionCostPerMeter,
      'resultProjectTableTotalPermissionCost': resultProjectTableTotalPermissionCost,
      'resultProjectTableTotalConstructedArea': resultProjectTableTotalConstructedArea,
      'resultProjectTableSegmentAverageSellPricePerMeter': resultProjectTableSegmentAverageSellPricePerMeter,
      'resultProjectTableLandPricePerMeterToAverageSellPricePerMeter': resultProjectTableLandPricePerMeterToAverageSellPricePerMeter,
      'resultProjectTableSegmentMinSellPricePerMeter': resultProjectTableSegmentMinSellPricePerMeter,
      'resultProjectTableSegmentMaxSellPricePerMeter': resultProjectTableSegmentMaxSellPricePerMeter,
      'resultProjectTableTransactionCostsText': resultProjectTableTransactionCostsText,
      'resultProjectTableOtherCostsText': resultProjectTableOtherCostsText,
      'resultProjectTableTotalIncome': resultProjectTableTotalIncome,
      'resultProjectTableTotalCosts': resultProjectTableTotalCosts,
      'resultProjectTableTotalProfit': resultProjectTableTotalProfit,
      'resultProjectTableProfitPercentageOfProject': resultProjectTableProfitPercentageOfProject,
      'resultProjectTableAllCostsIncurredPerMeterOfSalableArea': resultProjectTableAllCostsIncurredPerMeterOfSalableArea,
      'resultProjectTableProfitPerSalableArea': resultProjectTableProfitPerSalableArea,
      'resultProjectTableSalableAreaConstructedPerMillionCurrencySegments': resultProjectTableSalableAreaConstructedPerMillionCurrencySegments,
      'resultProjectTableNumberOfSalableProperties': resultProjectTableNumberOfSalableProperties,
      'resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments': resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments,
      'resultProjectTableLandPermissionCostsPerTotalCosts': resultProjectTableLandPermissionCostsPerTotalCosts,
      'resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost': resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost,
      'resultProjectTableCalculationType': resultProjectTableCalculationType,
      'resultProjectTableRoofAndYardConstructionCostsText': resultProjectTableRoofAndYardConstructionCostsText,
    };
  }
}

class ProjectAddressData {
  int addressTableId;
  String addressTableProjectName;
  String addressTableEnvironmentallyFriendly;
  String addressTableSociallyFriendly;
  String addressTableProvinceName;
  String addressTableCity;
  String addressTableStreet;
  String addressTableBuildingNumber;
  String addressTablePhoneNumber;
  String addressTableOther;

  ProjectAddressData({
    required this.addressTableId,
    required this.addressTableProjectName,
    required this.addressTableEnvironmentallyFriendly,
    required this.addressTableSociallyFriendly,
    required this.addressTableProvinceName,
    required this.addressTableCity,
    required this.addressTableStreet,
    required this.addressTableBuildingNumber,
    required this.addressTablePhoneNumber,
    required this.addressTableOther,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressTableId': addressTableId,
      'addressTableProjectName': addressTableProjectName,
      'addressTableEnvironmentallyFriendly': addressTableEnvironmentallyFriendly,
      'addressTableSociallyFriendly': addressTableSociallyFriendly,
      'addressTableProvinceName': addressTableProvinceName,
      'addressTableCity': addressTableCity,
      'addressTableStreet': addressTableStreet,
      'addressTableBuildingNumber': addressTableBuildingNumber,
      'addressTablePhoneNumber': addressTablePhoneNumber,
      'addressTableOther': addressTableOther,
    };
  }
}

class CompleteCalculationDatabaseHelper {

  static const String tableBasicData = 'projectBasicDataTable';
  static const String columnProjectBasicTableId = 'projectBasicTableId';
  static const String columnProjectBasicTableProjectName = 'projectBasicTableProjectName';
  static const String columnProjectBasicTableLandArea = 'projectBasicTableLandArea';
  static const String columnProjectBasicTableLandPricePerMeter = 'projectBasicTableLandPricePerMeter';
  static const String columnProjectBasicTableRoofAndYardConstructionCosts = 'projectBasicTableRoofAndYardConstructionCosts';
  static const String columnProjectBasicTableTransactionCosts = 'projectBasicTableTransactionCosts';
  static const String columnProjectBasicTableOtherCosts = 'projectBasicTableOtherCosts';
  static const String columnProjectBasicTableFirstFloorNumber = 'projectBasicTableFirstFloorNumber';
  static const String columnProjectBasicTableNumberOfSalableProperties = 'projectBasicTableNumberOfSalableProperties';
  static const String columnProjectBasicTableShortNumbersNumberOfZeroRemoved = 'projectBasicTableShortNumbersNumberOfZeroRemoved';

  static const tableCostPricing = 'projectCostPricingTable';
  static const columnCostPricingTableProjectId = 'costPricingTableProjectId';
  static const columnCostPricingTableProjectName = 'costPricingTableProjectName';
  static const columnCostPricingTableCpp = 'costPricingTableCpp';
  static const columnCostPricingTableFloorNumber = 'costPricingTableFloorNumber';
  static const columnCostPricingTableSegmentNumber = 'costPricingTableSegmentNumber';
  static const columnCostPricingTableSegmentArea = 'costPricingTableSegmentArea';
  static const columnCostPricingTableSegmentCostPerMeter = 'costPricingTableSegmentCostPerMeter';
  static const columnCostPricingTableSegmentSellPricePerMeter = 'costPricingTableSegmentSellPricePerMeter';
  static const columnCostPricingTableIncomeOfSegment = 'costPricingTableIncomeOfSegment';
  static const columnCostPricingTableCostOfSegment = 'costPricingTableCostOfSegment';
  static const columnCostPricingTableProfitOfSegment = 'costPricingTableProfitOfSegment';
  static const columnCostPricingTableIndex3 = 'costPricingTableIndex3';

  static const tableStartingSimilar = 'projectStartingSimilarTable';
  static const columnStartingSimilarTableId = 'startingSimilarTableId';
  static const columnStartingSimilarTableProjectName = 'startingSimilarTableProjectName';
  static const columnStartingSimilarTableCpp = 'startingSimilarTableCpp';
  static const columnStartingSimilarTableStartingFloor = 'startingSimilarTableStartingFloor';
  static const columnStartingSimilarTableSimilarFloor = 'startingSimilarTableSimilarFloor';
  static const columnStartingSimilarTableNumberOfSegments = 'startingSimilarTableNumberOfSegments';
  static const columnStartingSimilarTableSegmentNumber = 'startingSimilarTableSegmentNumber';
  static const columnstartingSimilarTableSegmentSalable = 'startingSimilarTableSegmentSalable';
  static const columnStartingSimilarTableCostPercentage = 'startingSimilarTableCostPercentage';
  static const columnStartingSimilarTableCostPerMeter = 'startingSimilarTableCostPerMeter';
  static const columnStartingSimilarTableSellPricePercentage = 'startingSimilarTableSellPricePercentage';
  static const columnStartingSimilarTableSellPricePerMeter = 'startingSimilarTableSellPricePerMeter';

  static const tablePermitFeeSegmentPricing = 'permitFeeSegmentPricingTable';
  static const columnPermitFeeSegmentPricingTableId = 'permitFeeSegmentPricingTableId';
  static const columnPermitFeeSegmentPricingTableProjectName = 'permitFeeSegmentPricingTableProjectName';
  static const columnPermitFeeSegmentPricingTableSegmentNumber = 'permitFeeSegmentPricingTableSegmentNumber';
  static const columnPermitFeeSegmentPricingTableFloorNumber = 'permitFeeSegmentPricingTableFloorNumber';
  static const columnPermitFeeSegmentPricingTableFeePlanNumber = 'permitFeeSegmentPricingTableFeePlanNumber';
  static const columnPermitFeeSegmentPricingTableSegmentArea = 'permitFeeSegmentPricingTableSegmentArea';
  static const columnPermitFeeSegmentPricingTableSegmentFeePerMeter = 'permitFeeSegmentPricingTableSegmentFeePerMeter';
  static const columnPermitFeeSegmentPricingTableTotalSegmentFee = 'permitFeeSegmentPricingTableTotalSegmentPermitFee';

  static const tablePermitFeeStartingSimilar = 'permitFeeStartingSimilarTable';
  static const columnPermitFeeStartingSimilarTableId = 'permitFeeStartingSimilarTableId';
  static const columnPermitFeeStartingSimilarTableProjectName = 'permitFeeStartingSimilarTableProjectName';
  static const columnPermitFeeStartingSimilarTableSegmentNumber = 'permitFeeStartingSimilarTableSegmentNumber';
  static const columnPermitFeeStartingSimilarTableStartingFloor = 'permitFeeStartingSimilarTableStartingFloor';
  static const columnPermitFeeStartingSimilarTableSimilarFloor = 'permitFeeStartingSimilarTableSimilarFloor';
 // static const columnPermitFeeStartingSimilarTableFloorNumber = 'permitFeeStartingSimilarTableFloorNumber';
  static const columnPermitFeeStartingSimilarTableNumberOfSegments = 'permitFeeStartingSimilarTableNumberOfSegments';
  static const columnPermitFeeStartingSimilarTableFeePlanNumber = 'permitFeeStartingSimilarTableFeePlanNumber';
  static const columnPermitFeeStartingSimilarTableFeePercentage = 'permitFeeStartingSimilarTableFeePercentage';
  static const columnPermitFeeStartingSimilarTableFeePerMeter = 'permitFeeStartingSimilarTableFeePerMeter';


  static const tableResultProjectData = 'resultProjectDataTable';
  static const String columnResultProjectTableId = 'resultProjectTableId';
  static const String columnResultProjectTableProjectName = 'resultProjectTableProjectName';
  static const String columnResultProjectTableLandArea = 'resultProjectTableLandArea';
  static const String columnResultProjectTableCostOfLand = 'resultProjectTableCostOfLand';
  static const String columnResultProjectTableTotalNumberOfFloorsText = 'resultProjectTableTotalNumberOfFloorsText';
  static const String columnResultProjectTableFloorZeroConstructedArea = 'resultProjectTableFloorZeroConstructedArea';
  static const String columnResultProjectTableFloorZeroConstructedPercentage = 'resultProjectTableFloorZeroConstructedPercentage';
  static const String columnResultProjectTableTotalCommonArea = 'resultProjectTableTotalCommonArea';
  static const String columnResultProjectTableTotalSalableArea = 'resultProjectTableTotalSalableArea';
  static const String columnResultProjectTableAverageConstructionCostPerMeter = 'resultProjectTableAverageConstructionCostPerMeter';
  static const String columnResultProjectTableTotalConstructionCost = 'resultProjectTableTotalConstructionCost';
  static const String columnResultProjectTableAveragePermissionCostPerMeter = 'resultProjectTableAveragePermissionCostPerMeter';
  static const String columnResultProjectTableTotalPermissionCost = 'resultProjectTableTotalPermissionCost';
  static const String columnResultProjectTableOtherCostsText = 'resultProjectTableOtherCostsText';
  static const String columnResultProjectTableTotalConstructedArea = 'resultProjectTableTotalConstructedArea';
  static const String columnResultProjectTableSegmentAverageSellPricePerMeter = 'resultProjectTableSegmentAverageSellPricePerMeter';
  static const String columnResultProjectTableSegmentMinSellPricePerMeter = 'resultProjectTableSegmentMinSellPricePerMeter';
  static const String columnResultProjectTableSegmentMaxSellPricePerMeter = 'resultProjectTableSegmentMaxSellPricePerMeter';
  static const String columnResultProjectTableTotalIncome = 'resultProjectTableTotalIncome';
  static const String columnResultProjectTableTotalCosts = 'resultProjectTableTotalCosts';
  static const String columnResultProjectTableTotalProfit = 'resultProjectTableTotalProfit';
  static const String columnResultProjectTableProfitPercentageOfProject = 'resultProjectTableProfitPercentageOfProject';
  static const String columnResultProjectTableAllCostsIncurredPerMeterOfSalableArea = 'resultProjectTableAllCostsIncurredPerMeterOfSalableArea';
  static const String columnResultProjectTableProfitPerSalableArea = 'resultProjectTableProfitPerSalableArea';
  static const String columnResultProjectTableSalableAreaConstructedPerMillionCurrencySegments = 'resultProjectTableSalableAreaConstructedPerMillionCurrencySegments';
  static const String columnResultProjectTableCalculationType = 'resultProjectTableCalculationType';
  static const String columnResultProjectTableLandPricePerMeterToAverageSellPricePerMeter = 'resultProjectTableLandPricePerMeterToAverageSellPricePerMeter';
  static const String columnResultProjectTableLandPermissionCostsPerTotalCosts = 'resultProjectTableLandPermissionCostsPerTotalCosts';
  static const String columnResultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost =
      'resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost';

  static const String columnResultProjectTableTotalSalableAreaToLandArea = 'resultProjectTableTotalSalableAreaToLandArea';
  static const String columnResultProjectTableRoofAndYardConstructionCostsText = 'resultProjectTableRoofAndYardConstructionCostsText';
  static const String columnResultProjectTableTransactionCostsText = 'resultProjectTableTransactionCostsText';
  static const String columnResultProjectTableNumberOfSalableProperties = 'resultProjectTableNumberOfSalableProperties';
  static const String columnResultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments = 
      'resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments';

  // Result Construction Data Table
  static const String tableResultCppData = 'resultConstructionDataTable';
  static const String columnResultCppTableId = 'resultCppTableId';
  static const String columnResultCppTableProjectName = 'resultCppTableProjectName';
  static const String columnResultCppTableCostPricePlan = 'resultCppTableCostPricePlan';
  static const String columnResultCppTableIncomeOfCostPricePlan = 'resultCppTableIncomeOfCostPricePlan';
  static const String columnResultCppTableCostOfCostPricePlan = 'resultCppTableCostOfCostPricePlan';
  static const String columnResultCppTableProfitOfCostPricePlan = 'resultCppTableProfitOfCostPricePlan';

// Result Floor Data Table
  static const String tableResultFloorData = 'resultFloorDataTable';
  static const String columnResultFloorTableId = 'resultFloorTableId';
  static const String columnResultFloorTableProjectName = 'resultFloorTableProjectName';
  static const String columnResultFloorTableCostPricePlan = 'resultFloorTableCostPricePlan';
  static const String columnResultFloorTableFloorNumber = 'resultFloorTableFloorNumber';
  static const String columnResultFloorTableIncomeOfFloor = 'resultFloorTableIncomeOfFloor';
  static const String columnResultFloorTableCostOfFloor = 'resultFloorTableCostOfFloor';
  static const String columnResultFloorTableProfitOfFloor = 'resultFloorTableProfitOfFloor';


  static const String tableAddress = 'projectAddressTable';
  static const String columnAddressTableId = 'addressTableId';
  static const String columnAddressTableProjectName = 'addressTableProjectName';
  static const String columnAddressTableEnvironmentallyFriendly = 'addressTableEnvironmentallyFriendly';
  static const String columnAddressTableSociallyFriendly = 'addressTableSociallyFriendly';
  static const String columnAddressTableProvinceName = 'addressTableProvinceName';
  static const String columnAddressTableCity = 'addressTableCity';
  static const String columnAddressTableStreet = 'addressTableStreet';
  static const String columnAddressTableBuildingNumber = 'addressTableBuildingNumber';
  static const String columnAddressTablePhoneNumber = 'addressTablePhoneNumber';
  static const String columnAddressTableOther = 'addressTableOther';

  static const String columnFavoriteLevelProjectName = 'projectName';
  static const String columnFavoriteLevel = 'favoriteLevel';

  static const _databaseName = 'homePriceDatabase1.db';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final databasesPath = await getApplicationDocumentsDirectory();
    final databasePath = join(databasesPath.path, _databaseName);
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _onCreateProjectBasicTable(db, version);
    await _onCreateCostPricingTable(db, version);
    await _onCreateStartingSimilarTable(db, version);
    await _onCreatePermitFeeSegmentPricingTable(db, version);
    await _onCreatePermitFeeStartingSimilarTable(db, version);
    await _onCreateResultFloorTable(db, version);
    await _onCreateprojectResultCppData(db, version);
    await _onCreateResultProjectTable(db, version);
    await _onCreateAddressTable(db, version);
  }

  static Future<void> _onCreateProjectBasicTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableBasicData (
      $columnProjectBasicTableId INTEGER PRIMARY KEY,
      $columnProjectBasicTableProjectName TEXT NOT NULL,
      $columnProjectBasicTableLandArea REAL NOT NULL,
      $columnProjectBasicTableLandPricePerMeter REAL NOT NULL,
      $columnProjectBasicTableRoofAndYardConstructionCosts REAL NOT NULL,
      $columnProjectBasicTableTransactionCosts REAL NOT NULL,
      $columnProjectBasicTableOtherCosts REAL NOT NULL,
      $columnProjectBasicTableFirstFloorNumber INTEGER NOT NULL,
      $columnProjectBasicTableNumberOfSalableProperties REAL NOT NULL,
      $columnProjectBasicTableShortNumbersNumberOfZeroRemoved INTEGER NOT NULL
    )
  ''');
  }


  static Future<void> _onCreateCostPricingTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCostPricing (
        $columnCostPricingTableProjectId INTEGER PRIMARY KEY,
        $columnCostPricingTableProjectName TEXT NOT NULL,
        $columnCostPricingTableCpp INTEGER NOT NULL,
        $columnCostPricingTableFloorNumber INTEGER NOT NULL,
        $columnCostPricingTableSegmentNumber INTEGER NOT NULL,
        $columnCostPricingTableSegmentArea REAL NOT NULL,
        $columnCostPricingTableSegmentCostPerMeter REAL NOT NULL,
        $columnCostPricingTableSegmentSellPricePerMeter REAL NOT NULL,
        $columnCostPricingTableIncomeOfSegment REAL NOT NULL,
        $columnCostPricingTableCostOfSegment REAL NOT NULL,
        $columnCostPricingTableProfitOfSegment REAL NOT NULL,
        $columnCostPricingTableIndex3 INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> _onCreateStartingSimilarTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableStartingSimilar (
        $columnStartingSimilarTableId INTEGER PRIMARY KEY,
        $columnStartingSimilarTableProjectName TEXT NOT NULL,
        $columnStartingSimilarTableCpp INTEGER NOT NULL,
        $columnStartingSimilarTableStartingFloor INTEGER NOT NULL,
     
        $columnStartingSimilarTableSimilarFloor INTEGER NOT NULL,
        $columnStartingSimilarTableNumberOfSegments INTEGER NOT NULL,
        $columnStartingSimilarTableSegmentNumber INTEGER NOT NULL,
        $columnstartingSimilarTableSegmentSalable INTEGER NOT NULL,
        $columnStartingSimilarTableCostPercentage REAL NOT NULL,
        $columnStartingSimilarTableCostPerMeter REAL NOT NULL,
        $columnStartingSimilarTableSellPricePercentage REAL NOT NULL,
        $columnStartingSimilarTableSellPricePerMeter REAL NOT NULL
      )
    ''');
  }


  static Future<void> _onCreatePermitFeeSegmentPricingTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tablePermitFeeSegmentPricing (
      $columnPermitFeeSegmentPricingTableId INTEGER PRIMARY KEY,
      $columnPermitFeeSegmentPricingTableProjectName TEXT NOT NULL,
      $columnPermitFeeSegmentPricingTableSegmentNumber INTEGER NOT NULL,
      $columnPermitFeeSegmentPricingTableFloorNumber INTEGER NOT NULL,
      $columnPermitFeeSegmentPricingTableFeePlanNumber INTEGER NOT NULL,
      $columnPermitFeeSegmentPricingTableSegmentArea REAL NOT NULL,
      $columnPermitFeeSegmentPricingTableSegmentFeePerMeter REAL NOT NULL,
      $columnPermitFeeSegmentPricingTableTotalSegmentFee REAL NOT NULL
    )
  ''');
  }

  static Future<void> _onCreatePermitFeeStartingSimilarTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePermitFeeStartingSimilar (
        $columnPermitFeeStartingSimilarTableId INTEGER PRIMARY KEY,
        $columnPermitFeeStartingSimilarTableProjectName TEXT NOT NULL,
        $columnPermitFeeStartingSimilarTableSegmentNumber INTEGER NOT NULL,
        $columnPermitFeeStartingSimilarTableStartingFloor INTEGER NOT NULL,
        $columnPermitFeeStartingSimilarTableSimilarFloor INTEGER NOT NULL,
        $columnPermitFeeStartingSimilarTableNumberOfSegments INTEGER NOT NULL,
        $columnPermitFeeStartingSimilarTableFeePlanNumber INTEGER NOT NULL,
        $columnPermitFeeStartingSimilarTableFeePercentage REAL NOT NULL,
        $columnPermitFeeStartingSimilarTableFeePerMeter REAL NOT NULL
      )
    ''');
  }

  static Future<void> _onCreateResultFloorTable (Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableResultFloorData (
        $columnResultFloorTableId INTEGER PRIMARY KEY,
        $columnResultFloorTableProjectName TEXT NOT NULL,
        $columnResultFloorTableCostPricePlan INTEGER NOT NULL,
        $columnResultFloorTableFloorNumber INTEGER NOT NULL,
        $columnResultFloorTableIncomeOfFloor TEXT NOT NULL,
        $columnResultFloorTableCostOfFloor TEXT NOT NULL,
        $columnResultFloorTableProfitOfFloor TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onCreateprojectResultCppData  (Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableResultCppData (
        $columnResultCppTableId INTEGER PRIMARY KEY,
        $columnResultCppTableProjectName TEXT NOT NULL,
        $columnResultCppTableCostPricePlan INTEGER NOT NULL,
        $columnResultCppTableIncomeOfCostPricePlan TEXT NOT NULL,
        $columnResultCppTableCostOfCostPricePlan TEXT NOT NULL,
        $columnResultCppTableProfitOfCostPricePlan TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onCreateResultProjectTable(Database db, int version) async {
    await db.execute('''
  CREATE TABLE $tableResultProjectData (
    $columnResultProjectTableId INTEGER PRIMARY KEY,
    $columnResultProjectTableProjectName TEXT NOT NULL,
    $columnResultProjectTableLandArea TEXT NOT NULL,
    $columnResultProjectTableTotalSalableAreaToLandArea TEXT NOT NULL,
    $columnResultProjectTableCostOfLand TEXT NOT NULL,
    $columnResultProjectTableTotalNumberOfFloorsText TEXT NOT NULL,
    $columnResultProjectTableFloorZeroConstructedArea TEXT NOT NULL,
    $columnResultProjectTableFloorZeroConstructedPercentage TEXT NOT NULL,
    $columnResultProjectTableTotalCommonArea TEXT NOT NULL,
    $columnResultProjectTableTotalSalableArea TEXT NOT NULL,
    $columnResultProjectTableAverageConstructionCostPerMeter TEXT NOT NULL,
    $columnResultProjectTableTotalConstructionCost TEXT NOT NULL,
    $columnResultProjectTableAveragePermissionCostPerMeter TEXT NOT NULL,
    $columnResultProjectTableTotalPermissionCost TEXT NOT NULL,
    $columnResultProjectTableTotalConstructedArea TEXT NOT NULL,
    $columnResultProjectTableSegmentAverageSellPricePerMeter TEXT NOT NULL,
    $columnResultProjectTableSegmentMinSellPricePerMeter TEXT NOT NULL,
    $columnResultProjectTableSegmentMaxSellPricePerMeter TEXT NOT NULL,
    $columnResultProjectTableTotalIncome TEXT NOT NULL,
    $columnResultProjectTableOtherCostsText TEXT NOT NULL,
    $columnResultProjectTableTotalCosts TEXT NOT NULL,
    $columnResultProjectTableTotalProfit TEXT NOT NULL,
    $columnResultProjectTableProfitPercentageOfProject TEXT NOT NULL,
    $columnResultProjectTableAllCostsIncurredPerMeterOfSalableArea TEXT NOT NULL,
    $columnResultProjectTableProfitPerSalableArea TEXT NOT NULL,
    $columnResultProjectTableSalableAreaConstructedPerMillionCurrencySegments TEXT NOT NULL,
    $columnResultProjectTableLandPermissionCostsPerTotalCosts TEXT NOT NULL,
    $columnResultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost TEXT NOT NULL,
    $columnResultProjectTableCalculationType TEXT NOT NULL,
    $columnResultProjectTableLandPricePerMeterToAverageSellPricePerMeter TEXT NOT NULL,
    $columnResultProjectTableRoofAndYardConstructionCostsText TEXT NOT NULL,
    $columnResultProjectTableTransactionCostsText TEXT NOT NULL,
    $columnResultProjectTableNumberOfSalableProperties TEXT NOT NULL,
    $columnResultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments TEXT NOT NULL
  )
''');
  }// $columnResultProjectTableTransactionCostBoolValue TEXT NOT NULL,
  //  $columnResultProjectTableYardConstructionCostsBoolValue TEXT NOT NULL


  static Future<void> _onCreateAddressTable (Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAddress (
        $columnAddressTableId INTEGER PRIMARY KEY,
        $columnAddressTableProjectName TEXT NOT NULL,
        $columnAddressTableEnvironmentallyFriendly REAL NOT NULL,
        $columnAddressTableSociallyFriendly REAL NOT NULL,
        $columnAddressTableProvinceName TEXT NOT NULL,
        $columnAddressTableCity TEXT NOT NULL,
        $columnAddressTableStreet TEXT NOT NULL,
        $columnAddressTableBuildingNumber TEXT NOT NULL,
        $columnAddressTablePhoneNumber TEXT NOT NULL,
        $columnAddressTableOther TEXT
      )
    ''');
  }

/*  static Future<int> insertOrUpdateProjectBasicData(ProjectBasicData projectBasicData)
  async {
    final db = await database;

    // Query to check if the project already exists based on multiple criteria
    final maps = await db.query(
      tableBasicData,
      where: '$columnProjectBasicTableProjectName = ?',
      whereArgs: [projectBasicData.projectBasicTableProjectName],
    );

    if (maps.isNotEmpty) {
      // If the project exists, update the existing record
      final id = maps.first[columnProjectBasicTableId] as int;

      await db.update(
        tableBasicData,
        projectBasicData.toMap(),
        where: '$columnProjectBasicTableProjectName = ?',
        whereArgs: [projectBasicData.projectBasicTableProjectName],
      );
      return id; // Return the ID of the updated record
    } else {
      // If the project does not exist, insert a new record
      final id = await db.insert(
        tableBasicData,
        projectBasicData.toMap(),
      );
      return id; // Return the ID of the newly inserted record
    }
  }*/

  static Future<int> insertOrUpdateProjectBasicData(
      String projectName,
      double landArea,
      double landPricePerMeter,
      int firstFloorNumber,
      int numberOfZeroRemoved,
      )
  async {
    final db = await database;

    // Check if project exists
    final existingRecords = await db.query(
      tableBasicData,
      where: '$columnProjectBasicTableProjectName = ?',
      whereArgs: [projectName],
    );

    if (existingRecords.isNotEmpty) {
      // Update existing record with new values
      await db.update(
        tableBasicData,
        {
          columnProjectBasicTableLandArea: landArea,
          columnProjectBasicTableLandPricePerMeter: landPricePerMeter,
          columnProjectBasicTableFirstFloorNumber: firstFloorNumber,
        },
        where: '$columnProjectBasicTableProjectName = ?',
        whereArgs: [projectName],
      );
      return existingRecords.first[columnProjectBasicTableId] as int;
    } else {
      // Insert new record with provided values and zeros for other columns
      final id = await db.insert(
        tableBasicData,
        {
          columnProjectBasicTableProjectName: projectName,
          columnProjectBasicTableLandArea: landArea,
          columnProjectBasicTableLandPricePerMeter: landPricePerMeter,
          columnProjectBasicTableFirstFloorNumber: firstFloorNumber,
          columnProjectBasicTableRoofAndYardConstructionCosts: 0.0,
          columnProjectBasicTableTransactionCosts: 0.0,
          columnProjectBasicTableOtherCosts: 0.0,
          columnProjectBasicTableNumberOfSalableProperties: 0.0,
          columnProjectBasicTableShortNumbersNumberOfZeroRemoved: numberOfZeroRemoved,
        },
      );
      return id;
    }
  }

  static Future<void> updateProjectBasicDataRemaining(
      String projectName,
      double roofAndYardConstructionCosts,
      double transactionCosts,
      double otherCosts,
      double numberOfSalableProperties,
      ) async {
    final db = await database;

    await db.update(
      tableBasicData,
      {
        columnProjectBasicTableRoofAndYardConstructionCosts: roofAndYardConstructionCosts,
        columnProjectBasicTableTransactionCosts: transactionCosts,
        columnProjectBasicTableOtherCosts: otherCosts,
        columnProjectBasicTableNumberOfSalableProperties: numberOfSalableProperties,
      },
      where: '$columnProjectBasicTableProjectName = ?',
      whereArgs: [projectName],
    );
  }

  static Future<int> insertOrUpdateProjectData(ProjectTableData projectData) async {
    final db = await database;
    final maps = await db.query(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ? AND'
          ' $columnCostPricingTableFloorNumber = ? AND $columnCostPricingTableSegmentNumber = ?',
      whereArgs: [projectData.costPricingTableProjectName, projectData.costPricingTableCpp,
        projectData.costPricingTableFloorNumber, projectData.costPricingTableSegmentNumber],
    );
    if (maps.isNotEmpty) {
      final id = maps.first[columnCostPricingTableProjectId] as int;
      await db.update(
        tableCostPricing,
        projectData.toMap(),
        where: '$columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ? '
            'AND $columnCostPricingTableFloorNumber = ? AND $columnCostPricingTableSegmentNumber = ?',
        whereArgs: [projectData.costPricingTableProjectName, projectData.costPricingTableCpp,
          projectData.costPricingTableFloorNumber, projectData.costPricingTableSegmentNumber],
      );
      return id;
    } else {
      final id = await db.insert(
        tableCostPricing,
        projectData.toMap(),
      );
      return id;
    }
  }



  static Future<List<ProjectBasicData>> getProjectBasicData(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableBasicData,
      where: '$columnProjectBasicTableProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return ProjectBasicData(
        projectBasicTableId: maps[i][columnProjectBasicTableId],
        projectBasicTableProjectName: maps[i][columnProjectBasicTableProjectName],
        projectBasicTableLandArea: maps[i][columnProjectBasicTableLandArea],
        projectBasicTableLandPricePerMeter: maps[i][columnProjectBasicTableLandPricePerMeter],
        projectBasicTableRoofAndYardConstructionCosts: maps[i][columnProjectBasicTableRoofAndYardConstructionCosts],
        projectBasicTableTransactionCosts: maps[i][columnProjectBasicTableTransactionCosts],
        projectBasicTableOtherCosts: maps[i][columnProjectBasicTableOtherCosts],
        projectBasicTableFirstFloorNumber: maps[i][columnProjectBasicTableFirstFloorNumber],
        projectBasicTableNumberOfSalableProperties: maps[i][columnProjectBasicTableNumberOfSalableProperties],
        projectBasicTableShortNumbersNumberOfZeroRemoved: maps[i][columnProjectBasicTableShortNumbersNumberOfZeroRemoved],
      );
    });
  }


  static Future<List<ProjectTableData>> getCostPricingData(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return ProjectTableData(
        costPricingTableProjectId: maps[i][columnCostPricingTableProjectId],
        costPricingTableProjectName: maps[i][columnCostPricingTableProjectName],
        costPricingTableCpp: maps[i][columnCostPricingTableCpp],
        costPricingTableFloorNumber: maps[i][columnCostPricingTableFloorNumber],
        costPricingTableSegmentNumber: maps[i][columnCostPricingTableSegmentNumber],
        costPricingTableSegmentArea: maps[i][columnCostPricingTableSegmentArea],
        costPricingTableSegmentCostPerMeter: maps[i][columnCostPricingTableSegmentCostPerMeter],
        costPricingTableSegmentSellPricePerMeter: maps[i][columnCostPricingTableSegmentSellPricePerMeter],
        costPricingTableIncomeOfSegment: maps[i][columnCostPricingTableIncomeOfSegment],
        costPricingTableCostOfSegment: maps[i][columnCostPricingTableCostOfSegment],
        costPricingTableProfitOfSegment: maps[i][columnCostPricingTableProfitOfSegment],
        costPricingTableIndex3: maps[i][columnCostPricingTableIndex3],
      );
    });
  }
  /* static Future<List<ProjectTableData>> getCostPricingData(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return ProjectTableData(
        id: maps[i][columnCostPricingTableProjectId],
        projectName: maps[i][columnCostPricingTableProjectName],
        cpp: maps[i][columnCostPricingTableCpp],
        floor: maps[i][columnCostPricingTableProjectName],
        segment: maps[i][columnCostPricingTableSegmentNumber],
        segmentArea: maps[i][columnCostPricingTableSegmentArea],
        segmentCost: maps[i][columnCostPricingTableSegmentCostPerMeter],
        segmentPrice: maps[i][columnCostPricingTableSegmentSellPricePerMeter],
        incomeOfSegment: maps[i][columnCostPricingTableIncomeOfSegment],
        costOfSegment: maps[i][columnCostPricingTableCostOfSegment],
        profitOfSegment: maps[i][columnCostPricingTableProfitOfSegment],
        index3: maps[i][columnCostPricingTableIndex3],
      );
    });
  }
*/

  static Future<int> getNextProjectBasicId() async {
    final dbProject = await database;
    final List<Map<String, dynamic>> maps = await dbProject.rawQuery(
        'SELECT MAX($columnProjectBasicTableId) + 1 as nextId FROM $tableBasicData'
    );
    return maps.first['nextId'] ?? 1; // Return 1 if no ID exists
  }

  static Future<int> getNextProjectId() async {
    final dbProject = await database;
    final List<Map<String, dynamic>> maps =
    await dbProject.rawQuery('SELECT MAX($columnCostPricingTableProjectId) + 1 as nextId FROM $tableCostPricing');
    return maps.first['nextId'] ?? 1;
  }

  static Future<Map<String, int?>> getMaxFloorCppByProject(project_) async {
    final db = await database;
    final result = await db.query(
      tableCostPricing,
      columns: ['MAX($columnCostPricingTableFloorNumber) AS maxFloor',
        'MAX($columnCostPricingTableCpp) AS maxCpp'],
      where: '$columnCostPricingTableProjectName = ?',
      whereArgs: [project_],
    );

    final maxValues = {
      'maxFloor': int.tryParse(result.first['maxFloor'].toString()),
      'maxCpp': int.tryParse(result.first['maxCpp'].toString()),
    };
    return maxValues;
  }

  static Future<void> deleteRowByCondition(String tableName, String columnName, dynamic value) async {
    final db = await database;
    await db.delete(tableName, where: '$columnName = ?', whereArgs: [value]);
  }

  static Future<List<ProjectTableData>> getCostPricingDataByCpp(String projectName, int ccpValue) async {

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ?',
      whereArgs: [projectName, ccpValue],
    );

    return List.generate(maps.length, (i) {
      return ProjectTableData(
        costPricingTableProjectId: maps[i][columnCostPricingTableProjectId],
        costPricingTableProjectName: maps[i][columnCostPricingTableProjectName],
        costPricingTableCpp: maps[i][columnCostPricingTableCpp],
        costPricingTableFloorNumber: maps[i][columnCostPricingTableFloorNumber],
        costPricingTableSegmentNumber: maps[i][columnCostPricingTableSegmentNumber],
        costPricingTableSegmentArea: maps[i][columnCostPricingTableSegmentArea],
        costPricingTableSegmentCostPerMeter: maps[i][columnCostPricingTableSegmentCostPerMeter],
        costPricingTableSegmentSellPricePerMeter: maps[i][columnCostPricingTableSegmentSellPricePerMeter],
        costPricingTableIncomeOfSegment: maps[i][columnCostPricingTableIncomeOfSegment],
        costPricingTableCostOfSegment: maps[i][columnCostPricingTableCostOfSegment],
        costPricingTableProfitOfSegment: maps[i][columnCostPricingTableProfitOfSegment],
        costPricingTableIndex3: maps[i][columnCostPricingTableIndex3],
      );
    });
  }

  static Future<Set<int>> uniqueFloorListByProjectNameAndCpp(String projectName, int cpp) async {
    final Database db = await database;
    final Set<int> floors = {};
    final List<Map<String, dynamic>> maps = await db.query(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ?',
      whereArgs: [projectName, cpp],
    );

    for (var map in maps) {
      final floorValue = map[columnCostPricingTableFloorNumber];
      if (!floors.contains(floorValue)) {
        floors.add(floorValue);
      }

    }
    return floors;
  }

  static Future<int> getNextProjectStartingSimilarID() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnStartingSimilarTableId) + '
        '1 as $columnStartingSimilarTableId FROM $tableStartingSimilar');
    int nextID = maps.first[columnStartingSimilarTableId] ?? 1;
    return nextID;
  }

  static Future<int> insertProjectStartingSimilarData(ProjectStartingSimilarTableData projectData) async {
    final db = await database;
    int id = await db.insert(tableStartingSimilar, projectData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> insertOrUpdateProjectStartingSimilarPercentageData(
      ProjectStartingSimilarTableData data) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ? '
          ' AND $columnStartingSimilarTableSegmentNumber = ?',// SegmentNumber is necessary
      whereArgs: [data.startingSimilarTableProjectName, data.startingSimilarTableCpp,
         data.startingSimilarTableSegmentNumber],
    );
    if (maps.isNotEmpty) {
      int id = maps[0][columnStartingSimilarTableId];
      await db.update(
        tableStartingSimilar,
        data.toMap(),
        where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?'
            ' AND $columnStartingSimilarTableSegmentNumber = ?',
        whereArgs: [data.startingSimilarTableProjectName, data.startingSimilarTableCpp,
           data.startingSimilarTableSegmentNumber],
      );
      return id;
    } else {
      int id = await db.insert(
        tableStartingSimilar,
        data.toMap(),
      );
      return id;
    }
  }


  // for saving_updating cost & price
/*
  static Future<int> updateProjectStartingSimilarData(String projectName, int cpp, int floor, int segmentNumber1,
      int similarFloor, int startingFloor, int numberOfSegments, double costPercent, double costPerMeter,
      double sellPercent, double sellPerMeter)
  async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?'
          ' AND $columnStartingSimilarTableFloorNumber = ? AND $columnStartingSimilarTableSegmentNumber = ?',
      whereArgs: [projectName, cpp ,floor,segmentNumber1],
    );
    if (maps.isNotEmpty) {
      int id = maps[0][columnStartingSimilarTableId];
      await db.update(
        tableStartingSimilar,
        {
          columnStartingSimilarTableCostPercentage: costPercent,
          columnStartingSimilarTableCostPerMeter: costPerMeter,
          columnStartingSimilarTableSellPricePercentage: sellPercent,
          columnStartingSimilarTableSellPricePerMeter: sellPerMeter,
        },
        where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?'
            ' AND $columnStartingSimilarTableFloorNumber = ? AND $columnStartingSimilarTableSegmentNumber = ?',
        whereArgs: [projectName,  cpp ,floor,segmentNumber1],
      );
      return id;
    } else {
      Map<String, dynamic> row = {
        columnStartingSimilarTableProjectName: projectName,
        columnStartingSimilarTableCpp: cpp,
        columnStartingSimilarTableFloorNumber: floor,
        columnStartingSimilarTableSegmentNumber: segmentNumber1,
        columnStartingSimilarTableNumberOfSegments: numberOfSegments,
        columnStartingSimilarTableSimilarFloor: similarFloor,
        columnStartingSimilarTableStartingFloor: startingFloor,
        columnStartingSimilarTableCostPercentage: costPercent,
        columnStartingSimilarTableCostPerMeter: costPerMeter,
        columnStartingSimilarTableSellPricePercentage: sellPercent,
        columnStartingSimilarTableSellPricePerMeter: sellPerMeter,
      };
      int id = await db.insert(
        tableStartingSimilar,
        row,
      );
      return id;
    }
  }
*/


  static Future<ProjectStartingSimilarTableData?> getStartingSimilarTableSegmentData(
      String projectName,
      int ccpValue, int segmentNumber)
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND '
          '$columnStartingSimilarTableCpp = ? AND $columnStartingSimilarTableSegmentNumber = ?',
      whereArgs: [projectName, ccpValue, segmentNumber],
    );

    if (maps.isNotEmpty) {
      return ProjectStartingSimilarTableData(
        startingSimilarTableId: maps[0][columnStartingSimilarTableId],
        startingSimilarTableProjectName: maps[0][columnStartingSimilarTableProjectName],
        startingSimilarTableCpp: maps[0][columnStartingSimilarTableCpp],
        startingSimilarTableStartingFloor: maps[0][columnStartingSimilarTableStartingFloor],
        startingSimilarTableSimilarFloor: maps[0][columnStartingSimilarTableSimilarFloor],
    //    startingSimilarTableFloorNumber: maps[0][columnStartingSimilarTableFloorNumber],
        startingSimilarTableNumberOfSegments: maps[0][columnStartingSimilarTableNumberOfSegments],
        startingSimilarTableSegmentNumber: maps[0][columnStartingSimilarTableSegmentNumber],
        startingSimilarTableCostPercentage: maps[0][columnStartingSimilarTableCostPercentage],
        startingSimilarTableCostPerMeter: maps[0][columnStartingSimilarTableCostPerMeter],
        startingSimilarTableSellPricePercentage: maps[0][columnStartingSimilarTableSellPricePercentage],
        startingSimilarTableSellPricePerMeter: maps[0][columnStartingSimilarTableSellPricePerMeter],
        startingSimilarTableSegmentSalable: maps[0][columnstartingSimilarTableSegmentSalable],
      );
    } else {
      return null;
    }
  }

  static Future<List<ProjectStartingSimilarTableData>> getStartingSimilarTableSegments(
      String projectName, int cppValue)
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?',
      whereArgs: [projectName, cppValue],
    );

    return List.generate(maps.length, (i) {
      return ProjectStartingSimilarTableData(
        startingSimilarTableId: maps[i][columnStartingSimilarTableId],
        startingSimilarTableProjectName: maps[i][columnStartingSimilarTableProjectName],
        startingSimilarTableCpp: maps[i][columnStartingSimilarTableCpp],
        startingSimilarTableStartingFloor: maps[i][columnStartingSimilarTableStartingFloor],
        startingSimilarTableSimilarFloor: maps[i][columnStartingSimilarTableSimilarFloor],
        startingSimilarTableNumberOfSegments: maps[i][columnStartingSimilarTableNumberOfSegments],
        startingSimilarTableSegmentNumber: maps[i][columnStartingSimilarTableSegmentNumber],
        startingSimilarTableCostPercentage: maps[i][columnStartingSimilarTableCostPercentage],
        startingSimilarTableCostPerMeter: maps[i][columnStartingSimilarTableCostPerMeter],
        startingSimilarTableSellPricePercentage: maps[i][columnStartingSimilarTableSellPricePercentage],
        startingSimilarTableSellPricePerMeter: maps[i][columnStartingSimilarTableSellPricePerMeter],
        startingSimilarTableSegmentSalable: maps[i][columnstartingSimilarTableSegmentSalable],
      );
    });
  }


  // Modified insertOrUpdatePermi tFeeSegmentPricingData method
  static Future<int> insertOrUpdatePermitFeeSegmentPricingData(
      PermitFeeSegmentPricingData permitFeeSegmentPricingData) async {
    final db = await database;
    final maps = await db.query(
      tablePermitFeeSegmentPricing,
      where: '$columnPermitFeeSegmentPricingTableProjectName = ? AND $columnPermitFeeSegmentPricingTableSegmentNumber = ? '
          'AND $columnPermitFeeSegmentPricingTableFloorNumber = ? '
          'AND $columnPermitFeeSegmentPricingTableFeePlanNumber = ?',
      whereArgs: [permitFeeSegmentPricingData.permitFeeSegmentPricingTableProjectName,
        permitFeeSegmentPricingData.permitFeeSegmentPricingTableSegmentNumber,
        permitFeeSegmentPricingData.permitFeeSegmentPricingTableFloorNumber,
        permitFeeSegmentPricingData.permitFeeSegmentPricingTableFeePlanNumber],
      // these columns are defined in class
    );
    if (maps.isNotEmpty) {
      final id = maps.first[columnPermitFeeSegmentPricingTableId] as int;
      await db.update(
        tablePermitFeeSegmentPricing,
        permitFeeSegmentPricingData.toMap(),
        where: '$columnPermitFeeSegmentPricingTableProjectName = ? AND $columnPermitFeeSegmentPricingTableSegmentNumber = ? AND'
            ' $columnPermitFeeSegmentPricingTableFloorNumber = ? '
            'AND $columnPermitFeeSegmentPricingTableFeePlanNumber = ?',
        whereArgs: [permitFeeSegmentPricingData.permitFeeSegmentPricingTableProjectName,
          permitFeeSegmentPricingData.permitFeeSegmentPricingTableSegmentNumber,
          permitFeeSegmentPricingData.permitFeeSegmentPricingTableFloorNumber,
          permitFeeSegmentPricingData.permitFeeSegmentPricingTableFeePlanNumber],
      );
      return id;
    } else {
      final id = await db.insert(
        tablePermitFeeSegmentPricing,
        permitFeeSegmentPricingData.toMap(),
      );
      return id;
    }
  }

  Future<List<Map<String, dynamic>>> calculatePermitFeeForEachFloor(String projectName) async {
    List<Map<String, dynamic>> floorPermitFees = [];
    List<PermitFeeSegmentPricingData> permitFeeData = await CompleteCalculationDatabaseHelper.getPermitFeeSegmentPricingData(projectName);
    Map<int, double> floorPermitFeesMap = {};

    for (var data in permitFeeData) {
      int floorNumber = data.permitFeeSegmentPricingTableFloorNumber;
      double segmentPermitFee = data.permitFeeSegmentPricingTableTotalSegmentPermitFee;

      floorPermitFeesMap[floorNumber] = (floorPermitFeesMap[floorNumber] ?? 0) + segmentPermitFee;
    }

    floorPermitFeesMap.forEach((floorNumber, permitFee) {
      floorPermitFees.add({'floorNumber': floorNumber, 'permitFee': permitFee});
    });

    return floorPermitFees;
  }

  static Future<List<String>> getAllProjectNames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        tableCostPricing,
        columns: [columnCostPricingTableProjectName]);
    List<String> projectNames = List.generate(maps.length, (i) {
      return maps[i][columnCostPricingTableProjectName] as String;
    });
    return projectNames;
  }

  static Future<int> getNextAddressProjectID() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnAddressTableId) '
        '+ 1 as $columnAddressTableId FROM $tableAddress');
    int nextID = maps.first[columnAddressTableId] ?? 1;
    return nextID;
  }

  static Future<int> insertOrUpdateAddressProjectData(ProjectAddressData data) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableAddress,
      where: '$columnAddressTableProjectName = ?',
      whereArgs: [data.addressTableProjectName],
    );
    if (maps.isNotEmpty) {
      int id = maps[0][columnAddressTableId];
      await db.update(
        tableAddress,
        data.toMap(),
        where: '$columnAddressTableProjectName = ?',
        whereArgs: [data.addressTableProjectName],
      );
      return id;
    } else {
      int id = await db.insert(
        tableAddress,
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    }
  }

  static Future<List<ProjectStartingSimilarTableData>> getAllProjectStartingSimilarData(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableStartingSimilar,
        where: '$columnStartingSimilarTableProjectName = ?',
        whereArgs: [projectName]);
    return List.generate(maps.length, (i) {
      return ProjectStartingSimilarTableData(
        startingSimilarTableId: maps[0][columnStartingSimilarTableId],
        startingSimilarTableProjectName: maps[0][columnStartingSimilarTableProjectName],
        startingSimilarTableCpp: maps[0][columnStartingSimilarTableCpp],
        startingSimilarTableStartingFloor: maps[0][columnStartingSimilarTableStartingFloor],
        startingSimilarTableSimilarFloor: maps[0][columnStartingSimilarTableSimilarFloor],
        startingSimilarTableNumberOfSegments: maps[0][columnStartingSimilarTableNumberOfSegments],
        startingSimilarTableSegmentNumber: maps[0][columnStartingSimilarTableSegmentNumber],
        startingSimilarTableCostPercentage: maps[0][columnStartingSimilarTableCostPercentage],
        startingSimilarTableCostPerMeter: maps[0][columnStartingSimilarTableCostPerMeter],
        startingSimilarTableSellPricePercentage: maps[0][columnStartingSimilarTableSellPricePercentage],
        startingSimilarTableSellPricePerMeter: maps[0][columnStartingSimilarTableSellPricePerMeter],
        startingSimilarTableSegmentSalable: maps[0][columnstartingSimilarTableSegmentSalable],

      );
    });
  }



  static Future<List<Map<String, dynamic>>> fetchProjectStartingSimilarData(String projectName,
      int cppValue, int startingFloor)
  async {
    List<Map<String, dynamic>> data = [];
    final db = await database;
    final List<dynamic> result = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND '
          '$columnStartingSimilarTableCpp = ? AND $columnStartingSimilarTableStartingFloor = ?',
      whereArgs: [projectName, cppValue, startingFloor],
    );

    for (Map<String, dynamic> row in result) {
      data.add(row);
    }
    return data;
  }



  static Future<double?> getCostPercentage(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableStartingSimilar,
        columns: [columnStartingSimilarTableCostPercentage],
        where: '$columnStartingSimilarTableProjectName = ?',
        whereArgs: [projectName]);
    if (maps.isNotEmpty) {
      return maps[0][columnStartingSimilarTableCostPercentage];
    } else {
      return null;
    }
  }


// Get all rows from the result floor table
  static Future<List<ProjectResultFloorData>> getProjectResultFloorData(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableResultFloorData,
      where: '$columnResultFloorTableProjectName = ?',
      whereArgs: [projectName],
    );
    return List.generate(maps.length, (i) {
      return ProjectResultFloorData(
        resultFloorTableId: maps[i][columnResultFloorTableId],
        resultFloorTableProjectName: maps[i][columnResultFloorTableProjectName],
        resultFloorTableCostPricePlan: maps[i][columnResultFloorTableCostPricePlan],
        resultFloorTableFloorNumber: maps[i][columnResultFloorTableFloorNumber],
        resultFloorTableIncomeOfFloor: maps[i][columnResultFloorTableIncomeOfFloor],
        resultFloorTableCostOfFloor: maps[i][columnResultFloorTableCostOfFloor],
        resultFloorTableProfitOfFloor: maps[i][columnResultFloorTableProfitOfFloor],
      );
    });
  }



  static Future<List<projectResultCppData>> getProjectResultCppData(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableResultCppData,
      where: '$columnResultCppTableProjectName = ?',
      whereArgs: [projectName],
    );
    return List.generate(maps.length, (i) {
      return projectResultCppData(
        resultCppTableId: maps[i][columnResultCppTableId],
        resultCppTableProjectName: maps[i][columnResultCppTableProjectName],
        resultCppTableCostPricePlan: maps[i][columnResultCppTableCostPricePlan],
        resultCppTableIncomeOfCostPricePlan: maps[i][columnResultCppTableIncomeOfCostPricePlan],
        resultCppTableCostOfCostPricePlan: maps[i][columnResultCppTableCostOfCostPricePlan],
        resultCppTableProfitOfCostPricePlan: maps[i][columnResultCppTableProfitOfCostPricePlan],
      );
    });
  }

// Get all rows from the result project table for using in allprojectpage, so no project name is required
  static Future<List<ResultProjectColumnsClassData>> getResultProjectColumnsClassData(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableResultProjectData,
      where: '$columnResultProjectTableProjectName = ?',
      whereArgs: [projectName],
    );
    return List.generate(maps.length, (i) {
      return ResultProjectColumnsClassData(
        resultProjectTableId: maps[i][columnResultProjectTableId] ?? 0,
        resultProjectTableProjectName: maps[i][columnResultProjectTableProjectName] ?? '',
        resultProjectTableLandArea: maps[i][columnResultProjectTableLandArea] ?? 0.0,
        resultProjectTableCostOfLand: maps[i][columnResultProjectTableCostOfLand] ?? 0.0,
        resultProjectTableTotalNumberOfFloorsText: maps[i][columnResultProjectTableTotalNumberOfFloorsText] ?? 0.0,
        resultProjectTableFloorZeroConstructedArea: maps[i][columnResultProjectTableFloorZeroConstructedArea] ?? 0.0,
        resultProjectTableFloorZeroConstructedPercentage: maps[i][columnResultProjectTableFloorZeroConstructedPercentage] ?? 0.0,
        resultProjectTableTotalCommonArea: maps[i][columnResultProjectTableTotalCommonArea] ?? 0.0,
        resultProjectTableTotalSalableArea: maps[i][columnResultProjectTableTotalSalableArea] ?? 0.0,
        resultProjectTableAverageConstructionCostPerMeter: maps[i][columnResultProjectTableAverageConstructionCostPerMeter] ?? 0.0,
        resultProjectTableTotalConstructionCost: maps[i][columnResultProjectTableTotalConstructionCost] ?? 0.0,
        resultProjectTableAveragePermissionCostPerMeter: maps[i][columnResultProjectTableAveragePermissionCostPerMeter] ?? 0.0,
        resultProjectTableTotalPermissionCost: maps[i][columnResultProjectTableTotalPermissionCost] ?? 0.0,
        resultProjectTableTotalConstructedArea: maps[i][columnResultProjectTableTotalConstructedArea] ?? 0.0,
        resultProjectTableSegmentAverageSellPricePerMeter: maps[i][columnResultProjectTableSegmentAverageSellPricePerMeter] ?? 0.0,
        resultProjectTableSegmentMinSellPricePerMeter: maps[i][columnResultProjectTableSegmentMinSellPricePerMeter] ?? 0.0,
        resultProjectTableSegmentMaxSellPricePerMeter: maps[i][columnResultProjectTableSegmentMaxSellPricePerMeter] ?? 0.0,
        resultProjectTableTotalIncome: maps[i][columnResultProjectTableTotalIncome] ?? 0.0,
        resultProjectTableTotalCosts: maps[i][columnResultProjectTableTotalCosts] ?? 0.0,
        resultProjectTableTotalProfit: maps[i][columnResultProjectTableTotalProfit] ?? 0.0,
        resultProjectTableProfitPercentageOfProject: maps[i][columnResultProjectTableProfitPercentageOfProject] ?? 0.0,
        resultProjectTableAllCostsIncurredPerMeterOfSalableArea: maps[i][columnResultProjectTableAllCostsIncurredPerMeterOfSalableArea] ?? 0.0,
        resultProjectTableProfitPerSalableArea: maps[i][columnResultProjectTableProfitPerSalableArea] ?? 0.0,
        resultProjectTableSalableAreaConstructedPerMillionCurrencySegments: maps[i][columnResultProjectTableSalableAreaConstructedPerMillionCurrencySegments] ?? 0.0,
        resultProjectTableNumberOfSalableProperties: maps[i][columnResultProjectTableNumberOfSalableProperties] ?? 0.0,
        resultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments: maps[i][columnResultProjectTableNumberOfSalablePropertiesPerMillionCurrencySegments] ?? 0.0,
        resultProjectTableCalculationType: maps[i][columnResultProjectTableCalculationType] ?? '',
        resultProjectTableLandPermissionCostsPerTotalCosts: maps[i][columnResultProjectTableLandPermissionCostsPerTotalCosts] ?? 0,
        resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost: maps[i][columnResultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermissionCost] ?? 0,
        resultProjectTableLandPricePerMeterToAverageSellPricePerMeter: maps[i][columnResultProjectTableLandPricePerMeterToAverageSellPricePerMeter] ?? 0,
        resultProjectTableTotalSalableAreaToLandArea: maps[i][columnResultProjectTableTotalSalableAreaToLandArea] ?? 0,
        resultProjectTableRoofAndYardConstructionCostsText: maps[i][columnResultProjectTableRoofAndYardConstructionCostsText] ?? 0,
        resultProjectTableTransactionCostsText: maps[i][columnResultProjectTableTransactionCostsText] ?? 0,
        resultProjectTableOtherCostsText: maps[i][columnResultProjectTableOtherCostsText] ?? 0,

      );
    });
  }



  static Future<void> insertOrUpdateProjectResultCppData(String projectName,
      int cpp, String costOfCpp, String incomeOfCpp,
      String profitOfCpp)
  async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableResultCppData,
      where: '$columnResultCppTableProjectName = ? AND $columnResultCppTableCostPricePlan = ?',
      whereArgs: [projectName, cpp],
    );
    if (maps.isNotEmpty) {
      await db.update(
        tableResultCppData,
        {
          columnResultCppTableCostOfCostPricePlan: costOfCpp,
          columnResultCppTableIncomeOfCostPricePlan: incomeOfCpp,
          columnResultCppTableProfitOfCostPricePlan: profitOfCpp,
        },
        where: '$columnResultCppTableProjectName = ? AND $columnResultCppTableCostPricePlan = ?',
        whereArgs: [projectName, cpp],
      );
    } else {
      await db.insert(
        tableResultCppData,
        {
          columnResultCppTableProjectName: projectName,
          columnResultCppTableCostPricePlan: cpp,
          columnResultCppTableCostOfCostPricePlan: costOfCpp,
          columnResultCppTableIncomeOfCostPricePlan: incomeOfCpp,
          columnResultCppTableProfitOfCostPricePlan: profitOfCpp,
        },
      );
    }
  }

  static Future<void> insertOrUpdateProjectResultFloorData(String projectName,
      int cpp, int floorNumber, String costOfFloor, String incomeOfFloor, String profitOfFloor)
  async {
    Database db = await CompleteCalculationDatabaseHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableResultFloorData,
      where: '$columnResultFloorTableProjectName = ? AND $columnResultFloorTableCostPricePlan = ? '
          'AND $columnResultFloorTableFloorNumber = ?',
      whereArgs: [projectName, cpp, floorNumber],
    );
    if (maps.isNotEmpty) {
      await db.update(
        tableResultFloorData,
        {
          columnResultFloorTableCostOfFloor: costOfFloor,
          columnResultFloorTableIncomeOfFloor: incomeOfFloor,
          columnResultFloorTableProfitOfFloor: profitOfFloor,
        },
        where: '$columnResultFloorTableProjectName = ? AND $columnResultFloorTableCostPricePlan = ? AND '
            '$columnResultFloorTableFloorNumber = ?',
        whereArgs: [projectName, cpp, floorNumber],
      );
    } else {
      await db.insert(
        tableResultFloorData,
        {
          columnResultFloorTableProjectName: projectName,
          columnResultFloorTableCostPricePlan: cpp,
          columnResultFloorTableFloorNumber: floorNumber,
          columnResultFloorTableCostOfFloor: costOfFloor,
          columnResultFloorTableIncomeOfFloor: incomeOfFloor,
          columnResultFloorTableProfitOfFloor: profitOfFloor,
        },
      );
    }
  }

  static Future<void> insertOrUpdateResultProjectData(ResultProjectColumnsClassData data) async {
    Database db = await CompleteCalculationDatabaseHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableResultProjectData,
      where: '$columnResultProjectTableProjectName = ?',
      whereArgs: [data.resultProjectTableProjectName],
    );
    if (maps.isNotEmpty) {
      await db.update(
        tableResultProjectData,
        data.toMap(),
        where: '$columnResultProjectTableProjectName = ?',
        whereArgs: [data.resultProjectTableProjectName],
      );
    } else {
      await db.insert(
        tableResultProjectData,
        data.toMap(),
      );
    }
  }


  static Future<Map<String, int?>> getMaxFloorCppByProjectStartingSimilar(String projectName)
  async {
    final db = await database;
    final result = await db.query(
      tableStartingSimilar,
      columns: ['MAX($columnStartingSimilarTableStartingFloor) AS maxStartingFloor',
        'MAX($columnStartingSimilarTableSimilarFloor) AS maxSimilarFloor'],
      where: '$columnStartingSimilarTableProjectName = ?', 
      whereArgs: [projectName],
    );

    final maxValues = {
      'maxStartingFloor': int.tryParse(result.first['maxStartingFloor'].toString()),
      'maxSimilarFloor': int.tryParse(result.first['maxSimilarFloor'].toString()),
    };
    return maxValues;
  }


  static Future<Map<String, int>?> getStartingAndSimilarFloor(String projectName, int cpp) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,

      where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?',
      whereArgs: [projectName, cpp],
      //   limit: 1,
    );

    if (maps.isNotEmpty) {
      final Map<String, int> floorValues = {
        'startingFloor': maps[0][columnStartingSimilarTableStartingFloor],
        'similarFloor': maps[0][columnStartingSimilarTableSimilarFloor],
      };
      return floorValues;
    }
    return null;
  }


  static Future<void> deleteProjectOfCompleteCalculationDatabase(String projectName) async {
    final db = await database;
    // Define a list of tables and their corresponding project name columns
    final tablesToDelete = [
      { 'tableName': tableBasicData, // Reference to the constant for the table name
        'projectNameColumn': columnProjectBasicTableProjectName, // Reference to the constant for the project name column
      },
      {
        'tableName': tableCostPricing,
        'projectNameColumn': columnCostPricingTableProjectName,
      },
      {
        'tableName': tableStartingSimilar,
        'projectNameColumn': columnStartingSimilarTableProjectName,
      },
      {
        'tableName': tablePermitFeeSegmentPricing,
        'projectNameColumn': columnPermitFeeSegmentPricingTableProjectName,
      },
      {
        'tableName': tablePermitFeeStartingSimilar,
        'projectNameColumn': columnPermitFeeStartingSimilarTableProjectName,
      },
      {
        'tableName': tableResultFloorData,
        'projectNameColumn': columnResultFloorTableProjectName,
      },
      {
        'tableName': tableResultCppData,
        'projectNameColumn': columnResultCppTableProjectName,
      },
      {
        'tableName': tableResultProjectData,
        'projectNameColumn': columnResultProjectTableProjectName,
      },
      {
        'tableName': tableAddress,
        'projectNameColumn': columnAddressTableProjectName,
      },
    ];

    // Delete the project from each table
    for (final table in tablesToDelete) {
      await db.delete(
        table['tableName']!,
        where: '${table['projectNameColumn']} = ?',
        whereArgs: [projectName],
      );
    }
  }


  static Future<void> deleteCpp(String projectName, int cpp) async {
    final db = await database;

    // Get the list of floors for the CPP to be deleted (for deduction logic)
    final removedFloors = await uniqueFloorListByProjectNameAndCpp(projectName, cpp);
    final removedFloorsLength = removedFloors.length;

    // Delete all rows related to the given CPP
    await db.delete(
      tableCostPricing,
      where: '$columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ?',
      whereArgs: [projectName, cpp],
    );
    await db.delete(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?',
      whereArgs: [projectName, cpp],
    );
    await db.delete(
      tableResultFloorData,
      where: '$columnResultFloorTableProjectName = ? AND $columnResultFloorTableCostPricePlan = ?',
      whereArgs: [projectName, cpp],
    );
    await db.delete(
      tableResultCppData,
      where: '$columnResultCppTableProjectName = ? AND $columnResultCppTableCostPricePlan = ?',
      whereArgs: [projectName, cpp],
    );

    // Find the maximum floor number among the removed floors (for deduction logic)
    int maxFloorNumberDeleted = 0;
    for (int floorNumber in removedFloors) {
      if (floorNumber > maxFloorNumberDeleted) {
        maxFloorNumberDeleted = floorNumber;
      }
    }

    // Check if there are any CPPs greater than the one deleted
    final List<int> biggerCpps = await getBiggerCppsThanGivenCpp(db, projectName, cpp);

    // Only deduct/renumber if there are bigger CPPs
    if (biggerCpps.isNotEmpty) {
      await deductFloorNumbers(projectName, cpp, removedFloorsLength, maxFloorNumberDeleted);
    }
  }


  static Future<List<int>> getBiggerCppsThanGivenCpp(Database db, String projectName, int cpp)
  async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT DISTINCT $columnCostPricingTableCpp FROM $tableCostPricing 
    WHERE $columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp > ?
    ''',
      [projectName, cpp],
    );
    return result.map((e) => e[columnCostPricingTableCpp] as int).toList();
  }


  static Future<void> deductFloorNumbers(String projectName, int cpp,
      int removedFloorsLength,  int maxFloorNumberDeleted) async
  {
    final Database db = await database;

    final List<int> bigCpps = 
      await getBiggerCppsThanGivenCpp(db, projectName, cpp);
    // deductions for tableStartingSimilar
    for (int bigCpp in bigCpps)
      {

      await db.rawUpdate(
        '''
      UPDATE $tableCostPricing
      SET $columnCostPricingTableFloorNumber = $columnCostPricingTableFloorNumber - ?
      WHERE $columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp = ?
      ''',
        [removedFloorsLength, projectName, bigCpp],
      );


      await db.rawUpdate(
        '''
      UPDATE $tableStartingSimilar
      SET $columnStartingSimilarTableStartingFloor = $columnStartingSimilarTableStartingFloor - ?
      WHERE $columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp = ?
      ''',
        [removedFloorsLength, projectName, bigCpp],
      );

      await db.rawUpdate(
        '''
      UPDATE $tableResultFloorData
      SET $columnResultFloorTableFloorNumber = $columnResultFloorTableFloorNumber - ?
      WHERE $columnResultFloorTableProjectName = ? AND $columnResultFloorTableCostPricePlan = ?
      ''',
        [removedFloorsLength, projectName, bigCpp],
      );
    }


// permit fea tables has no cpp column To delete it directly but can be recognized
// in and user should re enter all permit fees again

    // Deduct 1 from all cpp values bigger than the current cpp value
    await db.rawUpdate(
      '''
    UPDATE $tableCostPricing
    SET $columnCostPricingTableCpp = $columnCostPricingTableCpp - 1
    WHERE $columnCostPricingTableProjectName = ? AND $columnCostPricingTableCpp > ?
    ''',
      [projectName, cpp],
    );

    await db.rawUpdate(
      '''
    UPDATE $tableStartingSimilar
    SET $columnStartingSimilarTableCpp = $columnStartingSimilarTableCpp - 1
    WHERE $columnStartingSimilarTableProjectName = ? AND $columnStartingSimilarTableCpp > ?
    ''',
      [projectName, cpp],
    );

    await db.rawUpdate(
      '''
      UPDATE $tableResultCppData
      SET $columnResultCppTableCostPricePlan = $columnResultCppTableCostPricePlan - 1
      WHERE $columnResultCppTableProjectName = ? AND $columnResultCppTableCostPricePlan > ?
      ''',
      [projectName, cpp],
    );

    await db.rawUpdate(
      '''
      UPDATE $tableResultFloorData
      SET $columnResultFloorTableCostPricePlan = $columnResultFloorTableCostPricePlan - 1
      WHERE $columnResultFloorTableProjectName = ? AND $columnResultFloorTableCostPricePlan > ?
      ''',
      [projectName, cpp],
    );
  }


  static Future<void> deletePermitFeePlan(String projectName, int feePlan) async {
    final db = await database;

    // Delete from tablePermitFeeSegmentPricing
    await db.delete(tablePermitFeeSegmentPricing,
        where: '$columnPermitFeeSegmentPricingTableProjectName = ? '
        'AND $columnPermitFeeSegmentPricingTableFeePlanNumber = ?',
        whereArgs: [projectName, feePlan]);

    // Delete from tablePermitFeeStartingSimilar
    await db.delete(tablePermitFeeStartingSimilar,
        where: '$columnPermitFeeStartingSimilarTableProjectName = ? '
        'AND $columnPermitFeeStartingSimilarTableFeePlanNumber = ?',
        whereArgs: [projectName, feePlan]);

  }

  static Future<void> deletePermitFeeDataByProjectName(String projectName) async {
    final db = await database;

    // Delete all rows from tablePermitFeeSegmentPricing for the given project name
    await db.delete(tablePermitFeeSegmentPricing,
        where: '$columnPermitFeeSegmentPricingTableProjectName = ?', whereArgs: [projectName]);

    // Delete all rows from tablePermitFeeStartingSimilar for the given project name
    await db.delete(tablePermitFeeStartingSimilar,
        where: '$columnPermitFeeStartingSimilarTableProjectName = ?', whereArgs: [projectName]);
  }



  static Future<void> updateProjectNameInAllTables(String newProjectName, String oldProjectName)
  async {
    final db = await database;
    // Update project name in ProjectTableData
    await db.rawUpdate('UPDATE $tableCostPricing SET '
        '$columnCostPricingTableProjectName = ? WHERE $columnCostPricingTableProjectName = ?',
        [newProjectName, oldProjectName]);

    // Update project name in ProjectStartingSimilarTableData
    await db.rawUpdate('UPDATE $tableStartingSimilar SET $columnStartingSimilarTableProjectName = ? WHERE '
        '$columnStartingSimilarTableProjectName = ?', [newProjectName, oldProjectName]);

    // Update project name in table permitFeeSegmentPricing
    await db.rawUpdate(
      'UPDATE $tablePermitFeeSegmentPricing SET $columnPermitFeeSegmentPricingTableProjectName = ? WHERE'
          ' $columnPermitFeeSegmentPricingTableProjectName = ?',
      [newProjectName, oldProjectName],
    );

    // Update project name in table permitFeeSegmentPricing
    await db.rawUpdate(
      'UPDATE $tablePermitFeeStartingSimilar SET $columnPermitFeeStartingSimilarTableProjectName = ?'
          ' WHERE $columnPermitFeeStartingSimilarTableProjectName = ?',
      [newProjectName, oldProjectName],
    );

    // Update project name in ProjectResultFloorData
    await db.rawUpdate('UPDATE $tableResultFloorData SET $columnResultFloorTableProjectName = ? WHERE $columnResultFloorTableProjectName = ?', [newProjectName, oldProjectName]);

    // Update project name in projectResultCppData
    await db.rawUpdate('UPDATE $tableResultCppData SET $columnResultCppTableProjectName = ? WHERE $columnResultCppTableProjectName = ?', [newProjectName, oldProjectName]);

    // Update project name in ResultProjectColumnsClassData
    await db.rawUpdate('UPDATE $tableResultProjectData SET $columnResultProjectTableProjectName = ? WHERE $columnResultProjectTableProjectName = ?', [newProjectName, oldProjectName]);

    await db.rawUpdate('UPDATE $tableAddress SET $columnAddressTableProjectName = ? WHERE $columnAddressTableProjectName = ?', [newProjectName, oldProjectName]);

    await db.rawUpdate('UPDATE $tableBasicData SET $columnProjectBasicTableProjectName = ? WHERE $columnProjectBasicTableProjectName = ?', [newProjectName, oldProjectName]);

    await AllProjectsPageDatabase.updateProjectNameInAllProjectsPageData(oldProjectName, newProjectName, 'complete');    // Show a message or perform any other action after updating the project name
  }

  static Future<List<String>> getAllProjectNamesFromStartingSimilarTable() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableStartingSimilar, columns:
    [columnStartingSimilarTableProjectName]);
    List<String> projectNames = List.generate(maps.length, (i) {
      return maps[i][columnStartingSimilarTableProjectName] as String;
    });
    return projectNames;
  }


  static Future<ProjectAddressData?> getAddressProjectData(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableAddress,
      where: '$columnAddressTableProjectName = ?',
      whereArgs: [projectName],
    );

    if (maps.isEmpty) {
      //
      return null; // Handle the case where no data is found for the projectName

    }

    return ProjectAddressData(
      addressTableId: maps[0][columnAddressTableId],
      addressTableProjectName: maps[0][columnAddressTableProjectName],
      addressTableEnvironmentallyFriendly: maps[0][columnAddressTableEnvironmentallyFriendly],
      addressTableSociallyFriendly: maps[0][columnAddressTableSociallyFriendly],
      addressTableProvinceName: maps[0][columnAddressTableProvinceName],
      addressTableCity: maps[0][columnAddressTableCity],
      addressTableStreet: maps[0][columnAddressTableStreet],
      addressTableBuildingNumber: maps[0][columnAddressTableBuildingNumber],
      addressTablePhoneNumber: maps[0][columnAddressTablePhoneNumber],
      addressTableOther: maps[0][columnAddressTableOther],
    );
  }


  // Fee costs methods in database
  static Future<List<PermitFeeSegmentPricingData>> getPermitFeeSegmentPricingData(String projectName) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePermitFeeSegmentPricing,
      where: '$columnPermitFeeSegmentPricingTableProjectName = ?',
      whereArgs: [projectName],
    );


    return List.generate(maps.length, (i) {
      return PermitFeeSegmentPricingData(
        permitFeeSegmentPricingTableId: maps[i][columnPermitFeeSegmentPricingTableId],
        permitFeeSegmentPricingTableProjectName: maps[i][columnPermitFeeSegmentPricingTableProjectName],
        permitFeeSegmentPricingTableSegmentNumber: maps[i][columnPermitFeeSegmentPricingTableSegmentNumber],
        permitFeeSegmentPricingTableFloorNumber: maps[i][columnPermitFeeSegmentPricingTableFloorNumber],
        permitFeeSegmentPricingTableFeePlanNumber: maps[i][columnPermitFeeSegmentPricingTableFeePlanNumber],
        permitFeeSegmentPricingTableSegmentArea: maps[i][columnPermitFeeSegmentPricingTableSegmentArea],
        permitFeeSegmentPricingTableSegmentFeePerMeter: maps[i][columnPermitFeeSegmentPricingTableSegmentFeePerMeter],
        permitFeeSegmentPricingTableTotalSegmentPermitFee: maps[i][columnPermitFeeSegmentPricingTableTotalSegmentFee],
      );
    });
  }

  static Future<List<PermitFeeSegmentPricingData>> getPermitFeeSegmentPricingDataByFeePlan(String projectName,
      int permitFeeSegmentPricingTableFeePlanNumber)
  async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePermitFeeSegmentPricing,
      where: '$columnPermitFeeSegmentPricingTableProjectName = ? AND '
          '$columnPermitFeeSegmentPricingTableFeePlanNumber = ?',
      whereArgs: [projectName, permitFeeSegmentPricingTableFeePlanNumber],
    );

    return List.generate(maps.length, (i) {
      return PermitFeeSegmentPricingData(
        permitFeeSegmentPricingTableId: maps[i][columnPermitFeeSegmentPricingTableId],
        permitFeeSegmentPricingTableProjectName: maps[i][columnPermitFeeSegmentPricingTableProjectName],
        permitFeeSegmentPricingTableSegmentNumber: maps[i][columnPermitFeeSegmentPricingTableSegmentNumber],
        permitFeeSegmentPricingTableFloorNumber: maps[i][columnPermitFeeSegmentPricingTableFloorNumber],
        permitFeeSegmentPricingTableFeePlanNumber: maps[i][columnPermitFeeSegmentPricingTableFeePlanNumber],
        permitFeeSegmentPricingTableSegmentArea: maps[i][columnPermitFeeSegmentPricingTableSegmentArea],
        permitFeeSegmentPricingTableSegmentFeePerMeter: maps[i][columnPermitFeeSegmentPricingTableSegmentFeePerMeter],
        permitFeeSegmentPricingTableTotalSegmentPermitFee: maps[i][columnPermitFeeSegmentPricingTableTotalSegmentFee],
      );
    });
  }


  static Future<int> getNextPermitFeeSegmentPricingTableId() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT MAX($columnPermitFeeSegmentPricingTableId) + 1 as $columnPermitFeeSegmentPricingTableId FROM '
          '$tablePermitFeeSegmentPricing',
    );
    int nextID = maps.first[columnPermitFeeSegmentPricingTableId] ?? 1;
    return nextID;
  }

  static Future<PermitFeeStartingSimilarTableData?> getPermitFeeStartingSimilarTableSegmentData
      (String projectName,int feePlanNumber, int segmentNumber)
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePermitFeeStartingSimilar,
      where: '$columnPermitFeeStartingSimilarTableProjectName = ? AND '
          '$columnPermitFeeStartingSimilarTableFeePlanNumber = ? AND '
          '$columnPermitFeeStartingSimilarTableSegmentNumber = ?',
      whereArgs: [projectName, feePlanNumber, segmentNumber],
    );

    if (maps.isNotEmpty) {
      return PermitFeeStartingSimilarTableData(
        permitFeeStartingSimilarTableId: maps[0][columnPermitFeeStartingSimilarTableId],
        permitFeeStartingSimilarTableProjectName: maps[0][columnPermitFeeStartingSimilarTableProjectName],
        permitFeeStartingSimilarTableSegmentNumber: maps[0][columnPermitFeeStartingSimilarTableSegmentNumber],
        permitFeeStartingSimilarTableStartingFloor: maps[0][columnPermitFeeStartingSimilarTableStartingFloor],
        permitFeeStartingSimilarTableSimilarFloor: maps[0][columnPermitFeeStartingSimilarTableSimilarFloor],
  //      permitFeeStartingSimilarTableFloorNumber: maps[0][columnPermitFeeStartingSimilarTableFloorNumber],
        permitFeeStartingSimilarTableNumberOfSegments: maps[0][columnPermitFeeStartingSimilarTableNumberOfSegments],
        permitFeeStartingSimilarTableFeePlanNumber: maps[0][columnPermitFeeStartingSimilarTableFeePlanNumber],
        permitFeeStartingSimilarTableFeePercentage: maps[0][columnPermitFeeStartingSimilarTableFeePercentage],
        permitFeeStartingSimilarTableFeePerMeter: maps[0][columnPermitFeeStartingSimilarTableFeePerMeter],
      );
    } else {
      return null;
    }
  }

  static Future<List<PermitFeeStartingSimilarTableData>> getPermitFeeStartingSimilarData(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePermitFeeStartingSimilar,
      where: '$columnPermitFeeStartingSimilarTableProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return PermitFeeStartingSimilarTableData(
        permitFeeStartingSimilarTableId: maps[i][columnPermitFeeStartingSimilarTableId],
        permitFeeStartingSimilarTableProjectName: maps[i][columnPermitFeeStartingSimilarTableProjectName],
        permitFeeStartingSimilarTableSegmentNumber: maps[i][columnPermitFeeStartingSimilarTableSegmentNumber],
        permitFeeStartingSimilarTableStartingFloor: maps[i][columnPermitFeeStartingSimilarTableStartingFloor],
        permitFeeStartingSimilarTableSimilarFloor: maps[i][columnPermitFeeStartingSimilarTableSimilarFloor],
      //  permitFeeStartingSimilarTableFloorNumber: maps[i][columnPermitFeeStartingSimilarTableFloorNumber],
        permitFeeStartingSimilarTableNumberOfSegments: maps[i][columnPermitFeeStartingSimilarTableNumberOfSegments],
        permitFeeStartingSimilarTableFeePlanNumber: maps[i][columnPermitFeeStartingSimilarTableFeePlanNumber],
        permitFeeStartingSimilarTableFeePercentage: maps[i][columnPermitFeeStartingSimilarTableFeePercentage],
        permitFeeStartingSimilarTableFeePerMeter: maps[i][columnPermitFeeStartingSimilarTableFeePerMeter],
      );
    });
  }

  static Future<int> insertOrUpdatePermitFeeStartingSimilarPercentageData
      (PermitFeeStartingSimilarTableData data) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tablePermitFeeStartingSimilar,
      where: '$columnPermitFeeStartingSimilarTableProjectName = ? AND $columnPermitFeeStartingSimilarTableSegmentNumber = ? '
          ' AND $columnPermitFeeStartingSimilarTableFeePlanNumber = ?',
      whereArgs: [data.permitFeeStartingSimilarTableProjectName, data.permitFeeStartingSimilarTableSegmentNumber,
         data.permitFeeStartingSimilarTableFeePlanNumber],
    );
    if (maps.isNotEmpty) {
      int id = maps[0][columnPermitFeeStartingSimilarTableId];
      await db.update(
        tablePermitFeeStartingSimilar,
        data.toMap(),
        where: '$columnPermitFeeStartingSimilarTableProjectName = ? AND $columnPermitFeeStartingSimilarTableSegmentNumber = ?'
            ' AND $columnPermitFeeStartingSimilarTableFeePlanNumber = ?',
        whereArgs: [data.permitFeeStartingSimilarTableProjectName, data.permitFeeStartingSimilarTableSegmentNumber,
          data.permitFeeStartingSimilarTableFeePlanNumber],
      );
      return id;
    } else {
      int id = await db.insert(
        tablePermitFeeStartingSimilar,
        data.toMap(),
      );
      return id;
    }
  }

  static Future<List<PermitFeeStartingSimilarTableData>> getAllFeeProjectStartingSimilarData(String projectName) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tablePermitFeeStartingSimilar,
        where: '$columnPermitFeeStartingSimilarTableProjectName = ?',
        whereArgs: [projectName]);
    return List.generate(maps.length, (i) {
      return PermitFeeStartingSimilarTableData(
        permitFeeStartingSimilarTableId: maps[i][columnPermitFeeStartingSimilarTableId],
        permitFeeStartingSimilarTableProjectName: maps[i][columnPermitFeeStartingSimilarTableProjectName],
        permitFeeStartingSimilarTableSegmentNumber: maps[i][columnPermitFeeStartingSimilarTableSegmentNumber],
        permitFeeStartingSimilarTableStartingFloor: maps[i][columnPermitFeeStartingSimilarTableStartingFloor],
        permitFeeStartingSimilarTableSimilarFloor: maps[i][columnPermitFeeStartingSimilarTableSimilarFloor],
  //      permitFeeStartingSimilarTableFloorNumber: maps[i][columnPermitFeeStartingSimilarTableFloorNumber],
        permitFeeStartingSimilarTableNumberOfSegments: maps[i][columnPermitFeeStartingSimilarTableNumberOfSegments],
        permitFeeStartingSimilarTableFeePlanNumber: maps[i][columnPermitFeeStartingSimilarTableFeePlanNumber],
        permitFeeStartingSimilarTableFeePercentage: maps[i][columnPermitFeeStartingSimilarTableFeePercentage],
        permitFeeStartingSimilarTableFeePerMeter: maps[i][columnPermitFeeStartingSimilarTableFeePerMeter],
      );
    });
  }

  static Future<int> getNextPermitFeeStartingSimilarID() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnPermitFeeStartingSimilarTableId) + '
        '1 as $columnPermitFeeStartingSimilarTableId FROM $tablePermitFeeStartingSimilar');
    int nextID = maps.first[columnPermitFeeStartingSimilarTableId] ?? 1;
    return nextID;
  }


  static Future<List<Map<String, dynamic>>> fetchPermitFeeStartingSimilarTableData(String permitFeeProjectName,
      int permitFeePlanNumber, int permitFeeStartingFloor)
  async {
    List<Map<String, dynamic>> data = [];
    final db = await database;
    final List<dynamic> result = await db.query(
      tablePermitFeeStartingSimilar,
      where: '$columnPermitFeeStartingSimilarTableProjectName = ? AND '
          '$columnPermitFeeStartingSimilarTableFeePlanNumber = ? AND'
          ' $columnPermitFeeStartingSimilarTableStartingFloor = ?',
      whereArgs: [permitFeeProjectName, permitFeePlanNumber, permitFeeStartingFloor],
    );

    for (Map<String, dynamic> row in result) {
      data.add(row);
    }
    return data;
  }





  static Future<Map<String, int?>> getMaxFeePlanFloorNumberByProjectName(projectName) async {
    final db = await database;
    final result = await db.query(
      tablePermitFeeSegmentPricing,
      columns: [
        'MAX($columnPermitFeeSegmentPricingTableFloorNumber) AS maxFloor',
        'MAX($columnPermitFeeSegmentPricingTableFeePlanNumber) AS maxFeePlan',
      ],
      where: '$columnPermitFeeSegmentPricingTableProjectName = ?',
      whereArgs: [projectName],
    );

    final maxValues = {
      'maxFloor': int.tryParse(result.first['maxFloor'].toString()),
      'maxFeePlan': int.tryParse(result.first['maxFeePlan'].toString()),
    };
    return maxValues;
  }


  static Future<void> deleteCompleteCalculationDatabaseHelper() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final databasePath = join(dbPath.path, 'homePriceDatabase1.db');
    await deleteDatabase(databasePath);
  }


  static Future<int> getNextResultProjectTableId() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnResultProjectTableId) + 1 as '
        '$columnResultProjectTableId FROM $tableResultProjectData');
    int nextID = maps.first[columnResultProjectTableId] ?? 1;
    return nextID;
  }


  static Future deleteTablesOfCompleteCalculationDatabaseHelper() async {
    await _database?.execute('DROP TABLE IF EXISTS tableCostPricing');
    await _database?.execute('DROP TABLE IF EXISTS tableStartingSimilar');
    await _database?.execute('DROP TABLE IF EXISTS tablePermitFeeSegmentPricing');
    await _database?.execute('DROP TABLE IF EXISTS tablePermitFeeStartingSimilar');
    await _database?.execute('DROP TABLE IF EXISTS tableResultProjectData');
    await _database?.execute('DROP TABLE IF EXISTS tableResultFloorData');
    await _database?.execute('DROP TABLE IF EXISTS tableResultCppData');
    await _database?.execute('DROP TABLE IF EXISTS tableAddress');
  }


  static Future<List<ProjectStartingSimilarTableData>> getRowsOfStartingSimilarTable(String projectName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableStartingSimilar,
      where: '$columnStartingSimilarTableProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return ProjectStartingSimilarTableData(
        startingSimilarTableId: maps[i][columnStartingSimilarTableId],
        startingSimilarTableProjectName: maps[i][columnStartingSimilarTableProjectName],
        startingSimilarTableCpp: maps[i][columnStartingSimilarTableCpp],
        startingSimilarTableStartingFloor: maps[i][columnStartingSimilarTableStartingFloor],
        startingSimilarTableSimilarFloor: maps[i][columnStartingSimilarTableSimilarFloor],
        startingSimilarTableNumberOfSegments: maps[i][columnStartingSimilarTableNumberOfSegments],
        startingSimilarTableSegmentNumber: maps[i][columnStartingSimilarTableSegmentNumber],
        startingSimilarTableCostPercentage: maps[i][columnStartingSimilarTableCostPercentage],
        startingSimilarTableCostPerMeter: maps[i][columnStartingSimilarTableCostPerMeter],
        startingSimilarTableSellPricePercentage: maps[i][columnStartingSimilarTableSellPricePercentage],
        startingSimilarTableSellPricePerMeter: maps[i][columnStartingSimilarTableSellPricePerMeter],
        startingSimilarTableSegmentSalable: maps[0][columnstartingSimilarTableSegmentSalable],

      );
    });
  }

  // Method to update the rows in the 'projectStartingSimilarTable' table
  static Future<void> updateStartingFloorForInTableStartingSimilar(String projectName, int differenceStartingFloor) async {
    final db = await database;
    List<ProjectStartingSimilarTableData> rows = await
       getRowsOfStartingSimilarTable(projectName);

    for (var row in rows) {
      row.startingSimilarTableStartingFloor += differenceStartingFloor;
      await db.update(
        tableStartingSimilar,
        row.toMap(),
        where: '$columnStartingSimilarTableId = ?',
        whereArgs: [row.startingSimilarTableId],
      );
    }
  }

  static Future<void> updateStartingFloorInTableCostPricing(String projectName, int differenceStartingFloor) async {
    final db = await database;
    List<ProjectTableData> rows = await getCostPricingData(projectName);

    for (var row in rows) {
      row.costPricingTableFloorNumber += differenceStartingFloor;
      await db.update(
        tableCostPricing,
        row.toMap(),
        where: '$columnCostPricingTableProjectId = ?',
        whereArgs: [row.costPricingTableProjectId],
      );
    }
  }

  static Future<void> updateFloorNumberInTableResultFloorData(String projectName, int differenceFloorNumber) async {
    final db = await database;
    List<ProjectResultFloorData> rows = await getProjectResultFloorData(projectName);

    for (var row in rows) {
      row.resultFloorTableFloorNumber += differenceFloorNumber;
      await db.update(
        tableResultFloorData,
        row.toMap(),
        where: '$columnResultFloorTableProjectName = ?',
        whereArgs: [projectName],
      );
    }
  }

/*  static Future<void> updateFloorNumberAndStartingFloorInTablePermitFeeStartingSimilar
      (String projectName, int differenceStartingFloor) async {
    final db = await database;
    List<PermitFeeStartingSimilarTableData> rows = await getPermitFeeStartingSimilarData(projectName);

    for (var row in rows) {

      row.permitFeeStartingSimilarTableStartingFloor += differenceStartingFloor;
      await db.update(
        tablePermitFeeStartingSimilar,
        row.toMap(),
        where: '$columnPermitFeeStartingSimilarTableProjectName = ?',
        whereArgs: [projectName],
      );
    }
  }*/

  static Future<void> updateFloorNumberInTablePermitFeeSegmentPricing(String projectName, int differenceFloorNumber) async {
    final db = await database;
    List<PermitFeeSegmentPricingData> rows = await getPermitFeeSegmentPricingData(projectName);

    for (var row in rows) {
      row.permitFeeSegmentPricingTableFloorNumber += differenceFloorNumber;
      await db.update(
        tablePermitFeeSegmentPricing,
        row.toMap(),
        where: '$columnPermitFeeSegmentPricingTableProjectName = ?',
        whereArgs: [projectName],
      );
    }
  }

  static Future<List<List<dynamic>>> getFloorAreas(String projectName) async {
    final data = await getCostPricingData(projectName);
    final floorAreas = <List<dynamic>>[];

    // Create a map to store the total area for each floor number
    Map<int, double> floorAreaMap = {};

    for (var project in data) {
      final floorNumber = project.costPricingTableFloorNumber;
      final area = project.costPricingTableSegmentArea;

      // Update the total area for the current floor number
      if (floorAreaMap.containsKey(floorNumber)) {
        floorAreaMap[floorNumber] = floorAreaMap[floorNumber]! + area;
      } else {
        floorAreaMap[floorNumber] = area;
      }
    }

    // Convert the map to a list of lists
    floorAreaMap.forEach((floorNumber, totalArea) {
      floorAreas.add([floorNumber, totalArea]);
    });

    return floorAreas;
  }



  static Future<List<List<dynamic>>> getPermitFeeFloorArea(String projectName) async {

    final data = await getPermitFeeSegmentPricingData(projectName);
    final permitFeeFloorAreas = <List<dynamic>>[];

    // Create a map to store the total area for each floor number
    Map<int, double> permitFeeFloorAreaMap = {};

    for (var permitFeeSegmentPricingData in data) {
      final floorNumber = permitFeeSegmentPricingData.permitFeeSegmentPricingTableFloorNumber;
      final segmentArea = permitFeeSegmentPricingData.permitFeeSegmentPricingTableSegmentArea;

      // Update the total area for the current floor number
      if (permitFeeFloorAreaMap.containsKey(floorNumber)) {
        permitFeeFloorAreaMap[floorNumber] = permitFeeFloorAreaMap[floorNumber]! + segmentArea;
      } else {
        permitFeeFloorAreaMap[floorNumber] = segmentArea;
      }
    }

    // Convert the map to a list of lists
    permitFeeFloorAreaMap.forEach((floorNumber, totalArea) {
      permitFeeFloorAreas.add([floorNumber, totalArea]);
    });

    return permitFeeFloorAreas;
  }

  static Future<List<List<dynamic>>> getFloorAreasWithDifferentAreas(String projectName) async {
    final floorAreas = await getFloorAreas(projectName);
    final permitFeeFloorAreas = await getPermitFeeFloorArea(projectName);

    final result = <List<dynamic>>[];

    for (var floorArea in floorAreas) {
      final floorNumber = floorArea[0];
      final area = floorArea[1];

      if (!permitFeeFloorAreas.any((permitFeeFloorArea) => permitFeeFloorArea[0] == floorNumber)) {
        result.add([floorNumber, area]);
      }
    }

    for (var permitFeeFloorArea in permitFeeFloorAreas) {
      final floorNumber = permitFeeFloorArea[0];
      final area = permitFeeFloorArea[1];

      if (!floorAreas.any((floorArea) => floorArea[0] == floorNumber)) {
        result.add([floorNumber, area]);
      }
    }

    return result;
  }


  static Future<int?> getMaxFloorNumberByProject(String project) async {
    final db = await database;
    final result = await db.query(
      tableCostPricing,
      columns: ['MAX($columnCostPricingTableFloorNumber) AS maxFloor'],
      where: '$columnCostPricingTableProjectName = ?',
      whereArgs: [project],
    );

    final maxFloor = int.tryParse(result.first['maxFloor'].toString());
    return maxFloor;
  }

  static Future<int> deleteProjectBasicData(String projectName) async {
    final db = await database; // Get the database instance
    return await db.delete(
      tableBasicData, // The table from which to delete
      where: '$columnProjectBasicTableProjectName = ?', // Condition for deletion
      whereArgs: [projectName], // The project name to match
    );
  }

}

// DatabaseHelper CompleteCalculationDatabaseHelper



void showEmptyPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Blank fields'),
        content: const Text('Please make sure to fill in the values for row, name '
            'and number Of Segments before proceeding.'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ok'),
          ),
        ],
      );
    },
  );
}


//////////////////////////////////////////////////// Currently this class isn't used
/*
class AddressBottomSheet extends StatefulWidget {
  final BuildContext context;
  final String projectName;

  const AddressBottomSheet({super.key, required this.context, required this.projectName});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _environmentallyFriendlyController = TextEditingController();
  final TextEditingController _sociallyFriendlyController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  String projectName2 = '';
  double environmentallyFriendlyAllProjects = 1;
  double sociallyFriendlyAllProjects = 1;
  String costOfProjectAllProjects = '';
  String incomeOfProjectAllProjects = '';
  String profitOfProjectAllProjects = '';
  String profitPercentageOfProjectAllProjects = '';
  String nameOfProjectAllProjects = '';
  String calculationTypeAllProjects = '';

  @override
  void initState() {
    super.initState();
    _retrieveAddressData();
  }


  Future<void> _retrieveAddressData() async {
    ProjectAddressData? addressData = await CompleteCalculationDatabaseHelper.getAddressProjectData(widget.projectName);

    if (addressData != null) {
      _projectNameController.text = (widget.projectName == "_oozz") ? "hhh" : widget.projectName;
      _provinceController.text = addressData.addressTableProvinceName;
      _sociallyFriendlyController.text = addressData.addressTableSociallyFriendly;
      _environmentallyFriendlyController.text = addressData.addressTableEnvironmentallyFriendly;
      _cityController.text = addressData.addressTableCity;
      _streetController.text = addressData.addressTableStreet;
      _buildingNumberController.text = addressData.addressTableBuildingNumber;
      _phoneNumberController.text = addressData.addressTablePhoneNumber;
      _otherController.text = addressData.addressTableOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                TextField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Province',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _buildingNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Building Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _otherController,
                  decoration: const InputDecoration(
                    labelText: 'Other',
                    border: OutlineInputBorder(),
                  ),
                ),


                ElevatedButton(
                  child: const Text('Save Project'),
                  onPressed: () async {

                    if (_projectNameController.text.isNotEmpty  || _projectNameController.text== '_oozz') {
                      final String projectNameControllerText = _projectNameController.text;
                      final List<String> existingProjectNames = await CompleteCalculationDatabaseHelper.getAllProjectNames();
                      if (existingProjectNames.contains(projectNameControllerText) &&
                          projectNameControllerText != projectName2) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('A project with this name already exists. Please choose another name.'),
                              backgroundColor: Color(0xFF9A87BE),
                            ),
                          );
                        }

                      } else {
                        if (projectName2 != _projectNameController.text) {
                          var projectData = context.read<ProjectData>();
                          await CompleteCalculationDatabaseHelper.updateProjectNameInAllTables(
                            _projectNameController.text,
                            projectData.projectName,
                          );
                          projectData.setProjectName(_projectNameController.text);
                          projectName2 = projectData.projectName;
                        }
                        // Get the project name, city, and street from the text fields
                        String city = _cityController.text;
                        String street = _streetController.text;
                        final ProjectAddressData projectAddressData = ProjectAddressData(
                          addressTableId: await CompleteCalculationDatabaseHelper.getNextAddressProjectID(),
                          addressTableProjectName: _projectNameController.text,
                          addressTableEnvironmentallyFriendly: _environmentallyFriendlyController.text,
                          addressTableSociallyFriendly: _sociallyFriendlyController.text,
                          addressTableProvinceName: _provinceController.text,
                          addressTableCity: city,
                          addressTableStreet: street,
                          addressTableBuildingNumber: _buildingNumberController.text,
                          addressTablePhoneNumber: _phoneNumberController.text,
                          addressTableOther: _otherController.text,
                        );

                        await CompleteCalculationDatabaseHelper.insertOrUpdateAddressProjectData(projectAddressData);

                        List<ResultProjectColumnsClassData> resultProjectData = await
                        CompleteCalculationDatabaseHelper.getResultProjectColumnsClassData(projectName2);

                        // Initialize the variables from the retrieved data
                        if (resultProjectData.isNotEmpty) {
                          nameOfProjectAllProjects = resultProjectData[0].resultProjectTableProjectName;
                          incomeOfProjectAllProjects = (resultProjectData[0].resultProjectTableTotalIncome);
                          costOfProjectAllProjects   = (resultProjectData[0].resultProjectTableTotalCosts);
                          profitOfProjectAllProjects = (resultProjectData[0].resultProjectTableTotalProfit);
                          profitPercentageOfProjectAllProjects =
                               ((resultProjectData[0].resultProjectTableProfitPercentageOfProject));

                          environmentallyFriendlyAllProjects = (_environmentallyFriendlyController.text.isNotEmpty) ?
                          double.parse (_environmentallyFriendlyController.text) : 1;
                          sociallyFriendlyAllProjects = (_sociallyFriendlyController.text.isNotEmpty) ?
                          double.parse (_sociallyFriendlyController.text) : 1;
                          calculationTypeAllProjects = 'complete';

                        }
                        final AllProjectsPageData1 allProjectsPageDataArguments =
                        AllProjectsPageData1(
                          allProjectsPageProjectName: nameOfProjectAllProjects,
                          allProjectsPageCostOfProject: costOfProjectAllProjects,
                          allProjectsPageIncomeOfProject: incomeOfProjectAllProjects,
                          allProjectsPageProfitOfProject: profitOfProjectAllProjects,
                          allProjectsPageProfitPercentageOfProject: profitPercentageOfProjectAllProjects,
                          allProjectsPageEnvironmentallyFriendly: environmentallyFriendlyAllProjects,
                          allProjectsPageSociallyFriendly: sociallyFriendlyAllProjects,
                          allProjectsPageCity: city,
                          allProjectsPageStreet: street,
                          allProjectsPageCalculationName: calculationTypeAllProjects,
                        );

                        await AllProjectsPageDatabase.insertOrUpdateAllProjectsPageData(allProjectsPageDataArguments);
                     */
/*   await insertDataIntoAllProjectsTable(
                          nameOfProject,
                          costOfProject,
                          incomeOfProject,
                          profitOfProject,
                          profitPercentageOfProject,
                          environmentallyFriendly,
                          sociallyFriendly,
                          city,
                          street,
                          calculationType,
                        );*//*

                      }
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(''),
                            content: const Text('Please enter a project name.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the popup
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/




///////////////////////////
