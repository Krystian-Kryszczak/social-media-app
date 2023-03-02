import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/launch/navigator/app_navigator.dart';

import 'package:frontend/launch/routes/app_router.dart';

import '../../../language/language.dart';
import '../../../service/services.dart';

class ActivateAccountScreen extends StatefulWidget {
  const ActivateAccountScreen({
    super.key
  });

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String activationCode = '';
  bool validCodeSyntax = false;

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String? ?? (){
      Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, AppRouter.loginRoute));
      return '';
    }();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  Language.getLangPhrase(Phrase.accountActivation),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  )),
                const SizedBox(height: 24),
                Text(
                  Language.getLangPhrase(Phrase.activateAccountInfo) + email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          log('Activation code value: $value');
                          if (value!.isEmpty) return Language.getLangPhrase(Phrase.enterActivationCode);
                          if (value.length == 5) {
                            validCodeSyntax = true;
                            log('Code is valid.');
                            return null;
                          }
                          log('Code is invalid.');
                          validCodeSyntax = false;
                          return Language.getLangPhrase(Phrase.invalidActivationCode);
                        },
                        onChanged: (value) => activationCode = value,
                        maxLines: 1,
                        initialValue: activationCode,
                        decoration: InputDecoration(
                          labelText: Language.getLangPhrase(Phrase.enterActivationCode),
                          prefixIcon: const Icon(Icons.key),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!=null && (_formKey.currentState?.validate() ?? false)) {
                            Services.securityService.activateAccount(email: email, code: activationCode).then((result) {
                              if (result) { // Successful
                                log('Activation code is correct!');
                                AppNavigator.of(context).popAllAndPushNamed(AppRouter.loginRoute, arguments: email);
                              } else { // Incorrect activation code
                                log('Activation code is incorrect!');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text(Language.getLangPhrase(Phrase.error)),
                                    content: Text(Language.getLangPhrase(Phrase.invalidActivationCode)),
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
                          Language.getLangPhrase(Phrase.activate),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
