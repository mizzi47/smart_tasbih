import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

const languages = const [
  const Language('Arabic', 'ar_AR'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';
  int listcount1 = 0;
  int listcount2 = 0;
  int listcount3 = 0;

  int count1 = 0;
  int count2 = 0;
  int count3 = 0;

  //String _currentLocale = 'en_US';
  Language selectedLang = Language('Arabic', 'ar_AR');

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
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

  @override
  Widget build(BuildContext context) {
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
                    transcription = "";
                    listcount3 = 0;
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
                    // _buildButton(
                    //   onPressed: _isListening ? () => cancel() : null,
                    //   label: 'Cancel',
                    // ),
                    _stopButton(
                      onPressed: _isListening ? () => stop() : null,
                      label: 'Stop',
                        cl: Colors.red
                    ),
                    //checking and counted zikr label
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            label: 'Subhanallah : $count1',
                              cl: Colors.greenAccent
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                count1 = 0;
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
                              cl: Colors.greenAccent
                          ),
                        ),
                        Container(
                            child: ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    count2 = 0;
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
                            cl: Colors.greenAccent
                          ),
                        ),
                        Container(
                            child: ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    count3 = 0;
                                  });
                                },
                                child: Icon(Icons.refresh)
                            )
                        ),
                      ],
                    ),
                  ],

                ),
              )),
        ),
      ),
    );
  }

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

  Widget _buildButton({required String label, VoidCallback? onPressed, required Color cl}) => Padding(
      padding: EdgeInsets.all(12.0),
      child: MaterialButton(
        onPressed: onPressed,
        color: cl,
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

  void start() => _speech.activate(selectedLang.code).then((_) {
    return _speech.listen().then((result) {
      print('_MyAppState.start => result $result');
      setState(() {
        _isListening = result;
        print(result);
      });
    });
  });

  // void cancel() =>
  //     _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
    setState(() {
      _isListening = false;
    });
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  //process of breaking voice into words for counting
  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
    final List s = text.split('سبحان الله');
    final List al = text.split('الحمد لله');
    final List aa = text.split('الله اكبر');
    setState(() => count1 = s.length-1);
    setState(() => count2 = al.length-1);
    setState(() => count3 = aa.length-1);
    if(_isListening == false){
      listcount3 += count3;
    }
    print(listcount3);
  }

  void onRecognitionComplete(String text) {
    // print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}