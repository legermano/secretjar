
import 'package:flutter/material.dart';

class Secrect extends StatefulWidget {
  const Secrect({Key? key}) : super(key: key);

  @override
  State<Secrect> createState() => _SecrectState();
}

class _SecrectState extends State<Secrect> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.black87),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Serviço",
                hintText: "Google",
              ),
              style: const TextStyle(fontSize: 18),
              controller: _typeController,
              validator: validateEmptyInput,
            ),
            separatorBox(),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nome",
                hintText: "Será exibido como título",
              ),
              style: const TextStyle(fontSize: 18),
              controller: _nameController,
              validator: validateEmptyInput,
            ),
            separatorBox(),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Login",
              ),
              style: TextStyle(fontSize: 18),
            )
          ],
        )
      ),
    );
  }

  Widget separatorBox() {
    return const SizedBox(height: 12,);
  }

  String? validateEmptyInput(String? value) {
    if(value == null || value.trim().isEmpty) {
      return "Enter a value";
    }

    return null;
  }
}