// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class OrdersPage extends StatefulWidget {
//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }

// FirebaseDatabase database = FirebaseDatabase.instance;
// DatabaseReference databaseReference = database.ref();
// final firebaseApp = Firebase.app();
// final rtdb = FirebaseDatabase.instanceFor(
//     app: firebaseApp,
//     databaseURL: 'https://your-realtime-database-url.firebaseio.com/');

// class _OrdersPageState extends State<OrdersPage> {
//   bool _isExpanded = false;

//   final databaseRef =
//       FirebaseDatabase.instance.ref(); //database reference object

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders'),
//       ),
//       body: FutureBuilder<DataSnapshot>(
//         future: databaseRef
//             .child('orders')
//             .once()
//             .then((snapshot) => snapshot as DataSnapshot),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (!snapshot.hasData) {
//             return Text("No orders yet");
//           }

//           return Text("Sajal");
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
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
        title: Text('Orders'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseRef
            .child('orders')
            .orderByChild('userId')
            .equalTo(_auth.currentUser!.uid)
            .once(),
        builder: (context, snapshot) {
          print("inside snapshots");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print("current user id:" + _auth.currentUser!.uid);
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Text("No orders yet");
          }

          // Parse the orders
          Map<dynamic, dynamic> orders = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(orders.values.elementAt(index)['orderName']),
                // Add more fields as needed
              );
            },
          );
        },
      ),
    );
  }
}
