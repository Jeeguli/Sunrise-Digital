import 'package:bloc_sunrise/bloc_application/data/repository/todo_repo_impl.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_cubit.dart';
import 'package:bloc_sunrise/bloc_application/presentation/pages/todo_bloc_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repository = TodoRepositoryImpl(prefs);

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => TodoCubit(repository))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunrise Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}
