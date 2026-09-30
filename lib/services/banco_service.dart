import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/usuario.dart';
import '../models/pedido.dart';

class BancoService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final caminho = kIsWeb
        ? 'the_bear.db'
        : join(await getDatabasesPath(), 'the_bear.db');

    _database = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE pedidos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cliente TEXT NOT NULL,
            prato TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            valorUnitario REAL NOT NULL,
            total REAL NOT NULL,
            classificacao TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> inserirUsuario(Usuario usuario) async {
    final db = await database;

    await db.insert(
      'usuarios',
      usuario.toMap(),
    );
  }

  Future<Usuario?> login(String email, String senha) async {
    final db = await database;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Usuario.fromMap(resultado.first);
  }

  Future<void> inserirPedido(Pedido pedido) async {
    final db = await database;

    await db.insert(
      'pedidos',
      pedido.toMap(),
    );
  }

  Future<List<Pedido>> buscarPedidos() async {
    final db = await database;

    final resultado = await db.query(
      'pedidos',
      orderBy: 'id DESC',
    );

    return resultado
        .map((item) => Pedido.fromMap(item))
        .toList();
  }

  Future<void> finalizarPedido(int id) async {
    final db = await database;

    await db.update(
      'pedidos',
      {'status': 'Finalizado'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> excluirPedido(int id) async {
    final db = await database;

    await db.delete(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}