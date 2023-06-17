import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/map/data/datasources/geo_json_datasource.dart';
import 'package:posts_app/features/map/data/repositores/map_repo_imp.dart';
import 'package:posts_app/features/map/domain/repositores/map_repository.dart';
import 'package:posts_app/features/map/domain/usecases/get_map_all_info.dart';
import 'package:posts_app/features/map/presentation/cubit/propart_cubit.dart';
import 'package:posts_app/features/map/presentation/cubit/sim_card_cubit.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:posts_app/features/posts/data/repositores/post_repository_imp.dart';
import 'package:posts_app/features/posts/domain/repositores/post_repository.dart';
import 'package:posts_app/features/posts/domain/usecases/add_posts.dart';
import 'package:posts_app/features/posts/domain/usecases/delete_posts.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts.dart';
import 'package:posts_app/features/posts/domain/usecases/update_posts.dart';
import 'package:posts_app/features/posts/presentation/bloc/add_or_update_or_delete/add_update_or_delete_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/post_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/map/presentation/cubit/map_cubit.dart';
import 'features/map/presentation/cubit/map_zoom_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Futures of Posts

  // Bloc

  sl.registerFactory(() => PostBloc(getAllPost: sl()));
  sl.registerFactory(() =>
      AddUpdateOrDeleteBloc(addPost: sl(), updatePost: sl(), deletePost: sl()));

  sl.registerFactory(() => MapCubit(getMapInfoUseCase: sl()));
  sl.registerFactory(() => MapZoomCubit());
  sl.registerFactory(() => PropartCubit(getMapInfoUseCase: sl()));
  sl.registerFactory(() => SimCardCubit(getMapInfoUseCase: sl()));

  // UsesCases

  sl.registerLazySingleton(() => GetAllPostUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => GetMapAllInfoUseCase(sl()));

  // Repositories

  sl.registerLazySingleton<PostRepository>(() => PostsRepositoryImp(
      postRemoteDataSource: sl(),
      postLocalDataSource: sl(),
      networkInfo: sl()));

  // DataSources

  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImp(sl()));
  sl.registerLazySingleton<GeoJsonDataSource>(() => GeoJsonDataSourceImpl());
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostModelLocalDataSourceImp(sharedPreferences: sl()));

  sl.registerLazySingleton<MapRepository>(() => MapRepositoryImp(
        geoJsonDataSource: sl(),
      ));

  /// Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));

  /// External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => InternetConnectionChecker());
}
