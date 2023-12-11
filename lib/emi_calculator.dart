import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EMICalculator extends StatefulWidget {
  const EMICalculator({Key? key}) : super(key: key);

  @override
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  TextEditingController _loanAmountController = TextEditingController();
  TextEditingController _rateOfInterestController = TextEditingController();
  TextEditingController _tenureController = TextEditingController();
  TextEditingController _emiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  double? _loanAmount, _rateOfInterest, _tenure, _emi;
  String? _calculateType = '';
  String _emiResult = '';
  String _tenureResult = '';
  String _loanAmountResult = '';
  String _rateOfInterestResult = '';
  String _totalInterestResult = '';
  String _totalAmountResult = '';
  String _oneMonthInterestResult = '';

  void _resetFields() {
    setState(() {
      _loanAmount = null;
      _rateOfInterest = null;
      _tenure = null;
      _emi = null;
      _emiResult = '';
      _tenureResult = '';
      _loanAmountResult = '';
      _formKey.currentState!.reset();
    });
    _loanAmountController.clear();
    _rateOfInterestController.clear();
    _tenureController.clear();
    _emiController.clear();
  }

  void _calculateLoanAmount() {
    print("cal amount");
    print(_rateOfInterest);
    print(_tenure);
    print(_emi);
    if (_emi != null && _rateOfInterest != null && _tenure != null) {
      double interest = _rateOfInterest! / (12 * 100);
      double numerador = _emi! * (pow(1 + interest, _tenure!) - 1);
      double denominador = interest * pow(1 + interest, _tenure!);
      // double loanAmount = _emi! /
      //     (interest * pow(1 + interest, _tenure as num)) *
      //     (pow(1 + interest, _tenure as num) - 1);
      double loanAmount = numerador / denominador;
      print(loanAmount);
      setState(() {
        _loanAmount = loanAmount;
        _loanAmountResult = loanAmount.toStringAsFixed(2);
        _loanAmountController = TextEditingController(text: _loanAmountResult);
      });
    }
  }

  void _calculateInterestRate() {
    print(" cal rate");
    print(_loanAmount);
    print(_tenure);
    print(_emi);
    if (_formKey.currentState!.validate() &&
        _loanAmount != null &&
        _emi != null &&
        _tenure != null) {
      double rate = (_emi! * 12 * 100) /
          (_loanAmount! * (1 - (1 / pow((1 + _emi! / 12), _tenure!))));
      setState(() {
        _rateOfInterestResult = rate.toStringAsFixed(2);
        _rateOfInterestController =
            TextEditingController(text: rate.toStringAsFixed(2));
        // _rateOfInterestController.text = _rateOfInterestResult;
        print('_rateOfInterestResult: , $_rateOfInterestResult');
      });
    }
  }

  void _calculateTenure() {
    print(" cal tenure");
    print(_loanAmount);
    print(_rateOfInterest);
    print(_emi);
    if (_formKey.currentState!.validate() &&
        _loanAmount != null &&
        _rateOfInterest != null &&
        _emi != null) {
      double interest = _rateOfInterest! / (12 * 100);
      double numerador =
          log(_emi!.abs()) - log((_emi! - _loanAmount! * interest).abs());
      double denominador = log((1 + interest!).abs());
      print("_emi: ${log(_emi!)}");
      print("_loanAmount: ${(_loanAmount! * interest)}");
      print("Numerador: ${numerador}");
      print("denominador: ${denominador}");
      print("interest: ${interest}");
      // double tenure = log((_emi! / (_emi! - interest * _loanAmount!)) /
      //         (interest * pow(1 + interest, _tenure as num))) /
      //     log((1 + interest));
      double tenure = numerador / denominador;
      setState(() {
        _tenureResult = tenure.toStringAsFixed(2);
        _tenureController.text = _tenureResult;
        print('_tenureResult: , $_tenureResult');
      });
    }
  }

  void _calculateEMI() {
    print("cal emi");
    print(_loanAmount);
    print(_rateOfInterest);
    print(_tenure);
    if (_formKey.currentState!.validate() &&
        _loanAmount != null &&
        _rateOfInterest != null &&
        _tenure != null) {
      double interest = _rateOfInterest! / (12 * 100);
      double emi = _loanAmount! *
          interest *
          pow(1 + interest, _tenure as double) /
          (pow(1 + interest, _tenure as double) - 1);
      setState(() {
        _emiResult = emi.toStringAsFixed(2);
        _emi = emi;
        _emiController = TextEditingController(text: _emiResult);
        print('_emiResult: , $_emiResult');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EMI Calculator'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: "loanAmount",
                      groupValue: _calculateType,
                      onChanged: (String? value) {
                        setState(() {
                          _calculateType = value;
                        });
                      },
                    ),
                    const Text("Loan Amount"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: _calculateType != "loanAmount",
                        controller: _loanAmountController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Loan Amount',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,10}')),
                        ],
                        validator: (value) {
                          //  print(value);
                          if (value!.isEmpty) {
                            return 'Please enter loanAmount amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //  print(value);
                          _loanAmount = double.parse(value);
                          //  print(_loanAmount);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Radio(
                      value: "interest",
                      groupValue: _calculateType,
                      onChanged: (String? value) {
                        setState(() {
                          _calculateType = value;
                        });
                      },
                    ),
                    const Text("ROI % Annual"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        // enabled: _calculateType != "interest",
                        controller: _rateOfInterestController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Interest Rate',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,10}')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter interest amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _rateOfInterest = double.parse(value);
                          //print(_rateOfInterest);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Radio(
                      value: "tenure",
                      groupValue: _calculateType,
                      onChanged: (String? value) {
                        setState(() {
                          _calculateType = value;
                        });
                      },
                    ),
                    const Text("Tenure in Months"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: _calculateType != "tenure",
                        controller: _tenureController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Tenure in Months',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter tenure amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _tenure = double.parse(value);
                          // print(_tenure);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Radio(
                      value: "emi",
                      groupValue: _calculateType,
                      onChanged: (String? value) {
                        setState(() {
                          _calculateType = value;
                        });
                      },
                    ),
                    const Text("EMI Monthly"),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: _calculateType != "emi",
                        controller: _emiController,
                        decoration: const InputDecoration(
                          hintText: 'Enter EMI Amount',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,10}')),
                        ],
                        validator: (value) {
                          // if (value!.isEmpty) {
                          //   return 'Please enter EMI amount';
                          // }
                          return null;
                        },
                        onChanged: (value) {
                          _emi = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //  Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: _resetFields,
                        child: const Text('Reset'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: (() {
                          if (_calculateType == 'loanAmount') {
                            _calculateLoanAmount();
                          } else if (_calculateType == 'interest') {
                            _calculateInterestRate();
                          } else if (_calculateType == 'tenure') {
                            _calculateTenure();
                          } else if (_calculateType == 'emi') {
                            _calculateEMI();
                          }

                          /*     _calculateType == 'loanAmount'
                                ? _calculateLoanAmount()
                                : _calculateType == 'interest'
                                    ? _calculateInterestRate()
                                    : _calculateType == 'tenure'
                                        ? _calculateTenure()
                                        : _calculateEMI(); */
                        }),
                        child: const Text('Calculate'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Details'),
                      ),
                    ),
                    //  Spacer(),
                  ],
                ),
                //  const SizedBox(height: 1),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Total Amount Payment:  ${(_loanAmount ?? 0.00).toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text('Total Interest Payment : $_rateOfInterest'),
                      const SizedBox(height: 8),
                      Text('First Month Interest :  $_tenure'),
                      const SizedBox(height: 8),
                      Text('EMI :  ${(_emi ?? 0.00).toStringAsFixed(2)}'),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Version : 1.0  '),
                      const SizedBox(height: 8),
                      Text(' EMI Calculator '),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
