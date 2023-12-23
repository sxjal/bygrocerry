import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String emailAddress;

  final String userUid;
  UserModel({
    required this.fullName,
    required this.emailAddress,
    required this.userUid,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      fullName: doc['fullName'],
      emailAddress: doc['emailAdress'],
      userUid: doc['userUid'],
    );
  }
}
