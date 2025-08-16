import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 211, 118, 130),
              Color.fromARGB(255, 253, 181, 168)
            ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades" ,style: TextStyle(color: Colors.white),),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("home").orderBy("pos").get(),
                builder: (context, snapshot){
                  if(!snapshot.hasData)
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  else {
                    print(snapshot.data?.docs.length);
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: Container()
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
