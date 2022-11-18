import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/newsitem.dart';

import 'drawer.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  static const route = '/country';
  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  String place = "us";
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
      drawer: const MyDrawer(),
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (actionIcon.icon == Icons.search) {
                actionIcon = const Icon(Icons.close);
                appBarTitle = TextField(
                  onSubmitted: (value) {
                    setState(() {
                      place = _countries[value]!;
                      // place = _countries[
                      //     value.toLowerCase().substring(0).toUpperCase()]!;
                      // print(place);
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
      ]),
      body: Column(
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
              height: MediaQuery.of(context).size.height - 120,
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
                      return ListView.builder(itemBuilder: (context, index) {
                        // scrollDirection:
                        // Axis.vertical;
                        // true;
                        return NewsItem(
                            name: snapshot.data![index]['source']['name'] ?? "",
                            author: snapshot.data![index]['author'] ?? "",
                            title: snapshot.data![index]['title'] ?? "",
                            url: snapshot.data![index]['url'] ?? "",
                            image: snapshot.data![index]['urlToImage'] ?? "",
                            description:
                                snapshot.data![index]['description'] ?? "",
                            content: snapshot.data![index]['content'] ?? "",
                            time: snapshot.data![index]['publishedAt'] ?? "");
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

Future countries(place) async {
  final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=${place}&apiKey=e794659b40054edb8c27fd25f3a6698d");
  final data = await http.get(url);
  final res = await jsonDecode(data.body);
  // print(url);
  // print(res['articles']);
  return res['articles'];
}
