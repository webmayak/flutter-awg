import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:awg/event_model.dart';
import 'package:awg/order_model.dart';

Future<List<Event>> fetchEvent() async {
  final response =
      await http.get(Uri.parse('https://api.teplohod.info/v1/events'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Event>((json) => Event.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Order>> fetchOrder() async {
  final response = await http.get(Uri.parse('http://florist.alex/api/orders'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Order>((json) => Order.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🌸 Заказы ФЛОРИСТ',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('🌸 Заказы ФЛОРИСТ'),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) =>
                    // Container(
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //     padding: EdgeInsets.all(20.0),
                    //     decoration: BoxDecoration(
                    //       color: Color(0xff97FFFF),
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "${snapshot.data![index].title}",
                    //           style: TextStyle(
                    //             fontSize: 18.0,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         SizedBox(height: 10),
                    //         //Text("${snapshot.data![index].description}"),
                    //         Html(data: snapshot.data![index].description),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Card(
                    //   clipBehavior: Clip.antiAlias,
                    //   color: Colors.green,
                    //   elevation: 8,
                    //   margin: EdgeInsets.all(20),
                    //   child: Column(
                    //     children: [
                    //       ListTile(
                    //         title: Text(snapshot.data![index].title),
                    //         subtitle: Text(
                    //           'Secondary Text',
                    //           style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    //         ),
                    //       ),
                    //       Html(data: snapshot.data![index].description),
                    //       SizedBox(height: 10),
                    //     ],
                    //   ),
                    // ),
                    Card(
                  child: InkWell(
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(snapshot.data![index].title),
                      // ));
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                              initialChildSize: 1, //set this as you want
                              maxChildSize: 1, //set this as you want
                              minChildSize: 1, //set this as you want
                              expand: true,
                              builder: (context, scrollController) {
                                return Html(
                                    data: snapshot.data![index].description);
                              });
                          // return FractionallySizedBox(
                          //   heightFactor: 1,
                          //   child: Html(data: snapshot.data![index].description),
                          // );
                        },
                      );
                    },
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Text("#${snapshot.data![index].id}"),
                          title: Text(snapshot.data![index].title),
                          //trailing: Text("ВЫПОЛНЕН"),
                          trailing: Icon(Icons.more_vert),
                          subtitle: Text(snapshot.data![index].subtitle),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
