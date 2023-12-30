import 'package:flutter/material.dart';
import 'package:scrolling_gallery/scrolling_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScrollingGalleryExample(),
    );
  }
}

class ScrollingGalleryExample extends StatefulWidget {

  const ScrollingGalleryExample({super.key});

  @override
  State<ScrollingGalleryExample> createState() =>
      _ScrollingGalleryExampleState();
}

class _ScrollingGalleryExampleState extends State<ScrollingGalleryExample> {
  double _rotation = 0;
  late final _imagesPerColumn = <List<String>>[];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++) {
      final columnImages = <String>[];
      for (int c = 1; c <= 5; c++) {
        columnImages.add("assets/images/img_${c + (i * 5)}.jpg");
      }

      _imagesPerColumn.add(columnImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: ScrollingGallery(
              rotation: _rotation,
              height: 478,
              imagesPerColumn: _imagesPerColumn,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 24,
            right: 24,
            child: Slider(
              value: _rotation,
              label: _rotation.round().toString(),
              onChanged: (value) {
                setState(
                  () {
                    _rotation = value;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
