// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoalCard extends StatefulWidget {
  GoalCard({
    super.key,
    required this.width,
    required this.height,
    required this.goalName,
    required this.current,
    required this.finalBalance,
    required this.date,
    required this.onTap,
    required this.img,
  });

  final double width;
  final double height;
  final String goalName;
  final String current;
  final String finalBalance;
  final String date;
  final String img;
  void Function()? onTap;

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return FadeInUp(
      delay: Duration(milliseconds: 250),
      curve: Curves.decelerate,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: widget.width * 0.05, vertical: widget.height * 0.015),
          width: widget.width,
          height: widget.height * 0.28,
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: widget.width * 0.05),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(widget.img, width: 80, height: 80),
                    // CircleAvatar(
                    //   backgroundColor: theme.primary,
                    //   radius: 40,
                    //   child: const Icon(CupertinoIcons.car_detailed,
                    //       color: Colors.white, size: 40),
                    // ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.goalName,
                                style: TextStyle(
                                  color: theme.inversePrimary,
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: width / 5),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: theme.primaryContainer,
                                        content: Text(
                                          "Are You Sure You Want To Delete This ?",
                                          style: TextStyle(
                                              color: theme.inversePrimary,
                                              fontFamily: 'Poppins'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: theme.inversePrimary),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: Text("No",
                                                style: TextStyle(
                                                    color:
                                                        theme.inversePrimary)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.multiply,
                                  color: theme.inversePrimary,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: widget.height * 0.025),
                            child: Row(
                              children: [
                                Text(
                                  "Current Balacne  : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                                Text(
                                  "\$${widget.current}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: widget.height * 0.025),
                            child: Row(
                              children: [
                                Text(
                                  "Required Balacne  : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                                Text(
                                  "\$${widget.finalBalance}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: widget.height * 0.025),
                            child: Row(
                              children: [
                                Text(
                                  " Deadline : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                                Text(
                                  widget.date,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.inversePrimary,
                                    fontFamily: 'Arvo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
