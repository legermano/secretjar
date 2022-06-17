import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class SecretsList extends StatefulWidget {
  const SecretsList({Key? key}) : super(key: key);

  @override
  State<SecretsList> createState() => _SecretsListState();
}

class _SecretsListState extends State<SecretsList> {
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
          if(snapshot.data == null) {
            return noSecrets();
          }

          return secretsList(context, snapshot);
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

  Widget secretsList(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        Map data = box.getAt(index);
        return Card(
          margin: const EdgeInsets.all(12),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  label: 'Excluir',
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (context) {},
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              tileColor: const Color(0xff1c1c1c),
              leading: const Icon(
                Icons.lock,
                size: 32,
              ),
              title: Text(
                "${data['nick']}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text(
                "Clique para copiar seu segredo!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 36,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future fetch() async {
    if(box.values.isEmpty) {
      return Future.value(null);
    }

    return Future.value(box.toMap());
  }
}
