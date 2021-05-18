import 'package:flutter/cupertino.dart';

class Poker {
  int point;

  //0红桃,1黑桃,2梅花,3方片
  int suit;
  bool canMove;
  bool isOpen;

  Poker(this.point, this.suit) {
    canMove = false;
    isOpen = false;
  }

  static List<Poker> allPoker() {
    List<Poker> pokers = [];
    for (int i = 1; i <= 13; i++) {
      for (int j = 0; j < 4; j++) {
        pokers.add(Poker(i, j));
      }
    }
    return pokers;
  }

  ImageProvider getImage() {
    if (isOpen) {
      String pictureName = '';
      switch (point) {
        case 11:
          pictureName += 'J';
          break;
        case 12:
          pictureName += 'Q';
          break;
        case 13:
          pictureName += 'K';
          break;
        case 1:
          pictureName += 'A';
          break;
        default:
          pictureName += point.toString();
      }
      switch (suit) {
        case 0:
          pictureName += 'H';
          break;
        case 1:
          pictureName += 'S';
          break;
        case 2:
          pictureName += 'C';
          break;
        case 3:
          pictureName += 'D';
      }
      return AssetImage('images/$pictureName.png');
    } else {
      return AssetImage('images/red_back.png');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Poker &&
          runtimeType == other.runtimeType &&
          point == other.point &&
          suit == other.suit &&
          canMove == other.canMove &&
          isOpen == other.isOpen;

  @override
  int get hashCode =>
      point.hashCode ^ suit.hashCode ^ canMove.hashCode ^ isOpen.hashCode;
}
