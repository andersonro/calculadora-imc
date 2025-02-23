import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_imc/app/controller/imc_controller.dart';
import 'package:calculadora_imc/app/controller/usuario_controller.dart';
import 'package:calculadora_imc/app/model/usuario_model.dart';
import 'package:calculadora_imc/app/widget/card_calculo_imc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final UsuarioModel usuarioModel;
  const HomePage({super.key, required this.usuarioModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _peso = TextEditingController();

  late final UsuarioController usuarioController = UsuarioController();
  late final imcController = ImcController(usuarioModel: widget.usuarioModel);

  calculateIMC() async {
    double peso = double.parse((_peso.text).replaceAll(',', '.'));
    await imcController.calculateIMC(peso);
  }

  salvarCalculo() async {
    double peso = double.parse((_peso.text).replaceAll(',', '.'));
    await imcController.saveCalculos(peso);
    limparCampos();
  }

  limparCampos() {
    _peso.text = '';
    imcController.setState(ImcState.start);
  }

  loadList() async {
    await imcController.load();
  }

  @override
  void initState() {
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("Calculadora IMC", style: TextStyle(fontSize: 20)),
              Text(
                '${widget.usuarioModel.nome!} (${widget.usuarioModel.altura!.obterRealSemSimbolo()}) ',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          Widget widget;

          switch (imcController.getStateList.value) {
            case ImcStateList.success:
              if (imcController.listaCalculosImc.isNotEmpty) {
                widget = ListView.builder(
                  itemCount: imcController.listaCalculosImc.length,
                  itemBuilder: (_, int index) {
                    return CardCalculoImc(
                      imcModel: imcController.listaCalculosImc[index],
                    );
                  },
                );
              } else {
                widget = Center(
                  child: Text(
                    'Nenhum calculo realizado!',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              break;
            case ImcStateList.loading:
              widget = const Center(child: CircularProgressIndicator());
              break;
            default:
              widget = SizedBox(child: Text(imcController.getMsgError.value));
          }

          return widget;
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Calculo IMC",
                    style: TextStyle(color: Colors.indigo),
                  ),
                  elevation: 16,
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(4),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _peso,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Peso",
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PesoInputFormatter(),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "O campo peso não pode ser vázio!!";
                              } else {
                                String str = value.replaceAll(',', '.');
                                double v = double.parse(str);
                                if (v < 1) {
                                  return "O campo peso deve ser maior que 0!!!";
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          Obx(() {
                            late Widget widget;
                            switch (imcController.getState.value) {
                              case ImcState.loading:
                                widget = const LinearProgressIndicator();
                                break;
                              case ImcState.success:
                                widget = Text(
                                  "IMC: ${imcController.getImc}",
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              default:
                                widget = const SizedBox();
                            }

                            return widget;
                          }),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  calculateIMC();
                                }
                              },
                              icon: const Icon(
                                Icons.calculate_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Calcular",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.indigo,
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(this.context);
                            limparCampos();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.close),
                              SizedBox(width: 2),
                              Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.indigo),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              salvarCalculo();
                              Navigator.pop(this.context);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.save),
                              SizedBox(width: 2),
                              Text(
                                "Salvar",
                                style: TextStyle(color: Colors.indigo),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
