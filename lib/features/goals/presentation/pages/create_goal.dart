// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/date_text_field.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/gradient_text.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';

// import 'package:awesome_dialog/awesome_dialog.dart';

class CreateGoal extends StatefulWidget {
  const CreateGoal({super.key});

  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  List<String> categories = ["Food", "Transport", "Utilities"];

  final TextEditingController date = TextEditingController();
  void clearField() {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const InlineNavBar(title: "Create Goal"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  FadeInDown(
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.tertiary,
                          borderRadius: BorderRadius.circular(35)),
                      width: width * 0.9,
                      height: 60,
                      child: Center(
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(25),

                          hint: Text("Select a category",
                              style: TextStyle(color: theme.inversePrimary)),

                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(Icons.widgets_outlined,
                                      color: theme.inversePrimary),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style:
                                        TextStyle(color: theme.inversePrimary),
                                  ),
                                ],
                              ), // Display the category name
                            );
                          }).toList(),
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          underline: Text(
                            "",
                            style: TextStyle(color: TColor.white),
                          ),
                          onChanged: (String? val) {
                            if (val != null) {
                              // controller.fetchSubcategory();
                            }
                          }, //o Implement your logic here when a selection changes
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                    child: RoundedTextField(
                        title: "Goal Title",
                        onIconPressed: () {},
                        preIcon: Icons.view_headline_sharp),
                  ),
                  const SizedBox(height: 25),
                  FadeInDown(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.decelerate,
                    child: RoundedTextField(
                        title: "Goal Budget",
                        onIconPressed: () {},
                        preIcon: Icons.attach_money_outlined),
                  ),
                  const SizedBox(height: 25),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.decelerate,
                    child: DateTextField(
                      onTap: showDate,
                      title: "Goal Deadline",
                      controller: date,
                      keyboardType: TextInputType.number,
                      icon: Icons.date_range_rounded,
                      onIconPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ZoomInDown(
                        duration: const Duration(milliseconds: 1000),
                        child: CustomButton(title: "Create", onPressed: () {})),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  //========GRADIENT CHIP
  Widget buildGradientChip({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(30),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: gradientColors.last.withOpacity(0.5),
                      blurRadius: 11)
                ]
              : [],
        ),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            // gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientIcon(
                icon: icon,
                size: 15,
                gradient: LinearGradient(colors: gradientColors),
              ),
              const SizedBox(width: 5),
              GradientText(
                label,
                gradient: LinearGradient(colors: gradientColors),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Arvo",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: TColor.gray30,
    );
    if (picked != null) {
      date.text = picked.toString().substring(0, 10);
    }
  }
}
