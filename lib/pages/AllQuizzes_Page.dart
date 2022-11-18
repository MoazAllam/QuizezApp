import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_academy/pages/Question_Page.dart';
import 'package:flutter/material.dart';

import '../config/const.dart';

class Quizzes_Page extends StatelessWidget {
  final String id, title;
  Quizzes_Page({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _quizzes = FirebaseFirestore.instance
        .collection('subjects')
        .doc(id)
        .collection('quizzes');

    return Scaffold(
      appBar: appbar(),
      backgroundColor: MyColors().backgroundColor,
      body: StreamBuilder(
        stream: _quizzes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionPage(
                              id: documentSnapshot.id,
                              title: documentSnapshot['title'],
                              time: documentSnapshot['time(min)'].toDouble(),
                              parentId: id,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: defaultPadding,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            tileColor: MyColors().cardColor,
                            title: Text(
                              documentSnapshot['title'],
                              style: MyStyles.headTextStyle,
                            ),
                            subtitle: Text(
                              documentSnapshot['description'],
                              style: MyStyles.smallTextStyle,
                            ),
                            trailing: Text(
                              documentSnapshot['time(min)'].toString() + ' min',
                              style: MyStyles.mediumTextStyle,
                            ),
                          ),
                        ),
                      );
                    }),
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

  AppBar appbar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: MyStyles.headTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
