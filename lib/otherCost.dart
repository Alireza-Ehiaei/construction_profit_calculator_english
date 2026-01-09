import 'dart:math';
import 'package:construction_profit_calculator_english/result_differentiated.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'all_projects.dart';
import 'database.dart';
import 'land.dart';
import 'main.dart';
import 'navigation_service.dart';
import 'permit_fees.dart';

class OtherCosts extends StatefulWidget {
  final String givenProjectName;
 // final List<List<dynamic>> givenFloorRangesData;
 // final int givenMaxFloorNumber;

  const OtherCosts({
    super.key,
    required this.givenProjectName,
  //  required this.givenFloorRangesData,
  //  required this.givenMaxFloorNumber,

  });

  @override
  State<OtherCosts> createState() => _OtherCostsState();
}

class _OtherCostsState extends State<OtherCosts> {

  late String projectName1;
  TextEditingController transactionCostsController = TextEditingController();
  TextEditingController otherCostController = TextEditingController();
  TextEditingController yardConstructionCostsController = TextEditingController();
  TextEditingController numberOfSalablePropertiesController = TextEditingController();
  TextEditingController numberOfInvestmentYearsController = TextEditingController();

  bool obscureText = true;
  List<AreaTableRowData> areaTableData = [];
  List<PriceTableRowData> priceTableData = [];

  int rowIndex = 0;
  int columnIndex = 0;
  // late InterstitialAdManager interstitialAdManager;

  int constructionValue = 1;
  List<List<PriceTableRowData>> priceTables = [];
  bool hasData = false;
  int selectedValue = 0;
  bool showLandPrice = true;
  late int startingFloor;
  List<List<dynamic>> givenFloorRangesData = [];
  int givenMaxFloorNumber = 0;

  @override
  void initState() {
    super.initState();
    projectName1 = widget.givenProjectName;
  //  givenFloorRangesData = widget.givenFloorRangesData;
  //  givenMaxFloorNumber = widget.givenMaxFloorNumber;
    startingFloor = Provider.of<ProjectData>(context, listen: false).firstStartingFloor;
    checkBasicData();

    //   interstitialAdManager = InterstitialAdManager();
    //   interstitialAdManager.loadInterstitialAd();
  }

  @override
  void dispose() {
    //   interstitialAdManager.dispose();
    super.dispose();
  }

  void checkBasicData()
  async {

    final projectBasicData = await
    DifferentiatedCalculationDatabaseHelper.getProjectBasicData(projectName1);

    if (projectBasicData.isNotEmpty)
    {
      yardConstructionCostsController.text = formatNumber(projectBasicData[0].projectBasicTableYardConstructionCostPerMeter);
      transactionCostsController.text = formatNumber(projectBasicData[0].projectBasicTableTransactionCosts);
      otherCostController.text = formatNumber(projectBasicData[0].projectBasicTableOtherCosts);
      numberOfSalablePropertiesController.text = formatNumber(projectBasicData[0].projectBasicTableNumberOfSalableProperties);
      numberOfInvestmentYearsController.text =  formatNumber(projectBasicData[0].projectBasicTableNumberOfInvestmentYears);
    }

  }

  String formatNumber(double value) {
    if (value == 0) return '0';
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);  // 2 decimals for non-whole
  }

  String formatNumberWithThousandSeparator(num number)
  {
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
      //  int integerPart = number.truncate();

      // Get the decimal part and convert to double
      // double decimalPart = (number - integerPart).toDouble();

      // Format with up to two decimal places
      formattedNumber = NumberFormat("#,###.##").format(number);

      // Remove trailing zeros if both decimals are zero or only one decimal is non-zero
      formattedNumber = formattedNumber.replaceAll(RegExp(r'(\.0+|\.00)$'), '');
    }

    return formattedNumber;
  }

 /* int maxDivisibleByThree(num num)
  {
    String numStr = num.toString().split('.')[0];
    int numDigits = numStr.length;

    while (numDigits % 3 != 0) {
      numDigits--;
    }

    return  pow(10, numDigits-1).toInt();
  }*/

  int completeThreeDigitBatches(num num) {
    String numStr = num.toString().split('.')[0];
    int numDigits = numStr.length;
    int ss = numDigits -2;  // Integer division
    return  pow(10, ss).toInt();
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

    const ipadBreakpoint = 850.0; // or your preferred breakpoint


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
              color: const Color.fromRGBO(0, 42, 78, 1.0),
              child: SafeArea(
                child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,2,8,0),
                              child: Container(color: const Color.fromRGBO(1, 29, 53, 1.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.7,
                                        ),
                                        child: Text(
                                          projectData.projectName == "***" ? " Other Costs"
                                              : projectData.projectName == "_oozz" ? "Other Costs"
                                              : '${projectData.projectName} Other Costs    ',
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
                                        'step 4/4 ',
                                        style: TextStyle(color: Colors.white, fontSize: textFontSize),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: spacingHeight),

                            Column(
                              children: [
                                SizedBox(height: spacingHeight),
                                Column(
                                  children: [
                                    SizedBox(height: spacingHeight),

                                    Row(
                                      children: [  SizedBox(width: textFontSize),
                                        Expanded(
                                          flex: 3,
                                          child:
                                          Text('Transaction Costs (%)', style: TextStyle(
                                            fontWeight: FontWeight.bold,color: Colors.white,  fontSize: textFontSize,
                                          ),),
                                        ),

                                        const SizedBox(width: 3.0),
                                        Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: transactionCostsController,
                                              decoration: InputDecoration(

                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                              keyboardType: TextInputType.number, 
                                              style: TextStyle(fontSize: textFontSize), )
                                        ),


                                        const SizedBox(width: 12.0),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text('Transaction costs', style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: textFontSize
                                                  ),),
                                                  content:  SingleChildScrollView(
                                                    child: Text('\nTransactional costs in real estate refer to the '
                                                        'various fees and taxes paid by the buyer and seller to complete '
                                                        'a property transaction, such as transfer taxes, stamp duty, '
                                                        'registration fees, notary expenses, real estate commission and legal fees.'
                                                        ' You should enter the percentage value associated with the '
                                                        'transaction costs as seller of the properties. '
                                                        'The app will then multiply that percentage to the total price '
                                                        'value of the property, and the result will be considered as an '
                                                        'additional cost to be added to other costs.'
                                                        '\n\nFor example, if the total transactional costs are 5% of the '
                                                        'property price, you would enter "5" in the corresponding field '
                                                        'and no need to attach percentage sign. '
                                                        'Then if the property price is 500,000 \$, the transactional '
                                                        'costs would be calculated as 5% of 500,000 \$, which '
                                                        'equals 25,000 \$. This 25,000 \$ would '
                                                        'then be added to the other costs associated with the property.\n\n'
                                                        'It\'s important to note that the specific transaction'
                                                        ' costs and their amounts can vary depending on the '
                                                        'location, property type, and lender. It\'s best to consult '
                                                        'with a real estate professional or a mortgage lender for a '
                                                        'more accurate estimate of the transaction costs for a specific property.\n\n'
                                                        , style: TextStyle(fontSize: textFontSize,
                                                        )),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,color: Colors.blue,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.yellow,),
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
                                          Text('Yard Construction Cost (ft²)'
                                            , style: TextStyle(
                                              fontWeight: FontWeight.bold,color: Colors.white,  fontSize: textFontSize,
                                            ),),
                                        ),

                                        const SizedBox(width: 3.0),
                                        Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: yardConstructionCostsController,
                                              decoration: InputDecoration(
                                                hintText:  '' ,
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                              keyboardType: TextInputType.number, 
                                              style: TextStyle(fontSize: textFontSize), )
                                        ),


                                        const SizedBox(width: 12.0),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text('Yard Construction Cost', style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: textFontSize
                                                  ),),
                                                  content:  SingleChildScrollView(
                                                    child: Text(
                                                      '\nIn this app, the total area of yard is considered equal '
                                                          'to the area of'
                                                          ' land purchased minus constructed area in the ground floor.'

                                                      'For example, if a plot of land has 1,000 ft², of which 600 ft² is used for building, '
                                                          'then the area of the yard is also 400 ft². \n\n'
                                                          'Usually, the cost of constructing the yard is considered in the construction '
                                                          'cost (per ft²/m²) of the built-up area. '
                                                          'In this case, there is no need to separately enter a positive cost for '
                                                          'yard construction; you can enter zero here.\n\n'
                                                          'However, if you have not accounted for the cost of yard '
                                                          'construction in the built-up area cost, or if you have additional '
                                                          'modifications on the yard that are not included in the built-up '
                                                          'area construction cost, and you want to calculate these costs separately, '
                                                          'enter the cost of construction of yard per ft²/m² here.\n\n'


                                                          ' The construction cost of the yard includes the costs associated with '
                                                          'constructing the walls, garden, and other expenses like plumbing, electricity, and landscaping. '
                                                          'These costs are all factored into the overall construction cost of yard. '
                                                          'These expenses can be broken down into the total area of the and yard to achieve '
                                                          'yard construction cost per ft²/m².'

                                                          'Also, If you know the total cost of construction of yard, not cost per per ft²/m², you '
                                                          'can enter zero here and add it '
                                                          'to the "Other Costs" value below to be added directly to total costs, but '
                                                          'if you prefer to have cost of each section like yard separately you have to '
                                                          'enter the cost of construction of yard per ft²/m².\n\n'
                                                      , style: TextStyle(
                                                      fontSize: textFontSize,
                                                    ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,color: Colors.blue,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.yellow,),
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
                                          Text('Other Costs', style: TextStyle(
                                            fontWeight: FontWeight.bold,color: Colors.white,  fontSize: textFontSize,
                                          ),),
                                        ),

                                        Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: otherCostController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                              keyboardType: TextInputType.number, 
                                              style: TextStyle(fontSize: textFontSize),)
                                        ),
                                        const SizedBox(width: 12.0),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text('Other Costs', style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: textFontSize
                                                  ),),
                                                  content:  SingleChildScrollView(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: '\nExcept for construction cost per ft²/m², and permit '
                                                                'fee per ft²/m²,  as those will be calculated separately '
                                                                'in the next pages the other costs field refers to any '
                                                                'additional expenses related to the real estate project '
                                                                'that are not already accounted for in the previous cost '
                                                                'fields and are not directly correlated to the ft²/m² construction'
                                                                ' costs. This can include costs for items like investment consulting,'
                                                                ' and any other miscellaneous expenses like: \n',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n- Home inspection fees: These are fees paid to a professional home '
                                                                'inspector to assess the condition of the property. The cost varies '
                                                                'depending on the size and age of the home.\n',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n- Pest inspection fees: These are fees paid to a professional '
                                                                'pest control company to inspect the property for termites and '
                                                                'other wood-destroying insects.\n',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n- Survey fees: These are fees paid to a professional surveyor '
                                                                'to determine the boundaries of the property and ensure there are no encroachments.\n',
                                                            style: TextStyle(
                                                              fontSize: textFontSize,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '\n- Homeowner\'s association (HOA) fees: If the property is part '
                                                                'of an HOA, the buyer may be responsible for paying a portion '
                                                                'of the HOA fees at closing.\n\n',
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
                                                        fontWeight: FontWeight.bold,color: Colors.blue,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.yellow,),
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
                                          Text('Number of Properties', style: TextStyle(
                                            fontWeight: FontWeight.bold,color: Colors.white, fontSize: textFontSize,
                                          ),),
                                        ),

                                        Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: numberOfSalablePropertiesController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                              keyboardType: TextInputType.number, 
                                              style: TextStyle(fontSize: textFontSize),)
                                        ),
                                        const SizedBox(width: 12.0),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text('Number of Properties', style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: textFontSize
                                                  ),),
                                                  content:  SingleChildScrollView(
                                                    child: Text('\nThe number of properties refers to the '
                                                        'total number of separate units or dwellings within a building '
                                                        'that could be sold to buyers. It is not related to the cost-price '
                                                        'segments or permit fee segments you\'ve defined in previous parts.'
                                                        'Number of properties is determined by '
                                                        'the number of floors in the building and the number of properties on each floor.'
                                                        '\n\nFor example, if a building has 3 floors above the ground floor '
                                                        'which is used fully for parking, and floors 1 and 2 has 2 '
                                                        'properties and floor number 3 has 1 property, '
                                                        'then the total number of properties is 5, '
                                                        'regardless of the individual areas of those properties.\n',
                                                      style: TextStyle(
                                                        fontSize: textFontSize,
                                                      ),),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,color: Colors.blue,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:  Icon(Icons.question_mark_sharp, size: iconSizeSmall, color: Colors.yellow,),
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
                                          Text('Investment period', style: TextStyle(
                                            fontWeight: FontWeight.bold,color: Colors.white , fontSize: textFontSize,
                                          ),),
                                        ),


                                        const SizedBox(width: 3.0),
                                        Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: numberOfInvestmentYearsController,
                                              decoration: InputDecoration(

                                                filled: true,
                                                fillColor: Colors.grey[100],
                                              ),
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(fontSize: textFontSize), )
                                        ),


                                        const SizedBox(width: 12.0),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:  Text('Investment period', style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: Colors.green[900],fontSize: textFontSize
                                                  ),),
                                                  content:  SingleChildScrollView(
                                                    child: Text('The number of years you expect the investment in the '
                                                        'project to take, from the start of construction'
                                                        ' until the sell of all units, when the profit or '
                                                        'loss of the project is fully determined.'
                                                        '\n\nFor example, if the project is built in one year'
                                                        ' and you anticipate that it will take two years to sell all the units'
                                                        ' you should enter the number 3 as the investment period.'
                                                        '\n\nYou must enter this time period in years, i.e.'
                                                        ' If a project takes 16 months, enter 1.25 and '
                                                        ' If it takes 18 months, enter 1.5'
                                                        , style: TextStyle(fontSize: textFontSize,
                                                        )),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text('OK', style: TextStyle(fontSize: textFontSize,
                                                        fontWeight: FontWeight.bold,color: Colors.blue,
                                                      ),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:  Icon(Icons.question_mark, size: iconSizeSmall,  color: Colors.yellow,),
                                        ),
                                        SizedBox(width: spacingHeight),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                    )
                    ),
                
                
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return SingleChildScrollView (
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: textFontSize),
                
                                IconButton(
                                  icon: Icon(Icons.home, color: Colors.white, size: iconSizeLarge),
                                  onPressed: () async {
                                    //       await interstitialAdManager.showInterstitialAd(context);
                                    // This callback will be executed after the ad is shown
                                    NavigationService().navigateToScreen(
                                      LandInputs(
                                        givenProjectName: projectName1,
                                      ),
                                    );
                
                                  },
                                ),
                
                                const SizedBox(width: 46),


                                IconButton(
                                  icon:  Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white, size: iconSizeLarge),
                                  onPressed: () async {
                                    if (numberOfSalablePropertiesController.text.isEmpty ||
                                        !isValidNumber(numberOfSalablePropertiesController.text) ||

                                        numberOfInvestmentYearsController.text.isEmpty ||
                                        !isValidNumber(numberOfInvestmentYearsController.text) ||

                                        yardConstructionCostsController.text.isEmpty ||
                                        !isValidNumber(yardConstructionCostsController.text) ||
                                        otherCostController.text.isEmpty ||
                                        !isValidNumber(otherCostController.text) ||
                                        transactionCostsController.text.isEmpty ||
                                        !isValidNumber(transactionCostsController.text)
                                    )
                                    {
                                     showErrorDialog1(context);
                                    }
                                    else {
                                      await DifferentiatedCalculationDatabaseHelper
                                          .updateProjectBasicDataRemaining(
                                        projectName1,
                                        double.parse(yardConstructionCostsController.text),
                                        double.parse(
                                            transactionCostsController.text),
                                        double.parse(otherCostController.text),
                                        double.parse(
                                            numberOfSalablePropertiesController.text),
                                        double.parse(
                                            numberOfInvestmentYearsController.text),
                                      );
                                      //We check all fields in return pressing condition because sometimes they
                                      // are initial and if they are not saved later we'll be lost but
                                      // No need to check if number of years invested and numberOfSalableProperties
                                      // is zero because when the forward arrow icon is pressed it will be checked
                                      NavigationService().navigateToScreen(
                                        // From here it shouldn't go to permit fee inputs because it cannot refresh floor ranges
                                        FloorRangesPage(
                                          givenProjectName: projectName1,
                                          //    firstStartingFloorForFloorRangesPage: startingFloor,
                                        ),
                                        arguments: {
                                          'givenProjectName': projectName1,
                                          //       'firstStartingFloorForFloorRangesPage': startingFloor,
                                        },
                                      );
                                    }
                                  },
                                ),

                                const SizedBox(width: 46),
                
                                IconButton(
                                  icon:  Icon(Icons.leaderboard_outlined,
                                      color: Colors.white,  size: iconSizeLarge),
                                  onPressed: ()
                                  async {

                                    if (numberOfSalablePropertiesController.text.isEmpty ||
                                        !isValidNumber(numberOfSalablePropertiesController.text) ||
                                        ( double.parse(numberOfSalablePropertiesController.text) == 0.0) ||

                                        numberOfInvestmentYearsController.text.isEmpty ||
                                        !isValidNumber(numberOfInvestmentYearsController.text) ||
                                        ( double.parse(numberOfInvestmentYearsController.text) == 0.0) ||

                                        !isValidNumber(yardConstructionCostsController.text) ||

                                        !isValidNumber(otherCostController.text) ||

                                        !isValidNumber(transactionCostsController.text)
                                    )
                                    {
                                      // Show a popup dialog with an error message
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
                
                                            content: Text(
                                              'Please fill in all text fields.\n\n'
                                                  'Number of properties and number of years of investment cannot be zero.\n\n'
                                                  'If you don\'t have any yard construction cost, transaction costs, '
                                                  'or other costs, you can set them to zero.'
                                                  '\n\nAlso, inputs cannot be empty and should be a valid number '
                                                  "(digits and optional decimal point only, like: 123, 123.5, 0.66) "
                                                  "not including letters (e.g., a, b, c) or symbols (e.g., \$, %, &)."
                                                  " Also starting or trailing decimal point (e.g., .1 or 1.) is not allowed.",
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
                                    }
                                    else
                                    {
                                      await DifferentiatedCalculationDatabaseHelper.updateProjectBasicDataRemaining(
                                        projectName1,
                                        double.parse(yardConstructionCostsController.text),
                                        double.parse(transactionCostsController.text),
                                        double.parse(otherCostController.text),
                                        double.parse(numberOfSalablePropertiesController.text),
                                        double.parse(numberOfInvestmentYearsController.text),
                                      );
                
                
                                      final List<ProjectBasicData> projectBasicDataList = await
                                      DifferentiatedCalculationDatabaseHelper
                                          .getProjectBasicData(projectName1);
                
                                      // Call the getCostPricingData method to retrieve project data
                                      List<ProjectTableData> projectData = await
                                      DifferentiatedCalculationDatabaseHelper
                                          .getCostPricingData(projectName1);

                                      double landArea = (projectBasicDataList[0].projectBasicTableLandArea);
                                      String landAreaText = formatNumberWithThousandSeparator(
                                          landArea);

                                      int shortNumbersNumberOfZeroRemoved = projectBasicDataList[0]
                                          .projectBasicTableShortNumbersNumberOfZeroRemoved;
                                      double landPricePerMeter = (projectBasicDataList[0]
                                          .projectBasicTableLandPricePerMeter)
                                          * pow(10, shortNumbersNumberOfZeroRemoved).toInt();

                                      double costOfLand = landPricePerMeter *
                                          landArea;

                                      String costOfLandText = formatNumberWithThousandSeparator(
                                          costOfLand);

                                      double totalNumberOfFloors = (givenMaxFloorNumber ==
                                          (projectBasicDataList[0].projectBasicTableFirstFloorNumber)) ?
                                      1 : givenMaxFloorNumber -
                                          ((projectBasicDataList[0]
                                              .projectBasicTableFirstFloorNumber)) +
                                          1;

                                      String totalNumberOfFloorsText = totalNumberOfFloors
                                          .toString();


                                      ////////////// Areas
                                      double groundFloor = double.maxFinite;
                                      double totalAreaGroundFloor = 0.0;
                                      for (ProjectTableData data in projectData) {
                                        int floorNumber = int.parse(
                                            data.costPricingTableFloorNumber.toString());
                                        if (floorNumber >= 0) {
                                          if (floorNumber < groundFloor) {
                                            // Found a new lower ground floor, reset total area
                                            groundFloor = floorNumber.toDouble();
                                            totalAreaGroundFloor = data.costPricingTableSegmentArea;
                                          } else if (floorNumber == groundFloor) {
                                            // Same ground floor, accumulate area
                                            totalAreaGroundFloor += data.costPricingTableSegmentArea;
                                          }
                                        }
                                      }
                
                                      String totalAreaGroundFloorText = formatNumberWithThousandSeparator(
                                          totalAreaGroundFloor);
                
                                      double floorZeroConstructedLandPercentage = (totalAreaGroundFloor /
                                          landArea) * 100;
                                      String floorZeroConstructedLandPercentageText = '${formatNumberWithThousandSeparator(
                                          floorZeroConstructedLandPercentage)}%';
                
                                      double totalCommonArea = 0;
                                      for (ProjectTableData data in projectData) {
                                        if (data.costPricingTableSegmentSellPricePerMeter ==
                                            0) {
                                          totalCommonArea +=
                                              data.costPricingTableSegmentArea;
                                        }
                                      }
                                      String totalCommonAreaText = formatNumberWithThousandSeparator(
                                          totalCommonArea);
                
                                      // Calculate the TotalSalableArea
                                      double totalSalableArea = 0;
                                      for (ProjectTableData data in projectData) {
                                        if (data
                                            .costPricingTableSegmentSellPricePerMeter !=
                                            0) {
                                          totalSalableArea +=
                                              data.costPricingTableSegmentArea;
                                        }
                                      }
                                      String totalSalableAreaText = formatNumberWithThousandSeparator(
                                          totalSalableArea);
                
                                      double resultProjectTableTotalSalableAreaToLandArea = totalSalableArea /
                                          landArea;
                
                                      double totalConstructedArea = 0;
                                      for (ProjectTableData data in projectData) {
                                        totalConstructedArea +=
                                            data.costPricingTableSegmentArea;
                                      }
                                      String totalConstructedAreaText = formatNumberWithThousandSeparator(
                                          totalConstructedArea);
                
                                      ////////////////// Costs
                                      double totalConstructionCost = 0;
                                      for (ProjectTableData data in projectData) {
                                        totalConstructionCost +=
                                            data.costPricingTableCostOfSegment;
                                      }
                                      totalConstructionCost = totalConstructionCost *
                                          pow(10, shortNumbersNumberOfZeroRemoved).toInt();

                                      String totalConstructionCostText = formatNumberWithThousandSeparator(
                                          totalConstructionCost);
                
                                      // Calculate the Weighted averageConstructionCostPerMeter
                                      double averageConstructionCostPerMeter = totalConstructionCost /
                                          totalConstructedArea;
                                      String averageConstructionCostPerMeterText = formatNumberWithThousandSeparator(
                                          averageConstructionCostPerMeter);

                                      List<UniquePermitFeeData> uniquePermitFeeData = await DifferentiatedCalculationDatabaseHelper
                                          .getUniquePermitFeeData(projectName1);
                                      double totalPermitFee = 0;
                                      if (uniquePermitFeeData.isNotEmpty &&(
                                          uniquePermitFeeData.first.uniquePermitFeeTableIsUniquePermitFeePerMeterBool == 1
                                              || uniquePermitFeeData.first.uniquePermitFeeTableIsUniquePermitFeeTotalBool == 1))
                                      {
                                        totalPermitFee = uniquePermitFeeData.first.uniquePermitFeeTableUniquePermitFeeTotal;
                                      }
                                      else
                                      {
                                        //   print('MeterBool ${uniquePermitFeeData.first.uniquePermitFeeTableIsUniquePermitFeePerMeterBool}');
                                        //    print('TotalBool ${uniquePermitFeeData.first.uniquePermitFeeTableIsUniquePermitFeeTotalBool}');
                                        List<PermitFeeSegmentPricingData> permitFeeData =
                                        await DifferentiatedCalculationDatabaseHelper.getPermitFeeSegmentPricingData(projectName1);
                                        // Calculate the TotalPermitFee

                                        for (PermitFeeSegmentPricingData data in permitFeeData) {
                                          totalPermitFee += data.permitFeeSegmentPricingTableTotalSegmentPermitFee;
                                        }
                                      }
                                      totalPermitFee = totalPermitFee *
                                          pow(10, shortNumbersNumberOfZeroRemoved).toInt();
                                      String totalPermitFeeText = formatNumberWithThousandSeparator(totalPermitFee);

                                      //   bool yardConstructionCostsBoolValue= bool.parse(resultProjectData[0].resultProjectTableYardConstructionCostsBoolValue);


                                      double yardConstructionCostsTotalValue =
                                      ((landArea- totalAreaGroundFloor) * (projectBasicDataList[0].projectBasicTableYardConstructionCostPerMeter)
                                          * pow(10, shortNumbersNumberOfZeroRemoved).toInt());

                                      /*double yardConstructionCostsTotalValue = yardConstructionCostsBoolValue ?
                                        (landArea * double.parse(resultProjectData[0].resultProjectTableRoofAndYardConstructionCosts.replaceAll(',', ''))
                                        * pow(10, shortNumbersNumberOfZeroRemoved).toInt())
                                        : (double.parse(resultProjectData[0].resultProjectTableRoofAndYardConstructionCosts.replaceAll(',', ''))
                                        * pow(10, shortNumbersNumberOfZeroRemoved).toInt());*/
                                      String yardConstructionCostsText = formatNumberWithThousandSeparator(
                                          yardConstructionCostsTotalValue);

                                      double averagePermitFeePerMeter = totalPermitFee /
                                          totalConstructedArea;
                                      String averagePermitFeePerMeterText = formatNumberWithThousandSeparator(
                                          averagePermitFeePerMeter);

                                      double givenOtherCost = (projectBasicDataList[0].projectBasicTableOtherCosts)
                                          * pow(10, shortNumbersNumberOfZeroRemoved).toInt();
                                      String givenOtherCostText = formatNumberWithThousandSeparator((givenOtherCost));

                                      // Calculate the TotalIncome
                                      double totalIncome = 0;
                                      for (ProjectTableData data in projectData) {
                                        totalIncome +=
                                            data.costPricingTableIncomeOfSegment;
                                      }
                                      totalIncome = totalIncome *
                                          pow(10, shortNumbersNumberOfZeroRemoved)
                                              .toInt();
                                      String totalIncomeText = formatNumberWithThousandSeparator(
                                          totalIncome);
                
                                      // Calculate the Weighted average SellPricePerMeter
                                      double unitAverageSellPricePerMeter = totalIncome /
                                          totalSalableArea;
                                      String unitAverageSellPricePerMeterText = formatNumberWithThousandSeparator(
                                          unitAverageSellPricePerMeter);

                                      //  bool TransactionCostBoolValue= bool.parse(resultProjectData[0].resultProjectTableTransactionCostBoolValue);
                
                                      double transactionCostsValue =
                                      ((totalIncome * ((projectBasicDataList[0].projectBasicTableTransactionCosts)) /100));
                
                                      /*  double transactionCostsValue = TransactionCostBoolValue ?
                                    ((totalIncome * (double.parse(resultProjectData[0].resultProjectTableTransactionCosts.replaceAll(',', '')))/100))
                                        : (double.parse(resultProjectData[0].resultProjectTableTransactionCosts.replaceAll(',', ''))
                                        *pow(10, shortNumbersNumberOfZeroRemoved).toInt());
                                            */
                                      String transactionCostsText = formatNumberWithThousandSeparator(
                                          transactionCostsValue);

                                      double landPricePerMeterToAverageSellPricePerMeter = landPricePerMeter /
                                          unitAverageSellPricePerMeter;
                                      String landPricePerMeterToAverageSellPricePerMeterText = formatNumberWithThousandSeparator(
                                          landPricePerMeterToAverageSellPricePerMeter);

                                      landPricePerMeterToAverageSellPricePerMeter =
                                          landPricePerMeterToAverageSellPricePerMeter *
                                              pow(10, shortNumbersNumberOfZeroRemoved).toInt();

                                      landPricePerMeterToAverageSellPricePerMeter =
                                          landPricePerMeterToAverageSellPricePerMeter *
                                              pow(10, shortNumbersNumberOfZeroRemoved)
                                                  .toInt();
                
                                      // Calculate the SegmentMinSellPricePerMeter and SegmentMaxSellPricePerMeter
                                      double unitMinSellPricePerMeter = double
                                          .infinity; // Initialize to infinity
                                      double unitMaxSellPricePerMeter = 0; // You can keep this as is

                                      for (ProjectTableData data in projectData) {
                                        // Check if the sell price is positive
                                        if (data.costPricingTableSegmentSellPricePerMeter > 0) {
                                          // Update minimum sell price if the current price is less than the current minimum
                                          if (data.costPricingTableSegmentSellPricePerMeter <unitMinSellPricePerMeter) {
                                            unitMinSellPricePerMeter = data
                                                .costPricingTableSegmentSellPricePerMeter;
                                          }
                                          // Update maximum sell price
                                          if (data
                                              .costPricingTableSegmentSellPricePerMeter >
                                              unitMaxSellPricePerMeter) {
                                            unitMaxSellPricePerMeter = data
                                                .costPricingTableSegmentSellPricePerMeter;
                                          }
                                        }
                                      }

                                      // Check if unitMinSellPricePerMeter was updated
                                      if (unitMinSellPricePerMeter ==
                                          double.infinity) {
                                        unitMinSellPricePerMeter =
                                        0; // or handle as needed (e.g., set to null or a specific value)
                                      } else {
                                        // If you want to apply a scaling factor, do it here
                                        unitMinSellPricePerMeter *=
                                            pow(10, shortNumbersNumberOfZeroRemoved)
                                                .toInt();
                                      }
                
                                      // Apply the scaling factor to the maximum sell price as well
                                      unitMaxSellPricePerMeter *=
                                          pow(10, shortNumbersNumberOfZeroRemoved)
                                              .toInt();
                
                                      // Format the prices for display
                                      String unitMinSellPricePerMeterText = formatNumberWithThousandSeparator(
                                          unitMinSellPricePerMeter);
                                      String unitMaxSellPricePerMeterText = formatNumberWithThousandSeparator(
                                          unitMaxSellPricePerMeter);
                
                                      // Calculate the total cost
                                      double totalCosts = costOfLand +
                                          totalConstructionCost +
                                          totalPermitFee +
                                          yardConstructionCostsTotalValue +
                                          transactionCostsValue + givenOtherCost;
                
                                      String totalCostsText = formatNumberWithThousandSeparator(
                                          totalCosts);
                
                                      int tenX = completeThreeDigitBatches(totalCosts);
                                      String tenXX = formatNumberWithThousandSeparator(tenX);
                                      
                                      double allCostsIncurredPerMeterOfSalableArea = totalCosts /
                                          totalSalableArea;
                                      String allCostsIncurredPerMeterOfSalableAreaText = formatNumberWithThousandSeparator
                                        (allCostsIncurredPerMeterOfSalableArea);
                
                                      // Calculate the totalProfit
                                      double totalProfit = totalIncome - totalCosts;
                                      String totalProfitText = formatNumberWithThousandSeparator(
                                          totalProfit);

                                      // Calculate the ProfitPerSalableArea
                                      double profitPercentage = (totalProfit /totalCosts) * 100;
                                      String profitPercentageText = '${formatNumberWithThousandSeparator(
                                          profitPercentage)}%';

                                      double profitPercentageAnnually = (profitPercentage /
                                          projectBasicDataList[0].projectBasicTableNumberOfInvestmentYears);

                                      String profitPercentageAnnuallyText = '${formatNumberWithThousandSeparator(
                                          profitPercentageAnnually)}%';

                                      // Calculate the ProfitPerSalableArea
                                      double profitPerSalableArea = totalProfit /
                                          totalSalableArea;
                                      String profitPerSalableAreaText = formatNumberWithThousandSeparator(
                                          profitPerSalableArea);

                                      double landPermitFeesPerTotalCosts = (costOfLand +
                                          totalPermitFee) / totalCosts;
                                      String landPermitFeesPerTotalCostsText = formatNumberWithThousandSeparator(
                                          landPermitFeesPerTotalCosts);

                                      double neededSalableAreaToBeSoldToFinanceLandAndPermitFee = (costOfLand +
                                          totalPermitFee) /
                                          unitAverageSellPricePerMeter;

                                      String neededSalableAreaToBeSoldToFinanceLandAndPermitFeeText =
                                      formatNumberWithThousandSeparator(neededSalableAreaToBeSoldToFinanceLandAndPermitFee);

                                      double saleableAreaConstructedPerMillionCurrencySegments = (totalSalableArea *
                                          tenX) / totalCosts;
                                      String saleableAreaConstructedPerMillionCurrencySegmentsText =
                                      (saleableAreaConstructedPerMillionCurrencySegments
                                          .toStringAsFixed(2));

                                      double numberOfSalablePropertiesPerMillionCurrencySegments =
                                          ((projectBasicDataList[0]
                                              .projectBasicTableNumberOfSalableProperties) * tenX)
                                              / totalCosts;

                                      String numberOfSalablePropertiesPerMillionCurrencySegmentsText =
                                      numberOfSalablePropertiesPerMillionCurrencySegments.toStringAsFixed(2);


                                      List<List<dynamic>> consFloor = [];
                                      double costOfProject = 0;
                                      double incomeOfProject = 0;
                                      double profitOfProject = 0;


                                      for (int i = 0; i < projectData.length; i++) {
                                        bool found = false;
                                        for (int j = 0; j < consFloor.length; j++) {
                                          // if data associated to current cons and floor had been
                                          // saved add values of other units to consfloor
                                          if (consFloor[j][0] ==
                                              projectData[i].costPricingTableCpp
                                              && consFloor[j][1] == projectData[i]
                                                  .costPricingTableFloorNumber) {
                                            consFloor[j][2] += projectData[i]
                                                .costPricingTableCostOfSegment;
                                            consFloor[j][3] += projectData[i]
                                                .costPricingTableIncomeOfSegment;
                                            consFloor[j][4] += projectData[i]
                                                .costPricingTableProfitOfSegment;
                                            found = true;
                                            break;
                                          }
                                        }
                                        // if no data associated to current cons and floor
                                        // had been saved add values of other units to consfloor
                                        if (!found) {
                                          consFloor.add([
                                            projectData[i].costPricingTableCpp,
                                            projectData[i]
                                                .costPricingTableFloorNumber,
                                            projectData[i]
                                                .costPricingTableCostOfSegment,
                                            projectData[i]
                                                .costPricingTableIncomeOfSegment,
                                            projectData[i]
                                                .costPricingTableProfitOfSegment
                                          ]);
                                        }
                                      }
                                      double totalCostOfFloors = 0;
                                      double totalIncomeOfFloors = 0;
                                      double totalProfitOfFloors = 0;

                                      for (int i = 0; i < consFloor.length; i++) {
                                        double costOfFloor = consFloor[i][2];
                                        double incomeOfFloor = consFloor[i][3];
                                        double profitOfFloor = consFloor[i][4];
                                        totalCostOfFloors += costOfFloor;
                                        totalIncomeOfFloors += incomeOfFloor;
                                        totalProfitOfFloors += profitOfFloor;
                
                                        await DifferentiatedCalculationDatabaseHelper
                                            .insertOrUpdateProjectResultFloorData(
                                            projectName1, consFloor[i][0],
                                            consFloor[i][1],
                                            formatNumberWithThousandSeparator(
                                                costOfFloor * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()),
                                            formatNumberWithThousandSeparator(
                                                incomeOfFloor * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()),
                                            formatNumberWithThousandSeparator(
                                                profitOfFloor * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()));
                                      }
                                      List<List<dynamic>> consConstruction = [];
                                      for (int i = 0; i < consFloor.length; i++) {
                                        bool found = false;
                                        for (int j = 0; j <
                                            consConstruction.length; j++) {
                                          if (consConstruction[j][0] ==
                                              consFloor[i][0]) {
                                            consConstruction[j][1] += consFloor[i][2];
                                            found = true;
                                            break;
                                          }
                                        }
                                        if (!found) {
                                          consConstruction.add(
                                              [consFloor[i][0], consFloor[i][2]]);
                                        }
                                      }
                                      for (int i = 0; i <
                                          consConstruction.length; i++) {
                                        double costOfConstruction = consConstruction[i][1];
                                        double incomeOfConstruction = 0;
                                        double profitOfConstruction = 0;
                                        for (int j = 0; j < consFloor.length; j++) {
                                          if (consFloor[j][0] ==
                                              consConstruction[i][0]) {
                                            incomeOfConstruction += consFloor[j][3];
                                            profitOfConstruction += consFloor[j][4];
                                          }
                                        }
                                        await DifferentiatedCalculationDatabaseHelper
                                            .insertOrUpdateProjectResultCppData(
                                            projectName1, consConstruction[i][0],
                                            formatNumberWithThousandSeparator(
                                                costOfConstruction * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()),
                                            formatNumberWithThousandSeparator(
                                                incomeOfConstruction * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()),
                                            formatNumberWithThousandSeparator(
                                                profitOfConstruction * pow(10,
                                                    shortNumbersNumberOfZeroRemoved)
                                                    .toInt()));
                                        costOfProject += costOfConstruction;
                                        incomeOfProject += incomeOfConstruction;
                                        profitOfProject += profitOfConstruction;
                                      }
                                      double profitPercentageOfProject1 = 0;
                                      profitPercentageOfProject1 =
                                          profitOfProject / costOfProject;

                
                                      ResultProjectColumnsClassData resultProjectData_ = ResultProjectColumnsClassData(
                                        resultProjectTableId: await DifferentiatedCalculationDatabaseHelper
                                            .getNextResultProjectTableId(),
                                        resultProjectTableProjectName: widget.givenProjectName,
                                        resultProjectTablePricing: 'differentiated',

                                        resultProjectTableLandArea: landAreaText,
                                        resultProjectTableTotalNumberOfFloorsText: totalNumberOfFloorsText,
                                        resultProjectTableFloorZeroConstructedArea: totalAreaGroundFloorText,
                                        resultProjectTableFloorZeroConstructedPercentage: floorZeroConstructedLandPercentageText,
                                        resultProjectTableTotalCommonArea: totalCommonAreaText,
                                        resultProjectTableTotalSalableArea: totalSalableAreaText,
                                        resultProjectTableTotalConstructedArea: totalConstructedAreaText,

                                        resultProjectTableSegmentAverageSellPricePerMeter: unitAverageSellPricePerMeterText,
                                        resultProjectTableLandPricePerMeterToAverageSellPricePerMeter: landPricePerMeterToAverageSellPricePerMeterText,
                                        resultProjectTableSegmentMinSellPricePerMeter: unitMinSellPricePerMeterText,
                                        resultProjectTableSegmentMaxSellPricePerMeter: unitMaxSellPricePerMeterText,
                                        resultProjectTableTotalIncome: totalIncomeText,

                                        resultProjectTableAverageConstructionCostPerMeter: averageConstructionCostPerMeterText,
                                        resultProjectTableAveragePermitFeePerMeter: averagePermitFeePerMeterText,

                                        resultProjectTableCostOfLand: costOfLandText,
                                        resultProjectTableTotalConstructionCost: totalConstructionCostText,
                                        resultProjectTableTotalPermitFee: totalPermitFeeText,

                                        resultProjectTableYardConstructionCostPerMeterText: yardConstructionCostsText,
                                        resultProjectTableOtherCostsText: givenOtherCostText,

                                        resultProjectTableTotalCosts: totalCostsText,

                                        resultProjectTableTotalProfit: totalProfitText,
                                        resultProjectTableProfitPercentageOfProject: profitPercentageText,
                                        resultProjectTableProfitPerSalableArea: profitPerSalableAreaText,
                                        resultProjectTableTransactionCostsText: transactionCostsText,
                                        resultProjectTableLandPermitFeesPerTotalCosts: landPermitFeesPerTotalCostsText,
                                        resultProjectTableNeededSalableAreaToBeSoldToFinanceLandAndPermitFee: neededSalableAreaToBeSoldToFinanceLandAndPermitFeeText,
                                        resultProjectTableAllCostsIncurredPerMeterOfSalableArea: allCostsIncurredPerMeterOfSalableAreaText,
                                        resultProjectTableMicroScale: tenXX,
                                        resultProjectTableNumberOfSalablePropertiesPerMicroScale: numberOfSalablePropertiesPerMillionCurrencySegmentsText,
                                        resultProjectTableSalableAreaConstructedPerMicroScale: saleableAreaConstructedPerMillionCurrencySegmentsText,
                                        resultProjectTableTotalSalableAreaToLandArea: resultProjectTableTotalSalableAreaToLandArea
                                            .toStringAsFixed(2),
                                        resultProjectTableNumberOfSalableProperties: projectBasicDataList[0]
                                            .projectBasicTableNumberOfSalableProperties.toString(),
                                        resultProjectTableProfitPercentageAnnually: profitPercentageAnnuallyText,
                                      );

                                      await DifferentiatedCalculationDatabaseHelper.insertOrUpdateResultProjectData(
                                          resultProjectData_);

                                      if (projectName1!= '_oozz') {
                                        await AllProjectsPageDatabase.updateAllProjectsPageData(
                                          projectName1,
                                          'differentiated',
                                          totalCostsText,
                                          totalIncomeText,
                                          totalProfitText,
                                          profitPercentageText,);
                                      }

                                   //   InterstitialAdManager.showInterstitial();
                                      await Future.delayed(const Duration(seconds: 2));

                                      NavigationService().navigateToScreen(const ResultPage1());

                                  /*    if (costOfProject == totalCostOfFloors &&
                                          incomeOfProject == totalIncomeOfFloors &&
                                          profitOfProject == totalProfitOfFloors) {
                                        print('Success: Project totals match the floor totals.');
                                        NavigationService().navigateToScreen(const ResultPage1());
                                      } else {
                                        print('Error: Total cost, income, or profit of floors, constructions, '
                                            'and project are not equal.');
                                        print('Project Cost: $costOfProject, Floors Total Cost: $totalCostOfFloors');
                                        print('Project Income: $incomeOfProject, Floors Total Income: $totalIncomeOfFloors');
                                        print('Project Profit: $profitOfProject, Floors Total Profit: $totalProfitOfFloors');
                                      }*/

                                      if (!(widget.givenProjectName == "_oozz"))
                                        {
                                    await AllProjectsPageDatabase.updateProjectOtherFields(
                                        projectName: widget.givenProjectName,       // Identifies the row to update
                                        pricingType: 'differentiated',           // Your calculation type to identify the row
                                        fieldsToUpdate: {
                                          AllProjectsPageDatabase
                                              .columnAllProjectsPageProjectName: widget
                                              .givenProjectName,
                                          AllProjectsPageDatabase
                                              .columnAllProjectsPageCostOfProject: totalCostsText,
                                          AllProjectsPageDatabase
                                              .columnAllProjectsPageIncomeOfProject: totalIncomeText,
                                          AllProjectsPageDatabase
                                              .columnAllProjectsPageProfitOfProject: totalProfitText,
                                          AllProjectsPageDatabase
                                              .columnAllProjectsPageProfitPercentageOfProject: profitPercentageText,
                                        });
                                    }

                                }
                                print('sss1');
                                  },
                                ),
                
                                const SizedBox(width: 16),
                
                              ],
                            ),
                
                          );
                        },
                      ),
                    ),
                    //     const MyBannerAdWidget(),
                   //    SizedBox(height: spacingHeight  *3,),
                  ],
                ),
              ),

            ),
          );
        }
    );
  }

}
