import 'firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseService service = FirebaseService();

class EditNotePage extends StatefulWidget {
  // An object of DocumentSnapshot needs to be passed in order
  // to modify that specific note and retrieve its existing content
  DocumentSnapshot editDoc;
  EditNotePage({required this.editDoc});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  //need to build an editable text object that fits the whole page
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();

  @override
  void initState() {
    // Fills controllers with note data from the snapshot
    noteTitle = TextEditingController(text: widget.editDoc['Title']);
    noteContent = TextEditingController(text: widget.editDoc['Content']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Edit Note"),
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
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
      // Return to home if content is blank
      Navigator.pop(context);
    } else {
      // Check if the title is empty
      if (title.isNotEmpty) {
        // Using the reference of the passed DocumentSnapshot,
        // update the data of the referenced note
        widget.editDoc.reference.update({
          'Title': title,
          'Content': noteContent,
        });
      } else {
        widget.editDoc.reference.update({
          'Title': 'Untitled',
          'Content': noteContent,
        });
      }
    }
  }
}
