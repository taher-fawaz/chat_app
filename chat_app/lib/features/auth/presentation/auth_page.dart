import 'package:chat_app/core/colors.dart';
import 'package:chat_app/core/constants.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_formfield.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_header.dart';
import 'package:chat_app/features/auth/presentation/widgets/custom_richtext.dart';
import 'package:chat_app/features/home/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const String routeName = '/AuthPage';
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userName = TextEditingController();
  bool isSignUp = false;
  bool hidePassword = true;
  String get email => _emailController.text.trim();
  String get userName => _userName.text.trim();
  String get password => _passwordController.text.trim();
  final firebaseAuth = FirebaseAuth.instance;
  UserCredential? credential;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.blue,
            ),
            CustomHeader(
              text: isSignUp ? 'Sign Up' : 'Log In',
              onTap: () {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const SignUp()));
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColors.whiteshade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09),
                        child: Image.asset(logo),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Visibility(
                        visible: isSignUp,
                        child: CustomFormField(
                          headingText: "UserName",
                          hintText: "username",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          controller: _userName,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "Email",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _emailController,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Password",
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        hintText: "At least 8 Character",
                        obsecureText: hidePassword,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            }),
                        controller: _passwordController,
                      ),
                      Visibility(
                        visible: !isSignUp,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              child: InkWell(
                                onTap: () async {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: AppColors.blue.withOpacity(0.7),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AuthButton(
                        onTap: () async {
                          if (isSignUp) {
                            try {
                              await registerWithEmail();
                            } on FirebaseAuthException catch (e) {
                              registerErrorHandling(e, context);
                            } catch (e) {
                              showSnackbar(context, "There was an Error");
                            }
                          } else {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await signInWithEmail();
                              } on FirebaseAuthException catch (e) {
                                signInErrorHandling(e, context);
                              } catch (e) {
                                showSnackbar(context, "There was an Error");
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        text: isSignUp ? 'Sign Up' : 'Sign In',
                      ),
                      CustomRichText(
                        discription: isSignUp
                            ? 'Already Have an account? '
                            : "Don't already Have an account? ",
                        text: isSignUp ? "Log In here" : "Sign Up",
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const SignUp()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> signInWithEmail() async {
    credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    Navigator.pushReplacementNamed(context, ChatPage.routeName);
  }

  void signInErrorHandling(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'user-not-found') {
      showSnackbar(context, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showSnackbar(context, "Wrong password provided for that user.");
    }
  }

  void registerErrorHandling(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'weak-password') {
      showSnackbar(context, "The password provided is too weak.");
    } else if (e.code == 'email-already-in-use') {
      showSnackbar(context, "The account already exists for that email.");
    }
  }

  Future<void> registerWithEmail() async {
    credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  void showSnackbar(BuildContext context, String? text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text!)));
  }
}
