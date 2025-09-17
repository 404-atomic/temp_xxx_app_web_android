import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:framework/base/base/base_pager.dart';

import '../../base/utils/toast.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  void initState() {
    super.initState();
  }

  final Color textColor = const Color(0xff999999);

  final int buttonSize = 68;
  final double space = 10;
  List operatorList = [
    'AC',
    'x',
    '％',
    '÷',
    7,
    8,
    9,
    '×',
    4,
    5,
    6,
    '-',
    1,
    2,
    3,
    '+',
    0,
    '.',
    '='
  ];

  String expression = '';

  bool get expressionIsEmpty => expression.isEmpty;
  String answerResult = '0';
  bool isScaleText = false;
  var prevClickOperator;
  var currentClickOperator;
  List calcResultList = [];
  List numOperatorList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List operatorSymbolList = ['-', '+', '×', '÷'];
  List otherOperatorList = ['x', '=', '.', 'AC', '％'];

  bool isCalcOperator(String value) => operatorSymbolList.contains(value);

  bool isNumberOperator(String value) => numOperatorList.contains(value);

  bool isOtherOperator(String value) => otherOperatorList.contains(value);

  bool filterInput(String operator) {
    if (expression.length >= 23) {
      if (operator == 'AC' || operator == 'x') {
        handleOtherOperatorClick(operator);
      }
      return true;
    }
    if (isCalcOperator(operator) && !expressionIsEmpty) {
      String lastExpression = expression[expression.length - 1];
      if (isNumberOperator(lastExpression) &&
          !operatorSymbolList.contains(lastExpression)) {
        return false;
      } else {
        return true;
      }
    }
    if (isNumberOperator(operator)) {
      if (operator == '0') {
        if (expressionIsEmpty) return true;
        if (expression.length == 1) {
          return expression == '0';
        }
        var str = expression[expression.length - 2];
        var last = expression[expression.length - 1];
        if (!isNumberOperator(str) && last == '0') {
          return !(str == '.');
        } else {
          return false;
        }
      } else {
        if (expression.isNotEmpty && calcResultList.isNotEmpty) {
          String last = calcResultList.last;
          return last.length == 1 && last == '0';
        }
        return false;
      }
    }
    if (operator == '.' && expression.isNotEmpty) {
      String lastExpression = expression[expression.length - 1];
      if (isNumberOperator(lastExpression) &&
          !operatorSymbolList.contains(lastExpression)) {
        return findStrCount(calcResultList.last, '.') != 0;
      }
      return true;
    }
    return false;
  }

  void handleClick(dynamic operator) {
    if (filterInput(operator.toString())) return;
    if (currentClickOperator != null) {
      if (!['x', '=', 'AC', '％'].contains(operator)) {
        if (prevClickOperator != currentClickOperator) {
          prevClickOperator = currentClickOperator;
        }
        currentClickOperator = operator.toString();
      }
    }
    if (operator is int) {
      currentClickOperator = operator.toString();
      handleClickNum(operator);
      setState(() => isScaleText = false);
    } else {
      if (operatorSymbolList.contains(operator)) {
        handleOperatorSymbolClick(operator);
        setState(() => isScaleText = false);
      } else {
        handleOtherOperatorClick(operator);
      }
    }
  }

  void calcExpression() {
    if (isNumberOperator(currentClickOperator) && prevClickOperator == null) {
      setState(() {
        answerResult = currentClickOperator;
      });
      calcResultList.add(currentClickOperator);
    } else if (isNumberOperator(currentClickOperator) &&
        (isNumberOperator(prevClickOperator) || prevClickOperator == '.')) {
      String last = calcResultList.last;
      if (findStrCount(last, '.') == 0 &&
          !operatorSymbolList.contains(last) &&
          prevClickOperator == '.') {
        calcResultList.last += '.' + currentClickOperator;
      } else {
        calcResultList.last += currentClickOperator;
      }
    } else if (isCalcOperator(currentClickOperator) &&
        isNumberOperator(prevClickOperator)) {
      calcResultList.add(currentClickOperator);
    } else if (isNumberOperator(currentClickOperator) &&
        isCalcOperator(prevClickOperator)) {
      calcResultList.add(currentClickOperator);
    } else if (prevClickOperator == '.' &&
        isCalcOperator(currentClickOperator)) {
      calcResultList.add(currentClickOperator);
    } else if (currentClickOperator == 'x') {
      if (isCalcOperator(prevClickOperator) || prevClickOperator == '.') {
        if (calcResultList.last == 0) {
          prevClickOperator = null;
        } else {
          currentClickOperator =
              calcResultList.last[calcResultList.last.length - 1];
        }
      } else {
        currentClickOperator = prevClickOperator;
      }
    }
    calcResult();
  }

  void calcResult() {
    double current = 0;
    double result = 0;
    double? next;
    String? operator;
    int currentIndex = 0;
    int count = calcResultList
        .where((element) => operatorSymbolList.contains(element))
        .length;
    if (calcResultList.length == 1) {
      result = double.parse(calcResultList[0]);
    }

    for (int index = 0; index < count; index++) {
      if (current == 0) {
        current = double.parse(calcResultList[currentIndex]);
      }
      if (currentIndex + 2 < calcResultList.length) {
        next = double.parse(calcResultList[currentIndex + 2]);
      } else {
        next = null;
      }
      if (currentIndex + 1 < calcResultList.length) {
        operator = calcResultList[currentIndex + 1];
      } else {
        operator = null;
      }
      currentIndex += 2;
      if (operator != null) {
        switch (operator) {
          case '×':
            current = result = current * (next ??= 1);
            break;
          case '+':
            current = result = current + (next ??= 0);
            break;
          case '-':
            current = result = current - (next ??= 0);
            break;
          case '÷':
            result = current = current / (next ??= 1);
            break;
          default:
            break;
        }
      }
    }
    setState(() {
      answerResult = result.toString();
    });
  }

  void handleOperatorSymbolClick(String operator) {
    if (expression.isNotEmpty) {
      setState(() {
        expression += operator;
      });
      calcExpression();
    }
  }

  void handleOtherOperatorClick(String operator) {
    if (operator == 'AC') {
      setState(() {
        expression = '';
        answerResult = '0';
        calcResultList = [];
        currentClickOperator = null;
        prevClickOperator = null;
      });
    } else if (operator == '=') {
      setState(() {
        isScaleText = true;
      });
    } else if (operator == 'x') {
      if (calcResultList.isNotEmpty) {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
        });
        String last = calcResultList.last;
        if (isCalcOperator(last)) {
          int index = calcResultList.lastIndexOf(last);
          calcResultList.removeAt(index);
        } else {
          if (last.length == 1) {
            int index = calcResultList.lastIndexOf(last);
            calcResultList.removeAt(index);
          } else {
            calcResultList.last = last.substring(0, last.length - 1);
          }
        }
        if (expression.isNotEmpty) {
          currentClickOperator = 'x';
          calcExpression();
        } else {
          expression = '';
          currentClickOperator = null;
          prevClickOperator = null;
          calcResultList.clear();
          answerResult = '0';
        }
      }
    } else if (operator == '.') {
      if (expression.isEmpty) {
        currentClickOperator = '.';
        prevClickOperator = '0';
        setState(() {
          expression = '0' '.';
          answerResult = '0';
        });
        calcResultList.add('0' '.');
      } else {
        setState(() {
          calcResultList.last = calcResultList.last + '.';
          expression += '.';
        });
      }
    } else {
      if (answerResult != '0' && expression.isNotEmpty) {
        setState(() {
          expression = '';
          currentClickOperator = null;
          prevClickOperator = null;
          calcResultList.clear();
          answerResult = (num.parse(answerResult) / 100).toString();
        });
      }
    }
  }

  void handleClickNum(int num) {
    setState(() {
      expression += num.toString();
    });
    calcExpression();
  }

  int findStrCount(String str, String s) {
    int i = 0;
    for (int index = 0; index < str.length; index++) {
      var element = str[index];
      if (element == s) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    Color expressionColor = Colors.white10;
    Color answerColor = Colors.red;
    if (isScaleText) {
      expressionColor = Colors.black38;
      answerColor = Colors.black;
    } else {
      expressionColor = Colors.black;
      answerColor = Colors.black38;
    }
    return BasePager(
        body: Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: expression.isNotEmpty,
                    child: AnimatedDefaultTextStyle(
                        child: Text(
                          expression,
                          style: TextStyle(
                              color: expressionColor,
                              fontSize: isScaleText ? 30 : 48),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        ),
                        style: TextStyle(
                            color: expressionColor,
                            fontSize: isScaleText ? 30 : 48),
                        duration: const Duration(milliseconds: 250))),
                AnimatedDefaultTextStyle(
                    child: Text(
                      answerResult != '0' ? '= ' + answerResult : '0',
                      style: TextStyle(
                          color: expressionColor,
                          fontSize: isScaleText ? 30 : 48),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                    style: TextStyle(
                        color: answerColor, fontSize: isScaleText ? 48 : 30),
                    duration: const Duration(milliseconds: 250))
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
                spacing: space,
                runSpacing: space,
                alignment: WrapAlignment.spaceBetween,
                children: operatorList.map((e) {
                  Widget child;
                  if (e == 'x') {
                    child = Icon(
                      Icons.cleaning_services_outlined,
                      color: textColor,
                    );
                  } else {
                    child = Text(e is int ? e.toString() : e,
                        style: TextStyle(color: textColor, fontSize: 22));
                  }
                  return SizedBox(
                      width: e == 0
                          ? _covert((buttonSize + space) * 2)
                          : _covert(buttonSize),
                      height:
                          e == 0 ? _covert(buttonSize) : _covert(buttonSize),
                      child: InkWell(
                          onTap: () => handleClick(e),

                          child: Center(
                            child: Transform.scale(
                              scale: operatorSymbolList.contains(e) ||
                                      ['.', '='].contains(e)
                                  ? 1.8
                                  : 1,
                              child: child,
                            ),
                          )));
                }).toList()),
          )
        ],
      ),
    ));
  }

  double _covert(dynamic value) {
    return value.toDouble();
  }
}
