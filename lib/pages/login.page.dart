import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isRememberMe = false;
  bool _isPasswordVisible = false;

  String _currentTime = '';
  Timer? _timer;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Função para salvar os dados do usuário no cache
  Future<void> saveUserData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void login() async {
    const String apiUrl = 'http://18.231.156.186:3333/signin';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await saveUserData(token);
      _showSucessfulDialog("Seja bem-vindo!", token);
    } else if (response.statusCode == 401) {
      _showErrorDialog('Email ou senha inválidos');
    } else {
      _showErrorDialog('Ocorreu um erro!');
    }
  }

  void _showSucessfulDialog(String message, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navegar para a página "HomePage" e passar o token
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(token: token),
                  ),
                );
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _getCurrentTime();
    });
  }

  void _getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now);
    if (mounted) {
      setState(() {
        _currentTime = formattedTime;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: ClipPath(
          clipper: MyCustomClipper(),
          child: AppBar(
            flexibleSpace: Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/imageBar.png',
                    width: MediaQuery.of(context).size.width,
                    height: 175,
                    scale: 1.5,
                  ),
                ),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 33, 34, 39),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Digite o seu usuário',
                prefixIcon: Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Digite a sua senha',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                labelStyle: const TextStyle(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const SizedBox(height: 0),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.grey,
                  value: _isRememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _isRememberMe = value!;
                    });
                  },
                ),
                const Text('Lembrar autenticação'),
              ],
            ),
            const SizedBox(height: 0),
            ElevatedButton(
              onPressed: () => login(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(224, 33, 34, 39)),
              ),
              child: const Text('LOGIN'),
            ),
            const SizedBox(height: 0),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text(
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                '$_currentTime - REGISTRAR PONTO',
              ),
            ),
            const SizedBox(height: 0),
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.vpn_key,
                    size: 15,
                  ),
                  Text(
                    'MobiToken',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height + 2, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}
