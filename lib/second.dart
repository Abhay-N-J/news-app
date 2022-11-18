import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/login.dart';
import 'package:news_app/newsitem.dart';

import 'drawer.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  static const route = '/country';
  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  String place = "in";
  Widget appBarTitle = const Text("News App");
  Icon actionIcon = const Icon(Icons.search);
  final Map<String, String> _countries = {
    'Argentina': 'ar',
    'Australia': 'au',
    'Austria': 'at',
    'Belgium': 'be',
    'Brazil': 'br',
    'Bulgaria': 'bg',
    'Canada': 'ca',
    'China': 'cn',
    'Colombia': 'co',
    'Cuba': 'cu',
    'Czech Republic': 'cz',
    'Egypt': 'eg',
    'France': 'fr',
    'Germany': 'de',
    'Greece': 'gr',
    'Hong Kong': 'hk',
    'Hungary': 'hu',
    'India': 'in',
    'Indonesia': 'id',
    'Ireland': 'ie',
    'Israel': 'il',
    'Italy': 'it',
    'Japan': 'jp',
    'Latvia': 'lv',
    'Lithuania': 'lt',
    'Malaysia': 'my',
    'Mexico': 'mx',
    'Morocco': 'ma',
    'Netherlands': 'nl',
    'New Zealand': 'nz',
    'Nigeria': 'ng',
    'Norway': 'no',
    'Philippines': 'ph',
    'Poland': 'pl',
    'Portugal': 'pt',
    'Romania': 'ro',
    'Russia': 'ru',
    'Saudi Arabia': 'sa',
    'Serbia': 'rs',
    'Singapore': 'sg',
    'Slovakia': 'sk',
    'Slovenia': 'si',
    'South Africa': 'za',
    'South Korea': 'kr',
    'Sweden': 'se',
    'Switzerland': 'ch',
    'Taiwan': 'tw',
    'Thailand': 'th',
    'Turkey': 'tr',
    'UAE': 'ae',
    'Ukraine': 'ua',
    'United Kingdom': 'gb',
    'United States': 'us',
    'Venuzuela': 've'
  };

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (actionIcon.icon == Icons.search) {
                      actionIcon = const Icon(Icons.close);
                      appBarTitle = TextField(
                        onSubmitted: (value) {
                          setState(() {
                            // place = _countries[value]!;
                            place = _countries[
                                "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}"]!;
                            print(place);
                          });
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            hintText: "Search Country name for News",
                            hintStyle: TextStyle(color: Colors.white)),
                      );
                    } else {
                      actionIcon = const Icon(Icons.search);
                      appBarTitle = const Text("News App");
                    }
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.route, (route) => false,
                        arguments: "true");
                  },
                  icon: const Icon(Icons.logout)),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       place = "in";
            //     });
            //   },
            //   child: const Text(""),
            // ),
            Text(
                "News from ${_countries.keys.firstWhere((element) => _countries[element] == place, orElse: () => null.toString())}"),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // height: 550.0,
                // width: 600.0,
                child: FutureBuilder(
                    future: countries(place),
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
                        return ListView.builder(
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, index) {
                              // scrollDirection:
                              // Axis.vertical;
                              // true;
      
                              return index != snapshot.data.length
                                  ? NewsItem(
                                      name: snapshot.data![index]['source']
                                              ['name'] ??
                                          "",
                                      author:
                                          snapshot.data![index]['author'] ?? "",
                                      title: snapshot.data![index]['title'] ?? "",
                                      url: snapshot.data![index]['url'] ?? "",
                                      image: snapshot.data![index]
                                              ['urlToImage'] ??
                                          "",
                                      time: snapshot.data![index]
                                              ['publishedAt'] ??
                                          "",
                                      description: snapshot.data![index]
                                                  ['description'] ==
                                              null
                                          ? ""
                                          : snapshot.data![index]['description']
                                              .substring(
                                              0,
                                            ),
                                      content: snapshot.data![index]['content'] ==
                                              null
                                          ? ""
                                          : snapshot.data![index]['content']
                                                      .length >=
                                                  100
                                              ? snapshot.data![index]['content']
                                                      .substring(0, 100) +
                                                  "...\nClick to view more"
                                              : snapshot.data![index]['content'])
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
      ),
    ));
  }
}

Future countries(place) async {
  final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=${place}&apiKey=e794659b40054edb8c27fd25f3a6698d");
  final data = await http.get(url);
  final res = await jsonDecode(data.body);
  // print(url);
  // print(res['articles']);
  return res['articles'];
}
