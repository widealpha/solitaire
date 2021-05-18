import 'package:flutter/material.dart';
import 'package:solitaire/card.dart';
import 'package:solitaire/poker.dart';
import 'package:solitaire/poker_heap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '纸牌游戏',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '纸牌游戏'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Poker> allPokers;
  List<PokerHeap> topHeapList;
  List<PokerHeap> tableHeapList;
  DisHeap disHeap;
  DeckHeap deckHeap;
  Poker temp;

  @override
  void initState() {
    // HeapData();
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DeckPile(
                    heap: deckHeap,
                    onClick: (Poker poker) {
                      if (poker == null) {
                        deckHeap.pokers.addAll(disHeap.pokers.reversed);
                        disHeap.pokers.removeWhere((_) => true);
                      } else {
                        disHeap.insert(deckHeap.removeLast());
                      }
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DisPile(
                    heap: disHeap,
                    onDragEnd: (detail) {
                      if (detail.wasAccepted) {
                        disHeap.removeLast();
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                SuitPile(
                  heap: topHeapList[0],
                  onAccept: (Poker poker) {
                    setState(() {
                      topHeapList[0].put(poker);
                    });
                  },
                ),
                SuitPile(
                  heap: topHeapList[1],
                  onAccept: (Poker poker) {
                    setState(() {
                      topHeapList[1].put(poker);
                    });
                  },
                ),
                SuitPile(
                  heap: topHeapList[2],
                  onAccept: (Poker poker) {
                    setState(() {
                      topHeapList[2].put(poker);
                    });
                  },
                ),
                SuitPile(
                  heap: topHeapList[3],
                  onAccept: (Poker poker) {
                    setState(() {
                      topHeapList[3].put(poker);
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tableHeapList
                    .map((e) => DeskPile(
                        heap: e,
                        onDragEnd: (detail) {
                          if (detail.wasAccepted) {
                            disHeap.removeLast();
                          }
                        }))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void start() {
    allPokers = Poker.allPoker();
    allPokers.shuffle();
    disHeap = DisHeap();
    topHeapList = List.generate(4, (_) => SuitHeap());
    tableHeapList = List.generate(7, (index) {
      int start = (index + 1) * (index + 2) ~/ 2;
      int end = (index + 2) * (index + 3) ~/ 2;
      return TableHeap(allPokers.sublist(start - 1, end - 2));
    });
    deckHeap = DeckHeap(allPokers.sublist(26));
  }
}
