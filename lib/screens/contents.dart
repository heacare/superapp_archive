import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hea/models/content.dart';
import 'package:hea/data/content_repo.dart';
import 'package:hea/screens/content.dart';

final contents = ContentRepo();

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({Key? key}) : super(key: key);

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Content"),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot<Content>>(
            stream: contents.getAll(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.hasError) {
                return Text("An error occured");
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.size,

                itemBuilder: (context, index) {
                  final content = data.docs[index].data();
                  return TextButton( child: Text(content.title), onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContentScreen(content: content))
                    );
                  });
                }
              );
            }
          )
      ),
    );
  }
}
