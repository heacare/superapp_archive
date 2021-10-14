import 'package:colorful_safe_area/colorful_safe_area.dart';
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

    final contentListView = StreamBuilder<QuerySnapshot<Content>>(
      stream: contents.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("An error occured");
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;
        return Expanded(
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8.0);
              },
              padding: const EdgeInsets.all(16.0),
              itemCount: data.size,
              itemBuilder: (context, index) {
                final content = data.docs[index].data();

                return Card(
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ContentScreen(content: content))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  content.title,
                                  style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold)
                                )
                              ),
                              const SizedBox(width: 16.0),
                              Container(
                                child: const Padding(
                                  child: Text("+5 years", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, height: 1.0)),
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16.0)
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          // TODO Pull from content model
                          const Text("Lorem Ipsum")
                        ],
                      )
                    ),
                  ),
                  color: Colors.grey[200],
                );
              })
        );
      });

    return Scaffold(
      body: ColorfulSafeArea(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              child: Text("Content", style: Theme.of(context).textTheme.headline1),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)
            ),
            contentListView
          ]
        )
      )
    );
  }
}
