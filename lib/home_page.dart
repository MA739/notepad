import 'package:flutter/material.dart';
import 'package:notepad/edit_notepage.dart';
import 'firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_notepage.dart';
import 'package:date_format/date_format.dart';

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
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Your Notes"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
        ),
        elevation: 2,
        // Maybe add settings here?
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        )
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: service
          .getCollection('users')
          .doc(service.auth.currentUser!.uid)
          .collection('notes')
          .snapshots()
          .distinct(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //displays user's subcollection of notes
            if (snapshot.hasData) {
              // Notes will appear in a grid view with data from snapshot
              return GridView.builder(
                padding: EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                // Each grid objet will have a container with note data
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    // Tapping on a note will allow the user to view and edit it
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditNotePage(editDoc: snapshot.data!.docs[index])),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data!.docs[index].data()['Title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data!.docs[index].data()['Content'],
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis),
                          )
                        ],
                      )
                    ),
                  );
                },
              );
            } else {
              // Screen will be blank when user has no saved notes
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ),
      // Allows user to create a new note
      floatingActionButton: FloatingActionButton(
        tooltip: 'Post Note',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotePage()),
          );
        }
      )
    );
  }
}
