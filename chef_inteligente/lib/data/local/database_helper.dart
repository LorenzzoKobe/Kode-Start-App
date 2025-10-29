import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:chef_inteligente/models/receita_favorita_model.dart';

class DatabaseHelper {
  // 1. Definição do Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 2. Inicialização do Banco de Dados
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'smartchef.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // 3. Método _onCreate (Criação das Tabelas)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tb_receitas_favoritas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        external_id TEXT NOT NULL UNIQUE,
        origem TEXT NOT NULL,
        nome TEXT NOT NULL,
        imagem_url TEXT NOT NULL,
        tempo_preparo TEXT,
        calorias TEXT,
        ingredientes_json TEXT NOT NULL,
        modo_preparo_json TEXT NOT NULL,
        data_favoritado TEXT NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%S', 'now', 'localtime'))
      )
    ''');

    await db.execute('''
      CREATE TABLE tb_historico_receitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        external_id TEXT NOT NULL UNIQUE,
        origem TEXT NOT NULL,
        nome TEXT NOT NULL,
        imagem_url TEXT NOT NULL,
        tempo_preparo TEXT,
        calorias TEXT,
        ingredientes_json TEXT NOT NULL,
        modo_preparo_json TEXT NOT NULL,
        data_visualizacao TEXT NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%S', 'now', 'localtime'))
      )
    ''');
  }

  // 4. Métodos CRUD (Criar, Ler, Atualizar, Deletar) para Favoritos

  Future<int> adicionarFavorito(ReceitaFavorita receita) async {
    final db = await instance.database;
    return await db.insert(
      'tb_receitas_favoritas',
      receita.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removerFavorito(String externalId) async {
    final db = await instance.database;
    return await db.delete(
      'tb_receitas_favoritas',
      where: 'external_id = ?',
      whereArgs: [externalId],
    );
  }

  Future<List<ReceitaFavorita>> getTodosFavoritos() async {
    final db = await instance.database;
    final maps = await db.query(
      'tb_receitas_favoritas',
      orderBy: 'data_favoritado DESC',
    );

    if (maps.isEmpty) {
      return [];
    }

    return maps.map((map) => ReceitaFavorita.fromMap(map)).toList();
  }

  Future<bool> isFavorito(String externalId) async {
    final db = await instance.database;
    final maps = await db.query(
      'tb_receitas_favoritas',
      where: 'external_id = ?',
      whereArgs: [externalId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }
}
