import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Map<int, int> itemViews = {
    for (var i = 0; i < 7; i++) i: 0,
  };

  late String userEmail = 'Carregando...';
  // Variável para armazenar o email do usuário

  @override
  void initState() {
    super.initState();
    getUserData(); // Chama a função para obter os dados do usuário ao iniciar a tela
  }

  final List<IconData> icons = [
    Icons.check_circle,
    Icons.motorcycle,
    Icons.calendar_today,
    Icons.attach_money,
    Icons.lock,
    Icons.autorenew,
    Icons.person_add_alt_1_outlined,
  ];

  Future<void> getUserData() async {
    const apiUrl = 'http://18.231.156.186:3333/user';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          userEmail = userData['email'];
        });
      } else {
        setState(() {
          userEmail = 'Erro ao obter o email do usuário';
        });
      }
    } catch (e) {
      setState(() {
        userEmail = 'Erro ao obter o email do usuário';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MOBI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.message),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 33, 34, 39),
                    ),
                    accountName: const Text('Nome do Usuário'),
                    accountEmail: Text(userEmail),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(
                        'N',
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ...List.generate(
                    7,
                    (index) => ListTile(
                      leading: Icon(
                        icons[index],
                        color: const Color.fromARGB(198, 33, 34, 30),
                      ),
                      title: Text('Item Menu ${index + 1}'),
                      textColor: const Color.fromARGB(198, 33, 34, 30),
                      onTap: () {
                        setState(() {
                          int currentViews = itemViews[index]!;
                          itemViews[index] = currentViews + 1;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[100],
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.black),
                title:
                    const Text('Sair', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        itemCount: 7,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1.6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: const Color.fromARGB(255, 33, 34, 39),
            elevation: 5,
            child: InkWell(
              onTap: () {
                setState(() {
                  int currentViews = itemViews[index]!;
                  itemViews[index] = currentViews + 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icons[index],
                    color: Colors.yellow,
                    size: 30,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Views: ${itemViews[index]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Item Menu ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
