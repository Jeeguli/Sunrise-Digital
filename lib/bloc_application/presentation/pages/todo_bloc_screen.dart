import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_cubit.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_state.dart';
import 'package:bloc_sunrise/bloc_application/presentation/widgets/todo_item.dart';
import 'package:bloc_sunrise/bloc_application/presentation/widgets/category_container.dart';
import 'package:bloc_sunrise/common/dialogs/new_list_dialog.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final todos = state.todos;
        final cubit = context.read<TodoCubit>();

        final totalBusinessCount = todos
            .where((task) => task.category == "Business")
            .length;
        final totalPersonalCount = todos
            .where((task) => task.category == "Personal")
            .length;
        final totalCompletedCount = todos
            .where((task) => task.isCompleted)
            .length;
        final width = MediaQuery.of(context).size.width;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/todo_png/Sunrise-logo-New.png",
                        height: MediaQuery.of(context).size.height * 0.05,
                        color: const Color(0xFF252525),
                      ),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: const AssetImage(
                            "assets/todo_png/user.png",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "My Task",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF252525),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (todos.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                showBlocAddTaskDialog(
                                  context,
                                  cubit,
                                  titleController,
                                  descController,
                                );
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "assets/todo_png/plus.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: width * 0.15,
                                color: const Color(0xFF595959),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "No Active Tasks(0)",
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.025,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF595959),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tap + to create your first task",
                              style: GoogleFonts.poppins(
                                fontSize: width * 0.025,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (todos.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category".toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF595959),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CategorySummaryWidget(
                            businessCount: totalBusinessCount,
                            personalCount: totalPersonalCount,
                            completedCount: totalCompletedCount,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Today's Task".toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF595959),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                return TodoBlocItemWidget(
                                  entity: todos[index],
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFFFF4E0),

            onPressed: () {
              showBlocAddTaskDialog(
                context,
                cubit,
                titleController,
                descController,
              );
            },
            child: Icon(Icons.add, color: Color(0xFF252525)),
          ),
        );
      },
    );
  }
}
