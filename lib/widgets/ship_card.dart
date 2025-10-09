import 'package:flutter/material.dart';
import 'package:online_store/datas/correios_frete.dart';
import 'package:http/http.dart' as http;

class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //tile que pode clicar e ela irá expandir
      child: ExpansionTile(
        title: Text(
          "Cálcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu CEP",
              ),
              //inicia com um cupom já colocado, senão coloca vazio
              initialValue: "",
              //ao submeter o cupom, busca no firestore o doc correspondente
              onFieldSubmitted: (String cepDigitado) async {
                try {
                  http.Response response = await http.get(
                    // consumindo api viacep
                    Uri.parse("https://viacep.com.br/ws/$cepDigitado/json/"),
                  );
                  print(response.body);

                  if (response.statusCode == 200) {
                    Correios correios = Correios.fromJson(response.body);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Cep: ${correios.cep} \nBairro: ${correios.bairro} \nLocaliadade: ${correios.localidade} \nUF: ${correios.uf}",
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Erro de conexão: ${response.statusCode}",
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } catch (e) {
                  print("Erro na requisição: $e");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
