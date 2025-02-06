import 'package:flutter/material.dart';
import 'numpad_btns.dart';
import 'package:math_expressions/math_expressions.dart';

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
  String equation = "0";
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
        equation = "0";
        displayController.text = "0";
      } else if (value == Btn.del) {
        if (equation.isNotEmpty) {
          equation = equation.substring(0, equation.length - 1);
          if (equation.isEmpty) equation = "0";
          displayController.text = equation;
        }
      } else if (value == Btn.negative) {
        if (equation.isNotEmpty && equation != "0") {
          if (equation.startsWith("-")) {
            equation = equation.substring(1);
          } else {
            equation = "-$equation";
          }
          displayController.text = equation;
        }
      } else if (value == Btn.per) {
        try {
          double num = double.parse(equation);
          equation = (num / 100).toString();
          displayController.text = equation;
        } catch (e) {
          displayController.text = "Error";
        }
      } else if (value == Btn.calculate) {
        evaluateExpression();
      } else {
        if (equation == "0") {
          equation = value;
        } else {
          equation += value;
        }
        displayController.text = equation;
      }
    });
  }

  void evaluateExpression() {
    try {
      String finalExpression = equation.replaceAll(Btn.multiply, '*').replaceAll(Btn.divide, '/');
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      equation = result.toString();
      displayController.text = equation;
    } catch (e) {
      displayController.text = "Error";
    }
  }
}
