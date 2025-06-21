import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackme/features/auth/domain/usecases/create_account_usercase.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_imp.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/delete_account_usecase.dart';
import '../../features/auth/domain/usecases/get_accounts_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_use_case.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/expenses/data/datasources/expense_remote_datasource.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/domain/services/limit_update_service.dart';
import '../../features/expenses/domain/usecases/usecases.dart';
import '../../features/expenses/presentation/bloc/expense_bloc.dart';
import '../../features/expenses/presentation/bloc/upcoming_expense_bloc.dart';
import '../../features/goals/data/datasources/goal_remote_datasource.dart';
import '../../features/goals/data/repositories/goal_repository_impl.dart';
import '../../features/goals/domain/repositories/goal_repository.dart';
import '../../features/goals/domain/usecases/add_goal_usecase.dart';
import '../../features/goals/domain/usecases/delete_goal_usecase.dart';
import '../../features/goals/domain/usecases/get_goals_usecase.dart';
import '../../features/goals/domain/usecases/update_goal_progress_usecase.dart';
import '../../features/goals/domain/usecases/update_goal_usecase.dart';
import '../../features/goals/presentation/bloc/goal_bloc.dart';
import '../../features/settings/data/datasources/income_remote_data_source.dart';
import '../../features/settings/data/datasources/user_remote_data_source.dart';
import '../../features/settings/data/repository/income_repository_imp.dart';
import '../../features/settings/data/repository/user_repository_imp.dart';
import '../../features/settings/domain/repository/income_repository.dart';
import '../../features/settings/domain/repository/user_repository.dart';
import '../../features/settings/domain/usecases/get_user_data_usecase.dart';
import '../../features/settings/domain/usecases/income_usecases.dart';
import '../../features/settings/domain/usecases/update_user_data_usecase.dart';
import '../../features/settings/presentation/bloc/income_bloc.dart';
import '../../features/settings/presentation/bloc/user_info_bloc.dart';
import '../../features/spendings_limits/data/datasources/limit_remote_datasource.dart';
import '../../features/spendings_limits/data/repositories/limit_repository_impl.dart';
import '../../features/spendings_limits/domain/repositories/limit_repository.dart';
import '../../features/spendings_limits/domain/usecases/add_limit_usecase.dart';
import '../../features/spendings_limits/domain/usecases/delete_limit_usecase.dart';
import '../../features/spendings_limits/domain/usecases/get_limits_usecase.dart';
import '../../features/spendings_limits/domain/usecases/update_limit_usecase.dart';
import '../../features/spendings_limits/domain/usecases/update_limit_spending_usecase.dart';
import '../../features/spendings_limits/presentation/bloc/limit_bloc.dart';
// import 'presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => LimitUpdateService(firestore: sl()));
//===============================================================================
  //Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(auth: sl(), firestore: sl()),
  );
  //---
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImp(auth: sl(), firestore: sl()),
  );
  //---
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(sl()),
  );
  //---
  sl.registerLazySingleton<IncomeRemoteDataSource>(
    () => IncomeRemoteDataSourceImpl(sl()),
  );
//=================================================================================
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(remote: sl()),
  );
  //---
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImp(remote: sl()),
  );
  //---
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(remoteDataSource: sl()),
  );
  //---
  sl.registerLazySingleton<IncomeRepository>(
    () => IncomeRepositoryImp(remoteDataSource: sl()),
  );
//=================================================================================
  // Use cases
  sl.registerLazySingleton(() => SignInUsecase(repo: sl()));
  sl.registerLazySingleton(() => SignUpUsecase(repo: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(repo: sl()));
  sl.registerLazySingleton(() => SignOutUsecase(repo: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repo: sl()));
  sl.registerLazySingleton(() => CreateAccountUsercase(repo: sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repo: sl()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repo: sl()));
  //---
  sl.registerLazySingleton(() => GetUserDataUsecase(repo: sl()));
  sl.registerLazySingleton(() => UpdateUserDataUsecase(repo: sl()));
  //---
  sl.registerLazySingleton(() => AddExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetExpensesUseCase(repository: sl()));
  //---
  sl.registerLazySingleton(() => AddUpcomingExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateUpcomingExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => DeleteUpcomingExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUpcomingExpensesUseCase(repository: sl()));
  //---
  sl.registerLazySingleton(() => AddIncomeUsecases(repo: sl()));
  sl.registerLazySingleton(() => GetIncomeUsecases(repo: sl()));
  sl.registerLazySingleton(() => DeleteIncomeUsecases(repo: sl()));

//=================================================================================

  // BLoC
  sl.registerFactory(
      () => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  //---
  sl.registerFactory(() => UserInfoBloc(getInfoUseecase: sl()));
  //---
  sl.registerFactory(
    () => ExpenseBloc(
      addExpense: sl(),
      deleteExpense: sl(),
      updateExpense: sl(),
      getExpenses: sl(),
      limitUpdateService: sl(),
      limitBloc: sl(),
    ),
  );
  //---
  sl.registerFactory(
    () => UpcomingExpenseBloc(
      addUpcomingExpense: sl(),
      updateUpcomingExpense: sl(),
      deleteUpcomingExpense: sl(),
      getUpcomingExpenses: sl(),
    ),
  );
  //---
  sl.registerFactory(
    () => IncomeBloc(addIncome: sl(), deleteIncome: sl(), getIncomes: sl()),
  );

//=================================================================================

  // Goals Feature
  // BLoC
  sl.registerFactory(() => GoalBloc(
        addGoal: sl(),
        updateGoal: sl(),
        deleteGoal: sl(),
        getGoals: sl(),
        updateGoalProgress: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => AddGoalUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateGoalUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteGoalUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetGoalsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateGoalProgressUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<GoalRepository>(
      () => GoalRepositoryImpl(remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<GoalRemoteDataSource>(
      () => GoalRemoteDataSourceImpl(sl()));

  // Spending Limits Feature
  // BLoC
  sl.registerFactory(() => LimitBloc(
        addLimit: sl(),
        updateLimit: sl(),
        deleteLimit: sl(),
        getLimits: sl(),
        updateLimitSpending: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => AddLimitUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateLimitUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteLimitUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetLimitsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateLimitSpendingUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<LimitRepository>(
      () => LimitRepositoryImpl(remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<LimitRemoteDataSource>(
      () => LimitRemoteDataSourceImpl(sl()));
}
