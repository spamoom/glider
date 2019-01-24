import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'cocoon.dart';

class BottomNavScaffold extends StatefulWidget {
  final Map<String, dynamic> _json;

  BottomNavScaffold(this._json, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavScaffoldState(_json);
  }
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  final Map<String, dynamic> _json;
  List<dynamic> _itemsJson;

  int _currentSelection = 0;

  _BottomNavScaffoldState(this._json) {
    this._itemsJson = _json['items'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _json['app_bar'] != null
          ? AppBar(
              title: Text(_json['app_bar']['title']),
            )
          : null,
      body: _itemsJson[_currentSelection] != null
          ? Cocoon(_itemsJson[_currentSelection]['body'])
          : null,
      bottomNavigationBar: _buildNavigationBar(context),
      floatingActionButton: _json['fab'] != null ? Cocoon(_json['fab']) : null,
      drawer: _json['drawer'] != null ? Cocoon(_json['drawer']) : null,
      bottomSheet:
          _json['bottom_sheet'] != null ? Cocoon(_json['bottom_sheet']) : null,
    );
  }

  BottomNavigationBar _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentSelection,
      items: _itemsJson.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(getMaterialIcon(name: item['icon'])),
          title: Text(item['title']),
        );
      }).toList(),
      onTap: (position) {
        setState(() {
          this._currentSelection = position;
        });
      },
    );
  }
}
