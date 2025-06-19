import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trackme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:trackme/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:trackme/firebase_options.dart';
import 'core/services/injection_container.dart';
import 'core/services/route/route_main.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'features/auth/presentation/bloc/password_cubit.dart';
import 'features/expenses/presentation/bloc/upcoming_expense_bloc.dart';
import 'features/settings/presentation/bloc/income_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(SetInitTheme())),
        BlocProvider(create: (context) => PasswordVisibilityCubit()),
        BlocProvider(create: (context) => ConfirmPasswordVisibilityCubit()),
        BlocProvider<AuthBloc>(
            create: (context) => sl<AuthBloc>()..add(AppStarted())),
        BlocProvider<ExpenseBloc>(create: (context) => sl<ExpenseBloc>()),
        BlocProvider<UpcomingExpenseBloc>(create: (context) => sl<UpcomingExpenseBloc>()),
        BlocProvider<IncomeBloc>(create: (context) => sl<IncomeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return MaterialApp.router(
            theme: theme,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
