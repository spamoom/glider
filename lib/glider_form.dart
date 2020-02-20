import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class GliderForm extends StatefulWidget {
  final Map<String, dynamic> _json;

  const GliderForm(this._json, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GliderFormState(_json);
  }
}

class _GliderFormState extends State<GliderForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _json;
  final _values = <String, dynamic>{};
  final _textControllers = <String, TextEditingController>{};

  _GliderFormState(this._json) {
    final fields = _json['fields'] as List<Map<String, dynamic>>;
    fields.forEach((Map<String, dynamic> field) {
      final String name = field['name'] as String;
      _values[name] = field['initial_value'];
    });
  }

  void _setValue(String name, dynamic value) {
    setState(() {
      _values[name] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = _json['fields'] as List<Map<String, dynamic>>;
    final List<Widget> children = [];
    fields.forEach((field) {
      children.add(_buildField(context, field));
    });

    final buttons = _json['buttons'] as List<Map<String, dynamic>>;
    children.add(_buildButtons(context, buttons));

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: children,
      ),
    );
  }

  Widget _buildField(BuildContext context, Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'text_field':
        return _buildTextField(context, json);
      case 'checkbox':
        return _buildCheckbox(context, json);
      case 'switch':
        return _buildSwitch(context, json);
      case 'dropdown_menu':
        return _buildDropdownButton(context, json);
      case 'radio_group':
        return _buildRadioGroup(context, json);
      case 'time':
        return _buildTimePicker(context, json);
      case 'date':
        return _buildDatePicker(context, json);
      default:
        return const ListTile();
    }
  }

  Widget _buildTextField(BuildContext context, Map<String, dynamic> json) {
    if (!_textControllers.containsKey(json['name'])) {
      _textControllers[json['name'] as String] = TextEditingController(
        text: json['initial_value'] as String,
      );
      _textControllers[json['name']].addListener(() {
        _setValue(json['name'] as String, _textControllers[json['name']].text);
      });
    }
    TextInputType keyboardType;
    TextCapitalization capitalization;

    switch (json['keyboard_type'] as String) {
      case 'text':
        keyboardType = TextInputType.text;
        break;
      case 'email':
        keyboardType = TextInputType.emailAddress;
        break;
      case 'phone':
        keyboardType = TextInputType.phone;
        break;
      case 'number':
        keyboardType = TextInputType.number;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    switch (json['capitalization'] as String) {
      case 'words':
        capitalization = TextCapitalization.words;
        break;
      case 'sentences':
        capitalization = TextCapitalization.sentences;
        break;
      case 'characters':
        capitalization = TextCapitalization.characters;
        break;
      default:
        capitalization = TextCapitalization.none;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        controller: _textControllers[json['name']],
        decoration: InputDecoration(
          labelText: json['label'] as String,
          hintText: json['hint'] as String,
        ),
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        obscureText: json['obscure_text'] == true,
        validator: (value) {
          if (json['required'] == true && (value == null || value.isEmpty)) {
            return 'Please enter a value';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, Map<String, dynamic> json) {
    return CheckboxListTile(
      value: _values[json['name']] as bool,
      onChanged: (value) {
        _setValue(json['name'] as String, value);
      },
      title: json['title'] != null ? Text(json['title'] as String) : null,
      subtitle:
          json['subtitle'] != null ? Text(json['subtitle'] as String) : null,
      secondary: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon'] as String))
          : null,
    );
  }

  Widget _buildSwitch(BuildContext context, Map<String, dynamic> json) {
    return SwitchListTile(
      value: _values[json['name']] as bool,
      onChanged: (value) {
        _setValue(json['name'] as String, value);
      },
      title: json['title'] != null ? Text(json['title'] as String) : null,
      subtitle:
          json['subtitle'] != null ? Text(json['subtitle'] as String) : null,
      secondary: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon'] as String))
          : null,
    );
  }

  Widget _buildDropdownButton(BuildContext context, Map<String, dynamic> json) {
    final options = json['options'] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownButtonFormField<dynamic>(
        value: _values[json['name']],
        onChanged: (dynamic value) {
          _setValue(json['name'] as String, value);
        },
        items: options.map((option) {
          return DropdownMenuItem<dynamic>(
            value: option['value'],
            child: Text(option['text'] as String),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: json['label'] as String,
        ),
        validator: (dynamic value) {
          if (json['required'] == true && value == null) {
            return 'Please select an option';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildRadioGroup(BuildContext context, Map<String, dynamic> json) {
    final options = json['options'] as List<Map<String, dynamic>>;

    final List<Widget> children = [
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          json['label'] as String,
          style: Theme.of(context).textTheme.subtitle,
        ),
      )
    ];

    children.addAll(options.map((option) {
      return RadioListTile<dynamic>(
        value: option['value'],
        groupValue: _values[json['name']],
        onChanged: (dynamic value) {
          _setValue(json['name'] as String, value);
        },
        title: option['title'] != null ? Text(option['title'] as String) : null,
        subtitle: option['subtitle'] != null
            ? Text(option['subtitle'] as String)
            : null,
        secondary: option['icon'] != null
            ? Icon(getIconGuessFavorMaterial(name: option['icon'] as String))
            : null,
      );
    }).toList());

    children.add(const Divider());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildDatePicker(BuildContext context, Map<String, dynamic> json) {
    final jsonFormat = DateFormat("yyyy/MM/dd");
    final displayFormat = DateFormat(json['format'] as String ?? "dd/MM/yyyy");
    return ListTile(
      title: Text(
        displayFormat.format(jsonFormat.parse(_values[json['name']] as String)),
      ),
      subtitle: json['label'] != null ? Text(json['label'] as String) : null,
      leading: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon'] as String))
          : null,
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: jsonFormat.parse(_values[json['name']] as String),
          firstDate: json['min'] != null
              ? jsonFormat.parse(json['min'] as String)
              : DateTime.now().add(const Duration(days: -365 * 100)),
          lastDate: json['max'] != null
              ? jsonFormat.parse(json['max'] as String)
              : DateTime.now().add(const Duration(days: 365 * 100)),
        );
        if (newDate != null) {
          _setValue(json['name'] as String, jsonFormat.format(newDate));
        }
      },
    );
  }

  Widget _buildTimePicker(BuildContext context, Map<String, dynamic> json) {
    final format = DateFormat("H:mm");
    return ListTile(
      title: Text(_values[json['name']] as String),
      subtitle: json['label'] != null ? Text(json['label'] as String) : null,
      leading: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon'] as String))
          : null,
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
              format.parse(_values[json['name']] as String)),
        );
        if (newTime != null) {
          _setValue(json['name'] as String, newTime.format(context));
        }
      },
    );
  }

  Widget _buildButtons(BuildContext context, List<Map<String, dynamic>> json) {
    final children = json
        .map<Widget>(
          (button) => _buildButton(context, button),
        )
        .toList();
    return ButtonBar(children: children);
  }

  Widget _buildButton(BuildContext context, Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'raised_button':
        return _buildRaisedButton(context, json);
      case 'text_button':
        return _buildTextButton(context, json);
      case 'outline_button':
        return _buildOutlineButton(context, json);
      default:
        return null;
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      final Map<String, dynamic> submitTo =
          _json['submit_to'] as Map<String, dynamic>;
      if (submitTo != null) {
        Future<Response> call;
        final String body = jsonEncode(_values);
        final headers = <String, String>{"content-type": "application/json"};
        switch (submitTo['method'] as String) {
          case 'put':
            call = put(submitTo['url'], body: body, headers: headers);
            break;
          case 'patch':
            call = patch(submitTo['url'], body: body, headers: headers);
            break;
          default:
            call = post(submitTo['url'], body: body, headers: headers);
        }
        call.then((Response response) {}).catchError((dynamic _) {});
        // if (response.statusCode == 200) {
        //   // Success
        // } else {
        //   Scaffold.of(context)
        //       .showSnackBar(SnackBar(content: Text('Something went wrong.')));
        // }
      }
    }
  }

  void _goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildRaisedButton(BuildContext context, Map<String, dynamic> json) {
    return RaisedButton(
      onPressed: () {
        switch (json['role'] as String) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
      child: Text(json['text'] as String),
    );
  }

  Widget _buildTextButton(BuildContext context, Map<String, dynamic> json) {
    return FlatButton(
      onPressed: () {
        switch (json['role'] as String) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
      child: Text(json['text'] as String),
    );
  }

  Widget _buildOutlineButton(BuildContext context, Map<String, dynamic> json) {
    return OutlineButton(
      onPressed: () {
        switch (json['role'] as String) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
      child: Text(json['text'] as String),
    );
  }
}
