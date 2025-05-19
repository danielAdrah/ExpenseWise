// ignore_for_file: unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoalDetail extends StatefulWidget {
  const GoalDetail({super.key});

  @override
  State<GoalDetail> createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  final TextEditingController balance = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon:
              Icon(Icons.arrow_back_ios, color: theme.inversePrimary, size: 25),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeInDown(
            delay: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: theme.primary,
                  child: const Icon(CupertinoIcons.car_detailed,
                      color: Colors.white, size: 90),
                ),
                const SizedBox(height: 25),
                Text("Buy new car",
                    style: TextStyle(
                      color: theme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins",
                    )),
                const SizedBox(height: 25),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: (30 / 5).clamp(0, 1),
                        strokeWidth: 15,
                        backgroundColor: theme.tertiary,
                        color: theme.primary,
                      ),
                    ),
                    Text(
                      "100%",
                      style: TextStyle(
                        color: theme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Balance",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: "Arvo",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text("\$7500",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Goal",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: "Arvo",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text("\$10000",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Divider(
                  color: Colors.grey.withOpacity(0.3),
                  endIndent: 50,
                  indent: 50,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deadline",
                              style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: "Arvo",
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              )),
                          Text("12/2/2025",
                              style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: "Poppins",
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(
                        right: 5, left: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Add to balance',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          // width: 30,
                          // height: 20,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0XFF5A31F4),
                              Color(0XFF8B5CF6),
                            ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("ADD",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
