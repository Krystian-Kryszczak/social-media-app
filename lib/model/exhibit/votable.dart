import '../item.dart';

abstract class Votable extends Item {
  int rating;
  bool voted = false;
  bool voteValue = false; // true => voteUp | false => voteDown
  Votable({super.id, this.rating = 0});
  Future<int> getRating() async => rating;
// Future<bool> isVoted() async { // TODO
//   return vote_!=null;
// }
// Future<bool?> getVote() async { // TODO
//   return vote_;
// }
// Future<bool> vote(bool? vote) async { // true = rate up | false = rate down | null = not voted
//   if (vote_==vote) return false; // old value and new value mustn't be the same
//   if (vote_==null) { // vote can't be null because vote_!=vote
//     (vote!) ? rating++ : rating--; // changing null value to true/false -> rateUp or rateDown
//   } else if (vote==null) { // vote_ can't be null
//     (vote_!) ? rating-- : rating++; // changing bool value to null -> remove rateUp or remove rateDown
//   } else { // vote and vote_ can't be null
//     (vote_!) ? rating-=2 : rating+=2; // changing bool value to !bool -> jump to rateUp or jump to rateDown
//   }
//   vote_ = vote; // setting new value
//   // TODO communication with server
//   return true;
// }
  void voteUp() {
    if (voted) return;
    rating++;
    voteValue = true;
    voted = true;
  }
  void voteDown() {
    if (voted) return;
    rating--;
    voteValue = false;
    voted = true;
  }
  void cancelVote() {
    if (!voted) return;
    voteValue ? rating-- : rating++;
    voted = false;
  }
  bool isVoted() => voted;
}
