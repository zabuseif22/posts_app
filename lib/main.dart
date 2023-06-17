import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:posts_app/features/map/presentation/cubit/sim_card_cubit.dart';
import 'package:posts_app/features/map/presentation/pages/map_page.dart';
import 'core/app_theam.dart';
import 'features/map/presentation/cubit/map_zoom_cubit.dart';
import 'features/map/presentation/cubit/propart_cubit.dart';
import 'injection_continar.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// if you have many bloc don't add here just make separate model
        BlocProvider(create: (_) => di.sl<PropartCubit>()..loadMapDataListProp),
        BlocProvider(create: (_) => di.sl<MapCubit>()..loadMapData),
        BlocProvider(create: (_) => di.sl<SimCardCubit>()..loadSimCard),
        BlocProvider(create: (_) => di.sl<MapZoomCubit>()),
      ],
      child: MaterialApp(
          title: 'TDD Clean Code',
          theme: MyAppTheme.lightTheme(),
          home: const MapPage()),
    );
  }
}
