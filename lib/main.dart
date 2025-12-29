import 'package:flutter/material.dart';

void main() {
  runApp(AICalculatorApp());
}

class AICalculatorApp extends StatefulWidget {
  @override
  _AICalculatorAppState createState() => _AICalculatorAppState();
}

class _AICalculatorAppState extends State<AICalculatorApp> {
  bool _isDark = false;
  bool _authenticated = false;
  List<String> _history = [];

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  Future<void> _authenticate() async {
    // Placeholder for biometric authentication
    // Always succeed for scaffold
    setState(() {
      _authenticated = true;
    });
  }

  void _addToHistory(String entry) {
    setState(() {
      _history.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Calculator',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: _authenticated
          ? CalculatorScreen(
              onToggleTheme: _toggleTheme,
              history: _history,
              onAddHistory: _addToHistory,
            )
          : LoginScreen(onAuthenticate: _authenticate),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onAuthenticate;

  const LoginScreen({required this.onAuthenticate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: onAuthenticate,
          child: Text('Login with Biometrics'),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final List<String> history;
  final Function(String) onAddHistory;

  const CalculatorScreen(
      {required this.onToggleTheme,
      required this.history,
      required this.onAddHistory});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == '=') {
        // AI integration hook (stub)
        // Here you could send _display to an AI model to compute the result.
        // For now we just echo the expression.
        _result = _display;
        widget.onAddHistory(_display);
        _display = '';
      } else if (value == 'C') {
        _display = '';
        _result = '';
      } else {
        _display += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('History')),
            ...widget.history.map((entry) => ListTile(
                  title: Text(entry),
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _display,
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['0', '.', '=', '+']),
          _buildButtonRow(['C']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: values
            .map(
              (v) => Expanded(
                child: ElevatedButton(
                  onPressed: () => _onPressed(v),
                  child: Text(
                    v,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
