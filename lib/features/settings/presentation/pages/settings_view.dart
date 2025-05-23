import 'package:animate_do/animate_do.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/settings_value.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  bool isEditing = false;
  bool isDarkTheme = true;
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: theme.surface,
        body: BlocBuilder<ThemeBloc, ThemeData>(
          builder: (context, state) {
            //to check if the dark theme is triggered
            final isDarkMode = theme.brightness == Brightness.dark;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  const InlineNavBar(title: "Settings"),
                  const SizedBox(height: 35),
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.deepPurple,
                          // backgroundImage: controller.imagePath.value ==
                          //         null
                          //     ? AssetImage("assets/img/u1.png")
                          //     : FileImage(File(controller.imagePath.value!))
                          //         as ImageProvider<Object>?
                        ),
                        Positioned(
                          right: 10,
                          bottom: 1,
                          child: InkWell(
                            onTap: () {
                              //choose a pic
                            },
                            child: CircleAvatar(
                              backgroundColor: TColor.white,
                              radius: 20,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile Information",
                                    style: TextStyle(
                                        color: theme.inversePrimary,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() => isEditing = !isEditing);
                                    },
                                    child: Text(isEditing ? 'Save' : 'Edit',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins')),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Card(
                                  color: theme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        profileItem(Icons.person, 'Name',
                                            'Daniel Adrah', theme),
                                        const SizedBox(height: 16),
                                        profileItem(Icons.email, 'E-mail',
                                            'dado@gmail.com', theme),
                                        const SizedBox(height: 16),
                                        profileItem(Icons.lock, ' Password',
                                            'Encrypted', theme),
                                        const SizedBox(height: 1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 2, left: 10),
                              child: Text(
                                "General",
                                style: TextStyle(
                                    color: theme.inversePrimary,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: theme.primaryContainer,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade300,
                                    offset: const Offset(2, 2),
                                    blurRadius: 0.1,
                                    blurStyle: BlurStyle.inner,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    value: isDarkMode,
                                    onChanged: (val) {
                                      context
                                          .read<ThemeBloc>()
                                          .add(SwitchThemeEvent());
                                    },
                                    title: Text('Dark Theme',
                                        style: TextStyle(
                                            color: theme.inversePrimary)),
                                    secondary: Icon(CupertinoIcons.moon,
                                        color: theme.inversePrimary),
                                    activeColor: theme.primary,
                                  ),
                                  const SizedBox(height: 5),
                                  SettingsValue(
                                    name: "My Statistics",
                                    icon: CupertinoIcons.chart_pie,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.inversePrimary,
                                    ),
                                    onTap2: () {
                                      context.pushNamed('statisticsTab');
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  SettingsValue(
                                    name: "My Incomes",
                                    icon: CupertinoIcons.money_dollar_circle,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.inversePrimary,
                                    ),
                                    onTap2: () {
                                      context.pushNamed('incomeView');
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  SettingsValue(
                                    name: "My Accounts",
                                    icon: CupertinoIcons.person_2_fill,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.inversePrimary,
                                    ),
                                    onTap2: () {
                                      context.pushNamed('accView');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 2, left: 10),
                              child: Text(
                                "Account Action",
                                style: TextStyle(
                                    color: theme.inversePrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: theme.primaryContainer,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade300,
                                    offset: const Offset(2, 2),
                                    blurRadius: 0.1,
                                    blurStyle: BlurStyle.inner,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  SettingsValue(
                                    name: "Log Out",
                                    icon: Icons.logout_outlined,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.inversePrimary,
                                    ),
                                    onTap2: () {},
                                  ),
                                  const SizedBox(height: 5),
                                  SettingsValue(
                                    name: "Delete My Account",
                                    icon: Icons.delete,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: theme.inversePrimary,
                                    ),
                                    onTap2: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                theme.primaryContainer,
                                            content: Text(
                                              "Are You Sure You Want To Delete This Account?",
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
                                                      color:
                                                          theme.inversePrimary),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Text("No",
                                                    style: TextStyle(
                                                        color: theme
                                                            .inversePrimary)),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ]),
              ),
            );
          },
        ));
  }

  Widget profileItem(
      IconData icon, String label, String value, ColorScheme theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isEditing
          ? Padding(
              key: ValueKey('$label-edit'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: theme.inversePrimary),
                  hintText: label,
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: theme.primaryContainer,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          : ListTile(
              key: ValueKey('$label-display'),
              leading: Icon(icon, color: theme.inversePrimary),
              title: Text(label,
                  style: TextStyle(
                      color: theme.inversePrimary, fontFamily: 'Poppins')),
              trailing: Text(value,
                  style: TextStyle(
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                      fontSize: 13)),
            ),
    );
  }
}
