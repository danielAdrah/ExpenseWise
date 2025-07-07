// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entity/user_entity.dart';
import '../bloc/user_info_bloc.dart';

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

  // Add controllers for the editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<UserInfoBloc>()..add(GetUserDataEvent()),
      child: Scaffold(
        backgroundColor: theme.surface,
        body: BlocBuilder<ThemeBloc, ThemeData>(
          builder: (context, state) {
            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: InlineNavBar(title: "Settings"),
                    ),
                  ),

                  // Profile Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Center(
                          child: Hero(
                            tag: 'profile-avatar',
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 5,
                                  child: InkWell(
                                    onTap: () {
                                      //choose a pic
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.primaryContainer,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.primary,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                theme.shadow.withOpacity(0.3),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: theme.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Profile Information Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Information Header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 4,
                                        decoration: BoxDecoration(
                                          color: theme.primary,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Profile Information",
                                        style: TextStyle(
                                          color: theme.onSurface,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      if (isEditing) {
                                        final currentState =
                                            context.read<UserInfoBloc>().state;
                                        if (currentState is UserInfoLoaded) {
                                          final updatedUser = UserEntity(
                                            name: nameController.text,
                                            email: emailController.text,
                                          );
                                          context.read<UserInfoBloc>().add(
                                                UpdateUserDataEvent(
                                                    user: updatedUser),
                                              );
                                        }
                                      } else {
                                        setState(() => isEditing = true);
                                      }
                                    },
                                    icon: Icon(
                                      isEditing ? Icons.save : Icons.edit,
                                      size: 18,
                                      color: theme.primary,
                                    ),
                                    label: Text(
                                      isEditing ? 'Save' : 'Edit',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: theme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: theme.primaryContainer
                                          .withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Profile Information Card
                            BlocConsumer<UserInfoBloc, UserInfoState>(
                              listener: (context, userState) {
                                if (userState is UserInfoLoaded) {
                                  nameController.text = userState.user.name;
                                  emailController.text = userState.user.email;
                                } else if (userState is UserUpdateSuccess) {
                                  final snackbar = Methods().successSnackBar(
                                      'Your information was updated successfully');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                  setState(() => isEditing = false);
                                } else if (userState is UserUpdateFail) {
                                  final snackbar = Methods().errorSnackBar(
                                      'Unable to update you data , try again.');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                }
                              },
                              builder: (context, userState) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: theme.primaryContainer,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.shadow.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: userState is UserInfoLoading ||
                                                userState
                                                    is UserUpdateInProgress
                                            ? _buildLoadingProfileItems(theme)
                                            : userState is UserInfoFail
                                                ? Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Text(
                                                        userState.message,
                                                        style: TextStyle(
                                                            color: theme.error),
                                                      ),
                                                    ),
                                                  )
                                                : userState is UserInfoLoaded
                                                    ? _buildProfileItems(
                                                        userState.user,
                                                        theme,
                                                        () async {
                                                          try {
                                                            //this for sending an link to the email that the user forget its password
                                                            await FirebaseAuth
                                                                .instance
                                                                .sendPasswordResetEmail(
                                                                    email: userState
                                                                        .user
                                                                        .email);

                                                            final snackbar = Methods()
                                                                .alertSnackBar(
                                                                    'An email has been sent to reset your password.');
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackbar);
                                                          } catch (e) {
                                                            print(e.toString());
                                                          }
                                                        },
                                                      )
                                                    : const SizedBox(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // General Settings Header
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 20, right: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: theme.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "General",
                                    style: TextStyle(
                                      color: theme.onSurface,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // General Settings Card
                            Container(
                              // padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: theme.primaryContainer,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadow.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Column(
                                    children: [
                                      // Dark Theme Toggle
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: SwitchListTile(
                                          value: isDarkMode,
                                          onChanged: (val) {
                                            context
                                                .read<ThemeBloc>()
                                                .add(SwitchThemeEvent());
                                          },
                                          title: Text(
                                            'Dark Theme',
                                            style: TextStyle(
                                              color: theme.onSurface,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          secondary: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: theme.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.moon_fill,
                                              color: theme.primary,
                                            ),
                                          ),
                                          // Container(
                                          //   padding: const EdgeInsets.all(8),
                                          //   decoration: BoxDecoration(
                                          //     color: isDarkMode
                                          //         ? theme.primary.withOpacity(0.2)
                                          //         : theme.primaryContainer,
                                          //     shape: BoxShape.circle,
                                          //   ),
                                          // child: Icon(
                                          //   CupertinoIcons.moon_fill,
                                          //   color: isDarkMode
                                          //       ? theme.primary
                                          //       : theme.onSurface,
                                          // ),
                                          // ),
                                          activeColor: theme.primary,
                                          activeTrackColor:
                                              theme.primary.withOpacity(0.3),
                                          inactiveTrackColor:
                                              theme.onSurface.withOpacity(0.1),
                                          inactiveThumbColor:
                                              theme.onSurfaceVariant,
                                        ),
                                      ),

                                      // Settings Items
                                      _buildAnimatedSettingsItem(
                                        "My Statistics",
                                        CupertinoIcons.chart_pie_fill,
                                        theme,
                                        () =>
                                            context.pushNamed('statisticsTab'),
                                      ),
                                      _buildAnimatedSettingsItem(
                                        "My Incomes",
                                        CupertinoIcons.money_dollar_circle_fill,
                                        theme,
                                        () => context.pushNamed('incomeView'),
                                      ),
                                      _buildAnimatedSettingsItem(
                                        "My Accounts",
                                        CupertinoIcons.person_2_fill,
                                        theme,
                                        () => context.pushNamed('accView'),
                                      ),
                                      _buildAnimatedSettingsItem(
                                        "AI Chat",
                                        Icons.smart_toy_rounded,
                                        theme,
                                        () => context.pushNamed('chatView'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Account Actions Header
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 20, right: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: theme.error,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Account Actions",
                                    style: TextStyle(
                                      color: theme.onSurface,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Account Actions Card
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 30),
                              decoration: BoxDecoration(
                                color: theme.errorContainer.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadow.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Column(
                                    children: [
                                      BlocConsumer<AuthBloc, AuthState>(
                                        listener: (context, state2) {},
                                        builder: (context, state2) {
                                          return _buildAnimatedSettingsItem(
                                            "Log Out",
                                            Icons.logout_rounded,
                                            theme,
                                            () {
                                              context
                                                  .read<AuthBloc>()
                                                  .add(SignOutRequested());
                                              context.pushNamed('signIn');
                                            },
                                            isDestructive: true,
                                          );
                                        },
                                      ),
                                      _buildAnimatedSettingsItem(
                                        "Delete My Account",
                                        Icons.delete_rounded,
                                        theme,
                                        () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: theme.surface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                title: Text(
                                                  "Delete Account",
                                                  style: TextStyle(
                                                    color: theme.onSurface,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete your account? This action cannot be undone.",
                                                  style: TextStyle(
                                                    color:
                                                        theme.onSurfaceVariant,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        context.pop(),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: theme.primary),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        context.pop(),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          theme.error,
                                                      foregroundColor:
                                                          theme.onError,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        isDestructive: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper methods for UI components
  Widget _buildLoadingProfileItems(ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerItem(theme),
        const SizedBox(height: 16),
        _buildShimmerItem(theme),
        const SizedBox(height: 16),
        _buildShimmerItem(theme),
      ],
    );
  }

  Widget _buildShimmerItem(ColorScheme theme) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: theme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 150,
                height: 14,
                decoration: BoxDecoration(
                  color: theme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItems(
      UserEntity user, ColorScheme theme, void Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileItem(Icons.person, 'Name', user.name, theme),
        const SizedBox(height: 16),
        profileItem(Icons.email, 'E-mail', user.email, theme),
        const SizedBox(height: 16),
        InkWell(
            onTap: onTap,
            child: profileItem(Icons.lock, 'Password', 'Encrypted', theme)),
      ],
    );
  }

  Widget _buildAnimatedSettingsItem(
    String title,
    IconData icon,
    ColorScheme theme,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? theme.error.withOpacity(0.1)
                    : theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? theme.error : theme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? theme.error : theme.onSurface,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? theme.error.withOpacity(0.7)
                  : theme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  //profile item
  Widget profileItem(
    IconData icon,
    String label,
    String value,
    ColorScheme theme,
  ) {
    // Determine which controller to use based on the label
    TextEditingController? controller;
    if (label == 'Name') {
      controller = nameController;
    } else if (label == 'E-mail') {
      controller = emailController;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isEditing && controller != null
          ? Padding(
              key: ValueKey('$label-edit'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: controller,
                style: TextStyle(color: theme.onSurface),
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: theme.primary),
                  labelText: label,
                  labelStyle: TextStyle(color: theme.primary.withOpacity(0.7)),
                  filled: true,
                  fillColor: theme.surface.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.primary, width: 2),
                  ),
                ),
              ),
            )
          : Container(
              key: ValueKey('$label-display'),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: theme.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: theme.onSurfaceVariant,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: theme.onSurface,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
