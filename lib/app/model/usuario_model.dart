class UsuarioModel {
  int? id;
  String? nome;
  double? altura;

  UsuarioModel({this.id, this.nome, this.altura});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    altura = json['altura'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['altura'] = altura;
    return data;
  }
}
