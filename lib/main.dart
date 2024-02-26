import 'dart:math';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JingchengCool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // 循环一百个雪花
  final List<SnowFlake> _snowFlake = List.generate(500, (index) => SnowFlake());

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(), // 设备屏幕有多大占多大
          decoration: const BoxDecoration(
            // 背景渐变 blue -> white
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Colors.white],
            )
          ),
          child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                _snowFlake.forEach((snow) => snow.fall());
                return CustomPaint(
                  painter: MyPainter(_snowFlake),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.transgender_rounded),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<SnowFlake> _snowFlakes;
  MyPainter(this._snowFlakes);

  @override
  void paint(Canvas canvas, Size size) {
    // 雪人
    final whitePaint = Paint()..color = Colors.white;
    // print(size);
    canvas.drawCircle(
      size.center(const Offset(0, 130)),
      60.0,
      whitePaint,
    ); // 位置 半径 空绘制样式
    canvas.drawOval(
      Rect.fromCenter(
        center: size.center(const Offset(0, 340)),
        width: 250,
        height: 300,
      ),
      whitePaint,
    );

    // 雪花
    _snowFlakes.forEach((snowFlake) {
      canvas.drawCircle(
        Offset(snowFlake.x, snowFlake.y),
        snowFlake.radius,
        whitePaint,
      );
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 雪花
class SnowFlake {
  double x = Random().nextDouble() * 500;
  double y = Random().nextDouble() * 800;
  double radius = Random().nextDouble() * 2 + 2; // 雪花尺寸 2-4
  double velocity = Random().nextDouble() * 4 + 2; // 雪花落下速度 4-6

  fall() {
    y += velocity;

    // 雪花落地后回收打乱
    if(y >= 800) {
      x = Random().nextDouble() * 500;
      y = 0;
      velocity = Random().nextDouble() * 4 + 2; // 雪花落下速度 4-6
    }
  }
}
