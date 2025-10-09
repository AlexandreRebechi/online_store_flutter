import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.pageController,
    required this.page,
  });

  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  @override
  Widget build(BuildContext context) {
    //material - para dar um efeito visual ao clicar nos botões
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //para fechar o drawer
          Navigator.of(context).pop();
          //indo para a página que especificamos no tile
          pageController.jumpToPage(page);
        },
        //container para expecificar a altura dos itens
        child: SizedBox(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                //.round() para arredondar o valor que vem do controller.page, pois é um double e o page é um int
                //se o page controller estiver na página especificada no tile
                color: pageController.page?.round() == page
                    ?
                      //pinta da cor do tema padrão
                      Theme.of(context).primaryColor
                    //se não estiver na página
                    : Colors.grey[700],
              ),
              SizedBox(width: 32.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page?.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
