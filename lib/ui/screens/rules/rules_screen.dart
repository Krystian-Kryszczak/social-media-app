import 'package:flutter/material.dart';
import 'package:frontend/model/rules/rules.dart';
import 'package:frontend/service/services.dart';
import 'package:frontend/ui/widget/snapshot/snapshot_handler.dart';

import '../../../language/language.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Future<Rules> rules = Services.rulesService.fetchRules().timeout(const Duration(seconds: 15));
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.getLangPhrase(Phrase.rules)),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: rules,
          builder: (context, snapshot) => SnapshotHandler(context: context, snapshot: snapshot,
            onSuccess: _RulesContent(content: snapshot.data),
            inCenterErrorInfo: true,
          )
        )
      ),
    );
  }
}

class _RulesContent extends StatelessWidget {
  final Rules? content;

  const _RulesContent({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(){
            List<Widget> list = [];
              content?.sections.forEach((key, value) {
              list.add(
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    padding: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(key, style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600
                        )),
                        const SizedBox(height: 8.0),
                        Text(value)
                      ],
                    ),
                  )
              );
              list.add(const SizedBox(height: 12.0));
            });
            return list;
          }(),
          const SizedBox(height: 18),
          Center(
            child: Text('${Language.getLangPhrase(Phrase.lastUpdate)}: ${content?.createdTime.toString().substring(0, 16)}'), // year-month-day hour:minutes
          )
        ],
      ),
    );
  }
}
