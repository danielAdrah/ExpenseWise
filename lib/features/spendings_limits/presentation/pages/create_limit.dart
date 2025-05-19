// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/date_text_field.dart';

import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';

// import 'package:awesome_dialog/awesome_dialog.dart';

class CreateLimit extends StatefulWidget {
  const CreateLimit({super.key});

  @override
  State<CreateLimit> createState() => _CreateLimitState();
}

class _CreateLimitState extends State<CreateLimit> {
  List<String> categories = ["Food", "Transport", "Utilities"];
  
  final TextEditingController goalName = TextEditingController();
  final TextEditingController budget = TextEditingController();
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
            const InlineNavBar(title: "Create Limit"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
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
                        title: "Limit Amount",
                        keyboardType: TextInputType.number,
                        onIconPressed: () {},
                        preIcon: Icons.attach_money_outlined),
                  ),
                  const SizedBox(height: 25),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.decelerate,
                    child: DateTextField(
                      onTap: showDate,
                      title: "Limit Start Date",
                      controller: date,
                      keyboardType: TextInputType.number,
                      icon: Icons.date_range_rounded,
                      onIconPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 25),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.decelerate,
                    child: DateTextField(
                      onTap: showDate2,
                      title: "Limit End Date",
                      controller: TextEditingController(),
                      keyboardType: TextInputType.number,
                      icon: Icons.date_range_rounded,
                      onIconPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ZoomInDown(
                        duration: const Duration(milliseconds: 1300),
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

 
  Future<void> showDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: TColor.gray30,
    );
    if (picked != null) {
      // controller.startDate.text = picked.toString().substring(0, 10);
      date.text = picked.toString().substring(0, 10);
    }
  }

  Future<void> showDate2() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: TColor.gray30,
    );
    if (picked != null) {
      // controller.endDate.text = picked.toString().substring(0, 10);
    }
  }
}
