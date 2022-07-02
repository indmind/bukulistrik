import 'package:bukulistrik/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = Get.find();
  final GoogleSignIn _googleSignIn = Get.find<GoogleSignIn>();

  late final Rx<User?> user = Rx<User?>(null);
  // late final Rx<GoogleSignInAccount?> googleAccount =
  //     Rx<GoogleSignInAccount?>(null);

  Worker? _userWorker;

  @override
  void onReady() {
    super.onReady();

    user.value = _auth.currentUser;

    user.bindStream(_auth.userChanges());
    _userWorker = ever(user, _onUserChanged);
  }

  @override
  void onClose() {
    _userWorker?.dispose();
    super.onClose();
  }

  _onUserChanged(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.login.name);
    } else {
      // if user is in login page, then go home
      if (Get.currentRoute == Routes.login.name) {
        Get.offAllNamed(Routes.home.name);
      }
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account != null) {
      final GoogleSignInAuthentication auth = await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      await _auth.signInWithCredential(credential);
    }
  }

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}