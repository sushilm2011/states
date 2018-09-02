import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final url = "https://raw.githubusercontent.com/sab99r/Indian-States-And-Districts/master/states-and-districts.json";
  var statesList;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "States App"
        ),
      ),
      body: statesList != null
        ?ListView.builder(
            itemCount : statesList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    statename: statesList[index]['state'],
                    districts: statesList[index]['districts']
                  )
                ));
              },
              title: Text(statesList[index]['state']),
              leading: CircleAvatar(
                backgroundColor: Color(0xff000000 - random.nextInt(0x00ffffff)),
                child: Text(statesList[index]['state'].substring(0, 2)),
              ),
            )
        )
          :Center(
        child: CircularProgressIndicator(),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async{
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);

    statesList = decodedJson['states'];
    //rebuilds the whole UI
    setState(() {});

  }
}

class DetailsPage extends StatelessWidget {
  final statename;
  final districts;
  Random random = Random();

  DetailsPage({this.statename, this.districts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(statename),
        ),
        body: ListView.builder(
          itemCount: districts.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(districts[index]),
            leading: CircleAvatar(
              backgroundColor: Color(0xff000000 - random.nextInt(0x00ffffff)),
              child: Text(districts[index].substring(0, 2)),
            ),
          ),
        ),
      );
  }
}

