import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String livroTable = "livrosTabela";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String autorColumn = "autorColumn";
final String assuntoColumn = "assuntoColumn";
final String editoraColumn = "editoraColumn";
final String anoColumn = "anoColumn";
final String resenhaColumn = "resenhaColumn";
final String statusColumn = "statusColumn";
final String avaliacaoColumn = "avaliacaoColumn";
final String capaColumn = "capaColumn";

class LivroHelper {
  static final LivroHelper _instance = LivroHelper.internal();

  factory LivroHelper() => _instance;

  LivroHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "biblioteca.db");
    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $livroTable($idColumn INTEGER PRIMARY KEY, $tituloColumn TEXT"
          ", $autorColumn TEXT, $assuntoColumn TEXT, $editoraColumn TEXT"
          ", $anoColumn INTEGER, $resenhaColumn TEXT, $statusColumn TEXT"
          ", $avaliacaoColumn INTEGER, $capaColumn TEXT )");
    });
  }

  Future<Livros> InserirLivro(Livros livro) async {
    Database dbLivro = await db;
    livro.id = await dbLivro.insert(livroTable, livro.toMap());
    return livro;
  }

  Future<Livros> SelecionarLivro(int id) async {
    Database dbLivro = await db;
    List<Map> maps = await dbLivro.query(livroTable,
        columns: [
          idColumn,
          tituloColumn,
          autorColumn,
          assuntoColumn,
          editoraColumn,
          anoColumn,
          resenhaColumn,
          statusColumn,
          avaliacaoColumn,
          capaColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Livros.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> DeletarLivro(int id) async {
    Database dbLivro = await db;
    return await dbLivro
        .delete(livroTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> EditarLivro(Livros livro) async {
    Database dbLivro = await db;
    return await dbLivro.update(livroTable, livro.toMap(),
        where: "$idColumn = ?", whereArgs: [livro.id]);
  }

  Future<List> getTodosLivro() async {
    Database dbLivro = await db;
    List listMap = await dbLivro.rawQuery("SELECT * FROM $livroTable");
    List<Livros> listLivro = List();
    for (Map map in listMap) {
      listLivro.add(Livros.fromMap(map));
    }
    return listLivro;
  }

  Future<int> getQuantidade() async {
    Database dbLivro = await db;
    return Sqflite.firstIntValue(
        await dbLivro.rawQuery("SELECT COUNT(*) FROM $livroTable"));
  }

  Future close() async {
    Database dbLivro = await db;
    await dbLivro.close();
  }
}

class Livros {
  int id;
  String titulo;
  String autor;
  String assunto;
  String editora;
  int ano;
  String resenha;
  String status;
  int avaliacao;
  String capa;

  Livros();

  Livros.fromMap(Map map) {
    id = map[idColumn];
    titulo = map[tituloColumn];
    autor = map[autorColumn];
    assunto = map[assuntoColumn];
    editora = map[editoraColumn];
    ano = map[anoColumn];
    resenha = map[resenhaColumn];
    status = map[statusColumn];
    avaliacao = map[avaliacaoColumn];
    capa = map[capaColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tituloColumn: titulo,
      autorColumn: autor,
      assuntoColumn: assunto,
      editoraColumn: editora,
      anoColumn: ano,
      resenhaColumn: resenha,
      statusColumn: status,
      avaliacaoColumn: avaliacao,
      capaColumn: capa
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
