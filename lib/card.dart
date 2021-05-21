import 'package:flutter/material.dart';
import 'package:solitaire/poker.dart';
import 'package:solitaire/poker_heap.dart';

class PokerCard extends StatefulWidget {
  final Poker poker;
  final void Function() onClick;
  final void Function(DraggableDetails details) onDragEnd;
  final PokerHeap heap;

  const PokerCard(
      {Key key, this.poker, this.onClick, this.onDragEnd, this.heap})
      : super(key: key);

  @override
  _PokerCardState createState() => _PokerCardState();
}

class _PokerCardState extends State<PokerCard> {
  Poker _poker;

  @override
  void initState() {
    _poker = widget.poker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _poker = widget.poker;
    return GestureDetector(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick();
          setState(() {
            _poker = widget.poker;
            _poker.isOpen = false;
          });
        }
      },
      child: _poker?.isOpen ?? true ? Draggable(
        child: _poker != null
            ? Container(
                width: 64,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(image: _poker.getImage())),
              )
            : Container(),
        data: _poker,
        childWhenDragging: childWhenDrag(),
        feedback: _poker != null
            ? Container(
                width: 64,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(image: _poker.getImage())),
              )
            : Container(),
        onDragEnd: (detail) {
          if (detail.wasAccepted) {
            setState(() {
              _poker = null;
            });
          }
          if (widget.onDragEnd != null) {
            widget.onDragEnd(detail);
          }
        },
      ) : Container(
        width: 64,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(image: _poker.getImage())),
      ),
    );
  }

  Widget childWhenDrag() {
    if (widget.heap == null) {
      return Container();
    }
    var ps = widget.heap.pokers;
    if (ps.isEmpty || ps.length == 1) {
      return Container();
    } else {
      return Container(
        width: 64,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(image: ps[ps.length - 2].getImage())),
      );
    }
  }
}

class SuitPile extends StatefulWidget {
  final PokerHeap heap;
  final void Function(Poker) onAccept;
  final void Function(DraggableDetails details) onDragEnd;

  const SuitPile({Key key, this.heap, this.onAccept, this.onDragEnd})
      : super(key: key);

  @override
  _SuitPileState createState() => _SuitPileState();
}

class _SuitPileState extends State<SuitPile> {
  PokerHeap _heap;

  @override
  void initState() {
    super.initState();
    _heap = widget.heap;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (_, __, ___) {
        return Card(
          child: Container(
            width: 64,
            height: 100,
            alignment: Alignment.center,
            child: _heap.pokers.isEmpty
                ? Container()
                : PokerCard(
                    poker: _heap.pokers.last,
                    heap: widget.heap,
                    onDragEnd: widget.onDragEnd,
                  ),
          ),
        );
      },
      onWillAccept: (data) {
        if (data is Poker) {
          return _heap.canPut(data);
        }
        return false;
      },
      onAccept: (data) {
        if (widget.onAccept != null) {
          widget.onAccept(data);
        }
      },
    );
  }
}

class DeskPile extends StatefulWidget {
  final PokerHeap heap;
  final void Function(DraggableDetails details, Poker poker) onDragEnd;
  final void Function(Poker) onAccept;

  const DeskPile({Key key, this.heap, this.onDragEnd, this.onAccept})
      : super(key: key);

  @override
  _DeskPileState createState() => _DeskPileState();
}

class _DeskPileState extends State<DeskPile> {
  PokerHeap _heap;

  @override
  void initState() {
    _heap = widget.heap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (_, __, ___) {
        return Stack(
          children: _heap.pokers.asMap().entries.map((e) {
            return Positioned(
              top: 20.0 * e.key,
              child: PokerCard(
                poker: e.value,
                onDragEnd: (detail) {
                  if (widget.onDragEnd != null) {
                    widget.onDragEnd(detail, e.value);
                  }
                },
              ),
            );
          }).toList(),
        );
      },
      onAccept: (data) {
        if (data is Poker) {
          if (widget.onAccept != null) {
            widget.onAccept(data);
          }
        }
      },
      onWillAccept: (data) {
        if (data is Poker) {
          if (!_heap.pokers.contains(data)) {
            return _heap.canPut(data);
          } else {
            return false;
          }
        } else {
          return false;
        }
      },
    );
  }
}

class DisPile extends StatefulWidget {
  final DisHeap heap;
  final void Function(DraggableDetails details) onDragEnd;

  const DisPile({
    Key key,
    this.heap,
    this.onDragEnd,
  }) : super(key: key);

  @override
  _DisPileState createState() => _DisPileState();
}

class _DisPileState extends State<DisPile> {
  DisHeap _heap;

  @override
  void initState() {
    _heap = widget.heap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_heap.pokers.isEmpty) {
      return Container(
        width: 64,
        height: 100,
      );
    }
    _heap.topPoker().isOpen = true;
    return PokerCard(
      poker: _heap.topPoker(),
      heap: _heap,
      onDragEnd: (detail) {
        if (widget.onDragEnd != null) {
          widget.onDragEnd(detail);
        }
      },
    );
  }
}

class DeckPile extends StatefulWidget {
  final DeckHeap heap;
  final void Function(Poker poker) onClick;

  const DeckPile({Key key, this.heap, this.onClick}) : super(key: key);

  @override
  _DeckPileState createState() => _DeckPileState();
}

class _DeckPileState extends State<DeckPile> {
  DeckHeap _heap;

  @override
  void initState() {
    _heap = widget.heap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_heap.pokers.isEmpty) {
      return GestureDetector(
        onTap: () {
          if (widget.onClick != null) {
            widget.onClick(null);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.grey)),
          width: 64,
          height: 100,
          alignment: Alignment.center,
          child: Icon(
            Icons.block,
            color: Colors.yellow,
          ),
        ),
      );
    }
    _heap.topPoker().isOpen = false;
    return PokerCard(
      poker: _heap.topPoker(),
      onClick: () {
        widget.onClick(_heap.topPoker());
      },
    );
  }
}
