import 'package:flutter/material.dart';
import '../../core/constants.dart';

class Carousel extends StatefulWidget {
  final List<Map<String, dynamic>> objects;

  const Carousel({required this.objects, super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.4);
    _controller.addListener(() {
      final newPage = _controller.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page >= 0 && page < widget.objects.length) {
      _controller.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

 @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding), // <-- Margin above and below
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            // Carousel items
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.objects.length,
                itemBuilder: (context, i) {
                  final object = widget.objects[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding / 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(object['icon'], size: 32),
                          const SizedBox(height: 8),
                          Text(object['name'], textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Left arrow
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty .all(Colors.transparent),
                ),
              ),
            ),

            // Right arrow
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _currentPage < widget.objects.length - 1
                    ? () => _goToPage(_currentPage + 1)
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty .all(Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
