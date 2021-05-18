import 'dart:math';

class Joker {
  int point;
  Suits suits;
  bool isOpen;
  bool canMove;
  Joker.simple(this.point, this.suits){
    isOpen = false;
    canMove = false;
  }

  Joker.suitNum(this.point, int suitId){
    switch(suitId){
      case 0:
        suits = Suits.Heart;
        break;
      case 1:
        suits = Suits.Spade;
        break;
      case 2:
        suits = Suits.Diamond;
        break;
      case 3:
        suits = Suits.Club;
        break;
    }
    isOpen = false;
    canMove = false;
  }


  Joker(this.point, this.suits, this.isOpen, this.canMove);

  static List<Joker> allJoker(){
    List <Joker> jokers = [];
    for (Suits suit in Suits.values){
      for (int i = 1; i <= 13; i++){
        jokers.add(Joker(i, suit, false, false));
      }
    }
    return jokers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Joker &&
          runtimeType == other.runtimeType &&
          point == other.point &&
          suits == other.suits;

  @override
  int get hashCode => point.hashCode ^ suits.hashCode;

  @override
  String toString() {
    return '$point,$suits';
  }
}

//花色
enum Suits {
  //黑桃
  Spade,
  //红心
  Heart,
  //梅花
  Club,
  //方片
  Diamond,
}


