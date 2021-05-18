import 'package:solitaire/joker.dart';

abstract class Heap {
  final int maxSize;
  List<Joker> jokerList = [];

  Heap(this.maxSize);

  bool canPlace(Joker joker);

  bool place(Joker joker);

  Joker removeTop();

  bool canRemoveTop();

  Joker getTop(){
    if (jokerList.isNotEmpty){
      return jokerList.last;
    } else {
      return null;
    }
  }
}

class SuitPile extends Heap {
  SuitPile() : super(13);

  @override
  bool canPlace(Joker joker) {
    if (jokerList.length >= this.maxSize) {
      return false;
    }
    return (this.jokerList.isEmpty && joker.point == 1) ||
        (this.jokerList.last.suits == joker.suits &&
            this.jokerList.last.point + 1 == joker.point);
  }

  @override
  bool canRemoveTop() {
    return false;
  }

  @override
  bool place(Joker joker) {
    if (canPlace(joker)) {
      this.jokerList.add(joker);
      return true;
    } else {
      return false;
    }
  }

  @override
  Joker removeTop() {
    return null;
  }
}

class TablePile extends Heap {
  TablePile(List<Joker> jokerList) : super(54) {
    this.jokerList = jokerList;
    this.jokerList.forEach((element) => element.isOpen = false);
    this.jokerList.last.isOpen = true;
  }

  @override
  bool canPlace(Joker joker) {
    if (jokerList.isEmpty && joker.point == 13) {
      return true;
    } else if (jokerList.last.point == joker.point) {
      //互不相容的两种花色
      List<Suits> common1 = [Suits.Heart, Suits.Diamond];
      List<Suits> common2 = [Suits.Spade, Suits.Club];
      return (common1.contains(joker.suits) &&
              common2.contains(jokerList.last.suits) ||
          (common2.contains(joker.suits) &&
              common1.contains(jokerList.last.suits)));
    }
    return false;
  }

  @override
  bool canRemoveTop() {
    return jokerList.isNotEmpty;
  }

  @override
  bool place(Joker joker) {
    if (canPlace(joker)) {
      jokerList.add(joker);
      return true;
    }
    return false;
  }

  @override
  Joker removeTop() {
    if (canRemoveTop()) {
      Joker joker = this.jokerList.removeLast();
      if (!jokerList.last.isOpen) {
        jokerList.last.isOpen = true;
      }
      return joker;
    }
    return null;
  }
}

class DeskCard extends Heap {
  List<Joker> origin = [];

  DeskCard(this.origin) : super(28){
    this.jokerList = origin;
    jokerList.forEach((element) => element.isOpen = false);
  }

  @override
  bool canPlace(Joker joker) {
    return origin.contains(joker);
  }

  @override
  bool canRemoveTop() {
    return jokerList.isNotEmpty;
  }

  @override
  bool place(Joker joker) {
    if (canPlace(joker)) {
      joker.isOpen = false;
      if (jokerList.last.isOpen) {
        jokerList.last.isOpen = false;
      }
      jokerList.add(joker);
      return true;
    } else {
      return false;
    }
  }

  @override
  Joker removeTop() {
    if (canRemoveTop()) {
      return jokerList.removeLast();
    }
    return null;
  }
}

class DisCard extends Heap {
  List<Joker> origin = [];

  DisCard(this.origin) : super(28);

  @override
  bool canPlace(Joker joker) {
    return origin.contains(joker);
  }

  @override
  bool canRemoveTop() {
    return jokerList.isNotEmpty;
  }

  @override
  bool place(Joker joker) {
    joker.isOpen = true;
    jokerList.add(joker);
    return true;
  }

  @override
  Joker removeTop() {
    if (canRemoveTop()) {
      return jokerList.removeLast();
    }
    return null;
  }
}
