import 'package:ckoitgrol/pages/auth/login_page.dart';
import 'package:ckoitgrol/utils/text/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ckoitgrol/pages/main_layout_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pseudoController = TextEditingController();
  File? _profilePic;

  Future<void> _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String? profilePicUrl =
            await _uploadProfilePic(userCredential.user!.uid);

        await _saveUserDataToFirestore(
          userCredential.user!.uid,
          _emailController.text.trim(),
          _usernameController.text.trim(),
          _pseudoController.text.trim(),
          profilePicUrl,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainLayoutPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.message ?? Translate.of(context).signUpError)),
        );
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await _saveUserDataToFirestore(
        userCredential.user!.uid,
        userCredential.user!.email!,
        userCredential.user!.email!.split('@')[0],
        userCredential.user!.displayName ?? '',
        userCredential.user!.photoURL,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translate.of(context).signUpError)),
      );
    }
  }

  Future<String?> _uploadProfilePic(String userId) async {
    if (_profilePic == null) return null;
    try {
      final ref =
          FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
      await ref.putFile(_profilePic!);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<void> _saveUserDataToFirestore(String uid, String email, String login,
      String pseudo, String? profilePicUrl) async {
    await FirebaseFirestore.instance.collection('logins').doc(uid).set({
      'email': email,
      'login': login,
      'pseudo': pseudo,
      'profilpic': profilePicUrl,
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                Translate.of(context).signUpButton.toCapitalized(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: _profilePic != null
                                    ? FileImage(_profilePic!)
                                    : null,
                                child: _profilePic == null
                                    ? const Icon(Icons.add_a_photo, size: 50)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: Translate.of(context).email),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return Translate.of(context).emailRequired;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return Translate.of(context).emailInvalid;
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  labelText: Translate.of(context).login),
                              validator: (value) => value!.isEmpty
                                  ? Translate.of(context).loginRequired
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _pseudoController,
                              decoration: InputDecoration(
                                  labelText: Translate.of(context).username),
                              validator: (value) => value!.isEmpty
                                  ? Translate.of(context).usernameRequired
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: Translate.of(context).password),
                              obscureText: true,
                              validator: (value) => (value == null ||
                                      value.length < 8 ||
                                      !value.contains(
                                          RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
                                  ? Translate.of(context).passwordRequirements
                                  : null,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _signUpWithEmailAndPassword();
                      },
                      child: Text(
                        Translate.of(context).signUpButton,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: SvgPicture.asset(
                        'assets/images/google.svg',
                        width: 24,
                        height: 24,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).canvasColor),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _signUpWithGoogle();
                      },
                      label: Text(
                        Translate.of(context).signUpWithGoogle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .outlinedButtonTheme
                              .style!
                              .textStyle!
                              .resolve({})!.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _pseudoController.dispose();
    super.dispose();
  }
}
