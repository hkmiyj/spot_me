import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot_me/view/homeBar.dart';
import 'package:spot_me/view/login.dart';
import 'package:spot_me/view/profileConfirmation.dart';
import '../widget/showSnackBar.dart';
import 'package:spot_me/route/route.dart' as route;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

// STATE PERSISTENCE
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // Stream get authStateChange => FirebaseAuth.instance.userChanges();
  // Stream get authStateTokenChange => FirebaseAuth.instance.idTokenChanges();

// SIGN UP EMAIL AND PASSWORD
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      showSuccessSnackBar(context, "Register Successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showSnackBar(context, e.message!);
    }
  }

  // SIGN IN EMAIL AND PASSWORD
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.displayName == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => confirmationAccount()));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homepage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // SIGN UP GMAIL
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}
