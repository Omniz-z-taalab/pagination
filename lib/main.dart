import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/pagination_bloc.dart';
import 'package:pop/popular.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginationBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PopularScreen(),
      ),
    );
  }
}


