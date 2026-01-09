import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'all_projects.dart';
import 'ad_mob.dart';
import 'navigation_service.dart';

class UniformCalculationDatabase {
  static const String tableUniformCalculationData = 'uniformCalculationDataTable';
  static const String columnUniformCalculationProjectName = 'uniformCalculationProjectName';
  static const String columnUniformCalculationProjectId = 'uniformCalculationProjectId';
  static const String columnLandAreaValueText = 'landAreaValueText';
  static const String columnTotalIncomeText = 'totalIncomeText';
  static const String columnTotalCostText = 'totalCostText';
  static const String columnProfitText = 'profitText';
  static const String columnProfitPercentageText = 'profitPercentageText';
  static const String columnFloorCommonAreaText = 'floorCommonAreaText';
  static const String columnApartmentSellPricePerMeterValueText = 'apartmentSellPricePerMeterValueText';
  static const String columnFloorConstructedLandAreaText = 'floorConstructedLandAreaText';
  static const String columnBuildabilityPercentageOrAreaValueText = 'buildabilityPercentageOrAreaText';
  static const String columnBuildabilityBoolIntValue = 'buildabilityBoolIntValue';
  static const String columnPermitBoolValue = 'permitBoolValue';
  static const String columnPermitPerMeterOrTotalPermitCostText = 'permitPerMeterOrTotalPermitCostText';
  static const String columnTotalPermitCostText = 'totalPermitCostText';
  static const String columnTotalUsefulAreaText = 'totalUsefulAreaText';
  static const String columnTotalConstructedAreaText = 'totalConstructedAreaText';
  static const String columnOtherCostText = 'otherCostText';
  static const String columnCostOfLandText = 'costOfLandText';
  static const String columnConstructionCostOfAllFloorsText = 'constructionCostOfAllFloorsText';
  static const String columnConstructionCostPerMeterText = 'constructionCostPerMeterText';
  static const String columnFloorUsefulAreaText = 'floorUsefulAreaText';
  static const String columnFloorTotalPriceText = 'floorTotalPriceText';
  static const String columnAllCostsIncurredPerMeterOfUsefulAreaText = 'allCostsIncurredPerMeterOfUsefulAreaText';
  static const String columnProfitPerUsefulAreaText = 'profitPerUsefulAreaText';
  static const String columnUsefulAreaConstructedBy1BillionText = 'usefulAreaConstructedBy1BillionText';
  static const String columntotalNumberOfPropertiesByTenXText = 'totalNumberOfPropertiesByTenXText';
  static const String columnProfitPercentagePerUsefulAreaText = 'profitPercentagePerUsefulAreaText';
  static const String columnLandPricePerMeter = 'landPricePerMeter';
  static const String columnTenXOfTotalCostForUnit = 'tenXOfTotalCostForUnit';
  static const String columnTotalNumberOfProperties = 'totalNumberOfProperties';
  static const String columnTotalNumberOfFloors = 'totalNumberOfFloors';
  static const String columnNumberOfSaleableFloorsValue = 'numberOfSaleableFloorsValue';
  static const String columnNumberOfInvestmentYears = 'numberOfInvestmentYears';
  static const String columnProfitPercentageAnnuallyText = 'profitPercentageAnnuallyText';

  static const String tableUniformCalculationAddress = 'uniformCalculationAddressTable';
  static const String columnUniformCalculationAddressTableId = 'uniformCalculationAddressTableId';
  static const String columnUniformCalculationAddressProjectName = 'uniformCalculationAddressProjectName';
  static const String columnCalculationType = 'calculationType';
  static const String columnProvinceName = 'ProvinceName';
  static const String columnCityName = 'CityName';
  static const String columnStreetName = 'StreetName';
  static const String columnBuildingNumber = 'BuildingNumber';
  static const String columnPhoneNumber = 'PhoneNumber';
  static const String columnOtherInfo = 'OtherInfo';
  static const String columnSociallyFriendly = 'socially_friendly';
  static const String columnEnvironmentallyFriendly = 'environmentally_friendly';

  static const _databaseName = 'uniformCalculationDatabase1.db';

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
    await _onCreateUniformCalculationTable(db, version);
    await _onCreateUniformCalculationAddressTable(db, version);
  }


  static Future<void> _onCreateUniformCalculationTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUniformCalculationData (
      ${UniformCalculationDatabase.columnUniformCalculationProjectName} TEXT,
      ${UniformCalculationDatabase.columnUniformCalculationProjectId} INTEGER PRIMARY KEY,
      ${UniformCalculationDatabase.columnLandAreaValueText} TEXT,
      ${UniformCalculationDatabase.columnTotalIncomeText} TEXT,
      ${UniformCalculationDatabase.columnTotalCostText} TEXT,
      ${UniformCalculationDatabase.columnProfitText} TEXT,
      ${UniformCalculationDatabase.columnProfitPercentageText} TEXT,
      ${UniformCalculationDatabase.columnFloorCommonAreaText} TEXT,
      ${UniformCalculationDatabase.columnApartmentSellPricePerMeterValueText} TEXT,
      ${UniformCalculationDatabase.columnFloorConstructedLandAreaText} TEXT,
      ${UniformCalculationDatabase.columnPermitPerMeterOrTotalPermitCostText} TEXT,
      ${UniformCalculationDatabase.columnBuildabilityPercentageOrAreaValueText} TEXT,
      ${UniformCalculationDatabase.columnTotalPermitCostText} TEXT,
      ${UniformCalculationDatabase.columnTotalUsefulAreaText} TEXT,
      ${UniformCalculationDatabase.columnTotalConstructedAreaText} TEXT,
      ${UniformCalculationDatabase.columnOtherCostText} TEXT,
      ${UniformCalculationDatabase.columnCostOfLandText} TEXT,
      ${UniformCalculationDatabase.columnConstructionCostOfAllFloorsText} TEXT,
      ${UniformCalculationDatabase.columnConstructionCostPerMeterText} TEXT,
      ${UniformCalculationDatabase.columnFloorUsefulAreaText} TEXT,
      ${UniformCalculationDatabase.columnFloorTotalPriceText} TEXT,
      ${UniformCalculationDatabase.columnAllCostsIncurredPerMeterOfUsefulAreaText} TEXT,
      ${UniformCalculationDatabase.columnProfitPerUsefulAreaText} TEXT,
      ${UniformCalculationDatabase.columnProfitPercentagePerUsefulAreaText} TEXT,
      ${UniformCalculationDatabase.columnUsefulAreaConstructedBy1BillionText} TEXT,
      ${UniformCalculationDatabase.columntotalNumberOfPropertiesByTenXText} TEXT,
      ${UniformCalculationDatabase.columnLandPricePerMeter} TEXT,
      ${UniformCalculationDatabase.columnTenXOfTotalCostForUnit} TEXT,
      ${UniformCalculationDatabase.columnPermitBoolValue} INTEGER,
      ${UniformCalculationDatabase.columnBuildabilityBoolIntValue} INTEGER,
      ${UniformCalculationDatabase.columnTotalNumberOfFloors} REAL,
      ${UniformCalculationDatabase.columnTotalNumberOfProperties} REAL,
      ${UniformCalculationDatabase.columnNumberOfInvestmentYears} REAL,
       ${UniformCalculationDatabase.columnProfitPercentageAnnuallyText} TEXT,
      ${UniformCalculationDatabase.columnNumberOfSaleableFloorsValue} REAL
    )
  ''');
  }

  static Future<void> _onCreateUniformCalculationAddressTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUniformCalculationAddress (
      ${UniformCalculationDatabase.columnUniformCalculationAddressProjectName} TEXT,
      ${UniformCalculationDatabase.columnUniformCalculationAddressTableId} INTEGER PRIMARY KEY,
      ${UniformCalculationDatabase.columnCalculationType} TEXT,
      ${UniformCalculationDatabase.columnProvinceName} TEXT,
      ${UniformCalculationDatabase.columnCityName} TEXT,
      ${UniformCalculationDatabase.columnStreetName} TEXT,
      ${UniformCalculationDatabase.columnBuildingNumber} TEXT,
      ${UniformCalculationDatabase.columnPhoneNumber} TEXT,
      ${UniformCalculationDatabase.columnOtherInfo} TEXT,
      ${UniformCalculationDatabase.columnSociallyFriendly} REAL,
      ${UniformCalculationDatabase.columnEnvironmentallyFriendly} REAL
    )
  ''');
  }

  static Future<int?> insertOrUpdateUniformCalculationData(UniformCalculationClassData  uniformCalculationData)
  async {
    final db = await database;
    final maps = await db.query(
      tableUniformCalculationData,
      where: '$columnUniformCalculationProjectName = ?',
      whereArgs: [uniformCalculationData.uniformCalculationProjectName],
    );

    if (maps.isNotEmpty) {
      // Update the existing record
      await db.update(
        tableUniformCalculationData,
        uniformCalculationData.toMap(),
        where: '$columnUniformCalculationProjectName = ?',
        whereArgs: [uniformCalculationData.uniformCalculationProjectName],
      );
      return null; // Return null for updates since no new ID is created
    } else {
      // Insert a new record
      final id = await db.insert(
        tableUniformCalculationData,
        uniformCalculationData.toMap(),
      );
      return id; // Return the newly created ID
    }
  }

  static Future<int?> insertOrUpdateUniformCalculationAddressData(UniformCalculationAddress1
  uniformCalculationAddress)
  async {
    final db = await database;

    // Check if a record with the same project name already exists
    final maps = await db.query(
      tableUniformCalculationAddress,
      where: '$columnUniformCalculationAddressProjectName = ?',
      whereArgs: [uniformCalculationAddress.addressTableProjectName],
    );

    if (maps.isNotEmpty) {
      // Update the existing record
      await db.update(
        tableUniformCalculationAddress,
        uniformCalculationAddress.toMap(),
        where: '$columnUniformCalculationAddressProjectName = ?',
        whereArgs: [uniformCalculationAddress.addressTableProjectName],
      );
      return null; // Return null for updates since no new ID is created
    } else {
      // Insert a new record
      final id = await db.insert(
        tableUniformCalculationAddress,
        uniformCalculationAddress.toMap(),
      );
      return id; // Return the newly created ID
    }
  }

  static Future<List<UniformCalculationClassData>> getUniformCalculationData(String projectName)
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUniformCalculationData,
      where: '$columnUniformCalculationProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return UniformCalculationClassData(
        uniformCalculationProjectName: maps[i][columnUniformCalculationProjectName],
        uniformCalculationProjectId: maps[i][columnUniformCalculationProjectId],
        landPricePerMeter: maps[i][columnLandPricePerMeter],
        landAreaValueText: maps[i][columnLandAreaValueText],
        totalIncomeText: maps[i][columnTotalIncomeText],
        totalCostText: maps[i][columnTotalCostText],
        profitText: maps[i][columnProfitText],
        profitPercentageText: maps[i][columnProfitPercentageText],
        profitPercentageAnnuallyText: maps[i][columnProfitPercentageAnnuallyText],
        floorCommonAreaText: maps[i][columnFloorCommonAreaText],
        apartmentSellPricePerMeterValueText: maps[i][columnApartmentSellPricePerMeterValueText],
        floorConstructedLandAreaText: maps[i][columnFloorConstructedLandAreaText],
        totalPermitCostText: maps[i][columnTotalPermitCostText],
        totalUsefulAreaText: maps[i][columnTotalUsefulAreaText],
        totalConstructedAreaText: maps[i][columnTotalConstructedAreaText],
        otherCostValueText: maps[i][columnOtherCostText],
        costOfLandText: maps[i][columnCostOfLandText],
        constructionCostOfAllFloorsText: maps[i][columnConstructionCostOfAllFloorsText],
        floorUsefulAreaText: maps[i][columnFloorUsefulAreaText],
        floorTotalPriceText: maps[i][columnFloorTotalPriceText],
        allCostsIncurredPerMeterOfUsefulAreaText: maps[i][columnAllCostsIncurredPerMeterOfUsefulAreaText],
        profitPerUsefulAreaText: maps[i][columnProfitPerUsefulAreaText],
        usefulAreaConstructedBy1BillionText: maps[i][columnUsefulAreaConstructedBy1BillionText],
        totalNumberOfPropertiesByTenXText: maps[i][columntotalNumberOfPropertiesByTenXText],
        tenXOfTotalCostForUnit: maps[i][columnTenXOfTotalCostForUnit],
        totalNumberOfProperties: maps[i][columnTotalNumberOfProperties],
        totalNumberOfFloorsValue: maps[i][columnTotalNumberOfFloors],
        permitPerMeterOrTotalPermitCostText: maps[i][columnPermitPerMeterOrTotalPermitCostText],
        buildabilityPercentageOrAreaValueText: maps[i][columnBuildabilityPercentageOrAreaValueText],
        permitBoolValue: maps[i][columnPermitBoolValue],
        buildabilityBoolIntValueClass: maps[i][columnBuildabilityBoolIntValue],
        numberOfSaleableFloorsValue: maps[i][columnNumberOfSaleableFloorsValue],
        constructionCostPerMeterText: maps[i][columnConstructionCostPerMeterText],
        profitPercentagePerUsefulAreaText: maps[i][columnProfitPercentagePerUsefulAreaText],
        numberOfInvestmentYears: maps[i][columnNumberOfInvestmentYears],
      );
    }
    );
  }

  static Future<List<UniformCalculationAddress1>> getUniformCalculationAddressData(String projectName)
  async {
    final db = await database; // Get a reference to the database
    final List<Map<String, dynamic>> maps = await db.query(
      tableUniformCalculationAddress,
      where: '$columnUniformCalculationAddressProjectName = ?',
      whereArgs: [projectName],
    );

    return List.generate(maps.length, (i) {
      return UniformCalculationAddress1(
        addressTableProjectName: maps[i][columnUniformCalculationAddressProjectName],
        addressTableId: maps[i][columnUniformCalculationAddressTableId],
        addressCalculationType: maps[i][columnCalculationType],
        addressProvinceName: maps[i][columnProvinceName],
        addressCityName: maps[i][columnCityName],
        addressStreetName: maps[i][columnStreetName],
        addressBuildingNumber: maps[i][columnBuildingNumber],
        addressPhoneNumber: maps[i][columnPhoneNumber],
        addressOtherInfo: maps[i][columnOtherInfo],
        addressSociallyFriendly: maps[i][columnSociallyFriendly],
        addressEnvironmentallyFriendly: maps[i][columnEnvironmentallyFriendly],
      );
    });
  }

  static Future<void> deleteUniformCalculationProject(String projectName)
  async {
    final db = await database;

    // Delete from UniformCalculationData
    await db.delete(
      tableUniformCalculationData,
      where: '$columnUniformCalculationProjectName = ?',
      whereArgs: [projectName],
    );
  }

  static Future<void> deleteUniformCalculationDatabase()
  async {
    final dbPath = await getApplicationDocumentsDirectory();
    final databasePath = join(dbPath.path, 'uniformCalculationDatabase1.db');
    await deleteDatabase(databasePath);
  }


  static Future<List<String>> getAllUniformCalculationProjectNames()
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUniformCalculationData,
      columns: [UniformCalculationDatabase.columnUniformCalculationProjectName],
    );

    List<String> projectNames = List.generate(maps.length, (i) {
      return maps[i][UniformCalculationDatabase.columnUniformCalculationProjectName] as String;
    });

    return projectNames;
  }

  static Future<void> deleteProjectOfUniformCalculationDatabase(String projectName) async {
    final db = await database;

    // Define a list of tables and their corresponding project name columns
    final tablesToDelete = [
      {
        'tableName': 'tableUniformCalculationData',
        'projectNameColumn': 'projectNameColumn', // Replace with actual column constant
      },
      {
        'tableName': 'tableUniformCalculationAddress',
        'projectNameColumn': 'projectNameColumn', // Replace with actual column constant
      },
    ];

    // Delete all rows for the specific project from each table
    for (final table in tablesToDelete) {
      await db.delete(
        table['tableName'] as String,
        where: '${table['projectNameColumn']} = ?',
        whereArgs: [projectName],
      );
    }
  }


  static Future<List<String>> getAllUniformCalculationAddressProjectNames()
  async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUniformCalculationAddress,
      columns: [UniformCalculationDatabase.columnUniformCalculationAddressProjectName],
    );

    List<String> uniformCalculationAddressProjectNames = List.generate(maps.length, (i) {
      return maps[i][UniformCalculationDatabase.columnUniformCalculationAddressProjectName] as String;
    });

    return uniformCalculationAddressProjectNames;
  }

  static Future<void> updateProjectNameInAllUniformCalculationTables(String newProjectName, String oldProjectName)
  async {
    final db = await database;
    // Update project name in ProjectTableData
    await db.rawUpdate('UPDATE $tableUniformCalculationData SET $columnUniformCalculationProjectName = ? '
        'WHERE $columnUniformCalculationProjectName = ?', [newProjectName, oldProjectName]);

    // Update project name in ProjectStartingSimilarTableData
    await db.rawUpdate('UPDATE $tableUniformCalculationAddress SET $columnUniformCalculationAddressProjectName = ? WHERE '
        '$columnUniformCalculationAddressProjectName = ?', [newProjectName, oldProjectName]);

    await AllProjectsPageDatabase.updateProjectNameInAllProjectsPageData(oldProjectName, newProjectName, 'uniform');    // Show a message or perform any other action after updating the project name
  }

  static Future<int> getNextUniformCalculationProjectID() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnUniformCalculationProjectId) '
        '+ 1 as $columnUniformCalculationProjectId FROM $tableUniformCalculationData');
    int nextID = maps.first[columnUniformCalculationProjectId] ?? 1;
    return nextID;
  }

  static Future<int> getNextUniformCalculationAddressID() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT MAX($columnUniformCalculationAddressTableId) '
        '+ 1 as $columnUniformCalculationAddressTableId FROM $tableUniformCalculationAddress');
    int nextID = maps.first[columnUniformCalculationAddressTableId] ?? 1;
    return nextID;
  }
} // uniformCalculationDatabase

class UniformCalculationClassData {
  String uniformCalculationProjectName;
  int uniformCalculationProjectId;
  String landAreaValueText;
  String totalIncomeText;
  String totalCostText;
  String profitText;
  String profitPercentageText;
  String floorCommonAreaText;
  String apartmentSellPricePerMeterValueText;
  String floorConstructedLandAreaText;
  String permitPerMeterOrTotalPermitCostText;
  String totalPermitCostText;
  String buildabilityPercentageOrAreaValueText;
  String totalUsefulAreaText;
  String totalConstructedAreaText;
  String otherCostValueText;
  String costOfLandText;
  String constructionCostOfAllFloorsText;
  String constructionCostPerMeterText;
  String floorUsefulAreaText;
  String floorTotalPriceText;
  String allCostsIncurredPerMeterOfUsefulAreaText;
  String profitPerUsefulAreaText;
  String profitPercentagePerUsefulAreaText;
  String usefulAreaConstructedBy1BillionText;
  String totalNumberOfPropertiesByTenXText;
  String landPricePerMeter;
  String tenXOfTotalCostForUnit;
  int permitBoolValue;
  int buildabilityBoolIntValueClass;
  double totalNumberOfFloorsValue;
  double totalNumberOfProperties;
  double numberOfSaleableFloorsValue;
  double numberOfInvestmentYears;
  String profitPercentageAnnuallyText;

  UniformCalculationClassData({
    required this.uniformCalculationProjectName,
    required this.uniformCalculationProjectId,
    required this.landAreaValueText,
    required this.totalIncomeText,
    required this.totalCostText,
    required this.profitText,
    required this.profitPercentageText,
    required this.floorCommonAreaText,
    required this.apartmentSellPricePerMeterValueText,
    required this.floorConstructedLandAreaText,
    required this.permitPerMeterOrTotalPermitCostText,
    required this.totalPermitCostText,
    required this.buildabilityPercentageOrAreaValueText,
    required this.totalUsefulAreaText,
    required this.totalConstructedAreaText,
    required this.otherCostValueText,
    required this.costOfLandText,
    required this.constructionCostPerMeterText,
    required this.constructionCostOfAllFloorsText,
    required this.floorUsefulAreaText,
    required this.floorTotalPriceText,
    required this.allCostsIncurredPerMeterOfUsefulAreaText,
    required this.profitPerUsefulAreaText,
    required this.usefulAreaConstructedBy1BillionText,
    required this.totalNumberOfPropertiesByTenXText,
    required this.landPricePerMeter,
    required this.tenXOfTotalCostForUnit,
    required this.totalNumberOfFloorsValue,
    required this.permitBoolValue,
    required this.buildabilityBoolIntValueClass,
    required this.totalNumberOfProperties,
    required this.numberOfSaleableFloorsValue,
    required this.profitPercentagePerUsefulAreaText,
    required this.numberOfInvestmentYears,
    required this.profitPercentageAnnuallyText,
  });

  Map<String, dynamic> toMap() {
    return {
      'uniformCalculationProjectName': uniformCalculationProjectName,
      'uniformCalculationProjectId': uniformCalculationProjectId,
      'landAreaValueText': landAreaValueText,
      'totalIncomeText': totalIncomeText,
      'totalCostText': totalCostText,
      'profitText': profitText,
      'profitPercentageText': profitPercentageText,
      'floorCommonAreaText': floorCommonAreaText,
      'apartmentSellPricePerMeterValueText': apartmentSellPricePerMeterValueText,
      'floorConstructedLandAreaText': floorConstructedLandAreaText,
      'permitPerMeterOrTotalPermitCostText': permitPerMeterOrTotalPermitCostText,
      'buildabilityPercentageOrAreaText': buildabilityPercentageOrAreaValueText,
      'totalPermitCostText': totalPermitCostText,
      'totalUsefulAreaText': totalUsefulAreaText,
      'totalConstructedAreaText': totalConstructedAreaText,
      'otherCostText': otherCostValueText,
      'costOfLandText': costOfLandText,
      'constructionCostOfAllFloorsText': constructionCostOfAllFloorsText,
      'floorUsefulAreaText': floorUsefulAreaText,
      'floorTotalPriceText': floorTotalPriceText,
      'allCostsIncurredPerMeterOfUsefulAreaText': allCostsIncurredPerMeterOfUsefulAreaText,
      'profitPerUsefulAreaText': profitPerUsefulAreaText,
      'profitPercentagePerUsefulAreaText': profitPercentagePerUsefulAreaText,
      'usefulAreaConstructedBy1BillionText': usefulAreaConstructedBy1BillionText,
      'totalNumberOfPropertiesByTenXText': totalNumberOfPropertiesByTenXText,
      'landPricePerMeter': landPricePerMeter,
      'tenXOfTotalCostForUnit': tenXOfTotalCostForUnit,
      'totalNumberOfFloors': totalNumberOfFloorsValue,
      'permitBoolValue': permitBoolValue,
      'buildabilityBoolIntValue': buildabilityBoolIntValueClass,
      'numberOfSaleableFloorsValue': numberOfSaleableFloorsValue,
      'totalNumberOfProperties': totalNumberOfProperties,
      'constructionCostPerMeterText': constructionCostPerMeterText,
      'numberOfInvestmentYears': numberOfInvestmentYears,
      'profitPercentageAnnuallyText': profitPercentageAnnuallyText,
    };
  }
}


class UniformCalculationAddress1 {
  final String addressTableProjectName; // Fixed variable name for clarity
  final int addressTableId;
  final String addressCalculationType;
  final String addressProvinceName;
  final String addressCityName;
  final String addressStreetName;
  final String addressBuildingNumber;
  final String addressPhoneNumber;
  final String addressOtherInfo;
  final double addressSociallyFriendly;
  final double addressEnvironmentallyFriendly;

  UniformCalculationAddress1({
    required this.addressTableProjectName,
    required this.addressTableId,
    required this.addressCalculationType,
    required this.addressProvinceName,
    required this.addressCityName,
    required this.addressStreetName,
    required this.addressBuildingNumber,
    required this.addressPhoneNumber,
    required this.addressOtherInfo,
    required this.addressSociallyFriendly,
    required this.addressEnvironmentallyFriendly,
  });

  // Method to convert the object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'uniformCalculationAddressProjectName': addressTableProjectName,
      'uniformCalculationAddressTableId': addressTableId,
      'calculationType': addressCalculationType,
      'ProvinceName': addressProvinceName,
      'CityName': addressCityName,
      'StreetName': addressStreetName,
      'BuildingNumber': addressBuildingNumber,
      'PhoneNumber': addressPhoneNumber,
      'OtherInfo': addressOtherInfo,
      'socially_friendly': addressSociallyFriendly,
      'environmentally_friendly': addressEnvironmentallyFriendly,
    };
  }
}


class UniformCalculationPage1 extends StatefulWidget {
  final String givenUniformProjectName;

  const UniformCalculationPage1({super.key, required this.givenUniformProjectName,});


@override
State<UniformCalculationPage1> createState() => _UniformCalculationPage1State();
}

class _UniformCalculationPage1State extends State<UniformCalculationPage1> {

  final TextEditingController _landAreaController = TextEditingController();
  final TextEditingController _landPricePerMeterController = TextEditingController();
  final TextEditingController _numberOfSaleableFloorsController = TextEditingController();
  final TextEditingController _numberOfCommonFloorsController = TextEditingController();
  final TextEditingController _buildabilityPercentageOrAreaController = TextEditingController();
  final TextEditingController _floorCommonAreaController = TextEditingController();
  final TextEditingController apartmentSellPricePerMeterController = TextEditingController();
  final TextEditingController constructionCostPerMeterController = TextEditingController();
  final TextEditingController permitCostController = TextEditingController();
  final TextEditingController otherCostController = TextEditingController();
  final TextEditingController totalNumberOfPropertiesController = TextEditingController();
  final TextEditingController numberOfInvestmentYearsController = TextEditingController();

  bool buildablePercentageRunTimeBoolValue = true;
  bool permitPerMeterBoolValue= true;
  double totalNumberOfFloorsValue = 0;
  late String uniformCalProjectName;
  bool _visible = false;
  bool calculatorVisible = false;
  late String responseId = '';
  bool isBannerVisible = true;


  @override
  void initState() {
    super.initState();

    uniformCalProjectName = widget.givenUniformProjectName;
    if (uniformCalProjectName != 'wwmm'){
      checkUniformCalculationData(uniformCalProjectName);}

  }

    @override
    void dispose() {
      super.dispose();
    }

  // Method to determine if fields should be read-only
  bool _isFieldReadOnly(TextEditingController controller) {
    // Check if project name is not 'wwmm' and if the controller is one of the specified controllers
    if (uniformCalProjectName != 'wwmm' && (controller == _landAreaController || controller == _landPricePerMeterController)) {
      return true; // Make these fields read-only
    }
    return false; // Otherwise, they are editable
  }


  void checkUniformCalculationData(String uniformCalProjectName) async {
    // Call the method to get simple calculation data for the given project name
    final uniformCalculationData = await UniformCalculationDatabase.getUniformCalculationData(uniformCalProjectName);

    // Check if the retrieved data is not empty
    if (uniformCalculationData.isNotEmpty) {
      // Assign the retrieved data to associated variables
      _landAreaController.text = uniformCalculationData[0].landAreaValueText;
      _landPricePerMeterController.text = uniformCalculationData[0].landPricePerMeter;
      _numberOfSaleableFloorsController.text = uniformCalculationData[0].numberOfSaleableFloorsValue.toString();
      _numberOfCommonFloorsController.text = (uniformCalculationData[0].totalNumberOfFloorsValue
          - uniformCalculationData[0].numberOfSaleableFloorsValue).toString(); // Adjust as needed
      _buildabilityPercentageOrAreaController.text = uniformCalculationData[0].buildabilityPercentageOrAreaValueText; // Adjust as needed
      _floorCommonAreaController.text = uniformCalculationData[0].floorCommonAreaText;
      apartmentSellPricePerMeterController.text = uniformCalculationData[0].apartmentSellPricePerMeterValueText; // Adjust as needed
      constructionCostPerMeterController.text = uniformCalculationData[0].constructionCostPerMeterText; // Adjust as needed
      setState(() {
        permitPerMeterBoolValue = (uniformCalculationData[0].permitBoolValue) == 1;
        buildablePercentageRunTimeBoolValue = (uniformCalculationData[0].buildabilityBoolIntValueClass) == 1;
      });

      permitCostController.text = uniformCalculationData[0].permitPerMeterOrTotalPermitCostText;
      /*permitPerMeterBoolValue ? (uniformCalculationData[0].permitPerMeterOrTotalPermitCostText) :
      (uniformCalculationData[0].totalPermitCostText);*/

      otherCostController.text = uniformCalculationData[0].otherCostValueText;
      totalNumberOfPropertiesController.text = uniformCalculationData[0].totalNumberOfProperties.toString(); // Adjust as needed

      numberOfInvestmentYearsController.text = uniformCalculationData[0].numberOfInvestmentYears.toString(); // Adjust as needed

    }
  }

  void showKeyboard() {
      setState(() {
        _visible = !_visible;
      }
      );
    }


    void showKeyboardCalculator() {
      setState(() {
        calculatorVisible = !calculatorVisible;
      });
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


  Widget _buildRowUniformCalculationPage1(
      BuildContext context,
      String labelText,
      String alertText,
      TextEditingController controller, {
        bool lastRow = false,
      })
  {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;

    // Adaptive sizes (use your predefined constants or define here)
    final double labelFontSize = isIpad ? 36 : 18.0;
    final double textFieldFontSize = isIpad ? 34 : 22.0;
    final double hintFontSize = isIpad ? 24.0 : 16.0;
    final double iconButtonSize = isIpad ? 46.0 : 28.0;
    final double rowHeight = isIpad ? 80.0 : 65.0;
    final double labelWidth = screenWidth * 0.4;
    final double iconButtonWidth = screenWidth * 0.1;
    final double spacingHeight = isIpad ? 16.0 : 10.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: rowHeight,
          width: labelWidth,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[700], // Background color for label container
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: EdgeInsets.all(isIpad ? 12.0 : 8.0),
              child: SingleChildScrollView(
                child: Text(
                  labelText,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: isIpad ? 10 : 5),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            onTap: () {
              if (_isFieldReadOnly(controller)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('It is a saved project and you cannot change this anymore. '
                        'To have a project with different land area and land price, '
                        'please define a new project.\n\n'),
                    duration: Duration(seconds: 5),
                  ),
                );
                return;
              }

              if (!_visible) {
                showKeyboard();
              }
            },
            showCursor: true,
            readOnly: _isFieldReadOnly(controller),
            autofocus: false,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.all(isIpad ? 12.0 : 8.0),
              hintStyle: TextStyle(fontSize: hintFontSize),
            ),
            style: TextStyle(fontSize: textFieldFontSize),
          ),
        ),
        SizedBox(
          width: iconButtonWidth,
          child: IconButton(
            iconSize: iconButtonSize,
            icon: Icon(Icons.help_outline, size: iconButtonSize,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      labelText,
                      style: TextStyle(
                        fontSize: textFieldFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Text(
                        alertText,
                        style: TextStyle(
                          fontSize: textFieldFontSize,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(

                        child: Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: textFieldFontSize,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }


    @override
    Widget build(BuildContext context) {
      double rowWidth = MediaQuery.of(context).size.width;

      final screenWidth = MediaQuery.of(context).size.width;
      const ipadBreakpoint = 850.0;
      final bool isIpad = screenWidth > ipadBreakpoint;

      // Use your adaptive constants or define them here
      const double buttonWidthPhone = 350.0;
      const double fontSizePhone = 18.0;
      const double titleFontSizePhone = 22.0;
      const double iconSizeLargePhone = 30.0;
      const double iconSizeSmallPhone = 28.0;
      const double rowHeightPhone = 60.0;

// iPad sizes (larger)
      final double buttonWidthPad = screenWidth *  0.5;
      const double fontSizePad = 36.0;
      const double titleFontSizePad = 40.0;
      const double iconSizeLargePad = 55.0;
      const double iconSizeSmallPad = 46.0;
      const double rowHeightPad = 70.0;

      final double labelFontSize = isIpad ? fontSizePad : fontSizePhone;
      final double textFieldFontSize = isIpad ? fontSizePad : fontSizePhone;
      final double titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
      final double hintFontSize = isIpad ? fontSizePad - 5 : fontSizePhone - 5;
      final double iconButtonSize = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
      final double rowHeight = isIpad ? rowHeightPad : rowHeightPhone;
      final double labelWidth = rowWidth * .3;
      final double iconButtonWidth = rowWidth * .1;
      final double spacingHeight = isIpad ? 16.0 : 6;

      return Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),color: Colors.black12,

          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25,),
                          _buildRowUniformCalculationPage1(context, 'Land Area', 'The total area of land or plot that needs to be '
                              'purchased for the project, upon which the construction will take place',
                              _landAreaController, ),
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(context,'Land Price (m²/ft²)', 'Land purchase price '
                              'per square foot or square meter',
                              _landPricePerMeterController),
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(context, 'Number of Saleable Floors',
                              'In this section of the app (Uniform Pricing), '
                                  'the term "saleable floors" refers to the floors of the building that have properties '
                                  'available for sale, separate '
                                  'from the property types which can be residential, commercial, administrative, or others, and '
                                  'separate from the areas of common spaces of these floors '
                                  'such as staircases which are not for sale.'
                                  '\n\nAlso, for simplicity in this section, all saleable floors are considered similar '
                                  'and their saleable area (usable area) is equal to each other; the remaining area of these floors '
                                  'is considered part of the building’s common area, '
                                  'however, the floor itself is defined within the group of saleable floors in this app'
                                  '.'
                                  ' \n\nFor example, if a building has four residential floors above a parking floor, '
                                  'it effectively has four saleable floors and one common floor that is the parking floor'
                                  '.'
                                  '\n\nIf you have floors with different built-up areas for saleable properties '
                                  'or want to sell each property at different prices, you should use the Differentiated '
                                  'Pricing section of this app.',
                              _numberOfSaleableFloorsController),
            
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(context,'Number of Common Floors',
                              'The total number of floors within a building that '
                              'are designated completely'
                              ' for common use, such as parking, lobbies, or utility areas. These floors do not '
                              'contain any properties available for separate sale. Even if ownership of a common '
                              'area is allocated to individual property holders, its value is inherently factored'
                              ' into their property\'s overall value and it is not a saleable asset on '
                              'its own.', _numberOfCommonFloorsController),
                          SizedBox(height: spacingHeight),
            
            Row(
              children: [
                SizedBox(
                  height: rowHeight,
                  width: labelWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isIpad ? 12 : 8.0),
                      child: Text(
                        'Built-up area of land',
                        style: TextStyle(fontSize: labelFontSize,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isIpad ? 10 : 5),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: rowHeight,
                    child: Center(
                      child: Transform.rotate(
                        angle: 1.5708,
                        child: Switch(
                          value: buildablePercentageRunTimeBoolValue,
                          onChanged: (value) {
                            setState(() {
                              buildablePercentageRunTimeBoolValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isIpad ? 10 : 5),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _buildabilityPercentageOrAreaController,
                    keyboardType: TextInputType.number,
                    onTap: () {

                      if (!_visible) {
                        showKeyboard();
                      }
                    },
                    showCursor: true,
                    readOnly: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: buildablePercentageRunTimeBoolValue ?
                       'Percentage' : "Area",
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(isIpad ? 14.0 : 8.0),
                      hintStyle: TextStyle(fontSize: hintFontSize),
                    ),
                    style: TextStyle(fontSize: textFieldFontSize * 1.2),
                  ),
                ),
                SizedBox(
                  width: iconButtonWidth,
                  child: IconButton(
                    iconSize: iconButtonSize,
                    icon: const Icon(Icons.help_outline, ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Built-up area on land',
                              style: TextStyle(
                                fontSize:  isIpad ? titleFontSizePad : titleFontSizePhone,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'This refers to the overall area on the ground '
                                          'assigned to construction, encompassing both common areas '
                                          '(such as staircases and elevators) and saleable floor areas '
                                          '(which are available for occupancy). The remaining land will be '
                                          'allocated for yards or other areas not classified '
                                          'as built-up space that typically require special permit fees.'
                                          '\n\nBe careful when using the switch: ',
                                      style: TextStyle(fontSize: isIpad ? 34 : 22),
                                    ),
                                    WidgetSpan(
                                      child: Transform.rotate(
                                        angle: 1.5708,
                                        child: Icon(
                                          Icons.toggle_on,
                                          size: isIpad ? iconSizeLargePad : iconSizeLargePhone,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: ' if it is on, you should enter the percentage of the land you want to '
                                          'allocate to construction. If the switch is off, you need to specify '
                                          'the exact area of land you wish to allocate for construction. '
                                          '\n\n▲ For example, if the switch is on and your land '
                                          'measures 500 square feet '
                                          'and you enter 60, the app will allocate 60% of your land '
                                          '(300) to your built-up area on the ground.'
                                          '\n\nAlternatively, if you prefer to set the built-up area on the '
                                          'ground yourself, you should turn the switch off and enter the desired area, '
                                          'in this example 300.'
                                          '\n\n■ If this area (here 300) is multiplied by the number of floors constructed, '
                                          'including all saleable and common floors '
                                          'whether above ground or underground, the total built-up area is '
                                          'obtained. This total built-up area, when multiplied by the '
                                          'construction cost per square meter/foot (defined later), will yield the '
                                          'total construction cost of the project. Additionally, if the total '
                                          'built-up area is multiplied by the permit cost per square meter/foot, '
                                          'it will produce the total permit cost associated with the project.'
                                          '\n\n■ If this area (here 300) is multiplied by the number of Saleable Floors, '
                                          'the total saleable area is calculated. Then, by multiplying the total saleable '
                                          'area by the selling price per square foot/meter, the total income is calculated.',
                                      style: TextStyle(fontSize: isIpad ? 34 : 22),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    fontSize: textFieldFontSize,color: Colors.purple
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
                    },
                  ),
                ),
              ],
            ),
                           SizedBox(height: spacingHeight),
            
                          _buildRowUniformCalculationPage1(context,'Common Area in each Floor',
                                  'Each floor of a property in this part of the app, Uniform Pricing, is divided into two parts: '
                                  '\n\n▶ The saleable area, also known as the usable area, '
                                  '\n▶ The common area that includes '
                                  'spaces with common usage such as staircases, elevators, and non-habitable areas that are not '
                                  'available for sale. '
                                  '\n\nWhen you set the common area in each floor the rest of built-up area in that floor '
                                      'will be considered as the saleable area.'
                                      '\n\nThe common area may also include the area of walls, depending on local regulations.'
                                  '\n\n▲ For example, if a property has a total area of 1,000 square feet, and 100 '
                                  'square feet is designated for areas such as staircases and elevators, '
                                  'with an additional 10 square feet occupied by walls, local policies may '
                                  'dictate that the remaining 890 square feet is considered the saleable area '
                                  'for sale. In this case, the common area would total 110 square feet. '
                                  '\n\nHowever, some cities might have different policies. For instance, in certain '
                                  'jurisdictions, the area occupied by walls may be included in the saleable '
                                  'area calculation. Thus, if the same property is assessed under such '
                                  'regulations, it might be considered to have 900 square feet of saleable '
                                  'area and only 100 square feet designated as common area. This variation '
                                  'in local policies can significantly impact the classification of space within a property.',
                              _floorCommonAreaController,
                              lastRow: true),
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(context, 'Sell Price \n(m²/ft²)','The Sell price for each square meter (m²) or '
                              'square foot (ft²) of saleable area within a property. \n\nThe saleable area refers to '
                              'the livable or occupiable space, excluding common areas, and may include walls '
                              'and non-habitable spaces as defined by local regulations. This metric is used '
                              'to determine the overall property price by multiplying the sell price per square '
                              'meter/foot by the total saleable area, contributing to the total income of the project.',
                              apartmentSellPricePerMeterController),
                          SizedBox(height: spacingHeight),
            
                          _buildRowUniformCalculationPage1(context, 'Construction Cost (m²/ft²)',
                              'Construction cost per square meter (m² or sqm) or per square foot (ft² or sqft) '
                                  'refers to the cost for constructing each square meter or square foot of the built-up area.'
                                  ' \n\nThe construction cost per m²/ft² is calculated '
                                  'by taking the total construction cost and dividing it by '
                                  'the total built-up area, which includes both saleable '
                                  'and common spaces. '
            
                              '\n\n■ Construction cost per square meter is calculated by dividing total construction cost '
                                'by total built-up area. Total construction cost includes:\n'
                                '- Building materials and equipment costs\n'
                                '- Labor costs including workers and engineers wages\n'
                                '- Utility connection fees (water, etc.)\n'
                                '- Costs for all building sections including foundation, structure, walls, roofs, stairs, '
                                'and other parts like courtyards and roofs that are not counted as built-up area.\u202b\n\n'
            
                                  '▲ For instance, if a building has a total '
                                  'built-up area of 1,000 square feet and the total construction cost '
                                  'is \$200,000, the construction cost per square foot would be \$200 (\$200,000 ÷ 1,000 ft²). '
            
                                  '\n\nSince you don\'t know the total construction cost of the project '
                                  'before starting (to divide by the total built-up area and calculate the '
                                  'cost per square meter, and to ensure accuracy in estimating construction '
                                  'costs, it is crucial to gather '
                                  'as most reliable and up-to-date construction cost per square foot '
                                  'from knowledgeable sources, such '
                                  'as developers, real estate brokers, and construction professionals familiar '
                                  'with similar projects in the region where you intend to invest.'
            
                                  '\n\nIn Uniform Pricing part of this app, the construction cost of both saleable '
                                  'and common areas is considered equal, and it is assumed that all floors '
                                  'have the same construction cost per m²/ft². '
                                  'However, if you wish to have different construction costs on each '
                                  'unit, floor or across various floors, use the Differentiated Pricing part.',
                              constructionCostPerMeterController),
                          SizedBox(height: spacingHeight),
                          Row(
                            children: [
                              SizedBox(
                                height: rowHeight,
                                width: rowWidth * .4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[700],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(isIpad ? 12.0 : 8.0),
                                    child: Text(
                                      'Permit Cost (m²/ft²)',
                                      style: TextStyle(fontSize: labelFontSize
                                          , color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: isIpad ? 10 : 2),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: rowHeight,
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: 1.5708,
                                      child: Switch(
                                        value: permitPerMeterBoolValue,
                                        onChanged: (value) {
                                          setState(() {
                                            permitPerMeterBoolValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: isIpad ? 10 : 2),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: permitCostController,
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                    if (!_visible) {
                                      showKeyboard();
                                    }
                                  },
                                  showCursor: true,
                                  readOnly: false,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: permitPerMeterBoolValue ? 'Per meter' : "Total Permit Cost",
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: const OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(isIpad ? 12.0 : 8.0),
                                    hintStyle: TextStyle(fontSize: hintFontSize),
                                  ),
                                  style: TextStyle(fontSize: textFieldFontSize * 1.2),
                                ),
                              ),
                              SizedBox(
                                width: rowWidth * .1,
                                child: IconButton(
                                  iconSize: iconButtonSize,
                                  icon: Icon(Icons.help_outline, size: iconButtonSize,),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Permit Cost',  style: TextStyle(
                                            fontSize: isIpad ? titleFontSizePad : titleFontSizePhone,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '\nPermit cost refers to the fee charged by city authorities '
                                                        'to grant permit for construction projects. If the switch '
                                                        'is on, you should enter the cost per square meter (or square foot), '
                                                        'which will be multiplied by the total built-up area to '
                                                        'calculate the total permit cost. Alternatively, if you prefer '
                                                        'to specify the total permit costs yourself, you can turn the '
                                                        'switch off and enter the amount directly.'
                                                        '\n\n▲ For instance, if a building has a total '
                                                        'built-up area of 1,000 square feet and you keep switch on and enter 200'
                                                        ' the permit fee will be considered \$200 '
                                                        'therefore total permit fee will be \$200,000.'
                                                        ' But if you turn switch to On, and enter 200,000 similarly the '
                                                        'total permit fee will be \$200,000. '
                                                        '\n\nThe permit cost per m²/ft² is typically determined '
                                                        'by local authorities based on factors such as the zoning regulations, '
                                                        'type of construction, and the overall size of the project. '
                                                        'It is a mandatory fee that must be paid to obtain the necessary '
                                                        'approvals and permits before commencing construction.'
                                                        'To calculate the total permit cost, the permit cost per '
                                                        'm²/ft² is multiplied by the total built-up area, '
                                                        'which includes both saleable and common spaces across all floors, '
                                                        'whether above or below ground. This total built-up area is '
                                                        'obtained by multiplying the built-up area on the ground by '
                                                        'the number of floors.',
                                                    style: TextStyle(fontSize: isIpad ? 34 : 22),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'Ok',
                                                style: TextStyle(fontSize: textFieldFontSize,color: Colors.purple),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
            
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(context, 'Other Cost',
                             'Any other costs such as financial consultation expenses, transaction '
                                 'costs, professional fees (legal, accounting, etc.), and'
                                 ' similar items are not calculated per square meter/foot, so '
                                 'enter them here in total, NOT per square meter/foot.'
                                 '\n\nThis category is also commonly called Overhead Costs '
                                 'or Indirect Costs. These are the indirect, ongoing expenses '
                                 'required to run the business but not directly tied to a specific'
                                 ' construction project\'s direct labor, materials, or equipment.'

                              '\n\nExamples of Overhead:'

                              '\n\n- Office Expenses: Rent, utilities, insurance, property taxes.'

                              '\n\n- Administrative Salaries: Wages for management, accounting, human resources (HR), and other office support staff.'

                              '\n\n- Marketing and Advertising: Costs for business development.'

                              '\n\n- Professional Fees: General legal and accounting retainers.'

                                  '\n\n- Office Operations: Equipment, supplies, and software subscriptions (e.g., project management software).'

                              '\n\n- General Liability Insurance (corporate portion).'

                            '\n\nSince many transaction costs are administrative, legal, or '
                                 'management-related, they are appropriately included '
                                 'within this broader category of Overhead Costs.',
                              otherCostController),
                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(
                            context,
                            'Number of Properties',
                            'The total number of saleable properties across all floors. For example, '
                                'if a building has 4 floors with 2 properties each, '
                                'enter 8 as the total number of constructed properties. \n\nThis number '
                                'helps us compare different projects built with '
                                'different capital amounts more easily in terms of the number of constructed properties. '
                                '\n\nHaving human development approach, between different projects runnable with a fixed capital amount, such as 1000,000\$, '
                                'the project that produces more properties (residential, office, commercial) '
            
                                'has higher productivity in terms of property production. '
                                'So it is more effective because more number of families and individuals have '
                                'access property for living or working that will decrease inequality in the society.',
                            totalNumberOfPropertiesController,
                          ),

                          SizedBox(height: spacingHeight),
                          _buildRowUniformCalculationPage1(
                            context,
                              'Investment Period',
                              'The number of years you expect the investment in the '
                                  'project to take, from the start of construction'
                                  ' until the sell of all units, when the profit or '
                                  'loss of the project is fully determined.'
                                  '\n\nFor example, if the project is built in one year'
                                  ' and you anticipate that it will take two years to sell all the units'
                                  ' you should enter the number 3 as the investment period.'
                                  '\n\nYou must enter this time period in years, i.e.'
                                  ' If a project takes 16 months, enter 1.25 and '
                                  ' If it takes 18 months, enter 1.5',
                            numberOfInvestmentYearsController, lastRow: true),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 6,),
                    IconButton(
                        icon: Icon(Icons.home,  color: Colors.purple[900]
                          , size: iconButtonSize * 1.3,),
                        onPressed: () {
                          NavigationService().navigateToScreen(
                            const AllProjectsPage(),
                          );
                        }),
                    IconButton(
                      icon:  Icon(Icons.analytics,  color: Colors.purple[900]
                        ,size: iconButtonSize * 1.3,),
                      onPressed: () {
                        if (_landAreaController.text.isNotEmpty &&
                            isValidNumber(_landAreaController.text.replaceAll(',', '')) && // Check for valid number
                            _landPricePerMeterController.text.isNotEmpty &&
                            isValidNumber(_landPricePerMeterController.text.replaceAll(',', '')) && // Check for valid number
                            _numberOfSaleableFloorsController.text.isNotEmpty &&
                            isValidNumber(_numberOfSaleableFloorsController.text.replaceAll(',', '')) && // Check for valid number
                            _numberOfCommonFloorsController.text.isNotEmpty &&
                            isValidNumber(_numberOfCommonFloorsController.text.replaceAll(',', '')) && // Check for valid number
                            _floorCommonAreaController.text.isNotEmpty &&
                            isValidNumber(_floorCommonAreaController.text.replaceAll(',', '')) && // Check for valid number
                            _buildabilityPercentageOrAreaController.text.isNotEmpty &&
                            isValidNumber(_buildabilityPercentageOrAreaController.text.replaceAll(',', '')) && // Check for valid number

                            ( (buildablePercentageRunTimeBoolValue && (double.parse(_buildabilityPercentageOrAreaController.text.replaceAll(',', '')) <= 100))

                                || (!buildablePercentageRunTimeBoolValue &&
                                    (double.parse((_buildabilityPercentageOrAreaController.text.replaceAll(',', '')))
                                        <= double.parse(_landAreaController.text.replaceAll(',', '')))))

                            && apartmentSellPricePerMeterController.text.isNotEmpty &&
                            isValidNumber(apartmentSellPricePerMeterController.text.replaceAll(',', '')) && // Check for valid number
                            constructionCostPerMeterController.text.isNotEmpty &&
                            isValidNumber(constructionCostPerMeterController.text.replaceAll(',', '')) && // Check for valid number
                            permitCostController.text.isNotEmpty &&
                            isValidNumber(permitCostController.text.replaceAll(',', '')) && // Check for valid number
                            otherCostController.text.isNotEmpty &&
                            isValidNumber(otherCostController.text.replaceAll(',', '')) &&
                            numberOfInvestmentYearsController.text.isNotEmpty &&
                            isValidNumber(numberOfInvestmentYearsController.text.replaceAll(',', ''))
                        ) {

                          totalNumberOfFloorsValue = double.parse(_numberOfSaleableFloorsController.text) +
                              double.parse(_numberOfCommonFloorsController.text);

                          double apartmentSellPricePerMeter = double.parse(apartmentSellPricePerMeterController.text.replaceAll(',', '')) ;

                          {// InterstitialAdManager.showInterstitial();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultUniformCalculationPage(
                                  shouldRetrieveData: 0,
                                  givenResultUniformProjectName: uniformCalProjectName,
                                  landAreaValue: double.parse(_landAreaController.text.replaceAll(',', '')),
                                  landPricePerMeter: double.parse(_landPricePerMeterController.text.replaceAll(',', '')),
                                  buildabilityPercentageOrAreaValue: double.parse(_buildabilityPercentageOrAreaController.text.replaceAll(',', '')),
                                  floorCommonAreaValue: double.parse(_floorCommonAreaController.text.replaceAll(',', '')),
                                  constructionCostPerMeterValue: double.parse(constructionCostPerMeterController.text.replaceAll(',', '')),
                                  otherCostValue: double.parse(otherCostController.text.replaceAll(',', '')),
                                  permitPerMeterBoolValue: permitPerMeterBoolValue ? 1 : 0,
                                  permitPerMeterOrTotalCostValue: double.parse(permitCostController.text.replaceAll(',', '')),
                                  totalNumberOfFloorsValue: totalNumberOfFloorsValue,
                                  numberOfSaleableFloorsValue: double.parse(_numberOfSaleableFloorsController.text.replaceAll(',', '')),
                                  apartmentSellPricePerMeterValue: apartmentSellPricePerMeter,
                                  buildablePercentageBoolValueResult: buildablePercentageRunTimeBoolValue ? 1 : 0,
                                  totalNumberOfPropertiesValue: double.parse(totalNumberOfPropertiesController.text.replaceAll(',', '')),
                                  numberOfInvestmentYearsValue: double.parse(numberOfInvestmentYearsController.text.replaceAll(',', '')),
                                ),
                              ),
                            );
                          }
                        } else if ((buildablePercentageRunTimeBoolValue && _buildabilityPercentageOrAreaController.text.isNotEmpty &&
                            double.parse(_buildabilityPercentageOrAreaController.text.replaceAll(',', '')) > 100) ||
                            (!buildablePercentageRunTimeBoolValue && (double.parse((_buildabilityPercentageOrAreaController.text.replaceAll(',', '')))
                                > double.parse(_landAreaController.text.replaceAll(',', ''))))
                            || (_floorCommonAreaController.text.isNotEmpty && double.parse(_floorCommonAreaController.text.replaceAll(',', ''))>=
                                double.parse(_landAreaController.text.replaceAll(',', '')) )
                            || (numberOfInvestmentYearsController.text.isNotEmpty &&
                                (double.parse(numberOfInvestmentYearsController.text.replaceAll(',', ''))== 0)
                            )) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:  const Text('Error', style: TextStyle(
                                  fontSize: titleFontSizePad,color: Colors.brown
                                  ,fontWeight: FontWeight.bold,
                                ),),
                                content:  Text('Percentage can not be bigger than 100. If you'
                                    ' have chosen to enter built-up area in the ground directly '
                                    'not as a percentage of land area, the value you enter as the built-up area'
                                    ' should not be bigger than the land area. Also, '
                                    'the common area can not be equal or bigger than the land area.\n\n'
                                  ,  style: TextStyle(fontSize: textFieldFontSize, ),),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(fontSize: isIpad ? 44 : 16,color: Colors.red),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:  const Text('Error', style: TextStyle(
                                  fontSize: titleFontSizePad,color: Colors.brown,fontWeight: FontWeight.bold,
                                ),),
                                content:  Text(
                                    'Please fill all required fields. Inputs should be valid numbers '
                                        '(digits and an optional decimal point only, like: 123, 123.5, '
                                        '0.66) and must not include letters (e.g., a, b, c) or symbols '
                                        '(e.g., \$, %, &). Additionally, trailing (e.g., .1)'
                                        ' decimal points are not allowed.\n\n',
                                    style: TextStyle(
                                      fontSize: textFieldFontSize,)),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(fontSize: textFieldFontSize
                                          ,color: Colors.red),
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
                    ),
            
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                   title:  Text('\nConstruction profit calculator with uniform pricing', style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.green[600],fontWeight: FontWeight.bold,
                            ),),
                              content: SingleChildScrollView(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                       TextSpan(
                                        text: '\nThis is a financial calculator specifically designed for analyzing the cost '
                                            'benefits of constructing a building. \n\nFor every data entry,'
                                            ' a ',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.help_outline, // The icon you want to display
                                          size: iconButtonSize, // Set the size of the icon
                                          color: Colors.red, // Set the color of the icon
                                        ),
                                      ),
                                       TextSpan(
                                        text: ' icon is provided to clearly explain what information is required. Finally, press ',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.analytics, // The icon you want to display
                                          size: iconButtonSize, // Set the size of the icon
                                          color: Colors.deepPurple, // Set the color of the icon
                                        ),
                                      ),
                                       TextSpan(
                                        text: ' to get the results. An example of a project is provided at the bottom of this page.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
            
            
            
                                       TextSpan(
                                        text: '\n\nTo effectively utilize this calculator, please gather as much updated data as '
                                            'possible of prices and costs from professionals in the market '
                                            'and enter them In their associated text fields by following the guidelines below:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n\nKey Steps to Use This Calculator',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.pink,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nProject\'s Physical Data',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.blue,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\nEnter the relevant physical project information, such as:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n- Land area',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n- Saleable area',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n- Number of floors',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nPrice/Cost Data of the Project',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.blue,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\nEnter the relevant price data of the project, including:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n- Sell Price: Specify the sell price of the saleable area.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n- Costs: You will need to define two types of costs associated with '
                                            'each square meter/foot of the built-up area:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n  • Construction Costs per Square Meter/Foot (m²/ft²)',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n  • Permit Costs',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nImportant Notes',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.pink,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ In this part of the app called Uniform Pricing, each floor of the building is categorized as either a Common floor or a Saleable floor:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n1. Common Floors: These floors do not contain any properties or '
                                            'spaces available for sale, such as parking floor, but still incur construction and permit costs. '
                                            'If your project has no common floors, enter zero for the number of common floors.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n2. Saleable Floors: These floors contain at least one property for sale. '
                                            'Each saleable floor consists of two parts:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n1) The saleable area that is available for sale as residential or commercial space. '
                                            ,
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n2) A common area designated for elevators and staircases '
                                            '(which is not saleable but still incurs construction and permit costs).'
                                            '\n\nIn the Uniform Pricing part, all saleable floors in a construction project'
                                            ' will be considered the same in terms of the common area, saleable area, '
                                            'and their associated sell price and costs. Also:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ The area of all floors, whether common or saleable, will be equal to the percentage of land that you choose. The total area of all floors will be considered the total built-up area.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ The sell price will be considered equal for all saleable properties and across all floors. Similarly, construction costs and permit costs will be considered equal for all built-up areas.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                    /*  TextSpan(
                                        text: '\n\n■ Typically, the construction cost of the yard and roof is included in the overall construction cost of the built-up area. However, if this is not the case, you should either break down the cost of constructing the yard and roof within the construction cost per square meter/foot, or add it to the other costs.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nFor example, if the construction cost of yard and rooftop —including walls,'
                                        'garden, insulation, and floor covering— is \$50,000, and the total built-up area is 1,000 '
                                        'square feet with a construction cost of \$200 (ft²) (excluding yard and roof costs),'
                                         'you should calculate the following:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nDivide \$50,000 by 1,000 to get \$50. Then, add this amount to the base '
                                        'construction cost: \$200 + \$50 = \$250. This results in a construction cost of \$250 (ft²),'
                                         'which should be entered as the construction cost (ft²) of the project including yard and rooftop costs.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nAlternatively, you could enter the base construction cost of \$200 (ft²) and'
                                        ' add the \$50,000 to the "other costs" below.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),*/
                                       TextSpan(
                                        text: '\n\n■ The summation of the purchasing land cost, construction costs '
                                            ' and permit costs will produce the total costs associated with '
                                            'the project. This total cost will then be deducted from the total '
                                            'income generated by selling all properties (total saleable area),'
                                            ' resulting in the profit from the project.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ Note: Once you have saved a project, you cannot change the '
                                            'land area and land price. However, you can still modify the sell '
                                            'price and other details to see their effects on the results. '
                                            'If you wish to change the land area or land price, you must create a new project.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ The uniformity of sell prices, construction costs, and permit costs across '
                                       ' floors is a feature of this part of the app, known as the "Uniform Pricing". '
                                        'However, in the "Differentiated Pricing", you can define different sell prices and costs '
                                        'for each square feet, and even specify different areas for each floor. '
                                            '\n\nBelow an example '
                                            'is provided to see how you can enter data of a construction project'
                                            ' and what results you would get after '
                                            'pressing the result icon.\n\n',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
            
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: Container(
                                            height: 2,
                                            width: 200, // Set a specific width or use MediaQuery
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nLand Area             200',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nLand Price (per sqft)        65',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nNumber of Saleable Floors            4',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nNumber of Common Floors            1',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nbuilt-up area of land (%)        70',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nCommon Area in each Floor           20',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nSelling Price (per sqft)        60',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nConstruction Cost (per sqft)        15',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nPermit Cost (per sqft)          1',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nOther Costs            10',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nNumber of Properties          5',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
            
            // Instruction text
                                       TextSpan(
                                        text: '\n\nResults\n',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
            
            // Results section
                                       TextSpan(
                                        text: 'Revenue           28,800',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nTotal Cost     24,210',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nProfit           4,590',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nProfit Percentage  %18.96\n\n',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
            
                                       TextSpan(
                                        text: 'In this app, you can easily '
                                            'see the changes in results by changing the variables. In the example above, if the selling price per square '
                                            'meter is 65 instead of 60, and the construction cost per square meter is 17  instead '
                                            'of 15, the following results are obtained.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
            
                                       TextSpan(
                                        text: '\n\nTotal Income      31,200',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nTotal Cost         25,610',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nProfit               5,590',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
                                       TextSpan(
                                        text: '\n\nProfit Percentage    21.83%\n\n',
                                        style: TextStyle(fontSize: textFieldFontSize, color: Colors.black),
                                      ),
            
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Container(
                                            height: 2,
                                            width: 200, // Set a specific width or use MediaQuery
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n■ To find a proper project both in terms of profitability and socio-economic '
                                            'effectiveness, it is better to enter data from different projects and several times '
                                            'change the prices and costs of each based on various market condition forecasts, and '
                                            'calculate the worst and best results. Because many prices and costs change during the'
                                            ' project execution period. \n\n■ The return on investment in projects, both '
                                            'in absolute and in percentage '
                                            'terms, should be compared over equal time periods, so divide the '
                                            'project profit by the project duration '
                                            'you think it will take to build and fully sell the building, to obtain the annual '
                                            'profit so that projects can be better compared with each other.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '\n\nExamples on Facebook (link on first page).',
                                      )
                                    ],
                                  ),
                                ),
                              ),
            
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(fontSize: textFieldFontSize,color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon:  Icon(Icons.help_center_rounded,
                          color: Colors.purple[900], size: iconButtonSize * 1.3),
                    ),
                    const SizedBox(width: 2,),
                  ],
                ),
                     //     const MyBannerAdWidget(),
                SizedBox(height: spacingHeight * 4,),
              ],
            ),
          ),
        ),
      );
    }
  }


///////////////////////////////////////////////////////////////// Result page
class ResultUniformCalculationPage extends StatefulWidget {
  final int shouldRetrieveData;
  final String givenResultUniformProjectName;
  final double landAreaValue;
  final double landPricePerMeter;
  final double buildabilityPercentageOrAreaValue;
  final double floorCommonAreaValue;
  final double otherCostValue;
  final int permitPerMeterBoolValue;
  final double permitPerMeterOrTotalCostValue;
  final double apartmentSellPricePerMeterValue;
  final int buildablePercentageBoolValueResult;
  final double constructionCostPerMeterValue;
  final double totalNumberOfFloorsValue;
  final double numberOfSaleableFloorsValue;
  final double totalNumberOfPropertiesValue;
  final double numberOfInvestmentYearsValue;

  const ResultUniformCalculationPage({
    super.key,
    required this.shouldRetrieveData,
    required this.givenResultUniformProjectName,
    required this.landAreaValue,
    required this.landPricePerMeter,
    required this.buildabilityPercentageOrAreaValue,
    required this.floorCommonAreaValue,
    required this.otherCostValue,
    required this.permitPerMeterBoolValue,
    required this.permitPerMeterOrTotalCostValue,
    required this.totalNumberOfFloorsValue,
    required this.numberOfSaleableFloorsValue,
    required this.apartmentSellPricePerMeterValue,
    required this.buildablePercentageBoolValueResult,
    required this.constructionCostPerMeterValue,
    required this.totalNumberOfPropertiesValue,
    required this.numberOfInvestmentYearsValue,
  });

  @override
  State createState() => _ResultUniformCalculationPageState();
}

/*class NewFinancialData {
  final String projectName;
  final String calculationName; // This identifies the Pricingtype
  final String costOfProject;
  final String incomeOfProject;
  final String profitOfProject;
  final String profitPercentageOfProject;

  NewFinancialData({
    required this.projectName,
    required this.calculationName,
    required this.costOfProject,
    required this.incomeOfProject,
    required this.profitOfProject,
    required this.profitPercentageOfProject,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'calculationName': calculationName,
      'costOfProject': costOfProject,
      'incomeOfProject': incomeOfProject,
      'profitOfProject': profitOfProject,
      'profitPercentageOfProject': profitPercentageOfProject,
    };
  }

// Override equality and hashCode if needed (optional)
}*/

class _ResultUniformCalculationPageState extends State<ResultUniformCalculationPage> {
  late double landAreaValue;
  late double landPricePerMeter;
  late double buildabilityPercentageOrAreaValue;
  late double floorCommonAreaValue;
  late double otherCostValue;
  late int permitPerMeterBoolValue;
  late double permitPerMeterOrTotalCostValue;
  late double apartmentSellPricePerMeterValue;
  late int shouldRetrieveData;
  late int givenBuildablePercentageBoolValue;
  late double constructionCostPerMeterValue;
  late double totalNumberOfFloorsValue;
  late double numberOfSaleableFloorsValue;
  late double totalNumberOfPropertiesValue;
  late String landAreaValueText;
  late String landPricePerMeterText;
  late String buildabilityPercentageOrAreaValueText;
  late String floorCommonAreaText;
  late String otherCostValueText;
  late String permitPerMeterOrTotalPermitCostText;
  late String apartmentSellPricePerMeterValueText;
  late String constructionCostPerMeterText;
  late String totalNumberOfFloorsValueText;
  late String numberOfSaleableFloorsValueText;
  late String totalNumberOfPropertiesValueText;
  late String totalIncomeText;
  late String totalCostText;
  late String profitText;
  late String profitPercentageText;
  late String floorConstructedLandAreaText;
  late String totalPermitCostText;
  late String totalUsefulAreaText;
  late String totalConstructedAreaText;
  late String costOfLandText;
  late String constructionCostOfAllFloorsText;
  late String floorUsefulAreaText;
  late String floorTotalPriceText;
  late String allCostsIncurredPerMeterOfUsefulAreaText;
  late String profitPerUsefulAreaText;
  late String profitPercentagePerUsefulAreaText;
  late String usefulAreaConstructedBy1BillionText;
  late String totalNumberOfPropertiesByTenXText;
  late String otherCostText;
  late String tenXOfTotalCostForUnit;
  late String uniformCalProjectName;
  late double numberOfInvestmentYearsValue;
  late String profitPercentageAnnuallyText;

  late int addressTableId;
  late String addressTableProjectName;
  late String addressCalculationType;
  late String addressProvinceName;
  late String addressCityName;
  late String addressStreetName;
  late String addressBuildingNumber;
  late String addressPhoneNumber;
  late String addressOtherInfo;
  late double addressSociallyFriendly;
  late double addressEnvironmentallyFriendly;
  // late InterstitialAdManager interstitialAdManager;

  int _isLoading = 1;
  final projectNameController = TextEditingController();
  final provinceController = TextEditingController();
  final environmentallyFriendlyController = TextEditingController();
  final sociallyFriendlyController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final buildingNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final otherInfoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    uniformCalProjectName = widget.givenResultUniformProjectName;
    _loadProjectData();

    // interstitialAdManager = InterstitialAdManager();
    // interstitialAdManager.loadInterstitialAd();
  }
  @override
  void dispose() {
    // interstitialAdManager.dispose(); // Dispose of the ad manager
    super.dispose();
  }
  void _loadProjectData() async {
    shouldRetrieveData = widget.shouldRetrieveData;
    if (widget.givenResultUniformProjectName == 'wwbb' || shouldRetrieveData == 0) {
      landAreaValue = widget.landAreaValue;
      landPricePerMeter = widget.landPricePerMeter;
      buildabilityPercentageOrAreaValue = widget.buildabilityPercentageOrAreaValue;
      floorCommonAreaValue = widget.floorCommonAreaValue;
      otherCostValue = widget.otherCostValue;
      permitPerMeterBoolValue = widget.permitPerMeterBoolValue;
      permitPerMeterOrTotalCostValue = widget.permitPerMeterOrTotalCostValue;
      apartmentSellPricePerMeterValue = widget.apartmentSellPricePerMeterValue;
      givenBuildablePercentageBoolValue = widget.buildablePercentageBoolValueResult;
      constructionCostPerMeterValue = widget.constructionCostPerMeterValue;
      totalNumberOfFloorsValue = widget.totalNumberOfFloorsValue;
      numberOfSaleableFloorsValue = widget.numberOfSaleableFloorsValue;
      totalNumberOfPropertiesValue = widget.totalNumberOfPropertiesValue;
      numberOfInvestmentYearsValue = widget.numberOfInvestmentYearsValue;
      await calculateResults(widget.givenResultUniformProjectName);
      setState(() {
        _isLoading = 0; // Update loading state
      }
      );
    } else {
      // Retrieve the project data from the database
      await retrieveUniformCalculationData(widget.givenResultUniformProjectName);

      setState(() {
        _isLoading = 0; // Update loading state
      });
    }
  }

  Future<void> calculateResults(String projectName) async {
    double floorConstructedLandArea = (givenBuildablePercentageBoolValue == 1) // Check if it's true
        ? ((buildabilityPercentageOrAreaValue * landAreaValue) * 0.01)
        : buildabilityPercentageOrAreaValue;
    double floorUsefulArea = floorConstructedLandArea - floorCommonAreaValue;
    double totalIncome = numberOfSaleableFloorsValue * floorUsefulArea * apartmentSellPricePerMeterValue;
    constructionCostPerMeterText = formatNumberWithThousandSeparator(constructionCostPerMeterValue);
    double totalConstructionCostOfFloor = floorConstructedLandArea * constructionCostPerMeterValue;
    permitPerMeterOrTotalPermitCostText = formatNumberWithThousandSeparator(permitPerMeterOrTotalCostValue);
    buildabilityPercentageOrAreaValueText = formatNumberWithThousandSeparator(buildabilityPercentageOrAreaValue);

    double constructionCostOfAllFloors = totalNumberOfFloorsValue * totalConstructionCostOfFloor ;
    double costOfLand = landAreaValue * landPricePerMeter;
    double totalPermitCost = (permitPerMeterBoolValue == 1) ?
    (permitPerMeterOrTotalCostValue * floorConstructedLandArea * totalNumberOfFloorsValue) :
    permitPerMeterOrTotalCostValue;

    double totalCost = constructionCostOfAllFloors + totalPermitCost+ otherCostValue +costOfLand;

    double profit = totalIncome - totalCost;
    double profitPercentage = ((totalIncome - totalCost) / totalCost) * 100;
    double profitPercentageAnnually = profitPercentage / numberOfInvestmentYearsValue;

    double totalUsefulArea = floorUsefulArea * numberOfSaleableFloorsValue;
    double totalConstructedArea = floorConstructedLandArea * totalNumberOfFloorsValue;


    // Add leading zeros to the total cost String based on the length
   /* int maxDivisibleByThree(num num) {
      String numStr = num.toString().split('.')[0];
      int numDigits = numStr.length;

      while (numDigits % 3 != 0) {
        numDigits--;
      }
      return  pow(10, numDigits-1).toInt();
    }*/

    tenXOfTotalCostForUnit = (completeThreeDigitBatches(totalCost)).toString();

    landPricePerMeterText = formatNumberWithThousandSeparator(landPricePerMeter);
    landAreaValueText = formatNumberWithThousandSeparator(landAreaValue);

    totalCostText = formatNumberWithThousandSeparator(totalCost);
    profitText = formatNumberWithThousandSeparator(profit);
    profitPercentageText = '%${formatNumberWithThousandSeparator(profitPercentage)}';
    profitPercentageAnnuallyText = '%${formatNumberWithThousandSeparator(profitPercentageAnnually)}';

    /////////// variables used in project result report

    floorCommonAreaText = formatNumberWithThousandSeparator(floorCommonAreaValue);
    apartmentSellPricePerMeterValueText = formatNumberWithThousandSeparator(apartmentSellPricePerMeterValue);
    floorConstructedLandAreaText = formatNumberWithThousandSeparator(floorConstructedLandArea);

    // while the real value of totalPermitCost is calculated for total cost here what the user entered
    // that might be pc per meter is saving in totalPermitCostText
    totalPermitCostText = formatNumberWithThousandSeparator(totalPermitCost);

    totalUsefulAreaText = formatNumberWithThousandSeparator(totalUsefulArea);
    totalConstructedAreaText = formatNumberWithThousandSeparator(totalConstructedArea);


    if (otherCostValue.toDouble() == 0.0 || otherCostValue == 0) {
      otherCostValueText = '0';
    } else {
      otherCostValueText = formatNumberWithThousandSeparator(otherCostValue);
    }

    totalIncomeText = formatNumberWithThousandSeparator(totalIncome);
    //  isDecimalZero(totalIncome) ? NumberFormat("#,###").format(totalIncome.toInt())
    //    : NumberFormat("#,###").format(totalIncome);

    costOfLandText = formatNumberWithThousandSeparator(costOfLand);
    constructionCostOfAllFloorsText = formatNumberWithThousandSeparator(constructionCostOfAllFloors);
    floorUsefulAreaText = formatNumberWithThousandSeparator(floorUsefulArea);

    double floorTotalPrice = apartmentSellPricePerMeterValue *(floorUsefulArea) ;
    floorTotalPriceText = formatNumberWithThousandSeparator(floorTotalPrice);

    double allCostsIncurredPerMeterOfUsefulArea = totalCost / (floorUsefulArea * numberOfSaleableFloorsValue );
    allCostsIncurredPerMeterOfUsefulAreaText = formatNumberWithThousandSeparator(allCostsIncurredPerMeterOfUsefulArea);

    double profitPerUsefulArea = (apartmentSellPricePerMeterValue-allCostsIncurredPerMeterOfUsefulArea);
    profitPerUsefulAreaText = formatNumberWithThousandSeparator(profitPerUsefulArea);

    double profitPercentagePerUsefulArea = 100 * (profitPerUsefulArea)/allCostsIncurredPerMeterOfUsefulArea;
    profitPercentagePerUsefulAreaText = '%${formatNumberWithThousandSeparator(profitPercentagePerUsefulArea)}';

    double usefulAreaConstructedByTenXX = (totalUsefulArea/totalCost)*(int.parse(tenXOfTotalCostForUnit)/10);
    usefulAreaConstructedBy1BillionText = formatNumberWithThousandSeparator(usefulAreaConstructedByTenXX);

    double totalNumberOfPropertiesByTenX =
        (totalNumberOfPropertiesValue/totalCost) * (int.parse(tenXOfTotalCostForUnit));
    totalNumberOfPropertiesByTenXText = formatNumberWithThousandSeparator(totalNumberOfPropertiesByTenX);
    tenXOfTotalCostForUnit = formatNumberWithThousandSeparator(int.parse(tenXOfTotalCostForUnit));

    if(projectName != 'wwbb') {
      final updatedUniformCalculationData = UniformCalculationClassData(
        uniformCalculationProjectName: projectName,
        uniformCalculationProjectId: await UniformCalculationDatabase.getNextUniformCalculationProjectID(),
        landAreaValueText: landAreaValueText,
        totalIncomeText: totalIncomeText,
        totalCostText: totalCostText,
        profitText: profitText,
        profitPercentageText: profitPercentageText,
        profitPercentageAnnuallyText: profitPercentageAnnuallyText,
        floorCommonAreaText: floorCommonAreaText,
        apartmentSellPricePerMeterValueText: apartmentSellPricePerMeterValueText,
        floorConstructedLandAreaText: floorConstructedLandAreaText,
        totalPermitCostText: totalPermitCostText,
        totalUsefulAreaText: totalUsefulAreaText,
        totalConstructedAreaText: totalConstructedAreaText,
        otherCostValueText: otherCostValueText,
        costOfLandText: costOfLandText,
        constructionCostOfAllFloorsText: constructionCostOfAllFloorsText,
        floorUsefulAreaText: floorUsefulAreaText,
        floorTotalPriceText: floorTotalPriceText,
        allCostsIncurredPerMeterOfUsefulAreaText: allCostsIncurredPerMeterOfUsefulAreaText,
        profitPerUsefulAreaText: profitPerUsefulAreaText,
        usefulAreaConstructedBy1BillionText: usefulAreaConstructedBy1BillionText,
        totalNumberOfPropertiesByTenXText: totalNumberOfPropertiesByTenXText,
        landPricePerMeter: landPricePerMeterText,
        tenXOfTotalCostForUnit: tenXOfTotalCostForUnit,
        totalNumberOfFloorsValue: totalNumberOfFloorsValue,
        numberOfSaleableFloorsValue: numberOfSaleableFloorsValue,
        totalNumberOfProperties: totalNumberOfPropertiesValue,
        profitPercentagePerUsefulAreaText: profitPercentagePerUsefulAreaText,
        permitPerMeterOrTotalPermitCostText: permitPerMeterOrTotalPermitCostText,
        buildabilityPercentageOrAreaValueText: buildabilityPercentageOrAreaValueText,
        constructionCostPerMeterText: constructionCostPerMeterText,
        permitBoolValue: permitPerMeterBoolValue, // == 1 ? true : false,
        buildabilityBoolIntValueClass: givenBuildablePercentageBoolValue,
        numberOfInvestmentYears: numberOfInvestmentYearsValue,
        // == 1 ? true : false,
      );
      // Save the simple calculation data
      await UniformCalculationDatabase.insertOrUpdateUniformCalculationData(updatedUniformCalculationData);


      await AllProjectsPageDatabase.updateAllProjectsPageData(
        projectName,
        'uniform',
        totalCostText,
        totalIncomeText,
        profitText,
        profitPercentageText,);
    }
  }

// currently not used
  Future<void> retrieveUniformCalculationData(String projectName) async {
    // Retrieve the simple calculation data for the given project name
    final uniformCalculationData = await UniformCalculationDatabase.getUniformCalculationData(projectName);

    // Check if the retrieved data is not empty
    if (uniformCalculationData.isNotEmpty) {

      // Set boolean values based on the retrieved data
      permitPerMeterBoolValue = (uniformCalculationData[0].permitBoolValue) ;

      givenBuildablePercentageBoolValue = (uniformCalculationData[0].buildabilityBoolIntValueClass) ;

      // Initialize text representation variables directly from the retrieved data
      landAreaValueText = uniformCalculationData[0].landAreaValueText;
      landPricePerMeterText = uniformCalculationData[0].landPricePerMeter;
      buildabilityPercentageOrAreaValueText = uniformCalculationData[0].buildabilityPercentageOrAreaValueText;
      floorCommonAreaText = uniformCalculationData[0].floorCommonAreaText;
      otherCostValueText = uniformCalculationData[0].otherCostValueText;
      permitPerMeterOrTotalPermitCostText = uniformCalculationData[0].permitPerMeterOrTotalPermitCostText;
      apartmentSellPricePerMeterValueText = uniformCalculationData[0].apartmentSellPricePerMeterValueText;
      constructionCostPerMeterText = uniformCalculationData[0].constructionCostPerMeterText;
      totalNumberOfFloorsValue = uniformCalculationData[0].totalNumberOfFloorsValue;
      numberOfSaleableFloorsValue = uniformCalculationData[0].numberOfSaleableFloorsValue;
      totalNumberOfPropertiesValue = uniformCalculationData[0].totalNumberOfProperties;
      totalIncomeText = uniformCalculationData[0].totalIncomeText;
      totalCostText = uniformCalculationData[0].totalCostText;
      profitText = uniformCalculationData[0].profitText;
      profitPercentageText = uniformCalculationData[0].profitPercentageText;
      profitPercentageAnnuallyText = uniformCalculationData[0].profitPercentageAnnuallyText;
      floorConstructedLandAreaText = uniformCalculationData[0].floorConstructedLandAreaText;
      totalPermitCostText = uniformCalculationData[0].totalPermitCostText;
      totalUsefulAreaText = uniformCalculationData[0].totalUsefulAreaText;
      totalConstructedAreaText = uniformCalculationData[0].totalConstructedAreaText;
      costOfLandText = uniformCalculationData[0].costOfLandText;
      constructionCostOfAllFloorsText = uniformCalculationData[0].constructionCostOfAllFloorsText;
      floorUsefulAreaText = uniformCalculationData[0].floorUsefulAreaText;
      floorTotalPriceText = uniformCalculationData[0].floorTotalPriceText;
      allCostsIncurredPerMeterOfUsefulAreaText = uniformCalculationData[0].allCostsIncurredPerMeterOfUsefulAreaText;
      profitPerUsefulAreaText = uniformCalculationData[0].profitPerUsefulAreaText;
      tenXOfTotalCostForUnit = uniformCalculationData[0].tenXOfTotalCostForUnit;
      profitPercentagePerUsefulAreaText = uniformCalculationData[0].profitPercentagePerUsefulAreaText;
      usefulAreaConstructedBy1BillionText = uniformCalculationData[0].usefulAreaConstructedBy1BillionText;
      totalNumberOfPropertiesByTenXText = uniformCalculationData[0].totalNumberOfPropertiesByTenXText;
    }
  }

  Future<void> retrieveUniformCalculationAddressData(String projectName) async {
    // Retrieve the simple calculation address data for the given project name
    final uniformCalculationAddressData = await UniformCalculationDatabase.getUniformCalculationAddressData(projectName);

    // Check if the retrieved data is not empty
    if (uniformCalculationAddressData.isNotEmpty) {
      // Initialize variables with retrieved data
      addressTableProjectName = uniformCalculationAddressData[0].addressTableProjectName;
      addressTableId = uniformCalculationAddressData[0].addressTableId;
      addressCalculationType = uniformCalculationAddressData[0].addressCalculationType;
      addressProvinceName = uniformCalculationAddressData[0].addressProvinceName;
      addressCityName = uniformCalculationAddressData[0].addressCityName;
      addressStreetName = uniformCalculationAddressData[0].addressStreetName;
      addressBuildingNumber = uniformCalculationAddressData[0].addressBuildingNumber;
      addressPhoneNumber = uniformCalculationAddressData[0].addressPhoneNumber;
      addressOtherInfo = uniformCalculationAddressData[0].addressOtherInfo;
      addressSociallyFriendly = uniformCalculationAddressData[0].addressSociallyFriendly;
      addressEnvironmentallyFriendly = uniformCalculationAddressData[0].addressEnvironmentallyFriendly;

    }
  }

  int completeThreeDigitBatches(num num) {
    String numStr = num.toString().split('.')[0];
    int numDigits = numStr.length;
    int ss = numDigits -2;  // Integer division
    return  pow(10, ss).toInt();
  }
  
  bool isDecimalZero(double number) {
    return number.truncateToDouble() == number;
  }

  Future<void> _showAddressDialog(BuildContext context) async {
    double rowWidth = MediaQuery.of(context).size.width;

    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;

    // Use your adaptive constants or define them here
    const double buttonWidthPhone = 350.0;
    const double fontSizePhone = 18.0;
    const double titleFontSizePhone = 22.0;
    const double iconSizeLargePhone = 30.0;
    const double iconSizeSmallPhone = 28.0;
    const double rowHeightPhone = 60.0;

// iPad sizes (larger)
    final double buttonWidthPad = screenWidth *  0.5;
    const double fontSizePad = 36.0;
    const double titleFontSizePad = 40.0;
    const double iconSizeLargePad = 55.0;
    const double iconSizeSmallPad = 46.0;
    const double rowHeightPad = 70.0;

    final double labelFontSize = isIpad ? fontSizePad : fontSizePhone;
    final double textFieldFontSize = isIpad ? fontSizePad : fontSizePhone;
    final double titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final double hintFontSize = isIpad ? fontSizePad - 5 : fontSizePhone - 5;
    final double iconButtonSize = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double rowHeight = isIpad ? rowHeightPad : rowHeightPhone;
    final double labelWidth = rowWidth * .3;
    final double iconButtonWidth = rowWidth * .1;
    final double spacingHeight = isIpad ? 16.0 : 6;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(''),
          content: SizedBox(
            width: isIpad ? buttonWidthPad : buttonWidthPhone,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: projectNameController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Project Name',
                            labelStyle: TextStyle(fontSize: isIpad ? 40 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: provinceController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Province',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                            color: Colors.purpleAccent,
                          ),
                          ),

                        ),
                        TextField(
                          controller: cityController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: streetController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Street',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: buildingNumberController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Building Number',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: phoneNumberController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: sociallyFriendlyController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Socially Friendly',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: environmentallyFriendlyController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration:  InputDecoration(
                            labelText: 'Environmentally Friendly',
                            labelStyle: TextStyle(fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        TextField(
                          controller: otherInfoController,
                          style: TextStyle(
                            fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Other Info',
                            labelStyle: TextStyle( fontSize: isIpad ? 30 : 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Check if the project name is empty and is not wwbb
                    if (projectNameController.text.isEmpty || projectNameController.text== 'wwbb') {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:  const Text(''),
                            content:  Text('Please enter a project name.',
                              style: TextStyle(
                                fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                                color: Colors.black87,
                              ),),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the popup
                                },
                                child:  Text('OK',style: TextStyle(
                                  fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                                  color: Colors.black87,
                                ),),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else {

                      final String projectNameControllerText = projectNameController.text;
                      final List<String> existingUniformCalculationProjectNames =
                      await UniformCalculationDatabase.getAllUniformCalculationProjectNames();

                      if (existingUniformCalculationProjectNames.contains(projectNameControllerText) &&
                          projectNameControllerText != uniformCalProjectName) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('A Uniform Pricing project with this name '
                                  'already exists. Please choose another name.\n\n',
                                style: TextStyle(
                                  fontSize: isIpad ? 36 : 18,  // Value text size (matches your constants)
                                  color: Colors.black87,
                                ),),
                              backgroundColor: const Color(0xFF9A87BE),
                            ),
                          );
                        }
                      } else {
                        if (uniformCalProjectName != projectNameController.text) {
                          await UniformCalculationDatabase
                              .updateProjectNameInAllUniformCalculationTables(
                            projectNameController.text,
                            uniformCalProjectName,
                          );
                          // Update the project name in your state management solution
                          // context.read<UniformCalculationProjectData>().setProjectName(projectNameController.text);
                          //  uniformCalProjectName = context.read<UniformCalculationProjectData>().projectName;
                          uniformCalProjectName = projectNameController.text;
                        }

                        final UniformCalculationAddress1 uniformCalculationAddress1 = UniformCalculationAddress1(
                          addressTableProjectName: projectNameController.text,
                          addressTableId: await UniformCalculationDatabase.getNextUniformCalculationAddressID(),
                          addressCalculationType: 'uniform', // Assuming this is a Uniform Pricing project
                          addressProvinceName: provinceController.text,
                          addressCityName: cityController.text,
                          addressStreetName: streetController.text,
                          addressBuildingNumber: buildingNumberController.text,
                          addressPhoneNumber: phoneNumberController.text,
                          addressOtherInfo: otherInfoController.text,
                          addressSociallyFriendly: double.tryParse(sociallyFriendlyController.text) ?? 1,
                          addressEnvironmentallyFriendly: double.tryParse(environmentallyFriendlyController.text) ?? 1,
                        );

                        await UniformCalculationDatabase.insertOrUpdateUniformCalculationAddressData(uniformCalculationAddress1);


                        // Initialize the variable from the result Pricing into the class for saving into the database
                        final updatedUniformCalculationData = UniformCalculationClassData(
                          uniformCalculationProjectName: projectNameController.text,
                          uniformCalculationProjectId: await UniformCalculationDatabase.getNextUniformCalculationProjectID(),
                          landAreaValueText: landAreaValueText,
                          totalIncomeText: totalIncomeText,
                          totalCostText: totalCostText,
                          profitText: profitText,
                          profitPercentageText: profitPercentageText,
                          profitPercentageAnnuallyText: profitPercentageAnnuallyText,

                          floorCommonAreaText: floorCommonAreaText,
                          apartmentSellPricePerMeterValueText: apartmentSellPricePerMeterValueText,
                          floorConstructedLandAreaText: floorConstructedLandAreaText,
                          totalPermitCostText: totalPermitCostText,
                          totalUsefulAreaText: totalUsefulAreaText,
                          totalConstructedAreaText: totalConstructedAreaText,
                          otherCostValueText: otherCostValueText,
                          costOfLandText: costOfLandText,
                          constructionCostOfAllFloorsText: constructionCostOfAllFloorsText,
                          floorUsefulAreaText: floorUsefulAreaText,
                          floorTotalPriceText: floorTotalPriceText,
                          allCostsIncurredPerMeterOfUsefulAreaText: allCostsIncurredPerMeterOfUsefulAreaText,
                          profitPerUsefulAreaText: profitPerUsefulAreaText,
                          usefulAreaConstructedBy1BillionText: usefulAreaConstructedBy1BillionText,
                          totalNumberOfPropertiesByTenXText: totalNumberOfPropertiesByTenXText,
                          landPricePerMeter: landPricePerMeterText,
                          tenXOfTotalCostForUnit: tenXOfTotalCostForUnit,
                          totalNumberOfFloorsValue: totalNumberOfFloorsValue,
                          numberOfSaleableFloorsValue: numberOfSaleableFloorsValue,
                          totalNumberOfProperties: totalNumberOfPropertiesValue,
                          profitPercentagePerUsefulAreaText: profitPercentagePerUsefulAreaText,
                          permitPerMeterOrTotalPermitCostText: permitPerMeterOrTotalPermitCostText,
                          buildabilityPercentageOrAreaValueText: buildabilityPercentageOrAreaValueText,
                          constructionCostPerMeterText: constructionCostPerMeterText,
                          permitBoolValue: permitPerMeterBoolValue, // == 1 ? true : false,
                          buildabilityBoolIntValueClass: givenBuildablePercentageBoolValue,
                          numberOfInvestmentYears: numberOfInvestmentYearsValue, // == 1 ? true : false,
                        );

                        // Save the Uniform Pricing data
                        await UniformCalculationDatabase.insertOrUpdateUniformCalculationData(updatedUniformCalculationData);

                        // to insert Data In to AllProjectsTable
                        uniformCalProjectName = projectNameController.text;
                        String cityName = cityController.text.isEmpty ? '' : cityController.text;
                        String streetName = streetController.text.isEmpty ? '' : streetController.text;
                        String calculationName = 'uniform';
                        double? environmentallyFriendly = environmentallyFriendlyController.text.isEmpty
                            ? 1
                            : double.tryParse(environmentallyFriendlyController.text);
                        double? sociallyFriendly = sociallyFriendlyController.text.isEmpty
                            ? 1
                            : double.tryParse(sociallyFriendlyController.text);

                        final AllProjectsPageData1 allProjectsPageDataArguments = AllProjectsPageData1(
                          allProjectsPageProjectName: projectNameController.text,
                          allProjectsPageCostOfProject: totalCostText,
                          allProjectsPageIncomeOfProject: totalIncomeText,
                          allProjectsPageProfitOfProject: profitText,
                          allProjectsPageProfitPercentageOfProject: profitPercentageText,
                          allProjectsPageEnvironmentallyFriendly: environmentallyFriendly!,
                          allProjectsPageSociallyFriendly: sociallyFriendly!,
                          allProjectsPageCity: cityName,
                          allProjectsPageStreet: streetName,
                          allProjectsPageCalculationName: calculationName,
                        );

                        await AllProjectsPageDatabase.insertOrUpdateAllProjectsPageData(allProjectsPageDataArguments);
                      }
                      // Close the popup
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } // else
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle:  const TextStyle(fontSize: 18),
                    backgroundColor: const Color.fromRGBO(
                        81, 23, 194, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child:  Padding(
                    padding: EdgeInsets.all(isIpad ? 20 : 10),
                    child: Text('Save Project',
                      style: TextStyle(
                      fontSize: isIpad ? 40 : 20,
                      fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

/*  String formatNumberWithThousandSeparator(num number) {
    String formattedNumber = number.toStringAsFixed(
      number.truncateToDouble() == number ? 0 : 1,
    );

    // Check if the decimal part is zero
    bool isDecimalZero = number.truncateToDouble() == number;

    if (isDecimalZero) {
      // Number is an integer or has a decimal part that starts with 0
      formattedNumber = NumberFormat("#,###").format(int.parse(formattedNumber));
    } else {
      // Number has a non-zero decimal part
      formattedNumber = NumberFormat("#,###.#").format(double.parse(formattedNumber));
    }
    return formattedNumber;
  }*/


  String formatNumberWithThousandSeparator(num number) {
    // Format the number based on whether it has decimal places or not
    String formattedNumber;

    // Check if the number is an integer
    bool isInteger = number.truncateToDouble() == number;

    if (isInteger) {
      // Number is an integer, format without decimals
      formattedNumber = NumberFormat("#,###").format(number);
    } else {
      // Number has a non-zero decimal part
      // Get the integer part
   //   int integerPart = number.truncate();

      // Get the decimal part and convert to double
     // double decimalPart = (number - integerPart).toDouble();

      // Format with up to two decimal places
      formattedNumber = NumberFormat("#,###.##").format(number);

      // Remove trailing zeros if both decimals are zero or only one decimal is non-zero
      formattedNumber = formattedNumber.replaceAll(RegExp(r'(\.0+|\.00)$'), '');
    }

    return formattedNumber;
  }


  Future<void> insertDataIntoAllProjectsTable(
      String projectName,
      String costOfProject,
      String incomeOfProject,
      String profitOfProject,
      String profitPercentageOfProject,
      double environmentallyFriendly,
      double sociallyFriendly,
      String city,
      String street,
      String calculationName,
      )
  async {
    final Database db = await AllProjectsPageDatabase.database; // Assuming you have a reference to the database instance

    final Map<String, dynamic> data = {
      AllProjectsPageDatabase.columnAllProjectsPageProjectName: projectName,
      AllProjectsPageDatabase.columnAllProjectsPageCostOfProject: costOfProject,
      AllProjectsPageDatabase.columnAllProjectsPageIncomeOfProject: incomeOfProject,
      AllProjectsPageDatabase.columnAllProjectsPageProfitOfProject: profitOfProject,
      AllProjectsPageDatabase.columnAllProjectsPageProfitPercentageOfProject: profitPercentageOfProject,
      AllProjectsPageDatabase.columnAllProjectsPageEnvironmentallyFriendly: environmentallyFriendly,
      AllProjectsPageDatabase.columnAllProjectsPageSociallyFriendly: sociallyFriendly,
      AllProjectsPageDatabase.columnAllProjectsPageCity: city,
      AllProjectsPageDatabase.columnAllProjectsPageStreet: street,
      AllProjectsPageDatabase.columnAllProjectsPagePricingType: calculationName,
    };

    await db.insert(
      AllProjectsPageDatabase.tableAllProjectsPageData,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading == 1) {
      // Display a loading indicator while data is being fetched
      return const Center(child: CircularProgressIndicator());
    }

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

    const ipadBreakpoint = 850.0; // or your preferred breakpoint


    final bool isIpad = screenWidth > ipadBreakpoint;

    final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
    final textFieldFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return Scaffold(

      body:Container(color: const Color.fromRGBO(41, 68, 88, 1.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isIpad ? 20 : 12),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                 //         const SizedBox(height: 30,),
                        _buildRowResultUniformCalculationPage(context, 'Income', totalIncomeText),
                        _buildRowResultUniformCalculationPage(context, 'Total Cost', totalCostText),
                        _buildRowResultUniformCalculationPage(context, 'Profit', profitText),
                        _buildRowResultUniformCalculationPage(context, 'Profit Percentage', profitPercentageText),

                        const SizedBox(height: 16),
                        Container(color: Colors.grey[200],
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                     TextSpan(text: 'The total land area is ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),),
                                    TextSpan(
                                      text: landAreaValueText,
                                      style:  TextStyle(color:  Colors.purple,
                                        fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(text: ' square meter/foot (m²/ft²), with ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),),
                                    TextSpan(
                                      text: floorConstructedLandAreaText,
                                      style:  TextStyle(color:  Colors.purple, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(text: ' m²/ft² allocated for construction. Of this, on each floor, ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),),
                                    TextSpan(
                                      text: floorUsefulAreaText,
                                      style:  TextStyle(color:  Colors.purple, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(text: ' m²/ft² is available for sale, and ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),),
                                    TextSpan(
                                      text: floorCommonAreaText,
                                      style:  TextStyle(color:  Colors.purple, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(text: ' m²/ft² is allocated for common usage such as staircases and elevator.',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),),
                                     TextSpan(
                                      text: ' The total built-up area of the project is ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: totalConstructedAreaText,
                                      style:  TextStyle(color:  Colors.purple, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                        text: ' m²/ft² and the total salable (usable) area is ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: totalUsefulAreaText,
                                      style:  TextStyle(color:  Colors.purple, fontSize: textFieldFontSize,),
                                    ),
                                   
                                     TextSpan(
                                      text: ' m²/ft².\n\nThe project total cost is \$',
                                       style: TextStyle(
                                       fontSize: textFieldFontSize,
                                     ),
                                    ),
                                    TextSpan(
                                      text: totalCostText,
                                      style:  TextStyle(color: const Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: '. This includes \$',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: costOfLandText,
                                      style:  TextStyle(color: Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' for purchasing land, \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: constructionCostOfAllFloorsText,
                                      style:  TextStyle(color: const Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' for cost of construction, with \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: totalPermitCostText,
                                      style:  TextStyle(color: const Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' permit fees',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: otherCostValueText != '0' && otherCostValueText != '0.0' ? ', and \$' : '.',
                                      style: TextStyle(
                                        fontSize: textFieldFontSize,
                                      ),
                                    ),
                                    TextSpan(
                                      text: otherCostValueText != '0' ? otherCostValueText : '',
                                      style: otherCostValueText != '0' ?  const
                                      TextStyle(color: Color.fromARGB(250, 176, 41, 1)) : null,
                                    ),
                                    TextSpan(
                                      text: otherCostValueText != '0' ? ' for other costs.' : '',
                                      style: TextStyle(
                                        fontSize: textFieldFontSize,
                                      ),
                                    ),
                                     TextSpan(
                                      text: '\n\nThe sale price of each floor is \$',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: floorTotalPriceText,
                                      style:  TextStyle(color: Colors.blue, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: '. Therefore, total income of the project is \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: totalIncomeText,
                                      style:  TextStyle(color: Colors.blue, fontSize: textFieldFontSize,),
                                    ),
                                     const TextSpan(
                                      text: '.\n\n',
                                    ),
                                     TextSpan(
                                      text: 'As a result, the total profit of the project is \$',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: profitText,
                                      style:  TextStyle(color: Colors.teal, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: '. The profit percentage is ',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: profitPercentageText,
                                      style:  TextStyle(color: Colors.green, fontSize: textFieldFontSize,),
                                    ),
                                    TextSpan(
                                      text: ', and annual profit percentage is ',
                                      style: TextStyle(
                                        fontSize: textFieldFontSize,
                                      ),
                                    ),
                                    TextSpan(
                                      text: profitPercentageAnnuallyText,
                                      style:  TextStyle(color: Colors.green, fontSize: textFieldFontSize,),
                                    ),
                                     const TextSpan(
                                      text: '.',
                                    ),
                                    const WidgetSpan(
                                      child: Divider(
                                        color: Colors.red,
                                        height: 1.0,
                                        thickness: 3.0,
                                      ),
                                    ),
                                     TextSpan(
                                      text: '\n\nThe total cost per m²/ft² of saleable area is \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: allCostsIncurredPerMeterOfUsefulAreaText,
                                      style:  TextStyle(color: Colors.pink, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' that is sold at the price of \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: apartmentSellPricePerMeterValueText,
                                      style:  TextStyle(color: Colors.blue, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' per m²/ft², resulting in a profit of \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: profitPerUsefulAreaText,
                                      style:  TextStyle(color: Colors.teal, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' per m²/ft² of usable area. This profit represents ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: profitPercentagePerUsefulAreaText,
                                      style:  TextStyle(color: Colors.green, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' of the total cost of one square meter/foot of usable area.\n\n',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                     TextSpan(
                                      text: 'To compare with other projects, in this project, every \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: NumberFormat('#,###').format(
                                        double.tryParse(tenXOfTotalCostForUnit.substring(0, tenXOfTotalCostForUnit.length - 1).replaceAll(',', '')) ?? 0.0,
                                      ),
                                      style:  TextStyle(color: Colors.blue, fontSize: textFieldFontSize,),
                                    ),

                                     TextSpan(
                                      text: ' invested produces ',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: usefulAreaConstructedBy1BillionText,
                                      style:  TextStyle(color: const Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' m²/ft² usable area. Also, every \$',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                    TextSpan(
                                      text: tenXOfTotalCostForUnit,
                                      style:  TextStyle(color: Colors.blue, fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' invested produces ',
                                         style: TextStyle(
                                           fontSize: textFieldFontSize,
                                         ),
                                    ),
                                    TextSpan(
                                      text: totalNumberOfPropertiesByTenXText,
                                      style:  TextStyle(color: const Color.fromARGB(250, 176, 41, 1), fontSize: textFieldFontSize,),
                                    ),
                                     TextSpan(
                                      text: ' unit properties. \n\n',
                                       style: TextStyle(
                                         fontSize: textFieldFontSize,
                                       ),
                                    ),
                                  ],
                                ),

                                style:  TextStyle(
                                  fontSize:isIpad ? 35 : 22,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(height: isIpad ? 13 : 10),

                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 22,),
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white70,
                        size: iconSizeLarge,),
                      onPressed: () async {
                 //     await interstitialAdManager.showInterstitialAd(context);
                        NavigationService().navigateToScreen(const AllProjectsPage());
                      },
                    ),


                    //  const SizedBox(width: 2,),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white70,
                        size: iconSizeLarge,),
                      onPressed: () {
                        if (shouldRetrieveData == 1) {
                          // Navigate back to Page One with specific logic
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniformCalculationPage1(
                                givenUniformProjectName: uniformCalProjectName,
                              ),
                            ),
                          );
                        } else {
                          // Just pop back to Page Two
                          Navigator.pop(context);
                        }
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.save, color: Colors.white70,
                        size: iconSizeLarge,),
                      onPressed: () async {

                        final uniformCalculationAddress = await UniformCalculationDatabase.getUniformCalculationAddressData(uniformCalProjectName);

                        // Check if UniformCalculationData is not empty Update the text field
                        if (uniformCalculationAddress.isNotEmpty && uniformCalProjectName != 'wwbb') {
                          projectNameController.text = uniformCalProjectName;
                          provinceController.text = uniformCalculationAddress[0].addressProvinceName;
                          environmentallyFriendlyController.text = uniformCalculationAddress[0].addressEnvironmentallyFriendly.toString();
                          sociallyFriendlyController.text = uniformCalculationAddress[0].addressSociallyFriendly.toString();
                          cityController.text = uniformCalculationAddress[0].addressCityName;
                          streetController.text = uniformCalculationAddress[0].addressStreetName;
                          buildingNumberController.text = uniformCalculationAddress[0].addressBuildingNumber;
                          phoneNumberController.text = uniformCalculationAddress[0].addressPhoneNumber;
                          otherInfoController.text = uniformCalculationAddress[0].addressOtherInfo;
                        }

                        _showAddressDialog(context);
                      },
                    ),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //   title:  Text('User Guidance'),
                              content: SingleChildScrollView(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Results of the Project',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nAt the top, you will see the four main results:',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n1. Income: This is calculated by multiplying the total '
                                            'saleable area by the sell price.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n2. Cost: This represents the sum of all types of costs associated with the project.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n3. Profit: Profit is determined by subtracting the total cost from the total income.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\n4. Profit Percentage: This is calculated by dividing the profit by the total cost '
                                            'and expressing it as a percentage.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nBelow the table, you will find information about the physical specifications of the project, '
                                            'including the total built-up area and the usable area. '
                                            '\n\nIt is important to note that at the bottom of the page, the total cost per square foot '
                                            'of saleable (usable) area is also displayed. This value is calculated by dividing the '
                                            'total cost by the total usable area. This metric is provided because investors typically '
                                            'input construction costs (i.e., cost per square foot of the total area), permit fees, land '
                                            'purchase costs, and other expenses separately, resulting in outputs such as total revenue, total'
                                            ' cost, total area, and total usable floor area. However, understanding the final cost per square '
                                            'foot of saleable area is especially valuable, as it allows us to more easily compare projects '
                                            'with similar capital and profit by identifying those that generate more usable area and thus '
                                            'offer greater economic efficiency. However, the following indices help compare projects even '
                                            'when their investment amounts and profitability differ.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),

                                       TextSpan(
                                        text: '\n\nEconomic Efficiency of Project',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.pink,
                                        ),
                                      ),
                                       TextSpan(
                                        text: '\n\nMaking a profit, which reflects the financial efficiency of '
                                            'investments, is one thing, but addressing the issue of inadequate'
                                            ' housing for low-middle income families is another. These goals may conflict, '
                                            'as a project can be profitable for investors while failing to provide '
                                            'affordable and qualified homes for those in need.\n\n'
                                            'Apart from some efficiency factors of a real estate project like total built-up area and number of job '
                                            'created, the most important economic efficiency factor is the total saleable area '
                                            'constructed meeting a standard quality with a fixed amount of investment. '
                                            'This means that the more saleable area'
                                            ' built with a given investment, the more economically efficient the project is, '
                                            'as it has a significant impact on the real estate market\'s economics. '
                                            '\n\nTherefore, having a metric to compare different '
                                            'projects in terms of this efficiency is invaluable.'
                                            '\n\nFor example, if a \$100,000 investment results in one project with '
                                            '500 ft² of built-up area, of which 400 ft² '
                                            'are saleable, and another project with the same built-up area '
                                            'produces 450 ft² of saleable area, the first project '
                                            'may allocate more space to staircases, elevators, lobbies, or use more expensive materials.'
                                            ' While these features sometimes can be necessary, '
                                            'often they might exceed what is required and be constructed merely '
                                            'to inflate the price of saleable area for higher profits. You can express your project result '
                                            ' as "each square meter/foot of saleable area has a cost of X" or'
                                            ' "each \$1,000 invested in the project produces Y square meter/foot of saleable area."'
                                            ' While both statements convey the same information, the second '
                                            'phrasing makes it easier to compare different projects mentally.'
                                            '\n\nFor this purpose, in this app the usable area constructed '
                                            'in a project is evaluated '
                                            'using a coefficient of \$10, like 10, 10, 100 based on the total cost of your project,'
                                            ' allowing effective comparisons to determine '
                                            'which projects are more efficient economically.'
                                            '\n\nFor example, if Project A, which costs \$78,000, produces 200 ft² '
                                            'of saleable area, and Project B, which costs \$89,000, produces 223 ft², '
                                            'which one is more economically efficient? The app indicates that for the first project, '
                                            'each \$1,000 invested yields 2.56 ft² of saleable area, while the second '
                                            'project yields 2.50 ft² per \$1,000. Thus, it is easy to conclude that '
                                            'the first project is the better option.',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),

                                       TextSpan(
                                        text: '\n\nSocial Efficiency of Project',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.bold,color: Colors.pink,
                                        ),
                                      ),

                                       TextSpan(
                                        text: '\n\nEven if a more economically efficient project in terms of saleable area is invested in, '
                                            'it may produce fewer properties. This means that fewer families can '
                                            'have homes or working properties after construction. Conversely, if a space for living or '
                                            'working is in crisis due to high purchasing or rental prices, we need '
                                            'to choose projects that provide more separate properties with justifiable quality and price '
                                            'using a fixed investment.\n\n'
                                            'This is indeed an important social variable of real estate investment that '
                                            'considers how many properties each \$10 coefficient produces. This value '
                                            'is usually a decimal, but different projects can simpler be compared. '
                                            '\n\nFor example, one project with \$100,000 produces 5 properties regardless '
                                            'of their size, while another project with \$170,000 produces 8 properties. '
                                            'In this context, the first project is better because it '
                                            'produces 0.05 properties per \$1,000, while the second project produces '
                                            '0.047 properties. It means that even if you have more money to invest than first project '
                                            'and your goal is to provide more properties, you should choose the first '
                                            'project and invest the rest of your money \$70,000 in other projects with the index not less than 0.047, '
                                            'so you could make more properties in total.'
                                            '\n\nThe most important metric for addressing social-economical issues in the real estate '
                                            'market is the number of properties supplied with justifiable quality, '
                                            'rather than focusing on total saleable area or profitability when '
                                            'comparing different projects. However, if you are not prioritizing the number of '
                                            'properties for any reason, you should at least focus on the saleable area '
                                            'you can provide. Otherwise, your investment may be directed more toward '
                                            'land costs, luxury materials, and additional common areas, which won\'t '
                                            'help address the shortage of qualified properties in the city where you invest.\n\n'
                                            'Also, Providing more separate properties is more important when discussing homes '
                                            'compared to workspaces, as families require private living spaces, whereas workspaces can be shared.\n\n'
                                            'It\'s important to note that providing smaller properties is not an absolute rule in '
                                            'the real estate market. Once an acceptable equilibrium is reached between the supply '
                                            'and demand of properties, after ensuring an adequate number of small, qualified homes, '
                                            'investment can be redirected towards larger properties for those capable of purchasing '
                                            'them. However, before such an equilibrium is achieved in the market, investing in big or high-end, '
                                            'luxurious homes or both can contribute to inflation and lead to a shortage of resources for '
                                            'the construction of smaller homes.'
                                            '\n\nFinding a project that strikes the right balance between profitability, '
                                            'usable area efficiency, and the number of properties is a delicate art. If '
                                            'the sole focus is on maximizing profit, it can come at the expense of other '
                                            'crucial factors. On the other hand, choosing a plot of land far from the city '
                                            'center may be cheap and offer a large usable area, but this building, even '
                                            'if provided at a low price, cannot effectively target the demand side of the '
                                            'market. Typically, people prefer '
                                            'properties within a reasonable distance from their workplaces, and if '
                                            'your project is located too far, it may struggle to attract buyers, '
                                            'leading to financial losses.'
                                            'Similarly, selecting a project with a high number of properties '
                                            'but low quality or excessively small units is also a risky proposition. '
                                            'Suites and tiny apartments are often suitable for cities with a large '
                                            'student population or single workers, but complete families of three or '
                                            'four persons generally require properties with at least one room and a '
                                            'justifiable area for the different parts of the home.'
                                            'The key lies in finding the sweet spot where profitability is balanced '
                                            'with practical considerations. A project that offers a good mix of '
                                            'usable area, property size, and overall efficiency is more likely to '
                                            'appeal to a wider range of buyers, ensuring a steady return on investment. '
                                            'It\'s a delicate balance that requires careful analysis of market trends, '
                                            'target demographics, and the unique characteristics of each potential project.'
                                            'For more information on the economic and social aspects of this topic, please refer to the '
                                            'details provided on the first page of this application.\n\n',
                                        style: TextStyle(
                                          fontSize: textFieldFontSize,
                                          color: Colors.black,
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ),

                              actions: [
                                TextButton(
                                  child:  Text('OK',   style: TextStyle(
                                    fontSize: titleFontSize,color: Colors.red
                                  ),),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon:  Icon(Icons.help_center_rounded,
                        color: Colors.white70, size: iconSizeLarge,),
                    ),
                    const SizedBox(width: 2,),
                  ],
                ),
              ),

           //   const MyBannerAdWidget(),
                 const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowResultUniformCalculationPage(
      BuildContext context, String labelText, String valueText) {
    final screenWidth = MediaQuery.of(context).size.width;
    const ipadBreakpoint = 850.0;
    final bool isIpad = screenWidth > ipadBreakpoint;
    Color backgroundColor = Colors.transparent;
    if (labelText == 'Income') {
      backgroundColor = Colors.blue;
    } else if (labelText == 'Total Cost') {
      backgroundColor = Colors.pink;
    } else if (labelText == 'Profit') {
      backgroundColor = Colors.teal;
    } else if (labelText == 'Profit Percentage') {
      backgroundColor = Colors.green;
    }

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style:  TextStyle(
              fontSize:isIpad ? 32 : 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            valueText,
            style:  TextStyle(
              fontSize:isIpad ? 32 : 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}



////////////////////////


