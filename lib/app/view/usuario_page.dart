import 'package:calculadora_imc/app/controller/usuario_controller.dart';
import 'package:calculadora_imc/app/model/usuario_model.dart';
import 'package:calculadora_imc/app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  late UsuarioController usuarioController = UsuarioController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    onSave() async {
      if (_formKey.currentState!.validate()) {
        try {
          await usuarioController.saveUsuario(
            nome: nomeController.text,
            altura: double.parse(alturaController.text.replaceAll(',', '.')),
          );

          UsuarioModel usuarioModel = await usuarioController.getUsuario();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bem vindo ${nomeController.text}'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (buildContext) => HomePage(usuarioModel: usuarioModel),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Cadastro de Usuário"), centerTitle: true),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () =>
                          usuarioController.getState.value ==
                                  UsuarioState.loading
                              ? CircularProgressIndicator()
                              : Card(
                                elevation: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nomeController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            labelText: 'Nome',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, insira seu nome';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: alturaController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Altura',
                                            border: const OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, insira sua altura';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            AlturaInputFormatter(),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              onSave();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.indigo,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Salvar"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
