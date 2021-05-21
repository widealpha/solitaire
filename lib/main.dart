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
      debugShowCheckedModeBanner: false,
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
  List<List<List<Poker>>> status = [];
  List<List<List<Poker>>> regretList = [];
  List<Poker> allPokers;
  List<PokerHeap> topHeapList;
  List<PokerHeap> tableHeapList;
  DisHeap disHeap;
  DeckHeap deckHeap;
  int seed = 0;

  @override
  void initState() {
    super.initState();
    seed = Random().nextInt(23456789);
    // cheat();
    start(Random(seed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: status.isNotEmpty
                  ? () {
                      setState(() {
                        regret();
                      });
                    }
                  : null,
              icon: Icon(Icons.arrow_back)),
          // IconButton(
          //     onPressed: regretList.isNotEmpty
          //         ? () {
          //             setState(() {
          //               forward();
          //             });
          //           }
          //         : null,
          //     icon: Icon(Icons.arrow_forward)),
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
          TextButton(onPressed: (){
            setState(() {
              cheat();
            });
          }, child: Text('作弊模式'))
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
                      copyStatus();
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
              ]..addAll(topHeapList
                  .map((heap) => SuitPile(
                        heap: heap,
                        onDragEnd: (detail) {
                          if (detail.wasAccepted) {
                            setState(() {
                              heap.removeLast();
                            });
                          }
                        },
                        onAccept: (Poker poker) {
                          copyStatus();
                          setState(() {
                            heap.put(poker);
                          });
                          int count = 0;
                          topHeapList
                              .forEach((heap) => count += heap.pokers.length);
                          if (count == 52) {
                            showWin();
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
                          onDragEnd: (detail, poker) {
                            if (detail.wasAccepted) {
                              setState(() {
                                if (poker == e.topPoker()){
                                  e.removeLast();
                                } else {
                                  e.removeAfter(e.pokers.indexOf(poker));
                                }
                                e.topPoker()?.isOpen = true;
                              });
                            }
                          },
                          onAccept: (Poker poker) {
                            copyStatus();
                            setState(() {
                              List<Poker> as = afterPokers(poker);
                              if (as.length == 0){
                                e.put(poker);
                              } else {
                                e.putList(as);
                              }
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

  List<Poker> afterPokers(Poker poker){
    List l;
    tableHeapList.forEach((element) {
      if (element.pokers.contains(poker)){
        int index = element.pokers.indexOf(poker);
        l = element.pokers.sublist(index);
      }
    });
    return l;
  }

  void cheat() {
    status = [];
    regretList = [];
    allPokers = Poker.allPoker();
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
      tableHeapList[i].pokers.addAll(allPokers.sublist(start, end).reversed.toList());
      tableHeapList[i].topPoker().isOpen = true;
    }
    deckHeap.pokers.clear();
    deckHeap.pokers.addAll(allPokers.sublist(28).reversed.toList());
  }

  void start(Random random) {
    status = [];
    regretList = [];
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

  void copyStatus() {
    List<List<Poker>> singleState = [];
    singleState.add(allPokers);
    topHeapList?.forEach((element) {
      singleState.add(List.of(element.pokers));
    });
    tableHeapList?.forEach((element) {
      singleState.add(List.of(element.pokers));
    });
    singleState.add(List.of(disHeap.pokers));
    singleState.add(List.of(deckHeap.pokers));
    status.add(singleState);
  }

  void regret() {
    if (status.isNotEmpty) {
      int point = 0;
      List<List<Poker>> pokerStatus = status.removeLast();
      allPokers.clear();
      allPokers.addAll(pokerStatus[point++]);
      topHeapList.forEach((element) {
        element.pokers.clear();
        element.pokers.addAll(pokerStatus[point++]);
      });
      tableHeapList?.forEach((element) {
        element.pokers.clear();
        element.pokers.addAll(pokerStatus[point++]);
      });
      disHeap.pokers.clear();
      disHeap.pokers.addAll(pokerStatus[point++]);
      deckHeap.pokers.clear();
      deckHeap.pokers.addAll(pokerStatus[point++]);
      regretList.add(pokerStatus);
    }
  }

  void forward() {
    if (regretList.isNotEmpty) {
      int point = 0;
      List<List<Poker>> pokerStatus = regretList.removeLast();
      allPokers.clear();
      allPokers.addAll(pokerStatus[point++]);
      topHeapList.forEach((element) {
        element.pokers.clear();
        element.pokers.addAll(pokerStatus[point++]);
      });
      tableHeapList?.forEach((element) {
        element.pokers.clear();
        element.pokers.addAll(pokerStatus[point++]);
      });
      disHeap.pokers.clear();
      disHeap.pokers.addAll(pokerStatus[point++]);
      deckHeap.pokers.clear();
      deckHeap.pokers.addAll(pokerStatus[point++]);
      regretList.add(pokerStatus);
      status.add(pokerStatus);
    }
  }

  void showWin() {
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
                      setState(() {
                        seed = Random().nextInt(1234556);
                        start(Random(seed));
                      });
                    },
                    child: Text('再来一局')),
              ],
            ));
  }
}
