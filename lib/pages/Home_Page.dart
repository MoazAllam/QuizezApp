import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_academy/config/const.dart';
import 'package:expert_academy/models/subjectModel.dart';
import 'package:expert_academy/pages/AllQuizzes_Page.dart';
import 'package:expert_academy/provider/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  final _subjects = FirebaseFirestore.instance.collection('subjects');

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      appBar: appbar(),
      drawer: drawer(),
      body: StreamBuilder(
        stream: _subjects.snapshots(),
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
                            builder: (context) => Quizzes_Page(
                              id: documentSnapshot.id,
                              title: documentSnapshot['name'],
                            ),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            vertical: 20.0,
                          ),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black,
                            image: DecorationImage(
                              image: NetworkImage(documentSnapshot['image']),
                              fit: BoxFit.cover,
                              opacity: 0.25,
                            ),
                          ),
                          child: Text(
                            documentSnapshot['name'],
                            style:
                                MyStyles.headTextStyle.copyWith(fontSize: 40.0),
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
              "جميع المواد",
              style: MyStyles.headTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      backgroundColor: MyColors().backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: MyColors().mainColor),
            accountEmail: null,
            accountName: Text(
              user?.email ?? "User email",
              style: MyStyles.mediumTextStyle,
            ),
            currentAccountPicture: const FlutterLogo(),
          ),
          ListTile(
            leading: Icon(
              Icons.subject,
              color: MyColors().headTextColor,
            ),
            title: Text(
              'Subjects',
              style: MyStyles.smallTextStyle.copyWith(
                color: MyColors().headTextColor,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: MyColors().headTextColor,
            ),
            title: Text(
              'Logout',
              style: MyStyles.smallTextStyle.copyWith(
                color: MyColors().headTextColor,
              ),
            ),
            onTap: () => signOut(),
          ),
          AboutListTile(
            icon: Icon(
              Icons.info,
              color: MyColors().headTextColor,
            ),
            child: Text(
              'About app',
              style: MyStyles.smallTextStyle.copyWith(
                color: MyColors().headTextColor,
              ),
            ),
            applicationIcon: const Icon(
              Icons.local_play,
            ),
            applicationName: 'Expert Academy',
            applicationVersion: '1.0.25',
            applicationLegalese: '© 2022 expert academy',
            aboutBoxChildren: const [
              Text(
                  'This app for expert academy studesnts for submitting exams'),
            ],
          ),
        ],
      ),
    );
  }
}
