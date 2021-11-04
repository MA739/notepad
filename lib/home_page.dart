import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_notepage.dart';

FirebaseService service = FirebaseService();

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(children: [
          StreamBuilder(
              stream: service
                  .getCollection('users')
                  .doc(service.auth.currentUser!.uid)
                  .collection('notes')
                  .snapshots()
                  .distinct(),
              //service.getCollection('users').doc(service.getCurrentUser().uid).collection('notes'),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //displays user's subcollection of notes
                if (snapshot.hasData) {
                  // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView(
                      shrinkWrap: true,
                      children: documents
                          .map((doc) => Card(
                                child: ListTile(
                                    title: Text(doc['Title']),
                                    subtitle: Text((doc['DateCreated']))),
                              ))
                          .toList());
                }
                //if the user has not created any notes yet, the screen will be blank.
                //There should still be a button displayed that allows the user to create new notes
                else {
                  return const CircularProgressIndicator();
                }
              }),
          FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotePage()),
                );
              },
              tooltip: 'Post Message',
              child: const Icon(Icons.add))
        ])));
  }
}
