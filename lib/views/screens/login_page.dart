import 'package:adv_11_am_firebase_app/helpers/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Anonymous Login"),
              onPressed: () async {
                Map<String, dynamic> res = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .logInWithAnonymously();

                if (res['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login successful..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: res['user']);
                } else if (res['error'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res['error']),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login failed..."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text("Sign Up"),
                  onPressed: validateAndSignUp,
                ),
                ElevatedButton(
                  child: Text("Sign In"),
                  onPressed: validateAndSignIn,
                ),
              ],
            ),
            ElevatedButton(
              child: Text("Sign in with Google"),
              onPressed: () async {
                Map<String, dynamic> res = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .signInWithGoogle();

                if (res['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In successful..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: res['user']);
                } else if (res['error'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res['error']),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In failed..."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  validateAndSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Sign Up"),
        ),
        content: Form(
          key: signUpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter password first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text("Sign Up"),
            onPressed: () async {
              if (signUpFormKey.currentState!.validate()) {
                signUpFormKey.currentState!.save();

                Map<String, dynamic> res = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .signUp(email: email!, password: password!);

                if (res['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign Up successful..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (res['error'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res['error']),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign Up failed..."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                Navigator.of(context).pop();
              }

              setState(() {
                emailController.clear();
                passwordController.clear();
                email = null;
                password = null;
              });
            },
          ),
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              setState(() {
                emailController.clear();
                passwordController.clear();
                email = null;
                password = null;
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  validateAndSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Sign In"),
        ),
        content: Form(
          key: signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter password first...";
                  } else if (val!.length <= 6) {
                    return "Enter lengthy password...";
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text("Sign In"),
            onPressed: () async {
              if (signInFormKey.currentState!.validate()) {
                signInFormKey.currentState!.save();

                Map<String, dynamic> res = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .signIn(email: email!, password: password!);

                if (res['user'] != null) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In successful..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: res['user']);
                } else if (res['error'] != null) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res['error']),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In failed..."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }

              setState(() {
                emailController.clear();
                passwordController.clear();
                email = null;
                password = null;
              });
            },
          ),
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              setState(() {
                emailController.clear();
                passwordController.clear();
                email = null;
                password = null;
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
