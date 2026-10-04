
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO:: Handle Firebase Authentication operations.
class AuthService {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//TODO:: Use the current Google Sign-In instance.
final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

//TODO:: Initialize Google Sign-In.
Future<void> _initializeGoogleSignIn() async {
await _googleSignIn.initialize();
}

//TODO:: Sign in using Google account.
Future<UserCredential> signInWithGoogle() async {
//TODO:: Initialize Google Sign-In before using it.
await _initializeGoogleSignIn();

//TODO:: Open the Google account selection screen.
final GoogleSignInAccount googleUser =
await _googleSignIn.authenticate();

//TODO:: Get the Google authentication token.
final GoogleSignInAuthentication googleAuth =
googleUser.authentication;

//TODO:: Create Firebase credential using the Google ID token.
final AuthCredential credential =
GoogleAuthProvider.credential(
idToken: googleAuth.idToken,
);

//TODO:: Sign in to Firebase using Google credential.
return _firebaseAuth.signInWithCredential(credential);
}

//TODO:: Sign in using email and password.
Future<UserCredential> signInWithEmail({
required String email,
required String password,
}) async {
return _firebaseAuth.signInWithEmailAndPassword(
email: email,
password: password,
);
}

//TODO:: Create a new Firebase account.
Future<UserCredential> createAccount({
required String name,
required String email,
required String password,
}) async {
final UserCredential credential =
await _firebaseAuth.createUserWithEmailAndPassword(
email: email,
password: password,
);

//TODO:: Store the user's name in their Firebase profile.
await credential.user?.updateDisplayName(name);

return credential;
}

//TODO:: Sign out the current user.
Future<void> signOut() async {
await _googleSignIn.signOut();
await _firebaseAuth.signOut();
}

//TODO:: Get the currently logged-in Firebase user.
User? get currentUser => _firebaseAuth.currentUser;

//TODO:: Listen for authentication state changes.
Stream<User?> get authStateChanges =>
_firebaseAuth.authStateChanges();
}
