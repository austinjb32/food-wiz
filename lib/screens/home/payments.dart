import 'dart:io';

import 'package:FoodWiz/screens/details/components/cartpage.dart';
import 'package:FoodWiz/screens/home/home_page.dart';
import 'package:FoodWiz/screens/home/payment_config.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../details/components/orders.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key});

  @override
  State<Payments> createState() => _PaymentsState();
}

bool status = false;

class _PaymentsState extends State<Payments> {
  String os = Platform.operatingSystem;

  @override
  void initState() {
    super.initState();
    redirectApp();
  }

  void redirectApp() {
    Future.delayed(Duration(seconds: 30), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      ).then((value) {
        // This code executes after the CartPage is closed
        // You can perform any additional actions here
      });
    });
  }

  var applePayButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
        label: 'Item A',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Item B',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Total',
        amount: '0.02',
        status: PaymentItemStatus.final_price,
      )
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.buy,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) => debugPrint('Payment Result $result'),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  var googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
        label: 'Total',
        amount: '2',
        status: PaymentItemStatus.final_price,
      )
    ],
    type: GooglePayButtonType.pay,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) => {status=true},
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("Quick Payment"),foregroundColor: Colors.black87,),
      body: Center(
        child: Column(
          children: [
            SizedBox(height:50),
            SizedBox(height:200),
            Text("Choose your payment Method",textScaleFactor: 1.5,),
            SizedBox(height: 20,),
            Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Platform.isIOS ? applePayButton : googlePayButton),
          ),
          ]
        ),
      ),
    );
  }
}
