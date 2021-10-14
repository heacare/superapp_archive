  import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

import 'package:hea/screens/chapter.dart';
import 'package:hea/models/content.dart';

class ContentScreen extends StatefulWidget {
  final Content content;

  const ContentScreen({Key? key, required this.content}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {

    final chapterListView = ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8.0);
      },
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.content.chapters.length,
      itemBuilder: (context, index) {
        final chapter = widget.content.chapters[index];

        return Card(
          child: InkWell(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChapterScreen(chapter: chapter))
            ),
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chapter.title, style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time_outlined, color: Colors.grey[600], size: 18.0),
                            const SizedBox(width: 4.0),
                            // TODO Pull from chapter model
                            Text("5 mins", style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.0, color: Colors.grey[600]))
                          ]
                        )
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Sleep 1XX",
                      style: TextStyle(color: Theme.of(context).textTheme.headline1!.color, fontWeight: FontWeight.bold)
                    )
                  ],
                )
            ),
          ),
          color: Colors.grey[200],
        );
      },
    );

    return Scaffold(
      body: ColorfulSafeArea(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                child: Text(widget.content.title, style: Theme.of(context).textTheme.headline1),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)
              ),
              Expanded(
                child: chapterListView
              )
            ]
        )
      )
    );
  }
}
