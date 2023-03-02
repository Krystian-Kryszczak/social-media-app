import '../../language/language.dart';

extension DatetimeFormatter on DateTime {

  String formatDateTimeAgo() { // TODO
    Duration difference = this.difference(DateTime.now());
    final String ago = Language.getLangPhrase(Phrase.ago);
    String when;
    int days =  difference.inDays;
    if (days > 365) { // years //
      String time = days >= 365*2
          ? '${(days/365) as int} ${Language.getLangPhrase(Phrase.years)}'
          : Language.getLangPhrase(Phrase.year);
      when = '$time $ago';
    } else if (days >= 30) { // months //
      String time = days >= 60
          ? '${(days/30) as int} ${Language.getLangPhrase(Phrase.months)}'
          : Language.getLangPhrase(Phrase.month);
      when = '$time $ago';
    } else if (days >= 7) { // weeks //
      String time = days >= 14
          ? '${(days/7) as int} ${Language.getLangPhrase(Phrase.weeks)}'
          : Language.getLangPhrase(Phrase.week);
      when = '$time $ago';
    } else if (difference.inHours >= 24) { // days //
      String time = difference.inHours >= 48
          ? '${difference.inHours} ${Language.getLangPhrase(Phrase.days)}'
          : Language.getLangPhrase(Phrase.day);
      when = '$time $ago';
    } else if (difference.inMinutes >= 60) { // hours //
      String time = difference.inHours > 1
          ? '${difference.inHours} ${Language.getLangPhrase(Phrase.hours)}'
          : Language.getLangPhrase(Phrase.hour);
      when = '$time $ago';
    } else if (difference.inSeconds >= 60) { // minutes //
      String time = difference.inMinutes > 1
          ? '${difference.inMinutes} ${Language.getLangPhrase(Phrase.minutes)}'
          : Language.getLangPhrase(Phrase.minute);
      when = '$time $ago';
    } else { // a moment ago //
      when = Language.getLangPhrase(Phrase.momentAgo);
    }
    return when;
  }
}
