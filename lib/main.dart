import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kksa/CustomMap.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'CustomDialogWithoutButton.dart';
import 'avoidKeyboard.dart';
import 'colors.dart';

void main(){

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: otherMessageBackground.withOpacity(0.50),
      )
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales,

      theme: ThemeData(
        accentColor: otherMessageBackground,
        cursorColor: otherMessageBackground,
        textSelectionColor: otherMessageBackground,
        textSelectionHandleColor: otherMessageBackground,
        fontFamily: 'Tajawal-Regular',
      ),

      debugShowCheckedModeBanner: false,
      home:  splashPage(),
    );
  }
}


class splashPage extends StatefulWidget {
  @override
  _splashPageState createState() => _splashPageState();
}

class _splashPageState extends State<splashPage> {

  bool visibleSplash = false;

  @override
  void initState() {

    super.initState();


    Future.delayed(
        Duration(milliseconds: 800),
            (){
          setState(() {
            visibleSplash = true;
          });

          Future.delayed(
              Duration(seconds: 3),
                  (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SlideShow()
                  ),
                );
              }
          );

        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: otherMessageBackground
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: visibleSplash ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Image.asset(
                    "assets/malak_logo.png",
                    fit: BoxFit.cover,
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideShow extends StatefulWidget {
  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {

  void initState(){
    super.initState();
  }


  List<String> photos = [
    'assets/screen1-2.png',
    'assets/screen2.png',
    'assets/screen3.png',
  ];

  PageController controller = PageController();

  int currentPageValue = 0; //This variable is changed when page is changed, currentPageValue == index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            PageView.builder(
              controller: controller,
              itemCount: photos.length,
              itemBuilder: (context, index) {

                // This method to save index of the page out of this method, to use the index in page counter in bottom.
                controller.addListener(() {
                  setState(() {
                    currentPageValue = (controller.page).round(); // round() is used to convert to int from double
                  });
                });


                return Scaffold(
                  floatingActionButton: index == 2 ? FloatingActionButton(
                    backgroundColor: white,
                    child: Text(
                      "ابدأ",
                      style: TextStyle(
                          fontSize: 25,
                          color: otherMessageBackground
                      ),
                    ),
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePageDialogflow()
                        ),
                      );
                    },
                  )
                      :
                  Container(),
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            photos[index],
                            fit: BoxFit.cover,
                          ),
                        ],
                      )
                  ),
                );
              },
            ),


            // To let this widget not moved or changed when background is changed
            Positioned(
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SelectedPhoto(
                                numberOfDots: photos.length,
                                photoIndex: currentPageValue,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )
          ],
        )
    );
  }


}

//color: position % 2 == 0 ? Colors.pink : Colors.cyan,

class SelectedPhoto extends StatelessWidget {

  int numberOfDots;
  int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget inactivePhoto(){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.50),
              borderRadius: BorderRadius.circular(4.0)
          ),
        ),
      ),
    );
  }

  Widget activePhoto(){
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0.0,
                    blurRadius: 2.0
                )
              ]
          ),
        ),
      ),
    );
  }

  List<Widget> buildDots(){
    List<Widget> dots = [];

    for(int i=0; i< numberOfDots; ++i){
      dots.add(
          i == photoIndex ? activePhoto():inactivePhoto()
      );
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildDots(),
      ),
    );
  }
}

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({
    Key key,
    this.title
  }) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() =>  _HomePageDialogflow();
}

class _HomePageDialogflow extends State<HomePageDialogflow> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController =  TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  bool _hasSpeech = false;
  double level = 0.0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  bool visibleLoadingIcon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _switchLang("ar_SA");

    initSpeechState();
  }

  void Response(query) async {
    _textController.clear();

    setState(() {
      visibleLoadingIcon = true;
    });

    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);

    ChatMessage message =  ChatMessage(
      text: response.getMessage() ?? CardDialogflow(response.getListMessage()[0]).title,
      name: "الرد الالي",
      type: false,
      animationController: AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 400)
      ),
    );

    setState(() {
      _messages.insert(0, message);
      visibleLoadingIcon = false;
    });

    message.animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
  }

  void _handleSubmitted(String text) {

    _textController.clear();

    ChatMessage message =  ChatMessage(
      text: text,
      name: "Promise",
      type: true,
      animationController: AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 400)
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

    Response(text);

  }

  void startListening() {
      initSpeechState();
      lastWords = "";
      lastError = "";
      speech.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 10),
          localeId: _currentLocaleId,
          onSoundLevelChange: soundLevelListener,
          cancelOnError: true,
          partialResults: true);

      setState(() {});
  }

  void stopListening() {
    speech.stop();

    if(_textController.text.isNotEmpty){
      _handleSubmitted(_textController.text);
    }

    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      _textController.text = lastWords;
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  void ErrorSending(String text){
    scaffoldkey.currentState.hideCurrentSnackBar();

    scaffoldkey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
            backgroundColor: otherMessageBackground,
            content: Row(
              children: <Widget>[
                Text(
                  text,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Tajawal-Regular"
                  ),
                ),
              ],
            )
        )
    );
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: otherMessageBackground,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(width: 10,),

            Container(
              height: 40,
              child: Image.asset(
                "assets/malak_logo2.png",
              ),
            ),

          ],
        )
      ),
      body: Container(
        color: backgroundGray,
        child: Column(
            children: <Widget>[

              // Content of chat
              Flexible(
                  child:  ListView.builder(
                    padding:  EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  )
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: visibleLoadingIcon ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SpinKitThreeBounce(
                        color: otherMessageBackground,
                        size: 20.0,
                        controller: AnimationController(
                            vsync: this,
                            duration: const Duration(
                                milliseconds: 1200
                            )
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              // Input bar
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Container(
                    child: Row(
                      children: <Widget>[

                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5.5,
                                  color: Colors.black.withOpacity(0.10),
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context).size.height * 0.15
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Scrollbar(
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  reverse: true,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextField(
                                                      controller: _textController,
                                                      textInputAction: TextInputAction.newline,
                                                      maxLines: null,
                                                      decoration: InputDecoration(
                                                        hintText: "اكتب سؤالك ..",
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: (){
                                      return showDialog(
                                        context: context,
                                        builder: (_){
                                          return KeyboardAvoiding(
                                            child: Container(
                                              child: CustomDialogWithoutButton(
                                                  width: MediaQuery.of(context).size.width * 0.90,
                                                  borderRadius: 15,
                                                  backgroundColor: Colors.white,
                                                  headerText: "تحديد موقعك",
                                                  content: CustomMap()
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          )
                        ),

                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: otherMessageBackground,
                                border: Border.all(
                                    color: Colors.black12
                                ),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 5.0,
                                    color: buttonColor.withOpacity(0.30))
                              ],
                            ),
                            child: GestureDetector(
                              child: Icon(
                                Icons.mic,
                                size: 30,
                                color: white,
                              ),
                              onLongPress: !_hasSpeech || speech.isListening ? null : startListening,
                              onLongPressUp: speech.isListening ? stopListening : null,
                              onTap: (){
                                print("ad");
                              },
                            )
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: otherMessageBackground,
                                border: Border.all(
                                    color: Colors.black12
                                )
                            ),
                            child:  IconButton(
                                color: backgroundGray,
                                icon:  Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                  color: white,
                                ),
                                onPressed: (){
                                  if(_textController.text.replaceAll('\n', '').isNotEmpty){
                                    _handleSubmitted(_textController.text);
                                  }else{
                                    ErrorSending("لا يمكن ارسال رساله فارغه");
                                  }
                                }
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({
    this.text,
    this.name,
    this.type,
    this.animationController
  });

  final String text;
  final String name;
  final bool type;
  final AnimationController animationController;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            ConstrainedBox(
              constraints: new BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: otherMessageBackground,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30)
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.10),
                      offset: Offset(3.5, 4.0),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  text,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: otherTextColor,
                      fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
       Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            ConstrainedBox(
              constraints: new BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: myBackgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(5)
                    ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.10),
                      offset: Offset(3.5, 4.0),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child:  Text(
                  text,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: myTextColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInToLinear
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this.type ? myMessage(context) : otherMessage(context),
        ),
      ),
    );
  }
}