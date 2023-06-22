import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(CupertinoIcons.back,color: Colrs.black,),
        // actions: [Icon(CupertinoIcons.search,color: black,)],
        // backgroundColor: primaryColor,elevation: 0,
        ),
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.03),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 25, right: 20, left: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.bar_chart),
                              Icon(Icons.person_2_outlined)
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: _firestore
                                .collection('users')
                                .doc(_auth.currentUser?.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> userMap =
                                snapshot.data!.data() as Map<String, dynamic>;
                                String? imageUrl = userMap['image_url']
                                as String?; // Retrieve the image URL

                                return Column(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: imageUrl != null
                                            ? DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: (size.width - 40) * 0.6,
                                      child: Column(
                                        children: [
                                          Text(
                                            userMap['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            userMap['status'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: kTextColor,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                userMap['role'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: CupertinoColors.systemBlue,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  userMap['role'] == "User"
                                                      ? Icon(
                                                    Icons.safety_check,
                                                    color: Colors.pink,
                                                    size: 40,
                                                  )
                                                      : Icon(
                                                    CupertinoIcons
                                                        .check_mark_circled_solid,
                                                    color: Colors.blue,
                                                    size: 40,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            userMap['gender'] == "female"
                                                ? Icon(
                                              Icons.female_outlined,
                                              color: Colors.pink,
                                              size: 40,
                                            )
                                                : Icon(
                                              Icons.male_outlined,
                                              color: Colors.blue,
                                              size: 40,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              userMap['age'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: kTextColor),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Age",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w100,
                                                  color: kTextColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Container(); // or any other widget to return
                              }
                            },
                          ),
                        ],
                      ),
                    ))
              ],
            )));
  }
}
