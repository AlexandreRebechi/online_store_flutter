import 'dart:convert';
import 'dart:math';

class Correios {
  String? cep;
  String? logradouro;
  String? complemento;
  String? unidade;
  String? bairro;
  String? localidade;
  String? uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;

  double altura = 5.0;
  double largura = 20.0;
  double comprimento = 20.0;
  double pesoReal = 10.0;

  Correios({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.unidade,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

 factory Correios.fromJson(String str) => Correios.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());


factory Correios.fromMap(Map<String, dynamic> json) =>
      Correios(
          cep: json["cep"],
          logradouro: json["logradouro"],
          complemento: json["complemento"],
          unidade: json["unidade"],
          bairro: json["bairro"],
          localidade: json["localidade"],
          uf: json["uf"],
          ibge: json["ibge"],
          gia: json["gia"],
          ddd: json["ddd"],
          siafi: json["siafi"]
      );

  calcFrete() {
    double pesoCubado = (comprimento * largura * altura) / 6000;
    double pesoTaxavel = max(pesoReal, pesoCubado);
    double frete;

    frete = 20 + (pesoTaxavel * 2);

    return frete;
  }

  Map<String, dynamic> toMap() => {
      'Cep': cep,
      'Logradouro': logradouro,
      'Complemento': complemento,
      'Unidade': unidade,
      'Bairro': bairro,
      'Localidade': localidade,
      'UF': uf,
      'IBGE': ibge,
      'GIA': gia,
      'DDD': ddd,
      'Siafi': siafi,

  };
}
