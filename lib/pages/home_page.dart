import 'package:flutter/material.dart';
import 'package:pgfy/providers/app_provider.dart';
import 'package:pgfy/widgets/list_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //AppProvider _appProvider;

  @override
  Widget build(BuildContext context) {
    AppProvider _appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 251, 230, 1),//Color.fromRGBO(255, 213, 0, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 239, 248, 1),//Color.fromRGBO(0, 91, 187, 1),
        title: Text(
          'ПЙН | PGFY',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 2,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: showCustomDialog)
        ],
      ),
      body: FutureBuilder(
        future: _appProvider.getUrls(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null &&
              _appProvider.urls.length >= 1) {
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListItem(index);
                },
                separatorBuilder: (BuildContext context, _) => Divider(),
                itemCount: _appProvider.urls.length);
          }
          if (snapshot.data == null) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          if (_appProvider.urls.length < 1) {
            // The list is empty
            return Center(child: Text('Список пустий'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  showCustomDialog() {

    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          AppProvider _appProvider = Provider.of<AppProvider>(context);

          return Dialog(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 300,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Type the url of the site you want to add
                  Text('Введіть URL-адресу сайту, який хочете додати'),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.url,
                      maxLines: 1,
                      expands: false,
                      autofocus: true,
                      controller: controller,
                      decoration: InputDecoration(
                        prefix: Text('https://'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                        height: 40,
                        color: Colors.red,
                        child: Text(
                          'Закрити',// Cancel
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          String text = controller.text;
                          if (text.contains('http')) {
                            text.replaceFirst('http', '');
                          }
                            _appProvider.addUrl('https://$text');
                          Navigator.of(context).pop();
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                        height: 40,
                        color: Colors.blueAccent,
                        child: Text(
                          'Додати',// Add
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
