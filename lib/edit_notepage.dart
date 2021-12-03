import 'firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseService service = FirebaseService();

class EditNotePage extends StatefulWidget {
  // An object of DocumentSnapshot needs to be passed in order
  // to modify that specific note and retrieve its existing content
  DocumentSnapshot editDoc;
  final String docID;
  EditNotePage({required this.editDoc, required this.docID});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  //need to build an editable text object that fits the whole page
  TextEditingController noteTitle = TextEditingController();
  TextEditingController noteContent = TextEditingController();
  String documentID = "";
  @override
  void initState() {
    // Fills controllers with note data from the snapshot
    noteTitle = TextEditingController(text: widget.editDoc['Title']);
    noteContent = TextEditingController(text: widget.editDoc['Content']);
    documentID = widget.docID;
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
                    //ask for confirmation. If the user clicks "Yes", delete
                    showDialog<String>(
                        //confirm user signout
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                content: const Text(
                                    'Are you sure you want to delete this?'),
                                actions: <Widget>[
                                  TextButton(
                                      //This is where it would navigate to the actual app's content
                                      onPressed: () => {Navigator.pop(context)},
                                      child: const Text('No')),
                                  TextButton(
                                      //This is where it would navigate to the actual app's content
                                      onPressed: () => {
                                            deleteNote(),
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst)
                                          },
                                      child: const Text('Yes'))
                                ]))
                  },
              icon: const Icon(Icons.delete)),
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

  Future<void> deleteNote() async {
    final DocumentReference messageDoc = service
        .getCollection('users')
        .doc(service.auth.currentUser!.uid)
        .collection('notes')
        //use docID var, passed from main menu when the user clicks on the doc...
        .doc(documentID);
    messageDoc.delete();
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
