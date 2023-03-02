import '../../language/language.dart';

extension ExhibitFormatter on int {

  String formatCount() { // TODO
    String value = toString();
    if (this >= 1000) { // more or equal thousand
      if (this < 1000000) { // less than million
        value = '${(this / 1000).floor()} ${Language.getLangPhrase(Phrase.thousands)}';
      } else if (this < 1000000000) { // less than billion
        value = '${(this / 1000000).floor()} ${Language.getLangPhrase(Phrase.millions)}';
      } else { // more than billion
        value = '${(this / 1000000000).floor()} ${Language.getLangPhrase(Phrase.billions)}';
      }
    }
    return '$value ${Language.getLangPhrase(Phrase.views)}';
  }
}
