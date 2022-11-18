import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/newsitem.dart';

import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const route = '/home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _query = "apple";
  String _sources = "bbc-news";
  bool _q = false;
  Widget appBarTitle = const Text("News App");
  Icon actionIcon = const Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true, title: appBarTitle,
        // actions: <Widget>[
        // IconButton(
        //   icon: actionIcon,
        //   onPressed: () {
        //     setState(() {
        //       if (actionIcon.icon == Icons.search) {
        //         actionIcon = const Icon(Icons.close);
        //         appBarTitle = TextField(
        //           onSubmitted: (value) {
        //             setState(() {
        //               place = _countries[
        //                   value.toLowerCase().substring(0).toUpperCase()]!;
        //             });
        //           },
        //           style: const TextStyle(
        //             color: Colors.white,
        //           ),
        //           decoration: const InputDecoration(
        //               prefixIcon: Icon(Icons.search, color: Colors.white),
        //               hintText: "Search Country name for News",
        //               hintStyle: TextStyle(color: Colors.white)),
        //         );
        //       } else {
        //         actionIcon = const Icon(Icons.search);
        //         appBarTitle = const Text("News App");
        //       }
        //     });
        // },
        // ),
      ),
      body: Column(
        children: [
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 80,
                child: FloatingActionButton(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.zero
                  ),

                  onPressed: () {
                    setState(() {
                      _sources = "bbc-news";
                      _q = false;
                    });
                  },
                  child: const Text("BBC-News"),
                  backgroundColor: Colors.white,
                  tooltip:"For BBC News Only... Click Me!",

                ),
              ),
              SizedBox(
                height: 40,
                width: 200,
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      _query = value.trim();
                      _q = true;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search here",

                      hintStyle: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
          // Text(
          //     "News from ${_countries.keys.firstWhere((element) => _countries[element] == place, orElse: () => null.toString())}"),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                  future: headlines(query: _query, sources: _sources, q: _q),
                  builder: (context, snapshot) {
                    List<Widget> children;
                    if (snapshot.connectionState != ConnectionState.done) {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Loading...'),
                        )
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ];
                      // return Center(
                      //     child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: children,
                      // ));
                    } else if (snapshot.hasData) {
                      return ListView.builder(itemBuilder: (context, index) {
                        // scrollDirection:
                        // Axis.vertical;
                        // true;
                        return index < snapshot.data.length
                            ? NewsItem(
                                name: snapshot.data![index]['source']['name'],
                                author: snapshot.data![index]['author'],
                                title: snapshot.data![index]['title'],
                                url: snapshot.data![index]['url'],
                                image: snapshot.data![index]['urlToImage'],
                                time: snapshot.data![index]['publishedAt'],
                                description: snapshot.data![index]['description'] .substring(0,),
                                content: snapshot.data![index]['content'] .substring(0,100) + "...\nClick to view more",

                        )
                            : SizedBox(
                                height: 100,
                                child: ElevatedButton(
                                  onPressed: () => setState(() {}),
                                  child: const Text("Go Back on top"),
                                ),
                              );
                      });
                    } else {
                      children = <Widget>[const Text("ERROR")];
                    }
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ));
                  }),
            ),
          )
        ],
      ),
    ));
  }
}

Future headlines(
    {String query = "", String sources = "", bool q = false}) async {
  Uri url;
  if (q) {
    url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&apiKey=e794659b40054edb8c27fd25f3a6698d");
  } else {
    url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=$sources&apiKey=e794659b40054edb8c27fd25f3a6698d");
  }
  final data = await http.get(url);
  final res = await jsonDecode(data.body);
  // print(url);
  // print(res['articles']);
  return res['articles'];
}
