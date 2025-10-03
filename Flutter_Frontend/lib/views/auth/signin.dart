import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
import 'package:hajj_and_umrah/CustomWidgets/CustomButton.dart';
import 'package:hajj_and_umrah/CustomWidgets/CutomTextFormField.dart';
import 'package:hajj_and_umrah/views/auth/signup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajj_and_umrah/views/home/home_screen.dart';

// import 'package:hajj_and_umrah/models/language_provider_model.dart';
// import 'package:provider/provider.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var appLocalizations = AppLocalizations.of(context);
    var emailcon = TextEditingController();
    var passwordcon = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image (Kaaba)
          Positioned(
            top: screenSize.width * 0.3,
            left: 0,
            right: screenSize.width * 0.14,
            child: Image.asset(
              'lib/assets/images/kaaba.png',
              width: screenSize.width,
              height: screenSize.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),

          // Form Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.08,
                  vertical: screenSize.width * 0.06),
              height: screenSize.height * 0.46,
              decoration: BoxDecoration(
                color:
                    Colors.grey.withOpacity(0.8), // Semi-transparent background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenSize.width * 0.08), // ✅ Fixed
                  topRight: Radius.circular(screenSize.width * 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Number TextField
                  CustomTextField(
                    hint: appLocalizations!.textfield2,
                    icon: Icons.email,
                    controller: emailcon,
                  ),
                  SizedBox(height: screenSize.width * 0.03),

                  // Password TextField
                  CustomTextField(
                    hint: appLocalizations.textfield3,
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordcon,
                  ),
                  SizedBox(height: screenSize.width * 0.03),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        appLocalizations.forgetpassword,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  // Sign In Button
                  CustomButton(
                    text: appLocalizations.signinbutton,
                    onTap: () async {
                      // Call the loginPerson function and get the response
                      Map<String, dynamic>? data = await APiHelper()
                          .loginPerson(emailcon.text, passwordcon.text);

                      // Check the status code
                      if (data != null && data["statusCode"] == 200) {
                        // Navigate to the HomeScreen if login is successful
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        // Show popup for invalid credentials
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Login Failed"),
                              content: Text(
                                  "Invalid credentials. Please try again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the popup
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),

                  // Sign Up Navigation
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        appLocalizations.info,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
