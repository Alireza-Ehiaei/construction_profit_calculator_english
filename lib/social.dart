import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ad_mob.dart';
import 'main.dart';
import 'navigation_service.dart';

class RealEstateTopicsPage extends StatefulWidget {
  const RealEstateTopicsPage({super.key});

  @override
  RealEstateTopicsPageState createState() => RealEstateTopicsPageState();
}


class RealEstateTopicsPageState extends State<RealEstateTopicsPage> {

  bool _introductionSociety = false;
  bool _personalDevelopment = false;
  bool _affordableHousingExpanded = false;
  bool _socialInfrastructureExpanded = false;
  bool _solutionsExpanded = false;
  bool _districtDevelopmentExpanded = false;
  final ScrollController _scrollControllerSo = ScrollController();


  @override
  void dispose() {
    _scrollControllerSo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/icon.PNG'),
            fit: BoxFit.cover,  // cover entire screen
          ),
        ),
        height: MediaQuery.of(context).size.height,
        constraints: const BoxConstraints.expand(),
      //  color: const Color.fromRGBO(136, 96, 35, 1.0),
        child:
        // color: const Color.fromRGBO(100, 2, 10, 1.0),
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100,),

                    SizedBox(width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () {NavigationService().navigateToScreen(const ExpandedTopicsSocietyPage());
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
                  ],
                ),
              ),
            ),

            IconButton(
                icon:  Icon(Icons.home,
                    color: Colors.white, size: iconSizeLarge),
                onPressed: () {
                  NavigationService().navigateToScreen(
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
                }),
            SizedBox(height: 2 * spacingHeight),
            //    const MyBannerAdWidget(),
          ],
        ),
      ),
    );
  }
}




class ExpandedTopicsSocietyPage extends StatefulWidget {
  const ExpandedTopicsSocietyPage({super.key});

  @override
  ExpandedTopicsSocietyPageState createState() => ExpandedTopicsSocietyPageState();
}

class ExpandedTopicsSocietyPageState extends State<ExpandedTopicsSocietyPage> {
  bool _introductionSociety = false;
  bool _personalDevelopment = false;
  bool _affordableHousingExpanded = false;
  bool _socialInfrastructureExpanded = false;
  bool _solutionsExpanded = false;
  bool _districtDevelopmentExpanded = false;
  final ScrollController _scrollControllerSo = ScrollController();


  @override
  void dispose() {
    _scrollControllerSo.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        constraints: const BoxConstraints.expand(),
        color: const Color.fromRGBO(94, 2, 9, 1.0),
          child:
       // color: const Color.fromRGBO(100, 2, 10, 1.0),
         Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   SizedBox(height: 3 * spacingHeight),

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text( 'Society and Real Estate Market',
                         style: TextStyle(color: Colors.white
                             , fontSize: titleFontSize, fontWeight: FontWeight.bold),
                       ),
                     ),


                   SizedBox(height: spacingHeight),

                      SizedBox(width:buttonWidth,
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _introductionSociety = !_introductionSociety;
                                 _personalDevelopment = false;
                                 _affordableHousingExpanded = false;
                                 _socialInfrastructureExpanded = false;
                                 _solutionsExpanded = false;
                                 _districtDevelopmentExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Introduction',
                                style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                            )
                          ),
                        ),
                      ),

                  if (_introductionSociety)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\n\nThe Social Dimension of the Home Industry',
                                          style: TextStyle(
                                            fontSize: titleFontSize,

                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nThe real estate market has a profound impact on society, '
                                              'shaping the lives of individuals, families, and communities. '
                                              'From a social perspective, the attributes of people are intrinsically '
                                              'linked to the places they live and work. Individuals seeking a home or '
                                              'groups like families and companies are in a mutual relationship with '
                                              'their homes and city districts. The quality of a home and neighborhood '
                                              'directly influences various aspects of life, while simultaneously, '
                                              'actions and choices impact the character of surroundings.\n\n'
                                          /*    'Individual variables like health and education, along with social factors '
                                              'such as community engagement and neighborhood security, are all influenced '
                                              'by the characteristics of homes and districts. '
                                              'While these changes often occur gradually over time, they are primarily '
                                              'driven by economic variables like income and housing prices. However, '
                                              'other factors like education, culture, religion, politics, and the '
                                              'environment can also contribute to the evolution of neighborhoods and '
                                              'communities. The interplay between these variables creates a complex '
                                              'and dynamic relationship between people and their living environments.\n\n'*/
                                              'In this part of the app, we will provide a short review of the social '
                                              'problems relating to property development and finally offer some solutions '
                                              'to address these issues.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                            //
                                          ),
                                        ),
                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: spacingHeight),


                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _affordableHousingExpanded = !_affordableHousingExpanded;
                                _personalDevelopment = false;
                                _introductionSociety = false;
                                _socialInfrastructureExpanded = false;
                                _solutionsExpanded = false;
                                _districtDevelopmentExpanded = false;

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Housing Instability', style:
                              TextStyle(color: Colors.black, fontSize: textFontSize),),
                            )
                        ),
                      ),

                  if (_affordableHousingExpanded)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '\nThe Social Impacts of Unaffordable Housing',
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                           fontWeight: FontWeight.bold, color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nRising rents and home prices are making housing unaffordable '
                                            'for low and middle-income families in many areas. This leads '
                                            'to homelessness, overcrowding, and displacement.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),

                                      TextSpan(
                                        text: '\n\nOvercrowding',
                                        style: TextStyle(
                                       fontWeight: FontWeight.bold
                                          , color: Colors.pink, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nFaced with high rents, multiple families may have to '
                                            'share a single home. Overcrowding leads to:\n\n'
                                            '▶ Lack of privacy and personal space\n'
                                            '▶ Increased stress and tension within families\n'
                                            '▶ Higher risk of illness due to close living quarters',

                                        style: TextStyle(

                                          fontSize: textFontSize,
                                          color: Colors.black,),
                                      ),

                                      TextSpan(
                                        text: '\n\nDisplacement',
                                        style: TextStyle(
                                         fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nAs rents rise, long-term residents are often forced '
                                            'to move out of their neighborhoods. Displacement disrupts social '
                                            'ties and community cohesion, leading to:\n\n'
                                            '▶ Loss of support networks and access to local resources\n'
                                            '▶ Difficulty maintaining employment and children\'s education\n'
                                            '▶ Feelings of rootlessness and loss of identity',
                                        style: TextStyle(

                                          fontSize: textFontSize,
                                          color: Colors.black,),
                                      ),

                                      TextSpan(
                                        text: '\n\nHomelessness',
                                        style: TextStyle(
                                         fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nWhen housing becomes unaffordable, many families and '
                                            'individuals are forced to live on the streets or in shelters. '
                                            'Homelessness has severe social consequences, including:\n\n'
                                            '▶ Lack of safety and stability, especially for children\n'
                                            '▶ Difficulty maintaining employment and accessing healthcare\n'
                                            '▶ Social isolation and stigma\n',

                                        style: TextStyle(

                                          fontSize: textFontSize,
                                          color: Colors.black,),
                                      ),

                                      TextSpan(
                                        text: '\n\nThe Mental Impacts of Achieving Access to Quality Housing',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\n▶ Access to qualified homes significantly enhances mental well-being. '
                                            'The privacy and security of a stable living environment foster a sense of safety, '
                                            'while increased self-esteem and a sense of pride and accomplishment arise from achieving '
                                            'homeownership or securing a good rental. These factors contribute to '
                                            'overall emotional stability and happiness.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text:  '\n\n▶ Homelessness and housing instability are major risk '
                                            'factors for mental illness. Lack of privacy and safety in '
                                            'shelters and on the streets takes a heavy psychological toll'

                                            '\n\n▶ Neighborhoods with high concentrations of poverty often'
                                            ' have less access to parks, and sport facilities,'
                                            ' which can negatively impact both physical and mental health'

                                            '\n\n▶ For long-term renters who aspire to own but are unable to, '
                                            'their unmet homeownership goals and substandard housing conditions '
                                            'can lead to decreased happiness '
                                            'and self-esteem. The social stigma and personal disappointment of '
                                            'not being a homebuyer, despite their best efforts, can take an '
                                            'emotional toll on long-term renters. Addressing these psychological '
                                            'impacts is important for supporting the well-being of those navigating the '
                                            'challenges of affordable housing.\n\n',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),

                                         TextSpan(text: 'References\n',  style: TextStyle(
                                        fontSize: textFontSize,fontWeight: FontWeight.bold,
                                      ),),
                                      TextSpan(
                                        text: 'The Social Impacts of Unaffordable Housing',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://trreb.ca/examining-the-social-impact-of-housing-unaffordability/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),

                                   /*   TextSpan(
                                        text: '\n\nUnderstand the broader social implications of housing crises',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://wealthwithpurpose.com/god-money/housing-crisis-impact/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/

                                      TextSpan(
                                        text: '\n\nExplore unaffordable housing in Europe',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.eurofound.europa.eu/en/publications/2023/unaffordable-and-inadequate-housing-europe');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),

                                      TextSpan(
                                        text: '\n\nHomelessness',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://commonbond.org/whats-the-community-impact-when-theres-a-lack-of-affordable-housing/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nLearn more about ending homelessness through affordable housing',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://endhomelessness.org/improve-access-to-affordable-housing/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),


                                      TextSpan(
                                        text: '\n\nLearn more about housing affordability policies',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.habitat.org/what-we-do/policy-and-advocacy/housing-affordability');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: 'Displacement',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.housingfinance.com/policy-legislation/unaffordable-housing-a-root-cause-of-social-inequality_o');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nUnderstand displacement in housing crises',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.sightline.org/2016/08/10/displacement-the-gnawing-injustice-at-the-heart-of-housing-crises/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nExplore displacement and gentrification\n\n',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.urban.org/research/publication/displacement-and-gentrification');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),


                                    ]
                                )
                            )
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: spacingHeight),

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _personalDevelopment = !_personalDevelopment;
                                _introductionSociety = false;
                                _affordableHousingExpanded = false;
                                _socialInfrastructureExpanded = false;
                                _solutionsExpanded = false;
                                _districtDevelopmentExpanded = false;

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Personal-Family Development'
                                , style: TextStyle(color: Colors.black,
                                    fontSize: textFontSize),),
                            )
                        ),
                      ),



                  if (_personalDevelopment)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\n\nEducational Inequities',
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Wealthier areas tend to have better schools, parks, '
                                              'libraries, and other public amenities compared to poorer neighborhood. The quality '
                                              'of schools is closely tied to '
                                              'the property values and demographics of the surrounding '
                                              'neighborhood. Children in lower-income areas often have '
                                              'access to under-resourced schools, limiting their educational opportunities and social mobility.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Frequent moves and unstable housing can disrupt education '
                                              'of children, leading to lower test scores and higher dropout rates. '
                                              'Homelessness in particular is strongly correlated with poor educational outcomes.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n\nEmployment Challenges',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Lack of affordable housing near job centers forces '
                                              'many workers to have long commutes, reducing time for '
                                              'family and leisure. This "spatial mismatch" limits economic opportunities.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Housing instability makes it very '
                                              'difficult to maintain steady employment. '
                                              'Employers may be reluctant to hire those without a permanent address.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n\nIncompatible Marriage',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ In some cultures, the quality of a home of individuals seeking marriage, '
                                              'or the quality of the home of their families and the district they live in, '
                                              'can significantly impact the marriage prospects of those individuals, '
                                              'even if they are well-educated, attractive, or possess other desirable qualities.'
                                              ' While this practice may seem unjust, it is a reality that cannot be ignored.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),

                                      TextSpan(
                                            text: 'References\n',
                                            style: TextStyle(
                                              fontSize: textFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'The Social Impacts of Unaffordable Housing',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://trreb.ca/examining-the-social-impact-of-housing-unaffordability/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nUnderstand the broader social implications of housing crises',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://wealthwithpurpose.com/god-money/housing-crisis-impact/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                         /* TextSpan(
                                            text: '\n\nExplore unaffordable housing in Europe',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.eurofound.europa.eu/en/publications/2023/unaffordable-and-inadequate-housing-europe');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),*/
                                          TextSpan(
                                            text: '\n\nHomelessness',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://commonbond.org/whats-the-community-impact-when-theres-a-lack-of-affordable-housing/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nLearn more about ending homelessness through affordable housing',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://endhomelessness.org/improve-access-to-affordable-housing/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nLearn more about housing affordability policies',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.habitat.org/what-we-do/policy-and-advocacy/housing-affordability');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                       /*   TextSpan(
                                            text: '\n\nEmployment Challenges',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.nlc.org/article/2023/08/01/how-housing-impacts-workforce-development/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),*/
                                          TextSpan(
                                            text: '\n\nHousing instability related to job',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.huduser.gov/portal/sites/default/files/pdf/Housing-Instability-Brief.pdf');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nLocation and Employment',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.ers.usda.gov/webdocs/publications/44882/14296_err103_1_.pdf?v=43837');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nEducational Inequities',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.brookings.edu/research/ten-facts-about-k-12-education-funding/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nEffects of poverty on education',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.nea.org/nea-today/all-news-articles/poverty-and-education-explaining-achievement-gap');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nHow housing affects school achievement',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.childrensdefense.org/wp-content/uploads/2018/12/housing-as-a-determinant-of-health-and-well-being.pdf');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nIncompatible Marriage',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.pewresearch.org/religion/2017/10/05/interfaith-marriage-who-what-when-and-why/');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nSalary, societal expectation',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.bbc.com/worklife/article/20240214-how-your-salary-affects-your-love-life');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: '\n\nHome expectation\n\n',
                                            style:  TextStyle(
                                              fontSize: textFontSize,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url = Uri.parse('https://www.nytimes.com/2023/03/03/realestate/homeownership-house-dating.html');
                                                try {
                                                  if (!await launchUrl(
                                                    url,
                                                    mode: LaunchMode.externalApplication,
                                                  )) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Failed to open link')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              },
                                          ),


                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: spacingHeight),


                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _socialInfrastructureExpanded = !_socialInfrastructureExpanded;
                                _affordableHousingExpanded = false;
                                _personalDevelopment = false;
                                _introductionSociety = false;
                                _solutionsExpanded = false;
                                _districtDevelopmentExpanded = false;

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Inclusive Housing', style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                            )
                        ),
                      ),



                  if (_socialInfrastructureExpanded)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\n\nAge-friendly Housing',
                                          style: TextStyle(
                                            fontSize: titleFontSize,

                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Locating elder and disability-friendly '
                                              'homes near green spaces, parks, and community centers promotes social '
                                              'interaction and mental well-being\n\n'
                                              '▶ Easy access to public spaces encourages residents to engage in '
                                              'physical activity, participate in social events, and maintain a sense of community belonging.\n\n'
                                              '▶ Proximity to amenities reduces isolation and loneliness, '
                                              'common issues faced by older adults and individuals with disabilities.\n\n'
                                              '▶ Incorporating spaces for hobbies, socializing, and relaxation '
                                              'within the home or community setting helps reduce stress and depression.\n\n'
                                               '▶ Providing small, affordable homes with specific design features like single-floor living, '
                                              'wide doorways, and adjustable counterparts allows older adults and individuals '
                                              'with disabilities to live independently.\n\n'
                                               '▶ Locating these homes near public transportation and essential '
                                              'services ensures residents can access necessary amenities without relying '
                                              'on private vehicles.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nMarginalized groups',
                                          style: TextStyle(
                                            fontSize: titleFontSize,

                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Inclusive housing promotes diversity and aims to serve '
                                              'underrepresented populations, such as racial and ethnic minorities, '
                                              'and immigrants, providing a welcoming and supportive environment.\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),


                                        TextSpan(
                                          text: '\n\nShort-term residents',
                                          style: TextStyle(
                                            fontSize: titleFontSize,  fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Inclusive housing should offer small, affordable studio '
                                              'or one-bedroom units suitable for students, interns, temporary '
                                              'workers, or others who need housing for a few months to a few years. '
                                              'These compact spaces allow for independent living while providing'
                                              ' access to shared community amenities.\n\n',

                                          style: TextStyle(

                                            fontSize: textFontSize,
                                            color: Colors.black,),
                                        ),

                                               TextSpan(
                                          text: 'References\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nAge-Friendly Housing: Design Principles for Livable Communities',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.nchh.org/information/lead/healthy-homes-for-healthy-aging/');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nCreating Homes for Independent Living: Design for Aging in Place',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.architectmagazine.com/practice/designing-for-aging-in-place_o');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nPromoting Inclusive Housing: Expanding Housing Opportunities for Low-Income Families',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.urban.org/research/publication/how-expand-housing-opportunity-low-income-families');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nAchieving Equitable Housing: Addressing the Needs of Marginalized Communities',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.policylink.org/our-work/community/equitable-development/equitable-housing');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nSmall Spaces, Big Impact: Micro-Units and Density in Urban Planning',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.pps.org/article/small-is-good-density-equity-and-the-micro-unit\n\n');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nHousing for Transient Populations: The Role of Short-Term Rentals in Urban Housing Markets\n',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.tandfonline.com/doi/full/10.1080/10511469.2020.1747763');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),


                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: spacingHeight),

                    SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                            setState(() {
                            _districtDevelopmentExpanded = !_districtDevelopmentExpanded;
                            _solutionsExpanded = false;
                            _socialInfrastructureExpanded = false;
                            _affordableHousingExpanded = false;
                            _personalDevelopment = false;
                            _introductionSociety = false;

                            });
                            },
                            style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromRGBO(
                            30, 29, 1, 1.0),
                            textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                            backgroundColor: const Color.fromRGBO(
                            236, 135, 3, 1.0), // Set the background color
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9), // Set the border radius
                            //    side: const BorderSide(color: Colors.white), // Set the border color to black
                            ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('District Development',
                              style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                            )
                            ),
                      ),


                  if (_districtDevelopmentExpanded)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container( color: Colors.grey[300],
                         child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '\n\nDistrict development refers to the process of improving '
                                              'the social, economic, and environmental conditions of '
                                              'a specific geographic area within a city or town. Not '
                                            'developed districts causes different social issues including:\n',
                                         style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nWeakened Community Identity',
                                        style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\n▶ Without a coordinated effort to improve the district, '
                                            'a sense of community identity and pride may be lacking.'
                                            '\n\n▶ The absence of community gathering spaces and events in '
                                            'underserved districts reduces opportunities for building a '
                                            'shared identity and positive local culture.\n',
                                        style: TextStyle(
                            fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nDeteriorating Infrastructure',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\n▶ Aging roads, utilities, and public '
                                            'spaces can make it difficult for home-based enterprises to operate efficiently.'
                                            ' When public spaces and utilities are outdated or in disrepair, it can create '
                                            'inefficiencies for businesses. For instance, unreliable internet connections '
                                            'or inadequate public services can disrupt business activities and limit productivity.\n',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),

                                      TextSpan(
                                        text: '\nIncompatible Businesses in Residential Areas',
                                        style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,),
                                      ),
                                      TextSpan(
                                        text: '\n\n▶ Allowing businesses that are incompatible with residential '
                                            'areas, such as certain industrial or non-standard commercial activities, '
                                           'can directly and negatively impact the quality of life for residents '
                                            'over time. Moreover, the presence of these businesses can decrease '
                                            'property values and discourage new residential construction in the '
                                            'affected district. '
                                            'This decrease in satisfaction, combined with the economic impacts '
                                            'on property values and new investment, can exacerbate social '
                                            'inequality between the affected district and other, more desirable areas of the city.'
                                            '\n\n',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nSpatial Deprivation',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\n▶ The unequal distribution of recreational resources between '
                                            'affluent and low-income neighborhoods is a clear example of spatial inequality.\n\n'
                                            '▶ Children living in disadvantaged areas often lack access '
                                            'to safe, well-maintained parks and playgrounds where they can play and exerciseconst .'
                                            ' Without affordable, nearby sports programs and facilities, many kids miss '
                                            'out on the physical, social and developmental benefits of organized athletics.'
                                            ' This can contribute to higher rates of childhood obesity, mental healthconst  '
                                            'issues, and antisocial behavior in underserved communities.\n\n'
                                            '▶ In addition to sports facilities, many disadvantaged neighborhoods lack '
                                            'well-maintained parks, plazas and other public spaces where kids can '
                                            'safely play and socialize. Poorly lit, neglected parks and playgrounds '
                                            'can become havens for crime and drug activity, further discouraging use by families. '
                                            'The absence of inviting, functional public spaces robs children of opportunities '
                                            'for free play, exploration and community bonding.\n\n',
                                          style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),


                                      TextSpan(
                                        text: '\nUnequal Districts',
                                        style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nThe inequalities between different districts within '
                                            'a city can have significant social consequences:'

                                            '\n\n▶ Spatial segregation between rich and poor neighborhoods limits '
                                            'cross-cultural understanding and empathy.'

                                            '\n\n▶ The lack of investment and visible signs of disinvestment in '
                                            'certain areas can breed resentment among residents, leading to the '
                                            'perception that the city cares more about some citizens than others.'

                                            '\n\n▶ Residents of underserved districts often feel stigmatized, '
                                            'ashamed, devalued, and disrespected by city authorities. They compare '
                                            'their neighborhoods, characterized by dilapidated infrastructure, '
                                            'lack of amenities, and high crime rates, to wealthier areas, which '
                                            'exacerbates their feelings of neglect. This structure enhances clarity '
                                            'and flow while maintaining the original meaning.\n\n',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),

                                   TextSpan(
                                        text: 'References\n',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nDistrict Development: An Overview',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.worldbank.org/en/topic/urbandevelopment/overview');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nCommunity-Led District Development',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                      color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.local.gov.uk/our-support/community-led-development');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                     /* TextSpan(
                                        text: '\n\nSustainable District Development',
                                        style:  TextStyle(
                                           fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.un.org/sustainabledevelopment/cities/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/
                                      TextSpan(
                                        text: '\n\nEnhancing Social Equity and Well-being',
                                        style:  TextStyle(
                         fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.cdc.gov/policy/hst/hi5/socialequity/index.html');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nCreating Mixed-Use Centers',
                                        style:  TextStyle(fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.smartgrowth.org/our-work/mixed-use-development/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                     /* TextSpan(
                                        text: '\n\nPrioritizing Green Infrastructure',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.epa.gov/green-infrastructure/what-green-infrastructure');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/
                                      TextSpan(
                                        text: '\n\nFostering Community Engagement',
                                         style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.thrivingcommunities.scot/what/community-engagement/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nAdapting to Demographic Shifts',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.prb.org/resources/how-demographic-change-shapes-our-world/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                     /* TextSpan(
                                        text: '\n\nBalancing Growth and Preservation\n\n',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.planning.org/pas/reports/report330/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/
                                    ]
                                )
                            )
                        ),
                      ),
                    ),
                  ),

                   SizedBox(height: spacingHeight),

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _solutionsExpanded = !_solutionsExpanded;
                                _socialInfrastructureExpanded = false;
                                _affordableHousingExpanded = false;
                                _personalDevelopment = false;
                                _introductionSociety = false;
                                _districtDevelopmentExpanded = false;

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 162, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Potential Solutions', style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                            )
                        ),
                      ),

                  if (_solutionsExpanded)
                    SingleChildScrollView(
                      controller: _scrollControllerSo,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [

                                        TextSpan(
                                          text: '\n\nAffordable Housing Development',
                                          style: TextStyle(

                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize, ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ District development plans should prioritize the creation '
                                              'of new affordable housing units, either through subsidized '
                                              'rentals or below-market rate ownership opportunities.\n\n'
                                              '▶ This could involve partnerships with non-profit developers, '
                                              'inclusionary zoning policies that require a percentage of affordable'
                                              ' units in new developments, or the conversion of existing buildings '
                                              'into affordable housing.\n\n'
                                              '▶ Locating affordable housing in downtown areas near jobs, '
                                              'transit and amenities helps low-income residents access '
                                              'opportunities and reduces transportation costs.'
                                              '\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),

                                        TextSpan(
                                          text: '\n\n\nSocial Housing',
                                          style: TextStyle(
                                            fontSize: titleFontSize,  fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nSocial housing refers to rental housing that is '
                                              'provided and managed by the government or non-profit '
                                              'organizations for those who cannot afford market-rate housing. '
                                              'The key characteristics of social housing are:\n\n'
                                              '▶ Affordability: Rents in social housing are typically set at below-market '
                                              'rates, making them affordable for low-income individuals and families.\n\n'
                                              '▶ Security of tenure: Social housing tenants often have more secure '
                                              'tenancies compared to private rental housing.\n\n'
                                              '▶ Target population: Social housing is primarily targeted towards '
                                              'vulnerable groups such as the homeless, people with disabilities, the elderly, and low-income families.\n\n'
                                              '▶ Subsidized by the government: The construction and '
                                              'operation of social housing is subsidized by the government '
                                              'to keep rents affordable.\n\n'
                                              '▶ Managed by housing authorities or non-profits: Social housing is owned and managed '
                                              'by government housing authorities or non-profit organizations.\n\n',

                                          style: TextStyle(

                                            fontSize: textFontSize,
                                            color: Colors.black,),
                                        ),

                                        TextSpan(
                                          text: '\nDistrict Development',
                                          style: TextStyle(
                                            fontSize: titleFontSize,

                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Ensuring that all neighborhoods have access to quality schools, '
                                              'parks, transportation, and other amenities is essential for '
                                              'promoting social equity in the real estate market.\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),



                                        TextSpan(
                                          text: '\n\nTenant Protections and Anti-Displacement Measures',
                                          style: TextStyle(

                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize, ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ District development should include policies '
                                              'to protect existing low-income residents from displacement '
                                              'due to rising rents and home prices.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nTargeted Subsidies and Tax Credits',
                                          style: TextStyle(

                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize, ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Offering property tax '
                                              'abatement or exemption for low-income homebuyers helps '
                                              'offset the burden of rising home values.',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Linking these subsidies to affordability covenants '
                                              'ensures the homes remain affordable for the long-term.\n\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),

                                        TextSpan(
                                          text: 'Neighborhood Revitalization without Displacement',
                                          style: TextStyle(

                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize, ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ District development should focus on improving neighborhoods '
                                              'without displacing existing low-income residents through physical '
                                              'improvements, economic development, and community capacity building.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Investing in public infrastructure, '
                                              'parks, schools and community facilities enhances '
                                              'quality of life without directly impacting housing costs.',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶ Supporting small businesses, '
                                              'job training programs, and resident-led '
                                              'initiatives helps build community wealth without driving up rents.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nSocial Infrastructure Improvement',
                                          style: TextStyle(

                                            fontSize: titleFontSize,  fontWeight: FontWeight.bold, color: Colors.blue, ),
                                        ),
                                        TextSpan(
                                          text: '\n\n▶Social infrastructure refers to the facilities, services, '
                                              'and organizational structures that support and enhance the quality '
                                              'of life and well-being of a community. It includes things like:\n'
                                              '\n▶ Public spaces (parks, plazas, community centers)'
                                        '\n\n▶ Educational facilities (schools, libraries, universities)'
                                        '\n\n▶ Healthcare facilities (hospitals, clinics, elderly care homes)'
                                        '\n\n▶ Cultural facilities (museums, theaters, concert halls)'
                                        '\n\n▶ Sports and recreation facilities (gyms, sports fields, swimming pools)'
                                        '\n\n▶ Social services (childcare, youth programs, senior centers)'
                                        '\n\n▶ Community organizations and nonprofits'
                                              '\n\n'
                                          'When planned and designed well, social infrastructure can:'
                                              '\n\n▶ Promote social inclusion and cohesion'
                                              '\n\n▶ Support child and youth development'
                                              '\n\n▶ Foster community identity and pride'
                                              '\n\n▶ Improve physical and mental health outcomes'
                                              '\n\n▶ Provide pathways to economic opportunity'
                                              '\n\n▶ Enhance environmental sustainability'
                                              '\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,

                                            color: Colors.black,
                                          ),
                                        ),

                                            TextSpan(
                                          text: 'References\n',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nAffordable Housing',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.hud.gov/topics/affordable_housing');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nSocial Housing',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.habitat.org/stories/what-is-social-housing');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nDistrict Development',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.worldbank.org/en/topic/urbandevelopment/overview');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nAffordable Housing Development',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.nlc.org/resource/affordable-housing-development-strategies-for-local-governments/');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),

                                        TextSpan(
                                          text: '\n\nTenant Protections and Anti-Displacement Measures',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.urban.org/policy-centers/cross-center-initiatives/rental-housing-policy-initiative/projects/tenant-protections-and-anti-displacement-policies');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nTargeted Subsidies and Tax Credits',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.huduser.gov/portal/pdredge/pdr-edge-featd-article-081417.html');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nNeighborhood Revitalization without Displacement',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.brookings.edu/research/gentrification-and-neighborhood-revitalization-whats-the-difference/');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nSocial Infrastructure Improvement\n\n',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.americanprogress.org/article/the-importance-of-social-infrastructure-for-community-resilience/');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),


                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: spacingHeight),


                  // Add 6 more elevated buttons for additional socially home-related topics with expandable text sections
                                      ],
                                    ),
              ),
            ),

            IconButton(
                icon:  Icon(Icons.home,
                    color: Colors.white, size: iconSizeLarge),
                onPressed: () {
                  NavigationService().navigateToScreen(const RealEstateTopicsPage());
                }),
             SizedBox(height: 2 * spacingHeight),
        //    const MyBannerAdWidget(),
          ],
        ),
      ),
    );
  }
}





class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({super.key});

  @override
  EnvironmentPageState createState() => EnvironmentPageState();
}

class EnvironmentPageState extends State<EnvironmentPage> {
  bool _introductionEnvironmental = false;
  bool _materialEnvironmentExpanded = false;

  bool _resourceEnvironmentExpanded = false;
  final ScrollController _scrollControllerEnv = ScrollController();

  @override
  void dispose() {
    _scrollControllerEnv.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {


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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color.fromRGBO(23, 105, 2, 1.0),
            child: Column(
                children: [
            Expanded(
            child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

                  children:[
                     SizedBox(height: spacingHeight * 3),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text( 'Environment and Real Estate Market',
                          style: TextStyle(color: Colors.white, fontSize: titleFontSize
                              ,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                     SizedBox(height: spacingHeight),

                     SizedBox(width:buttonWidth,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _introductionEnvironmental = !_introductionEnvironmental;
                                     _materialEnvironmentExpanded = false;
                                     _resourceEnvironmentExpanded = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color.fromRGBO(
                                      30, 29, 1, 1.0),
                                  textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                                  backgroundColor: const Color.fromRGBO(
                                      236, 135, 3, 1.0), // Set the background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9), // Set the border radius
                                    //    side: const BorderSide(color: Colors.white), // Set the border color to black
                                  ),
                                ),
                                child:  Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Introduction'
                                    , style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                                )
                            ),
                          ),


                    if (_introductionEnvironmental)
                      SingleChildScrollView(
                        controller: _scrollControllerEnv,
                        child: Container( color: Colors.grey[300],
                          child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [

                                        TextSpan(
                                          text: '\n\nEnvironmental issues are the harmful effects of human activities '
                                              'on the environment, such as pollution, waste disposal, '
                                              'global warming, ozone layer depletion, water pollution, '
                                              'air pollution, solid waste management, and deforestation. '
                                              'These issues have significant impacts on the health of the natural world, '
                                              'human health, and well-being, as well as business operations '
                                              'and organizational performance.\n\n'

                                              'Below, we discuss the environmental effects of home-based '
                                              'industries, including the types of construction materials '
                                              'used and resource consumption.\n\n',
                                          style: TextStyle(
                                            fontSize: textFontSize, 
                                          ),
                                        ),
                                      ]
                                  )
                              )
                          ),
                        ),
                      ),

                     SizedBox(height: spacingHeight),


                        SizedBox(width:buttonWidth,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _materialEnvironmentExpanded = !_materialEnvironmentExpanded;
                                  _introductionEnvironmental = false;
                                  _resourceEnvironmentExpanded = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color.fromRGBO(
                                    30, 29, 1, 1.0),
                                textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                                backgroundColor: const Color.fromRGBO(
                                    236, 135, 3, 1.0), // Set the background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9), // Set the border radius
                                  //    side: const BorderSide(color: Colors.white), // Set the border color to black
                                ),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Home Construction Materials'
                                  , style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                              )
                          ),
                        ),


                    if (_materialEnvironmentExpanded)
                      SingleChildScrollView(
                        controller: _scrollControllerEnv,
                        child: Container( color: Colors.grey[300],
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text.rich(
                                  TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\nCement and Concrete',
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                             
                                             fontWeight: FontWeight.bold, color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nCement production is energy-intensive '
                                              'and releases large amounts of carbon dioxide, contributing to climate change.',
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nSteel and Iron',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nSteel production generates significant air and water '
                                              'pollution from the smelting and processing of iron ore.\n',

                                          style: TextStyle(
                                            
                                            fontSize: textFontSize,
                                            color: Colors.black,),
                                        ),
                                        TextSpan(
                                          text: '\nWood',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nDeforestation for wood production can lead to biodiversity'
                                              ' loss and climate change.',

                                          style: TextStyle(
                                            
                                            fontSize: textFontSize,
                                            color: Colors.black,),
                                        ),

                                        TextSpan(
                                          text: '\n\n\nPotential Solutions ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nReducing Cement Content: Incorporate alternative binders '
                                              'like fly ash and slag to minimize cement usage.'
                                        '\n\n▶ Using Lightweight Materials: Opt for fiberglass reinforcement '
                                              'or recycled composite materials instead of traditional steel rebar.'
                                        '\n\n▶ Sustainable Forestry Practices: Ensure that wood products '
                                              'come from sustainably managed forests.'
                                          '\n\n▶ Recycling and Reuse: By using bolted metal structures instead '
                                              'of welded connections, these building materials can be more easily '
                                              'disassembled and reused in the future. Also, implement recycling programs for '
                                              'construction waste and use recycled materials in new projects.'
                                          '\n\n▶ Redesign Building Elements: Explore alternative, '
                                              'lightweight materials for non-structural components like building facades, '
                                              'walls around stairs, and other areas that do not require the high strength '
                                              'of cement and steel. This can help reduce the overall '
                                              'usage of these high-impact materials.\n\n',
                                          style: TextStyle(
                                            
                                            fontSize: textFontSize,
                                            color: Colors.black,),
                                        ),


                                             TextSpan(
                                          text: 'References\n',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\n\nEnvironmental Issues in Construction',
                                          style:   TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.epa.gov/smm/sustainable-management-construction-and-demolition-materials');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nCement and Concrete Environmental Impact',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.chathamhouse.org/2022/09/making-concrete-change-innovation-low-carbon-cement-and-concrete');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nSteel Production Environmental Effects',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.worldsteel.org/steel-topics/steel-markets/environment.html');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nSustainable Forestry Practices',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.fsc.org/en/what-is-fsc');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),
                                        TextSpan(
                                          text: '\n\nGreen Construction Solutions\n\n',
                                          style:  TextStyle(
                                            fontSize: textFontSize,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url = Uri.parse('https://www.usgbc.org/leed');
                                              try {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Failed to open link')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                                );
                                              }
                                            },
                                        ),


                                      ]
                                  )
                              )
                          ),
                        ),
                      ),
                     SizedBox(height: spacingHeight),

                        SizedBox(width:buttonWidth,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _resourceEnvironmentExpanded = !_resourceEnvironmentExpanded;
                                  _introductionEnvironmental = false;
                                  _materialEnvironmentExpanded = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color.fromRGBO(
                                    30, 29, 1, 1.0),
                                textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                                backgroundColor: const Color.fromRGBO(
                                    236, 135, 3, 1.0), // Set the background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9), // Set the border radius
                                  //    side: const BorderSide(color: Colors.white), // Set the border color to black
                                ),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Resource Consumption'
                                  , style: TextStyle(color: Colors.black, fontSize: textFontSize),),
                              )
                          ),
                        ),

                    if (_resourceEnvironmentExpanded)
                      Scrollbar(
                        thickness: 8.0, // Set the thickness of the scrollbar
                        radius: const Radius.circular(10), // Set the radius for rounded corners
                        thumbVisibility: true, // Al
                        child: SingleChildScrollView(
                          controller: _scrollControllerEnv,
                        child: Container( color: Colors.grey[300],
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text.rich(
                                TextSpan(
                                    children: [

                                  TextSpan(
                                    text: '\n\nEnergy Use\n',
                                    style: TextStyle(
                                     fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nReducing Fossil Fuel Dependence',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nRelying on fossil fuel-based energy sources like natural '
                                        'gas and electricity from the grid generates greenhouse gas '
                                        'emissions and environmental pollution.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nUtilizing Renewable Energy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nUtilize renewable energy sources, such as rooftop solar '
                                        'panels, to power homes and reduce dependence on non-renewable '
                                        'and polluting energy sources. Additionally, solar energy can '
                                        'be utilized directly, not just for power generation. '
                                        'For instance, installing a solar water heater is an '
                                        'effective strategy to mitigate the environmental impacts '
                                        'associated with new property. By utilizing the abundant '
                                        'and renewable energy from the sun, solar water heaters provide '
                                        'a sustainable alternative to traditional water heating methods '
                                        'that often rely on fossil fuels. '
                                        '\n\nSimilar to solar energy, geothermal energy can be utilized in '
                                        'various ways to enhance building energy efficiency:'
                                        '\n▶ Heating and Cooling'
                                        'The heat or cold stored in the earth\'s shallow depths can be used '
                                        'to regulate the interior temperature of a house. This is achieved '
                                        'through geothermal heat pumps, also known as ground-source heat pumps. '
                                        'These systems transfer heat between the ground (or a body of water) '
                                        'and the building, providing efficient heating in the winter and cooling in the summer.'
                                        '\n▶ Electricity Generation'
                                        'Geothermal energy can also be harnessed to generate electricity by '
                                        'accessing the earth\'s natural heat at deeper levels. This process '
                                        'involves using geothermal heat to evaporate water, which drives turbines '
                                        'to produce electricity. The steam or hot water is extracted from underground '
                                        'reservoirs and, after passing through the turbines, is reinjected back into '
                                        'the reservoir to maintain pressure and ensure sustainability.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nImproving Appliance and System Efficiency',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nInefficient appliances, such as refrigerators, '
                                        'washing machines, food makers, air conditioners, heaters, '
                                        'lighting, and home systems, waste excessive amounts of energy. '
                                        'These appliances contribute significantly to energy consumption '
                                        'in households, leading to higher utility bills and increased environmental impact.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\nUpgrade to energy-efficient appliances, LED lighting, and '
                                        'smart home technologies to conserve energy.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nEnhancing Insulation and Design',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nLacking home insulation, weatherization, and passive solar '
                                        'design escalates the energy required for heating and cooling.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nWeatherization and Passive Solar Design Strategies',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nWeatherization refers to the process of improving '
                                        'the energy efficiency of a home by sealing air leaks and '
                                        'adding insulation. Passive solar design is an approach '
                                        'to home design that takes advantage of the energy of sun '
                                        'for heating and cooling by strategically placing windows, '
                                        'walls, and floors, etc. So enhance home insulation, '
                                        'weatherization, and incorporate passive solar design '
                                        'elements to minimize energy needs.\n',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nWater Usage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nReducing Water Consumption',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\nHigh water consumption for indoor plumbing, landscaping, and other '
                                        'household uses depletes water resources.'
                                        '\n\nInstall water-efficient fixtures, appliances, and incorporate '
                                        'rainwater harvesting systems to preserve water.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nRecycling and Reusing Greywater',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\nGreywater refers to the wastewater'
                                        ' generated from household activities such as bathing, washing clothes,'
                                        ' and doing dishes, excluding wastewater from toilets (known as blackwater).',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nAdopt greywater recycling systems to process and repurpose household '
                                        'wastewater for landscape irrigation and other non-drinking uses.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),


                                  TextSpan(
                                    text: '\n\n\nLand Use',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nExpanding Residential Areas: The Impact on Ecosystems',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nLoss of Biodiversity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nAs natural habitats are converted to urban areas, species '
                                        'that rely on these habitats are displaced or lost.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nDegradation of Ecosystems',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nUrbanization can lead to the degradation of ecosystems, including '
                                        'the loss of soil, water, and air quality.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),


                                      TextSpan(
                                        text: '\n\nUrban Heat Island (UHI) Effects',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nUrban sprawl contribute to the urban heat island effect by '
                                            'replacing natural surfaces with impervious materials like asphalt '
                                            'and concrete. This leads to increased temperatures in urban areas '
                                            'compared to surrounding rural areas, affecting energy consumption and human health.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nStormwater Runoff',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nUrbanization significantly impacts stormwater runoff, defined as the water from rain or snowmelt that flows over impervious surfaces—such as roads, parking lots, and rooftops—without being absorbed into the ground. This process can lead to several negative consequences:\n\n'
                                            '▶ Increased Flooding: The rapid accumulation of stormwater can overwhelm drainage systems, resulting in localized flooding that can damage property and infrastructure.\n'
                                            '▶ Water Pollution: Stormwater runoff often carries pollutants, including sediments, nutrients, and chemicals, into local water bodies, degrading water quality and harming aquatic ecosystems.\n'
                                            '▶ Erosion: The increased volume and velocity of runoff can lead to soil erosion, particularly in stream banks and other natural areas, disrupting habitats and increasing sedimentation in waterways.\n'
                                            '▶ Altered Hydrology: Urbanization changes natural drainage patterns, leading to more frequent and severe peak flows in streams and rivers, which can disrupt aquatic life and alter stream morphology.\n'
                                            '▶ Public Health Risks: Contaminated stormwater can pose health risks to communities, especially if it enters drinking water supplies or recreational waters.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nLoss of Biodiversity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nHorizontal urbanization often encroach on natural habitats, '
                                            'leading to the fragmentation and destruction of ecosystems. This can result in '
                                            'the loss of biodiversity, as species struggle to adapt to the changing environment.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.black,
                                        ),
                                      ),

                                      TextSpan(
                                        text: '\n\n\nDesigning for Sustainability',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nCompact, High-Density Housing',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nDesigning housing that is compact and high-density '
                                            'can reduce the amount of land required for development, '
                                            'preserving natural habitats and agricultural land.',
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nGreen Spaces and Urban Forests',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.green, fontSize: titleFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nIncorporating green spaces and urban forests '
                                            'into residential areas can provide habitats for wildlife, '
                                            'improve air quality, and reduce the urban heat island effect.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nPermeable Surfaces',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\nUsing permeable surfaces, such as porous pavement, '
                                            'can help reduce stormwater runoff and improve water quality.',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                        ),
                                      ),


                                  TextSpan(
                                    text: '\n\n\nMaterial Efficiency in Homes',
                                    style: TextStyle(

                                          fontWeight: FontWeight.bold
                                      , color: Colors.blue, fontSize: titleFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nExcessive Consumption and Waste',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nExcessive consumption of household goods and single-use products generates waste.'
                                        '\n\nEncourage a circular economy mindset with reuse, repair, and recycling of '
                                        'home items to minimize waste.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nExtending Product Lifespan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nDifficulty in repairing, repurposing, or recycling many home items leads to resource depletion.'
                                        '\n\nOpt for durable, modular, and adaptable home furnishings and products, '
                                        'and provide convenient recycling and composting programs to extend their lifespan.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\n\nLogistics and Transportation for Homes',
                                    style: TextStyle(
                                     fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nReducing Personal Vehicle Use and Emissions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green,fontSize: textFontSize,

                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nIncreased personal vehicle use and associated emissions from residents commuting.'
                                        '\n\nPromoting walkable, transit-oriented residential developments and '
                                        'encouraging the use of electric vehicles, carpooling, and micro-mobility '
                                        'options can reduce reliance on personal vehicles and lower emissions.',
                                    style: TextStyle(
                                    fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\nOptimizing Goods Delivery',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nInefficient delivery and distribution of goods to individual homes.'
                                        '\n\nOptimizing last-mile delivery logistics can reduce emissions '
                                        'and traffic associated with the transportation of goods to individual homes.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '\n\n\nProperty Usage Efficiency',
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                       fontWeight: FontWeight.bold, color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nUnderutilized Residential Spaces',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nMany homes have large, multi-room layouts that are underutilized by '
                                        'small households. These expansive properties require significant '
                                        'resources to construct, heat, cool, and maintain, despite '
                                        'being occupied by only a few residents.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nVacation and Secondary Homes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nAcross many communities, there are numerous vacation and secondary homes that '
                                        'sit empty for extended periods throughout the year. These unoccupied properties '
                                        'not only represent wasted resources, but also become prone to deterioration and '
                                        'require costly repairs if left unattended for too long.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n\nPromoting Shared and Flexible Living',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green, fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nTo improve property usage efficiency, strategies could include:',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n▶ Encouraging the development of more compact, flexible housing '
                                        'designs that can adapt to changing household sizes and needs.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n▶ Incentivizing the conversion of larger homes into multi-unit or shared '
                                        'living arrangements, allowing more efficient use of the available space.',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n▶ Implementing policies and programs to encourage the better '
                                        'utilization of vacation and secondary homes, such as rental assistance,'
                                        ' property management services, and streamlined processes for property sharing.\n\n',
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),



                                      TextSpan(
                                        text: '\nReferences',
                                        style: TextStyle(
                                          fontSize: textFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n\nReducing Fossil Fuel Dependence',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energy.gov/eere/renewable-energy');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nSolar Energy Solutions',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energy.gov/eere/solar/homeowners-guide-going-solar');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      /*TextSpan(
                                        text: '\n\nGeothermal Energy Systems',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energy.gov/eere/geothermal/geothermal-basics');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/
                                      TextSpan(
                                        text: '\n\nEnergy Efficient Appliances',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energystar.gov/products');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                     /* TextSpan(
                                        text: '\n\nPassive Solar Design',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energy.gov/energysaver/passive-solar-home-design');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nHome Weatherization',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.energy.gov/energysaver/weatherize');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
*/

                                      TextSpan(
                                        text: '\n\nWater Conservation Strategies',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.epa.gov/watersense/start-saving');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nGreywater Recycling Systems',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.epa.gov/watersense/greywater-reuse');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                    /*  TextSpan(
                                        text: '\n\nUrbanization and Biodiversity Loss',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.unep.org/news-and-stories/story/urban-sprawl-and-lost-biodiversity-can-be-reversed');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nEcosystem Degradation from Urban Expansion',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.iucn.org/resources/issues-brief/urban-development-and-biodiversity');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/

                                     
                                      TextSpan(
                                        text: '\n\nUrban Heat Island Effect',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.epa.gov/heatislands');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nStormwater Management',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.epa.gov/green-infrastructure');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nUrban Biodiversity Conservation',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.cbd.int/subnational/partners-and-initiatives/cities');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nSustainable Urban Design',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://unhabitat.org/topic/urban-planning-and-design');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: '\n\nCircular Economy in Housing',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://ellenmacarthurfoundation.org/topics/built-environment/overview');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),
                                    /*  TextSpan(
                                        text: '\n\nSustainable Transportation',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.itdp.org/library/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),*/
                                      TextSpan(
                                        text: '\n\nHousing Utilization Strategies\n\n',
                                        style:  TextStyle(
                                          fontSize: textFontSize,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = Uri.parse('https://www.oecd.org/social/affordable-housing-database/');
                                            try {
                                              if (!await launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Failed to open link')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error: ${e.toString()}')),
                                              );
                                            }
                                          },
                                      ),

                                ]
                                  )
                              )
                            ),
                          ),
                          ),
                      ),
               SizedBox(height: spacingHeight),

                  ],

                ),
              ),
            ),
        ),
              IconButton(
                  icon:  Icon(Icons.home,
                      color: Colors.white, size: iconSizeLarge),
                  onPressed: () {
                    NavigationService().navigateToScreen(const RealEstateTopicsPage());
                  }),
               SizedBox(height: 20),
         //     const MyBannerAdWidget(),
            ],
        ),
      ),
    );
  }
}





class Demand1Introduction extends StatelessWidget {
  final ScrollController scrollController;

  const Demand1Introduction({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return DraggableScrollbar.semicircle(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            color: Colors.grey[300],
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text.rich(
                    TextSpan(
                        children: [

                          TextSpan(
                        text: '\nThe real estate is a complex and multifaceted market. A house is an essential '
                        'commodity, as no one, regardless of nationality, religion, education, or income, can live '
                        'without a home. Moreover, buildings are not solely used for residential purposes; they also '
                        'serve commercial, administrative, and industrial functions. On the other hand, this market '
                        'has broader social and environmental impacts. '

                         /*   'The players in the real estate market include '
                        'investors, developers (builders), buyers, sellers, tenants, banks, and mortgage lenders. '
                        'This market reaches an optimal balance (where all players benefit without harming others)'
                         'when policymakers consider the various aspects of this complex market and market players '
                         'act based on those policies and local programs.'*/
                         
                         '\n\nUnlike the supply and demand of other '
                         'goods or services, which have simpler analyses, the supply and demand in the real estate '
                         'market have their unique complexities. Houses, as commodities, are offered with different '
                         'motivations, types, and qualities. For example, in the real estate market, many buyers '
                         'purchase buildings with the intention of earning income through rent or resale at a higher '
                         'price. However, most buyers purchase items like fruit, tables, or bicycles for personal use, '
                          'not for resale or rent. This means that real estate has both consumer demand and investment '
                           'demand, which makes market analysis and management challenging. '
                           

                            
                            '\n\nWhen discussing the real estate '
                            'market, the focus in this program is on the buying and selling market. However, there is '
                             'also a rental market, which has its own analysis but is closely related to the buying '
                             'and selling market. '

                          /*  'The real estate buying and selling market is influenced by factors '
                             'such as mortgage interest rates, economic conditions, demographic trends, and more. '
                             'Parallel to the buying and selling market, the rental market is influenced by factors '
                              'like market interest rates, short-term migration policies, job market conditions, '
                               'and the relative costs of buying versus renting. Changes in one market affect the '
                               'other because the relative costs and benefits of buying versus renting influence '
                               'the decisions of buyers and renters.'

                            '\n\n\nMost of the content presented in the real estate economics section of this app has'
                            ' been collected from the internet, and you can find more information in the mentioned'
                            ' resources.'*/
                            ' \n\n\nMost of the content, especially in the \'Market Impact\' '
                            'sections, is the analysis of the developer of this app. Similarly, the economic and '
                            'social productivity indicators stated in the complete calculation section are defined '
                            'and presented by the developer of this app.\n\n',
                        style: TextStyle(
                          fontSize: textFontSize,
                        ),
                      ),
                        ]
                    )
                )
            ),
          ),
          // Add more content here
        ],
      ),
    );
  }
}



class DemandIntroduction extends StatelessWidget {
  final ScrollController scrollController;

  const DemandIntroduction({super.key,
    required this.scrollController});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.6;
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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children:  [
                TextSpan(
                text: '\n\nDemand Side of the Real Estate Market',
                style: TextStyle(
                  fontSize: titleFontSize,

                  fontWeight: FontWeight.bold, color: Colors.blue,
                ),
              ),
                TextSpan(
                  text: '\n\nThe real estate demand refers to the total '
                      'number of properties—residential, commercial, industrial, and land—'
                      'that buyers have the desire and '
                      'financial capacity to purchase at different price '
                      'points during a specific time period, assuming all '
                      'other factors remain constant. Since the situation '
                      'or motivation of the people demanding properties '
                      'might be different, real estate demand'
                      ' can be categorized into the following types:',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

              /*  TextSpan(
                  text: '\n\n▲ Consumption Demand',
                  style: TextStyle(
                    fontSize: textFontSize,

                    fontWeight: FontWeight.bold, color: Colors.purple,
                  ),
                ),
                TextSpan(
                  text: '\n ▶  Consumption Demand: Demand for a property as a residential space or a workplace, Not for making money by reselling or renting the property.',
                     */
                  /* '\n ▶ Primary Consumption Demand: Demand for a building unit as a primary residence or primary workplace, typically the first unit purchased by individuals.'
                      '\n ▶ Non-Primary Consumption Demand: Demand for a building unit as a residence or workplace that is less frequently used and is typically a second (or subsequent) unit, purchased by individuals for personal use, such as for vacations or other reasons.'
                  *//*style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\n▲ Investment Demand',
                  style: TextStyle(
                    fontSize: textFontSize,

                    fontWeight: FontWeight.bold, color: Colors.purple,
                  ),
                ),
                TextSpan(
                  text: '\n▶ The demand for housing by investors who purchase '
                      'properties with the intention of generating rental income '
                      'and long-term appreciation'
                      '\n▶ The primary goal is '
                      'to acquire income-producing assets, not to profit solely '
                      'from short-term price appreciation.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\n▲ Speculative Demand',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.purple,
                  ),
                ),


                TextSpan(
                  text: '\n▶ The demand for properties '
                      ' by buyers who purchase '
                      'properties with the primary goal of reselling them at a higher '
                      'price in the future to generate capital gains.'
                      *//*'\n ▶ The primary '
                      'motivation is to profit from expected price appreciation, rather '
                      'than from the ability of properties to generate rental income.'*//*
                      '\nSpeculators usually have a short-term focus, aiming for quick profits,'
                      ' while investors tend to have a long-term perspective, seeking to build '
                      'wealth over time through rental income and property appreciation, '
                      'this is why it is better to not consider '
                      'speculation as an investment type.\n',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
    */
                TextSpan(
                  text:
                  '\n\n◤ To analyze real estate demand effectively,'
                      ' we aim to categorize it based on key property attributes. '
                      'Below, we focus on factors such as property age and buyer type '
                      'to gain a better understanding of demand dynamics in the real estate market:',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\n1. Property Size',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Large-Sized Properties'
                      '\n▶ Medium-Sized Properties'
                      '\n▶ Small-Sized Properties',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\n2. Property Age',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: '\n▶ New Property'
                      '\n▶ Used Property',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\n3. Property Buyer Type',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Consumer-Buyer',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Investor-Buyer',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Speculator-Buyer',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Government-Buyer',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\n4. Property Type: Luxury vs. Economic Properties',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Luxury Homes'
                      '\n▶ Economic Homes',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\n5. Residential Density',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: '\n▶ High-density Residential/Apartments',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Low-density Residential/Single-Family Homes',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\nEach property can be classified under one of the items of '
                      'each category mentioned above. For example, a single property '
                      'may be classified as: a newly constructed building '
                      '(under property age), buying by an investor (under buyer type), '
                      'a multi-apartment building (under residential density), and '
                      'an economic property (under property type). '
                      'This multifaceted categorization helps us better understand the '
                      'interrelationships that must be considered in the real estate market. '
                      'Promoting the quality of life for all people living in a city is an '
                      'important goal that can be achieved by leveraging this comprehensive '
                      'understanding of the various property characteristics and their interactions.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),








                /////////////////////
               /* TextSpan(
                  text: '\n\n\nApproaches to Real Estate Demand Management',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\nHigher Transaction Costs for Speculators',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.pink,
                  ),
                ),
                TextSpan(
                  text: '\n▶ It is recommended to impose higher capital gains '
                      'taxes on properties sold within a short time period (e.g., 2 years) '
                      'to discourage flipping. This approach could help stabilize '
                      'the market by reducing speculative buying and selling.'
                      '\n▶ Implementing a speculation tax or vacancy tax on properties'
                      ' left empty is advisable. This measure would target investors'
                      ' who do not rent out their properties, encouraging them to '
                      'either rent or sell, thereby increasing the availability of housing in the market.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\nLimit Leverage for Investment Properties',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.pink,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Requiring higher down payments (e.g., 30%+) '
                      'for non-owner-occupied properties is advisable to '
                      'reduce speculative leverage. This approach could help '
                      'mitigate the risk of overleveraged investments and discourage '
                      'investors from purchasing properties solely for investment purposes, '
                      'potentially freeing up more housing stock for owner-occupiers. '
                      'A down payment is a portion of the total purchase price of a property'
                      ' that a buyer pays upfront, rather than financing the entire '
                      'amount through a mortgage or loan. '

                      '\n▶ It is advisable to restrict the ability of investors to use '
                      'home equity loans or cash-out refinancing to fund speculative purchases. '
                      'This measure may limit access to financing options for investors, '
                      'reducing the number of properties acquired for investment purposes '
                      'and increasing the availability of housing for owner-occupiers.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),
                TextSpan(
                  text: '\n\nImprove Data Collection on Real Estate Market',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.pink,
                  ),
                ),
                TextSpan(
      text: '\n ▶ The disclosure of the number and price of traded building units, especially when accompanied by detailed addresses and features, can be highly beneficial for investors and analysts,',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),

                TextSpan(
                  text: '\n▶ Require disclosure of all-cash purchases and investor identities '
                      'to better track speculative activity. '
                      '\n▶ Collect and publish detailed '
                      'data on the share of homes purchased by investors,'
                      ' flippers, and out-of-town buyers.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\nDifferential Tax Treatment',
                  style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                  ),
                ),
             TextSpan(
            text: '\n ▶ Reducing or eliminating transaction taxes for first-time buyers purchasing new homes in the event of a housing shortage.'
                '\n ▶ Increasing transaction taxes for non-first-time buyers reselling used buildings, especially if sold within a short timeframe (e.g., under 5 years).'
                '\n ▶ Promoting housing supply: Tax incentives for new homes encourage builders to increase housing supply, which can help alleviate affordability pressures in the long term.'
                '\n ▶ Implementing taxes on vacant or underutilized homes. This policy incentivizes investors to either rent out or sell their properties to prevent a decline in market supply,',
            style: TextStyle(
              fontSize: textFontSize,
            ),
          ),

                TextSpan(
                  text: '\n\nThis categorization clearly distinguishes between demand '
                      'driven by consumption needs (primary and secondary residences) '
                      'and demand driven by investment objectives, further dividing '
                      'investment demand into genuine long-term rental income-seeking '
                      'and speculative short-term price appreciation.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                TextSpan(
                  text: '\n\nPolicymakers can use this framework to better understand '
                      'the different forces shaping the housing market and develop '
                      'targeted policies to address issues like housing affordability, '
                      'market stability, and the promotion of sustainable, '
                      'investment-driven demand.\n\n',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                )
                ],
              ),
            ),
          ),
        ),
        // Add more content here
      ],
    );
  }
}



class Demand1PropertySize extends StatelessWidget {
  final ScrollController scrollController;

  const Demand1PropertySize({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n1. Demand Differences by Property Size',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nLarge Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*  TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Spacious apartments, condos, or single-family homes, '
                      'often 1,500 sqft (139 sqm) or more'
                      '\n▶ Luxury penthouses and villas, characterized by high-quality '
                      'finishes and modern amenities, '
                      'typically fall within the category of large properties. However, '
                      'this group also includes more standard properties'
                      '\n▶ Attributes like square footage, number of bedrooms/bathrooms, lot '
                      'size, desirable neighborhoods, and amenities are highly valued.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ Demand is typically driven by high-income individuals, '
                        'families, or companies seeking spacious living/working spaces.'
                        '\n▶ Demand is '
                        'more sensitive to factors like location, neighborhood prestige, and access '
                        'to high-end amenities.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Larger properties tend to '
                        'be more luxurious, which means they command higher prices per square foot. '
                        'Additionally, since these properties are significantly larger in size, '
                        'the overall purchase price is also significantly higher.'

                        '\n▶ Fewer buyers can afford large, luxury properties, limiting the '
                        'pool of potential purchasers',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),



                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ The increased demand for larger properties '
                        'will drive up their prices unless there is surplus for such properties.'
                        ' This price increase will also raise '
                        'the prices of small to medium-sized properties. Otherwise, a '
                        'significant gap would exist between the prices of these market '
                        'segments, which is not feasible particularly when there is a shortage of '
                        'small-medium sized properties. '
                        'which is the case most of the time. Consequently, due to increase of '
                        'prices of small to medium-sized properties demand for small to'
                        ' medium-sized properties may decline. '
                        'If we assume that a significant portion of the market is comprised '
                        'of small to medium-sized properties, this decline in demand could '
                        'lead to an overall decrease in total property demand, potentially '
                        'pushing the market into recession.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\n\nMedium-Sized Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*        TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),

                TextSpan(
                  text: '\n▶ Apartments, condos, or homes ranging from approximately 800-1,500 sqft (74-139 sqm).'
                      '\n▶ Livable space, functionality, and value-for-money are important considerations.'
                      '\n▶ Appeal to families, young work force, and first-time homebuyers seeking working or living solutions.'
                  ,
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ Demand comes from a broader range of buyers, including families, '
                        'work force, and some investors.'
                        '\n▶ This segment is influenced by factors such as school districts, neighborhood '
                        'safety, and access to parks and recreational facilities.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ Prices per square foot are generally lower than large '
                        'properties of type luxury, '
                        'making them more attainable for middle-income buyers. '
                        'However, prices for medium-sized properties might still be less '
                        'than those of smaller properties because the construction costs for '
                        'small properties can be higher per square foot than those '
                        'for medium-sized properties.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n ▶ If demand for medium-sized units increases while the market has a surplus supply, without '
                        'an increase in purchase prices, existing units are likely to sell, contributing to market '
                        ' growth (an increase in the number of transactions). However, if the market faces a shortage '
                        'of medium-sized units, purchase prices rise, and some of the demand for medium-sized units '
                        'shifts to smaller units, causing their prices to decrease slightly to prevent the medium-sized unit'
                        'market from cooling down. But if the initial price increase of medium-sized units is significant, the'
                        'medium-sized unit market may lose a substantial portion of its demand and face stagnation. As a'
                        'result, some buyers might exit the medium-sized building market, and if smaller units do not suit'
                        'the size of their family or company, they may turn to the rental market, potentially leading to '
                        'stagnation in the medium-sized building market. This stagnation continues until economic '
                        'conditions change, either by new buyers entering the medium-sized unit market, or their'
                        'purchase prices decreasing again, or both.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\n\nSmall-Sized Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text:
                  '\n▶ Compact apartments, studios, or accessory dwelling units (ADUs), '
                      'often approximately under 800 sqft (74 sqm).'
                      '\n▶ Affordability, efficiency, and low maintenance are highly regarded.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Demand usually is driven by first-time buyers, '
                        'young professionals, and investors seeking rental properties'
                        '\n▶ Also demand is driven by by families who can no longer afford medium-sized properties '
                        'due to inflation, economic conditions'
                        '\n▶ Demand is sensitive to factors like proximity to urban centers, '
                        'public transportation, and amenities',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The price per square foot of these units is usually not less than that of medium-sized '
                        'units per square foot, but since they are smaller, they are more affordable for a wider range of buyers,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Demand for small units is highly sensitive to economic conditions. '
                        'Inflation in living costs or the housing market, or economic '
                        'stagnation and income reduction, can force many people to seek smaller units. '
                        'This sudden increase in demand cannot be immediately met by supply, '
                        'leading to an increase in the purchase price of small units. However, '
                        'the overall demand for small units is likely to remain relatively '
                        'stable compared to medium and large units. Therefore, even if some '
                        'buyers in the small unit market turn to renting, they can be replaced '
                        'by new buyers who cannot afford larger homes, creating a continuous '
                        'need for this type of housing. The market behavior depends on how the '
                        'increase in the purchase price of small units affects the purchase '
                        'price of medium and ultimately large units, which is contingent upon '
                        'the surplus or shortage of medium and large building units.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Demand2PropertyAge extends StatelessWidget {
  final ScrollController scrollController;

  const Demand2PropertyAge({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.6;
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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;




    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n2. Demand Differences by Property Age',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nNew Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.purple,fontWeight: FontWeight.bold,
                    ),
                  ),
                  /*   TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
            TextSpan(
      text: '\n ▶ Standard (Economic) New Buildings are typically constructed using medium-quality materials and efficient designs with low maintenance costs.'
    '\n ▶ Luxury New Buildings feature modern construction, high-quality materials, and branded equipment,',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),*/


                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶Demand is driven by buyers seeking modern amenities, '
                        'equipment efficiency, and customization options',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text:
                    /*The price of new constructions is significantly influenced by various'
                      ' economic factors, including the overall economic situation, mortgage '
                      'rates, and the return on investment in other markets. When the economy '
                      'is strong, consumer confidence typically rises, leading to increased '
                      'demand for new homes. Conversely, during economic downturns or recessions,'
                      ' demand may decline as buyers become more cautious about making significant investments. '
                      'Mortgage rates also play a crucial role in determining home '
                      'prices. Lower mortgage rates make borrowing more affordable, stimulating '
                      'demand for new constructions and driving prices upward. Conversely, '
                      'higher rates can dampen demand, leading to potential price reductions.'
                      ' Additionally, if investors find better returns in markets outside of '
                      'real estate, such as stocks or bonds, they may divert their funds away '
                      'from new construction, further affecting demand and pricing in the housing market.'
                      ' Overall, the interplay of these economic factors can lead to fluctuations '
                      'in the demand for new homes, subsequently impacting their prices.'*/
                    '\n▶ The price of new constructions is influenced by economic factors like the overall economy, mortgage rates, and returns in other markets. A strong economy boosts consumer confidence and demand, raising prices, while downturns lower demand. Low mortgage rates make borrowing cheaper, increasing demand and prices, whereas high rates reduce both. Investors seeking better returns outside real estate can also decrease demand. Together, these factors cause fluctuations in new home prices.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ An increase in demand for new units may lead to a short-term rise in the '
                        'purchase price of newly constructed buildings, as well as an increase in construction '
                        'costs due to higher demand for materials and labor. However, over time, as the '
                        'supply of new buildings increases in the market and competition grows, the purchase price decreases or stabilizes,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  /*      TextSpan(
                  text: '\n▶ There should be no considerable tax or transactional costs for buying a '
                      'new constructed properties to incentivize the demand for buying new properties, '
                      'which in turn will incentivize investors to build new properties. However, '
                      'this policy should only apply to first-time buyers or those who do not intend '
                      'to speculate on future price appreciation. To prevent abuse, there should be a '
                      'limitation on buyers purchasing new property with low tax and low transactional '
                      'costs as their second or higher properties, and a restriction on buyers who continuously '
                      'buy and resell a new property within a specific time frame.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),

                TextSpan(
                  text: '\n\n■ Policymakers can leverage the demand side of the real estate market to '
                      'address various social and environmental issues simultaneously by directing '
                      'the demand of new property towards properties that are socially '
                      'and environmentally friendly. This can be achieved by assigning specific loans for '
                      'buyers that prioritize the smaller, high-quality homes in less developed districts, '
                      'as well as the use of green, modern technologies that minimize the environmental impacts. '
                      'Targeting the demand side in this manner can have a positive ripple effect on the supply '
                      'side, as investors find more interest in catering to the growing demand for socially and '
                      'environmentally conscious real estate developments.'
                      '\n\n● Socially Friendly Homes: \nPolicymakers '
                      'can incentivize the demand for smaller properties in less developed districts by '
                      'offering more favorable loan terms or lower interest rates. For example, if two '
                      'properties have equal size and quality but are located in different areas, the property '
                      'situated in a less developed city area should receive a more affordable loan for buyers. '
                      'This approach can help address issues of housing affordability and accessibility, '
                      'particularly for lower-income communities, while also attracting investors to enhance '
                      'the transition and development of these underserved areas.'
                      '\n\n● Environmentally Friendly Homes: \nTo promote environmentally friendly real estate, '
                      'policymakers can incentivize the demand for homes that utilize green, modern technologies. '
                      'This can include features such as energy-efficient appliances, renewable energy sources, '
                      'water conservation systems, and sustainable building materials. By creating '
                      'a strong demand for these types of properties, investors will be motivated to '
                      'develop projects that align with environmental sustainability goals',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/


                  TextSpan(
                    text: '\n\n\nUsed Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,color: Colors.purple,fontWeight: FontWeight.bold,
                    ),
                  ),
                  /*   TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Previously owned homes being resold on the market.'
                      '\n▶Attributes like location, lot size, and potential for renovation '
                      'are important considerations.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/

                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶Demand comes from a broader range of buyers, '
                        'including those seeking affordability, '
                        'established neighborhoods, and unique character',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text:// '\n ▶ The purchase price of used homes is more influenced by the purchase price of new buildings, which is determined by economic conditions and parallel markets.'
                    // '\n\n ▶ In each neighborhood, the purchase price of newly constructed homes is typically higher per square meter than that of used homes due to the costs associated with materials, equipment, design, and other new elements. Buyers are generally willing to pay more for a living or working space with better quality. However, used buildings may have a higher valuation based on factors such as the significant share of land value on which the building is constructed, good views, or other features.'
                    '\n\n ▶ The purchase price of used buildings is influenced by factors such as neighborhood accessibility, proximity to markets, schools, public services, land value, and property taxes. In contrast, the valuation of new buildings primarily depends on their location and the materials and equipment used in their construction. Additionally, the economic conditions of buyers play a more significant role in determining the purchase price of used buildings, especially for older and non-luxury ones, compared to new buildings,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Increased demand for used properties is mainly driven by buyers who can\'t '
                        'afford new properties, forming most of the market demand. Managing this '
                        'segment requires different policies than new properties, such as density rules '
                        'and construction loans. To prevent inflation and shortages, measures like property '
                        'taxes and higher transaction fees for buyers purchasing additional properties '
                        'beyond their primary residence can be applied. These redirect capital from demand '
                        'to construction, increasing supply. The goal is to balance the market, reduce speculation, '
                        'and support first-time buyers seeking primary homes.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class Demand3BuyerType extends StatelessWidget 
{
  final ScrollController scrollController;

  const Demand3BuyerType({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n3. Demand Differences by Property Buyer Type',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nConsumer-Buyer Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /*   TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text:  '\n▶ Consumer-Buyer properties refer to properties that '
                      'will be occupied by the buyers themselves. In this context, '
                      'buyers have no intention of generating profit or income as '
                      'speculators or investors; rather, they are purchasing the '
                      'property for personal use as their living or working space. '
                      'Therefore, attributes like location, neighborhood amenities, and property '
                      'condition are highly valued.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/

                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Demand is driven by individuals, families or companies'
                        ' seeking a living or working space , '
                        'often with a focus on long-term stability and community integration.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ Buyers seeking to occupy properties typically focus on the '
                        'intrinsic value of the home rather than speculative potential. '
                        'As a result, '
                        'the prices of such properties tend to remain relatively stable '
                        'and are less susceptible to fluctuations driven by speculative behavior. '
                        'This stability is rooted in the fact that buyers-occupiers prioritize '
                        'long-term satisfaction and utility over short-term market trends, '
                        'leading to a more consistent pricing environment. ',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ Stable demand from buyer-occupiers helps maintain '
                        'property values and supports local economies',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\n\nInvestor-Buyer Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*  TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ To clearly differentiate investor-buyers from speculator-buyers, '
                      'we define investor-buyers as individuals who purchase properties with the '
                      'intention of generating rental income or renovating and reselling them '
                      'at higher prices due to significant improvements in quality. '
                      '\n▶ Properties with strong fundamentals, such as good locations, desirable features, '
                      'and low maintenance costs for generating rental income.'
                      '\n▶ Old or dilapidated properties capable of being renovated or redeveloped',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Driven by investors who buy properties for long-term rental '
                        'income or profits from renovating or redeveloping properties',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ Investment criteria for such investments typically encompass '
                        'several key factors, including both expected and unexpected '
                        'costs associated with acquiring the property, projected rental '
                        'income over several years, anticipated renovation or development '
                        'costs, and expected selling prices of the renovated properties.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Investor-buyer properties can have a stabilizing effect on the market '
                        'by providing a steady supply of rental units that will prevent from rising prices '
                        'by providing alternatives properties to live or work. '
                        '\n▶ They contribute to the increase in supply of higher quality '
                        'homes if they renovate and redevelop the properties',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\n\nSpeculator-Buyer Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,

                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*  TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Speculators are less concerned with the condition of property '
                      'or earning potential and more focused on its potential for price appreciation in short terms'
                      '\n▶ Speculators may focus on properties in areas with high demand or limited supply, '
                      'regardless of the fundamental value of the property',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The demand from buyer-speculators decreases as the return on '
                        'investment in other markets increases, because they are primarily seeking financial gains rather than utilizing the building or profiting from its production or rental,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n▶ Speculators seek properties that they believe will increase '
                        'in value quickly, often based on market trends or speculation as a subjective and often riskier approach',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Speculators are willing to pay high prices for properties, '
                        'even if they are overvalued, in the hope of selling them at an even higher price later'
                        '\n▶ This can lead to price bubbles and volatility in the market',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Buyer-speculators can have a destabilizing effect on the market by increasing the purchase price for resident-buyers and long-term investors.'
                    //   '\n ▶ They can contribute to market fluctuations and increase the risk of price bubbles.'
                        '\n ▶ Some believe that speculation provides liquidity for those who need to buy or sell buildings, having a positive impact on the market. While this may be partially true, in most cases, due to the large number of speculators and high competition, they are willing to pay more than consumer buyers or investors, leading to increased purchase prices. However, if the market is efficiently managed through proper policy-making, sellers can find consumer buyers or investors, eliminating the need for speculators,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPolicy Recommendations',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ To address the negative impacts of speculative '
                        'demand, higher transaction fees and higher taxes '
                        'on profit of properties purchased for speculation '
                        'should be imposed.'
                        '\n▶ Prioritizing the sale of homes '
                        'to buyer-occupiers over speculative investors.'
                        '\n▶ Implementing '
                        'regulations that discourage the rapid buying and reselling of '
                        'properties without long-term ownership.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\n\nGovernment Housing Buyer',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /*  TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Buildings with basic qualities located in less '
                      'developed areas that can be offered to low-income groups at affordable'
                      ' prices or rents'
                      '\n▶ Properties that are usually of low quality '
                      'and not profitable for investors, which can be acquired by '
                      'governments and can be converted into new buildings with some '
                      'public usage, such as affordable housing, community centers, or other '
                      'public facilities.'
                  ,
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ Buildings with basic qualities located in less '
                        'developed areas that can be offered to low-income groups at affordable'
                        ' prices or rents by Governments.'
                        '▶ Demand is driven by low-income households, '
                        'seniors, and other vulnerable populations.'
                        '\n▶ They may feature income restrictions, rent control, and other '
                        'measures to ensure long-term affordability.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices are influenced by government policies,'
                        ' subsidies, and local market conditions',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ By offering affordable housing options, government initiatives '
                        'can help stabilize prices in less developed areas. This can '
                        'prevent rapid price increases driven by speculation and provide '
                        'a buffer against housing market volatility.'
                    /*     '\n▶ The long-term sustainability of government housing programs '
                      'is crucial. Insufficient funding and poor management can lead to '
                      'deteriorating conditions, which may negatively impact the surrounding '
                      'area and reduce the intended benefits of such initiatives.'*/
                        '\n▶ Government housing programs can help address '
                        'social and economic issues, but may also create dependency '
                        'and reduce private investment.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Demand4ResidentialDensity extends StatelessWidget
{
  final ScrollController scrollController;

  const Demand4ResidentialDensity({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [  TextSpan(
                  text: '\n\n5. Demand Differences by Residential Density',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                  ),
                ),
                  TextSpan(
                    text: '\n\nHigh-Density Buildings (Apartments)',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*    TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Most properties are smaller, with shared amenities '
                      '(e.g., gyms, pools, common areas).'
                      '\n▶ Located in dense, mixed-use developments or high-rise buildings.'
                      '\n▶ However, some towers that are high-density buildings may have '
                      'larger properties, like penthouses',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Driven by young professionals, small families, and '
                        'those seeking more affordable housing options to purchase'
                        '\n▶ This is a good approach for resolving the problem of '
                        'residential-commercial properties due to the high efficiency '
                        'of land, but if these properties lie in the group of luxury, '
                        'big properties, they cannot resolve the problem and can instead enhance the crisis.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Purchase prices tend to be more affordable per '
                        'square foot compared to single-family homes'
                        '\n▶ However, if the properties being supplied are of the '
                        'luxury, big property type, the purchase prices would be very high',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ High-density building development can help address '
                        'housing affordability and supply issues in urban areas.'
                        '\n▶ Developers may prioritize building more profitable luxury apartments '
                        'over affordable housing options, which can exacerbate the housing '
                        'affordability crisis. Therefore, it is crucial to deploy '
                        'appropriate policies to address this issue and ensure the '
                        'development of affordable, high-density housing options that '
                        'cater to the needs of a diverse range of buyers.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\n\nLow-Density Buildings (Single-Family Homes)',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Typically feature larger lot sizes with more space between buildings.'
                      '\n▶ Often include single-family homes or townhouses with private yards.'
                      '\n▶ Emphasize outdoor living spaces, such as gardens, patios, and driveways.'
                      '\n▶ Generally have fewer shared amenities compared to high-density developments.',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Driven by families, move-up buyers, and those seeking '
                        'more space and privacy to purchase. '
                        'Move-up buyers are current homeowners looking to purchase a larger or more expensive property.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Price per square foot for single-family homes are generally '
                        'higher than apartments or condominiums due to the effect of land value',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Single-family home development can contribute '
                        'to urban sprawl and increased reliance on personal vehicles.'
                        '\n▶ Demand for single-family homes may drive up prices, '
                        'as more land area is needed per square foot of property '
                        'compared to high-density buildings. This raises the price '
                        'of land, which is a significant component of property prices, '
                        'making home ownership less affordable for some buyers. Therefore,'
                        ' policymakers should consider restricting the construction of '
                        'single-family homes within the city limits to manage '
                        'traffic congestion. Alternatively, they could allow single-family '
                        'home construction in smaller sizes outside the city, where land is '
                        'more affordable, to maintain housing affordability while still '
                        'providing options for buyers seeking more space.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),],
              ),
            ),
          ),
        ),

      ],
    );

  }
}

class Demand5PropertyType extends StatelessWidget {
  final ScrollController scrollController;

   const Demand5PropertyType({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n4. Demand Differences by Property Type: Luxury vs. Economic Properties',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nLuxury Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,

                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*  TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text:
                  '\n▶Luxury properties often feature very '
                      'high-priced materials, either due to their quality or beauty, which '
                      'makes them stand out from other properties'
                      '\n▶ The properties typically are large including expansive outdoor spaces, '
                      'landscaped gardens, and exclusive amenities that promote a luxurious lifestyle'
                      ' in premium locations.' ,
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Driven by high-income buyers seeking premium amenities, exclusivity, and status'
                        '\n▶ Demand is less sensitive to price changes compared to economic homes'
                        '\n▶ Conspicuous Consumption: Buyers often purchase '
                        'luxury properties to showcase their financial ability, even if '
                        'they do not need to use all the amenities or space',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Significantly higher than economic homes on a per-square-foot basis'
                        '\n▶ Prices are less influenced by macroeconomic factors '
                        'and more by the unique attributes of the property'
                        '\n▶ Price Records: Since buyers are willing to pay more '
                        'for uniqueness and high-quality materials, luxury properties '
                        'often set new price records in a city',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Demand for luxury homes is more stable and less affected by '
                        'economic cycles compared to the demand for economic properties.'
                        '\n▶ As demand for luxury properties increases in the short term, '
                        'prices begin to rise. However, buyers may not be priced out initially '
                        'due to an existing surplus. As prices continue to increase, some'
                        ' buyers may opt for smaller luxury properties, while others may '
                        'choose non-luxury properties of similar size. Consequently, some '
                        'buyers may exit the real estate market altogether. This shift can'
                        ' lead to a decline in the overall trade of luxury properties, '
                        'potentially resulting in a recession until the next market phase, '
                        'in which prices and demand across all property segments are adjusted.',
                    // They seem to be an island of market demand in which increase and decrease
                    // for such buildings depends on the surplus and shortage of this type buildings not overall economic situatiom
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\n\nEconomic Properties',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                  text: '\n\nAttributes',
                  style: TextStyle(
                    fontSize: textFontSize,
                    fontWeight: FontWeight.bold, color: Colors.teal,
                  ),
                ),
                TextSpan(
                  text: '\n▶ Moderate square footage, standard finishes, and common amenities'
                      '\n▶ Located in a variety of neighborhoods, not necessarily in the most desirable areas',
                  style: TextStyle(
                    fontSize: textFontSize,
                  ),
                ),*/
                  TextSpan(
                    text: '\n\nDemand',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Driven by a broader range of buyers, including first-time homebuyers '
                        'and middle-income families'
                        '\n▶ Demand is more sensitive to changes in affordability, '
                        'such as interest rates and household incomes',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ More affordable and accessible for the average homebuyer'
                        '\n▶ Prices are more closely tied to macroeconomic factors, '
                        'such as employment, inflation, and mortgage rates',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,fontWeight: FontWeight.bold, color: Colors.teal,

                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Demands of economic properties have a larger impact '
                        'on the overall housing market because their lower prices per square foot '
                        'allow for a greater number of buyers to afford them compared to'
                        ' luxury properties'
                        '\n▶ Fluctuations in demand for economic properties can significantly'
                        ' influence market trends and affordability, both positively and negatively'
                        '\n▶ If appropriate policies are implemented, such as targeted '
                        'subsidies or zoning incentives, fluctuations in economic home '
                        'demand can positively impact affordability and accessibility.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    );

  }
}

//|||||||||||||||||||||||||||||||||||||||  SUPLY |||||||||||||||||||||||||||||||||||||||

class SupplyIntroduction extends StatelessWidget
{
  final ScrollController scrollController;

  const SupplyIntroduction({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\nSupply Side of the Real Estate Market',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nSupply in the real estate market refers to the total number '
                        'of properties—including residential, commercial, industrial, and'
                        ' land—that owners are willing and able to offer for sale over a'
                        ' given period, assuming all other factors remain constant. To '
                        'gain a deeper understanding of the '
                        'characteristics of the supply side of the real estate market, we '
                        'can examine them from various perspectives, as outlined below,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n1. Property Size',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Large-Sized Properties'
                        '\n▶ Medium-Sized Properties'
                        '\n▶ Small-Sized Properties',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n2. Property Age',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ New Property'
                        '\n▶ Used Property',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n3. Property Seller Type',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Consumer-Seller'
                        '\n▶ Investor-Seller'
                        '\n▶ Speculator-Seller'
                        '\n▶ Government-Housing-Seller',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n4.Residential Density',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ High-density residential/Apartments'
                        '\n▶ Low-density residential/Single-Family Homes',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\n5. Property Type',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Luxury Properties'
                        '\n▶ Economic Properties',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nEach property can be classified under one of the items of '
                        'each category mentioned above. For example, a single property '
                        'may be classified as: a newly constructed building '
                        '(under property age), belonging to an investor (under ownership), '
                        'a multi-apartment building (under residential density), and '
                        'an economic property (under property type).\n\n '
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
        // Add more content here
      ],
    );
  }
}


class Supply1PropertySize extends StatelessWidget {
  final ScrollController scrollController;

  const Supply1PropertySize({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [

                  TextSpan(
                    text: '\n\n1. Supply Differences by Property Size',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nLarge-Sized Properties',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Spacious apartments, condos, or single-family homes, '
                          'often 1,500 sqft (139 sqm) or more'
                          '\n▶ Luxury penthouses and villas, characterized by high-quality '
                          'finishes and modern amenities, '
                          'typically fall within the category of large properties. However, '
                          'this group also includes more standard properties'
                          '\n▶ Often located in desirable neighborhoods',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ In larger building units, various amenities and spaces can be '
                        'provided that are not feasible in smaller to medium-sized units. This, '
                        'combined with a desirable neighborhood, makes them suitable for conversion into luxury units.'
                        '\n ▶ Large building units of ordinary or poor quality are typically offered by owners who either need capital and are willing to sell their unit to purchase a smaller one, or lack the funds to renovate their unit.'
                        '\n ▶ High-quality large building units are usually supplied by investors and builders with '
                        'high capabilities, who are willing to spend more per square foot on construction. '
                        'Their goal is to maximize profit by offering luxurious materials and special amenities.'
                        '\n ▶ Suppliers primarily target high-income groups, including affluent families, executives, and investors,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),



                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Luxury large properties have a significantly higher purchase price '
                        'per square foot compared to other types of properties, due to their features and luxurious amenities.'
                        '\n ▶ Suppliers of luxury large properties, typically having greater '
                        'financial capabilities than other suppliers, can afford to wait long '
                        'enough to sell their properties at the highest possible price, thus '
                        'setting sales records. This is because they can receive higher prices '
                        'from buyers willing to pay more for exclusivity, high-quality materials, and exclusive amenities.'
                    /*'\n ▶ In contrast, non-luxury large properties may have a lower price '
                      'per square foot compared to smaller properties. This is because the '
                      'construction costs for smaller properties are higher due to fixed '
                      'elements that every home must have, such as bathrooms, kitchens, '
                      'and heating-cooling systems. However, economies of scale in larger '
                      'properties can lead to reduced costs per square foot, resulting in lower prices,'*/,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: 'An increase in demand for large luxury units can raise prices for all unit '
                        'sizes, but increasing the supply of luxury units may not lower their prices'
                        ' much because sellers face less pressure to reduce prices due to high costs '
                        'and financial stability. In contrast, developers of regular large and smaller'
                        ' units may lower prices faster under financial pressure. Ultimately, how supply '
                        'affects prices depends on various market factors and the specific relationship'
                        ' between luxury and smaller units should be analyzed separately.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),



                  TextSpan(
                    text: '\n\nMedium-Sized Properties',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                    ),
                  ),
                  /*    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Apartments, condos, or homes ranging from approximately 800-1,500 sqft (74-139 sqm).'
                          '\n▶ Provide a balance of space and affordability, making them attractive to a diverse range of buyers.'
                          '\n▶ Appeal to families, young professionals, and first-time homebuyers seeking practical living solutions.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Medium-sized properties are supplied by a combination of investors and builders aiming '
                        'for profitability, and owner-consumers with various goals, such as needing capital, seeking '
                        'variety in homes and neighborhoods, etc.'
                        '\n ▶ Their construction is generally less complex and more feasible compared to '
                        'larger units and sometimes even smaller ones, leading to a greater supply of these units in the market,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The price of medium-sized properties is generally lower than that of luxury units, '
                        'making them more affordable for a broader audience.'
                        '\n ▶ The price per square foot of medium-sized units can vary significantly based on '
                        'location, amenities, and market demand.'
                        '\n ▶ Factors such as proximity to workplaces and neighborhood quality are very important in'
                        ' determining the price of these units,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Compared to large building units, medium-sized units require less investment, allowing more units to be supplied with a fixed amount of capital. This increased supply helps meet the demand of a greater number of buyers, reduces demand pressure in the market, and contributes to overall market stability, especially in rapidly growing urban neighborhoods where space is limited,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),



                  TextSpan(
                    text: '\n\nSmall-Sized Properties',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                    ),
                  ),
                  /*  TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Compact apartments, studios, or accessory dwelling units (ADUs), '
                          'often approximately under 800 sqft (74 sqm).'
                          '\n▶ Cater to young professionals, students, downsizing seniors, '
                          'and those with limited budgets.'
                          '\n▶ Offer more affordable housing options, especially for first-time and low-income buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ New small building units are typically supplied by builders who focus on high-density projects '
                        'to address traffic issues (by reducing intra-city travel through sales near workplaces) or '
                        'the shortage of affordable housing units.'
                        '\n ▶ The supply of small building units is influenced by economic conditions, urban policies '
                        'for managing density and traffic, migrant populations, and construction costs,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ The price per square foot can be higher due to the fixed '
                        'costs of construction, but the overall price remains more affordable and lower '
                        'prices compared to medium and large-sized properties.'
                        '\n▶ These properties offer a more accessible entry point into the housing market.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Supply of small-sized properties play a crucial role in providing '
                        'affordable housing options in high-demand areas and reducing prices.'
                        '\n▶ They help address the housing needs of low-income and '
                        'underserved populations, promoting social and economic diversity.'
                        '\n▶ An increase in the supply of small-sized properties can '
                        'contribute to more inclusive and equitable housing markets.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nTo incentivize the development of more medium-sized and small-scale '
                        'affordable housing units, policymakers could consider:',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\n1. Increasing Construction Permit Fees and Trade Taxes for Larger '
                        'Properties.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  /* TextSpan(
                      text: '\nImplementing higher permit fees and taxes for properties '
                          'over 1,500 sqft (139 sqm) can make it less financially attractive '
                          'for developers to build large luxury units, encouraging them to focus '
                          'on smaller, more affordable properties instead.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\n2. Offering Incentives for Affordable Unit Development by Providing tax credits, subsidies, or expedited permitting.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  /*  TextSpan(
                      text: '\nProviding tax credits, subsidies, or expedited permitting for '
                          'projects that include a certain percentage of medium-sized '
                          '(800-1,500 sqft or 74-139 sqm) or small-sized (under 800 sqft or 74 sqm)'
                          ' units can help offset the higher costs associated with building '
                          'more units per square foot.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\n3. Implementing Inclusionary Zoning Policies by Shaping a mix'
                        ' of large, medium, and small-scale options for each construction. \n\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  /*    TextSpan(
                      text: '\n Requiring a mix of unit sizes in new developments, '
                          'including a balance of large, medium, and small-scale options, '
                          'can ensure a diverse range of housing choices within each project.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\n4. Providing Financial Assistance for First-Time and Low-Income Buyers.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),/*
                    TextSpan(
                      text: '\n Offering programs like down payment assistance, low-interest mortgages, '
                          'and homebuyer education courses can help make the smaller, '
                          'more affordable units accessible to those who need them most.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nBy implementing these targeted policies, '
                          'policymakers can incentivize the development of a more '
                          'balanced housing supply that caters to the diverse needs '
                          'and budgets of the population, from affluent buyers to '
                          'first-time and low-income property buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Supply2PropertyAge extends StatelessWidget {
  final ScrollController scrollController;

  const Supply2PropertyAge({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  // Supply Differences by Property Age
                  TextSpan(
                    text: '\n\n2. Supply Differences by Property Age',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nNew Property:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /*    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ New economic properties are designed with affordability'
                          ' in mind, featuring cost-effective materials and efficient '
                          'layouts that prioritize functionality and low maintenance'
                          '\n▶ New luxury properties have attributes such as brand-new construction, '
                          'high-quality materials, new equipment, '
                          'and smart home features that are highly valued',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

    // Prices
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ New properties are gradually constructed after purchasing '
                        'land. As a result, builders consider both the costs incurred and the '
                        'time invested in completing the project when determining their sale '
                        'prices, which may differ from market prices at the time of sale. '
                        'Additionally, investors must account for future market fluctuations'
                        ' when pricing their properties. Consequently, accurately determining '
                        'the price of new properties is complex.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

    // Supply
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: /*'\n ▶ Unlike used building units, new building units are not limited by the area, '
    'infrastructure, or design of previous structures. This provides greater flexibility in addressing changing economic, social, and environmental needs.'
         */ '\n ▶ With proper construction policies, new building units offers the best opportunity to design homes that meet the needs of low-income groups. This can be achieved through:'
                        '\n   - Smaller and more affordable units'
                        '\n   - Use of sustainable building materials and technologies'
                        '\n   - Incorporating energy-efficient appliances and smart systems to reduce ecological impacts'
                        '\n ▶ Policymakers can utilize economic principles with a development-oriented perspective to increase supply in the market. This approach can help bring the housing market to a fairer social and economic equilibrium,',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


    // Market Impact
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The supply of new building units, if characterized by suitable features and proper location, '
                        'can significantly help stabilize the market. Otherwise, even the supply can lead '
                        'the market toward recession due to high capital investment for a limited number of '
                        'units, or inflation due to excessively expensive materials, or both.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  // Policy Recommendations

                  TextSpan(
                    text: '\n\n\nUsed Property:',
                    style: TextStyle(
                      fontSize: titleFontSize,fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*     TextSpan(
                      text: '\nSupply of previously used properties being supplied in the market. '
                          'This type can be further divided into:'
                          '\n - Qualified Used Properties'
                          '\n - Unqualified Used Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

                  // Standard Quality Used Properties
                  TextSpan(
                    text: '\n\nQualified Quality Used Properties:',
                    style: TextStyle(
                      fontSize: textFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Previously used properties being supplied in the market.'
                          '\n▶ Typically in good condition and meeting quality standards.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices are influenced by market conditions and the property\'s condition.'
                        '\n▶ Buyers can negotiate based on the property\'s attributes and recent comparable sales.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ The supply of qualified used properties depends '
                        'on factors like propertie\'s owner goals and the overall housing market.'
                        '\n▶ Appropriate policies to prevent speculation can help increase '
                        'the supply of these properties.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Qualified used properties provide affordable housing options for buyers'
                        ' in compare to new properties with same size and location.'
                        '\n▶ Increasing the supply of these properties can '
                        'positively impact market equilibrium and affordability.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

    // Unqualified Used Properties
                  TextSpan(
                    text: '\n\nUnqualified Used Properties:',
                    style: TextStyle(
                      fontSize: textFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Existing homes that do not meet current quality standards.'
                          '\n▶ May require significant repairs or renovations.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices for unqualified used properties are '
                        'typically lower than standard quality homes.'
                        '\n▶ Buyers must factor in the cost of necessary improvements.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ The supply of unqualified used properties can be '
                        'reduced by converting them to new, higher-quality housing.'
                        '\n▶ This can be encouraged through policies like discounted '
                        'permitting fees and additional financing for redevelopment.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Increasing the supply of underutilized or dilapidated '
                        'properties provides an opportunity for redevelopment. By '
                        'either rebuilding these properties from the ground up or '
                        'undertaking significant renovations, the overall supply of '
                        'high-quality housing units can be increased. This influx of '
                        'improved properties can help stabilize and even reduce prices '
                        'in the housing market.'
                        '\n▶ Unqualified used properties can pose risks related '
                        'to safety, crime, and neighborhood quality. Converting '
                        'these properties to new housing can help '
                        'mitigate these risks and costs while increasing '
                        'the overall supply of decent, affordable homes.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Supply3SellerType extends StatelessWidget {
  final ScrollController scrollController;

  const Supply3SellerType({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n3. Supply Differences by Seller Type:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nConsumer-Seller:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  TextSpan(
                    text: '\nIn this type, the sellers of properties are the residents themselves. '
                        'This form of housing supply can help stabilize the market and '
                        'promote affordability, as consumer-sellers are less likely '
                        'to engage in speculative behavior. '
                        'Because consumer-sellers typically seek a new property to reside in after '
                        'selling their current home, they are often more risk-averse than '
                        'professional investors. This risk aversion makes them less inclined '
                        'to buy and sell properties in the short term for profit. Their primary focus is '
                        'on finding a suitable living situation rather than engaging in '
                        'speculative activities, which further stabilizes the housing market.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  /*   TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ Consumer-sellers typically prioritize factors such as neighborhood quality, '
                          'school districts, and proximity to work or family when selling their properties.'
                          '\n▶ The focus on personal needs rather than profit can lead to more '
                          'stable pricing in the housing market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices set by consumer-sellers may be more reflective of local '
                        'market conditions and personal circumstances rather than speculative trends'
                        '\n▶ Since they are often motivated by the need to find a new home, '
                        'their pricing strategies can contribute to more stable market conditions'
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ The supply of properties from consumer-sellers can fluctuate based '
                        'on personal circumstances such as job changes, family needs, or retirement'
                        '\n▶ This supply is generally more stable compared to investor-driven markets, '
                        'as it is less influenced by speculative buying and selling'
                        '\n▶ However, in times of economic uncertainty, consumer-sellers may hold onto '
                        'their properties longer, reducing the available supply',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Consumer-sellers contribute to a more stable housing market by'
                        ' prioritizing their living needs over profit, reducing volatility'
                        '\n▶ Their presence can help moderate price fluctuations, making the market '
                        'more accessible for first-time buyers and families',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nInvestor-Seller:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  TextSpan(
                    text: '\nInvestor-sellers in this context refer to investors in '
                        'real estate who purchase land to '
                        'engage in the construction to '
                        'supply the market for profit. They may also purchase properties '
                        'with the intention of selling them after significant renovations.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  /*               TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
      text: '\n ▶ Investor-sellers have access to capital and construction expertise, and under normal market conditions,'
      ' they tend to sell units and start new projects to generate profits.'
      '\n▶ The properties they develop or renovate may include a range of housing '
                          'types, from single-family homes to multi-unit buildings.',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),
    */

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices set by investor-sellers can be influenced by market '
                        'trends and their personal expected profit.'
                        '\n▶ Investors may price properties based on anticipated future value'
                        ' rather than current market conditions, which can lead to rising prices.'
                        ' However, their supply often '
                        'stabilizes the market and can even reduce prices, unless the properties are located in premium areas '
                        'or are luxury types that may command higher prices.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ The supply of properties from investor-sellers can fluctuate based '
                        'on market conditions and investment strategies.'
                        '\n▶ Investors may choose to hold properties longer during downturns, '
                        'limiting the available inventory in the market.'
                        '\n▶ Conversely, a surge in investor activity can lead to an increase in '
                        'housing supply, particularly in high-demand areas.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ Investor-sellers can have a significant impact on the real estate market as they are the only group of suppliers that increase the number of buildings.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

    /*TextSpan(
      text: '\n ▶ Effective policies are essential to create a balance between investor activities and the housing needs of society, ensuring that development aligns with demand.',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),

    TextSpan(
      text: '\n ▶ If investors do not choose suitable locations for construction and fail to attract buyers, '
    'they risk losing their financial and material resources. Additionally, if they '
    'opt to build luxury buildings, although they increase the overall number of buildings in the market, this can lead to higher sale prices and even drive the market toward recession.',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),*/


                  TextSpan(
                    text: '\n\nSpeculator-Seller:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),
                  /*   TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                  TextSpan(
      text: '\n ▶ Suppliers who typically do not reside in the units they sell and did not build them, but rather purchase them solely to resell at a higher price for profit.',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),*/

                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ Speculator are suppliers who typically do not reside in the units they sell '
                        'and did not build them, but rather purchase them solely to resell at '
                        'a higher price for profit.'
                        '\n▶ This type of property supply enters the market '
                        'without significant renovations aimed at increasing value. Instead, '
                        'speculators typically buy properties below their market value or'
                        ' at current market value and wait to sell at higher prices.'
                        '\n▶ Speculators may contribute to the supply of properties in the short term, '
                        'but they don\'t increase the number of properties constructed and '
                        'their overall demand can drive up market prices',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Some believe that speculators are supplying the money to the '
                        'market for those who need to sell their homes in the short term, '
                        'which can be correct in some cases. But this '
                        'speculative activity ultimately undermines housing affordability '
                        'and accessibility for the broader population, exacerbating economic '
                        'inequality and making it increasingly difficult for first-time and low-income '
                        'buyers to enter the housing market.'
                        '\n▶ Therefore, speculation most of the time increases prices in favor of high-income groups, '
                        'effectively destroying the economic supply of homes for the real, '
                        'home-needed demand from lower- and middle-income households.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ The focus on short-term gains can result in a lack of long-term investment'
                        ' in the housing market, decreasing overall supply in long term'
                        '\n▶ Speculative activity undermines housing affordability and'
                        ' accessibility for the broader population.'
                        '\n▶ It exacerbates economic inequality, making it increasingly '
                        'difficult for first-time and low-income buyers to enter the housing market.'
                        '\n▶ Policymakers must address this speculative dynamic to ensure a '
                        'more equitable and sustainable housing market.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nGovernment-Seller:',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Government housing includes properties owned or '
                          'subsidized by public agencies to provide accessible living options.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Government housing includes properties owned or '
                        'subsidized by governments or public agencies to provide accessible living options for low income buyers.'
                    /*'\n▶ The supply of government housing is often '
                          'constrained by limited funding and resources'
                          '\n▶ Policies such as inclusionary zoning and tax incentives can '
                          'encourage private developers to include affordable units in their projects'
                          '\n▶ However, the overall supply remains insufficient to meet the '
                          'growing demand for affordable housing in many areas'*/,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ Prices of government housing are typically set '
                        'below market rates to maintain accessibility'
                    /*   '\n▶ Subsidies and income restrictions help keep rents and purchase '
                          'prices within reach of low-income households'
                          '\n▶ However, the limited supply of affordable housing can lead to long '
                          'waitlists and competition for available units'*/,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Government housing can help address market failures and ensure '
                        'that low-income households have access to decent, affordable homes.'
                        '\n▶ However, inefficient implementation or corruption can '
                        'undermine the effectiveness of these programs'
                        '\n▶ While the free market should be the primary '
                        'driver of housing supply, government intervention can act as a '
                        'lever to push the market towards a more equitable equilibrium '
                        'Policymakers must strike a balance between government '
                        'intervention and free market forces to create a more '
                        'equitable and sustainable housing system.\n\n'
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Supply4ResidentialDensity extends StatelessWidget {
  final ScrollController scrollController;

  const Supply4ResidentialDensity({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [       TextSpan(
                  text: '\n\n4. Supply Differences by Residential Density',
                  style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                  ),
                ),
                  TextSpan(
                    text: '\n\nHigh-Density Residential',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                    ),
                  ),
                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ This category includes multi-unit housing structures such as '
                          'apartment buildings, condominiums, and townhouses'
                          '\n▶ High-density residential developments are often more efficient '
                          'in terms of land usage and infrastructure utilization,'
                          ' especially in urban areas facing housing shortages'
                          '\n▶ These properties can offer amenities such as shared facilities, '
                          'green spaces, and community areas, promoting a sense of community among residents',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/

                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:
                    '\n▶ High-density properties can be financed for construction more '
                        'easily than low-density properties, such as villas, because '
                        'developers can sell some units to finance the total project '
                        'before construction begins or while it is ongoing. This approach '
                        'allows for quicker capital recovery and reduces the financial burden on the developer.'
                    /*  '\n▶ In many cases, suppliers of high-density properties are speculators. '
                          'These properties typically have lower prices, making them more '
                          'affordable and accessible to a wider range of buyers. As a result, '
                          'more speculators are attracted to purchase and resell these properties '
                          'to generate profits. This trend can easily convert high-density '
                          'properties into investment commodities rather than consumption '
                          'commodities, making them susceptible to inflation and recession.'
                          'To address this issue, appropriate policies need to be implemented. '*/
                        '\n▶ The supply of high-density residential properties can help '
                        'increase the overall housing stock that meet the requirements of different buyers. '
                        '\nHowever, the development of high-density housing may face zoning '
                        'restrictions or community opposition in some areas, '
                        'limiting its ability to rapidly expand the supply.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices for high-density residential properties can vary '
                        'depending on location, amenities, and market demand'
                        '\n▶ These properties often offer more affordable options compared '
                        'to low-density housing, making them accessible to a wider range of buyers and renters'
                        '\n▶ However, in some high-demand urban areas or luxury towers, high-density properties '
                        'may still be out of reach for lower-income households.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Increasing the supply of high-density residential properties'
                        ' can alleviate housing shortages in urban areas, contributing to overall market stability'
                        '\n▶ These developments can attract a diverse range of residents, '
                        'including young professionals, families, and retirees, fostering vibrant communities.\n\n'
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\n\nLow-Density Residential',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                    ),
                  ),
                  /* TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ This category encompasses housing types with a '
                          'smaller number of individual units, such as duplexes, '
                          'triplexes, and small-scale single-family homes.'
                          '\n▶ Low-density residential properties provide more space, '
                          'privacy, and a more residential character compared to high-density options.'
                          '\n▶ These properties often feature larger yards, gardens, '
                          'and outdoor spaces, appealing to families and individuals seeking a quieter living environment.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/


                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: 'Suppliers of used low-density buildings are typically the '
                        'residents of those units who intend to purchase another property for personal use.'
                        '\n ▶ New low-density buildings or new villas are usually supplied by '
                        'investors who previously purchased land or existing units and have rebuilt '
                        'them as low-unit or villa-style properties.\n\n'
                    /*'\n ▶ The supply of low-density residential units can be beneficial for controlling '
                        'traffic and reducing pollution in densely populated city centers, and they can '
                        'be placed between high-density neighborhoods.'*/,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices for low-density residential properties in urban areas are '
                        'generally more compared to medium and high-density '
                        'options, unless they are far from city center, work place and markets that reduces their prices.'

                        '\n▶ The overall cost of low-density housing can be '
                        'influenced by the land-intensive nature of development, '
                        'which may drive prices higher in areas with limited available land.\n\n',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Low-density residential properties contribute to the overall '
                        'character and livability of neighborhoods, providing a buffer '
                        'between high-density developments and open spaces But it cannot be '
                        'considered a solution for resolving the housing problem. '
                        '\n▶ They can enhance property values in surrounding areas by creating'
                        ' desirable living environments that attract families and long-term residents\n\n'
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),


                  /*       TextSpan(
                      text: '\n\nBy considering both high-density and low-density residential '
                          'options, policymakers can work towards a balanced housing supply '
                          'that caters to the diverse needs and preferences of the population, '
                          'while also addressing environmental and infrastructure-related concerns.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
    */
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class Supply5PropertyType extends StatelessWidget {
  final ScrollController scrollController;

  const Supply5PropertyType({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '\n\n5. Supply Differences by Property Type: Luxury vs. Economic',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold, color: Colors.pink,
                    ),
                  ),
                  TextSpan(
                    text: '\n\nLuxury properties',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /*   TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Luxury properties are characterized by their premium materials, '
                          'unique architectural designs, and high-quality craftsmanship.'
                          '\n▶ The properties typically are large including expansive outdoor spaces, '
                          'landscaped gardens, and exclusive amenities that promote a luxurious lifestyle'
                          ' in premium locations.'
                          '\n▶ In today\'s world, they often feature advanced technology and smart home systems, '
                          'enhancing convenience and security for residents.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/


                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The supply of luxury building properties is generally limited because'
                        ' they are typically constructed in prime locations, considering the smaller '
                        'population of wealthy buyers.'
                        '\n ▶ While luxury properties can drive up market prices, they may lead to a decrease'
                        ' in overall market activity due to the significant capital and resources they attract.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n ▶ The sale price per square foot of luxury properties is higher than standard '
                        'properties due to the quality of materials and other costs, depending on location and features.'
                    ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text:  '\n ▶ The high sale prices of luxury properties can increase the average '
                        'purchase price of other types of properties in surrounding '
                        'neighborhoods, then can can elevate average home prices that exclude middle and low-income buyers from the market.'

                        '\n▶ In some cases, the introduction of luxury properties can '
                        'stimulate market activity, attracting investors and increasing overall interest in the area.'
                        '\n▶ However, if the market is already saturated with high-priced'
                        ' homes, it may lead to a recession in trading and production within the real estate sector.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nEconomic properties',
                    style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                    ),
                  ),

                  /*           TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                 TextSpan(
      text: '\n ▶ Standard building properties are recognized for their functional design and essential amenities.'
    '\n ▶ Building properties typically have smaller square footage compared to luxury buildings and require less capital and materials per square foot, allowing for a greater supply with a fixed amount of capital. However, they still provide acceptable quality spaces for work or comfortable living.'
    '\n ▶ These properties may use cheaper materials and construction methods to maintain affordability, yet they still offer acceptable quality spaces for work or living.',
      style: TextStyle(
        fontSize: textFontSize,
      ),
    ),*/

                  TextSpan(
                    text: '\n\nSupply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ The supply of economic (standard) properties can be increased'
                        ' by shifting resources and materials towards their construction.'
                        '\n▶ Streamlining the development process for economic properties'
                        ' can also contribute to a more robust supply.'
                        '\n▶ Policies such as inclusionary zoning, developer incentives, '
                        'and rehabilitation programs can help boost the supply of decent, low-cost housing.'

                        '\n▶ One strategy for redistributing population density across '
                        'different regions of a city is through Transferable Development '
                        'Rights (TDR). This approach allows developers to sell construction '
                        'rights from a less demanded area to a more desirable location, '
                        'enabling the construction of taller buildings or larger floor '
                        'spaces where demand is higher. By facilitating this transfer,'
                        ' TDR helps manage urban growth and encourages development in areas'
                        ' that can better accommodate increased density'
                        '\n▶ Invest in infrastructure and transit to enable more housing '
                        'in desirable urban areas.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  TextSpan(
                    text: '\n\nPrices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Prices for economic properties are generally '
                        'lower than luxury properties, making them accessible to a wider range of buyers.'
                        '\n▶ The price per square foot is often more competitive for these properties, '
                        'as they prioritize affordability over high-end finishes and amenities.'
                        ' They maintain security and reliability similar to luxury properties but '
                        'utilize essential materials and equipment, rather than using materials'
                        ' and equipment from luxury brands, which '
                        'are often associated with aesthetics or special features that may not be necessary for functionality.'
    /*
                          '\n▶ Economic properties can provide a more attainable path to '
                          'homeownership for middle-income and lower-income families.'*/,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),

                  /*   TextSpan(
                      text: '\n▶ Blockchain technology is revolutionizing real estate through fractional ownership.'
                          '\n▶ Broader access: Retail investors can participate in high-value properties with small capital.'
                          '\n▶ Easier financing: Developers can fund projects faster by selling digital shares.'
                          '\n▶ Enhanced liquidity: Property tokens can be traded easily, unlike physical real estate.'
                          '\n▶ Security and transparency: Blockchain\'s immutable ledger ensures traceable and secure transactions.'
                          '\n▶ This transformation not only democratizes property investment but also accelerates market growth while reducing risks.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),*/
                  TextSpan(
                    text: '\n\n\nMarket Impact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Economic homes provide more accessible housing options '
                        'for the majority of home buyers, promoting social and economic diversity.'
                        '\n▶ By increasing the supply of affordable homes, the market can '
                        'become more balanced, reducing the risk of pricing out middle-income '
                        'and lower-income households.\n\n' ,
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}




// without reducing content:
/*
class DraggableScrollableContentDemand extends StatelessWidget
 {
  final ScrollController scrollController;

  const DraggableScrollableContentDemand({super.key,
    required this.scrollController});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
// iPhone sizes (base)
    final double buttonWidthPhone = screenWidth *  0.6;
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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return DraggableScrollbar.semicircle(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(
                TextSpan(
                  children:  [
                    TextSpan(
                      text: '\n\nDemand Side of the Real Estate Market',
                      style: TextStyle(
                        fontSize: titleFontSize,

                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nThe real estate demand refers to the total '
                          'number of properties either residential or commercial that buyers have the desire and '
                          'financial capacity to purchase at different price '
                          'points during a specific time period, assuming all '
                          'other factors remain constant. Since the situation '
                          'or motivation of the people demanding properties '
                          'might be different, real estate demand'
                          ' can be categorized into the following types:',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n▲ Consumption Demand',
                      style: TextStyle(
                        fontSize: textFontSize,

                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶  Consumption Demand: Demand for a property as a residential space or a workplace, Not for making money by reselling or renting the property.',
                      *//* '\n ▶ Primary Consumption Demand: Demand for a building unit as a primary residence or primary workplace, typically the first unit purchased by individuals.'
                        '\n ▶ Non-Primary Consumption Demand: Demand for a building unit as a residence or workplace that is less frequently used and is typically a second (or subsequent) unit, purchased by individuals for personal use, such as for vacations or other reasons.'
                    *//*style: TextStyle(
                      fontSize: textFontSize,
                    ),
                    ),
                    TextSpan(
                      text: '\n\n▲ Investment Demand',
                      style: TextStyle(
                        fontSize: textFontSize,

                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The demand for housing by investors who purchase '
                          'properties with the intention of generating rental income '
                          'and long-term appreciation'
                          '\n▶ The primary goal is '
                          'to acquire income-producing assets, not to profit solely '
                          'from short-term price appreciation.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n▲ Speculative Demand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),


                    TextSpan(
                      text: '\n▶ The demand for properties '
                          ' by buyers who purchase '
                          'properties with the primary goal of reselling them at a higher '
                          'price in the future to generate capital gains.'
                      *//*'\n ▶ The primary '
                        'motivation is to profit from expected price appreciation, rather '
                        'than from the ability of properties to generate rental income.'*//*
                          '\nSpeculators usually have a short-term focus, aiming for quick profits,'
                          ' while investors tend to have a long-term perspective, seeking to build '
                          'wealth over time through rental income and property appreciation, '
                          'this is why it is better to not consider '
                          'speculation as an investment type.\n',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text:
                      '\n\n◤ To analyze real estate demand effectively,'
                          ' we aim to categorize it based on key property attributes. '
                          'Below, we focus on factors such as property age and buyer type '
                          'to gain a better understanding of demand dynamics in the real estate market:',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n1. Property Size',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Large-Sized Properties'
                          '\n▶ Medium-Sized Properties'
                          '\n▶ Small-Sized Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n2. Property Age',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ New Property'
                          '\n▶ Used Property',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n3. Property Buyer Type',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Consumer-Buyer',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Investor-Buyer',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Speculator-Buyer',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Government-Buyer',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n4. Property Type: Luxury vs. Economic Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Luxury Homes'
                          '\n▶ Economic Homes',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n5. Residential Density',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ High-density Residential/Apartments',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Low-density Residential/Single-Family Homes',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nEach property can be classified under one of the items of '
                          'each category mentioned above. For example, a single property '
                          'may be classified as: a newly constructed building '
                          '(under property age), buying by an investor (under buyer type), '
                          'a multi-apartment building (under residential density), and '
                          'an economic property (under property type). '
                          'This multifaceted categorization helps us better understand the '
                          'interrelationships that must be considered in the real estate market. '
                          'Promoting the quality of life for all people living in a city is an '
                          'important goal that can be achieved by leveraging this comprehensive '
                          'understanding of the various property characteristics and their interactions.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\n1. Demand Differences by Property Size',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nLarge Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    *//*  TextSpan(
                    text: '\n\nAttributes',
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold, color: Colors.teal,
                    ),
                  ),
                  TextSpan(
                    text: '\n▶ Spacious apartments, condos, or single-family homes, '
                        'often 1,500 sqft (139 sqm) or more'
                        '\n▶ Luxury penthouses and villas, characterized by high-quality '
                        'finishes and modern amenities, '
                        'typically fall within the category of large properties. However, '
                        'this group also includes more standard properties'
                        '\n▶ Attributes like square footage, number of bedrooms/bathrooms, lot '
                        'size, desirable neighborhoods, and amenities are highly valued.',
                    style: TextStyle(
                      fontSize: textFontSize,
                    ),
                  ),*//*
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Demand is typically driven by high-income individuals, '
                          'families, or companies seeking spacious living/working spaces.'
                          '\n▶ Demand is '
                          'more sensitive to factors like location, neighborhood prestige, and access '
                          'to high-end amenities.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Larger properties tend to '
                          'be more luxurious, which means they command higher prices per square foot. '
                          'Additionally, since these properties are significantly larger in size, '
                          'the overall purchase price is also significantly higher.'

                          '\n▶ Fewer buyers can afford large, luxury properties, limiting the '
                          'pool of potential purchasers',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),



                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ The increased demand for larger properties '
                          'will drive up their prices unless there is surplus for such properties.'
                          ' This price increase will also raise '
                          'the prices of small to medium-sized properties. Otherwise, a '
                          'significant gap would exist between the prices of these market '
                          'segments, which is not feasible particularly when there is a shortage of '
                          'small-medium sized properties. '
                          'which is the case most of the time. Consequently, due to increase of '
                          'prices of small to medium-sized properties demand for small to'
                          ' medium-sized properties may decline. '
                          'If we assume that a significant portion of the market is comprised '
                          'of small to medium-sized properties, this decline in demand could '
                          'lead to an overall decrease in total property demand, potentially '
                          'pushing the market into recession.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\nMedium-Sized Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Apartments, condos, or homes ranging from approximately 800-1,500 sqft (74-139 sqm).'
                          '\n▶ Livable space, functionality, and value-for-money are important considerations.'
                          '\n▶ Appeal to families, young work force, and first-time homebuyers seeking working or living solutions.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Demand comes from a broader range of buyers, including families, '
                          'work force, and some investors.'
                          '\n▶ This segment is influenced by factors such as school districts, neighborhood '
                          'safety, and access to parks and recreational facilities.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Prices per square foot are generally lower than large '
                          'properties of type luxury, '
                          'making them more attainable for middle-income buyers. '
                          'However, prices for medium-sized properties might still be less '
                          'than those of smaller properties because the construction costs for '
                          'small properties can be higher per square foot than those '
                          'for medium-sized properties.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n ▶ If demand for medium-sized units increases while the market has a surplus supply, without '
                          'an increase in purchase prices, existing units are likely to sell, contributing to market '
                          ' growth (an increase in the number of transactions). However, if the market faces a shortage '
                          'of medium-sized units, purchase prices rise, and some of the demand for medium-sized units '
                          'shifts to smaller units, causing their prices to decrease slightly to prevent the medium-sized unit'
                          'market from cooling down. But if the initial price increase of medium-sized units is significant, the'
                          'medium-sized unit market may lose a substantial portion of its demand and face stagnation. As a'
                          'result, some buyers might exit the medium-sized building market, and if smaller units do not suit'
                          'the size of their family or company, they may turn to the rental market, potentially leading to '
                          'stagnation in the medium-sized building market. This stagnation continues until economic '
                          'conditions change, either by new buyers entering the medium-sized unit market, or their'
                          'purchase prices decreasing again, or both.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\nSmall-Sized Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ Compact apartments, studios, or accessory dwelling units (ADUs), '
                          'often approximately under 800 sqft (74 sqm).'
                          '\n▶ Affordability, efficiency, and low maintenance are highly regarded.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Demand is driven by first-time buyers, '
                          'young professionals, downsizers, and investors seeking rental properties'
                          '\n▶ Also demand is families who can no longer afford medium-sized properties '
                          'due to inflation, economic conditions'
                          '\n▶ Demand is sensitive to factors like proximity to urban centers, '
                          'public transportation, and amenities',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The price per square foot of these units is usually not less than that of medium-sized units, but since they are smaller, they are more affordable for a wider range of buyers,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Demand for small units is highly sensitive to economic conditions. Inflation in living costs or the housing market, or economic stagnation and income reduction, can force many people to seek smaller units. This sudden increase in demand cannot be immediately met by supply, leading to an increase in the purchase price of small units. However, the overall demand for small units is likely to remain relatively stable compared to medium and large units. Therefore, even if some buyers in the small unit market turn to renting, they can be replaced by new buyers who cannot afford larger homes, creating a continuous need for this type of housing. The market behavior depends on how the increase in the purchase price of small units affects the purchase price of medium and ultimately large units, which is contingent upon the surplus or shortage of medium and large building units,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\n2. Demand Differences by Property Age',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nNew Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: Colors.purple,fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Standard (Economic) New Buildings are typically constructed using medium-quality materials and efficient designs with low maintenance costs.'
                          '\n ▶ Luxury New Buildings feature modern construction, high-quality materials, and branded equipment,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶Demand is driven by buyers seeking modern amenities, '
                          'equipment efficiency, and customization options',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ The price of new constructions is significantly influenced by various'
                          ' economic factors, including the overall economic situation, mortgage '
                          'rates, and the return on investment in other markets. When the economy '
                          'is strong, consumer confidence typically rises, leading to increased '
                          'demand for new homes. Conversely, during economic downturns or recessions,'
                          ' demand may decline as buyers become more cautious about making significant investments. '
                          'Mortgage rates also play a crucial role in determining home '
                          'prices. Lower mortgage rates make borrowing more affordable, stimulating '
                          'demand for new constructions and driving prices upward. Conversely, '
                          'higher rates can dampen demand, leading to potential price reductions.'
                          ' Additionally, if investors find better returns in markets outside of '
                          'real estate, such as stocks or bonds, they may divert their funds away '
                          'from new construction, further affecting demand and pricing in the housing market.'
                          ' Overall, the interplay of these economic factors can lead to fluctuations '
                          'in the demand for new homes, subsequently impacting their prices.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ An increase in demand for new units may lead to a short-term rise in the purchase price of newly constructed buildings, as well as an increase in construction costs due to higher demand for materials and labor. However, over time, as the supply of new buildings increases in the market and competition grows, the purchase price decreases or stabilizes,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),




                    TextSpan(
                      text: '\n▶ There should be no considerable tax or transactional costs for buying a '
                          'new constructed properties to incentivize the demand for buying new properties, '
                          'which in turn will incentivize investors to build new properties. However, '
                          'this policy should only apply to first-time buyers or those who do not intend '
                          'to speculate on future price appreciation. To prevent abuse, there should be a '
                          'limitation on buyers purchasing new property with low tax and low transactional '
                          'costs as their second or higher properties, and a restriction on buyers who continuously '
                          'buy and resell a new property within a specific time frame.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n■ Policymakers can leverage the demand side of the real estate market to '
                          'address various social and environmental issues simultaneously by directing '
                          'the demand of new property towards properties that are socially '
                          'and environmentally friendly. This can be achieved by assigning specific loans for '
                          'buyers that prioritize the smaller, high-quality homes in less developed districts, '
                          'as well as the use of green, modern technologies that minimize the environmental impacts. '
                          'Targeting the demand side in this manner can have a positive ripple effect on the supply '
                          'side, as investors find more interest in catering to the growing demand for socially and '
                          'environmentally conscious real estate developments.'
                          '\n\n● Socially Friendly Homes: \nPolicymakers '
                          'can incentivize the demand for smaller properties in less developed districts by '
                          'offering more favorable loan terms or lower interest rates. For example, if two '
                          'properties have equal size and quality but are located in different areas, the property '
                          'situated in a less developed city area should receive a more affordable loan for buyers. '
                          'This approach can help address issues of housing affordability and accessibility, '
                          'particularly for lower-income communities, while also attracting investors to enhance '
                          'the transition and development of these underserved areas.'
                          '\n\n● Environmentally Friendly Homes: \nTo promote environmentally friendly real estate, '
                          'policymakers can incentivize the demand for homes that utilize green, modern technologies. '
                          'This can include features such as energy-efficient appliances, renewable energy sources, '
                          'water conservation systems, and sustainable building materials. By creating '
                          'a strong demand for these types of properties, investors will be motivated to '
                          'develop projects that align with environmental sustainability goals',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\nUsed Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,color: Colors.purple,fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Previously owned homes being resold on the market.'
                          '\n▶Attributes like location, lot size, and potential for renovation '
                          'are important considerations.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶Demand comes from a broader range of buyers, including those seeking affordability, '
                          'established neighborhoods, and unique character',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The purchase price of used homes is more influenced by the purchase price of new buildings, which is determined by economic conditions and parallel markets.'
                          '\n\n ▶ In each neighborhood, the purchase price of newly constructed homes is typically higher per square meter than that of used homes due to the costs associated with materials, equipment, design, and other new elements. Buyers are generally willing to pay more for a living or working space with better quality. However, used buildings may have a higher valuation based on factors such as the significant share of land value on which the building is constructed, good views, or other features.'
                          '\n\n ▶ The purchase price of used buildings is influenced by factors such as neighborhood accessibility, proximity to markets, schools, public services, land value, and property taxes. In contrast, the valuation of new buildings primarily depends on their location and the materials and equipment used in their construction. Additionally, the economic conditions of buyers play a more significant role in determining the purchase price of used buildings, especially for older and non-luxury ones, compared to new buildings,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Increased demand for used buildings is primarily driven by buyers who cannot afford new buildings, which constitute the majority of market demand. Consequently, managing this market segment requires policies distinct from those for new units, such as density regulations and construction loans. To prevent inflation and shortages in the used unit market, policies like property taxes and increased transaction costs for buyers purchasing additional units beyond their primary residence can be implemented. This redirects capital from demand to construction, thereby boosting supply. The goal of such programs is to balance the real estate market, curb speculative behavior, and accommodate first-time buyers seeking a primary residence,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\n3. Demand Differences by Property Buyer Type',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nConsumer-Buyer Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:  '\n▶ Consumer-Buyer properties refer to properties that '
                          'will be occupied by the buyers themselves. In this context, '
                          'buyers have no intention of generating profit or income as '
                          'speculators or investors; rather, they are purchasing the '
                          'property for personal use as their living or working space. '
                          'Therefore, attributes like location, neighborhood amenities, and property '
                          'condition are highly valued.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Demand is driven by individuals, families or companies'
                          ' seeking a living and specifically distance to their working space if they are employed , '
                          'often with a focus on long-term stability and community integration.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Buyers seeking to occupy properties typically focus on the '
                          'intrinsic value of the home rather than speculative potential. '
                          'Their willingness to pay is based on the property\'s suitability for '
                          'their personal needs, such as location, size, and amenities, rather '
                          'than expectations of future price appreciation. As a result, '
                          'the prices of such properties tend to remain relatively stable '
                          'and are less susceptible to fluctuations driven by speculative behavior. '
                          'This stability is rooted in the fact that buyers-occupiers prioritize '
                          'long-term satisfaction and utility over short-term market trends, '
                          'leading to a more consistent pricing environment. ',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ Stable demand from buyer-occupiers helps maintain '
                          'property values and supports local economies',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n\nInvestor-Buyer Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ To clearly differentiate investor-buyers from speculator-buyers, '
                          'we define investor-buyers as individuals who purchase properties with the '
                          'intention of generating rental income or renovating and reselling them '
                          'at higher prices due to significant improvements in quality. '
                          '\n▶ Properties with strong fundamentals, such as good locations, desirable features, '
                          'and low maintenance costs for generating rental income.'
                          '\n▶ Old or dilapidated properties capable of being renovated or redeveloped',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Driven by investors who buy properties for long-term rental '
                          'income or profits from renovating or redeveloping properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Investors are willing to pay fair market prices for properties that '
                          'meet their investment criteria.'
                          '\n▶ Investment criteria for such investments typically encompass '
                          'several key factors, including both expected and unexpected '
                          'costs associated with acquiring the property, projected rental '
                          'income over several years, anticipated renovation or development '
                          'costs, and expected selling prices of the renovated properties.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Investor-buyer properties can have a stabilizing effect on the market '
                          'by providing a steady supply of rental units that will prevent from rising prices '
                          'by providing alternatives properties to live or work. '
                          '\n▶ They contribute to the increase in supply of higher quality '
                          'homes if they renovate and redevelop the properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n\nSpeculator-Buyer Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,

                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Speculators are less concerned with the condition of property '
                          'or earning potential and more focused on its potential for price appreciation in short terms'
                          '\n▶ Speculators may focus on properties in areas with high demand or limited supply, '
                          'regardless of the fundamental value of the property',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The demand from buyer-speculators decreases as the return on investment in other markets increases, because they are primarily seeking financial gains rather than utilizing the building or profiting from its production or rental,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Speculators seek properties that they believe will increase '
                          'in value quickly, often based on market trends or speculation as a subjective and often riskier approach',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Speculators are willing to pay high prices for properties, '
                          'even if they are overvalued, in the hope of selling them at an even higher price later'
                          '\n▶ This can lead to price bubbles and volatility in the market',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Buyer-speculators can have a destabilizing effect on the market by increasing the purchase price for resident-buyers and long-term investors.'
                          '\n ▶ They can contribute to market fluctuations and increase the risk of price bubbles.'
                          '\n ▶ Some believe that speculation provides liquidity for those who need to buy or sell buildings, having a positive impact on the market. While this may be partially true, in most cases, due to the large number of speculators and high competition, they are willing to pay more than consumer buyers or investors, leading to increased purchase prices. However, if the market is efficiently managed through proper policy-making, sellers can find consumer buyers or investors, eliminating the need for speculators,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPolicy Recommendations',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ To address the negative impacts of speculative '
                          'demand, higher transaction fees and higher taxes '
                          'on profit of properties purchased for speculation '
                          'should be imposed.'
                          '\n▶ Prioritizing the sale of homes '
                          'to buyer-occupiers over speculative investors.'
                          '\n▶ Implementing '
                          'regulations that discourage the rapid buying and reselling of '
                          'properties without long-term ownership.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n\nGovernment Housing',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Buildings with basic qualities located in less '
                          'developed areas that can be offered to low-income groups at affordable'
                          ' prices or rents'
                          '\n▶ Properties that are usually of low quality '
                          'and not profitable for investors, which can be acquired by '
                          'governments and can be converted into new buildings with some '
                          'public usage, such as affordable housing, community centers, or other '
                          'public facilities.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ Demand is driven by low-income households, '
                          'seniors, and other vulnerable populations.'
                          '\n▶ They may feature income restrictions, rent control, and other '
                          'measures to ensure long-term affordability.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices are influenced by government policies,'
                          ' subsidies, and local market conditions',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ By offering affordable housing options, government initiatives '
                          'can help stabilize prices in less developed areas. This can '
                          'prevent rapid price increases driven by speculation and provide '
                          'a buffer against housing market volatility.'
                          '\n▶ The long-term sustainability of government housing programs '
                          'is crucial. Insufficient funding and poor management can lead to '
                          'deteriorating conditions, which may negatively impact the surrounding '
                          'area and reduce the intended benefits of such initiatives.'
                          '\n▶ Government housing programs can help address '
                          'social and economic issues, but may also create dependency '
                          'and reduce private investment',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n\n4. Demand Differences by Property Type: Luxury vs. Economic Properties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nLuxury Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,

                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶Luxury properties often feature very '
                          'high-priced materials, either due to their quality or beauty, which '
                          'makes them stand out from other properties'
                          '\n▶ The properties typically are large including expansive outdoor spaces, '
                          'landscaped gardens, and exclusive amenities that promote a luxurious lifestyle'
                          ' in premium locations.' ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Driven by high-income buyers seeking premium amenities, exclusivity, and status'
                          '\n▶ Demand is less sensitive to price changes compared to economic homes'
                          '\n▶ Conspicuous Consumption: Buyers often purchase '
                          'luxury properties to showcase their financial ability, even if '
                          'they do not need to use all the amenities or space',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Significantly higher than economic homes on a per-square-foot basis'
                          '\n▶ Prices are less influenced by macroeconomic factors '
                          'and more by the unique attributes of the property'
                          '\n▶ Price Records: Since buyers are willing to pay more '
                          'for uniqueness and high-quality materials, luxury properties '
                          'often set new price records in a city',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Demand for luxury homes is more stable and less affected by '
                          'economic cycles compared to the demand for economic properties.'
                          '\n▶ As demand for luxury properties increases in the short term, '
                          'prices begin to rise. However, buyers may not be priced out initially '
                          'due to an existing surplus. As prices continue to increase, some'
                          ' buyers may opt for smaller luxury properties, while others may '
                          'choose non-luxury properties of similar size. Consequently, some '
                          'buyers may exit the real estate market altogether. This shift can'
                          ' lead to a decline in the overall trade of luxury properties, '
                          'potentially resulting in a recession until the next market phase, '
                          'in which prices and demand across all property segments are adjusted.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\nEconomic Properties',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Moderate square footage, standard finishes, and common amenities'
                          '\n▶ Located in a variety of neighborhoods, not necessarily in the most desirable areas',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Driven by a broader range of buyers, including first-time homebuyers '
                          'and middle-income families'
                          '\n▶ Demand is more sensitive to changes in affordability, '
                          'such as interest rates and household incomes',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ More affordable and accessible for the average homebuyer'
                          '\n▶ Prices are more closely tied to macroeconomic factors, '
                          'such as employment, inflation, and mortgage rates',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,fontWeight: FontWeight.bold, color: Colors.teal,

                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Demands of economic properties have a larger impact '
                          'on the overall housing market because their lower prices per square foot '
                          'allow for a greater number of buyers to afford them compared to'
                          ' luxury properties'
                          '\n▶ Fluctuations in demand for economic properties can significantly'
                          ' influence market trends and affordability, both positively and negatively'
                          '\n▶ If appropriate policies are implemented, such as targeted '
                          'subsidies or zoning incentives, fluctuations in economic home '
                          'demand can positively impact affordability and accessibility',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n\n5. Demand Differences by Residential Density',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nHigh-Density Buildings (Apartments)',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Most properties are smaller, with shared amenities '
                          '(e.g., gyms, pools, common areas).'
                          '\n▶ Located in dense, mixed-use developments or high-rise buildings.'
                          '\n▶ However, some towers that are high-density buildings may have '
                          'larger properties, like penthouses',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Driven by young professionals, small families, and '
                          'those seeking more affordable housing options to purchase'
                          '\n▶ This is a good approach for resolving the problem of '
                          'residential-commercial properties due to the high efficiency '
                          'of land, but if these properties lie in the group of luxury, '
                          'big properties, they cannot resolve the problem and can instead enhance the crisis.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Purchase prices tend to be more affordable per '
                          'square foot compared to single-family homes'
                          '\n▶ However, if the properties being supplied are of the '
                          'luxury, big property type, the purchase prices would be very high',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ High-density building development can help address '
                          'housing affordability and supply issues in urban areas.'
                          '\n▶ Developers may prioritize building more profitable luxury apartments '
                          'over affordable housing options, which can exacerbate the housing '
                          'affordability crisis. Therefore, it is crucial to deploy '
                          'appropriate policies to address this issue and ensure the '
                          'development of affordable, high-density housing options that '
                          'cater to the needs of a diverse range of buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n\nLow-Density Buildings (Single-Family Homes)',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Typically feature larger lot sizes with more space between buildings.'
                          '\n▶ Often include single-family homes or townhouses with private yards.'
                          '\n▶ Emphasize outdoor living spaces, such as gardens, patios, and driveways.'
                          '\n▶ Generally have fewer shared amenities compared to high-density developments.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nDemand',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Driven by families, move-up buyers, and those seeking '
                          'more space and privacy to purchase. '
                          'Move-up buyers are current homeowners looking to purchase a larger or more expensive property.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Price per square foot for single-family homes are generally '
                          'higher than apartments or condominiums due to the effect of land value',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Single-family home development can contribute '
                          'to urban sprawl and increased reliance on personal vehicles.'
                          '\n▶ Demand for single-family homes may drive up prices, '
                          'as more land area is needed per square foot of property '
                          'compared to high-density buildings. This raises the price '
                          'of land, which is a significant component of property prices, '
                          'making home ownership less affordable for some buyers. Therefore,'
                          ' policymakers should consider restricting the construction of '
                          'single-family homes within the city limits to manage '
                          'traffic congestion. Alternatively, they could allow single-family '
                          'home construction in smaller sizes outside the city, where land is '
                          'more affordable, to maintain housing affordability while still '
                          'providing options for buyers seeking more space',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    /////////////////////
                    TextSpan(
                      text: '\n\n\nApproaches to Real Estate Demand Management',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nHigher Transaction Costs for Speculators',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ It is recommended to impose higher capital gains '
                          'taxes on properties sold within a short time period (e.g., 2 years) '
                          'to discourage flipping. This approach could help stabilize '
                          'the market by reducing speculative buying and selling.'
                          '\n▶ Implementing a speculation tax or vacancy tax on properties'
                          ' left empty is advisable. This measure would target investors'
                          ' who do not rent out their properties, encouraging them to '
                          'either rent or sell, thereby increasing the availability of housing in the market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nLimit Leverage for Investment Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Requiring higher down payments (e.g., 30%+) '
                          'for non-owner-occupied properties is advisable to '
                          'reduce speculative leverage. This approach could help '
                          'mitigate the risk of overleveraged investments and discourage '
                          'investors from purchasing properties solely for investment purposes, '
                          'potentially freeing up more housing stock for owner-occupiers. '
                          'A down payment is a portion of the total purchase price of a property'
                          ' that a buyer pays upfront, rather than financing the entire '
                          'amount through a mortgage or loan. '

                          '\n▶ It is advisable to restrict the ability of investors to use '
                          'home equity loans or cash-out refinancing to fund speculative purchases. '
                          'This measure may limit access to financing options for investors, '
                          'reducing the number of properties acquired for investment purposes '
                          'and increasing the availability of housing for owner-occupiers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nImprove Data Collection on Real Estate Market',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The disclosure of the number and price of traded building units, especially when accompanied by detailed addresses and features, can be highly beneficial for investors and analysts,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n▶ Require disclosure of all-cash purchases and investor identities '
                          'to better track speculative activity. '
                          '\n▶ Collect and publish detailed '
                          'data on the share of homes purchased by investors,'
                          ' flippers, and out-of-town buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nDifferential Tax Treatment',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Reducing or eliminating transaction taxes for first-time buyers purchasing new homes in the event of a housing shortage.'
                          '\n ▶ Increasing transaction taxes for non-first-time buyers reselling used buildings, especially if sold within a short timeframe (e.g., under 5 years).'
                          '\n ▶ Promoting housing supply: Tax incentives for new homes encourage builders to increase housing supply, which can help alleviate affordability pressures in the long term.'
                          '\n ▶ Implementing taxes on vacant or underutilized homes. This policy incentivizes investors to either rent out or sell their properties to prevent a decline in market supply,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nThis categorization clearly distinguishes between demand '
                          'driven by consumption needs (primary and secondary residences) '
                          'and demand driven by investment objectives, further dividing '
                          'investment demand into genuine long-term rental income-seeking '
                          'and speculative short-term price appreciation.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPolicymakers can use this framework to better understand '
                          'the different forces shaping the housing market and develop '
                          'targeted policies to address issues like housing affordability, '
                          'market stability, and the promotion of sustainable, '
                          'investment-driven demand.\n\n',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Add more content here
        ],
      ),
    );
  }
}

class DraggableScrollableContentSupply extends StatelessWidget {
  final ScrollController scrollController;

  const DraggableScrollableContentSupply({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return DraggableScrollbar.semicircle(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '\n\nSupply Side of the Real Estate Market',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply in the real estate market refers to the total '
                          'number of building units that their owners are willing and '
                          'able to offer for sale over a given period, assuming all other '
                          'factors remain constant. To gain a deeper understanding of the '
                          'characteristics of the supply side of the real estate market, we '
                          'can examine them from various perspectives, as outlined below,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n1. Property Size',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Large-Sized Properties'
                          '\n▶ Medium-Sized Properties'
                          '\n▶ Small-Sized Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n2. Property Age',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ New Property'
                          '\n▶ Used Property',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n3. Property Seller Type',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Consumer-Seller'
                          '\n▶ Investor-Seller'
                          '\n▶ Speculator-Seller'
                          '\n▶ Government-Seller',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n4.Residential Density',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ High-density residential/Apartments'
                          '\n▶ Low-density residential/Single-Family Homes',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n5. Property Type',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Luxury Properties'
                          '\n▶ Economic Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nEach property can be classified under one of the items of '
                          'each category mentioned above. For example, a single property '
                          'may be classified as: a newly constructed building '
                          '(under property age), belonging to an investor (under ownership), '
                          'a multi-apartment building (under residential density), and '
                          'an economic property (under property type). '
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\n1. Supply Differences by Property Size',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nLarge-Sized Properties',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Spacious apartments, condos, or single-family homes, '
                          'often 1,500 sqft (139 sqm) or more'
                          '\n▶ Luxury penthouses and villas, characterized by high-quality '
                          'finishes and modern amenities, '
                          'typically fall within the category of large properties. However, '
                          'this group also includes more standard properties'
                          '\n▶ Often located in desirable neighborhoods',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ In larger building units, various amenities and spaces can be provided that are not feasible in smaller to medium-sized units. This, combined with a desirable neighborhood, makes them suitable for conversion into luxury units.'
                          '\n ▶ Large building units of ordinary or poor quality are typically offered by owners who either need capital and are willing to sell their unit to purchase a smaller one, or lack the funds to renovate their unit.'
                          '\n ▶ High-quality large building units are usually supplied by investors and builders with high capabilities, who are willing to spend more per square foot on construction. Their goal is to maximize profit by offering luxurious materials and special amenities.'
                          '\n ▶ Suppliers primarily target high-income groups, including affluent families, executives, and investors,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),



                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Luxury large properties have a significantly higher purchase price per square foot compared to other types of properties, due to their features and luxurious amenities.'
                          '\n ▶ Suppliers of luxury large properties, typically having greater financial capabilities than other suppliers, can afford to wait long enough to sell their properties at the highest possible price, thus setting sales records. This is because they can receive higher prices from buyers willing to pay more for exclusivity, high-quality materials, and exclusive amenities.'
                          '\n ▶ In contrast, non-luxury large properties may have a lower price per square foot compared to smaller properties. This is because the construction costs for smaller properties are higher due to fixed elements that every home must have, such as bathrooms, kitchens, and heating-cooling systems. However, economies of scale in larger properties can lead to reduced costs per square foot, resulting in lower prices,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.bold, color: Colors.teal,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Although an increase in demand for large building units can lead to higher purchase prices and potentially transfer this increase to smaller and medium-sized units, the impact of increased supply on the purchase price of luxury large units may not significantly reduce their prices. This is largely due to the fact that sellers of luxury units generally have less inclination to lower their prices for various reasons, including high construction costs and financial stability, which means they are under less pressure to sell.'
                          '\n\n In contrast, developers of ordinary large and small-to-medium units may face greater financial pressures, which could prompt them to reduce purchase prices more quickly in response to market conditions.'
                          '\n\n ▶ Ultimately, like any other commodity, the final impact of the supply of large building units depends on the cumulative effect of various market factors over time. If a large supply of luxury units meets low demand, causing their prices to decrease, the impact of this reduction on the prices of smaller and medium-sized units should still be analyzed separately,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),





                    TextSpan(
                      text: '\n\nMedium-Sized Properties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Apartments, condos, or homes ranging from approximately 800-1,500 sqft (74-139 sqm).'
                          '\n▶ Provide a balance of space and affordability, making them attractive to a diverse range of buyers.'
                          '\n▶ Appeal to families, young professionals, and first-time homebuyers seeking practical living solutions.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Medium-sized properties are supplied by a combination of investors and builders aiming for profitability, and owner-consumers with various goals, such as needing capital, seeking variety in homes and neighborhoods, etc.'
                          '\n ▶ Their construction is generally less complex and more feasible compared to larger units and sometimes even smaller ones, leading to a greater supply of these units in the market,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The price of medium-sized properties is generally lower than that of luxury units, making them more affordable for a broader audience.'
                          '\n ▶ The price per square foot of medium-sized units can vary significantly based on location, amenities, and market demand.'
                          '\n ▶ Factors such as proximity to workplaces and neighborhood quality are very important in determining the price of these units,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Compared to large building units, medium-sized units require less investment, allowing more units to be supplied with a fixed amount of capital. This increased supply helps meet the demand of a greater number of buyers, reduces demand pressure in the market, and contributes to overall market stability, especially in rapidly growing urban neighborhoods where space is limited,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),



                    TextSpan(
                      text: '\n\nSmall-Sized Properties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Compact apartments, studios, or accessory dwelling units (ADUs), '
                          'often approximately under 800 sqft (74 sqm).'
                          '\n▶ Cater to young professionals, students, downsizing seniors, '
                          'and those with limited budgets.'
                          '\n▶ Offer more affordable housing options, especially for first-time and low-income buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ New small building units are typically supplied by builders who focus on high-density projects to address traffic issues (by reducing intra-city travel through sales near workplaces) or the shortage of affordable housing units.'
                          '\n ▶ The supply of small building units is influenced by economic conditions, urban policies for managing density and traffic, migrant populations, and construction costs,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ The price per square foot can be higher due to the fixed '
                          'costs of construction, but the overall price remains more affordable and lower '
                          'prices compared to medium and large-sized properties.'
                          '\n▶ These properties offer a more accessible entry point into the housing market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Supply of small-sized properties play a crucial role in providing '
                          'affordable housing options in high-demand areas and reducing prices.'
                          '\n▶ They help address the housing needs of low-income and '
                          'underserved populations, promoting social and economic diversity.'
                          '\n▶ An increase in the supply of small-sized properties can '
                          'contribute to more inclusive and equitable housing markets.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nTo incentivize the development of more medium-sized and small-scale '
                          'affordable housing units, policymakers could consider:',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n1. Increasing Construction Permit Fees and Trade Taxes for Larger '
                          'Properties:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nImplementing higher permit fees and taxes for properties '
                          'over 1,500 sqft (139 sqm) can make it less financially attractive '
                          'for developers to build large luxury units, encouraging them to focus '
                          'on smaller, more affordable properties instead.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n2. Offering Incentives for Affordable Unit Development:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProviding tax credits, subsidies, or expedited permitting for '
                          'projects that include a certain percentage of medium-sized '
                          '(800-1,500 sqft or 74-139 sqm) or small-sized (under 800 sqft or 74 sqm)'
                          ' units can help offset the higher costs associated with building '
                          'more units per square foot.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n3. Implementing Inclusionary Zoning Policies:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n Requiring a mix of unit sizes in new developments, '
                          'including a balance of large, medium, and small-scale options, '
                          'can ensure a diverse range of housing choices within each project.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n4. Providing Financial Assistance for First-Time and Low-Income Buyers:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n Offering programs like down payment assistance, low-interest mortgages, '
                          'and homebuyer education courses can help make the smaller, '
                          'more affordable units accessible to those who need them most.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nBy implementing these targeted policies, '
                          'policymakers can incentivize the development of a more '
                          'balanced housing supply that caters to the diverse needs '
                          'and budgets of the population, from affluent buyers to '
                          'first-time and low-income property buyers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    // Supply Differences by Property Age
                    TextSpan(
                      text: '\n\n\n2. Supply Differences by Property Age',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nNew Property:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\nSupply of newly built homes, condos, and other residential properties.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

// Attributes
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ New economic properties are designed with affordability'
                          ' in mind, featuring cost-effective materials and efficient '
                          'layouts that prioritize functionality and low maintenance'
                          '\n▶ New luxury properties have attributes such as brand-new construction, '
                          'high-quality materials, new equipment, '
                          'and smart home features that are highly valued',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

// Prices
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ New properties are gradually constructed after purchasing land. As a result, builders consider both the costs incurred and the time invested in completing the project when determining their sale prices, which may differ from market prices at the time of sale. Additionally, investors must account for future market fluctuations when pricing their properties. Consequently, accurately determining the price of new properties is complex.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

// Supply
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Unlike used building units, new building units are not limited by the area, infrastructure, or design of previous structures. This provides greater flexibility in addressing changing economic, social, and environmental needs.'
                          '\n ▶ With proper construction policies, new development offers the best opportunity to design homes that meet the needs of low-income groups. This can be achieved through:'
                          '\n   - Smaller and more affordable units'
                          '\n   - Use of sustainable building materials and technologies'
                          '\n   - Incorporating energy-efficient appliances and smart systems to reduce ecological impacts'
                          '\n ▶ Policymakers can utilize economic principles with a development-oriented perspective to increase supply in the market. This approach can help bring the housing market to a fairer social and economic equilibrium,',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


// Market Impact
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The supply of new building units, if characterized by suitable features and proper location, can significantly help stabilize the market. Otherwise, even the supply can lead the market toward recession due to high capital investment for a limited number of units, or inflation due to excessively expensive materials, or both.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    // Policy Recommendations

                    TextSpan(
                      text: '\n\n\nUsed Property:',
                      style: TextStyle(
                        fontSize: titleFontSize,fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\nSupply of previously used properties being supplied in the market. '
                          'This type can be further divided into:'
                          '\n - Qualified Used Properties'
                          '\n - Unqualified Used Properties',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    // Standard Quality Used Properties
                    TextSpan(
                      text: '\n\nQualified Quality Used Properties:',
                      style: TextStyle(
                        fontSize: textFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Previously used properties being supplied in the market.'
                          '\n▶ Typically in good condition and meeting quality standards.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices are influenced by market conditions and the property\'s condition.'
                          '\n▶ Buyers can negotiate based on the property\'s attributes and recent comparable sales.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of qualified used properties depends '
                          'on factors like propertie\'s owner goals and the overall housing market.'
                          '\n▶ Appropriate policies to prevent speculation can help increase '
                          'the supply of these properties.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Qualified used properties provide affordable housing options for buyers'
                          ' in compare to new properties with same size and location.'
                          '\n▶ Increasing the supply of these properties can '
                          'positively impact market equilibrium and affordability.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

// Unqualified Used Properties
                    TextSpan(
                      text: '\n\nUnqualified Used Properties:',
                      style: TextStyle(
                        fontSize: textFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Existing homes that do not meet current quality standards.'
                          '\n▶ May require significant repairs or renovations.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices for unqualified used properties are '
                          'typically lower than standard quality homes.'
                          '\n▶ Buyers must factor in the cost of necessary improvements.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of unqualified used properties can be '
                          'reduced by converting them to new, higher-quality housing.'
                          '\n▶ This can be encouraged through policies like discounted '
                          'permitting fees and additional financing for redevelopment.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Increasing the supply of underutilized or dilapidated '
                          'properties provides an opportunity for redevelopment. By '
                          'either rebuilding these properties from the ground up or '
                          'undertaking significant renovations, the overall supply of '
                          'high-quality housing units can be increased. This influx of '
                          'improved properties can help stabilize and even reduce prices '
                          'in the housing market.'
                          '\n▶ Unqualified used properties can pose risks related '
                          'to safety, crime, and neighborhood quality. Converting '
                          'these properties to new housing can help '
                          'mitigate these risks and costs while increasing '
                          'the overall supply of decent, affordable homes.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\n3. Supply Differences by Seller Type:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nConsumer-Seller:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\nIn this type, the sellers of properties are the residents themselves. '
                          'This form of housing supply can help stabilize the market and '
                          'promote affordability, as consumer-sellers are less likely '
                          'to engage in speculative behavior. '
                          'Because consumer-sellers typically seek a new property to reside in after '
                          'selling their current home, they are often more risk-averse than '
                          'professional investors. This risk aversion makes them less inclined '
                          'to buy and sell properties in the short term for profit. Their primary focus is '
                          'on finding a suitable living situation rather than engaging in '
                          'speculative activities, which further stabilizes the housing market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ Consumer-sellers typically prioritize factors such as neighborhood quality, '
                          'school districts, and proximity to work or family when selling their properties.'
                          '\n▶ The focus on personal needs rather than profit can lead to more '
                          'stable pricing in the housing market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices set by consumer-sellers may be more reflective of local '
                          'market conditions and personal circumstances rather than speculative trends'
                          '\n▶ Since they are often motivated by the need to find a new home, '
                          'their pricing strategies can contribute to more stable market conditions'
                          '\n▶ However, if consumer-sellers perceive a downturn in the market, they may '
                          'be reluctant to lower prices, which can lead to prolonged listings',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of properties from consumer-sellers can fluctuate based '
                          'on personal circumstances such as job changes, family needs, or retirement'
                          '\n▶ This supply is generally more stable compared to investor-driven markets, '
                          'as it is less influenced by speculative buying and selling'
                          '\n▶ However, in times of economic uncertainty, consumer-sellers may hold onto '
                          'their properties longer, reducing the available supply',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Consumer-sellers contribute to a more stable housing market by'
                          ' prioritizing their living needs over profit, reducing volatility'
                          '\n▶ Their presence can help moderate price fluctuations, making the market '
                          'more accessible for first-time buyers and families',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nInvestor-Seller:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\nInvestor-sellers in this context refer to investors in '
                          'real estate who purchase land to '
                          'engage in the construction to '
                          'supply the market for profit. They may also purchase properties '
                          'with the intention of selling them after significant renovations.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Investor-sellers have access to capital and construction expertise, and under normal market conditions,'
                          ' they tend to sell units and start new projects to generate profits.'
                          '\n▶ The properties they develop or renovate may include a range of housing '
                          'types, from single-family homes to multi-unit buildings.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices set by investor-sellers can be influenced by market '
                          'trends and their personal expected profit.'
                          '\n▶ Investors may price properties based on anticipated future value'
                          ' rather than current market conditions, which can lead to rising prices. However, their supply often '
                          'stabilizes the market and can even reduce prices, unless the properties are located in premium areas '
                          'or are luxury types that may command higher prices.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of properties from investor-sellers can fluctuate based '
                          'on market conditions and investment strategies.'
                          '\n▶ Investors may choose to hold properties longer during downturns, '
                          'limiting the available inventory in the market.'
                          '\n▶ Conversely, a surge in investor activity can lead to an increase in '
                          'housing supply, particularly in high-demand areas.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Investor-sellers can have a significant impact on the real estate market as they are the only group of suppliers that increase the number of buildings.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n ▶ Effective policies are essential to create a balance between investor activities and the housing needs of society, ensuring that development aligns with demand.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n ▶ If investors do not choose suitable locations for construction and fail to attract buyers, they risk losing their financial and material resources. Additionally, if they opt to build luxury buildings, although they increase the overall number of buildings in the market, this can lead to higher sale prices and even drive the market toward recession.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nSpeculator-Seller:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Suppliers who typically do not reside in the units they sell and did not build them, but rather purchase them solely to resell at a higher price for profit.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Some believe that speculators are supplying the money to the '
                          'market for those who need to sell their homes in the short term, '
                          'which can be correct in some exceptional cases. But this '
                          'speculative activity ultimately undermines housing affordability '
                          'and accessibility for the broader population, exacerbating economic '
                          'inequality and making it increasingly difficult for first-time and low-income '
                          'buyers to enter the housing market.'
                          '\n▶ Therefore, speculation increases prices in favor of high-income groups, '
                          'effectively destroying the economic supply of homes for the real, '
                          'home-needed demand from lower- and middle-income households.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ This type of property supply enters the market '
                          'without significant renovations aimed at increasing value. Instead, '
                          'speculators typically buy properties below their market value or'
                          ' at current market value and wait to sell at higher prices'
                          '\n▶ Speculators may contribute to the supply of properties in the short term, '
                          'but they don\'t increase the number of properties constructed and '
                          'their overall demand can drive up market prices',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ The focus on short-term gains can result in a lack of long-term investment'
                          ' in the housing market, decreasing overall supply in long term'
                          '\n▶ Speculative activity undermines housing affordability and'
                          ' accessibility for the broader population'
                          '\n▶ It exacerbates economic inequality, making it increasingly '
                          'difficult for first-time and low-income buyers to enter the housing market'
                          '\n▶ Policymakers must address this speculative dynamic to ensure a '
                          'more equitable and sustainable housing market',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nGovernment-Seller:',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Government housing includes properties owned or '
                          'subsidized by public agencies to provide accessible living options.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices for Government housing are typically set '
                          'below market rates to maintain accessibility'
                          '\n▶ Subsidies and income restrictions help keep rents and purchase '
                          'prices within reach of low-income households'
                          '\n▶ However, the limited supply of affordable housing can lead to long '
                          'waitlists and competition for available units',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of government housing is often '
                          'constrained by limited funding and resources'
                          '\n▶ Policies such as inclusionary zoning and tax incentives can '
                          'encourage private developers to include affordable units in their projects'
                          '\n▶ However, the overall supply remains insufficient to meet the '
                          'growing demand for affordable housing in many areas',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Government housing can help address market failures and ensure '
                          'that low-income households have access to decent, affordable homes.'
                          '\n▶ However, inefficient implementation or corruption can '
                          'undermine the effectiveness of these programs'
                          '\n▶ While the free market should be the primary '
                          'driver of housing supply, government intervention can act as a '
                          'lever to push the market towards a more equitable equilibrium '
                          'Policymakers must strike a balance between government '
                          'intervention and free market forces to create a more '
                          'equitable and sustainable housing system'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),




                    TextSpan(
                      text: '\n\n\n4. Supply Differences by Residential Density',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nHigh-Density Residential',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ This category includes multi-unit housing structures such as '
                          'apartment buildings, condominiums, and townhouses'
                          '\n▶ High-density residential developments are often more efficient '
                          'in terms of land usage and infrastructure utilization,'
                          ' especially in urban areas facing housing shortages'
                          '\n▶ These properties can offer amenities such as shared facilities, '
                          'green spaces, and community areas, promoting a sense of community among residents',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices for high-density residential properties can vary '
                          'depending on location, amenities, and market demand'
                          '\n▶ These properties often offer more affordable options compared '
                          'to low-density housing, making them accessible to a wider range of buyers and renters'
                          '\n▶ However, in some high-demand urban areas or luxury towers, high-density properties '
                          'may still be out of reach for lower-income households',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                      '\n▶ High-density properties can be financed for construction more '
                          'easily than low-density properties, such as villas, because '
                          'developers can sell some units to finance the total project '
                          'before construction begins or while it is ongoing. This approach '
                          'allows for quicker capital recovery and reduces the financial burden on the developer.'
                          '\n▶ In many cases, suppliers of high-density properties are speculators. '
                          'These properties typically have lower prices, making them more '
                          'affordable and accessible to a wider range of buyers. As a result, '
                          'more speculators are attracted to purchase and resell these properties '
                          'to generate profits. This trend can easily convert high-density '
                          'properties into investment commodities rather than consumption '
                          'commodities, making them susceptible to inflation and recession.'
                          'To address this issue, appropriate policies need to be implemented. '
                          '\n▶ The supply of high-density residential properties can help '
                          'increase the overall housing stock that meet the requirements of different buyers. '
                          '\nHowever, the development of high-density housing may face zoning '
                          'restrictions or community opposition in some areas, '
                          'limiting its ability to rapidly expand the supply',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Increasing the supply of high-density residential properties'
                          ' can alleviate housing shortages in urban areas, contributing to overall market stability'
                          '\n▶ These developments can attract a diverse range of residents, '
                          'including young professionals, families, and retirees, fostering vibrant communities'
                          '\n▶ However, if supply increases too rapidly without corresponding '
                          'demand, it could lead to oversupply and potential price declines in the market',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n\nLow-Density Residential',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ This category encompasses housing types with a '
                          'smaller number of individual units, such as duplexes, '
                          'triplexes, and small-scale single-family homes.'
                          '\n▶ Low-density residential properties provide more space, '
                          'privacy, and a more residential character compared to high-density options.'
                          '\n▶ These properties often feature larger yards, gardens, '
                          'and outdoor spaces, appealing to families and individuals seeking a quieter living environment.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices for low-density residential properties in urban areas are '
                          'generally more compared to medium and high-density '
                          'options, unless they are far from city center, work place and markets that reduces their prices.'

                          '\n▶ The overall cost of low-density housing can be '
                          'influenced by the land-intensive nature of development, '
                          'which may drive prices higher in areas with limited available land.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: 'Suppliers of used low-density buildings or used villas are typically the residents and end-users of those units who intend to purchase another property for personal use.'
                          '\n ▶ New low-density buildings or new villas are usually supplied by builders who previously purchased land or existing units and have rebuilt them as low-unit or villa-style properties.'
                          '\n ▶ The supply of low-density residential units can be beneficial for controlling traffic and reducing pollution in densely populated city centers, and they can be placed between high-density neighborhoods.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Low-density residential properties contribute to the overall '
                          'character and livability of neighborhoods, providing a buffer '
                          'between high-density developments and open spaces But it cannot be '
                          'considered a solution for resolving the housing problem. '
                          '\n▶ They can enhance property values in surrounding areas by creating'
                          ' desirable living environments that attract families and long-term residents'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\nBy considering both high-density and low-density residential '
                          'options, policymakers can work towards a balanced housing supply '
                          'that caters to the diverse needs and preferences of the population, '
                          'while also addressing environmental and infrastructure-related concerns.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n\n5. Supply Differences by Property Type: Luxury vs. Economic',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold, color: Colors.pink,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nLuxury properties',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Luxury properties are characterized by their premium materials, '
                          'unique architectural designs, and high-quality craftsmanship.'
                          '\n▶ The properties typically are large including expansive outdoor spaces, '
                          'landscaped gardens, and exclusive amenities that promote a luxurious lifestyle'
                          ' in premium locations.'
                          '\n▶ In today\'s world, they often feature advanced technology and smart home systems, '
                          'enhancing convenience and security for residents.'
                      ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The sale price per square foot of luxury properties is higher than standard properties due to the quality of materials and other costs, depending on location and features.'
                          '\n ▶ The high sale prices of luxury properties can increase the average purchase price of other types of properties in surrounding neighborhoods, potentially excluding middle and low-income buyers from the market.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ The supply of luxury building properties is generally limited because they are typically constructed in prime locations, considering the smaller population of wealthy buyers.'
                          '\n ▶ While luxury properties can drive up market prices, they may lead to a decrease in overall market activity due to the significant capital and resources they attract.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Luxury homes can elevate average home prices, '
                          'that may also lead to affordability issues for lower-income buyers.'
                          '\n▶ In some cases, the introduction of luxury properties can '
                          'stimulate market activity, attracting investors and increasing overall interest in the area.'
                          '\n▶ However, if the market is already saturated with high-priced'
                          ' homes, it may lead to a recession in trading and production within the real estate sector.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nStandard properties',
                      style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.purple,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nAttributes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n ▶ Standard building properties are recognized for their functional design and essential amenities.'
                          '\n ▶ Building properties typically have smaller square footage compared to luxury buildings and require less capital and materials per square foot, allowing for a greater supply with a fixed amount of capital. However, they still provide acceptable quality spaces for work or comfortable living.'
                          '\n ▶ These properties may use cheaper materials and construction methods to maintain affordability, yet they still offer acceptable quality spaces for work or living.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\nPrices',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Prices for standard properties are generally '
                          'lower than luxury properties, making them accessible to a wider range of buyers.'
                          '\n▶ The price per square foot is often more competitive for these properties, '
                          'as they prioritize affordability over high-end finishes and amenities.'
                          ' They maintain security and reliability similar to luxury properties but '
                          'utilize essential materials and equipment, rather than using materials'
                          ' and equipment from luxury brands, which '
                          'are often associated with aesthetics or special features that may not be necessary for functionality.'

                          '\n▶ Economic properties can provide a more attainable path to '
                          'homeownership for middle-income and lower-income families.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nSupply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ The supply of standard properties can be increased'
                          ' by shifting resources and materials towards their construction.'
                          '\n▶ Streamlining the development process for economic properties'
                          ' can also contribute to a more robust supply.'
                          '\n▶ Policies such as inclusionary zoning, developer incentives, '
                          'and rehabilitation programs can help boost the supply of decent, low-cost housing.'

                          '\n▶ One strategy for redistributing population density across '
                          'different regions of a city is through Transferable Development '
                          'Rights (TDR). This approach allows developers to sell construction '
                          'rights from a less demanded area to a more desirable location, '
                          'enabling the construction of taller buildings or larger floor '
                          'spaces where demand is higher. By facilitating this transfer,'
                          ' TDR helps manage urban growth and encourages development in areas'
                          ' that can better accommodate increased density'
                          '\n▶ Invest in infrastructure and transit to enable more housing '
                          'in desirable urban areas.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Blockchain technology is revolutionizing real estate through fractional ownership.'
                          '\n▶ Broader access: Retail investors can participate in high-value properties with small capital.'
                          '\n▶ Easier financing: Developers can fund projects faster by selling digital shares.'
                          '\n▶ Enhanced liquidity: Property tokens can be traded easily, unlike physical real estate.'
                          '\n▶ Security and transparency: Blockchain\'s immutable ledger ensures traceable and secure transactions.'
                          '\n▶ This transformation not only democratizes property investment but also accelerates market growth while reducing risks.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n\nMarket Impact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.teal, fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n▶ Economic homes provide more accessible housing options '
                          'for the majority of home buyers, promoting social and economic diversity.'
                          '\n▶ By increasing the supply of affordable homes, the market can '
                          'become more balanced, reducing the risk of pricing out middle-income '
                          'and lower-income households.\n\n' ,
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add more content here
        ],
      ),
    );
  }
}*/


// Inside EconomicsOfConstructionPage Widget
class EconomicsOfConstructionPage extends StatefulWidget {
  const EconomicsOfConstructionPage({super.key});

  @override
  EconomicsOfConstructionPageState createState() => EconomicsOfConstructionPageState();
}

class EconomicsOfConstructionPageState extends State<EconomicsOfConstructionPage> {
  bool _jobOpportunitiesExpanded = false;
  bool _introductionEconomics = false;
  bool _demandIntroductionEconomics = false;
  bool _demandSizeEconomics = false;
  bool _demandAgeEconomics = false;
  bool _demandBuyerEconomics = false;
  bool _demandResidentialEconomics = false;
  bool _demandPropertyTypeEconomics = false;

  bool _supplyIntroductionEconomics = false;
  bool _supplySizeEconomics = false;
  bool _supplyAgeEconomics = false;
  bool _supplySellerEconomics = false;
  bool _supplyResidentialEconomics = false;
  bool _supplyPropertyTypeEconomics = false;
  

    bool _referencesExpanded = false;
  final ScrollController _scrollControllerEco = ScrollController();

  @override
  void dispose() {
    _scrollControllerEco.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    const ipadBreakpoint = 850.0; // or your preferred breakpoint


    final bool isIpad = screenWidth > ipadBreakpoint;

    final buttonWidth = isIpad ? buttonWidthPad : buttonWidthPhone;
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(52, 56, 66, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Expanded(
              child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       SizedBox(height: 2 * spacingHeight),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text( 'Economics of Real Estate',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize),
                            ),
                          ),

                       SizedBox(height: spacingHeight),

         //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                          SizedBox(width:buttonWidth,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _demandIntroductionEconomics = !_demandIntroductionEconomics;

                                     _demandSizeEconomics = false;
                                     _demandAgeEconomics = false;
                                     _demandBuyerEconomics = false;
                                     _demandResidentialEconomics = false;
                                     _demandPropertyTypeEconomics = false;

                                    _supplyIntroductionEconomics = false;
                                     _supplySizeEconomics = false;
                                     _supplyAgeEconomics = false;
                                     _supplySellerEconomics = false;
                                     _supplyResidentialEconomics = false;
                                     _supplyPropertyTypeEconomics = false;

                                     _jobOpportunitiesExpanded = false;
                                    _referencesExpanded = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color.fromRGBO(
                                      30, 29, 1, 1.0),
                                  textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                                  backgroundColor: const Color.fromRGBO(
                                      236, 135, 3, 1.0), // Set the background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9), // Set the border radius
                                    //    side: const BorderSide(color: Colors.white), // Set the border color to black
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Demand Side\nIntroduction',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: titleFontSize),),
                                )
                            ),
                          ),


                      if (_demandIntroductionEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: DemandIntroduction(scrollController: _scrollControllerEco
                          ),
                        ),
                       SizedBox(height: spacingHeight),
          

          //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;

                                _demandSizeEconomics = !_demandSizeEconomics;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Demand Side\nProperty Size',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),

                      if (_demandSizeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Demand1PropertySize(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),
                      
                      
         //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;

                                _demandSizeEconomics = false;
                                _demandAgeEconomics = !_demandAgeEconomics;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Demand Side\nProperty Age',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_demandAgeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Demand2PropertyAge(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

              //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;

                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = !_demandBuyerEconomics;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Demand Side\nBuyer Type',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_demandBuyerEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Demand3BuyerType(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

            //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                     
                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = !_demandResidentialEconomics;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Demand Side\nResidential Density',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_demandResidentialEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Demand4ResidentialDensity(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

        //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = !_demandPropertyTypeEconomics;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  236, 135, 3, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Demand Side\nProperty Type',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),

                      if (_demandPropertyTypeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Demand5PropertyType(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),
      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                      
                      
 // ////////////////// SUPPLY  // //////////////////

       //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = !_supplyIntroductionEconomics;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nIntroduction',
                                style: TextStyle(color: Colors.black,
                                    fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_supplyIntroductionEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: SupplyIntroduction(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),


                      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = !_supplySizeEconomics;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nProperty Size',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),

                      if (_supplySizeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Supply1PropertySize(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),


                      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = !_supplyAgeEconomics;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nProperty Age',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_supplyAgeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Supply2PropertyAge(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

                      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = !_supplySellerEconomics;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nSeller Type',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_supplySellerEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Supply3SellerType(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

                      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = !_supplyResidentialEconomics;
                                _supplyPropertyTypeEconomics = false;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nResidential Density',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),


                      if (_supplyResidentialEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Supply4ResidentialDensity(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),

                      //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      SizedBox(width:buttonWidth,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _demandIntroductionEconomics = false;
                                _demandSizeEconomics = false;
                                _demandAgeEconomics = false;
                                _demandBuyerEconomics = false;
                                _demandResidentialEconomics = false;
                                _demandPropertyTypeEconomics = false;

                                _supplyIntroductionEconomics = false;
                                _supplySizeEconomics = false;
                                _supplyAgeEconomics = false;
                                _supplySellerEconomics = false;
                                _supplyResidentialEconomics = false;
                                _supplyPropertyTypeEconomics = !_supplyPropertyTypeEconomics;

                                _jobOpportunitiesExpanded = false;
                                _referencesExpanded = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(
                                  30, 29, 1, 1.0),
                              textStyle:  TextStyle(fontSize: titleFontSize), // Set the font size to 20
                              backgroundColor: const Color.fromRGBO(
                                  1, 174, 24, 1.0), // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9), // Set the border radius
                                //    side: const BorderSide(color: Colors.white), // Set the border color to black
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Supply Side\nProperty Type',
                                style: TextStyle(color: Colors.black
                                    , fontSize: titleFontSize),),
                            )
                        ),
                      ),

                      if (_supplyPropertyTypeEconomics)
                        SizedBox(height:screenHeight * 0.6,
                          child: Supply5PropertyType(scrollController: _scrollControllerEco
                          ),
                        ),
                      SizedBox(height: spacingHeight),


         //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      SizedBox(width:buttonWidth,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _demandIntroductionEconomics = false;
                                    _demandSizeEconomics = false;
                                    _demandAgeEconomics = false;
                                    _demandBuyerEconomics = false;
                                    _demandResidentialEconomics = false;
                                    _demandPropertyTypeEconomics = false;

                                    _supplyIntroductionEconomics = false;
                                    _supplySizeEconomics = false;
                                    _supplyAgeEconomics = false;
                                    _supplySellerEconomics = false;
                                    _supplyResidentialEconomics = false;
                                    _supplyPropertyTypeEconomics = false;

                                    _jobOpportunitiesExpanded = !_jobOpportunitiesExpanded;
                                    _referencesExpanded = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color.fromRGBO(
                                      30, 29, 1, 1.0),
                                  textStyle:  TextStyle(fontSize: titleFontSize),
                                  backgroundColor: const Color.fromRGBO(
                                      150, 1, 13, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child:  Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Job Opportunities',
                                    style: TextStyle(color: Colors.white, fontSize: titleFontSize),),
                                )
                            ),
                          ),


                      if (_jobOpportunitiesExpanded)
                        SizedBox(height:screenHeight * 0.6,
                          child: DraggableScrollableContentJob(scrollController:
                          _scrollControllerEco
                          ),
                        ),
                       SizedBox(height: spacingHeight),


                       if (_referencesExpanded)
                        SizedBox(
                          height: screenHeight,
                          child: DraggableScrollableContentReferences(
                            scrollController: _scrollControllerEco,
                          ),
                        ),
                       SizedBox(height: spacingHeight),

                    ],
                  ),
                ),
              ),
            ),
        ),

              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon:  Icon(Icons.home,
                          color: Colors.white, size: iconSizeLarge),
                      onPressed: () {
                        NavigationService().navigateToScreen(const RealEstateTopicsPage());
                      }),
                   SizedBox(width: spacingHeight *2),
                  IconButton(
                    icon:  Icon(Icons.keyboard_arrow_up_rounded,
                        color: Colors.white70, size: iconSizeLarge),
                    onPressed: () {
                      setState(() {
                        _demandIntroductionEconomics = false;
                        _demandSizeEconomics = false;
                        _demandAgeEconomics = false;
                        _demandBuyerEconomics = false;
                        _demandResidentialEconomics = false;
                        _demandPropertyTypeEconomics = false;

                        _supplyIntroductionEconomics = false;
                        _supplySizeEconomics = false;
                        _supplyAgeEconomics = false;
                        _supplySellerEconomics = false;
                        _supplyResidentialEconomics = false;
                        _supplyPropertyTypeEconomics = false;

                        _jobOpportunitiesExpanded = false;
                        _referencesExpanded = false;
                      });
                    },
                  ),
                  SizedBox(width: spacingHeight *2),
                  IconButton(
                    icon:  Icon(Icons.info_outline,
                        color: Colors.white70, size: iconSizeLarge),
                    onPressed: () {
                      setState(() {
                        _demandIntroductionEconomics = false;
                        _demandSizeEconomics = false;
                        _demandAgeEconomics = false;
                        _demandBuyerEconomics = false;
                        _demandResidentialEconomics = false;
                        _demandPropertyTypeEconomics = false;

                        _supplyIntroductionEconomics = false;
                        _supplySizeEconomics = false;
                        _supplyAgeEconomics = false;
                        _supplySellerEconomics = false;
                        _supplyResidentialEconomics = false;
                        _supplyPropertyTypeEconomics = false;

                        _jobOpportunitiesExpanded = false;
                        _referencesExpanded = !_referencesExpanded;
                      });
                    },
                  ),
                ],
              ),
               SizedBox(height: 2 * spacingHeight),
           //   const MyBannerAdWidget(),
            ],
        ),
      ),
    );
  }
}


class DraggableScrollableContentJob extends StatelessWidget {
  final ScrollController scrollController;

  const DraggableScrollableContentJob({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;


    return DraggableScrollbar.semicircle(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(
                TextSpan(
                  children: [

                    TextSpan(
                      text: '\nIn addition to the various jobs directly related to '
                          'the real estate market that some of them are mentioned below,'
                          ' it is important to note that all equipment and materials '
                          'used in construction are produced in factories. As the real estate '
                          'sector grows, it also increases job opportunities in these manufacturing facilities.'

                          '\n\nMoreover, as we continue to construct buildings using traditional '
                          'technologies, we will primarily encounter environmental issues,'
                          ' even if we set aside economic and social concerns. Therefore, '
                          'there is a need for new jobs, particularly in research and '
                          'innovative production methods for materials and equipment, '
                          'such as air conditioning systems. While traditional production '
                          'workers may face unemployment due to these new methods, new '
                          'opportunities will arise for workers and scientists in these '
                          'innovative fields, although likely in smaller numbers.',
                      style: TextStyle(
                        fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\n\n1. Land Surveyors',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nMeasure and map the property boundaries and topography of the construction site.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n2. Geotechnical Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nAssess the soil and rock conditions at the construction site to ensure a stable foundation.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n3. Demolition Workers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nCarry out the demolition and removal of existing structures to prepare the site for new property.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n4. Foundation Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and construct the foundation of the building, ensuring it can support the structure.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n5. Excavators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nOperate heavy machinery to excavate and prepare the construction site.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n6. Architects',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and plan the construction of buildings and other structures.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n7. Civil Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and oversee the construction of infrastructure such as roads, bridges, and buildings.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n8. Structural Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and analyze the structural integrity of buildings and other structures.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n9. Mechanical Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and oversee the installation of mechanical systems, such as HVAC and plumbing.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n10. Electrical Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and oversee the installation of electrical systems, including power, '
                          'lighting, and telecommunications.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n11. Plumbing Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and oversee the installation of plumbing systems, including water supply and drainage.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n12. HVAC Engineers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and oversee the installation of heating, ventilation, and air conditioning systems.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n13. Project Managers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nOversee and coordinate the overall construction project, ensuring it is '
                          'completed on time and within budget.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n14. Construction Managers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nManage the day-to-day operations and logistics of the construction site.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n15. Site Supervisors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nMonitor and oversee the work of construction crews on the job site.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n16. Quantity Surveyors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nEstimate and manage the costs of construction materials and labor.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n17. Concrete Workers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nMix, pour, and finish concrete for the foundation, floors, and other structural elements.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n18. Masons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nBuild and install brick, stone, and concrete structures, such as walls and chimneys.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n19. Stucco Masons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nApply stucco, a type of plaster, to exterior walls, creating a durable and decorative finish.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n20. Bricklayers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nSpecialize in laying and installing bricks for walls, chimneys, and other structures.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n21. Carpenters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nBuild and install wooden structures, such as framing, floors, and roofs.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n22. Steel Fabricators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nManufacture and assemble steel components for the structure of building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n23. Steel Erectors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and assemble the steel components to form the structure of building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n24. Roofers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and repair the roof of the building, including shingles, tiles, or other roofing materials.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n25. Glaziers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and repair the windows, doors, and other glass components of the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n26. Window Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nSpecialize in the installation of windows, ensuring they are properly sealed and functioning.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n27. Door Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and fit doors, including exterior and interior doors, to the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n28. Drywall Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and finish the drywall panels that make up the interior walls and ceilings.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n29. Tile Setters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall ceramic, stone, or other types of tiles on floors, walls, and countertops.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n30. Flooring Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and finish various types of flooring, such as hardwood, laminate, or carpet.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n31. Painters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nApply paint, stain, or other finishes to the interior and exterior surfaces of the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n32. Decorators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and install decorative elements, such as moldings, trims, and specialty finishes.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n33. Locksmith',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall or repair locks and access control systems.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n34. Landscapers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and install the landscaping elements, such as '
                          'gardens, lawns, and outdoor features.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n35. Landscaping Workers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the landscaping elements, such as plants, trees, and grass.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n36. Elevator Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the elevators in the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n37. Insulation Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall insulation materials to improve the energy efficiency of the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n38. Waterproofing Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nApply waterproofing materials to protect the building from water damage.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n39. Facade Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall the exterior facade, such as cladding, stone, or other decorative elements.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n40. Signage Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall the exterior and interior signage for the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n41. Security System Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the security systems, including alarms and access control.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n42. IT/Telecommunications Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the IT and telecommunications infrastructure, including cables and equipment.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n43. Kitchen Equipment Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the kitchen equipment, such as appliances, countertops, and cabinets.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n44. Bathroom Fixture Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the bathroom fixtures, such as toilets, sinks, and showers.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n45. Interior Designers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nDesign the interior layout, finishes, and furnishings of the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n46. Lighting Designers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and specify the lighting systems for the building, ensuring optimal illumination.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n47. Acoustics Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and install acoustic treatments to improve the sound quality and reduce noise in the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n48. Fire Protection Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the fire protection systems, such as sprinklers and alarms.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n49. Waste Management Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and implement the waste management systems for the building, including recycling and disposal.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n50. Crane Operators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nOperate cranes to lift and move heavy materials and equipment on the construction site.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n51. Heavy Equipment Operators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nOperate heavy machinery, such as bulldozers and excavators, to move earth and materials.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n52. Welders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nJoin metal components together using welding techniques to create the structure of building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n53. Ironworkers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and assemble the steel reinforcement for concrete structures and the frame of building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n54. Plasterers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nApply plaster to walls and ceilings, creating a smooth surface for painting or other finishes.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n55. Asphalt Workers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the asphalt surfaces, such as parking lots and driveways.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),


                    TextSpan(
                      text: '\n\n56. Horticulturists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProvide expertise in the selection, planting, and care of plants and vegetation.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n57. Gardener',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nCare for and maintain the landscaping and gardens around the property.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n58. Irrigation Technicians',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the irrigation systems for the landscaping.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n59. Pest Control Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProvide pest control services to protect the building and '
                          'its occupants from insects and rodents.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n60. Solar Panel Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the solar panel infrastructure.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n61. Escalator Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and maintain the escalators in the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n62. Facade Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign, fabricate, and install the exterior facade of the building, ensuring it meets aesthetic and performance requirements.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n63. Facade Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall the exterior facade, such as cladding, stone, or other decorative elements.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n64. Facade Building Cleaner',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nSpecialize in cleaning and maintaining the exterior facade of the building.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n65. Well Drainer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDrain and maintain the well system to ensure proper water supply and quality.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n66. Cleaning Crew',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProvide regular cleaning and janitorial services to maintain the cleanliness and appearance of the property.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n67. Property Guards',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProvide security and surveillance services to protect the property and its occupants.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n68. Smart Home Technicians',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure smart home devices, such as thermostats, lighting systems, and security cameras.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n69. Home Automation Specialists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and implement home automation systems, integrating various devices and appliances.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n70. Smart Security Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure smart security systems, including cameras, alarms, and access control devices.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n71. Smart Lighting Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure smart lighting systems, including LED lights and smart bulbs.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n72. Smart Thermostat Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure smart thermostats to control heating and cooling systems.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n73. Smart Appliance Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure smart appliances, such as smart refrigerators and smart washing machines.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n74. Smart Home Network Installers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nInstall and configure home networks, including routers and network devices.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n75. Smart Home Maintenance Technicians',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nPerform routine maintenance and troubleshooting for smart home systems.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n76. Smart Home Integrators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nIntegrate various smart devices and systems to create a cohesive smart home ecosystem.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n77. Smart Home Designers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nDesign and plan smart home systems, including layout and device selection.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n78. Economists',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nAnalyze and forecast real estate market trends.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n79. Lawyers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nAssist with property transactions, contracts, and disputes.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n80. Accountants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nManage the financial aspects of property transactions and development.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),

                    TextSpan(
                      text: '\n\n81. Market Researchers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nStudy and report on real estate market conditions and trends.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n82. Investment Consultants',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,

                      ),
                    ),
                    TextSpan(
                      text: '\nProvide expert advice on real estate development and investment.',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n83. Insurance Brokers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.pink, fontSize: titleFontSize,
                      ),
                    ),
                    TextSpan(
                      text: '\nProvide insurance coverage for properties and property buyers.\n\n\n',
                      style: TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Add more content here
        ],
      ),
    );
  }
}

// References
class DraggableScrollableContentReferences extends StatelessWidget {
  final ScrollController scrollController;

  const DraggableScrollableContentReferences({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {

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
    final textFontSize = isIpad ? fontSizePad : fontSizePhone;
    final titleFontSize = isIpad ? titleFontSizePad : titleFontSizePhone;
    final iconSizeLarge = isIpad ? iconSizeLargePad : iconSizeLargePhone;
    final iconSizeSmall = isIpad ? iconSizeSmallPad : iconSizeSmallPhone;
    final double spacingHeight = isIpad ? 16.0 : 10.0;



    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(8.0),
      children: [
        Container(
          color: Colors.grey[100],
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                          text: '\n',
                          style: TextStyle(
                            fontSize: textFontSize,
                            fontWeight: FontWeight.bold,  color: Colors.blue,
                          ),
                        ),

                        TextSpan(
                          text: 'References\n',
                          style: TextStyle(
                            fontSize: textFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                     /*   TextSpan(
                          text: '\n\nLuxury Real Estate Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.knightfrank.com/research');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHigh-End Residential Market Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.savills.com/impacts/market-trends/prime-residential-property.aspx');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nGlobal Luxury Housing Demand Drivers',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.christiesrealestate.com/eng/luxury-market-reports');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/


                        TextSpan(
                          text: '\n\nSmall Property Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics/small-homes');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nCompact Housing Demand Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.urban.org/urban-wire/rising-demand-small-homes-what-does-mean-cities');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nNew Construction Market Dynamics',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nahb.org/news-and-economics/housing-economics/new-home-market');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                       /* TextSpan(
                          text: '\n\nSustainable Housing Policies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.oecd.org/environment/tools-evaluation/green-housing-policies.htm');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/


                        TextSpan(
                          text: '\n\nUsed Housing Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics/existing-home-sales');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        /*TextSpan(
                          text: '\n\nPricing Dynamics of Pre-Owned Homes',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.corelogic.com/intelligence/used-home-price-index/');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                        TextSpan(
                          text: '\n\nPolicy Tools for Housing Market Stability',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.oecd.org/housing/policy-tools/');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),



                        TextSpan(
                          text: '\n\nOwner-Occupied Housing Market\n\n',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index.aspx');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nInvestment Property Market Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nareit.com/research-and-statistics/research-reports');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                       /* TextSpan(
                          text: '\n\nRental Housing Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.jchs.harvard.edu/state-nations-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                        TextSpan(
                          text: '\n\nHousing Market Stability Policies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.huduser.gov/portal/periodicals/ushmc.html');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),

/*
                        TextSpan(
                          text: '\n\nReal Estate Speculation Impacts',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.imf.org/en/Publications/WP/Issues/2021/07/16/Housing-Markets-and-Structural-Policies-in-Advanced-Economies-462231');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nAnti-Speculation Housing Policies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.oecd.org/housing/tackling-housing-unaffordability.htm');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nGovernment Housing Programs',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.hud.gov/program_offices/public_indian_housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nAffordable Housing Strategies\n',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.worldbank.org/en/topic/urbandevelopment/brief/affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),


                        TextSpan(
                          text: '\n\nLuxury Real Estate Market Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.christiesrealestate.com/eng/luxury-market-reports');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nAffordable Housing Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.jchs.harvard.edu/state-nations-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHousing Market Segmentation',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                       /* TextSpan(
                          text: '\n\nHousing Affordability Policies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.oecd.org/housing/policy-tools/');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/


                        TextSpan(
                          text: '\n\nHigh-Density Housing Development',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.urban.org/urban-wire/benefits-high-density-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                      /*  TextSpan(
                          text: '\n\nAffordable High-Density Solutions',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.huduser.gov/portal/periodicals/em/fall18/highlight2.html');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                        TextSpan(
                          text: '\n\nSingle-Family Home Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics/single-family-home-sales');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nUrban Sprawl and Housing Policy',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.epa.gov/smartgrowth/smart-growth-and-affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),


                     /*   TextSpan(
                          text: '\n\nLuxury Housing Supply Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.savills.com/impacts/market-trends/prime-residential-property.aspx');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nMid-Size Housing Market Dynamics',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics/condominium-and-cooperative-sales');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nAffordable Small Housing Supply',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.jchs.harvard.edu/research-areas/affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHousing Supply Policy Tools',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.oecd.org/housing/policy-tools/');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
*/

                        /*TextSpan(
                          text: '\n\nNew Construction Housing Supply',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nahb.org/news-and-economics/housing-economics/new-home-market');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                        TextSpan(
                          text: '\n\nExisting Home Market Analysis',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.nar.realtor/research-and-statistics/housing-statistics/existing-home-sales');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHousing Quality Standards',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.hud.gov/program_offices/public_indian_housing/reac/products/prodguide');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHousing Redevelopment Strategies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.epa.gov/smartgrowth/smart-growth-and-affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),


                   /*     TextSpan(
                          text: '\n\nGovernment Housing Programs',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.hud.gov/program_offices/public_indian_housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nAffordable Housing Strategies',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.worldbank.org/en/topic/urbandevelopment/brief/affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nHigh-Density Development',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.urban.org/urban-wire/benefits-high-density-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nLow-Density Housing Impacts',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.epa.gov/smartgrowth/smart-growth-and-affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),


                        TextSpan(
                          text: '\n\nLuxury Housing Market Trends',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.christiesrealestate.com/eng/luxury-market-reports');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),*/
                        TextSpan(
                          text: '\n\nAffordable Housing Development',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.worldbank.org/en/topic/urbandevelopment/brief/affordable-housing');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nTransferable Development Rights',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.epa.gov/smartgrowth/transfer-development-rights');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: '\n\nBlockchain in Real Estate\n\n\n\n',
                          style:  TextStyle(
                            fontSize: textFontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse('https://www.mckinsey.com/industries/financial-services/our-insights/blockchain-in-real-estate-dawn-of-a-new-era');
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to open link')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                        ),

                      ]
                  )
              )
          ),
        ),
        // Add more content here
      ],
    );
  }
}