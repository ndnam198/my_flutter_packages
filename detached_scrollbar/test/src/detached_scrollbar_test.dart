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

  testWidgets('DetachedScrollBar updates scroll position on handle dragged', (WidgetTester tester) async {
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
}
