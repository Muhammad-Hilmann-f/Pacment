import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // client id
    clientId: '820318220141-hea9lono9a937c15m66a7uojku5evn67.apps.googleusercontent.com',
  );

  // Register
// Register
Future<User?> registerWithEmail(String email, String password) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 🟢 Kirim email verifikasi
    await result.user?.sendEmailVerification();

    print('✅ Registration successful, verification email sent to $email');
    return result.user;
  } on FirebaseAuthException catch (e) {
    print('Register error: ${e.message}');
    throw Exception(e.message);
  } catch (e) {
    print('Register error: $e');
    throw Exception('An unknown error occurred during registration.');
  }
}


  // Login
Future<User?> loginWithEmail(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (result.user != null && !result.user!.emailVerified) {
      await _auth.signOut(); // Langsung logout lagi
      throw Exception('Email Anda belum diverifikasi. Periksa inbox Anda.');
    }

    return result.user;
  } on FirebaseAuthException catch (e) {
    print('Login error: ${e.message}');
    throw Exception(e.message);
  } catch (e) {
    print('Login error: $e');
    throw Exception('An unknown error occurred during login.');
  }
}

  // Google Sign-In dengan error handling yang lebih baik
  Future<User?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // Sign out dulu untuk memastikan clean state
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        return null;
      }

      print('Google user: ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      print('Signing in with Firebase...');
      UserCredential result = await _auth.signInWithCredential(credential);
      print('Firebase sign-in successful: ${result.user?.email}');
      
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      await _googleSignIn.signOut(); // Clean up on error
      throw Exception('Firebase authentication failed: ${e.message}');
    } catch (e) {
      print('Google Sign-In error: $e');
      await _googleSignIn.signOut(); // Clean up on error
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}