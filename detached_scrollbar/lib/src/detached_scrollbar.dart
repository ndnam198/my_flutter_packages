import 'package:flutter/material.dart';

const _handleColor = Color(0xFF747474);
const _trackColor = Color(0xFFcbcbcb);
const _trackWidth = 5.0;

/// Track key
const trackKey = Key('__detached_scrollbar_track__');
/// Handle key
const handleKey = Key('__detached_scrollbar_handle__');

/// A scrollbar that is detached from the scrollable content.
class DetachedScrollBar extends StatefulWidget {
  // ignore: public_member_api_docs
  const DetachedScrollBar({
    required this.scrollController,
    required this.trackLength,
    super.key,
    this.isHorizontal = true,
    this.trackWidth = _trackWidth,
    this.handleColor = _handleColor,
    this.trackColor = _trackColor,
  });

  /// The scroll controller to listen to.
  final ScrollController scrollController;

  ///  The length of the track.
  final double trackLength;

  /// Whether the scrollbar is horizontal or vertical.
  final bool isHorizontal;

  /// The width of the track.
  final double trackWidth;

  /// The color of the draggable handle.
  final Color handleColor;

  /// The color of the track.
  final Color trackColor;

  @override
  State<DetachedScrollBar> createState() => _DetachedScrollBarState();
}

class _DetachedScrollBarState extends State<DetachedScrollBar> {
  double _scrollPercent = 0;
  // initial handle length
  double _handleLength = 100;
  // initial track length
  double _trackLength = 1000;
  bool _isHandleDragging = false;

  // ignore: avoid_setters_without_getters
  set _scrollPercentSetter(double value) {
    if (_scrollPercent != value) {
      _scrollPercent = value;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollPositionUpdated);
    _trackLength = widget.trackLength;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLength = _calculateHandleLength();
      setState(() {});
    });
  }

  double _calculateHandleLength() {
    //vẻify widget.scrollController.position is gettable first
    if (!widget.scrollController.hasClients) return 50;

    final viewportDimension = widget.scrollController.position.viewportDimension;
    final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    return (_trackLength * (viewportDimension / (maxScrollExtent + viewportDimension))).clamp(20.0, _trackLength);
  }

  void _onScrollPositionUpdated() {
    setState(() {
      _scrollPercentSetter =
          (widget.scrollController.offset / widget.scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
    });
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    _isHandleDragging = true;

    // Calculate delta movement instead of absolute position
    final delta = widget.isHorizontal ? details.delta.dx : details.delta.dy;
    final maxExtent = widget.scrollController.position.maxScrollExtent;

    // Convert track movement to scroll movement
    final scrollDelta = (delta / _trackLength) * maxExtent;

    // Update scroll position based on delta
    final newOffset = (widget.scrollController.offset + scrollDelta).clamp(0.0, maxExtent);

    setState(() {
      _scrollPercentSetter = newOffset / maxExtent;
      widget.scrollController.jumpTo(newOffset);
    });
  }

  void _onTrackTap(TapDownDetails details) {
    if (_isHandleDragging) {
      return;
    }

    final dragPosition = widget.isHorizontal
        ? details.localPosition.dx.clamp(0, _trackLength)
        : details.localPosition.dy.clamp(0, _trackLength);
    final scrollPercentage = dragPosition / _trackLength;

    setState(() {
      _scrollPercentSetter = scrollPercentage;
      widget.scrollController.jumpTo(scrollPercentage * widget.scrollController.position.maxScrollExtent);
    });
  }

  @override
  void didUpdateWidget(covariant DetachedScrollBar oldWidget) {
    widget.scrollController.removeListener(_onScrollPositionUpdated);
    widget.scrollController.addListener(_onScrollPositionUpdated);
    // update track length and handle length when widget is updated
    _trackLength = widget.trackLength;
    _handleLength = _calculateHandleLength();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollPositionUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final handleMaxOffset = _trackLength - _handleLength;
    final offset = (_scrollPercent * handleMaxOffset).clamp(0, handleMaxOffset).toDouble();

    if (_handleLength >= _trackLength) {
      debugPrint('handle length is greater than track length $_handleLength >= $_trackLength');
      return const SizedBox.shrink();
    }

    return GestureDetector(
      key: trackKey,
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTrackTap,
      child: Container(
        width: widget.isHorizontal ? _trackLength : _trackWidth,
        height: widget.isHorizontal ? _trackWidth : _trackLength,
        decoration: const BoxDecoration(
          color: _trackColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeOut,
              left: widget.isHorizontal ? offset : null,
              top: widget.isHorizontal ? null : offset,
              child: GestureDetector(
                key: handleKey,
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: widget.isHorizontal ? _onHandleDragUpdate : null,
                onVerticalDragUpdate: widget.isHorizontal ? null : _onHandleDragUpdate,
                onTapDown: (_) {
                  _isHandleDragging = true;
                },
                onTapUp: (_) {
                  _isHandleDragging = false;
                },
                onHorizontalDragEnd: (_) => _isHandleDragging = false,
                onVerticalDragEnd: (_) => _isHandleDragging = false,
                child: Container(
                  width: widget.isHorizontal ? _handleLength : _trackWidth,
                  height: widget.isHorizontal ? _trackWidth : _handleLength,
                  decoration: const BoxDecoration(
                    color: _handleColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
