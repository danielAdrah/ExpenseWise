import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackme/features/auth/domain/usecases/create_account_usercase.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_imp.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/repository/get_current_user_use_case.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
// import 'presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(auth: sl(), firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(remote: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUsecase(repo: sl()));
  sl.registerLazySingleton(() => SignUpUsecase(repo: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(repo: sl()));
  sl.registerLazySingleton(() => SignOutUsecase(repo: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repo: sl()));
  sl.registerLazySingleton(() => CreateAccountUsercase(repo: sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
        // signIn: sl(),
        // signUp: sl(),
        // resetPassword: sl(),
        // signOut: sl(),
        // getCurrentUser: sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
}
