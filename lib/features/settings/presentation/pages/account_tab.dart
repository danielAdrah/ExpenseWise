import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../widgets/account_tile.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.inversePrimary),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: FadeInDown(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Text('My Accounts',
              style: TextStyle(
                  color: theme.inversePrimary,
                  fontSize: 21,
                  fontFamily: 'Arvo')),
        ),
        leading: FadeInLeft(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.inversePrimary,
              )),
        ),
        actions: [
          FadeInRight(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child:
                  Image.asset("assets/img/logo1.png", width: 55, height: 55)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          context.pushNamed('createSecAccount');
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0XFF8B5CF6),
                Color(0XFF5A31F4),
              ],
            ),
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 35),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Slidable(
                endActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {
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
                                  style: TextStyle(color: theme.inversePrimary),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text("No",
                                    style:
                                        TextStyle(color: theme.inversePrimary)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                    spacing: 2,
                  ),
                ]),
                child: FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: const AccountTile(
                    icon: Icons.account_box,
                    currency: "Syrian Bound",
                    title: "Daily Account",
                    budget: "200000",
                  ),
                ),
              );
            }),
      )),
    );
  }
}
