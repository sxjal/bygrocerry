import 'package:bygrocerry/pages/checkout/check_out_page.dart';
import 'package:bygrocerry/pages/home/order/orders.dart';
import 'package:flutter/material.dart';

class PaymentStatusPage extends StatefulWidget {
  final bool paymentSuccessful;

  PaymentStatusPage({required this.paymentSuccessful});

  @override
  _PaymentStatusPageState createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                widget.paymentSuccessful ? OrdersPage() : CheckOutPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.paymentSuccessful
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
            Text(
                "Payment ${widget.paymentSuccessful ? "Successful" : "Failed"}"),
          ],
        ),
      ),
    );
  }
}
