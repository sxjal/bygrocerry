import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference databaseReference = database.ref();
final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL: 'https://your-realtime-database-url.firebaseio.com/');

class _OrdersPageState extends State<OrdersPage> {
  final databaseRef =
      FirebaseDatabase.instance.ref(); //database reference object

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: databaseRef
            .child('orders')
            .once()
            .then((snapshot) => snapshot as DataSnapshot),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Text('No orders yet');
          }

          Object? orders = snapshot.data!.value;
          // return ListView(
          //   children: orders?.entries.map((entry) {
          //     return ListTile(
          //       title: Text('Order ID: ${entry.key}'),
          //       subtitle: Text('Total: ${entry.value['total']}'),
          //     );
          //   }).toList(),
          // );
          return Text("Sajal");
        },
      ),
    );
  }
}
