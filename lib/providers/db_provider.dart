import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class DbProvider {
  //Database db;

  Future<Database> initializeDB() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //final path = join(documentsDirectory.path, "urls.db");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "pgfy.db");
    print(path);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE urls(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT UNIQUE
          )
        """);
        newDb.rawInsert("""
          INSERT INTO urls (`url`) VALUES ('http://belta.by/'), ('https://sputnik.by/'), ('https://www.tvr.by/'), ('https://www.sb.by/'), ('https://belmarket.by/'), ('https://www.belarus.by/'), ('https://belarus24.by/'), ('https://ont.by/'), ('https://www.024.by/'), ('https://www.belnovosti.by/'), ('https://mogilevnews.by/'), ('https://yandex.by/'), ('https://www.slonves.by/'), ('http://www.ctv.by/'), ('https://radiobelarus.by/'), ('https://radiusfm.by/'), ('https://alfaradio.by/'), ('https://radiomir.by/'), ('https://radiostalica.by/'), ('https://radiobrestfm.by/'), ('https://www.tvrmogilev.by/'), ('https://minsknews.by/'), ('https://zarya.by/'), ('https://grodnonews.by/'), ('https://rec.gov.by/ru'), ('https://www.mil.by/'), ('http://www.government.by/'), ('https://president.gov.by/ru'), ('https://www.mvd.gov.by/ru'), ('http://www.kgb.by/ru/'), ('http://www.prokuratura.gov.by/'), ('http://www.nbrb.by/'), ('https://belarusbank.by/'), ('https://brrb.by/'), ('https://www.belapb.by/'), ('https://bankdabrabyt.by/'), ('https://belinvestbank.by/individual'), ('https://bgp.by/ru/'), ('https://www.belneftekhim.by'), ('http://www.bellegprom.by'), ('https://www.energo.by'), ('http://belres.by/ru/')
        """);
      },
    );
  }

  Future<List<String>> fetchUrls() async {
    final Database db = await initializeDB();
    List<Map> results = await db.query(
      'urls',
      columns: ['url'],
    );
    List<String> urls = [];
    results.forEach((Map<dynamic, dynamic> res) {
      urls.add(res['url']);
    });
    return urls;
  }

  addUrl(String url) async{
    final Database db = await initializeDB();
    Map<String, dynamic> data = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'url': url
    };
    await db.insert('urls', data, conflictAlgorithm: ConflictAlgorithm.replace);
    print('inserted');
  }

  deleteUrl(String url) async{
    final Database db = await initializeDB();
    var res = await db.rawDelete('DELETE FROM urls WHERE url = ?', [url]);
  }
}
