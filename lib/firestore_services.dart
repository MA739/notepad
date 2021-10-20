import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//base authentication class for future projects

class FirebaseService {
  //add instances that allow use of each authentication method
  //create a method for each
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Map<String, UserEX> userMap = <String, UserEX>{};

  final StreamController<Map<String, UserEX>> _usersController =
      StreamController<Map<String, UserEX>>();

  FirebaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
  }

  //method for performing simple currentUser login status
  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  //method for returning the a given collection. Needed for adding new users to the db
  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  Stream<Map<String, UserEX>> get users => _usersController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  Map<String, UserEX> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      UserEX user = UserEX.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  //create account with email with password method
  Future<UserCredential> emailPassSignUp(String email, String password) async {
    //try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    /*} on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }*/
    return userCredential;
  }

  Future<void> emailSignInWithPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //email verification
  Future<void> verifyEmail() async {
    User? user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //signout method
  Future<void> signOut() async {
    await auth.signOut();
  }
}

class UserEX {
  UserEX({
    required this.id,
    //required this.picture,
    required this.name,
  });

  factory UserEX.fromMap(String id, Map<String, dynamic> data) {
    return UserEX(
        id: id, /*picture: data['picture'],*/ name: data['display_name']);
  }

  final String id;
  //final String? picture;
  final String name;
}
