import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hea/models/content.dart';
import 'package:hea/data/content_repo.dart';

final contents = ContentRepo();

class ContentScreen extends StatefulWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
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
                  return Text(content.title);
                }

              );
            }
          )
      ),
    );
  }
}
