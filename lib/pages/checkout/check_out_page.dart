import 'package:bygrocerry/pages/checkout/paymentstatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bygrocerry/appColors/app_colors.dart';
import 'package:bygrocerry/pages/provider/cart_provider.dart';
import 'package:bygrocerry/widgets/my_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';

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

  int quantity = 1;

  void quantityFuntion(productId) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(productId)
        .update({
      "productQuantity": quantity,
    });
  }

  void deleteProductFuntion(productId) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(productId)
        .delete();
  }

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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('orders')
        .doc(userId)
        .collection('orderId')
        .doc(orderId)
        .set({
      'userId': userId,
      'orderID': orderId,
    });

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
    afterCheckout();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentStatusPage(paymentSuccessful: false),
      ), // or false if the payment failed
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

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
          "Heavens Mart",
          style: TextStyle(
            color: AppColors.KblackColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Products",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: cartProvider.getCartList.isEmpty
                  ? Center(
                      child: Text("No Product"),
                    )
                  : Card(
                      child: ListView.builder(
                          itemCount: cartProvider.getCartList.length,
                          itemBuilder: (context, index) {
                            var data = cartProvider.cartList[index];
                            items[data.productName] = data.productQuantity;
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(data.productImage),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data.productName}",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 12,
                                          ),
                                          Text(
                                            data.productPrice.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //implement a counter here
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              if (quantity > 1) {
                                                setState(() {
                                                  quantity--;
                                                  quantityFuntion(
                                                      data.productId);
                                                });
                                              } else if (quantity == 1) {
                                                deleteProductFuntion(
                                                    data.productId);
                                              } else {
                                                print("error");
                                              }
                                            },
                                          ),
                                          Text(
                                            data.productQuantity.toString(),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              size: 14,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                                quantityFuntion(data.productId);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 12,
                                          ),
                                          Text(
                                            (data.productPrice *
                                                    data.productQuantity)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Sub Total",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\₹ $subTotal",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Delivery Fee",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\₹ $deliveryFee",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\₹ $totalPrice",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    cartProvider.getCartList.isEmpty
                        ? Text("")
                        : MyButton(
                            onPressed: () => openCheckout(cartProvider),
                            text: "Place Order",
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
