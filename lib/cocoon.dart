/// A [Cocoon] is a [Widget] which takes a JSON definition and translates it into an app.
///
/// The JSON definition can be passed as a [String] or as a [Map].
/// Additionally, you can pass a URL from which to retrieve the definition.
library cocoon;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icons_helper/icons_helper.dart';
import 'bottom_nav_scaffold.dart';
import 'cocoon_form.dart';

// A wrapper [Widget] containing a [GlobalKey] and state values
class _CocoonStateful extends StatefulWidget {
  final GlobalKey<_CocoonState> globalKey;
  final Map<String, dynamic> _json;

  _CocoonStateful(this._json, this.globalKey) : super(key: globalKey);

  @override
  State<StatefulWidget> createState() {
    return _CocoonState(globalKey, _json);
  }
}

class _CocoonState extends State<_CocoonStateful> {
  final GlobalKey<_CocoonState> globalKey;
  final Map<String, dynamic> _json;
  Map<String, Widget> _customWidgets = {};
  Map<String, dynamic> _state;

  _CocoonState(
    this.globalKey,
    this._json, {
    Map<String, Widget> customWidgets: const {},
  }) {
    this._customWidgets = customWidgets;
  }

  @override
  void initState() {
    super.initState();

    _state = _json['state'];
  }

  @override
  Widget build(BuildContext context) {
    return Cocoon._buildWidget(context, _json, globalKey, _customWidgets);
  }

  void updateStateValue(String key, dynamic value) {
    setState(() {
      _state[key] = value;
    });
  }

  void updateState(Map<String, dynamic> values) {
    setState(() {
      values.forEach((key, value) {
        _state[key] = value;
      });
    });
  }
}

/// A [Widget] based on a JSON-formatted definition.
class Cocoon extends StatelessWidget {
  final Map<String, dynamic> _json;
  final GlobalKey<_CocoonState> _stateKey;
  final Map<String, Widget> _customWidgets;

  /// Creates a [Cocoon] based on the given JSON-formatted [Map].
  Cocoon(
    this._json, {
    GlobalKey<_CocoonState> stateKey,
    Map<String, Widget> customWidgets: const {},
    Key key,
  })  : this._stateKey = stateKey,
        this._customWidgets = customWidgets,
        super(key: key);

  /// Creates a [Cocoon] based on the given API endpoint, with an optional [fallback] parameter.
  ///
  /// The endpoint should return a JSON-formatted Cocoon definition.
  ///
  /// The [fallback] should be a JSON-formatted [String] defining the widget to display in case the endpoint can't be reached.
  ///
  /// If the endpoint returns an error, or there is no network connection, the [fallback] will be used.
  /// If no [fallback] is given, a [Widget] displaying an error message will be displayed.
  static Widget appFromUrl(String url, {String fallback}) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            return Cocoon.appFromString(snapshot.data.body);
          } else if (fallback != null) {
            return Cocoon.appFromString(fallback);
          } else {
            return MaterialApp(
              home: Center(
                child: Text(
                  snapshot.hasError
                      ? snapshot.error.toString()
                      : 'An error occurred',
                ),
              ),
              title: "Cocoon App",
            );
          }
        } else {
          return MaterialApp(
            home: Center(
              child: CircularProgressIndicator(),
            ),
            title: "Cocoon App",
          );
        }
      },
    );
  }

  /// Creates a [Cocoon] based on a JSON-formatted [String] definition.
  static Widget appFromString(String json) {
    return Cocoon(jsonDecode(json));
  }

  static Widget _fromUrl(String url) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            final json = jsonDecode(snapshot.data.body);
            if (json['type'] != 'scaffold') {
              throw Exception(
                  "Only Scaffold widgets can be retrieved from URLs");
            }
            return Cocoon(json);
          } else {
            return Scaffold(
              body: Center(
                child: Text(
                  snapshot.hasError
                      ? snapshot.error.toString()
                      : 'An error occurred',
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_json);

    // If this widget contains a state object, wrapp with [_CocoonStateful]
    if (_json.containsKey("state")) {
      return _CocoonStateful(_json, GlobalKey());
    }

    return _buildWidget(context, _json, _stateKey, _customWidgets);
  }

  static Widget _buildWidget(
    BuildContext context,
    Map<String, dynamic> json,
    GlobalKey<_CocoonState> stateKey,
    Map<String, Widget> customWidgets,
  ) {
    final String type = json['type'];
    if (customWidgets.containsKey(type)) {
      return customWidgets[type];
    } else {
      switch (type) {
        case 'url':
          return Cocoon._fromUrl(json['url']);
        case 'app':
          return _buildApp(context, json, stateKey: stateKey);
        case 'scaffold':
          return _buildScaffold(context, json, stateKey: stateKey);
        case 'bottom_nav_scaffold':
          return _buildBottomNavScaffold(context, json);
        case 'app_bar':
          return _buildAppBar(context, json, stateKey: stateKey);
        case 'aspect_ratio':
          return _buildAspectRatio(context, json, stateKey: stateKey);
        case 'button_bar':
          return _buildButtonBar(context, json, stateKey: stateKey);
        case 'card':
          return _buildCard(context, json, stateKey: stateKey);
        case 'center':
          return _buildCenter(context, json, stateKey: stateKey);
        case 'circular_progress':
          return _buildCircularProgressIndicator(context, json);
        case 'column':
          return _buildColumn(context, json, stateKey: stateKey);
        case 'divider':
          return _buildDivider(context, json);
        case 'drawer':
          return _buildDrawer(context, json, stateKey: stateKey);
        case 'fab':
          return _buildFab(context, json, stateKey: stateKey);
        case 'form':
          return CocoonForm(json);
        case 'hero':
          return _buildHero(context, json, stateKey: stateKey);
        case 'icon':
          String icon = _valueFromState(json, "icon", stateKey);
          return _buildIcon(context, icon);
        case 'image':
          return _buildImage(context, json);
        case 'linear_progress':
          return _buildLinearProgressIndiator(context, json);
        case 'list_tile':
          return _buildListTile(context, json, stateKey: stateKey);
        case 'list_view':
          return _buildListView(context, json, stateKey: stateKey);
        case 'padding':
          return _buildPadding(context, json, stateKey: stateKey);
        case 'sized_box':
          return _buildSizedBox(context, json, stateKey: stateKey);
        case 'row':
          return _buildRow(context, json, stateKey: stateKey);
        case 'text':
          return _buildText(context, json, stateKey: stateKey);
        case 'tooltip':
          return _buildTooltip(context, json);
        case 'button':
          return _buildButton(context, json, stateKey: stateKey);
        default:
          return Center();
      }
    }
  }

  static MaterialApp _buildApp(BuildContext context, Map<String, dynamic> json,
      {GlobalKey<_CocoonState> stateKey}) {
    return MaterialApp(
      home: Cocoon(
        json['home'],
        stateKey: stateKey,
      ),
      title: _valueFromState(json, 'title', stateKey),
      theme: _buildTheme(context, json['theme'], stateKey: stateKey),
      debugShowCheckedModeBanner: json["debug"] != null ? json["debug"] : false,
    );
  }

  static Scaffold _buildScaffold(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return Scaffold(
      appBar: json['app_bar'] != null
          ? _buildAppBar(context, json['app_bar'], stateKey: stateKey)
          : null,
      body: json['body'] != null
          ? Cocoon(
              json['body'],
              stateKey: stateKey,
            )
          : null,
      floatingActionButton: json['fab'] != null
          ? Cocoon(
              json['fab'],
              stateKey: stateKey,
            )
          : null,
      drawer: json['drawer'] != null
          ? Cocoon(
              json['drawer'],
              stateKey: stateKey,
            )
          : null,
      bottomNavigationBar: json['bottom_bar'] != null
          ? Cocoon(
              json['bottom_bar'],
              stateKey: stateKey,
            )
          : null,
      bottomSheet: json['bottom_sheet'] != null
          ? Cocoon(
              json['bottom_sheet'],
              stateKey: stateKey,
            )
          : null,
    );
  }

  static BottomNavScaffold _buildBottomNavScaffold(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return BottomNavScaffold(json);
  }

  static AppBar _buildAppBar(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return AppBar(
      title: Text(_valueFromState(json, "title", stateKey)),
    );
  }

  static AspectRatio _buildAspectRatio(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return AspectRatio(
      aspectRatio: json['aspect_ratio'],
      child: Cocoon(json['child'], stateKey: stateKey),
    );
  }

  // TODO Bottom navigation bar

  static ButtonBar _buildButtonBar(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    final List<dynamic> buttonsJson = json['buttons'];
    final List<Widget> buttons = buttonsJson
        .map((button) => Cocoon(
              button,
              stateKey: stateKey,
            ))
        .toList();
    return ButtonBar(
      children: buttons,
    );
  }

  static Card _buildCard(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    String color = _valueFromState(json, "color", stateKey);
    double elevation = _valueFromState(json, "elevation", stateKey) ?? 1.0;

    return Card(
      child: Cocoon(
        json['child'],
        stateKey: stateKey,
      ),
      color: _colorFromHex(color),
      elevation: elevation,
    );
  }

  static Center _buildCenter(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return Center(
      child: json['child'] != null
          ? Cocoon(
              json['child'],
              stateKey: stateKey,
            )
          : null,
    );
  }

  // TODO Checkbox

  // TODO Chip

  static CircularProgressIndicator _buildCircularProgressIndicator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return CircularProgressIndicator();
  }

  static Column _buildColumn(BuildContext context, Map<String, dynamic> json,
      {GlobalKey<_CocoonState> stateKey}) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children = childrenJson
        .map((child) => Cocoon(
              child,
              stateKey: stateKey,
            ))
        .toList();
    return Column(
      children: children,
    );
  }

  static Divider _buildDivider(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Divider(
      indent: json['indent'] != null ? json['indent'] : 0.0,
    );
  }

  static Drawer _buildDrawer(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return Drawer(
        child: Cocoon(
      json['child'],
      stateKey: stateKey,
    ));
  }

  // TODO Dropdown button

  // TODO Flat button

  static FloatingActionButton _buildFab(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    Function onTap = _onTap(context, json, stateKey);

    String icon = _valueFromState(json, 'icon', stateKey);

    return json['label'] != null
        ? FloatingActionButton.extended(
            icon: _buildIcon(context, icon),
            label: Text(_valueFromState(json, 'label', stateKey)),
            onPressed: onTap,
          )
        : FloatingActionButton(
            child: _buildIcon(context, icon),
            onPressed: onTap,
          );
  }

  static RaisedButton _buildButton(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    Function onTap = _onTap(context, json, stateKey);

    return RaisedButton(
      child: Text(_valueFromState(json, 'label', stateKey)),
      onPressed: onTap,
    );
  }

  // TODO Form

  // TODO FormField

  // TODO GridView

  static Hero _buildHero(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return Hero(
      tag: json['tag'],
      child: Cocoon(
        json['child'],
        stateKey: stateKey,
      ),
    );
  }

  static Icon _buildIcon(BuildContext context, String icon) {
    return Icon(getIconGuessFavorMaterial(name: icon));
  }

  // TODO IconButton

  static Image _buildImage(BuildContext context, Map<String, dynamic> json) {
    return Image.network(json['src']);
  }

  static LinearProgressIndicator _buildLinearProgressIndiator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return LinearProgressIndicator();
  }

  static ListTile _buildListTile(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    final Function onTap = _onTap(context, json, stateKey);

    return ListTile(
      title: json['title'] != null
          ? Text(_valueFromState(json, 'title', stateKey))
          : null,
      subtitle: json['subtitle'] != null
          ? Text(_valueFromState(json, 'subtitle', stateKey))
          : null,
      leading: json['leading'] != null
          ? Cocoon(_valueFromState(json, 'leading', stateKey))
          : null,
      trailing: json['trailing'] != null
          ? Cocoon(_valueFromState(json, 'trailing', stateKey))
          : null,
      onTap: onTap,
    );
  }

  static ListView _buildListView(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children = childrenJson
        .map((child) => Cocoon(
              child,
              stateKey: stateKey,
            ))
        .toList();
    return ListView(children: children);
  }

  static Padding _buildPadding(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return Padding(
        child: Cocoon(
          json['child'],
          stateKey: stateKey,
        ),
        padding: json['padding'] != null
            ? EdgeInsets.all(json['padding'])
            : json['padding_vertical'] != null &&
                    json['padding_horizontal'] != null
                ? EdgeInsets.symmetric(
                    vertical: json['padding_vertical'],
                    horizontal: json['padding_horizontal'],
                  )
                : EdgeInsets.fromLTRB(
                    json['padding_left'],
                    json['padding_top'],
                    json['padding_right'],
                    json['padding_bottom'],
                  ));
  }

  // TODO PopupMenuButton

  // TODO Radio

  // TODO RaisedButton

  // TODO RefreshIndicator

  static Row _buildRow(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children = childrenJson
        .map((child) => Cocoon(
              child,
              stateKey: stateKey,
            ))
        .toList();
    return Row(
      children: children,
    );
  }

  static SizedBox _buildSizedBox(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    return SizedBox(
      width: _valueFromState(json, "width", stateKey),
      height: _valueFromState(json, "height", stateKey),
      child: json['child'] != null
          ? Cocoon(
              json['child'],
              stateKey: stateKey,
            )
          : null,
    );
  }

  // TODO Slider

  // TODO SnackBar

  // TODO Switch

  // TODO TabBar

  // TODO TabBarView

  // TODO TextField

  static ThemeData _buildTheme(BuildContext context, Map<String, dynamic> json,
      {GlobalKey<_CocoonState> stateKey}) {
    String primary = _valueFromState(json, "primary_color", stateKey);
    String accent = _valueFromState(json, "accent_color", stateKey);
    bool dark = _valueFromState(json, "dark", stateKey);

    return ThemeData(
      primaryColor: _colorFromHex(primary),
      accentColor: _colorFromHex(accent),
      brightness: dark == true ? Brightness.dark : Brightness.light,
      inputDecorationTheme: json['input_theme'] != null
          ? InputDecorationTheme(
              filled: json['input_theme']['filled'] == true,
              border: json['input_theme']['outlined'] == true
                  ? OutlineInputBorder()
                  : UnderlineInputBorder(),
            )
          : null,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: _colorFromHex(primary),
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
      ),
    );
  }

  static Text _buildText(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_CocoonState> stateKey,
  }) {
    String text = _valueFromState(json, "text", stateKey);
    return Text(text);
  }

  static Tooltip _buildTooltip(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Tooltip(
      child: Cocoon(json['child']),
      message: json['message'],
    );
  }

  static Function _onTap(
    BuildContext context,
    Map<String, dynamic> json,
    GlobalKey<_CocoonState> stateKey,
  ) {
    if (json.containsKey('destination')) {
      return () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Cocoon(json['destination']),
        ));
      };
    } else if (json.containsKey('state_change') &&
        stateKey != null &&
        stateKey.currentState != null) {
      return () {
        _CocoonState currentState = stateKey.currentState;
        if (currentState != null) {
          currentState.updateState(json['state_change']);
        }
      };
    }
    return () {};
  }

  // Get the value of the given field from the state if present
  static dynamic _valueFromState(
    Map<String, dynamic> json,
    String fieldKey,
    GlobalKey<_CocoonState> stateKey,
  ) {
    dynamic jsonValue = json[fieldKey];

    if (stateKey != null &&
        jsonValue is Map &&
        jsonValue['type'] == 'state_value') {
      String valueKey = jsonValue['key'];
      _CocoonState currentState = stateKey.currentState;
      return currentState._state[valueKey];
    }
    return json[fieldKey];
  }

  static Color _colorFromHex(
    String hex,
  ) {
    if (hex != null && hex.isNotEmpty) {
      return Color(int.parse(hex.replaceAll('#', ''), radix: 16))
          .withOpacity(1.0);
    } else
      return null;
  }
}
