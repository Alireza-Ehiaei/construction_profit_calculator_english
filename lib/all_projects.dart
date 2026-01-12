import 'package:construction_profit_calculator_english/result_differentiated.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ad_mob.dart';
import 'billing_provider.dart';
import 'land.dart';
import 'main.dart';
import 'database.dart';
import 'uniformPricing_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'navigation_service.dart';
import 'dart:io';


class AllProjectsPageDatabase {
  static const String tableAllProjectsPageData = 'allProjectsData';
  static const String columnAllProjectsPageId = 'allProjectsPageId';
  static const String columnAllProjectsPageProjectName = 'allProjectsPageProjectName';
  static const String columnAllProjectsPageCostOfProject = 'allProjectsPageCostOfProject';
  static const String columnAllProjectsPageIncomeOfProject = 'allProjectsPageIncomeOfProject';
  static const String columnAllProjectsPageProfitOfProject = 'allProjectsPageProfitOfProject';
  static const String columnAllProjectsPageProfitPercentageOfProject = 'allProjectsPageProfitPercentageOfProject';
  static const String columnAllProjectsPageEnvironmentallyFriendly = 'allProjectsPageEnvironmentallyFriendly';
  static const String columnAllProjectsPageSociallyFriendly = 'allProjectsPageSociallyFriendly';
  static const String columnAllProjectsPageCity = 'allProjectsPageCity';
  static const String columnAllProjectsPageStreet = 'allProjectsPageStreet';
  static const String columnAllProjectsPagePricingType = 'allProjectsPageCalculationName';

  static const _databaseName = 'allProjectsPageDatabase.db';
  static const _databaseVersion = 1;

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
      version: _databaseVersion,
      onCreate: _onCreateAllProjectsPageTable,
    );
    return database;
  }

  static Future<void> _onCreateAllProjectsPageTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAllProjectsPageData (
      $columnAllProjectsPageId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAllProjectsPageProjectName TEXT,
        $columnAllProjectsPageCostOfProject TEXT,
        $columnAllProjectsPageIncomeOfProject TEXT,
        $columnAllProjectsPageProfitOfProject TEXT,
        $columnAllProjectsPageProfitPercentageOfProject TEXT,
        $columnAllProjectsPageEnvironmentallyFriendly REAL,
        $columnAllProjectsPageSociallyFriendly REAL,
        $columnAllProjectsPageCity TEXT,
        $columnAllProjectsPageStreet TEXT,
        $columnAllProjectsPagePricingType TEXT
      )
    ''');
  }

  static Future<void> deleteProjectInAllProjectsPage(String projectName) async {
    final db = await database;

    // Delete from AllProjectsPageData
    await db.delete(
      tableAllProjectsPageData,
      where: '$columnAllProjectsPageProjectName = ?',
      whereArgs: [projectName],
    );
  }

static Future<int> insertOrUpdateAllProjectsPageData(
    AllProjectsPageData1 allProjectsPageData)
    async {
      final db = await database;
      final maps = await db.query(
        tableAllProjectsPageData,
        where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
        whereArgs: [allProjectsPageData.allProjectsPageProjectName, allProjectsPageData.allProjectsPageCalculationName],
      );
      if (maps.isNotEmpty) {
        await db.update(
          tableAllProjectsPageData,
          allProjectsPageData.toMap(),
          where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
          whereArgs: [allProjectsPageData.allProjectsPageProjectName, allProjectsPageData.allProjectsPageCalculationName],
        );
        return maps.first[columnAllProjectsPageId] as int;
      } else {
        final id = await db.insert(
          tableAllProjectsPageData,
          allProjectsPageData.toMap(),
        );
        return id;
      }
    }
  static Future<void> updateAllProjectsPageData(
      String projectName,
      String calculationName,
      String costOfProject,
      String incomeOfProject,
      String profitOfProject,
      String profitPercentageOfProject,
      )
  async {
    final db = await database;

    await db.update(
      tableAllProjectsPageData,
      {
        columnAllProjectsPageCostOfProject: costOfProject,
        columnAllProjectsPageIncomeOfProject: incomeOfProject,
        columnAllProjectsPageProfitOfProject: profitOfProject,
        columnAllProjectsPageProfitPercentageOfProject: profitPercentageOfProject,
        columnAllProjectsPagePricingType: calculationName,
        columnAllProjectsPageProjectName: projectName,
      },
      where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
      whereArgs: [projectName, calculationName],
    );
  }


 /* static Future<int> updateProjectFinancials(NewFinancialData newFinancialData) async {
    final db = await database;

    // Fetch existing row
    final maps = await db.query(
      tableAllProjectsPageData,
      where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
      whereArgs: [newFinancialData.projectName, newFinancialData.calculationName],
    );

    if (maps.isEmpty) {
      // Insert if not exist (optional)
      final id = await db.insert(tableAllProjectsPageData, {
        // Map fields from newFinancialData, add defaults for missing fields
        columnAllProjectsPageProjectName: newFinancialData.projectName,
        columnAllProjectsPagePricingType: newFinancialData.calculationName,
        columnAllProjectsPageCostOfProject: newFinancialData.costOfProject,
        columnAllProjectsPageIncomeOfProject: newFinancialData.incomeOfProject,
        columnAllProjectsPageProfitOfProject: newFinancialData.profitOfProject,
        columnAllProjectsPageProfitPercentageOfProject: newFinancialData.profitPercentageOfProject,
        // Add defaults or nulls for preserved fields
      });
      return id;
    }

    final existingRecord = maps.first;

    // Prepare updated fields keeping preserved fields from existing record:
    final updatedMap = {
      columnAllProjectsPageCostOfProject: newFinancialData.costOfProject,
      columnAllProjectsPageIncomeOfProject: newFinancialData.incomeOfProject,
      columnAllProjectsPageProfitOfProject: newFinancialData.profitOfProject,
      columnAllProjectsPageProfitPercentageOfProject: newFinancialData.profitPercentageOfProject,
      // Preserve these:
      columnAllProjectsPageEnvironmentallyFriendly: existingRecord[columnAllProjectsPageEnvironmentallyFriendly],
      columnAllProjectsPageSociallyFriendly: existingRecord[columnAllProjectsPageSociallyFriendly],
      columnAllProjectsPageCity: existingRecord[columnAllProjectsPageCity],
      columnAllProjectsPageStreet: existingRecord[columnAllProjectsPageStreet],

      // Also keep identifying columns to avoid updating them
      columnAllProjectsPageProjectName: newFinancialData.projectName,
      columnAllProjectsPagePricingType: newFinancialData.calculationName,
    };

    final id = existingRecord[columnAllProjectsPageId] as int;

    await db.update(
      tableAllProjectsPageData,
      updatedMap,
      where: '$columnAllProjectsPageId = ?',
      whereArgs: [id],
    );

    return id;
  }

*/

  static Future<int> updateProjectOtherFields({
    required String projectName,
    required String pricingType,
    required Map<String, dynamic> fieldsToUpdate,
  })
  async {
    final db = await database;
    // Only update the specified columns
    final result = await db.update(
      tableAllProjectsPageData,
      fieldsToUpdate,
      where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
      whereArgs: [projectName, pricingType],
    );
    return result; // returns number of rows affected
  }



  static Future<List<AllProjectsPageData1>> getAllProjectsPageData() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableAllProjectsPageData,
    );
    return List.generate(maps.length, (i) {
      return AllProjectsPageData1(
        allProjectsPageProjectName: maps[i][columnAllProjectsPageProjectName],
        allProjectsPageCostOfProject: maps[i][columnAllProjectsPageCostOfProject],
        allProjectsPageIncomeOfProject: maps[i][columnAllProjectsPageIncomeOfProject],
        allProjectsPageProfitOfProject: maps[i][columnAllProjectsPageProfitOfProject],
        allProjectsPageProfitPercentageOfProject: maps[i][columnAllProjectsPageProfitPercentageOfProject],
        allProjectsPageEnvironmentallyFriendly: maps[i][columnAllProjectsPageEnvironmentallyFriendly],
        allProjectsPageSociallyFriendly: maps[i][columnAllProjectsPageSociallyFriendly],
        allProjectsPageCity: maps[i][columnAllProjectsPageCity],
        allProjectsPageStreet: maps[i][columnAllProjectsPageStreet],
        allProjectsPageCalculationName: maps[i][columnAllProjectsPagePricingType],
      );
    });
  }

  static Future<void> updateProjectNameInAllProjectsPageData(String oldProjectName, String newProjectName, String pricingType) async {
    final db = await database;

    if (pricingType == 'uniform') {
      await db.rawUpdate(
        'UPDATE $tableAllProjectsPageData SET $columnAllProjectsPageProjectName = ? '
            'WHERE $columnAllProjectsPageProjectName = ? '
            'AND $columnAllProjectsPagePricingType = ?',
        [newProjectName, oldProjectName, pricingType],
      );
    } else if (pricingType == 'Differentiated') {
      await db.rawUpdate(
        'UPDATE $tableAllProjectsPageData SET $columnAllProjectsPageProjectName = ? '
            'WHERE $columnAllProjectsPageProjectName = ? '
            'AND $columnAllProjectsPagePricingType = ?',
        [newProjectName, oldProjectName, pricingType],
      );
    }
  }

  static Future<void> deleteProjectFromAllProjectsPageData(String projectName, String calculationType)
  async {
    final db = await database;
    await db.delete(
      tableAllProjectsPageData,
      where: '$columnAllProjectsPageProjectName = ? AND $columnAllProjectsPagePricingType = ?',
      whereArgs: [projectName, calculationType],
    );
  }

  static Future<void> deleteAllProjectsPageDatabase() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final databasePath = join(dbPath.path, 'allProjectsPageDatabase.db');
    await deleteDatabase(databasePath);
  }

  static Future deleteTablesOfAllProjectsPageDatabase() async {
    await _database?.execute('DROP TABLE IF EXISTS tableAllProjectsPageData');
  }

} // allProjectsPageDatabase


class AllProjectsPageData1 {
  final String allProjectsPageProjectName;
  final String allProjectsPageCostOfProject;
  final String allProjectsPageIncomeOfProject;
  final String allProjectsPageProfitOfProject;
  final String allProjectsPageProfitPercentageOfProject;
  final double allProjectsPageEnvironmentallyFriendly;
  final double allProjectsPageSociallyFriendly;
  final String allProjectsPageCity;
  final String allProjectsPageStreet;
  final String allProjectsPageCalculationName;

  AllProjectsPageData1({
    required this.allProjectsPageProjectName,
    required this.allProjectsPageCostOfProject,
    required this.allProjectsPageIncomeOfProject,
    required this.allProjectsPageProfitOfProject,
    required this.allProjectsPageProfitPercentageOfProject,
    required this.allProjectsPageEnvironmentallyFriendly,
    required this.allProjectsPageSociallyFriendly,
    required this.allProjectsPageCity,
    required this.allProjectsPageStreet,
    required this.allProjectsPageCalculationName,
  });

  Map<String, dynamic> toMap() {
    return {
      'allProjectsPageProjectName': allProjectsPageProjectName,
      'allProjectsPageCostOfProject': allProjectsPageCostOfProject,
      'allProjectsPageIncomeOfProject': allProjectsPageIncomeOfProject,
      'allProjectsPageProfitOfProject': allProjectsPageProfitOfProject,
      'allProjectsPageProfitPercentageOfProject': allProjectsPageProfitPercentageOfProject,
      'allProjectsPageEnvironmentallyFriendly': allProjectsPageEnvironmentallyFriendly,
      'allProjectsPageSociallyFriendly': allProjectsPageSociallyFriendly,
      'allProjectsPageCity': allProjectsPageCity,
      'allProjectsPageStreet': allProjectsPageStreet,
      'allProjectsPageCalculationName': allProjectsPageCalculationName,
    };
  }
}


class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});


  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}


class _AllProjectsPageState extends State<AllProjectsPage> {
  late final List<AllProjectsPageData1> allProjectsData;
  int sortColumnIndex = 0;
  bool _isProjectExistSortedAscending = false;
  bool isHeaderSelected = false;
  List<bool> selectedRows = [];
  List<String> favoriteLevels = List.filled(10, "");
  int selectedRowsLength = 0;
  List<String> selectedProjects = [];

  // Define a list to store the selected values for each row
  List<String> selectedValues = List.filled(
      10, ''); // Re place 10 with the appropriate length
//  final InAppPurchase _inAppPurchase = InAppPurchase.instance;


  @override
  void initState() {
    super.initState();
    _initializeProjectProviderData();
  }


/*  Future<bool> checkGooglePlayBillingAvailability() async {
    if (!Platform.isAndroid) {
      return false; // Disable Google Billing on non-Android (e.g., iPad emulator)
    }
    final InAppPurchase inAppPurchase = InAppPurchase.instance;
    return await inAppPurchase.isAvailable();
  }*/

  Future<void> _initializeProjectProviderData() async {
    // Retrieve the data from the database
    allProjectsData = await AllProjectsPageDatabase.getAllProjectsPageData();

    // Initialize selectedRows based on the length of allProjectsData
    selectedRows = List.filled(allProjectsData.length, false);
    await DifferentiatedCalculationDatabaseHelper
        .deleteProjectOfDifferentiatedCalculationDatabase('_oozz');

    //   setState(() {});
  }

  bool? headerCheckboxValue; // State to track the value of the header checkbox
  // Modify the onChanged_ method to update the selected value for the specific row

  void deleteProjects(List<int> deletedIndexes) {
    setState(() {
      // Remove the deleted indexes from selectedRows
      for (int index in deletedIndexes) {
        selectedRows[index] = false;
      }
    });
  }

  Future<List<
      List<dynamic>>> _getAllProjectProviderDataFromAllProjectsPageDatabase() async {
    final db = await AllProjectsPageDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AllProjectsPageDatabase.tableAllProjectsPageData,
      columns: [
        AllProjectsPageDatabase.columnAllProjectsPageProjectName,
        AllProjectsPageDatabase.columnAllProjectsPageIncomeOfProject,
        AllProjectsPageDatabase.columnAllProjectsPageCostOfProject,
        AllProjectsPageDatabase.columnAllProjectsPageProfitOfProject,
        AllProjectsPageDatabase.columnAllProjectsPageProfitPercentageOfProject,
        AllProjectsPageDatabase.columnAllProjectsPageEnvironmentallyFriendly,
        AllProjectsPageDatabase.columnAllProjectsPageSociallyFriendly,
        AllProjectsPageDatabase.columnAllProjectsPageCity,
        AllProjectsPageDatabase.columnAllProjectsPageStreet,
        AllProjectsPageDatabase.columnAllProjectsPagePricingType,
      ],
    );

    return maps.map((map) {
      return [
        false, // Checkbox value
        map[AllProjectsPageDatabase.columnAllProjectsPageProjectName],
        map[AllProjectsPageDatabase.columnAllProjectsPageCostOfProject],
        map[AllProjectsPageDatabase.columnAllProjectsPageIncomeOfProject],
        map[AllProjectsPageDatabase.columnAllProjectsPageProfitOfProject],
        map[AllProjectsPageDatabase
            .columnAllProjectsPageProfitPercentageOfProject],
        map[AllProjectsPageDatabase
            .columnAllProjectsPageEnvironmentallyFriendly],
        map[AllProjectsPageDatabase.columnAllProjectsPageSociallyFriendly],
        map[AllProjectsPageDatabase.columnAllProjectsPageCity],
        map[AllProjectsPageDatabase.columnAllProjectsPageStreet],
        map[AllProjectsPageDatabase.columnAllProjectsPagePricingType],
      ];
    }).toList();
  }

  List<List<dynamic>>? _sortData(List<List<dynamic>>? data, int columnIndex,
      bool isAscending) {
    if (data == null || data.isEmpty) {
      return null;
    }

    if (columnIndex == 6) {
      data.sort((a, b) {
        if (isAscending) {
          return a[6].compareTo(b[6]);
        } else {
          return b[6].compareTo(a[6]);
        }
      });

      // Reorder favoriteLevels
      List<dynamic> favoriteLevels = data.map((row) => row[6]).toList();
      if (!isAscending) {
        favoriteLevels = favoriteLevels.reversed.toList();
      }
      for (int i = 0; i < data.length; i++) {
        data[i][6] = favoriteLevels[i];
      }
    } else {
      data.sort((a, b) {
        var aValue = a[columnIndex];
        var bValue = b[columnIndex];

        if (aValue is String && bValue is String) {
          // Remove commas and percentage signs, then parse to double
          double? aDouble = double.tryParse(
              aValue.replaceAll(',', '').replaceAll('%', ''));
          double? bDouble = double.tryParse(
              bValue.replaceAll(',', '').replaceAll('%', ''));

          if (aDouble != null && bDouble != null) {
            return isAscending ? aDouble.compareTo(bDouble) : bDouble.compareTo(
                aDouble);
          } else {
            return isAscending ? aValue.compareTo(bValue) : bValue.compareTo(
                aValue);
          }
        } else if (aValue is num && bValue is num) {
          return isAscending ? aValue.compareTo(bValue) : bValue.compareTo(
              aValue);
        } else if (aValue is bool && bValue is bool) {
          if (aValue == bValue) {
            return 0;
          } else if (aValue) {
            return isAscending ? 1 : -1;
          } else {
            return isAscending ? -1 : 1;
          }
        } else {
          return 0;
        }
      });
    }

    return data;
  }

// Helper method to detect if the device is an iPad.
  bool isIpad(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final diagonal = size.width + size.height;
    return diagonal > 1500;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData.dark();
    final bool isIpadDevice = isIpad(context);

    // Use LayoutBuilder to get the available space for your widget
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final availableWidth = constraints.maxWidth;

          final screenWidth = MediaQuery
              .of(context)
              .size
              .width;
          // iPhone sizes (base)
          final double buttonWidthPhone = screenWidth * 0.7;
          const double fontSizePhone = 20.0;
          const double titleFontSizePhone = 22.0;
          const double iconSizeLargePhone = 30.0;
          const double iconSizeSmallPhone = 28.0;

// iPad sizes (larger)
          final double buttonWidthPad = screenWidth * 0.5;
          const double fontSizePad = 30.0;
          const double titleFontSizePad = 40.0;
          const double iconSizeLargePad = 55.0;
          const double iconSizeSmallPad = 42.0;

          // Conditionally set all your final values
          final double buttonWidth = isIpadDevice
              ? buttonWidthPad
              : buttonWidthPhone;
          final double textFontSize = isIpadDevice
              ? fontSizePad
              : fontSizePhone;
          final double titleFontSize = isIpadDevice
              ? titleFontSizePad
              : titleFontSizePhone;
          final double iconSizeLarge = isIpadDevice
              ? iconSizeLargePad
              : iconSizeLargePhone;
          final double iconSizeSmall = isIpadDevice
              ? iconSizeSmallPad
              : iconSizeSmallPhone;
          final double spacingHeight = isIpadDevice ? 16.0 : 10.0;


          // final navigationProvider = Provider.of<ProjectProviderData>(context, listen: false);
          return Consumer2<ProjectProviderData, SubscriptionsProvider>(
              builder: (context, projectData, subscriptionsProvider, child) {
                return Scaffold(

                  body: Container(
                    color: const Color.fromRGBO(13, 110, 76, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<List<dynamic>>>(
                        future: _getAllProjectProviderDataFromAllProjectsPageDatabase(),
                        builder: (context, snapshot) {
                          /*   if (snapshot.hasData) {
                      List<List<dynamic>> data = snapshot.data!;
*/
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            // Ensure selectedRows is initialized based on fetched data
                            List<List<dynamic>> data = snapshot.data ?? [];

                            // Initialize selectedRows if its length does not match data length
                            if (selectedRows.length != data.length) {
                              selectedRows = List.filled(data.length, false);
                            }

                            ////////////////
                            if (!_isProjectExistSortedAscending &&
                                sortColumnIndex != 0) {
                              data = _sortData(data, sortColumnIndex,
                                  _isProjectExistSortedAscending) ?? [];
                            }
                            else {
                              data.sort((a, b) {
                                if (sortColumnIndex !=
                                    0) { // Check if the sortColumnIndex is not 0 (excluding the first column)
                                  if (a[sortColumnIndex] is String) {
                                    return a[sortColumnIndex].compareTo(
                                        b[sortColumnIndex]);
                                  } else if (a[sortColumnIndex] is int) {
                                    return a[sortColumnIndex]
                                        .toString()
                                        .compareTo(
                                        b[sortColumnIndex].toString());
                                  }
                                }
                                return 0;
                              });
                            }
                            {
                              return SafeArea(
                                child: Column(
                                  children: [
                                    //   SizedBox(height: spacingHeight * 2),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              headingRowHeight: isIpadDevice
                                                  ? 90
                                                  : 50,
                                              columnSpacing: isIpadDevice
                                                  ? 20
                                                  : 10,
                                              horizontalMargin: isIpadDevice
                                                  ? 20
                                                  : 10,
                                              dataRowMaxHeight: isIpadDevice
                                                  ? 70
                                                  : 50,
                                              sortColumnIndex: sortColumnIndex,
                                              sortAscending: _isProjectExistSortedAscending,
                                              //      headingRowHeight: titleFontSize,
                                              //     dataRowHeight: isIpad ? 40 : 20,
                                              //      dataRowMaxHeight: isIpad ? 50 : 20,
                                              headingRowColor:
                                              WidgetStateProperty.resolveWith<
                                                  Color>(
                                                      (
                                                      Set<WidgetState> states) {
                                                    return Colors
                                                        .pink; // Set the background color of the header row
                                                  }),
                                              columns: [
                                                const DataColumn(
                                                  label: Text(''),
                                                ),
                                                DataColumn(
                                                  label: Text('Project Name',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),

                                                DataColumn(
                                                  label: Text(
                                                    'Income',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Cost',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Profit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Profit %',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),

                                                DataColumn(
                                                  label: Text(
                                                    '   City  ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Street',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: titleFontSize
                                                    ),
                                                  ),
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),

                                                DataColumn(
                                                  label: Text(
                                                    'Environmentally\nFriendly',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: textFontSize * 0.8
                                                    ),
                                                  ),
                                                  // New column for the text value
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Socially\nFriendly',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: textFontSize * 0.8
                                                    ),
                                                  ),
                                                  // New column for the text value
                                                  numeric: true,
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),

                                                DataColumn(
                                                  label: Text(
                                                    '   Pricing',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: textFontSize
                                                    ),
                                                  ),
                                                  onSort: (columnIndex,
                                                      ascending) {
                                                    setState(() {
                                                      _isProjectExistSortedAscending =
                                                          ascending;
                                                      _sortData(
                                                          data, columnIndex,
                                                          ascending);
                                                      sortColumnIndex =
                                                          columnIndex;
                                                    });
                                                    if (columnIndex != 0) {
                                                      for (var i = 0;
                                                      i < selectedRows.length;
                                                      i++) {
                                                        selectedRows[i] = false;
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],

                                              // Set the horizontal margin between columns
                                              rows: data
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key;
                                                List<dynamic> rowData = entry
                                                    .value;
                                                Color? rowColor = index % 2 == 0
                                                    ? Colors.grey[200]
                                                    : Colors
                                                    .white; // Alternate row colors
                                                return DataRow(
                                                  color: WidgetStateProperty
                                                      .all(
                                                      Color(rowColor!.value)),
                                                  cells: [
                                                    DataCell(
                                                      Checkbox(
                                                        value: selectedRows[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedRows[index] =
                                                            value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    // Project Name
                                                    DataCell(Text(
                                                      rowData[1].toString(),
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Income

                                                    DataCell(Text(
                                                      '${rowData[3]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Cost
                                                    DataCell(Text(
                                                      '${rowData[2]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),


                                                    // Profit
                                                    DataCell(Text(
                                                      '${rowData[4]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Profit %

                                                    DataCell(Text(
                                                      (rowData[5] is String)
                                                          ? '${rowData[5]}'
                                                          : '${rowData[5]
                                                          .toStringAsFixed(0)}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Environmentally Friendly

                                                    DataCell(Text(
                                                      '${rowData[6]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Socially Friendly

                                                    DataCell(Text(
                                                      '${rowData[7]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // City

                                                    DataCell(Text(
                                                      '${rowData[8]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // Street

                                                    DataCell(Text(
                                                      '${rowData[9]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),
                                                    // pricing Name

                                                    DataCell(Text(
                                                      '${rowData[10]}',
                                                      style: TextStyle(
                                                          fontSize: textFontSize),
                                                    )),

                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(width: spacingHeight),
                                        IconButton(
                                            icon: Icon(Icons.home,
                                                color: Colors.white,
                                                size: iconSizeLarge),
                                            onPressed: () {
                                              NavigationService()
                                                  .navigateToScreen(
                                                const HomePage(
                                                  backgroundImages: [
                                                    'assets/images/home (1).jpeg',
                                                    'assets/images/home (2).jpeg',
                                                    'assets/images/home (4).jpeg',
                                                    'assets/images/home (7).jpeg',
                                                    'assets/images/home (11).jpeg',
                                                    'assets/images/home (12).jpeg',
                                                    'assets/images/home (13).jpeg',
                                                    'assets/images/home (14).jpeg',
                                                  ],),
                                              );
                                            }),

                                        SizedBox(width: spacingHeight),
                                        IconButton(
                                          color: Colors.white,
                                          icon: Icon(
                                            Icons.add_circle_sharp,
                                            size: iconSizeLarge,
                                          ),
                                          onPressed: () async {
                                     //       final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
                                     //       final projectData = Provider.of<ProjectProviderData>(context, listen: false);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: SizedBox(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                            height: spacingHeight * 3),
                                                        /* Flexible(
                                                flex: 1,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                               //     final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
                                                //    bool isBillingAvailable = await checkGooglePlayBillingAvailability();
                      
                                                    if (1!=1){//(!isBillingAvailable) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title:  const Text('No Subscription Available'),
                                                          content: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                 TextSpan(text: 'No subscription found. ', style: TextStyle(fontSize: titleFontSize , color: Colors.black)),
                                                                 TextSpan(text: 'Check your internet connection and your ', style: TextStyle(fontSize: titleFontSize , color: Colors.black)),
                                                                TextSpan(
                                                                  text: 'Google Play account',
                                                                  style:  TextStyle(fontSize: titleFontSize , color: Colors.blue, decoration: TextDecoration.underline),
                                                                  recognizer: TapGestureRecognizer()
                                                                    ..onTap = () async {
                                                                      const url = 'https://play.google.com/store/account/subscriptions';
                                                                      if (await canLaunchUrl(Uri.parse(url))) {
                                                                        await launchUrl(Uri.parse(url));
                                                                      }
                                                                    },
                                                                ),
                                                                 TextSpan(text: ' connection to ensure you have a subscription.',
                                                                     style: TextStyle(fontSize: titleFontSize , color: Colors.black)),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child:  Text('OK',   style: TextStyle(
                                                                  fontSize: titleFontSize,
                                                                  fontWeight: FontWeight.bold,
                                                                ),),
                                                              onPressed: () => Navigator.of(context).pop(),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    else if (1==1){//if (subscriptionsProvider.hasUniformActiveSubscription || subscriptionsProvider.hasDifferentiatedPlusUniformCalculationProductId) {
                                                      NavigationService().navigateToScreen(
                                                        const UniformCalculationPage1(givenUniformProjectName: 'wwmm'),
                                                        arguments: 'wwmm',
                                                      );
                                                      Navigator.of(context).pop();
                                                    } else {
                                                      subscriptionsProvider.showUniformSubscriptionUI(context);
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                                  child:  Text('   Uniform Pricing   '
                                                      , style: TextStyle(fontSize: textFontSize, color: Colors.white)),
                                                ),
                                              ),*/
                                                     /*   ElevatedButton(
                                                          onPressed: () => subscriptionsProvider.showTestSubscriptionDialog(context),
                                                          child: const Text('Test Subscription Dialog'),
                                                        ),*/

                                                        Flexible(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            width: double.infinity, // Force equal width
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                final subscriptionsProvider = context.read<SubscriptionsProvider>();

                                                                // 1️⃣ Check purchased access (excluding trial)
                                                                final bool hasPurchasedAccess = subscriptionsProvider.hasUniformActiveSubscription ||
                                                                    subscriptionsProvider.hasDifferentiatedPlusUniformCalculationProductId;

                                                                if  (hasPurchasedAccess) {
                                                                  // ✅ Grant access immediately
                                                                  projectData.setProjectName("wwmm");
                                                                  Navigator.of(context).pop(); // Close any parent dialogs if open

                                                                  if (context.mounted) {
                                                                    Navigator.of(context).push(
                                                                      MaterialPageRoute(
                                                                        builder: (_) => const UniformCalculationPage1(givenUniformProjectName: 'wwmm'),
                                                                      ),
                                                                    );
                                                                  }

                                                                  // Optional: show trial message if applicable
                                                                  // final bool hasTrialAccess = subscriptionsProvider.hasTrialActive;
                                                                  // if (hasTrialAccess) {
                                                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                                                  //     const SnackBar(
                                                                  //       content: Text("✅ Trial access is active.\n"),
                                                                  //       backgroundColor: Colors.green,
                                                                  //     ),
                                                                  //   );
                                                                  // }

                                                                } else {
                                                                  // 2️⃣ Show loading spinner while subscription UI loads
                                                                  showDialog(
                                                                    context: context,
                                                                    barrierDismissible: false,
                                                                    builder: (_) => const Center(
                                                                      child: CircularProgressIndicator(strokeWidth: 3),
                                                                    ),
                                                                  );

                                                                  try {
                                                                    // 3️⃣ Call the real subscription UI (handles errors internally)
                                                                    await subscriptionsProvider.showUniformSubscriptionUI(context);
                                                                  } finally {
                                                                    // 4️⃣ Close spinner dialog after completion
                                                                    if (context.mounted) Navigator.of(context).pop();
                                                                  }
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.blue,
                                                                foregroundColor: Colors.white,
                                                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                              ),
                                                              child: Text(
                                                                'Uniform Pricing',
                                                                style: TextStyle(fontSize: textFontSize),
                                                              ),
                                                            ),

                                                          ),
                                                        ),

                                                        SizedBox(height: spacingHeight * 2),

                                                        Flexible(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            width: double.infinity, // Force equal width
                                                            child:ElevatedButton(
                                                              onPressed: () async {
                                                                final subscriptionsProvider = context.read<SubscriptionsProvider>();

                                                                // 1️⃣ Check purchased access (excluding trial)
                                                                final bool hasPurchasedAccess = subscriptionsProvider.hasDifferentiatedActiveSubscription ||
                                                                    subscriptionsProvider.hasDifferentiatedPlusUniformCalculationProductId;

                                                                if (hasPurchasedAccess) {
                                                                  // ✅ Grant access immediately
                                                                  projectData.setProjectName("_oozz");
                                                                  Navigator.of(context).pop(); // Close any parent dialogs if open

                                                                  if (context.mounted) {
                                                                    NavigationService().navigateToScreen(
                                                                      const LandInputs(givenProjectName: '_oozz'),
                                                                      arguments: '_oozz',
                                                                    );
                                                                  }

                                                                  // Optional: show trial message if applicable
                                                                  // final bool hasTrialAccess = subscriptionsProvider.hasTrialActive;
                                                                  // if (hasTrialAccess) {
                                                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                                                  //     const SnackBar(
                                                                  //       content: Text("✅ Trial access is active.\n"),
                                                                  //       backgroundColor: Colors.green,
                                                                  //     ),
                                                                  //   );
                                                                  // }

                                                                } else {
                                                                  // 2️⃣ Show loading spinner while subscription UI loads
                                                                  showDialog(
                                                                    context: context,
                                                                    barrierDismissible: false,
                                                                    builder: (_) => const Center(
                                                                      child: CircularProgressIndicator(strokeWidth: 3),
                                                                    ),
                                                                  );

                                                                  try {
                                                                    // 3️⃣ Call the real subscription UI (it handles errors internally)
                                                                    await subscriptionsProvider.showDifferentiatedSubscriptionUI(context);
                                                                  } finally {
                                                                    // 4️⃣ Close spinner dialog after completion
                                                                    if (context.mounted) Navigator.of(context).pop();
                                                                  }
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.blue,
                                                                foregroundColor: Colors.white,
                                                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                              ),
                                                              child: Text(
                                                                'Differentiated Pricing',
                                                                style: TextStyle(fontSize: textFontSize),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),


                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: spacingHeight *3),

                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),

                                        SizedBox(width: spacingHeight),


                                        IconButton(
                                          color: Colors.white,
                                          icon:
                                          Icon(Icons.remove_red_eye,
                                              size: iconSizeLarge),
                                          onPressed: () async {
                                            // Clear the list of all project data to ensure it starts fresh.
                                            allProjectsData.clear();

                                            // Update the user interface to reflect that there are currently no projects available.
                                            setState(() {});

                                            // Count how many projects have been selected by checking the selectedRows list for true values.
                                            int trueCount = selectedRows
                                                .where((element) => element)
                                                .length;


                                            // Clear the project name list in the projectData object to prepare for new selections.
                                            projectData.projectNameList.clear();

                                            // Iterate through the selectedRows list to find which projects have been selected.
                                            for (int i = 0; i <
                                                selectedRows.length; i++) {
                                              // If the current row is selected, add the corresponding project to the selectedProjects list.
                                              if (selectedRows[i]) {
                                                selectedProjects.add(
                                                    snapshot.data![i][1]);
                                                projectData.projectNameList.add(
                                                    snapshot.data![i][1]);
                                              }
                                            }

                                            // Check if no projects have been selected.
                                            if (selectedProjects.isEmpty) {
                                              // Show a dialog to inform the user that they need to select a project.
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Error', style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: titleFontSize
                                                    ),),
                                                    content: Text(
                                                      'Please select a project.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        color: Colors
                                                            .black45, // Set the text color to white
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('OK',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                            color: Colors.red, // Set the text color to white
                                                          ),),
                                                        onPressed: () {
                                                          // Close the dialog when the user presses the OK button.
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (trueCount == 1) {
                                              int selectedIndex = selectedRows.indexOf(true);
                                              String pricingType = snapshot
                                                  .data![selectedIndex][10];
                                              String projectName = snapshot
                                                  .data![selectedIndex][1];

                                              if (pricingType ==
                                                  'differentiated') {
                                                projectData.setProjectName(projectName);
                                                projectData.projectNameList.clear();
                                                NavigationService().navigateToScreen(
                                                  LandInputs(givenProjectName: projectName),
                                                  arguments: projectName,
                                                );
                                              }
                                              else if
                                              (pricingType == 'uniform') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultUniformCalculationPage(
                                                          shouldRetrieveData: 1,
                                                          givenResultUniformProjectName: projectName,
                                                          landAreaValue: 0,
                                                          landPricePerMeter: 0,
                                                          buildabilityPercentageOrAreaValue: 0,
                                                          floorCommonAreaValue: 0,
                                                          otherCostValue: 0,
                                                          permitPerMeterBoolValue: 0,
                                                          permitPerMeterOrTotalCostValue: 0,
                                                          totalNumberOfFloorsValue: 0,
                                                          numberOfSaleableFloorsValue: 0,
                                                          apartmentSellPricePerMeterValue: 0,
                                                          buildablePercentageBoolValueResult: 0,
                                                          constructionCostPerMeterValue: 0,
                                                          totalNumberOfPropertiesValue: 0,
                                                          numberOfInvestmentYearsValue: 0,
                                                        ),
                                                  ),
                                                );
                                              }
                                            }
                                            else if (trueCount > 1) {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(''),
                                                    content: Text(
                                                      'Please select just one project.',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                        color: Colors.black45
                                                        ,
                                                      ),),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('OK',
                                                          style: TextStyle(
                                                            fontSize: isIpadDevice
                                                                ? 33
                                                                : 20,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),),
                                                        onPressed: () {
                                                          // Close the dialog when the user presses the OK button.
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),

                                        SizedBox(width: spacingHeight),
                                        if (allProjectsData.isNotEmpty)
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.white,
                                                size: iconSizeLarge),
                                            onPressed: () {
                                              for (int i = 0;
                                              i < selectedRows.length;
                                              i++) {
                                                if (selectedRows[i]) {
                                                  selectedProjects.add(
                                                      snapshot.data![i][1]);
                                                }
                                              }
                                              if (selectedProjects.isEmpty) {
                                                // Show a pop-up message if no project is selected
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                      BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                      Text(
                                                          'No Project Selected',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,)),
                                                      content: Text(
                                                        'Please select a project.',
                                                        style: TextStyle(
                                                          fontSize: textFontSize,
                                                          color: Colors.black45,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                        ),),
                                                      actions: <Widget>[
                                                        TextButton(child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                            fontSize: textFontSize,
                                                            color: Colors
                                                                .red, // Set the text color to white
                                                          ),),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              else {
                                                // Show a confirmation pop-up before deleting the projects
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                      BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Confirm Deletion'
                                                          , style: TextStyle(
                                                        fontSize: textFontSize,color: Colors.pink)),
                                                      content: Text(
                                                          'Are you sure you want to delete the selected project?'
                                                          , style: TextStyle(
                                                        fontSize: textFontSize,)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('No',
                                                              style: TextStyle(
                                                                fontSize: textFontSize,)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Yes',
                                                              style: TextStyle(
                                                                fontSize: textFontSize,color: Colors.red)),
                                                          onPressed: () async {
                                                            // Build a map: projectName -> calculationType
                                                            final Map<String, String> calcTypeByProject = {};
                                                            for (int i = 0; i < selectedRows.length; i++) {
                                                              if (selectedRows[i]) {
                                                                final String projectName = snapshot.data![i][1];
                                                                final String calculationType = snapshot.data![i][10];
                                                                calcTypeByProject[projectName] = calculationType;
                                                              }
                                                            }

                                                            // Proceed with the deletion of the selected projects
                                                            for (String projectName in calcTypeByProject.keys) {
                                                            final String calculationType = calcTypeByProject[projectName]!;

                                                            // Check calculation type and call appropriate deletion method
                                                            if (calculationType.toLowerCase().contains('differentiated')) {
                                                            // Delete from differentiated database
                                                            await DifferentiatedCalculationDatabaseHelper
                                                                .deleteProjectOfDifferentiatedCalculationDatabase(projectName);
                                                            } else if (calculationType.toLowerCase().contains('uniform')) {
                                                            // Delete from uniform database
                                                            await UniformCalculationDatabase
                                                                .deleteProjectOfUniformCalculationDatabase(projectName);
                                                            } else {
                                                            // Unknown type or fallback - delete from both for safety
                                                            print('⚠️ Unknown calculation type "$calculationType" for project "$projectName"');
                                                            await DifferentiatedCalculationDatabaseHelper
                                                                .deleteProjectOfDifferentiatedCalculationDatabase(projectName);
                                                            await UniformCalculationDatabase
                                                                .deleteProjectOfUniformCalculationDatabase(projectName);
                                                            }

                                                            // Always delete from the all projects page database
                                                            await AllProjectsPageDatabase
                                                                .deleteProjectFromAllProjectsPageData(projectName, calculationType);
                                                            }

                                                            // Initialize an empty list to store the deleted indexes
                                                            List<
                                                                int> deletedIndexes = [
                                                            ];

                                                            for (int i = 0;
                                                            i < selectedRows
                                                                .length;
                                                            i++) {
                                                              if (selectedRows[i]) {
                                                                // If the row is selected, add its index to the deletedIndexes list
                                                                deletedIndexes
                                                                    .add(i);
                                                              }
                                                            }
                                                            deleteProjects(
                                                                deletedIndexes);

                                                            // Retrieve the updated project data
                                                            //     List<List<dynamic>> updatedProjectProviderData = await _getAllProjectProviderData();

                                                            // Update the data list with the updated project data
                                                            setState(() {});

                                                            // Show a message at the bottom of the screen
                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Selected project(s) have been deleted.\n\n'),
                                                                  backgroundColor: Color(
                                                                      0xFF9A87BE),
                                                                ),
                                                              );
                                                            }
                                                            Navigator.of(
                                                                context).pop();
                                                            // Close the bottom sheet

                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),

                                        SizedBox(width: spacingHeight),

                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: iconSizeLarge,
                                          ),
                                          onPressed: () async {
                                            // Show an alert dialog to confirm deletion
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Delete All Projects'
                                                      , style: TextStyle(
                                                    fontSize: textFontSize,)),
                                                  content: Text(
                                                      'This icon allows you to delete all projects either from uniform '
                                                          'pricing type or differentiated pricing type or refresh the app to resolve potential issues.'
                                                          '\n\nAre you sure you want to delete all project(s) or refresh the app? '
                                                          'If you press Yes you need to open app again.'
                                                      , style: TextStyle(
                                                    fontSize: textFontSize,)),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancel',
                                                        style: TextStyle(
                                                          fontSize: textFontSize,
                                                          color: Colors
                                                              .blue,),),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text('Yes', style:
                                                      TextStyle(
                                                        fontSize: textFontSize,
                                                        color: Colors.blue,),),
                                                      onPressed: () async {
                                                        // Delete all projects
                                                        await DifferentiatedCalculationDatabaseHelper
                                                            .deleteDifferentiatedCalculationDatabaseHelper();

                                                        await AllProjectsPageDatabase
                                                            .deleteAllProjectsPageDatabase();

                                                        await UniformCalculationDatabase
                                                            .deleteUniformCalculationDatabase();

                                                        allProjectsData.clear();
                                                        await showDialog(
                                                          context: context,
                                                          builder: (
                                                              BuildContext context) {
                                                            return
                                                              AlertDialog(
                                                                title: Text(''),
                                                                content: Text(
                                                                    'Please close the app and open it again.'
                                                                    ,
                                                                    style: TextStyle(
                                                                      fontSize: textFontSize,)),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator
                                                                          .of(
                                                                          context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                          fontSize: textFontSize,)),
                                                                  ),
                                                                ],
                                                              );
                                                          },
                                                        );


                                                        // Update the UI to reflect the absence of projects
                                                        setState(() {});

                                                        // Push the HomePage onto the stack
                                                        /*      NavigationService().navigateToScreen(
                                                const HomePage(backgroundImages: [
                                                  'assets/images/home (1).jpeg',
                                                  'assets/images/home (2).jpeg',
                                                  'assets/images/home (4).jpeg',
                                                  'assets/images/home (7).jpeg',
                                                  'assets/images/home (11).jpeg',
                                                  'assets/images/home (12).jpeg',
                                                  'assets/images/home (13).jpeg',
                                                  'assets/images/home (14).jpeg',
                                                ],),
                                              );
                      */


                                                        // Close the dialog
                                                        if (mounted) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        const Expanded(
                                          child: SizedBox.shrink(),
                                        ),
                                        //      if (allProjectsData.isNotEmpty)
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Introduction',
                                                    style: TextStyle(
                                                      fontSize: titleFontSize,
                                                      color: Colors.pink,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),),
                                                  content: SingleChildScrollView(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [

                                                          TextSpan(
                                                            text: 'Uniform Pricing',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nUse a constant rate for the sale price and a constant rate for the '
                                                                'construction cost and permit cost per unit area for each part of a building project '
                                                                'to calculate project profitability',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n\nDifferentiated Calculation',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nMaximize accuracy: input custom sale '
                                                                'prices and construction & permit costs per unit area for each part of a building '
                                                                'project to generate a '
                                                                'detailed profitability report.\n',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nAdding a New Project',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nIf you want to start a new project, you should press ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons
                                                                  .add_circle_sharp,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .black, // Set the color of the icon
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '. When you press this icon, a dialog will pop up asking you'
                                                                ' to select whether you want to perform a uniform pricing or '
                                                                'a differentiated pricing. If you choose to proceed with the uniform '
                                                                'calculation, you\'ll get a quick estimate of the project\'s cost-benefit. '
                                                                'If you choose to proceed with the differentiated pricing, you\'ll '
                                                                'get a more detailed and comprehensive analysis. Once you\'ve '
                                                                'entered the data, you can save the project and it will be '
                                                                'added to the list of saved projects.',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '\n\nViewing Project Details',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nWhen you save a project, it will be listed in the table at the top of the page. '
                                                                'You can view the details of each project by selecting that project in the '
                                                                'list and pressing ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons
                                                                  .remove_red_eye,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .black, // Set the color of the icon
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '. This will take you to the project\'s page, '
                                                                'where you can see all the profitability results of that project based '
                                                                'on the data you entered when you created the project. '
                                                                'However, you can also view additional results in a summary table in the '
                                                                'last page of the projects with differentiated pricing type. '
                                                           //     'allowing you to compare different projects saved from either '
                                                           //     'the uniform or differentiated pricing. You can sort the rows '
                                                           //     'by pressing the title of each column in the table. For example, '
                                                            //    'if you want to sort the projects based on cost, simply click on '
                                                            //    'the "Cost" header in the table.'
                                                            ,
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n\nBack to First Page',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nIf you want to go back to the main page, press ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.home,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .black, // Set the color of the icon
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '.\n\nDeleting a Project',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '\nTo delete a specific project, select the project '
                                                                'you want to delete from the table at the top of '
                                                                'the page and press white ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.delete,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .black, // Set the color of the icon
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '.\n\nDeleting All Projects',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\nIf you want to delete all the projects you have saved, press ',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.delete,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .red, // Set the color of the icon
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '. This will delete all the projects shown in the table at the top of the page.',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '\n\nSaving a Project',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),

                                                          TextSpan(
                                                            text: '\nTo save a specific project, in the result page of that project press '
                                                            ,
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons.save,
                                                              // The icon you want to display
                                                              size: iconSizeSmall,
                                                              // Set the size of the icon
                                                              color: Colors
                                                                  .black, // Set the color of the icon
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' When saving a project, you will be asked to enter your project’s '
                                                                'social and environmental friendliness level. '
                                                                'You can use the information provided in Society and Environment parts on the first page of the app '
                                                                'and, it\'s better, consult with specialists to assign '
                                                                'a value from 1 to 10 (where 10 is the best and 1 is the worst). Among '
                                                                'projects with equal profitability, this rating '
                                                                'helps you compare which project better aligns with social and environmental goals.',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),


                                                          TextSpan(
                                                            text: '\n\nIt\'s important to note that the calculations in this app '
                                                                'provide results for your investment both without factoring in the'
                                                                ' duration of the project, and then with considering the duration. Typically, you '
                                                                'should divide your project '
                                                                'profit by the number of years from the start of construction to the '
                                                                'sale of all properties. For example, if a project yields a 40% profit '
                                                                'and can be constructed in 1.5 years with an additional six months for '
                                                                'selling all units of project, your annual profit would be 20%.'
                                                                '\n\nLarger projects usually require more time to construct and sell. Therefore, '
                                                                'if a project has a 60% profit over three years, you might consider two '
                                                                'smaller projects, each with a 60% profit, that can be completed and '
                                                                'realized in two years. By choosing the second option, you can achieve '
                                                                'a 60% profit on your investment one year sooner with higher annual profit.\n\n',
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'OK', style: TextStyle(
                                                        fontSize: titleFontSize,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.help_center_rounded,
                                            color: Colors.white,
                                            size: iconSizeLarge,),
                                        ),
                                        SizedBox(width: spacingHeight * 2),
                                      ],
                                    ),
                                    // const MyBannerAdWidget(),
                                    SizedBox(height: spacingHeight),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                );
              }
          );
        });
  }
}
