import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_academy/config/primaryButton.dart';
import 'package:expert_academy/pages/Home_Page.dart';
import 'package:flutter/material.dart';

import '../config/const.dart';

class QuestionPage extends StatefulWidget {
  final String title, id, parentId;
  final double time;
  const QuestionPage({
    Key? key,
    required this.title,
    required this.id,
    required this.parentId,
    required this.time,
  }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> allScores = [];
  int selectedPage = 0;
  int score = 0;
  int totalQuestion = 0;
  bool isSelected = false;

  late Timer _timer;
  double start = 0;

  final PageController _pageController = PageController();

  void startTimer() {
    const oneMin = Duration(minutes: 1);
    _timer = Timer.periodic(
      oneMin,
      (Timer timer) {
        setState(() {
          start--;
        });
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    start = widget.time;
    startTimer();
    Timer(Duration(minutes: widget.time.toInt()), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: score.toString(),
            totlaQuestions: totalQuestion.toString(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _questions = FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.parentId)
        .collection('quizzes')
        .doc(widget.id)
        .collection('questions');

    Future<void> _showMyDialog(sscore, solution) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: MyColors().backgroundColor,
            title: Text(
              'Soltion:',
              style: MyStyles.mediumTextStyle,
            ),
            content: Image.network(
              solution,
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      appBar: appbar(start.toString()),
      body: StreamBuilder(
        stream: _questions.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding,
              ),
              child: Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PageView.builder(
                      onPageChanged: (int page) {
                        setState(() {
                          selectedPage = page;
                        });
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        totalQuestion = snapshot.data!.docs.length;
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['question'],
                              style: MyStyles.smallTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            documentSnapshot['image'] == ""
                                ? Container()
                                : Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            documentSnapshot['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: documentSnapshot['options'].length,
                                  itemBuilder: (context, index) {
                                    final option = documentSnapshot['options']
                                        [index]['option'];

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isSelected = true;
                                          if (documentSnapshot['options'][index]
                                              ['score']) {
                                            score++;
                                          }
                                        });
                                        _showMyDialog(
                                          documentSnapshot['options'][index]
                                              ['score'],
                                          documentSnapshot['solution'],
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 10.0,
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? documentSnapshot['options']
                                                      [index]['score']
                                                  ? Colors.green
                                                  : Colors.red
                                              : MyColors().cardColor,
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ),
                                        child: Text(
                                          option,
                                          style: MyStyles.smallTextStyle,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            PrimaryButton(
                              color: isSelected
                                  ? MyColors().mainColor
                                  : const Color.fromARGB(31, 101, 65, 245),
                              textColor: isSelected
                                  ? MyColors().headTextColor
                                  : const Color.fromARGB(36, 255, 255, 255),
                              title:
                                  snapshot.data!.docs.length - selectedPage == 2
                                      ? "التالي"
                                      : "انهاء",
                              tap: () {
                                if (snapshot.data!.docs.length - selectedPage ==
                                    1) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScorePage(
                                        score: score.toString(),
                                        totlaQuestions:
                                            totalQuestion.toString(),
                                      ),
                                    ),
                                  );
                                  allScores.add(
                                      "${(score / snapshot.data!.docs.length) * 100}" +
                                          "%");
                                } else if (isSelected) {
                                  if (_pageController.hasClients) {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {
                                      isSelected = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      }),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  AppBar appbar(start) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        start + " (min)",
        style: MyStyles.mediumTextStyle,
      ),
      centerTitle: true,
      actions: [
        Container(
          padding: const EdgeInsets.only(
            right: defaultPadding,
          ),
          child: Text(
            widget.title,
            style: MyStyles.mediumTextStyle,
          ),
        ),
      ],
    );
  }
}

class ScorePage extends StatelessWidget {
  final String score;
  final String totlaQuestions;
  const ScorePage({
    Key? key,
    required this.score,
    required this.totlaQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your score is',
              style: MyStyles.headTextStyle,
            ),
            Text(
              score + "/" + totlaQuestions,
              style: MyStyles.headTextStyle,
            ),
            const SizedBox(
              height: 50.0,
            ),
            PrimaryButton(
              color: MyColors().mainColor,
              textColor: MyColors().headTextColor,
              title: "الرجوع للصفحة الرئيسسة",
              tap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
