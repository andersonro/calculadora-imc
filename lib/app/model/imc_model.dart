class ImcModel {
  int? id;
  double? peso;
  String? imc;
  DateTime? data = DateTime.now();
  int? idUsuario;

  ImcModel({this.peso, this.imc, this.idUsuario, this.id});

  ImcModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    peso = json['peso'];
    idUsuario = json['id_usuario'];
    imc = json['imc'];
    data = DateTime.parse(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['peso'] = peso;
    data['id_usuario'] = idUsuario;
    data['imc'] = imc;
    data['data'] = data;
    return data;
  }
}
