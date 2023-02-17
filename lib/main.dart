//Packages import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

//Start Application
void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp((MaterialApp(home: MyApp())));
}

//Setting language
const languages = const [
  const Language('Arabic', 'ar_AR'),
];
class Language {
  final String name;
  final String code;
  const Language(this.name, this.code);
}

//State create
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  final formkey = GlobalKey<FormState>();

  TextEditingController goal1 = new TextEditingController();
  TextEditingController goal2 = new TextEditingController();
  TextEditingController goal3 = new TextEditingController();

  String transcription = '';

  int goalcount1 = 0;
  int goalcount2 = 0;
  int goalcount3 = 0;

  int count1 = 0;
  int count2 = 0;
  int count3 = 0;

  int listcount1 = 0;
  int listcount2 = 0;
  int listcount3 = 0;

  Language selectedLang = Language('Arabic', 'ar_AR');

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  //Widget Builder
  Widget _buildButton({required String label, VoidCallback? onPressed, required Color cl}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: cl.withOpacity(0.8),
        disabledColor: cl.withOpacity(0.5),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  Widget _stopButton({required String label, VoidCallback? onPressed, required Color cl}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    goal1.text = '0';
    goal2.text = '0';
    goal3.text = '0';
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.greenAccent.withOpacity(0.5),
          title: Center(child: Text('Qul Tasbih')),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.withOpacity(0.5)),
                onPressed: (){
                  setState(() {
                    count1 = 0;
                    count2 = 0;
                    count3 = 0;
                    listcount1 = 0;
                    listcount2 = 0;
                    listcount3 = 0;
                    goalcount1 = 0;
                    goalcount2 = 0;
                    goalcount3 = 0;
                    transcription = "";
                  });
                },
                child: Icon(Icons.refresh)
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 100,),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.grey.shade200.withOpacity(0.5),
                              child: Text(transcription))),
                      _buildButton(
                        onPressed: _speechRecognitionAvailable && !_isListening
                            ? () => start()
                            : null,
                        label: _isListening
                            ? 'Listening...'
                            : 'Start Zikr',
                        cl: Colors.green
                      ),
                      _stopButton(
                        onPressed: _isListening ? () => stop() : null,
                        label: 'Stop',
                          cl: Colors.red
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              label: 'Subhanallah : $count1',
                                cl: Colors.green,
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Current Goal :" + goalcount1.toString()),
                                      content: TextFormField(
                                        onTap: () {
                                          goal1.text = '0';
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Goal Counts',
                                          hintText: "30",
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                        controller: goal1,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter goal';
                                          }
                                          return null;
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              goalcount1 = int.parse(goal1.text);
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Confirm"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.yellow.withOpacity(0.5)),
                                    onPressed: null,
                                    child: Text(listcount1.toString()),
                                )
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  count1 = 0;
                                  listcount1 = 0;
                                });
                              },
                              child: Icon(Icons.refresh)
                            )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              label: 'Alhamdulillah : $count2',
                                cl: Colors.green,
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Current Goal :" + goalcount2.toString()),
                                      content: TextFormField(
                                        onTap: () {
                                          goal2.text = '0';
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Counts',
                                          hintText: "30",
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                        controller: goal2,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter goal';
                                          }
                                          return null;
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              goalcount2 = int.parse(goal2.text);
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Confirm"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.yellow.withOpacity(0.5)),
                                  onPressed: null,

                                  child: Text(listcount2.toString()),
                                )
                            ),
                          ),
                          Container(
                              child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      count2 = 0;
                                      listcount2 = 0;
                                    });
                                  },
                                  child: Icon(Icons.refresh)
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              label: 'Allahuakbar : $count3',
                              cl: Colors.green,
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Current Goal :" + goalcount3.toString()),
                                      content: TextFormField(
                                        onTap: () {
                                          goal3.text = '0';
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Counts',
                                          hintText: "30",
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                        controller: goal3,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter goal';
                                          }
                                          return null;
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              goalcount3 = int.parse(goal3.text);
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Confirm"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.yellow.withOpacity(0.5)),
                                  onPressed: null,
                                  child: Text(listcount3.toString()),
                                )
                            ),
                          ),
                          Container(
                              child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      count3 = 0;
                                      listcount3 = 0;
                                    });
                                  },
                                  child: Icon(Icons.refresh)
                              )
                          ),
                        ],
                      ),
                    ],

                  ),
                ),
              )),
        ),
      ),
    );
  }

  //All Functions

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  void activateSpeechRecognizer() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('ar_AR').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
    return _speech.listen().then((result) {
      setState(() {
        _isListening = result;
      });
    });
  });

  void stop() => _speech.stop().then((_) {
    setState(() {
      _isListening = false;
    });
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  //process of breaking voice into words for counting
  void onRecognitionResult(String text) {

    setState(() => transcription = text);
    final List s = text.split('سبحان الله');
    final List al = text.split('الحمد لله');
    final List aa = text.split('الله اكبر');

    setState(() => count1 = s.length-1);
    setState(() => count2 = al.length-1);
    setState(() => count3 = aa.length-1);

    if(listcount1 + count1 == goalcount1 && goalcount1 != 0){
      _speech.cancel();
      _isListening = false;
      Vibrate.vibrate();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Goal Achieved"),
          content: Text("Goal: "+ goalcount1.toString() +" for Zikr Subhanallah has achieved"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goalcount1 = 0;
                Navigator.of(ctx).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
    if(listcount2 + count2 == goalcount2 && goalcount2 != 0){
      _speech.cancel();
      _isListening = false;
      Vibrate.vibrate();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Goal Achieved"),
          content: Text("Goal: "+ goalcount2.toString() +" for Zikr Alhamdulillah has achieved"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goalcount2 = 0;
                Navigator.of(ctx).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
    if(listcount3 + count3 == goalcount3 && goalcount3 != 0){
      _speech.cancel();
      _isListening = false;
      Vibrate.vibrate();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Goal Achieved"),
          content: Text("Goal: "+ goalcount3.toString() +" for Zikr Allahuakbar has achieved"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goalcount3 = 0;
                Navigator.of(ctx).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }

    if(_isListening == false){
      listcount1 = listcount1 + count1;
      listcount2 = listcount2 + count2;
      listcount3 = listcount3 + count3;
    }
  }

  void onRecognitionComplete(String text) {
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}