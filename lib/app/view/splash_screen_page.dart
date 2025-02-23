import 'package:calculadora_imc/app/controller/usuario_controller.dart';
import 'package:calculadora_imc/app/model/usuario_model.dart';
import 'package:calculadora_imc/app/view/home_page.dart';
import 'package:calculadora_imc/app/view/usuario_page.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  UsuarioController usuarioController = UsuarioController();

  onLoad() async {
    Widget page;
    UsuarioModel usuarioModel = await usuarioController.getUsuario();
    // Verifica se o usuário já existe no banco de dados
    if (usuarioModel.id != null) {
      page = HomePage(usuarioModel: usuarioModel);
    } else {
      page = UsuarioPage();
    }

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (buildContext) => page),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Center(child: Image.asset("assets/calculadora_imc.png")),
    );
  }
}
