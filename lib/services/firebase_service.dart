import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth Methods
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Email/Password Sign Up
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _createUserDocument(credential.user!, name);
      
      // Update display name
      await credential.user!.updateDisplayName(name);

      return credential.user;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Email/Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      // Create user document if new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserDocument(
          userCredential.user!,
          googleUser.displayName ?? 'User',
        );
      }

      return userCredential.user;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Firestore Methods
  Future<void> _createUserDocument(User user, String name) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'photoUrl': user.photoURL,
      'tokens': 0,
      'savingsBalance': 0.0,
      'dailyUsageMinutes': 0,
      'selectedMMF': null,
      'linkedAccounts': {},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get User Data
  Stream<DocumentSnapshot> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  // Update User Data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Token Operations
  Future<void> addTokens(String uid, int tokens) async {
    await _firestore.collection('users').doc(uid).update({
      'tokens': FieldValue.increment(tokens),
    });
  }

  Future<void> deductTokens(String uid, int tokens) async {
    await _firestore.collection('users').doc(uid).update({
      'tokens': FieldValue.increment(-tokens),
    });
  }

  // Investment Operations
  Future<void> createInvestment({
    required String uid,
    required String mmf,
    required double amount,
    required String type, // 'tokens' or 'mpesa'
  }) async {
    await _firestore.collection('investments').add({
      'userId': uid,
      'mmf': mmf,
      'amount': amount,
      'type': type,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get Investments
  Stream<QuerySnapshot> getInvestments(String uid) {
    return _firestore
        .collection('investments')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Transaction Operations
  Future<void> createTransaction({
    required String uid,
    required String type, // 'deposit', 'withdrawal', 'investment', 'reward'
    required double amount,
    required String description,
  }) async {
    await _firestore.collection('transactions').add({
      'userId': uid,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get Transactions
  Stream<QuerySnapshot> getTransactions(String uid) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }
}

