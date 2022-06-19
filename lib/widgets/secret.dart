import 'package:flutter/material.dart';
import 'package:secrectjar/model/secret_model.dart';
import 'package:secrectjar/utils/theme/encrypt_service.dart';

class Secrect extends StatefulWidget {
  final int? index;
  final String type;
  final String name;
  final String login;
  final String password;

  const Secrect({
    Key? key,
    this.index,
    this.type = "",
    this.name = "",
    this.login = "",
    this.password = "",
  }) : super(key: key);

  @override
  State<Secrect> createState() => _SecrectState();
}

final _formKey = GlobalKey<FormState>();
final _typeController = TextEditingController(text: null);
final _nameController = TextEditingController(text: null);
final _loginController = TextEditingController(text: null);
final _passwordController = TextEditingController(text: null);
final _encryptService = EncryptService();

class _SecrectState extends State<Secrect> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    _typeController.text = widget.type;
    _nameController.text = widget.name;
    _loginController.text = widget.login;
    
    if(widget.password.trim().isEmpty) {
      _passwordController.text = widget.password;
    } else {
      _passwordController.text = _encryptService.decrypt(widget.password);
    }

    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTextoFormField(
                  label: "Serviço",
                  hint: "Google",
                  controller: _typeController,
                  validator: validateEmptyInput,
                ),
                separatorBox(),
                customTextoFormField(
                  label: "Nome",
                  hint: "Nome do segredo",
                  controller: _nameController,
                  validator: validateEmptyInput,
                ),
                separatorBox(),
                customTextoFormField(
                  label: "Login",
                  hint: "Username/Email/Telefone",
                  controller: _loginController,
                  validator: validateEmptyInput,
                ),
                separatorBox(),
                customTextoFormField(
                  label: "Senha",
                  hint: "Senha de login",
                  controller: _passwordController,
                  validator: validateEmptyInput,
                  isPassword: true,
                ),
                separatorBox(),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextoFormField({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {    
    return TextFormField(      
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: isPassword
            ? IconButton(
              icon: Icon(
                passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => toogleShowPassword(),
            )
            : null,
        ),
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      keyboardType: TextInputType.text,
      obscureText: isPassword ? !passwordVisible : false,      
      controller: controller,
      validator: validator,
    );
  }

  Widget separatorBox() {
    return const SizedBox(
      height: 12,
    );
  }

  String? validateEmptyInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter a value";
    }

    return null;
  }

  void toogleShowPassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () => saveSecret(
        _typeController.text,
        _nameController.text,
        _loginController.text,
        _passwordController.text,
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor,
        ),
      ),
      child: const Text(
        "Salvar",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void saveSecret(String type, String name, String login, String password) {
    EncryptService encryptService = EncryptService();

    // Encrypt the password
    password = encryptService.encrypt(password);

    SecretModel secretModel = SecretModel();

    dynamic values = {
      'type': type.toLowerCase(),
      'name': name,
      'login': login,
      'password': password
    };

    secretModel.save(values, index: widget.index);

    Navigator.of(context).pop();
  }
}
