import 'dart:developer';

import 'package:aplicatie/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase{

  static connect() async{
    var db = await Db.create(mongo_url);
    await db.open();  
    inspect(db);
    var collection = db.collection(collection_name);

    var status = db.serverStatus();

    print(status);

    print(collection);

    // await collection.insertMany([
    //   {
    //     "nume":"gandac1",
    //     "greutate":1,
    //     "culoare":"rosu"
    //   }
    // ]);
    
    // var cursor = await collection.find();
    // await cursor.forEach((document) {
    //   var culoare = document["culoare"];
    //   print(culoare);
    // });

    // await collection.updateMany(where.eq("nume", "gandac1"), modify.set("culoare", "alb"));

    collection.deleteMany({"nume":"gandac1"});

  }

  Future<void> insertUser(String username, String email, String password, String collectionName) async {
    var db = await Db.create(mongo_url);
    await db.open();  
    var collection = db.collection(collectionName);

    await collection.insertMany([
      {
        "username": username,
        "email": email,
        "password": password
      }
    ]);

    await db.close();
  }

  

  Future<bool> checkUser(String username, String password, String collectionName) async {
    var db = await Db.create(mongo_url);
    await db.open();
    var collection = db.collection(collectionName);

    var result = await collection.findOne({
      "username": username,
      "password": password
    });

    await db.close();

    return result != null;
  }


}

