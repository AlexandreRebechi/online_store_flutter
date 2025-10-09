import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(snapshot.get("image"), fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.get("title"),
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(snapshot.get("address"), textAlign: TextAlign.start),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  //abrindo google maps, pedindo para procurar a latitude e longitude da loja
                  launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${snapshot.get('lat')},${snapshot.get('long')}',
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: Text("Ver no Mapa"),
              ),
              TextButton(
                onPressed: () {
                  //Fazer ligação usando o aplicativo de telefone padrão
                  launchUrlString(snapshot.get("phone"));
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: Text("Ligar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
