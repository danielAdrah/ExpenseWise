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
import '../../features/expenses/domain/usecases/usecases.dart';
import '../../features/expenses/presentation/bloc/expense_bloc.dart';
import '../../features/expenses/presentation/bloc/upcoming_expense_bloc.dart';
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
// import 'presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
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
}
