import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';

//instantiates a FirebaseService object from file firestore_services.dart
FirebaseService service = FirebaseService();

// ignore: must_be_immutable
class RegistrationForm extends StatelessWidget {
  RegistrationForm({Key? key}) : super(key: key);
  //Controllers for first name, last name, etc
  //FNController, EController, PwController, bioController, homeController, ageController
  var FNController = TextEditingController();
  var EController = TextEditingController();
  var PwController = TextEditingController();
  var bioController = TextEditingController();
  var homeController = TextEditingController();
  var ageController = TextEditingController();

  Future<void> addUser(
      String Name, String email, String pass, BuildContext context) async {
    // Call the user's Reference to add a new user
    bool errorThrown = true;
    try {
      UserCredential userCredential =
          await service.emailPassSignUp(email, pass);
      errorThrown = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorThrown = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The password provided is too weak.")));
        //return;
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The account already exists for that email.")));
        errorThrown = true;
        //return;
      }
    } catch (e) {
      return;
    }
    //assuming everything went well with the email registration
    if (errorThrown == false && service.getCurrentUser() != null) {
      //print('DATE' + DateTime.now().toString());
      var user = await service.getCurrentUser();
      String uid = user!.uid;

      //EDIT REGISTRATION PARAMETERS

      //dateTime object
      var now = DateTime.now();
      var regisDate = formatDate(now, [mm, "/", dd, "/", yyyy]);
      service
          .getCollection('users')
          .doc(uid)
          .set({
            //'Email': Email, // xyz@gmail.com
            'id': Name, // Stokes and Sons
            'Registration DateTime':
                regisDate, //insert function to grab time/date, format it, and convert it to string
            //'Bio': bio,
            //'HomeTown': hometown,
            //'Age': age,
            'UID': uid,
            //'picture': defaultImageURL,
            //'UID': uid,
            //'Password': Pass
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      Navigator.of(context).pop();
      //Navigator.of(context)..pop();

      //send popup showing that the user registered successfully. When the user clicks "ok", send them back to login page
      //} else {}
    }
  }

  @override
  //wall of textfields...
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Center(
                    //padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0,),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
          const Padding(
              // Even Padding On All Sides
              padding: EdgeInsets.all(20.0)),
          //EDIT REGISTRATION PARAMETERS
          TextField(
            //scrollPadding: EdgeInsets.fromTLRB(0.0, 20.0, 0.0, 0.0),
            controller: FNController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'User Name'),
          ),
          TextField(
            controller: EController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Email'),
          ),
          TextField(
            controller: PwController,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Password'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.black,
              //textStyle: const TextStyle(Fontweight.bold),
            ),
            //submit values to firestore
            onPressed: () => {
              //email/password authentication here

              //constructor String FName, String LName, String Email, String Pass, --String UID--, --String Role--
              //user's data here
              //service.emailPassSignUp(EController.text, PwController.text),
              if (FNController.text == "" ||
                  EController.text == "" ||
                  PwController.text == "")
                {
                  showDialog<String>(
                    //if password and username match database, allow login and navigate to mainpage (pictures, etc)
                    //Otherwise send a popup that the login credentials were incorrect
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Login Status'),
                      content: const Text('Fill out all fields'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {
                            //navigates back to login page
                            //Navigator.of(context)..pop()..pop()
                            Navigator.pop(context, 'OK'),
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  )
                }
              else
                {
                  addUser(FNController.text, EController.text,
                      PwController.text, context)
                },
            },
            child: const Text('Register'),
          )
        ])))));
  }
}
