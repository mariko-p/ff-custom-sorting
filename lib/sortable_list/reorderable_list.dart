import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as FlutterReorderableList;

typedef void OnReorderCallback(List<Key> keys, List<int> indices);

// Represents reorderable list
// Every widget in the widgets list should have a key defined
class DraggableReorderableList extends StatefulWidget {
  final List<Widget> widgets;
  final double gap;
  final EdgeInsets padding;
  final DraggingMode draggingMode;
  final OnReorderCallback onReorder;
  final ScrollPhysics? physics;

  const DraggableReorderableList({
    Key? key,
    required this.widgets,
    required this.onReorder,
    this.physics,
    this.gap = 0.0,
    this.padding = EdgeInsets.zero,
    this.draggingMode = DraggingMode.iOS,
  }) : super(key: key);

  @override
  _DraggableReorderableListState createState() =>
      _DraggableReorderableListState();
}

class _DraggableReorderableListState extends State<DraggableReorderableList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Key> _keys;
  late List<int> _items;

  @override
  void initState() {
    super.initState();
    _keys = List<Key>.generate(
      widget.widgets.length,
      (int index) => ValueKey(index),
    );
    _items = List<int>.generate(
      widget.widgets.length,
      (int index) => index,
    );
  }

  int _indexOfKey(Key key) {
    return widget.widgets.indexWhere((Widget d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = widget.widgets[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      widget.widgets.removeAt(draggingIndex);
      widget.widgets.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key draggedKey) {
    final newPositionIndex = _indexOfKey(draggedKey);
    final draggedItem = widget.widgets[newPositionIndex];
    debugPrint("Reordering finished for $draggedItem}");

    int oldIndex = _keys.indexWhere((Key key) => key == draggedKey);

    final key = _keys.removeAt(oldIndex);
    _keys.insert(newPositionIndex, key);

    final item = _items.removeAt(oldIndex);
    _items.insert(newPositionIndex, item);

    widget.onReorder.call(_keys, _items);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterReorderableList.ReorderableList(
      onReorder: _reorderCallback,
      onReorderDone: _reorderDone,
      child: ListView.separated(
        physics: widget.physics,
        itemCount: widget.widgets.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) => Item(
          key: widget.widgets[index].key,
          widget: widget.widgets[index],
          isFirst: index == 0,
          isLast: index == widget.widgets.length - 1,
          draggingMode: DraggingMode.iOS,
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: widget.gap,
        ),
        padding: widget.padding,
      ),
    );
  }
}

enum DraggingMode {
  iOS,
  android,
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.widget,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
  }) : super(key: key);
  final Widget widget;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 6.0, left: 6.0),
              child: const Center(
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      clipBehavior: Clip.none,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: widget,
                ),
                dragHandle,
              ],
            ),
          ),
        ),
      ),
    );

    if (draggingMode == DraggingMode.android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: widget.key!,
      childBuilder: _buildChild,
    );
  }
}
