import 'dart:io';
import 'dart:math';

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
  int seed;

  @override
  void initState() {
    super.initState();
    seed = Random().nextInt(23456789);
    start(Random(seed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  start(Random(seed));
                });
              },
              child: Text(
                '重新开始本局',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                setState(() {
                  seed = Random().nextInt(23456789);
                  start(Random(seed));
                });
              },
              child: Text(
                '重新开始游戏',
                style: TextStyle(color: Colors.white),
              )),
        ],
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
                        setState(() {
                          disHeap.removeLast();
                        });
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                // SuitPile(
                //   heap: topHeapList[0],
                //   onAccept: (Poker poker) {
                //     setState(() {
                //       topHeapList[0].put(poker);
                //     });
                //   },
                // ),
                // SuitPile(
                //   heap: topHeapList[1],
                //   onAccept: (Poker poker) {
                //     setState(() {
                //       topHeapList[1].put(poker);
                //     });
                //   },
                // ),
                // SuitPile(
                //   heap: topHeapList[2],
                //   onAccept: (Poker poker) {
                //     setState(() {
                //       topHeapList[2].put(poker);
                //     });
                //   },
                // ),
                // SuitPile(
                //   heap: topHeapList[3],
                //   onAccept: (Poker poker) {
                //     setState(() {
                //       topHeapList[3].put(poker);
                //     });
                //   },
                // ),
              ]..addAll(topHeapList
                  .map((heap) => SuitPile(
                        heap: heap,
                        onAccept: (Poker poker) {
                          setState(() {
                            heap.put(poker);
                          });
                          int count = 0;
                          topHeapList
                              .forEach((heap) => count += heap.pokers.length);
                          if (count == 52) {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => AlertDialog(
                                      title: Text('恭喜您获胜了'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              exit(0);
                                            },
                                            child: Text('退出')),
                                        TextButton(
                                            onPressed: () {
                                              seed = Random().nextInt(1234556);
                                              start(Random(seed));
                                            },
                                            child: Text('再来一局')),
                                      ],
                                    ));
                          }
                        },
                      ))
                  .toList()),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tableHeapList
                    .map(
                      (e) => Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(12),
                        child: DeskPile(
                          heap: e,
                          onDragEnd: (detail) {
                            if (detail.wasAccepted) {
                              setState(() {
                                e.removeLast();
                                e.topPoker()?.isOpen = true;
                              });
                            }
                          },
                          onAccept: (Poker poker) {
                            setState(() {
                              e.put(poker);
                            });
                          },
                        ),
                      )),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void start(Random random) {
    if (allPokers == null) {
      allPokers = Poker.allPoker();
      allPokers.shuffle(random);
      disHeap = DisHeap();
      topHeapList = List.generate(4, (_) => SuitHeap());
      tableHeapList = List.generate(7, (index) {
        int start = index * (index + 1) ~/ 2;
        int end = (index + 1) * (index + 2) ~/ 2;
        var heap = TableHeap(allPokers.sublist(start, end));
        //翻开第一张
        heap.topPoker().isOpen = true;
        return heap;
      });
      deckHeap = DeckHeap(allPokers.sublist(28));
    } else {
      allPokers = Poker.allPoker();
      allPokers.shuffle(random);
      allPokers.forEach((poker) => poker.isOpen = false);
      disHeap.pokers.clear();
      topHeapList.forEach((heap) {
        heap.pokers.clear();
      });
      tableHeapList.forEach((heap) {
        heap.pokers.clear();
      });

      for (int i = 0; i < 7; i++) {
        tableHeapList[i].pokers.clear();
        int start = i * (i + 1) ~/ 2;
        int end = (i + 1) * (i + 2) ~/ 2;
        tableHeapList[i].pokers.addAll(allPokers.sublist(start, end));
        tableHeapList[i].topPoker().isOpen = true;
      }
      deckHeap.pokers.clear();
      deckHeap.pokers.addAll(allPokers.sublist(28));
    }
  }
}
