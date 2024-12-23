// ignore_for_file: prefer_const_constructors

import 'package:detached_scrollbar/detached_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DetachedScrollBar initializes correctly', (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DetachedScrollBar(
            scrollController: scrollController,
            trackLength: 200,
          ),
        ),
      ),
    );

    expect(find.byType(DetachedScrollBar), findsOneWidget);
  });

  testWidgets('DetachedScrollBar updates scroll position on handle dragged (vertically)', (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(100, (index) => ListTile(title: Text('Item $index')));
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 200,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(handleKey).first;

    expect(scrollController.offset, equals(0));
    await tester.drag(handle, Offset(0, 50));
    await tester.pumpAndSettle();
    expect(scrollController.offset, greaterThan(0));
  });

  testWidgets('DetachedScrollBar updates scroll position on handle dragged (horizontal case)',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(
      100,
      (index) => Container(
        width: 100,
        color: index.isEven ? Colors.blue : Colors.red,
        child: Center(child: Text('Item $index')),
      ),
    );
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 200,
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(handleKey).first;

    expect(scrollController.offset, equals(0));
    await tester.drag(handle, Offset(50, 0)); // Drag horizontally
    await tester.pumpAndSettle();
    expect(scrollController.offset, greaterThan(0));
  });

  testWidgets('DetachedScrollBar updates handle position on track tapped', (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(100, (index) => ListTile(title: Text('Item $index')));
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 200,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      ),
    );

    final track = find.byKey(trackKey).first;
    await tester.tap(track);
    await tester.pumpAndSettle();
    expect(scrollController.offset, greaterThan(0));
  });

  testWidgets('DetachedScrollBar handle size adjusts with content size', (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(100, (index) => ListTile(title: Text('Item $index')));
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 200,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(handleKey).first;
    final initialHandleSize = tester.getSize(handle);

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pumpAndSettle();

    final updatedHandleSize = tester.getSize(handle);
    expect(updatedHandleSize.height, lessThan(initialHandleSize.height));
  });

  testWidgets('DetachedScrollBar handle size adjusts with viewport size', (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(100, (index) => ListTile(title: Text('Item $index')));
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 200,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.binding.setSurfaceSize(Size(400, 800));
    final handle = find.byKey(handleKey).first;
    final initialHandleSize = tester.getSize(handle);

    await tester.binding.setSurfaceSize(Size(400, 400));
    await tester.pumpAndSettle();
    final updatedHandleSize = tester.getSize(handle);

    expect(updatedHandleSize.height, lessThan(initialHandleSize.height));
  });

  testWidgets('DetachedScrollBar does not render when handle size is equal or greater than track length',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(5, (index) => ListTile(title: Text('Item $index')));
    final scrollableWidget = ListView.builder(
      controller: scrollController,
      itemCount: scrollableContent.length,
      itemBuilder: (context, index) => scrollableContent[index],
    );

    await tester.binding.setSurfaceSize(Size(2000, 2000));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              scrollableWidget,
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: 100,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('DetachedScrollBar calls didUpdateWidget when properties change', (WidgetTester tester) async {
    final scrollController = ScrollController();
    final scrollableContent = List.generate(
      100,
      (index) => ListTile(title: Text('Item $index')),
    );

    await tester.binding.setSurfaceSize(Size(2000, 2000));

    // Define a StatefulWidget to allow dynamic updates
    Widget buildTestWidget({required double trackLength}) {
      return MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: scrollableContent.length,
                itemBuilder: (context, index) => scrollableContent[index],
              ),
              DetachedScrollBar(
                scrollController: scrollController,
                trackLength: trackLength,
                isHorizontal: false,
              ),
            ],
          ),
        ),
      );
    }

    // Initial widget with trackLength = 200
    await tester.pumpWidget(buildTestWidget(trackLength: 200));

    // Verify initial state
    final handle = find.byKey(handleKey);
    final handleSize1 = tester.getSize(handle.first);

    // Update the widget by changing trackLength
    await tester.pumpWidget(buildTestWidget(trackLength: 300));

    final handleSize2 = tester.getSize(handle.first);

    // increase track length should shrink handle size
    expect(handleSize1.longestSide, lessThan(handleSize2.longestSide));
  });
}
