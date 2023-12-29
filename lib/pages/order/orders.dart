import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({Key? key}) : super(key: key);

  final databaseReference = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              const urlString = 'tel:+918349881787';
              Uri url = Uri.parse(
                  urlString); // Replace <YourPhoneNumber> with the number you want to call
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(64, 190, 117, 1),
        title: Text(
          'Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseReference
            .child('orders')
            .orderByChild('userId')
            .equalTo(_auth.currentUser!.uid)
            .onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromRGBO(64, 190, 117, 1),
            ));
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<dynamic, dynamic>? values =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
              if (values == null) {
                return Container(); // or return a widget to indicate no orders
              } else {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (ctx, i) {
                      var keys = values.keys.toList()
                        ..sort((a, b) => b.compareTo(a));
                      var order = values[keys[i]];
                      var status = order['Status'];

                      Color color = Colors.orange;
                      if (status == "OPEN") {
                        color = const Color.fromARGB(255, 255, 182, 64);
                      } else if (status == "CLOSED") {
                        color = Colors.green;
                      } else if (status == "RETURNED") {
                        color = Colors.red;
                      } // Assuming the status is stored in a 'status' field
                      var orderId = keys[i];
                      var date = order['Date'];
                      var amount = order['amount'];
                      var time = order['Time'];
                      var visibleOrderId =
                          orderId.substring(orderId.length - 4);
                      var greyOrderId =
                          orderId.substring(0, orderId.length - 4);

                      return GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the border radius
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 10,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'ID: ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: greyOrderId,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 85, 85, 85),
                                            ),
                                          ),
                                          TextSpan(
                                            text: visibleOrderId,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.currency_rupee,
                                      size: 14,
                                      // weight: 50,
                                    ),
                                    Text(
                                      amount.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 70, 70, 70),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${order['Items'].entries.map((e) => '${e.key}').join(', ')}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    child: Text(
                                      '$date, $time',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      right: 10.0,
                                      bottom: 10.0,
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                      bottom: 4.0,
                                      left: 10.0,
                                      right: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
