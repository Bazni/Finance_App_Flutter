

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String movementsTABLE = "movementsTABLE";
final String idColumn = "idColumn";
final String dataColumn = "dataColumn";
final String valueColumn = "valueColumn";
final String typeColumn = "typeColumn";
final String descriptionColumn = "descriptionColumn";


class MovementsHelper {
  static final MovementsHelper _instance = MovementsHelper.internal();
  factory MovementsHelper() => _instance;

  MovementsHelper.internal();

  Database _db;
  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "movements.db");

    return await openDatabase(path,version: 1,onCreate: (Database db,int newerVersion) async {
      await db.execute(
          "CREATE TABLE $movementsTABLE(" +
              "$idColumn INTEGER PRIMARY KEY,"+
              "$valueColumn FLOAT,"+
              "$dataColumn TEXT,"+
              "$typeColumn TEXT,"+
              "$descriptionColumn TEXT)"

      );
    });
  }

  Future<Movements> saveMovements(Movements movements) async {
    Database dbMovements = await db;
    movements.id = await dbMovements.insert(movementsTABLE, movements.toMap());
    return movements;
  }

  Future<Movements> getMovements(int id) async {
    Database dbMovements = await db;
    List<Map> maps = await dbMovements.query(movementsTABLE,
        columns: [idColumn,valueColumn, dataColumn, typeColumn,descriptionColumn],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Movements.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovements(Movements movements) async {
    Database dbMovements = await db;
    return await dbMovements.delete(movementsTABLE,
        where: "$idColumn =?",
        whereArgs: [movements.id]);
  }

  Future<int> updateMovements(Movements movements) async {
    print("chamada update");
    print(movements.toString());
    Database dbMovements = await db;
    return await dbMovements.update(movementsTABLE, movements.toMap(),
        where: "$idColumn =?",
        whereArgs: [movements.id]
    );
  }

  Future<List> getAllMovements() async {
    Database dbMovements = await db;
    List listMap = await dbMovements.rawQuery("SELECT * FROM $movementsTABLE");
    List<Movements> listMovements = List();

    for(Map m in listMap){
      listMovements.add(Movements.fromMap(m));
    }
    return listMovements;
  }
  Future<List> getAllMovementsByMes(String data) async {
    Database dbMovements = await db;
    List listMap = await dbMovements.rawQuery("SELECT * FROM $movementsTABLE WHERE $dataColumn LIKE '%$data%'");
    List<Movements> listMovements = List();

    for(Map m in listMap){
      listMovements.add(Movements.fromMap(m));
    }
    return listMovements;
  }

  Future<List> getAllMovementsByType(String type) async {
    Database dbMovements = await db;
    List listMap = await dbMovements.rawQuery("SELECT * FROM $movementsTABLE WHERE $typeColumn ='$type' ");
    List<Movements> listMovements = List();

    for(Map m in listMap){
      listMovements.add(Movements.fromMap(m));
    }
    return listMovements;
  }



  Future<int> getNumber() async {
    Database dbMovements = await db;
    return Sqflite.firstIntValue(await dbMovements.rawQuery(
        "SELECT COUNT(*) FROM $movementsTABLE"));
  }

  Future close()async{
    Database dbMovements = await db;
    dbMovements.close();
  }
}

class Movements {

  int id;
  String data;
  double value;
  String type;
  String description;

  Movements();

  Movements.fromMap(Map map){
    id = map[idColumn];
    value = map[valueColumn];
    data = map[dataColumn];
    type = map[typeColumn];
    description = map[descriptionColumn];

  }

  Map toMap(){
    Map<String,dynamic> map ={
      valueColumn :value,
      dataColumn : data,
      typeColumn : type,
      descriptionColumn : description,

    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  String toString(){
    return "Movements(id: $id, value: $value, data: $data, type: $type, desc: $description, )";
  }
}