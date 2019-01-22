import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CocoonForm extends StatefulWidget {
  final Map<String, dynamic> _json;

  CocoonForm(this._json, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CocoonFormState(_json);
  }
}

class _CocoonFormState extends State<CocoonForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _json;
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _textControllers = {};

  _CocoonFormState(this._json) {
    final fields = _json['fields'];
    fields.forEach((field) {
      final String name = field['name'];
      _values[name] = field['initial_value'];
    });

    print(_values);
  }

  void _setValue(String name, dynamic value) {
    setState(() {
      _values[name] = value;
      print('$name: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = _json['fields'];
    final List<Widget> children = [];
    fields.forEach((field) {
      children.add(_buildField(context, field));
    });

    final buttons = _json['buttons'];
    children.add(_buildButtons(context, buttons));

    return Form(
      key: _formKey,
      child: ListView(
        children: children,
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Widget _buildField(BuildContext context, Map<String, dynamic> json) {
    switch (json['type']) {
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
        return ListTile();
    }
  }

  Widget _buildTextField(BuildContext context, Map<String, dynamic> json) {
    _textControllers[json['name']] =
        TextEditingController(text: json['initial_value']);

    TextInputType keyboardType;
    TextCapitalization capitalization;

    switch (json['keyboard_type']) {
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

    switch (json['capitalization']) {
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
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        controller: _textControllers[json['name']],
        decoration: InputDecoration(
          labelText: json['label'],
          helperText: json['help'],
          hintText: json['hint'],
        ),
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        obscureText: json['obscure_text'] == true,
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, Map<String, dynamic> json) {
    return CheckboxListTile(
      value: _values[json['name']],
      onChanged: (value) {
        _setValue(json['name'], value);
      },
      title: json['title'] != null ? Text(json['title']) : null,
      subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
      secondary: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon']))
          : null,
    );
  }

  Widget _buildSwitch(BuildContext context, Map<String, dynamic> json) {
    return SwitchListTile(
      value: _values[json['name']],
      onChanged: (value) {
        _setValue(json['name'], value);
      },
      title: json['title'] != null ? Text(json['title']) : null,
      subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
      secondary: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon']))
          : null,
    );
  }

  Widget _buildDropdownButton(BuildContext context, Map<String, dynamic> json) {
    final List<Map<String, dynamic>> options = [];
    json['options'].forEach((option) {
      options.add(option);
    });

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownButtonFormField(
        value: _values[json['name']],
        onChanged: (value) {
          _setValue(json['name'], value);
        },
        items: options.map((option) {
          return DropdownMenuItem(
            value: option['value'],
            child: Text(option['text']),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: json['label'],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(BuildContext context, Map<String, dynamic> json) {
    final List<Map<String, dynamic>> options = [];
    json['options'].forEach((option) {
      options.add(option);
    });

    final List<Widget> children = [
      Divider(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          json['label'],
          style: Theme.of(context).textTheme.subtitle,
        ),
      )
    ];

    children.addAll(options.map((option) {
      return RadioListTile(
        value: option['value'],
        groupValue: _values[json['name']],
        onChanged: (value) {
          _setValue(json['name'], value);
        },
        title: option['title'] != null ? Text(option['title']) : null,
        subtitle: option['subtitle'] != null ? Text(option['subtitle']) : null,
        secondary: option['icon'] != null
            ? Icon(getIconGuessFavorMaterial(name: option['icon']))
            : null,
      );
    }).toList());

    children.add(Divider());

    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildDatePicker(BuildContext context, Map<String, dynamic> json) {
    final jsonFormat = DateFormat("yyyy/MM/dd");
    final displayFormat = DateFormat(json['format'] ?? "dd/MM/yyyy");
    return ListTile(
      title:
          Text(displayFormat.format(jsonFormat.parse(_values[json['name']]))),
      subtitle: json['label'] != null ? Text(json['label']) : null,
      leading: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon']))
          : null,
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: jsonFormat.parse(_values[json['name']]),
          firstDate: json['min'] != null
              ? jsonFormat.parse(json['min'])
              : DateTime.now().add(Duration(days: -365 * 100)),
          lastDate: json['max'] != null
              ? jsonFormat.parse(json['max'])
              : DateTime.now().add(Duration(days: 365 * 100)),
        );
        if (newDate != null) {
          _setValue(json['name'], jsonFormat.format(newDate));
        }
      },
    );
  }

  Widget _buildTimePicker(BuildContext context, Map<String, dynamic> json) {
    final format = DateFormat("H:mm");
    return ListTile(
      title: Text(_values[json['name']]),
      subtitle: json['label'] != null ? Text(json['label']) : null,
      leading: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon']))
          : null,
      onTap: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(format.parse(_values[json['name']])),
        );
        if (newTime != null) {
          _setValue(json['name'], newTime.format(context));
        }
      },
    );
  }

  Widget _buildButtons(BuildContext context, List json) {
    final List<Widget> children = [];
    json.forEach((button) {
      children.add(_buildButton(context, button));
    });
    return ButtonBar(children: children);
  }

  Widget _buildButton(BuildContext context, Map<String, dynamic> json) {
    switch (json['type']) {
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

  void _submit(BuildContext context) async {
    // TODO
    // final String submitTo = _json['submit_to'];
    // if (submitTo != null) {
    //   final response = await post(submitTo, body: jsonEncode(_values));
    //   if (response.statusCode == 200) {
    //     // Success
    //   } else {
    //     Scaffold.of(context)
    //         .showSnackBar(SnackBar(content: Text('Something went wrong.')));
    //   }
    // }
  }

  void _goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildRaisedButton(BuildContext context, Map<String, dynamic> json) {
    return RaisedButton(
      child: Text(json['text']),
      onPressed: () {
        switch (json['role']) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
    );
  }

  Widget _buildTextButton(BuildContext context, Map<String, dynamic> json) {
    return FlatButton(
      child: Text(json['text']),
      onPressed: () {
        switch (json['role']) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
    );
  }

  Widget _buildOutlineButton(BuildContext context, Map<String, dynamic> json) {
    return OutlineButton(
      child: Text(json['text']),
      onPressed: () {
        switch (json['role']) {
          case 'submit':
            _submit(context);
            break;
          case 'back':
            _goBack(context);
            break;
        }
      },
    );
  }
}
