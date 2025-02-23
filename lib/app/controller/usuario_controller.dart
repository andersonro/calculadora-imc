import 'package:calculadora_imc/app/data/db.dart';
import 'package:calculadora_imc/app/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioController extends GetxController {
  late UsuarioModel? usuarioModel = UsuarioModel();
  late Database db;

  final _msgError = "".obs;
  Rx<String> getMsgError() => _msgError;

  final _state = UsuarioState.start.obs;
  Rx<UsuarioState> get getState => _state.value.obs;

  UsuarioController();

  Future getUsuario() async {
    db = await DB.instance.database;

    usuarioModel = await db
        .query('usuario', limit: 1)
        .then((value) => UsuarioModel.fromJson(value.first))
        .catchError((e) => UsuarioModel());
    _state.value = UsuarioState.success;
    return usuarioModel;
  }

  Future getIdUsuario(int id) async {
    db = await DB.instance.database;

    usuarioModel = await db
        .query('usuario', limit: 1, where: 'id = ?', whereArgs: [id])
        .then((value) => UsuarioModel.fromJson(value.first));
    _state.value = UsuarioState.success;
    return usuarioModel;
  }

  Future<bool> saveUsuario({
    required String nome,
    required double altura,
  }) async {
    _state.value = UsuarioState.loading;

    try {
      usuarioModel = UsuarioModel(nome: nome, altura: altura);
      debugPrint('Usuário: ${usuarioModel.toString()}');
      db = await DB.instance.database;
      var save = await db.insert('usuario', usuarioModel!.toJson());
      debugPrint('Salvo: $save');
      _state.value = UsuarioState.success;
      return true;
    } catch (e) {
      _state.value = UsuarioState.error;
      _msgError.value = e.toString();
      throw e.toString();
    }
  }
}

enum UsuarioState { start, loading, success, error }
