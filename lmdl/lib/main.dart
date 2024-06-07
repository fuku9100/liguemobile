import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Login',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          _buildPasswordField(),
          const SizedBox(height: 20.0),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre adresse e-mail';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Mot de passe'),
      obscureText: true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () async {
        if (_formKey.currentState!.validate()) {
          String email = _emailController.text;
          String password = _passwordController.text;
          setState(() {
            _isLoading = true;
          });
          await _login(email, password);
        }
      },
      child: _isLoading ? const CircularProgressIndicator() : const Text('Se connecter'),
    );
  }

  Future<String?> _login(String email, String password) async {
  String apiUrl = 'http://localhost:3000/api/usersroute/connexion';
  Map<String, String> data = {
    'email': email,
    'password': password,
  };
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.body.isEmpty) {
      _showErrorSnackBar('Le corps de la réponse est nul ou vide. Veuillez vérifier votre serveur.');
      return null;
    }
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String? token = responseBody['token'];
      if (token == null || token.isEmpty) {
        _showErrorSnackBar('Le token est nul ou vide. Veuillez vérifier votre serveur.');
        return null;
      }
      Provider.of<AuthProvider>(context, listen: false).login(token);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
      return token;
    } else {
      _showErrorSnackBar('Identifiants incorrects. Veuillez réessayer.');
    }
  } catch (e) {
    _showErrorSnackBar('Une erreur s\'est produite lors de la connexion. Veuillez réessayer.');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
  return null;
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  void login(String token) {
    _token = token;
    storage.write(key: 'auth_token', value: token);
    notifyListeners();
  }

  void logout() {
    _token = null;
    storage.delete(key: 'auth_token');
    notifyListeners();
  }
}