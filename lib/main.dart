import 'dart:math';
import 'package:construction_profit_calculator_english/simple_calc_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:construction_profit_calculator_english/social.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'all_projects.dart';
import 'package:provider/provider.dart';
import 'billing_provider.dart';
import 'database.dart';
import 'land.dart';
import 'navigation_service.dart';
// import 'routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ProjectData instance
  final projectData = ProjectData();
  final subscriptionsProvider = SubscriptionsProvider(projectData);

  // Initialize subscriptions
//  await subscriptionsProvider.initializeSubscriptions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: projectData),
        ChangeNotifierProvider.value(value: subscriptionsProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Profit Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Define the ProjectData class for updating
class ProjectData extends ChangeNotifier {
  String _projectName = '_oozz';
  int _firstStartingFloor = 0;
  List<String> _projectNameList = [];

  String get projectName => _projectName;
  int get firstStartingFloor => _firstStartingFloor;
  List<String> get projectNameList => _projectNameList;

  void setProjectName(String newName) {
    _projectName = newName;
    notifyListeners();
  }

  void setFirstStartingFloor(int value) {
    _firstStartingFloor = value;
    notifyListeners();
  }

  void setProjectNameList(List<String> newList) {
    _projectNameList = newList;
    notifyListeners();
  }
}


/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  // Initialize subscriptions
  final subscriptionsProvider = SubscriptionsProvider(ProjectData());
  try {
    await subscriptionsProvider.initializeSubscriptions();
  } catch (e) {
    print("Subscription initialization failed: $e");
  }


 // await MobileAds.instance.initialize(); // Initialize the Mobile Ads SDK

  // for using just testin ads make the above line comment and run this:
*//*  RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: ["56612CEE57EE40526F1ADA5B6AE61104"]);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);*//*

      runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProjectData(),
        ),
        ChangeNotifierProvider<SubscriptionsProvider>( create: (context) =>
            SubscriptionsProvider( Provider.of<ProjectData>(context, listen: false), ),
        ),
      ],
      child: MyApp(),
    ),
  );
}*/


class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  final List<String> backgroundImages = [
    'assets/images/home (1).jpeg',
    'assets/images/home (2).jpeg',
    'assets/images/home (4).jpeg',
    'assets/images/home (7).jpeg',
    'assets/images/home (11).jpeg',
    'assets/images/home (12).jpeg',
    'assets/images/home (13).jpeg',
    'assets/images/home (14).jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: HomePage(backgroundImages: backgroundImages),

      navigatorKey: NavigationService().navigationKey,
      routes: NavigationService().routes,
    );
  }
}

typedef ValueSetterWithIndex<T> = void Function(T value, int index);

class HomePage extends StatefulWidget {
  final List<String> backgroundImages; // Declare a field for the images

  const HomePage({super.key, required this.backgroundImages}); // Accept the list in the constructor

  @override
  State createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>
{

  bool _visible = false;
  bool calculatorVisible = false;
  late String responseId = '';
  bool isBannerVisible = true;

  final _landFocusNode = FocusNode();
  final _landPriceFocusNode = FocusNode();
  final _floorsFocusNode = FocusNode();
  final _parkingFloorsFocusNode = FocusNode();
  final _percentageFocusNode = FocusNode();
  final _areaFocusNode = FocusNode();
  final _staircaseAreaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _landFocusNode.addListener(_onFocusChange);
    _landPriceFocusNode.addListener(_onFocusChange);
    _floorsFocusNode.addListener(_onFocusChange);
    _parkingFloorsFocusNode.addListener(_onFocusChange);
    _percentageFocusNode.addListener(_onFocusChange);
    _areaFocusNode.addListener(_onFocusChange);
    _staircaseAreaFocusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
  //    _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    // Comment out Firebase for iOS testing if not needed
    /*
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  */

    // Initialize subscriptions
    final subscriptionsProvider = context.read<SubscriptionsProvider>();
    try {
      bool initialized = await subscriptionsProvider.initializeSubscriptions();
      if (!initialized && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to initialize subscriptions")),
        );
      }
    } catch (e) {
      print("Subscription initialization failed: $e");
    }
  }

  @override
  void dispose() {
    _landFocusNode.removeListener(_onFocusChange);
    _landPriceFocusNode.removeListener(_onFocusChange);
    _floorsFocusNode.removeListener(_onFocusChange);
    _parkingFloorsFocusNode.removeListener(_onFocusChange);
    _percentageFocusNode.removeListener(_onFocusChange);
    _areaFocusNode.removeListener(_onFocusChange);
    _staircaseAreaFocusNode.removeListener(_onFocusChange);

    _landFocusNode.dispose();
    _landPriceFocusNode.dispose();
    _floorsFocusNode.dispose();
    _parkingFloorsFocusNode.dispose();
    _percentageFocusNode.dispose();
    _areaFocusNode.dispose();
    _staircaseAreaFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    debugPrint("_landFocusNode.hasFocus ${_landFocusNode.hasFocus}");
    debugPrint("_landPriceFocusNode.hasFocus ${_landPriceFocusNode.hasFocus}");
    debugPrint("_floorsFocusNode.hasFocus ${_floorsFocusNode.hasFocus}");
    debugPrint("_parkingFloorsFocusNode.hasFocus ${_parkingFloorsFocusNode.hasFocus}");
    debugPrint("_percentageFocusNode.hasFocus ${_percentageFocusNode.hasFocus}");
    debugPrint("_areaFocusNode.hasFocus ${_areaFocusNode.hasFocus}");
    debugPrint("_areaFocusNode.hasFocus ${_areaFocusNode.hasFocus}");
  }

  void showKeyboard() {
    setState(() {
      _visible = !_visible;
      if (calculatorVisible = false) {}
    }
    );
  }


  Future<void> launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'tarashekaft@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Construction App Feedback',
        'body': 'Dear Developer,\n\n'
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email client';
    }
  }

 /* void shareApp() {
    const String appLink = 'https://play.google.com/store/apps/details?id=com.tec4dev.construction_profit_calculator_english';
    const String appName = 'Construction Profit Calculator';

    Share.share(
      'Check out $appName: $appLink',
      subject: 'Share $appName',
    );
  }*/

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _showReviewModeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String username = '';
        String password = '';
        String errorMessage = ''; // Local state for error message

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
                  ElevatedButton(
                    onPressed: () async {
                      if (_validateCredentials(username, password)) {
                        Navigator.of(context).pop();
                        NavigationService().navigateToScreen(
                          const SimpleCalculationPage1(givenSimpleProjectName: 'wwmm'),
                          arguments: 'wwmm',
                        );
                      } else {
                        setState(() {
                          errorMessage = 'The username or password is incorrect.';
                        });

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      ' Simple Calculation ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                 /* ElevatedButton(
                    onPressed: () async {
                      if (_validateCredentials(username, password)) {
                        Navigator.of(context).pop();
                        final projectData = Provider.of<ProjectData>(context, listen: false);
                        await CompleteCalculationDatabaseHelper.deleteProjectBasicData("_oozz");
                        await CompleteCalculationDatabaseHelper.deletePermitFeeDataByProjectName('_oozz');
                        final projectNames = await CompleteCalculationDatabaseHelper.getAllProjectNames();
                        if (projectNames.contains("_oozz")) {
                          await CompleteCalculationDatabaseHelper.deleteProjectOfCompleteCalculationDatabase("_oozz");
                        }
                        projectData.projectNameList.clear();
                        projectData.setProjectName('_oozz');
                        NavigationService().navigateToScreen(
                          const LandInputs(givenProjectName: '_oozz'),
                          arguments: '_oozz',
                        );
                      } else {
                        setState(() {
                          errorMessage = 'The username or password you entered is incorrect.';
                        });

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      ' Complete Calculation ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),*/
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _validateCredentials(String username, String password) {
    return username == 'demoUser' && password == 'demo123Password';
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.7;
    const double textFieldFontSize = 20.0;
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
    final textFontSize = isIpad ? fontSizePad : textFieldFontSize;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    //final navigationProvider = Provider.of<ProjectData>(context, listen: false);
    final randomIndex = Random().nextInt(widget.backgroundImages.length);

    return  Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImages[randomIndex]), // Use widget.backgroundImages
            fit: BoxFit.fill,
          ),
        ),
    
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                  
                children: [

                /*  Row(
                    children: [
                      SizedBox(
                        width: 50, // Width of the hidden button
                        height: 50, // Height of the hidden button
                        child: GestureDetector(
                          onTap: () {
                            print('Hidden button pressed');
                            _showReviewModeDialog();
                          },
                          child: Container(
                            color: Colors.transparent, // Make it transparent to be hidden
                          ),
                        ),
                      ),
              Expanded( child: Container(), ),// This will ensure the GestureDetector stays at the start ),
                    ],
                  ),*/
                  
                  Center(
                    child: Column(   crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 100,),
                  
                        SizedBox(width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {NavigationService().navigateToScreen(const ExpandedTopicsPage());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900], // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3), // Add rounded corners
                              ),
                          //    padding: const EdgeInsets.all(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,10),
                              child: Text(
                                'Society & Real Estate',
                                style: TextStyle(
                                  fontSize: titleFontSize, // Increase the font size of the text
                                  color: Colors.white, // Set the text color to white
                                ),
                              ),
                            ),
                          ),
                        ),
                  
                        SizedBox(height:  spacingHeight),
                  
                        SizedBox(width:buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              NavigationService().navigateToScreen(const EnvironmentPage());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900], // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3), // Add rounded corners
                              ),
                              padding: const EdgeInsets.all(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,10),
                              child: Text('Environment & Real Estate',
                                style: TextStyle(
                                  fontSize: titleFontSize, // Increase the font size of the text
                                  color: Colors.white, // Set the text color to white
                                ),
                              ),
                            ),
                          ),
                        ),
                  
                        SizedBox(height:  spacingHeight),
                  
                        SizedBox(width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              NavigationService().navigateToScreen(const EconomicsOfConstructionPage());
                  
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900], // Set the background color to blue
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                           //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,10),
                              child: Text(
                                'Economy & Real Estate',
                                style: TextStyle(
                                  fontSize: titleFontSize, // Set the font size of the text
                                  color: Colors.white, // Set the text color to white
                                ),
                              ),
                            ),
                          ),
                        ),
                  
                        SizedBox(height:  spacingHeight),
                  
                        SizedBox(width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: ()      {
                              if (1 == 1) {
                              NavigationService().navigateToScreen(const AllProjectsPage());
                               /* Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AllProjectsPage()),
                                );*/
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error',style: TextStyle(
                                        fontSize: textFontSize,)),
                                      content: Text('Please fill all required fields.'
                                          ,style: TextStyle(
                                        fontSize: textFontSize,)),
                                      actions: [
                                        TextButton(
                                          child: const Text(
                                              'Please fill all required fields. Inputs should be valid numbers '
                                                  '(digits and an optional decimal point only, like: 123, 123.5, '
                                                  '0.66) and must not include letters (e.g., a, b, c) or symbols '
                                                  '(e.g., \$, %, &). Additionally, trailing (e.g., .1)'
                                                  ' decimal points are not allowed.\n\n',
                                              style: TextStyle(
                                                fontSize: textFieldFontSize,)),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Colors.deepOrange, //fromRGBO(197, 158, 4, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                           //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,10),
                              child: Text(
                                'ROI Calculation',
                                style: TextStyle(
                                  fontSize: titleFontSize, // Set the font size of the text
                                  color: Colors.black, // Set the text color to white
                                ),
                              ),
                            ),
                          ),
                        ),
                    //    Expanded(child: SizedBox(height: MediaQuery.of(context).size.height * 0.3),)
                      ],
                    ),
                  ),//Expanded(child: Spacer()),
                  SizedBox(height: MediaQuery.of(context).size.height * .2,),


                  Row(
                    children: [const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[900], //.withValues(alpha: 0.7),
                          //    shape: BoxShape.circle, // Makes the background circular. Remove if you want a rectangle.
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        //    SizedBox(height:  spacingHeight ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      //     title: const Text('Error'),
                                      content: SingleChildScrollView(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '\nWelcome to your comprehensive real estate companion app.'
                                                    ' Starting here you will find:\n\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '• App Overview\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.blue,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '• App Benefits\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.blue,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '• ROI Tool Guidance\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.blue,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '• Audiences',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,color: Colors.blue,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nApp Overview', style: TextStyle(
                                                fontSize: textFontSize,color: Colors.pink,fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                               TextSpan(
                                                text: '\nThis '
                                                    'app is designed to help through the complex and multifaceted world of real estate.'
                                                    '\n\nThe app is divided into four main sections:\n\n'
                                                    '1. Social Aspect:\nExplore the interplay between individual and community behaviors, and how they shape the dynamics of the real estate market across different city districts and property types.'
                                                    '\n\n2. Environmental Aspect:\nAnalyze the environmental issues related to real estate construction and the use of existing properties, including energy efficiency, water management, and sustainability.'
                                                    '\n\n3. Economic Insights:\nDive into the analytical theories behind the effects of different types of homes, development projects, and market activities on property prices and the overall real estate economy.'
                                                    '\n\n4. Financial calculators:\nThe standout feature of this app is the Investment Analyzer. '
                                                    'The two powerful tools provided in the return on investment (ROI) part of the app '
                                                    'allow you to input the specifications of a property or development project '
                                                    'and receive detailed projections on the potential cost benefit of the project. '
                                                    'Compare different scenarios side-by-side to make the most informed decisions '
                                                    'for your real estate investments.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  //  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\n\nBenefits of the App',
                                                style: TextStyle(
                                                  fontSize: titleFontSize,
                                                  color: Colors.pink,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\nUnderstanding Key Factors Beyond Profitability\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'The app highlights significant factors in real estate beyond '
                                                    'just project profitability, providing valuable insights that enable informed decision-making.\n\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'Financial Calculations: Simple '
                                                    'and Complete ROI Tools\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'The fourth section focuses on financial calculations, offering both '
                                                    'simple and complete tools For calculating '
                                                    'cost and income of investment in a construction project '
                                                    'beneficial for:\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '• Users Lacking Calculation Knowledge: The app simplifies the process for those unfamiliar with assessing costs and profits.\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '• Experienced Users: Some may be prone to calculation errors due to oversight or laziness. The app helps minimize these risks with a straightforward interface.\n\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'Simple Comparison of Projects\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'The app allows users to compare the profitability of allocating a fixed investment across different projects while adjusting for key variables. For instance, choosing a less expensive plot can free up funds for larger or more luxurious projects, while selecting a higher-value district may increase land costs, leaving less for construction. Higher selling prices in prime locations do not always guarantee greater profits. Simply comparing the projects enables users to make strategic decisions.\n\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'Analytical Metrics:\n',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: 'Apart from income, cost, and profit, the app provides key metrics for better analytics, such as the percentage of total costs attributed to land purchasing and permission fees, which are usually paid at the start of a project. This information is more readily available in the complete calculation results, allowing you to make more strategic decisions by understanding the relative significance of each cost component.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nROI Tool Guide', style: TextStyle(
                                                fontSize: textFontSize,color: Colors.pink,fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                               TextSpan(
                                                text: "\nThe ROI calculators of the app provides you with "
                                                    "two ways to assess the potential profitability of a construction Investment"
                                                    ": a simple calculation and a complete calculation.\n\nIn the Simple "
                                                    "Calculation, you can easily input the key information about the "
                                                    "construction of a building, including costs and "
                                                    "sell price per square meter (m²) or square foot (ft²). Based on this data,"
                                                    " the app will quickly generate the results of the investment analysis, "
                                                    "including the projected return on investment and other key financial "
                                                    "metrics.\n\nThis simple mode is great for getting a quick, high-level "
                                                    "understanding of the potential viability of a real estate construction project"
                                                    "that uses a uniform pricing model. "

                                                    "\n\nFor a more comprehensive analysis, you "
                                                    "can use the Complete Calculation feature. In this mode, you can define "
                                                    "specific costs and sell prices per m²/ft² for each individual property "
                                                    "or even different segments of a single property. This allows you to build a "
                                                    "detailed, multi-faceted investment model and get a more accurate and "
                                                    "insightful set of results.\n\nThe Complete Calculation by having a "
                                                    "price differentiation model gives you the "
                                                    "ability to account for the nuances and complexities of real estate "
                                                    "development, providing you with a deeper understanding of the potential "
                                                    "risks and rewards. This can be especially simplify feasibility study of large and "
                                                    "complex projects.\n\nYou can access the full instructions and guidance "
                                                    "on how to use tools and interpret the information on each page by tapping the "
                                                    "question mark icon located on that page. This will "
                                                    "provide you with step-by-step walkthroughes and examples to ensure you get "
                                                    "the most out of the app's powerful investment analysis capabilities.",
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\n\nAudiences', style: TextStyle(
                                                fontSize: titleFontSize,color: Colors.pink,fontWeight: FontWeight.bold,
                                              ),
                                              ),

                                               TextSpan(
                                                text: '\nInvestors',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nReal estate investors, '
                                                    'both institutional and individual, who provide capital for '
                                                    'property acquisitions, developments and projects.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nDevelopers',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nReal estate developers who acquire land, obtain financing, oversee construction and bring new properties to market.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nBuyers and Sellers',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nIndividuals and businesses who purchase or sell residential and commercial properties.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nReal Estate Investment Analyzers',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nProfessionals who provide consultation and analysis to investors in the real estate market, helping them make informed decisions about their investments.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nEconomists',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nEconomists who are focused on analyzing and forecasting trends in the real estate market.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nLenders',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nBanks, mortgage companies and other lenders who provide financing for real estate purchases and developments.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nAttorneys',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nLawyers who provide legal counsel on real estate transactions and contracts.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nTitle Companies',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nFirms that research property titles, issue title insurance and facilitate closings.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nArchitects and Engineers',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nDesign professionals who create plans for new construction and renovations.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nConstruction Companies',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nContractors who build new properties and renovate existing ones.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nLocal Governments and Policymakers',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nMunicipal authorities who zone land, approve developments and provide public infrastructure.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nCommunity Groups',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nNeighborhood associations and advocacy organizations that influence local real estate issues.',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                ),
                                              ),

                                               TextSpan(
                                                text: '\n\nReal Estate Brokerages',
                                                style: TextStyle(
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                               TextSpan(
                                                text: '\nBrokerage firms and real estate agents who facilitate transactions between buyers and sellers.',
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
                                          child: Text('OK',   style: TextStyle(
                                            fontSize: isIpad ? 40 : 28,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.help_center_rounded,size:  iconSizeLarge,
                                  color: Colors.white70),
                            ),
                            SizedBox(height: spacingHeight),
                          /*  IconButton(
                              icon: Icon(Icons.share, size:  iconSizeLarge, color: Colors.deepOrange),
                              onPressed: shareApp, // Use the shareApp function directly
                              tooltip: 'Share App',
                            ),*/
                            SizedBox(height:  spacingHeight ),
                            IconButton(
                              icon: Icon(Icons.email
                                  , size:  iconSizeLarge, color: Colors.white70), // Close icon
                              onPressed: () {
                                launchEmail();
                              },
                            ),

                            SizedBox(height:  spacingHeight),
                          ],
                        ),
                      ),
                     SizedBox(width:  spacingHeight,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    ));

  }
}


///////////////////////////////////////////////////////////////// Result page


////////////////////////////////////////////////////////////////////////////

