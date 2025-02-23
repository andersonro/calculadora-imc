import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_imc/app/model/imc_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardCalculoImc extends StatelessWidget {
  const CardCalculoImc({super.key, required this.imcModel});
  final ImcModel imcModel;

  @override
  Widget build(BuildContext context) {
    var dataFormatada = DateFormat(
      'dd/MM/yyyy hh:mm:ss',
    ).format(imcModel.data!);

    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Data do calculo: $dataFormatada",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Peso: ${imcModel.peso!.obterRealSemSimbolo()}"),
            Text("IMC: ${imcModel.imc}"),
          ],
        ),
      ),
    );
  }
}
