import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_cubit.dart';
import 'package:bloc_sunrise/common/widgets/text_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showBlocAddTaskDialog(
  BuildContext context,
  TodoCubit todoCubit,
  TextEditingController titleController,
  TextEditingController descController,
) {
  final formKey = GlobalKey<FormState>();
  String? selectedCategory;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return SingleChildScrollView(
              child: Container(
                width: width > 500 ? 400 : double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Task',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF252525),
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Title should not be empty";
                          }
                          if (value.length < 3) {
                            return "Title must be at least 3 characters";
                          }
                          return null;
                        },
                        decoration: buildInputDecoration(
                          hintText: "Task Title",
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: descController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Description should not be empty";
                          }
                          if (value.length < 5) {
                            return "Description must be at least 5 characters";
                          }
                          return null;
                        },
                        decoration: buildInputDecoration(
                          hintText: "Task Description",
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        "Category",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF595959),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text("Business"),
                            selected: selectedCategory == "Business",
                            selectedColor: const Color(0xFFE7FFE0),
                            backgroundColor: const Color(0xFFFFF4E0),
                            onSelected: (selected) {
                              setState(
                                () => selectedCategory = selected
                                    ? "Business"
                                    : null,
                              );
                            },
                          ),
                          ChoiceChip(
                            label: const Text("Personal"),
                            selected: selectedCategory == "Personal",
                            selectedColor: const Color(0xFFE7FFE0),
                            backgroundColor: const Color(0xFFFFF4E0),
                            onSelected: (selected) {
                              setState(
                                () => selectedCategory = selected
                                    ? "Personal"
                                    : null,
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 238, 162, 20),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (selectedCategory == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select a category",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  todoCubit.addTodo(
                                    titleController.text.trim(),
                                    descController.text.trim(),
                                    category: selectedCategory!,
                                  );
                                  titleController.clear();
                                  descController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  238,
                                  162,
                                  20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Save Task',
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.025,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
