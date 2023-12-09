import 'package:bygrocerry/pages/checkout/paymentstatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bygrocerry/appColors/app_colors.dart';
import 'package:bygrocerry/pages/provider/cart_provider.dart';
import 'package:bygrocerry/widgets/my_button.dart';
import 'package:bygrocerry/widgets/single_cart_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String date = DateFormat.yMMMd().format(tz.TZDateTime.now(tz.local));
String time = DateFormat.jm().format(tz.TZDateTime.now(tz.local));

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late Razorpay _razorpay;
  late double totalPrice;
  Map<String, int> items = {};
  double? shipping = 30.0;

  void openCheckout(CartProvider cartProvider) async {
    String name = "Sajal";
    int id = 123456789;
    double contact = 1234567890;
    String email = "abc@gmail.com";
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': num.parse(
            totalPrice.toString(),
          ) *
          100,
      'name': name,
      'description': 'Payment for order $id',
      'prefill': {
        'contact': contact.toString(),
        'email': email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      print("loading razorpay");
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void afterCheckout() async {
    // Generate a unique ID for the order
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseAuth auth = FirebaseAuth.instance;
    String? userId = auth.currentUser?.uid;

    print(totalPrice);
    print(items);
    print("inside checkout");
    await FirebaseDatabase.instance.ref().child('orders').child(orderId).set(
      {
        'userId': userId,
        'DeliveryFee': deliveryFee,
        'SubTotal': totalPrice - deliveryFee,
        'amount': totalPrice,
        'Items': items,
        'Address': 'address',
        'Status': 'Order Received',
        'Date': date, //current date,
        'Time': time, //curren time,
        'name': 'name',
        'contact': 'contact',
        'Payment': 'payment',
        'OrderId': 'orderId',
        // ignore: sdk_version_since
        'Accepted': bool.parse(false.toString()),
        // Add other order details here
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentStatusPage(paymentSuccessful: true),
      ), // or false if the payment failed
    );
    // Continue with the checkout process...
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Susccess");
    print("calling afterCheckout();");
    afterCheckout();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment error");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentStatusPage(paymentSuccessful: false),
      ), // or false if the payment failed
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET ");
  }

  double deliveryFee = 0.0;

  void getDeliveryFee() async {
    Future<DataSnapshot> del = FirebaseDatabase.instance
        .ref()
        .child('adminvariables')
        .child('deliveryFee')
        .get();
    del.then((DataSnapshot snapshot) {
      setState(() {
        deliveryFee = double.parse(snapshot.value.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getDeliveryFee();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    double subTotal = cartProvider.subTotal();
    double value = subTotal + deliveryFee;
    totalPrice = value;

    if (cartProvider.getCartList.isEmpty) {
      setState(() {
        totalPrice = 0.0;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Check out",
          style: TextStyle(
            color: AppColors.KblackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.getCartList.isEmpty
                ? Center(
                    child: Text("No Product"),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: cartProvider.getCartList.length,
                    itemBuilder: (ctx, index) {
                      var data = cartProvider.cartList[index];
                      items[data.productName] = data.productQuantity;
                      print(items);
                      return SingleCartItem(
                        productId: data.productId,
                        productCategory: data.productCategory,
                        productImage: data.productImage,
                        productPrice: data.productPrice,
                        productQuantity: data.productQuantity,
                        productName: data.productName,
                      );
                    },
                  ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: Text("Sub Total"),
                  trailing: Text("\₹ $subTotal"),
                ),
                ListTile(
                  leading: Text("Shiping"),
                  trailing: Text("\₹ $deliveryFee"),
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: Text("Total"),
                  trailing: Text("\₹ $totalPrice"),
                ),
                cartProvider.getCartList.isEmpty
                    ? Text("")
                    : MyButton(
                        onPressed: () => openCheckout(cartProvider),
                        text: "Buy",
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
