import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green,
          secondary: Colors.greenAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // primary: Colors.green,
            // onPrimary: Colors.white,
            textStyle: TextStyle(fontSize: 18),
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
        ),
      ),
      home: TemperatureConverterHomePage(),
    );
  }
}

class TemperatureConverterHomePage extends StatefulWidget {
  @override
  _TemperatureConverterHomePageState createState() => _TemperatureConverterHomePageState();
}

class _TemperatureConverterHomePageState extends State<TemperatureConverterHomePage> {
  String _selectedConversion = 'F to C';
  TextEditingController _controller = TextEditingController();
  String _result = '';
  List<String> _history = [];

  void _convertTemperature() {
    double input;
    try {
      input = double.parse(_controller.text);
    } catch (e) {
      _showErrorDialog('Please enter a valid number.');
      return;
    }
    double output;

    if (_selectedConversion == 'F to C') {
      output = (input - 32) * 5 / 9;
    } else {
      output = input * 9 / 5 + 32;
    }

    setState(() {
      _result = output.toStringAsFixed(2);
      _history.insert(0, '$_selectedConversion: $input => $_result');
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPortrait = constraints.maxWidth < constraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Fahrenheit to Celsius'),
                        leading: Radio<String>(
                          value: 'F to C',
                          groupValue: _selectedConversion,
                          onChanged: (value) {
                            setState(() {
                              _selectedConversion = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Celsius to Fahrenheit'),
                        leading: Radio<String>(
                          value: 'C to F',
                          groupValue: _selectedConversion,
                          onChanged: (value) {
                            setState(() {
                              _selectedConversion = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter temperature',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '=',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '$_result',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _convertTemperature,
                      child: Text('Convert'),
                    ),
                  ),
                ),
                Divider(height: 20, thickness: 2),
                Text(
                  'History of conversions:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index], style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
