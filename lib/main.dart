import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sampleSize = 500;
  List<int> numbers = [];

  StreamController<List<int>> streamController;
  Stream _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: StreamBuilder<Object>(
              stream: _stream,
              builder: (context, snapshot) {
                int counter = 0;
                return Row(
                  children: numbers.map((number) {
                    counter++;
                    return CustomPaint(
                      painter: BarPainter(
                        width: MediaQuery.of(context).size.width / sampleSize,
                        height: number,
                        index: counter,
                      ),
                    );
                  }).toList(),
                );
              })),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: FlatButton(
              child: Text('Randomize'),
              onPressed: () {
                randomize();
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text('Sort'),
              onPressed: () {
                sort();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController<List<int>>();
    _stream = streamController.stream;
    randomize();
  }

  void randomize() {
    numbers = [];
    for (int i = 0; i < sampleSize; i++) {
      numbers.add(Random().nextInt(sampleSize));
    }

    streamController.add(numbers);
    //setState(() {});
  }

  Future<void> sort() async {
    for (int i = 0; i < numbers.length; i++) {
      for (int j = 0; j < numbers.length - i - 1; j++) {
        if (numbers[j] > numbers[j + 1]) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }

        await Future.delayed(Duration(microseconds: 100));

        streamController.add(numbers);
        //setState(() {});
      }
    }
  }
}

class BarPainter extends CustomPainter {
  double width;
  int height;
  int index;

  BarPainter({this.width, this.height, this.index});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (height < 100) {
      paint.color = Colors.lightGreen[100];
    } else if (height < 200) {
      paint.color = Colors.lightGreen[300];
    } else if (height < 300) {
      paint.color = Colors.green[400];
    } else if (height < 400) {
      paint.color = Colors.green[600];
    } else if (height < 500) {
      paint.color = Colors.green[900];
    }

    paint.strokeWidth = 5.0;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, height.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
