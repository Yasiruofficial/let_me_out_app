import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_me_out/models/AppUser.dart';
import 'package:let_me_out/services/FirebaseFirestoreService.dart';

class FirebaseAuthService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();


  Future<AppUser> getCurrentUser() async {
    try {
      User _user = firebaseAuth.currentUser;

      if (_user != null) {
        return await _firebaseFirestoreService.getUserById(_user.uid.toString());
      }
      return null;
    } catch (e) {
      throw new Exception("Get currunt User error");
    }
  }


  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return await _firebaseFirestoreService.getUserById(userCredential.user.uid.toString());

    } catch (e) {
      throw new Exception("Sign-in Error");
    }
  }

  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user = new AppUser(uid: userCredential.user.uid.toString(),email: email,isAdmin: false);
      await _firebaseFirestoreService.addUser(user);

      return user;

    } catch (e) {

      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        throw new Exception("User already in! Please try with another email");
      }
      print(e);
      throw new Exception("Register Error");
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
