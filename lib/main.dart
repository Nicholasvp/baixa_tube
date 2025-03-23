import 'package:baixa_tube/core/routes/routes.dart';
import 'package:baixa_tube/ui/blocs/home/home_bloc.dart';
import 'package:baixa_tube/ui/blocs/library/cubit/library_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => LibraryBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Baixa Tube',
        routerConfig: router,
      ),
    );
  }
}
