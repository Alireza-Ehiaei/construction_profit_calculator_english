import 'package:construction_profit_calculator_english/result_differentiated.dart';
import 'package:flutter/material.dart';
import 'package:construction_profit_calculator_english/permit_fees.dart';
import 'all_projects.dart';
import 'database.dart';
import 'land.dart';
import 'main.dart';
import 'otherCost.dart';
import 'costPrices.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  NavigationService._internal();

  factory NavigationService() => _instance;

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomePage(backgroundImages: []),
    '/allProjects': (context) => const AllProjectsPage(),
    '/landInputs': (context) => LandInputs(
      givenProjectName: ModalRoute.of(context)!.settings.arguments as String,
    ),
    '/CostPrices': (context) => CostPrices(
      givenProjectName: ModalRoute.of(context)!.settings.arguments as String,
  //    firstStartingFloor: ModalRoute.of(context)!.settings.arguments as int,
      givenCppValue: ModalRoute.of(context)!.settings.arguments as int,
    ),
    '/floorRanges': (context) => FloorRangesPage(
      givenProjectName: ModalRoute.of(context)!.settings.arguments as String,
   //   givenMaxConstructionValue: int.parse(ModalRoute.of(context)!.settings.arguments as String),
   //   firstStartingFloorForFloorRangesPage: int.parse(ModalRoute.of(context)!.settings.arguments as String),
    ),
    '/permitFeeInputs': (context) => PermitFeeInputs(
      givenProjectName: ModalRoute.of(context)!.settings.arguments as String,
  //    givenMaxConstructionValue: ModalRoute.of(context)!.settings.arguments as int,
      floorRangesData: ModalRoute.of(context)!.settings.arguments as List<List<dynamic>>,
      maxFloorParsedToPermitFee: ModalRoute.of(context)!.settings.arguments as int,
   //   firstStartingFloorForPermitFee: int.parse(ModalRoute.of(context)!.settings.arguments as String),
    ),
    '/otherCost': (context) => OtherCosts(
      givenProjectName: ModalRoute.of(context)!.settings.arguments as String,
      //    givenMaxConstructionValue: ModalRoute.of(context)!.settings.arguments as int,
   //   givenFloorRangesData: ModalRoute.of(context)!.settings.arguments as List<List<dynamic>>,
   //   givenMaxFloorNumber: ModalRoute.of(context)!.settings.arguments as int,
   //   givenFirstStartingFloorForPermitFee: int.parse(ModalRoute.of(context)!.settings.arguments as String),
    ),
    '/ResultPage': (context) => const ResultPage1(),
  };

  Future<dynamic> navigateToScreen(Widget page, {arguments}) async {
    return navigationKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic> replaceScreen(Widget page, {arguments}) async {
    return navigationKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void goBack([dynamic popValue]) {
    return navigationKey.currentState?.pop(popValue);
  }

  void popToFirst() {
    return navigationKey.currentState?.popUntil((route) => route.isFirst);
  }
}