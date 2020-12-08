import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cadastro/livro.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ManterLivros extends StatefulWidget {
  final Livros livros;

  ManterLivros({this.livros});

  @override
  _ManterLivrosState createState() => _ManterLivrosState();
}

enum SingingCharacter { Lido, Lendo, Nao_Lido }

class _ManterLivrosState extends State<ManterLivros> {
  // This widget is the root of your application.

  TextEditingController _titulo = TextEditingController();
  TextEditingController _autor = TextEditingController();
  TextEditingController _assunto = TextEditingController();
  TextEditingController _editora = TextEditingController();
  TextEditingController _ano = TextEditingController();
  TextEditingController _resenha = TextEditingController();
  TextEditingController _status = TextEditingController();
  TextEditingController _avaliacao = TextEditingController();
  int valida;
  var _Status = ["Não lido", "Lendo", "Lido"];
  var _Av = ["0", "1", "2", "3", "4", "5"];
  final _tituloFocus = FocusNode();
  final _anoFocus = FocusNode();
  final _avalicaoFocus = FocusNode();

  LivroHelper Crud = LivroHelper();
  Livros _aux;

  @override
  void initState() {
    super.initState();
    if (widget.livros == null) {
      _aux = Livros();
      _status.text = _Status[0];
      _avaliacao.text = _Av[0];
      valida = 0;
    } else {
      _aux = Livros.fromMap(widget.livros.toMap());
      _titulo.text = _aux.titulo;
      _autor.text = _aux.autor;
      _assunto.text = _aux.assunto;
      _editora.text = _aux.editora;
      _ano.text = _aux.ano.toString();
      _resenha.text = _aux.resenha;
      _status.text = _aux.status;
      _avaliacao.text = _aux.avaliacao.toString();
      valida = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _SelecionaStatus() {
      return Container(
        child: TextField(
          controller: _status,
          decoration: InputDecoration(
            labelText: "Status",
            labelStyle: TextStyle(fontSize: 20),
            suffixIcon: PopupMenuButton<String>(
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 40,
              ),
              padding: EdgeInsets.only(right: 260),
              onSelected: (String value) {
                _status.text = value;
              },
              itemBuilder: (BuildContext context) {
                return _Status.map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: new Text(value), value: value);
                }).toList();
              },
            ),
          ),
          readOnly: true,
        ),
      );
    }

    Widget _SelectAvalia() {
      return Container(
        child: TextField(
          controller: _avaliacao,
          decoration: InputDecoration(
            labelText: "Avaliação",
            labelStyle: TextStyle(fontSize: 20),
            suffixIcon: PopupMenuButton<String>(
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 40,
              ),
              padding: EdgeInsets.only(right: 260),
              onSelected: (String value) {
                _avaliacao.text = value;
              },
              itemBuilder: (BuildContext context) {
                return _Av.map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: new Text(value), value: value);
                }).toList();
              },
            ),
          ),
          readOnly: true,
        ),
      );
    }

    Widget Tela() {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              "Para tirar foto clique na imagem",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),

            GestureDetector(
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _aux.capa != null
                          ? FileImage(File(_aux.capa))
                          : AssetImage("Imagens/capa.png"),
                      fit: BoxFit.cover),
                ),
              ),
              onTap: () {
                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                  if (file == null) return;
                  setState(() {
                    _aux.capa = file.path;
                  });
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Titulo",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              controller: _titulo,
              focusNode: _tituloFocus,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Autor",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              controller: _autor,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Assunto",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              controller: _assunto,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Editora",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              controller: _editora,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ano",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              focusNode: _anoFocus,
              controller: _ano,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Resenha",
                labelStyle: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              controller: _resenha,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            //_Radio(),
            _SelecionaStatus(),
            _SelectAvalia(),
            Padding(padding: EdgeInsets.only(top: 40.0)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(_aux.titulo ?? "Cadastro de Novo Livro"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titulo.text != null && _titulo.text.isNotEmpty) {
            if (_ano.text != null && _ano.text.isNotEmpty) {
              _aux.titulo = _titulo.text;
              _aux.autor = _autor.text;
              _aux.assunto = _assunto.text;
              _aux.editora = _editora.text;
              _aux.ano = int.parse(_ano.text);
              _aux.resenha = _resenha.text;
              _aux.status = _status.text;
              _aux.avaliacao = int.parse(_avaliacao.text);
              if (valida == 0) {
                Crud.InserirLivro(_aux);
              } else {
                Crud.EditarLivro(_aux);
              }
              Navigator.pop(
                context,
              );
            } else {
              FocusScope.of(context).requestFocus(_anoFocus);
            }
          } else {
            FocusScope.of(context).requestFocus(_tituloFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[Tela()],
        ),
      ),
    );
  }
}
