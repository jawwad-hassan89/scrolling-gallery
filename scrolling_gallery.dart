import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gap/gap.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScrollingGallery extends StatefulWidget {
  final double rotation;
  final double height;
  final int columns;
  final double? itemExtent;
  final List<List<String>> imagesPerColumn;

  const ScrollingGallery({
    super.key,
    required this.rotation,
    this.columns = 3,
    this.height = 320,
    this.itemExtent,
    required this.imagesPerColumn,
  }) : assert(imagesPerColumn.length == columns,
            "The length of imagesPerColumn should be the same as the number of columns");

  @override
  State<ScrollingGallery> createState() => _ScrollingGalleryState();
}

class _ScrollingGalleryState extends State<ScrollingGallery>
    with TickerProviderStateMixin {
  static const _speedFactor = 20;
  static const _rotationCompensation = 100;

  late final _scrollControllers = [
    for (int i = 0; i < widget.columns + 1; i++) ScrollController()
  ];

  void _scroll() {
    _scrollControllers.forEachIndexed(
      (index, scrollController) {
        double maxExtent = scrollController.position.maxScrollExtent;
        double distanceDifference = maxExtent - scrollController.offset;
        double durationDouble = distanceDifference / _speedFactor;

        scrollController.jumpTo(
            (widget.itemExtent ?? (widget.height / widget.columns)) * index);

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()),
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
  }

  @override
  void dispose() {
    for (final scrollController in _scrollControllers) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offset = Offset(
      math.cos((3 * math.pi / 2) + math.pi * widget.rotation) *
          _rotationCompensation,
      math.sin((3 * math.pi / 2) + math.pi * widget.rotation) *
          _rotationCompensation,
    );

    final scrollingColumns = [
      for (int index = 0; index < _scrollControllers.length; index++) ...[
        ShowCaseColumn(
          images: widget.imagesPerColumn[index % widget.columns],
          rotation: widget.rotation,
          scrollController: _scrollControllers[index],
          width: (1.sw / (widget.columns) - 11),
        ),
        const Gap(16),
      ]
    ];

    return Material(
      child: ClipRect(
        child: SizedBox(
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: Transform.rotate(
                    angle: -math.pi * widget.rotation,
                    child: Transform.translate(
                      offset: offset,
                      child: Row(children: scrollingColumns),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowCaseColumn extends StatelessWidget {
  final List<String> images;
  final ScrollController scrollController;
  final double rotation;
  final int itemCount;
  final double separatorGap;
  final double width;

  const ShowCaseColumn({
    super.key,
    required this.images,
    required this.scrollController,
    required this.rotation,
    this.itemCount = 100,
    this.separatorGap = 16,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.separated(
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        controller: scrollController,
        separatorBuilder: (context, index) => SizedBox(height: separatorGap),
        itemBuilder: (context, index) => Center(
          child: ShowCaseItem(
            imgPath: images[index % images.length],
            angle: rotation,
            width: width,
            height: width * 1.2,
          ),
        ),
      ),
    );
  }
}

class ShowCaseItem extends StatelessWidget {
  final String imgPath;
  final double angle;
  final double height;
  final double width;
  final double borderRadius;

  const ShowCaseItem({
    super.key,
    required this.imgPath,
    required this.angle,
    this.height = 160,
    this.width = 140,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final maxLength = height > width ? height : width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        color: Colors.red,
        child: Transform.rotate(
          angle: math.pi * angle,
          child: Transform.scale(
            scale: 1.5,
            child: Image.asset(
              imgPath,
              height: maxLength,
              width: maxLength,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class ScrollingGalleryExample extends StatefulWidget {
  static const route = "intro_screen";

  const ScrollingGalleryExample({super.key});

  @override
  State<ScrollingGalleryExample> createState() => _ScrollingGalleryExampleState();
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
        columnImages.add("assets/showcase_images/img_${c + (i * 5)}.jpg");
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
          ScrollingGallery(
            rotation: _rotation,
            height: 478.h,
            imagesPerColumn: _imagesPerColumn,
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
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

