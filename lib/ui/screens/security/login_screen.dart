import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/launch/navigator/app_navigator.dart';
import 'package:frontend/service/services.dart';

import '../../../language/language.dart';
import '../../../launch/routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool emailValidate = false, passwordValidate = false;
  bool rememberValue = false;

  String email = dotenv.isInitialized?(dotenv.get('TEST_USERNAME', fallback: '')):'';
  String password = dotenv.isInitialized?(dotenv.get('TEST_PASSWORD', fallback: '')):'';

  @override
  Widget build(BuildContext context) {
    String? preparedEmail = ModalRoute.of(context)?.settings.arguments as String?;
    if (preparedEmail != null && preparedEmail.isNotEmpty) {
      email = preparedEmail;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                Language.getLangPhrase(Phrase.signIn),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                )),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return Language.getLangPhrase(Phrase.pleaseEnterYourEmail);
                          if (EmailValidator.validate(value)) {
                            emailValidate = true;
                            return null;
                          }
                          emailValidate = false;
                          return Language.getLangPhrase(Phrase.pleaseEnterValidEmail);
                        },
                        onChanged: (value) => email = value,
                        maxLines: 1,
                        initialValue: email,
                        decoration: InputDecoration(
                          labelText: Language.getLangPhrase(Phrase.enterYourEmail),
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            passwordValidate = true;
                            return Language.getLangPhrase(Phrase.pleaseEnterYourPassword);
                          }
                          passwordValidate = false;
                          return null;
                        },
                        onChanged: (value) => password=value,
                        maxLines: 1,
                        initialValue: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: Language.getLangPhrase(Phrase.enterYourPassword),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(Language.getLangPhrase(Phrase.rememberMe)),
                        contentPadding: EdgeInsets.zero,
                        value: rememberValue,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (newValue) => setState(() => rememberValue = newValue!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      ElevatedButton(
                        onPressed: () {
                            if (_formKey.currentState!=null && (_formKey.currentState?.validate() ?? false)) {
                              Services.securityService.login(email, password).then((result) {
                                if (result) { // Successful
                                  AppNavigator.of(context).popAllAndPushNamed(AppRouter.homeRoute);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text(Language.getLangPhrase(Phrase.error)),
                                      content: Text(Language.getLangPhrase(Phrase.wrongLoginData)),
                                      actions: [
                                        TextButton(
                                          child: Text(Language.getLangPhrase(Phrase.ok)),
                                          onPressed: () => Navigator.pop(context))
                                      ],
                                    )
                                  );
                                }
                              });
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        ),
                        child: Text(
                          Language.getLangPhrase(Phrase.signInButton),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Language.getLangPhrase(Phrase.notRegisteredYet)),
                          TextButton(
                            onPressed: () => AppNavigator.of(context).popAllAndPushNamed(AppRouter.registerRoute),
                            child: Text(Language.getLangPhrase(Phrase.createAnAccount)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
