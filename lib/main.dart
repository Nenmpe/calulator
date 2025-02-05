import 'package:flutter/material.dart';
import 'numpad_btns.dart';

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  TextEditingController displayController = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Calculator", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Text output field
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: TextField(
                      controller: displayController,
                      readOnly: true,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
          
              //Numpad buttons field
              Wrap(
                children: Btn.buttonValues.map(
                    (value)=>SizedBox(
                        width: screenSize.width/5,
                        height: screenSize.height/7,
                        child: buildNumpad(value)),
                ).toList(),
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget buildNumpad(value){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100)
        ),
        child: InkWell(
          onTap: (){
            onButtonPressed(value);
          },
            child: Center(
                child: Text(value, style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24
                ),)
            )
        ),
      ),
    );
  }

  Color getBtnColor(value){
    return [Btn.del,Btn.clr].contains(value)?
    Colors.red:[Btn.add,
      Btn.divide,
      Btn.multiply,
      Btn.subtract,
      Btn.per,
      Btn.negative,
      Btn.calculate].contains(value)?Colors.orange:Colors.white;
  }

  void onButtonPressed(String value) {
    setState(() {
      if (value == Btn.clr) {
        displayController.text = "0";
        number1 = "";
        operand = "";
        number2 = "";
      } else if (value == Btn.del) {
        if (displayController.text.isNotEmpty) {
          displayController.text =
              displayController.text.substring(0, displayController.text.length - 1);
          if (displayController.text.isEmpty) {
            displayController.text = "0";
          }
        }
      } else if ([Btn.add, Btn.subtract, Btn.multiply, Btn.divide].contains(value)) {
        if (number1.isEmpty) {
          number1 = displayController.text;
          operand = value;
          displayController.text = "";
        }
      } else if (value == Btn.per) {
        if (operand.isEmpty) {
          // Convert standalone number to percentage
          double num = double.parse(displayController.text);
          displayController.text = (num / 100).toString();
        } else {
          // Calculate percentage of number1
          if (number1.isNotEmpty && displayController.text.isNotEmpty) {
            double num1 = double.parse(number1);
            double num2 = double.parse(displayController.text);
            number2 = (num1 * (num2 / 100)).toString();
            displayController.text = number2;
          }
        }
      } else if (value == Btn.negative) {
        if (displayController.text != "0") {
          if (displayController.text.startsWith("-")) {
            displayController.text = displayController.text.substring(1);
          } else {
            displayController.text = "-${displayController.text}";
          }
        }
      } else if (value == Btn.calculate) {
        if (number1.isNotEmpty && operand.isNotEmpty && displayController.text.isNotEmpty) {
          number2 = displayController.text;
          double num1 = double.parse(number1);
          double num2 = double.parse(number2);
          double result = 0;

          switch (operand) {
            case Btn.add:
              result = num1 + num2;
              break;
            case Btn.subtract:
              result = num1 - num2;
              break;
            case Btn.multiply:
              result = num1 * num2;
              break;
            case Btn.divide:
              if (num2 != 0) {
                result = num1 / num2;
              } else {
                displayController.text = "Error";
                return;
              }
              break;
          }

          displayController.text = result.toString();
          number1 = "";
          operand = "";
          number2 = "";
        }
      } else {
        if (displayController.text == "0") {
          displayController.text = value;
        } else {
          displayController.text += value;
        }
      }
    });
  }
}
