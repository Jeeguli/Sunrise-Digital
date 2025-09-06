import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_cubit.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_state.dart';
import 'package:bloc_sunrise/common/dialogs/todo_completion_dialog.dart';
import 'package:bloc_sunrise/common/dialogs/todo_deletion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toSentenceCase() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class TodoBlocItemWidget extends StatefulWidget {
  final TodoEntity entity;
  final int index;

  const TodoBlocItemWidget({
    super.key,
    required this.entity,
    required this.index,
  });

  @override
  State<TodoBlocItemWidget> createState() => _TodoBlocItemWidgetState();
}

class _TodoBlocItemWidgetState extends State<TodoBlocItemWidget> {
  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;

  String _timeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min";
    if (diff.inHours < 24) return "${diff.inHours} hr";
    if (diff.inDays < 30) return "${diff.inDays} day";
    if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} month";
    return "${(diff.inDays / 365).floor()} year";
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    showDeleteTaskDialog(
      context,
      widget.entity.title,
      () => cubit.deleteTodo(widget.index),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    showCompleteTaskDialog(
      context,
      widget.entity.title,
      widget.entity.isCompleted,
      () => cubit.toggleTodo(widget.index),
    );
  }

  void _showDetailsPopup(BuildContext context, GlobalKey key) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 120,
        top: offset.dy + 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF595959),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              "Created: ${DateFormat('dd MMM yyyy hh:mm').format(widget.entity.createdAt)}",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final infoKey = GlobalKey();
    final width = MediaQuery.of(context).size.width;
    final textScaler = MediaQuery.of(context).textScaler;

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final model = state.todos[widget.index];

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.025,
            vertical: width * 0.02,
          ),
          padding: EdgeInsets.all(width * 0.035),
          decoration: BoxDecoration(
            color: model.isCompleted ? const Color(0xFFFFF5F5) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: width * 0.002,

                    child: Checkbox(
                      value: model.isCompleted,
                      onChanged: (_) => _showCompleteDialog(context),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: const Color.fromARGB(255, 238, 162, 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      model.title.toSentenceCase(),
                      textScaler: textScaler,
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w600,
                        decoration: model.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: width * 0.02),

              if (!model.isCompleted)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.025,
                        color: Color(0xFF595959),
                      ),
                      children: [
                        TextSpan(
                          text: _isExpanded
                              ? model.description.toSentenceCase()
                              : (model.description.length > 40
                                        ? "${model.description.substring(0, 35)}..."
                                        : model.description)
                                    .toSentenceCase(),
                        ),
                        if (model.description.length > 40)
                          TextSpan(
                            text: _isExpanded ? ". Show less" : " Show more",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF252525),
                              fontSize: width * 0.025,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: width * 0.025),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _timeAgo(model.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.02,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: width * 0.015),
                  InkWell(
                    key: infoKey,
                    child: Icon(Icons.info_outline, size: width * 0.03),
                    onTap: () => _showDetailsPopup(context, infoKey),
                  ),
                  SizedBox(width: width * 0.02),
                  InkWell(
                    onTap: () => _confirmDelete(context),
                    child: Icon(Icons.delete_outline, size: width * 0.03),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
