import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double currentPolarity = 0.0;
  var currentSentence = '';
  var errorStatus = '';

//function to get polarity of the sentence
  Future getPolarity(data) async {
    final String restAPI = 'http://192.168.0.2:4652/textblob';
    final response = await http.post(Uri.parse(restAPI),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"data": "$currentSentence"}));

    var jsonData;
    var polarity;

    print(polarity);
    setState(() {
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        polarity = jsonData['polarity'];
        currentPolarity = double.parse(polarity);
        errorStatus = '';
      } else {
        currentPolarity = 0.0;
        errorStatus =
            "Error Code: ${response.statusCode}, Bahut tej ho rahe ho";
        print(errorStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.varelaTextTheme(
            Theme.of(context).textTheme,
          )),
      home: Scaffold(
        //backgroundColor: Colors.green[50],

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Center(
                  child: SfRadialGauge(
                enableLoadingAnimation: true,
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: -1,
                    maximum: 1,
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: currentPolarity,
                        needleLength: 0.5,
                        enableAnimation: true,
                        knobStyle: KnobStyle(
                          borderColor: Colors.black,
                          borderWidth: 0.02,
                          knobRadius: 0.06,
                          // color: Colors.white,
                        ),
                      ),
                    ],
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: -1,
                        endValue: -0.8,
                        color: Colors.red[900],
                      ),
                      GaugeRange(
                        startValue: -0.8,
                        endValue: -0.6,
                        color: Colors.red[700],
                      ),
                      GaugeRange(
                        startValue: -0.6,
                        endValue: -0.4,
                        color: Colors.red[500],
                      ),
                      GaugeRange(
                        startValue: -0.4,
                        endValue: -0.2,
                        color: Colors.red[400],
                      ),
                      GaugeRange(
                        startValue: -0.2,
                        endValue: -0.1,
                        color: Colors.red[300],
                      ),
                      GaugeRange(
                        startValue: -0.1,
                        endValue: 0.1,
                        color: Colors.orange,
                      ),
                      GaugeRange(
                        startValue: 0.1,
                        endValue: 0.2,
                        color: Colors.green[300],
                      ),
                      GaugeRange(
                        startValue: 0.2,
                        endValue: 0.4,
                        color: Colors.green[400],
                      ),
                      GaugeRange(
                        startValue: 0.4,
                        endValue: 0.6,
                        color: Colors.green[500],
                      ),
                      GaugeRange(
                        startValue: 0.6,
                        endValue: 0.8,
                        color: Colors.green[700],
                      ),
                      GaugeRange(
                        startValue: 0.8,
                        endValue: 1,
                        color: Colors.green[900],
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        //current value
                        widget: Text(
                          "$currentPolarity",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        positionFactor: 0.3,
                        angle: 90,
                      ),
                      GaugeAnnotation(
                        //positive side
                        widget: Text(
                          "Positive",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                        positionFactor: 0.6,
                      ),
                      GaugeAnnotation(
                        //negative side
                        widget: Text(
                          "Negative",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        positionFactor: 0.6,
                        angle: 180,
                      ),
                      GaugeAnnotation(
                        //neutral side
                        widget: Text(
                          "Neutral",
                          style: TextStyle(fontSize: 18, color: Colors.orange),
                        ),
                        positionFactor: 0.73,
                        angle: 270,
                      ),
                    ],
                  )
                ],
              )),
              //textfield below
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      currentSentence = val;
                    });
                  },
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: "Enter your sentence/paragraph here",
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //submit button below
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () async {
                    if (currentSentence != '') {
                      print(currentSentence);
                      await getPolarity(currentSentence);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 42,
                    child: Center(
                        child: Text(
                      "Check Polarity",
                      style: TextStyle(fontSize: 18),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              errorStatus == ''
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "$errorStatus",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
