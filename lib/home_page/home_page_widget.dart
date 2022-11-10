import 'dart:math';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../sortable_list/reorderable_list.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = List<Widget>.generate(
      50,
      (int index) => Container(
        height: (Random().nextInt(200) + 20).toDouble(),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        key: ValueKey(index),
        child: Center(
          child: Text("Item $index"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Custom Sorting DEMO',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: DraggableReorderableList(
            widgets: _widgets,
            onReorder: (reorderedKeys, reorderedItems) {
              print("reorderDone $reorderedKeys $reorderedItems");
              // TODO use this info
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            gap: 10,
          ),
        ),
      ),
    );
  }
}
