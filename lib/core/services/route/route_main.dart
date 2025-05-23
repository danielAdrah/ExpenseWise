import 'package:go_router/go_router.dart';
import 'package:trackme/features/auth/presentation/pages/sign_in_view.dart';
import 'package:trackme/main_navbar.dart';
import '../../../features/auth/presentation/pages/create_account.dart';
import '../../../features/auth/presentation/pages/sign_up_view.dart';
import '../../../features/charts/presentation/pages/chart_view.dart';
import '../../../features/expenses/presentation/pages/create_expense_view.dart';
import '../../../features/expenses/presentation/pages/create_upcoming.dart';
import '../../../features/expenses/presentation/pages/update_expense.dart';
import '../../../features/expenses/presentation/pages/update_upcoming.dart';
import '../../../features/goals/presentation/pages/create_goal.dart';
import '../../../features/goals/presentation/pages/goal_detail.dart';
import '../../../features/goals/presentation/pages/goals_view.dart';
import '../../../features/on_boarding/presentation/pages/onboarding_view.dart';
import '../../../features/settings/presentation/pages/account_tab.dart';
import '../../../features/settings/presentation/pages/create_income.dart';
import '../../../features/settings/presentation/pages/create_sec_account.dart';
import '../../../features/settings/presentation/pages/income_tab.dart';
import '../../../features/settings/presentation/pages/settings_view.dart';
import '../../../features/settings/presentation/pages/statistics.dart';
import '../../../features/spendings_limits/presentation/pages/create_limit.dart';
import '../../../features/spendings_limits/presentation/pages/edit_limit.dart';
import '../../../features/spendings_limits/presentation/pages/limit_detail.dart';
import '../../../features/spendings_limits/presentation/pages/spending_limit_view.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    //======
    GoRoute(
      path: '/signUp',
      name: 'signUp',
      builder: (context, state) => const SignUpView(),
    ),
    //=====
    GoRoute(
      path: '/signIn',
      name: 'signIn',
      builder: (context, state) => const SignInView(),
    ),
    //======
    GoRoute(
      path: '/createAcc',
      name: 'createAcc',
      builder: (context, state) => const CreatAccount(),
    ),
    //======
    GoRoute(
      path: '/mainBar',
      name: 'mainBar',
      builder: (context, state) => const MainNavBar(),
    ),
    //======
    GoRoute(
      path: '/settingsView',
      name: 'settingsView',
      builder: (context, state) => const SettingsView(),
    ),
    //======
    GoRoute(
      path: '/createExpense',
      name: 'createExpense',
      builder: (context, state) => const CreateExpenseView(),
    ),
    //======
    GoRoute(
      path: '/createUpcoming',
      name: 'createUpcoming',
      builder: (context, state) => const CreateUpcomingExpense(),
    ),
    //======
    GoRoute(
      path: '/editExpense',
      name: 'editExpense',
      builder: (context, state) => const EditExpense(),
    ),
    //======
    GoRoute(
      path: '/editUpcoming',
      name: 'editUpcoming',
      builder: (context, state) => const EditUpcomingExpense(),
    ),
    //======
    GoRoute(
      path: '/goalView',
      name: 'goalView',
      builder: (context, state) => const GoalView(),
    ),
    //======
    GoRoute(
      path: '/goalDetail',
      name: 'goalDetail',
      builder: (context, state) => const GoalDetail(),
    ),
    //======
    GoRoute(
      path: '/createGoal',
      name: 'createGoal',
      builder: (context, state) => const CreateGoal(),
    ),
    //======
    GoRoute(
      path: '/spendingsLimit',
      name: 'spendingsLimit',
      builder: (context, state) => const SpendingLimit(),
    ),
    //======
    GoRoute(
      path: '/createLimit',
      name: 'createLimit',
      builder: (context, state) => const CreateLimit(),
    ),
    //======
    GoRoute(
      path: '/editLimit',
      name: 'editLimit',
      builder: (context, state) => const EditLimit(),
    ),
    //======
    GoRoute(
      path: '/limitDetail',
      name: 'limitDetail',
      builder: (context, state) => const LimitDetail(),
    ),
    //======
    GoRoute(
      path: '/settingsView/accView',
      name: 'accView',
      builder: (context, state) => const AccountsView(),
    ),
    //======
    GoRoute(
      path: '/settingsView/statisticsTab',
      name: 'statisticsTab',
      builder: (context, state) => const StatisticsView(),
    ),
    //======
    GoRoute(
      path: '/settingsView/incomeView',
      name: 'incomeView',
      builder: (context, state) => const IncomeTabView(),
    ),
    //======
    GoRoute(
      path: '/settingsView/createIncome',
      name: 'createIncome',
      builder: (context, state) => const CreateIncome(),
    ),
    //======
    GoRoute(
      path: '/settingsView/createSecAccount',
      name: 'createSecAccount',
      builder: (context, state) => const CreateSecAccount(),
    ),
    //======
    GoRoute(
      path: '/chartsView',
      name: 'chartsView',
      builder: (context, state) => const ChartsPage(),
    ),
    //======
  ],
);
