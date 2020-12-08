import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String revistaTable = "revistaTabela";
final String idColumn = "idColumn";
final String tituloColumn = "tituloColumn";
final String autorColumn = "autorColumn";
final String categoriaColumn = "categoriaColumn";
final String editoraColumn = "editoraColumn";
final String anoColumn = "anoColumn";
final String portabilidadeColumn = "portabilidadeColumn";
final String statusColumn = "statusColumn";
final String avaliacaoColumn = "avaliacaoColumn";
final String capaColumn = "capaColumn";

class RevistaHelper {
  static final RevistaHelper _instance = RevistaHelper.internal();

  factory RevistaHelper() => _instance;

  RevistaHelper.internal();

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
    final path = join(databasesPath, "revistei.db");
    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $revistaTable($idColumn INTEGER PRIMARY KEY, $tituloColumn TEXT"
          ", $autorColumn TEXT, $categoriaColumn TEXT, $editoraColumn TEXT"
          ", $anoColumn INTEGER, $portabilidadeColumn TEXT, $statusColumn TEXT"
          ", $avaliacaoColumn INTEGER, $capaColumn TEXT )");
    });
  }

  Future<Revistas> InserirRevista(Revistas revista) async {
    Database dbRevista = await db;
    revista.id = await dbRevista.insert(revistaTable, revista.toMap());
    return revista;
  }

  Future<Revistas> SelecionarRevista(int id) async {
    Database dbRevista = await db;
    List<Map> maps = await dbRevista.query(revistaTable,
        columns: [
          idColumn,
          tituloColumn,
          autorColumn,
          categoriaColumn,
          editoraColumn,
          anoColumn,
          portabilidadeColumn,
          statusColumn,
          avaliacaoColumn,
          capaColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Revistas.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> DeletarRevista(int id) async {
    Database dbRevista = await db;
    return await dbRevista
        .delete(revistaTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> EditarRevista(Revistas revista) async {
    Database dbRevista = await db;
    return await dbRevista.update(revistaTable, revista.toMap(),
        where: "$idColumn = ?", whereArgs: [revista.id]);
  }

  Future<List> getTodosRevista() async {
    Database dbRevista = await db;
    List listMap = await dbRevista.rawQuery("SELECT * FROM $revistaTable");
    List<Revistas> listRevista = List();
    for (Map map in listMap) {
      listRevista.add(Revistas.fromMap(map));
    }
    return listRevista;
  }

  Future<int> getQuantidade() async {
    Database dbRevista = await db;
    return Sqflite.firstIntValue(
        await dbRevista.rawQuery("SELECT COUNT(*) FROM $revistaTable"));
  }

  Future close() async {
    Database dbRevista = await db;
    await dbRevista.close();
  }
}

class Revistas {
  int id;
  String titulo;
  String autor;
  String categoria;
  String editora;
  int ano;
  String portabilidade;
  String status;
  int avaliacao;
  String capa;

  Revistas();

  Revistas.fromMap(Map map) {
    id = map[idColumn];
    titulo = map[tituloColumn];
    autor = map[autorColumn];
    categoria = map[categoriaColumn];
    editora = map[editoraColumn];
    ano = map[anoColumn];
    portabilidade = map[portabilidadeColumn];
    status = map[statusColumn];
    avaliacao = map[avaliacaoColumn];
    capa = map[capaColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tituloColumn: titulo,
      autorColumn: autor,
      categoriaColumn: categoria,
      editoraColumn: editora,
      anoColumn: ano,
      portabilidadeColumn: portabilidade,
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
