import 'package:solitaire/poker.dart';

abstract class PokerHeap {
  List<Poker> pokers = [];

  bool canRemoveLast();

  bool canRemoveAfter(int index);

  bool canPut(Poker poker);

  bool canPutList(List<Poker> pokerList);

  Poker topPoker() {
    if (pokers.isEmpty) {
      return null;
    }
    return pokers.last;
  }

  bool put(Poker poker) {
    if (canPut(poker)) {
      pokers.add(poker);
      return true;
    }
    return false;
  }

  bool putList(List<Poker> pokerList);

  Poker removeLast() {
    if (canRemoveLast()) {
      return pokers.removeLast();
    }
    return null;
  }

  List<Poker> removeAfter(int index) {
    if (canRemoveAfter(index)) {
      return pokers.sublist(index);
    } else {
      return [];
    }
  }

  bool moveLastTo(PokerHeap heap) {
    if (canRemoveLast() && heap.canPut(pokers.last)) {
      heap.put(removeLast());
      return true;
    }
    return false;
  }

  bool moveAfterTo(int index, PokerHeap heap) {
    if (canRemoveAfter(index) && canPutList(pokers.sublist(index))) {
      heap.putList(removeAfter(index));
      return true;
    }
    return false;
  }
}

class TableHeap extends PokerHeap {
  TableHeap(List<Poker> pokers) {
    this.pokers = pokers;
  }

  @override
  bool canPut(Poker poker) {
    if (pokers.isEmpty && poker.point == 13) {
      return true;
    } else if (pokers.last.point == poker.point + 1 &&
        pokers.last.suit + poker.suit != 3) {
      //不等于3就是花色颜色不同
      return true;
    } else {
      return false;
    }
  }

  @override
  bool canRemoveAfter(int index) {
    if (index >= pokers.length) {
      return false;
    } else {
      for (int i = index; i < pokers.length; i++) {
        if (!pokers[index].isOpen) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  bool canRemoveLast() {
    if (pokers.isEmpty) {
      return false;
    }
    return pokers.last.isOpen;
  }

  @override
  bool canPutList(List<Poker> pokerList) {
    if (pokerList.isEmpty) {
      return false;
    }
    return canPut(pokerList[0]);
  }

  @override
  bool putList(List<Poker> pokerList) {
    if (canPutList(pokerList)) {
      pokers.addAll(pokerList);
      return true;
    }
    return false;
  }
}

class SuitHeap extends PokerHeap {
  @override
  bool canPut(Poker poker) {
    if (pokers.isEmpty && poker.point == 1) {
      return true;
    } else if (pokers.last.point + 1 == poker.point &&
        poker.suit == pokers.last.suit) {
      return true;
    }
    return false;
  }

  @override
  bool canPutList(List<Poker> pokerList) {
    return false;
  }

  @override
  bool canRemoveAfter(int index) {
    return false;
  }

  @override
  bool canRemoveLast() {
    return true;
  }

  @override
  bool putList(List<Poker> pokerList) {
    return false;
  }
}

class DeckHeap extends PokerHeap {
  DeckHeap(List<Poker> pokers) {
    this.pokers = pokers;
  }

  @override
  bool canPut(Poker poker) {
    return false;
  }

  @override
  bool canPutList(List<Poker> pokerList) {
    return false;
  }

  @override
  bool canRemoveAfter(int index) {
    return false;
  }

  @override
  bool canRemoveLast() {
    return pokers.isNotEmpty;
  }

  @override
  bool putList(List<Poker> pokerList) {
    return false;
  }

  void insert(Poker poker) {
    poker.isOpen = false;
    pokers.insert(0, poker);
  }
}

class DisHeap extends PokerHeap {
  @override
  bool canPut(Poker poker) {
    return false;
  }

  @override
  bool canPutList(List<Poker> pokerList) {
    return false;
  }

  @override
  bool canRemoveAfter(int index) {
    return false;
  }

  @override
  bool canRemoveLast() {
    return pokers.isNotEmpty;
  }

  @override
  bool putList(List<Poker> pokerList) {
    return false;
  }

  void insert(Poker poker) {
    poker.isOpen = true;
    pokers.add(poker);
  }
}
