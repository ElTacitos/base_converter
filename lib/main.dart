// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}


class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  var optList = ["0","0","0","0"];
  var basesList = [16,10,8,2];
  var actList = [false,true,false,false];

  Color actCol = Color.fromARGB(255, 190, 190, 190);
  Color deactCol = Color.fromARGB(255, 200, 200, 200);
  Color bgCol = Color.fromARGB(255, 200, 200, 200);
  Color actDigitBtCol = Color.fromARGB(255, 255, 190, 0);
  Color deactDigitBtCol = Color.fromARGB(255, 240, 175, 0);
  Color optBtCol = Colors.blueGrey;

  double deactFontSize = 33.0;
  double actFontSize = 35.0;
  int actBase = 1;
  String testTxt = "test";

  testFn(){
    setState(() {
      testTxt = "zbouib";
    });
  }


  convert(String inp, int act){
    if(act == 0){ //hex to other
      int nb = int.parse(inp,radix: basesList[act]);
      optList[1] = nb.toString();
      optList[2] = nb.toRadixString(basesList[2]);
      optList[3] = nb.toRadixString(basesList[3]);
    }else if(act == 1){ //dec to other
      int nb = int.parse(inp);
      optList[0] = nb.toRadixString(basesList[0]).toUpperCase();
      optList[2] = nb.toRadixString(basesList[2]);
      optList[3] = nb.toRadixString(basesList[3]);
    }else if(act == 2){ //oct to other
      int nb = int.parse(inp,radix: basesList[act]);
      optList[0] = nb.toRadixString(basesList[0]).toUpperCase();
      optList[1] = nb.toString();
      optList[3] = nb.toRadixString(basesList[3]);
    }else if(act == 3){ //bin to other
      int nb = int.parse(inp,radix: basesList[act]);
      optList[0] = nb.toRadixString(basesList[0]).toUpperCase();
      optList[1] = nb.toString();
      optList[2] = nb.toRadixString(basesList[2]);
    }
  }

  baseChange(int newBase){
    setState(() {
      actList[actBase] = false;
      actList[newBase] = true;
      actBase = newBase;
    });
  }


  buttonPressed(String btTxt){
    setState(() {
      if(btTxt == "c"){
        optList[actBase] = "0";
      }else if(btTxt == "⌫"){
        optList[actBase] = optList[actBase].substring(0, optList[actBase] .length-1);
        if(optList[actBase] == ""){
          optList[actBase] = "0";
        }
      }else{
        optList[actBase] = (optList[actBase] == "0") ? btTxt : optList[actBase] +btTxt;
      }
      convert(optList[actBase],actBase);
    });
  }

  Widget digitDisp(int base, String baseTxt){
    return Container(
            margin: (base == 0) ? EdgeInsets.fromLTRB(0, 20, 0, 0) : EdgeInsets.zero,
            //alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            color: (actList[base]) ? actCol : deactCol, //SET COLOR ACORDING TO ACTIVATION
            
              child: Row(
                children: [
                  FlatButton(
                  onPressed: () => baseChange(base), 
                  child: Expanded(
                    flex: 2,
                    child: Container(
                      child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(baseTxt,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ),
                    ),
                  ),
                  ),
                 Expanded(
                    flex: 8,
                    child:  FlatButton(
                      onPressed: () => (actList[base]) ? Clipboard.setData(ClipboardData(text: optList[base])) : baseChange(base), 
                      child:  Align(
                      alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(optList[base],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: (actList[base]) ? actFontSize : deactFontSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  
                ],
              )  
          );
  }

  Widget wipButton(double btHeight){
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * btHeight,
      color: Colors.blueGrey,
      child: FlatButton(
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            color: bgCol,
            width: 2, 
            style: BorderStyle.solid
          )
        ),
        padding: EdgeInsets.all(2.0),
        onPressed: null, 
        child: Text(
          "WIP",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      )
    );
  }

  Widget buildButton(String btTxt, double btHeight, Color actBtCol, Color deactBtCol, bool active){

    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * btHeight,
      color: (active) ? actBtCol : deactBtCol,
      child: FlatButton(
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            color: bgCol,
            width: 2, 
            style: BorderStyle.solid
          )
        ),
        padding: EdgeInsets.all(2.0),
        onPressed: (active) ? () => buttonPressed(btTxt): null, 
        child: Text(
          btTxt,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCol,
      body: Column(
        children: <Widget>[

          digitDisp(0, "HEX"),
          digitDisp(1, "DEC"),
          digitDisp(2, "OCT"),
          digitDisp(3, "BIN"),

          Expanded(
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("E", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        buildButton("F", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        wipButton(1),
                        wipButton(1),
                      ]
                    ),

                    TableRow(
                      children: [
                        buildButton("D", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        buildButton("7", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                        buildButton("8", 1, actDigitBtCol, deactDigitBtCol, actBase <= 1),
                        buildButton("9", 1, actDigitBtCol, deactDigitBtCol, actBase <= 1),
                      ]
                    ),

                    TableRow(
                      children: [
                        buildButton("C", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        buildButton("6", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                        buildButton("5", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                        buildButton("4", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                      ]
                    ),

                    TableRow(
                      children: [
                        buildButton("B", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        buildButton("1", 1, actDigitBtCol, deactDigitBtCol, actBase <= 3),
                        buildButton("2", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                        buildButton("3", 1, actDigitBtCol, deactDigitBtCol, actBase <= 2),
                      ]
                    ),

                    TableRow(
                      children: [
                        buildButton("A", 1, actDigitBtCol, deactDigitBtCol, actBase <= 0),
                        buildButton("c", 1, optBtCol, deactDigitBtCol, true),
                        buildButton("0", 1, actDigitBtCol, deactDigitBtCol, actBase <= 3),
                        buildButton("⌫", 1, optBtCol, deactDigitBtCol, true),
                      ]
                    ),
                  ],
                ),
              ),
              
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                      TableRow(
                        children: [
                          wipButton(1),
                        ]
                      ),

                      TableRow(
                        children: [
                          wipButton(1),
                        ]
                      ),

                      TableRow(
                        children: [
                          wipButton(1),
                        ]
                      ),

                      TableRow(
                        children: [
                          wipButton(2),
                        ]
                      ),
                    ],
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}