import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Secrets extends StatefulWidget {
  const Secrets({Key? key}) : super(key: key);

  @override
  State<Secrets> createState() => _SecretsState();
}

class _SecretsState extends State<Secrets> {
  Box box = Hive.box('secrets');
  bool longPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Seus segredos",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          return noSecrets();
        },
      ),
    );
  }

  Widget noSecrets() {
    return const Center(
      child: Text(
        "Você não tem nenhum segredo guardado 😓.\nGuarde alguns...\nÉ seguro 🔐.\nTudo está no seu celular...",
        style: TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future fetch() async {
    return Future.value(null);
  }
}
