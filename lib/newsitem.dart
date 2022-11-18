import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  const NewsItem(
      {super.key,
      required this.name,
      required this.author,
      required this.title,
      required this.url,
      required this.image,
      required this.description,
      required this.content,
      required this.time});
  final String? name;
  final String? author;
  final String? title;
  final String? url;
  final String? image;
  final String? description;
  final String? time;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.network(
            image!,
            fit: BoxFit.fill,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              );
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                    // value: loadingProgress.expectedTotalBytes != null
                    //     ? loadingProgress.cumulativeBytesLoaded /
                    //         loadingProgress.expectedTotalBytes!
                    //     : null,
                    ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('images/Image_Not_Found.jpeg');
            },
          ),
          Text("Title: $title"),
          Text("Description: $description"),
          Text("Content: $content"),
          Text("Source: $name"),
        ]),
      ),
      onTap: () async {
        if (url == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            elevation: 10,
            content: Container(
              padding: const EdgeInsets.all(10),
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const Center(
                child: Text("Page not loaded"),
              ),
            ),
          ));
        } else {
          final uri = Uri.parse(url ?? "");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $url';
          }
        }
      },
    );
  }
}
