import 'package:flutter/material.dart';
import 'package:music_player/features/login/widgets/login_textfield.dart';
import 'package:provider/provider.dart';
import '../../../controller/authentication_controller.dart';
import '../../../utils/constants/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    return Scaffold(
      backgroundColor: Constants.appBg,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                maxRadius: 90,
                child: Image.asset(
                  Constants.logo,
                  fit: BoxFit.contain,
                ),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                color: Constants.cardBg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: loginformKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Constants.loginHeading,
                        const SizedBox(height: 30),
                        LoginFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: emailController,
                            hint: "Email"),
                        const SizedBox(height: 10),
                        LoginFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }return null;
                          },
                          controller: passwordController,
                          hint: "Password",
                          pass: true,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: Constants.welcomeButtonStyle,
                            onPressed: () {
                              if (loginformKey.currentState!.validate()) {
                                authenticationController.emailLogin(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                              }
                            },
                            child: Constants.loginText),
                        Constants.or,
                        TextButton(
                            onPressed: () {}, child: Constants.withoutLogin),
                        const SizedBox(height: 50)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
