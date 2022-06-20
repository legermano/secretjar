import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:secrectjar/model/secret_model.dart';
import 'package:secrectjar/utils/encrypt_service.dart';
import 'package:secrectjar/widgets/secret.dart';

class SecretsList extends StatefulWidget {
  const SecretsList({Key? key}) : super(key: key);

  @override
  State<SecretsList> createState() => _SecretsListState();
}

class _SecretsListState extends State<SecretsList> {
  SecretModel secretModel = SecretModel();
  EncryptService encryptService = EncryptService();
  int secretsCount = 0;
  var secretsMax = "∞";

  @override
  void initState() {
    updateCounter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            const Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                "Seus segredos",
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Text(
                "$secretsCount/$secretsMax",
              ),
            )
          ],
        ),
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _secretForm(context),
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
      body: FutureBuilder<List?>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return noSecrets();
            }

            return secretsList(context, snapshot);
          }
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
        Map data = secretModel.get(index);
        return Card(
          margin: const EdgeInsets.all(12),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  label: 'Editar',
                  backgroundColor: Colors.black45,
                  icon: Icons.edit,
                  onPressed: (context) {
                    _secretForm(
                      context,
                      index: index,
                      type: "${data['type']}",
                      name: "${data['name']}",
                      login: "${data['login']}",
                      password: "${data['password']}",
                    );
                    setState(() {});
                  },
                ),
                SlidableAction(
                  label: 'Excluir',
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (context) => _delete(index),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              tileColor: Colors.grey[850],
              leading: const Icon(
                Icons.lock,
                size: 32,
              ),
              title: Text(
                "${data['name']}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text(
                "Clique no ícone para copiar a senha do seu segredo!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              trailing: IconButton(
                onPressed: () => encryptService.copyToClipboard(
                  data['password'],
                  context,
                ),
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

  Future<List?> fetch() async {
    Iterable<dynamic> secrets = secretModel.getAll();

    if (secrets.isEmpty) {
      return Future.value(null);
    }

    return Future.value(secrets.toList());
  }

  void _delete(int index) async {
    await secretModel.delete(index);
    updateCounter();
  }

  Future<void> _secretForm(
    BuildContext context, {
    int? index,
    String type = "",
    String name = "",
    String login = "",
    String password = "",
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Secrect(
          index: index,
          type: type,
          name: name,
          login: login,
          password: password,
        );
      },
    );

    updateCounter();
  }

  void updateCounter() {    
    setState(() {
      secretsCount = secretModel.getAll().length;
    });
  }
}
