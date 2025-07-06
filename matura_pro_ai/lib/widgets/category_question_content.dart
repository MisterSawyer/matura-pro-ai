import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../core/constants.dart';
import '../models/category_question.dart';

import 'no_scrollbar.dart';
import 'draggable_item.dart';
import 'drop_target.dart';

class CategoryQuestionContent extends StatefulWidget {
  final CategoryQuestion question;
  final int questionIndex;
  final int total;
  final ValueChanged<Map<String, String>> onAnswered; // item -> category

  const CategoryQuestionContent(
      {super.key,
      required this.question,
      required this.questionIndex,
      required this.total,
      required this.onAnswered});

  @override
  State<CategoryQuestionContent> createState() =>
      _CategoruQuestionContentState();
}

class _CategoruQuestionContentState extends State<CategoryQuestionContent> {
  Offset? _lastPointerPosition;
  bool _isAutoScrolling = false;
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> _assigned = {}; // item -> category

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_assigned.length < widget.question.items.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.categoriesIncomplete)),
      );
      return;
    }

    widget.onAnswered(_assigned);
  }

  void _startAutoScrollLoop() async {
    if (_isAutoScrolling) return;
    _isAutoScrolling = true;

    while (_isAutoScrolling && mounted) {
      if (_lastPointerPosition != null) {
        _performAutoScroll(_lastPointerPosition!);
      }
      await Future.delayed(const Duration(milliseconds: 16)); // ~60 FPS
    }
  }

  void _performAutoScroll(Offset globalPosition) {
    const edgeMargin = 100.0;
    const scrollSpeed = 10.0;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final local = box.globalToLocal(globalPosition);
    final height = box.size.height;

    if (local.dy < edgeMargin) {
      final newOffset = (_scrollController.offset - scrollSpeed).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    } else if (local.dy > height - edgeMargin) {
      final newOffset = (_scrollController.offset + scrollSpeed).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(newOffset);
    }
  }

  void _onPointerMove(PointerEvent event) {
    _lastPointerPosition = event.position;
    _startAutoScrollLoop();
  }

  void _onPointerUp(PointerEvent event) {
    _isAutoScrolling = false;
    _lastPointerPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerUp,
          child: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text("Question ${widget.questionIndex + 1} of ${widget.total}",
                      style: AppStyles.subHeader),
                  const SizedBox(height: 16),
                  Text(widget.question.question, style: AppStyles.header),
                  const SizedBox(height: 32),
            
                  // Unassigned items
            
                  Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.question.items
                          .where((item) => !_assigned.containsKey(item))
                          .map((item) => DraggableItem(label: item))
                          .toList(),
                    ),
                  ),
            
                  const SizedBox(height: 32),
            
                  // Drop targets with wrapping
                  Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: widget.question.categories.map((category) {
                        final itemsInCategory = _assigned.entries
                            .where((entry) => entry.value == category)
                            .map((entry) => entry.key)
                            .toList();
            
                        return ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                            minHeight: 160,
                          ),
                          child: DropTarget(
                            label: category,
                            currentData: itemsInCategory,
                            onAccept: (DragTargetDetails<String> item) {
                              setState(() {
                                _assigned.removeWhere(
                                    (key, value) => key == item.data);
                                _assigned[item.data] = category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text(AppStrings.submit),
                    ),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
