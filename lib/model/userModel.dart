import 'package:database_contacts/helper/constance.dart';
import 'package:database_contacts/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UserModel {
  int? id;
  String? name, email, phone;
  // UserType type = UserType.user;

  UserModel({this.id, this.name, this.email, this.phone});

  toJson() {
    return {columnName: name, columnPhone: phone, columnEmail: email};
  }

  UserModel.fromJson(Map map) {
    id = map[columnId];
    name = map[columnName];
    phone = map[columnPhone];
    email = map[columnEmail];
  }

  Future<int> insert() async {

    return await DatabaseHelper.database.insert(
      tableUser,
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update() async {
    return await DatabaseHelper.database.update(
      tableUser,
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  static Future<UserModel?> getUser(int id) async {
    List<Map> maps = await DatabaseHelper.database.query(
      tableUser,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? UserModel.fromJson(maps.first) : null;
  }

  static Future<List<UserModel>> getAll() async {
    List<Map> users = await DatabaseHelper.database.query(tableUser);
    return users.isNotEmpty
        ? users.map((user) => UserModel.fromJson(user)).toList()
        : [];
  }

  Future<int> delete(int id) async {
    Colors.red.isLight;
    return DatabaseHelper.database.delete(
      tableUser,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    return DatabaseHelper.database.delete(tableUser);
  }

  Future<int> checkAndDelete() async {
    return DatabaseHelper.database.delete(
      tableUser,
      where: ' LENGTH($columnName) < ? OR LENGTH($columnPhone) < ?',
      whereArgs: [2,5]
    );
  }

  Future<int> save()async {
    if((id ?? 0) == 0){
      return insert();
    }else{
      return update();
    }
  }
}

// enum UserType {
//   admin,user,tempUser,gust
//
// }
//
//
// extension UserTypeEx on UserModel {
//
//   bool get isUser => [UserType.user,UserType.tempUser].contains(this);
//
//
// }