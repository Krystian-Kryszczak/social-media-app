import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/launch/navigator/app_navigator.dart';
import 'package:frontend/service/security/security_service.dart';
import 'package:frontend/service/services.dart';

import '../../../language/language.dart';
import '../../../launch/routes/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email, name, lastname, password;
  SecurityService securityService = Services.securityService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  Language.getLangPhrase(Phrase.register),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (v) => _validateName(v) ? null : Language.getLangPhrase(Phrase.pleaseEnterYourName),
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: Language.getLangPhrase(Phrase.name),
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              validator: (v) => _validateLastname(v) ? null : Language.getLangPhrase(Phrase.pleaseEnterYourSurname),
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: Language.getLangPhrase(Phrase.surname),
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (v) => _validateEmail(v) ? null : Language.getLangPhrase(Phrase.pleaseEnterValidEmail),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: Language.getLangPhrase(Phrase.enterYourEmail),
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (v) => _validatePassword(v) ? null : Language.getLangPhrase(Phrase.pleaseEnterYourPassword),
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: Language.getLangPhrase(Phrase.enterYourPassword),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() && (email!=null&&email!.isNotEmpty&&name!=null&&name!.isNotEmpty&&lastname!=null&&lastname!.isNotEmpty&&password!=null&&password!.isNotEmpty)) {
                            securityService.register(email: email!, firstname: name!, lastname: lastname!, password: password!)
                              .then((result) {
                                if (result) {
                                  log('Successful registration!');
                                  AppNavigator.of(context).popAllAndPushNamed(AppRouter.activateAccountRoute, arguments: email!);
                                  return true;
                                }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text(Language.getLangPhrase(Phrase.error)),
                                      content: Text(Language.getLangPhrase(Phrase.registerConflict)),
                                      actions: [
                                        TextButton(
                                          child: Text(Language.getLangPhrase(Phrase.ok)),
                                          onPressed: () => Navigator.pop(context))
                                      ],
                                    )
                                );
                                return false;
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text(Language.getLangPhrase(Phrase.error)),
                                    content: Text(Language.getLangPhrase(Phrase.registerFailed)),
                                    semanticLabel: email,
                                    actions: [
                                      TextButton(
                                        child: Text(Language.getLangPhrase(Phrase.ok)),
                                        onPressed: () => Navigator.pop(context))
                                    ],
                                  )
                                );
                                log(error.toString());
                                log(stackTrace.toString());
                                return false;
                              });
                        }},
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(40, 15, 40, 15)),
                        child: Text(
                          Language.getLangPhrase(Phrase.registerButton),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Language.getLangPhrase(Phrase.alreadyRegistered)),
                          TextButton(
                            onPressed: () => AppNavigator.of(context).popAllAndPushNamed(AppRouter.loginRoute),
                            child: Text(Language.getLangPhrase(Phrase.signIn)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateName(String? name) {
    if (!SecurityService.validateName(name)) return false;
    this.name = name;
    return true;
  }

  bool _validateLastname(String? lastname) {
    if (!SecurityService.validateSurname(lastname)) return false;
    this.lastname = lastname;
    return true;
  }

  bool _validateEmail(String? email) {
    if (!SecurityService.validateEmail(email)) return false;
    this.email = email;
    return true;
  }

  bool _validatePassword(String? password) {
    if (!SecurityService.validatePassword(password)) return false;
    this.password = password;
    return true;
  }
}
