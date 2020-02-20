/// A [Glider] is a [Widget] which takes a JSON definition and translates it into an app.
///
/// The JSON definition can be passed as a [String] or as a [Map].
/// Additionally, you can pass a URL from which to retrieve the definition.
library glider;

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icons_helper/icons_helper.dart';
import 'bottom_nav_scaffold.dart';
import 'glider_form.dart';

// A wrapper [Widget] containing a [GlobalKey] and state values
class _GliderStateful extends StatefulWidget {
  final GlobalKey<_GliderState> globalKey;
  final Map<String, dynamic> _json;

  const _GliderStateful(this._json, this.globalKey) : super(key: globalKey);

  @override
  State<StatefulWidget> createState() {
    return _GliderState(globalKey, _json);
  }
}

class _GliderState extends State<_GliderStateful> {
  final GlobalKey<_GliderState> globalKey;
  final Map<String, dynamic> _json;
  Map<String, Widget> _customWidgets = {};
  Map<String, dynamic> _state;

  _GliderState(
    this.globalKey,
    this._json, {
    Map<String, Widget> customWidgets = const {},
  }) {
    this._customWidgets = customWidgets;
  }

  @override
  void initState() {
    super.initState();

    _state = _json['state'] as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Glider._buildWidget(context, _json, globalKey, _customWidgets);
  }

  void updateStateValue(String key, dynamic value) {
    setState(() {
      _state[key] = value;
    });
  }

  void updateState(Map<String, dynamic> values) {
    setState(() {
      values.forEach((key, dynamic value) {
        _state[key] = value;
      });
    });
  }
}

/// A [Widget] based on a JSON-formatted definition.
class Glider extends StatelessWidget {
  final Map _json;
  final GlobalKey<_GliderState> _stateKey;
  final Map<String, Widget> _customWidgets;

  /// Creates a [Glider] based on the given JSON-formatted [Map].
  const Glider(
    this._json, {
    GlobalKey<_GliderState> stateKey,
    Map<String, Widget> customWidgets = const {},
    Key key,
  })  : this._stateKey = stateKey,
        this._customWidgets = customWidgets,
        super(key: key);

  /// Creates a [Glider] based on the given API endpoint, with an optional [fallback] parameter.
  ///
  /// The endpoint should return a JSON-formatted Glider definition.
  ///
  /// The [fallback] should be a JSON-formatted [String] defining the widget to display in case the endpoint can't be reached.
  ///
  /// If the endpoint returns an error, or there is no network connection, the [fallback] will be used.
  /// If no [fallback] is given, a [Widget] displaying an error message will be displayed.
  static Widget appFromUrl(
    String url, {
    String fallback,
    Map<String, Widget> customWidgets = const {},
  }) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            return Glider.appFromString(snapshot.data.body);
          } else if (fallback != null) {
            return Glider.appFromString(fallback);
          } else {
            return MaterialApp(
              home: Center(
                child: Text(
                  snapshot.hasError
                      ? snapshot.error.toString()
                      : 'An error occurred',
                ),
              ),
              title: "Glider App",
            );
          }
        } else {
          return const MaterialApp(
            home: Center(
              child: CircularProgressIndicator(),
            ),
            title: "Glider App",
          );
        }
      },
    );
  }

  /// Creates a [Glider] based on a JSON-formatted [String] definition.
  static Widget appFromString(
    String json, {
    Map<String, Widget> customWidgets = const {},
  }) {
    return Glider(jsonDecode(json) as Map, customWidgets: customWidgets);
  }

  /// Creates a [Glider] based on a definition provided by a Cloud Firestore [DocumentReference].
  ///
  /// This widget will automatically update as the document is changed in Cloud Firestore.
  static Widget appFromDocumentReference(
    DocumentReference ref,
    String fallback,
  ) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return fallback != null
              ? Glider.appFromString(fallback)
              : Scaffold(
                  body: Center(
                    child: Text(
                      snapshot.hasError
                          ? snapshot.error.toString()
                          : 'An error occurred',
                    ),
                  ),
                );
        } else if (snapshot.hasData) {
          final Map<String, dynamic> json = snapshot.data.data;
          if (json['type'] != 'app' && json['type'] != 'firestore_ref') {
            throw Exception("The definition does not define an app widget.");
          }
          return Glider.appFromString(jsonEncode(json));
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  static Widget _fromUrl(String url) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            final json = jsonDecode(snapshot.data.body) as Map;
            if (json['type'] != 'scaffold') {
              throw Exception(
                  "Only Scaffold widgets can be retrieved from URLs");
            }
            return Glider(json);
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  static Widget _fromDocumentReference(DocumentReference ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("An error occurred"));
        } else if (snapshot.hasData) {
          final Map<String, dynamic> json = snapshot.data.data;
          return Glider.appFromString(jsonEncode(json));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If this widget contains a state object, wrap with [_GliderStateful]
    if (_json.containsKey("state")) {
      return _GliderStateful(_json as Map<String, dynamic>, GlobalKey());
    }

    return _buildWidget(
      context,
      Map<String, dynamic>.from(_json),
      _stateKey,
      _customWidgets,
    );
  }

  static Widget _buildWidget(
    BuildContext context,
    Map<String, dynamic> json,
    GlobalKey<_GliderState> stateKey,
    Map<String, Widget> customWidgets,
  ) {
    final String type = json['type'] as String;
    if (customWidgets.containsKey(type)) {
      return customWidgets[type];
    } else {
      switch (type) {
        case 'url':
          return Glider._fromUrl(json['url'] as String);
        case 'firestore_ref':
          return Glider._fromDocumentReference(
              Firestore.instance.document(json['ref'] as String));
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
        case 'flat_button':
          return _buildFlatButton(context, json, stateKey: stateKey);
        case 'form':
          return GliderForm(json);
        case 'hero':
          return _buildHero(context, json, stateKey: stateKey);
        case 'icon':
          final String icon = _valueFromState(json, "icon", stateKey) as String;
          return _buildIcon(context, icon);
        case 'image':
          return _buildImage(context, json);
        case 'linear_progress':
          return _buildLinearProgressIndiator(context, json);
        case 'list_tile':
          return _buildListTile(context, json, stateKey: stateKey);
        case 'list_view':
          return _buildListView(context, json, stateKey: stateKey);
        case 'outline_button':
          return _buildOutlineButton(context, json, stateKey: stateKey);
        case 'padding':
          return _buildPadding(context, json, stateKey: stateKey);
        case 'sized_box':
          return _buildSizedBox(context, json, stateKey: stateKey);
        case 'raised_button':
          return _buildRaisedButton(context, json, stateKey: stateKey);
        case 'row':
          return _buildRow(context, json, stateKey: stateKey);
        case 'text':
          return _buildText(context, json, stateKey: stateKey);
        case 'tooltip':
          return _buildTooltip(context, json);
        default:
          return const Center();
      }
    }
  }

  static MaterialApp _buildApp(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return MaterialApp(
      home: Glider(
        json['home'] as Map,
        stateKey: stateKey,
      ),
      title: _valueFromState(json, 'title', stateKey) as String,
      theme: _buildTheme(
        context,
        json['theme'] as Map<String, dynamic>,
        stateKey: stateKey,
      ),
      debugShowCheckedModeBanner: json["debug"] as bool ?? false,
    );
  }

  static Scaffold _buildScaffold(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return Scaffold(
      appBar: json['app_bar'] != null
          ? _buildAppBar(
              context,
              json['app_bar'] as Map<String, dynamic>,
              stateKey: stateKey,
            )
          : null,
      body: json['body'] != null
          ? Glider(
              json['body'] as Map,
              stateKey: stateKey,
            )
          : null,
      floatingActionButton: json['fab'] != null
          ? Glider(
              json['fab'] as Map,
              stateKey: stateKey,
            )
          : null,
      drawer: json['drawer'] != null
          ? Glider(
              json['drawer'] as Map,
              stateKey: stateKey,
            )
          : null,
      bottomNavigationBar: json['bottom_bar'] != null
          ? Glider(
              json['bottom_bar'] as Map,
              stateKey: stateKey,
            )
          : null,
      bottomSheet: json['bottom_sheet'] != null
          ? Glider(
              json['bottom_sheet'] as Map,
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
    GlobalKey<_GliderState> stateKey,
  }) {
    return AppBar(
      title: Text(_valueFromState(json, "title", stateKey) as String),
    );
  }

  static AspectRatio _buildAspectRatio(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return AspectRatio(
      aspectRatio: json['aspect_ratio'] as double,
      child: Glider(json['child'] as Map, stateKey: stateKey),
    );
  }

  static ButtonBar _buildButtonBar(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final buttonsJson = json['buttons'] as List<Map>;
    final buttons = buttonsJson
        .map<Widget>((Map button) => Glider(
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
    GlobalKey<_GliderState> stateKey,
  }) {
    final color = _valueFromState(json, "color", stateKey) as String;
    final elevation =
        _valueFromState(json, "elevation", stateKey) as double ?? 1.0;

    return Card(
      color: _colorFromHex(color),
      elevation: elevation,
      child: Glider(
        json['child'] as Map,
        stateKey: stateKey,
      ),
    );
  }

  static Center _buildCenter(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return Center(
      child: json['child'] != null
          ? Glider(
              json['child'] as Map,
              stateKey: stateKey,
            )
          : null,
    );
  }

  static CircularProgressIndicator _buildCircularProgressIndicator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return const CircularProgressIndicator();
  }

  static Column _buildColumn(BuildContext context, Map<String, dynamic> json,
      {GlobalKey<_GliderState> stateKey}) {
    final childrenJson = json['children'] as List<Map>;
    final List<Widget> children = childrenJson
        .map((child) => Glider(
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
      indent: json['indent'] as double ?? 0.0,
    );
  }

  static Drawer _buildDrawer(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return Drawer(
      child: Glider(
        json['child'] as Map,
        stateKey: stateKey,
      ),
    );
  }

  static FlatButton _buildFlatButton(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final VoidCallback onTap = _onTap(context, json, stateKey);

    return FlatButton(
      onPressed: onTap,
      child: Text(_valueFromState(json, 'text', stateKey) as String),
    );
  }

  static FloatingActionButton _buildFab(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final VoidCallback onTap = _onTap(context, json, stateKey);

    final icon = _valueFromState(json, 'icon', stateKey) as String;

    return json['label'] != null
        ? FloatingActionButton.extended(
            icon: _buildIcon(context, icon),
            label: Text(_valueFromState(json, 'label', stateKey) as String),
            onPressed: onTap,
          )
        : FloatingActionButton(
            onPressed: onTap,
            child: _buildIcon(context, icon),
          );
  }

  static Hero _buildHero(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return Hero(
      tag: json['tag'],
      child: Glider(
        json['child'] as Map,
        stateKey: stateKey,
      ),
    );
  }

  static Icon _buildIcon(BuildContext context, String icon) {
    return Icon(getIconGuessFavorMaterial(name: icon));
  }

  static Image _buildImage(BuildContext context, Map<String, dynamic> json) {
    return Image.network(json['src'] as String);
  }

  static LinearProgressIndicator _buildLinearProgressIndiator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return const LinearProgressIndicator();
  }

  static ListTile _buildListTile(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final VoidCallback onTap = _onTap(context, json, stateKey);

    return ListTile(
      title: json['title'] != null
          ? Text(_valueFromState(json, 'title', stateKey) as String)
          : null,
      subtitle: json['subtitle'] != null
          ? Text(_valueFromState(json, 'subtitle', stateKey) as String)
          : null,
      leading: json['leading'] != null
          ? Glider(_valueFromState(json, 'leading', stateKey) as Map)
          : null,
      trailing: json['trailing'] != null
          ? Glider(_valueFromState(json, 'trailing', stateKey) as Map)
          : null,
      onTap: onTap,
    );
  }

  static ListView _buildListView(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final childrenJson = json['children'] as List<Map>;
    final List<Widget> children = childrenJson
        .map((child) => Glider(
              child,
              stateKey: stateKey,
            ))
        .toList();
    return ListView(children: children);
  }

  static OutlineButton _buildOutlineButton(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final VoidCallback onTap = _onTap(context, json, stateKey);

    return OutlineButton(
      onPressed: onTap,
      child: Text(_valueFromState(json, 'text', stateKey) as String),
    );
  }

  static Padding _buildPadding(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    return Padding(
      padding: json['padding'] != null
          ? EdgeInsets.all(json['padding'] as double)
          : json['padding_vertical'] != null &&
                  json['padding_horizontal'] != null
              ? EdgeInsets.symmetric(
                  vertical: json['padding_vertical'] as double,
                  horizontal: json['padding_horizontal'] as double,
                )
              : EdgeInsets.fromLTRB(
                  json['padding_left'] as double,
                  json['padding_top'] as double,
                  json['padding_right'] as double,
                  json['padding_bottom'] as double,
                ),
      child: Glider(
        json['child'] as Map,
        stateKey: stateKey,
      ),
    );
  }

  static RaisedButton _buildRaisedButton(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final VoidCallback onTap = _onTap(context, json, stateKey);

    return RaisedButton(
      onPressed: onTap,
      child: Text(_valueFromState(json, 'text', stateKey) as String),
    );
  }

  static Row _buildRow(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final childrenJson = json['children'] as List<Map>;
    final List<Widget> children = childrenJson
        .map((child) => Glider(
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
    GlobalKey<_GliderState> stateKey,
  }) {
    return SizedBox(
      width: _valueFromState(json, "width", stateKey) as double,
      height: _valueFromState(json, "height", stateKey) as double,
      child: json['child'] != null
          ? Glider(
              json['child'] as Map,
              stateKey: stateKey,
            )
          : null,
    );
  }

  static ThemeData _buildTheme(
    BuildContext context,
    Map<String, dynamic> json, {
    GlobalKey<_GliderState> stateKey,
  }) {
    final primary = _valueFromState(json, "primary_color", stateKey) as String;
    final accent = _valueFromState(json, "accent_color", stateKey) as String;
    final dark = _valueFromState(json, "dark", stateKey) as bool;

    return ThemeData(
      primaryColor: _colorFromHex(primary),
      accentColor: _colorFromHex(accent),
      brightness: dark == true ? Brightness.dark : Brightness.light,
      inputDecorationTheme: json['input_theme'] != null
          ? InputDecorationTheme(
              filled: json['input_theme']['filled'] == true,
              border: json['input_theme']['outlined'] == true
                  ? const OutlineInputBorder()
                  : const UnderlineInputBorder(),
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
    GlobalKey<_GliderState> stateKey,
  }) {
    final String text = _valueFromState(json, "text", stateKey) as String;
    return Text(text);
  }

  static Tooltip _buildTooltip(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Tooltip(
      message: json['message'] as String,
      child: Glider(json['child'] as Map),
    );
  }

  static VoidCallback _onTap(
    BuildContext context,
    Map<String, dynamic> json,
    GlobalKey<_GliderState> stateKey,
  ) {
    if (json.containsKey('cloud_function')) {
      return () async {
        try {
          await CloudFunctions.instance
              .getHttpsCallable(
                functionName: json['cloud_function'] as String,
              )
              .call();
          if (json.containsKey('destination')) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => Glider(json['destination'] as Map),
              ),
            );
          }
        } catch (e) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(e.message as String)),
          );
        }
      };
    } else if (json.containsKey('destination')) {
      return () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => Glider(json['destination'] as Map),
          ),
        );
      };
    } else if (json.containsKey('state_change') &&
        stateKey != null &&
        stateKey.currentState != null) {
      return () {
        final _GliderState currentState = stateKey.currentState;
        if (currentState != null) {
          currentState.updateState(
            json['state_change'] as Map<String, dynamic>,
          );
        }
      };
    }
    return null;
  }

  // Get the value of the given field from the state if present
  static dynamic _valueFromState(
    Map<String, dynamic> json,
    String fieldKey,
    GlobalKey<_GliderState> stateKey,
  ) {
    final dynamic jsonValue = json[fieldKey];

    if (stateKey != null &&
        jsonValue is Map &&
        jsonValue['type'] == 'state_value') {
      final valueKey = jsonValue['key'] as String;
      final _GliderState currentState = stateKey.currentState;
      return currentState._state[valueKey];
    }
    return json[fieldKey];
  }

  static Color _colorFromHex(
    String hex,
  ) {
    if (hex != null && hex.isNotEmpty) {
      return Color(
        int.parse(
          hex.replaceAll('#', ''),
          radix: 16,
        ),
      ).withOpacity(1.0);
    } else {
      return null;
    }
  }
}
