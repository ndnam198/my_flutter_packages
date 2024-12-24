import 'package:detached_scrollbar/detached_scrollbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TestPage());
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TestView();
  }
}

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tableHeight = MediaQuery.of(context).size.height * 0.8;
    final tableWidth = MediaQuery.of(context).size.width * 0.8;
    final xTrackLength = MediaQuery.of(context).size.width * 0.5;
    final yTrackLength = MediaQuery.of(context).size.height * 0.5;

    // Table content
    final table = ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: SingleChildScrollView(
        controller: _verticalController,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: List.generate(
              20,
              (index) => DataColumn(label: Text('Header $index')),
            ),
            rows: List.generate(
              100,
              (index) => DataRow(
                cells: List.generate(
                  20,
                  (cellIndex) => DataCell(Text('Row $index Cell $cellIndex')),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Custom Horizontal Scrollbar

    // Custom Vertical Scrollbar

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Detached Scrollbar')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                height: tableHeight,
                width: tableWidth,
                child: table,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: DetachedScrollBar(
                  scrollController: _horizontalController,
                  trackLength: xTrackLength,
                ),
              ),
              // If disable this then the horizontal bar will shrink
              Align(
                alignment: Alignment.topRight,
                child: DetachedScrollBar(
                  scrollController: _verticalController,
                  trackLength: yTrackLength,
                  isHorizontal: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
