import 'firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseService service = FirebaseService();

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);
  _NotePageState createState() => _NotePageState();
}

//Add method to update note message, if the doc already exists

class _NotePageState extends State<NotePage> {
  //need to build an editable text object that fits the whole page
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("New Note"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => {
                    //write note to database
                    saveNote(noteTitle.text, noteContent.text),
                    //return to homescreen
                    Navigator.pop(context),
                  },
              icon: const Icon(Icons.save))
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: noteTitle,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                autofocus: true,
              ),
              TextField(
                controller: noteContent,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type Here...",
                    hintStyle: TextStyle(fontSize: 18)),
                style: const TextStyle(fontSize: 18),
                scrollPadding: const EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 500,
                autofocus: true,
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> saveNote(String title, String noteContent) async {
    if (noteContent == "") {
      //just return to home page
      Navigator.pop(context);
    } else {
      final DocumentReference messageDoc = service
          .getCollection('users')
          .doc(service.auth.currentUser!.uid)
          .collection('notes')
          .doc();

      //check if the doc with this id already exists...

      if (title.isNotEmpty) {
        messageDoc.set(<String, dynamic>{
          'Title': title,
          'DateCreated': DateTime.now(),
          'Content': noteContent,
        });
      } else {
        messageDoc.set(<String, dynamic>{
          'Title': "Untitled",
          'DateCreated': DateTime.now(),
          'Content': noteContent,
        });
      }
    }
  }
}
