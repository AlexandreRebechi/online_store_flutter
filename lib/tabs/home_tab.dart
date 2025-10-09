import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    //degradê
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
    //stack para deixar o conteudo acima do fundo
    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              floating: true,
              //snap: quando puxar a tela pra baixo a barra vai sumir,
              //quando puxar um pouco para cima ela vai reaparecer
              snap: true,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Novidades", style: TextStyle(color: Colors.white)),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("home_online_store")
                  .orderBy("pos")
                  .get(),
              //o builder é a função que vai criar o que vai ter na tela dependendo do
              //que o futuro vai trazer
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    //GridView controla o tamanho e a posição
                    child: GridView.custom(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        //transforma cada um dos documentos em uma QuiltedGridTiles e converte todas em uma lista
                        pattern: snapshot.data!.docs.map((data) {
                          return QuiltedGridTile(data['y'], data['x']);
                        }).toList(),
                      ),
                      //delegate fornece os itens da lista conforme aparecem
                      //SliverChildBuilderDelegate cria a lista lentamente
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit
                              .cover, //para cobrir todo o espaço possível na tile
                        ),
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
