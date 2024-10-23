import 'dart:math';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../sortable_list/reorderable_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Custom Sorting DEMO',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
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
