import 'dart:io';

import 'package:cadastro/ManterRevista.dart';
import 'package:cadastro/revista.dart';
import 'package:flutter/material.dart';
import 'package:cadastro/livro.dart';
import 'package:cadastro/ManterLivros.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // This widget is the root of your application.
  LivroHelper Crud = LivroHelper();
  List<Livros> listaLivros = List();

  RevistaHelper Crud2 = RevistaHelper();
  List<Revistas> listaRevistas = List();

  Function Atualiza() {
    Crud.getTodosLivro().then((list) {
      setState(() {
        listaLivros = list;
        print(listaLivros.toString());
      });
    });
  }

  Function Atualiza2() {
    Crud2.getTodosRevista().then((list) {
      setState(() {
        listaRevistas = list;
        print(listaRevistas.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Crud.getTodosLivro().then((list) {
      setState(() {
        listaLivros = list;
        print(listaLivros.toString());
      });
    });
    Crud2.getTodosRevista().then((list) {
      setState(() {
        listaRevistas = list;
        print(listaRevistas.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int _counter = 0;
    final Color colorAtivo = Colors.cyan;
    final Color colorInativo = Colors.grey;

    String _quebrarLinha(String texto) {
      String resultado = "";
      int i, cont = 0;
      for (i = 0; i < texto.length; i++) {
        cont++;
        if (cont < 36) {
          if (cont == 35 && cont < texto.length) {
            if (texto[i + 1] == " ") {
              resultado = resultado + texto[i];
            } else
              resultado = resultado + texto[i] + "-";
          } else {
            resultado = resultado + texto[i];
          }
        } else {
          resultado = resultado + "\n" + texto[i].trim();
          cont = 0;
        }
      }
      return resultado;
    }

    Color _validarAtivo(int ativos, atual) {
      if (atual <= ativos) {
        return colorAtivo;
      } else {
        return colorInativo;
      }
    }

    Widget _getFAB() {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: Color(0xFF801E48),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // FAB 1
          SpeedDialChild(
              child: Icon(Icons.assignment_turned_in),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                _TelaLivro();
                Atualiza();
              },
              label: 'Button 1',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),
          // FAB 2
          SpeedDialChild(
              child: Icon(Icons.assignment_turned_in),
              backgroundColor: Color(0xFF801E48),
              onTap: () {
                _TelaRevista();
                Atualiza2();
                setState(() {
                  _counter = 0;
                });
              },
              label: 'Button 2',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48))
        ],
      );
    }

    Widget _Star(int avalia) {
      return Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.star,
              color: _validarAtivo(avalia, 1),
            ),
            Icon(
              Icons.star,
              color: _validarAtivo(avalia, 2),
            ),
            Icon(
              Icons.star,
              color: _validarAtivo(avalia, 3),
            ),
            Icon(
              Icons.star,
              color: _validarAtivo(avalia, 4),
            ),
            Icon(
              Icons.star,
              color: _validarAtivo(avalia, 5),
            ),
          ],
        ),
      );
    }

    Widget _LivroCard(BuildContext context, int index) {
      return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 10.00),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: listaLivros[index].capa != null
                            ? FileImage(File(listaLivros[index].capa))
                            : AssetImage("Imagens/capa.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _quebrarLinha(
                                'Titulo: ' + listaLivros[index].titulo ?? ""),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            _quebrarLinha(
                                'Autor: ' + listaLivros[index].autor ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Assunto: ' + listaLivros[index].assunto ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Editora: ' + listaLivros[index].editora ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Ano: ' + listaLivros[index].ano.toString() ??
                                    ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Resenha: ' + listaLivros[index].resenha ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            'Status: ' + listaLivros[index].status ?? "",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          _Star(listaLivros[index].avaliacao),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _TelaLivro(livro: listaLivros[index]);
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Excluir Livro?"),
                  content: Text("O livro será excluido completamente!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Excluir"),
                      onPressed: () {
                        Crud.DeletarLivro(listaLivros[index].id);
                        Atualiza();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      );
    }

    Widget _RevistaCard(BuildContext context, int index) {
      return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 10.00),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: listaLivros[index].capa != null
                            ? FileImage(File(listaLivros[index].capa))
                            : AssetImage("Imagens/capa.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _quebrarLinha(
                                'Titulo: ' + listaRevistas[index].titulo ?? ""),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            _quebrarLinha(
                                'Autor: ' + listaRevistas[index].autor ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha('Categoria: ' +
                                    listaRevistas[index].categoria ??
                                ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Editora: ' + listaRevistas[index].editora ??
                                    ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha(
                                'Ano: ' + listaRevistas[index].ano.toString() ??
                                    ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _quebrarLinha('Portabilidade: ' +
                                    listaRevistas[index].portabilidade ??
                                ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            'Status: ' + listaRevistas[index].status ?? "",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                          _Star(listaRevistas[index].avaliacao),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _TelaRevista(revista: listaRevistas[index]);
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Excluir Revista?"),
                  content: Text("A revista será excluida completamente!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Excluir"),
                      onPressed: () {
                        Crud2.DeletarRevista(listaRevistas[index].id);
                        Atualiza2();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca pessoal',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Biblioteca pessoal"),
        ),
        // floatingActionButton: FloatingActionButton(
        //  onPressed: () {

        //  },
        //  child: Icon(Icons.add),
        //  backgroundColor: Colors.cyan,
        //),
        floatingActionButton: _getFAB(),
        //(
        //  onPressed: () => setState(() {
        //    _counter++;
        //  }),
        //  tooltip: 'Increment Counter',
        //  child: Icon(Icons.add),
        //),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Text(
                "\n"
                "INSTRUÇÕES: \n"
                "OPÇÃO 01: \n"
                "Editar Livro: clique uma vez no livro desejado \n"
                "OPÇÃO 02: \n"
                "Excluir Livro: pressione o livro desejado por 2s",
                style: TextStyle(color: colorInativo),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: listaLivros.length,
                itemBuilder: (context, index) {
                  return _LivroCard(context, index);
                },
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: listaRevistas.length,
                itemBuilder: (context, index) {
                  return _RevistaCard(context, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _TelaLivro({Livros livro}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManterLivros(
                  livros: livro,
                )));
    Atualiza();
  }

  void _TelaRevista({Revistas revista}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManterRevistas(
                  revistas: revista,
                )));
    Atualiza2();
  }
}
//É NOIZ
