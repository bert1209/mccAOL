import 'package:flutter/material.dart';

// import google_sign_in
import 'package:google_sign_in/google_sign_in.dart';
void signInGoogle() async {
final GoogleSignIn _googleSignIn = GoogleSignIn(
scopes: ['email'],
);
// Performs Sign In, will return user account's info
final GoogleSignInAccount? account = await _googleSignIn.signIn();
// Account will be null if user cancelled the sign in process
if (account != null) {
print('Email user: ${account.email}');
print('Nama user: ${account.displayName}');
}
}
void signOutGoogle() async {
final GoogleSignIn _googleSignIn = GoogleSignIn(
scopes: ['email'],
);
if (await _googleSignIn.isSignedIn()) {
await _googleSignIn.signOut();
}
}