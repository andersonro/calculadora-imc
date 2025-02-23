import 'package:calculadora_imc/app/data/db.dart';
import 'package:calculadora_imc/app/model/imc_model.dart';
import 'package:calculadora_imc/app/model/usuario_model.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ImcController extends GetxController {
  late ImcModel imcModel = ImcModel();
  late Database db;
  UsuarioModel usuarioModel = UsuarioModel();

  ImcController({required this.usuarioModel});

  final _listaCalculosImc = [].obs;
  RxList get listaCalculosImc => _listaCalculosImc;

  final _imc = "".obs;
  Rx<String> get getImc => _imc;

  final _state = ImcState.start.obs;
  Rx<ImcState> get getState => _state.value.obs;
  ImcState setState(value) => _state.value = value;

  final _stateList = ImcStateList.success.obs;
  Rx<ImcStateList> get getStateList => _stateList.value.obs;

  final _errorMsg = ''.obs;
  Rx<String> get getMsgError => _errorMsg.value.obs;

  Future calculateIMC(double peso) async {
    _state.value = ImcState.loading;
    Future.delayed(const Duration(seconds: 3), () {
      imcModel.peso = peso;
      imcModel.idUsuario = usuarioModel.id;
      imcModel.imc = _retornaIMC();

      _state.value = ImcState.success;
      _imc.value = imcModel.imc!;
    });
  }

  Future saveCalculos(double peso) async {
    try {
      _state.value = ImcState.loading;
      ImcModel imcModel = ImcModel();
      imcModel.peso = peso;
      imcModel.idUsuario = usuarioModel.id;

      imcModel.imc = _retornaIMC();

      db = await DB.instance.database;

      var j = {
        'peso': imcModel.peso,
        'imc': imcModel.imc,
        'id_usuario': usuarioModel.id,
        'data': imcModel.data!.toString(),
      };

      db.insert('imc', j);

      _state.value = ImcState.success;
      load();
    } catch (e) {
      throw Exception("Erro ao salvar o cálculo do IMC (${e.toString()})");
    }
  }

  Future load() async {
    _stateList.value = ImcStateList.loading;
    try {
      db = await DB.instance.database;

      var lista = await db.query('imc');
      listaCalculosImc.value =
          lista.map((e) => ImcModel.fromJson(e)).toList().reversed.toList();
      _stateList.value = ImcStateList.success;
    } catch (e) {
      _stateList.value = ImcStateList.error;
      _errorMsg.value = e.toString();
    }
  }

  double _calculaIMC() {
    if (imcModel.peso! < 1) {
      throw ArgumentError("O peso não pode ser zero!");
    }
    if (usuarioModel.altura == 0) {
      throw ArgumentError("A altura não pode ser zero!");
    }
    return imcModel.peso! / (usuarioModel.altura! * usuarioModel.altura!);
  }

  String _retornaIMC() {
    var t = "";
    var imc = _calculaIMC();
    var strImc = imc.toStringAsFixed(2);
    if (imc < 16) {
      t = "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      t = "Magreza moderada";
    } else if (imc >= 17 && imc < 18.5) {
      t = "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      t = "Saudável";
    } else if (imc >= 25 && imc < 30) {
      t = "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      t = "Obesidade Grau I";
    } else if (imc >= 35 && imc < 40) {
      t = "Obesidade Grau II";
    } else {
      t = "Obesidade Grau III";
    }
    return "$strImc $t";
  }
}

enum ImcState { start, loading, success, error }

enum ImcStateList { loading, success, error }
