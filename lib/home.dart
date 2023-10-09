import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String url = "https://dev.to/api/users/by_username?url=alvbarros";

  Future<Map<String, dynamic>> getJson(String url) async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final futureJson = getJson(url);

    return Scaffold(
      body: SizedBox.expand(
        child: FutureBuilder(
          future: futureJson,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return filledWidget(snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget filledWidget(Map<String, dynamic> data) {
    const boldStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Follow me on Dev.to!", style: boldStyle),
        profilePicture(data["profile_image"]),
        profileLink(data["name"]),
      ],
    );
  }

  Widget profileLink(String profileName) {
    const linkStyle = TextStyle(
      fontSize: 16,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue,
      color: Colors.blue,
    );
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse('https://dev.to/$profileName'));
      },
      child: Text('dev.to/$profileName', style: linkStyle),
    );
  }

  Widget profilePicture(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(180.0),
      child: Image.network(url, height: 200),
    );
  }
}
