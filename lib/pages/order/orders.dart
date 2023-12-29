import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final databaseRef =
      FirebaseDatabase.instance.ref(); //database reference object

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(64, 190, 117, 1),
        title: Text('Orders'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseRef
            .child('orders')
            .orderByChild('userId')
            .equalTo(_auth.currentUser!.uid)
            .once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("No orders yet"));
          }

          // Parse the orders
          Map<dynamic, dynamic> orders = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              print("orders: $orders");
              return ListTile(
                title:
                    Text(orders.values.elementAt(index)['OrderId'] as String),
                // Add more fields as needed
              );
            },
          );
        },
      ),
    );
  }
}
