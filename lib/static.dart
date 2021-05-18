import 'package:solitaire/joker.dart';

import 'heap.dart';

class HeapData {
  static Plate plate;

  HeapData() {
    plate = Plate();
  }
}

class Plate {
  Heap disCard;
  Heap deckCard;
  List<Heap> tablePiles = [];
  List<Heap> suitPiles = [];

  Plate() {
    createPlate();
  }

  void createPlate() {
    List<Joker> allJokers = Joker.allJoker();
    //洗牌
    allJokers.shuffle();
    suitPiles = List.generate(4, (_) => SuitPile());
    tablePiles = List.generate(7, (index) {
      int start = (index + 1) * (index + 2) ~/ 2;
      int end = (index + 2) * (index + 3) ~/ 2;
      return TablePile(allJokers.sublist(start - 1, end - 2));
    });
    disCard = DisCard(allJokers.sublist(26));
    deckCard = DeskCard(allJokers.sublist(26));
  }

  bool transfer(Heap heap){
    
  }
}
