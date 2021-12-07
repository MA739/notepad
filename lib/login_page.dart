import 'home_page.dart';
import 'registration_form.dart';
import 'firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;

FirebaseService service = FirebaseService();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var UController = TextEditingController();
  var PController = TextEditingController();
  Route route = MaterialPageRoute(builder: (context) => const homePage());
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    PController.dispose();
    UController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text('Notepad',
            style: GoogleFonts.comfortaa(
              fontWeight: FontWeight.w500,
              fontSize: 50.0)),
          const SizedBox(height: 25),
          TextField(
            controller: UController,
            decoration: InputDecoration(
                fillColor: Colors.white10, filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                hintText: 'Email',
                hintStyle: const TextStyle(
                  color: Colors.grey))),
          const SizedBox(height: 15.0),
          TextField(
            obscureText: true,
            controller: PController,
            decoration: InputDecoration(
                fillColor: Colors.white10, filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                hintText: 'Password',
                hintStyle: const TextStyle(
                  color: Colors.grey))),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              onPressed: () => {
                if (UController.text.isEmpty || PController.text.isEmpty)
                  {
                    showDialog<String>(
                      //if password and username match database, allow login and navigate to mainpage (pictures, etc)
                      //Otherwise send a popup that the login credentials were incorrect
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Login Status'),
                        content:
                            const Text('Please enter your login information.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              UController.clear();
                              PController.clear();
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    )
                  }
                else
                  {
                    service.emailSignInWithPassword(
                        UController.text, PController.text, context),
                    //sometimes need to press login twice
                    if (service.auth.currentUser != null)
                      {Navigator.pushReplacement(context, route)}
                  }
              },
              child: const Text('Login'),
              //onPressed: () =>{attemptLogin()}
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
              ),
              const SizedBox(width: 20),
              Text('OR', style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[500] : Colors.grey[700],
                fontWeight: FontWeight.w300),),
              const SizedBox(width: 20),
              const Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationForm()),
              );
            },
            child: const Text('Create New Account'),
          ),
        ])),
    );
  }
}
