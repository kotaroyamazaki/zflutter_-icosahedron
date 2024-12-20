import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

void main() => runApp(Dices());

class Dices extends StatefulWidget {
  const Dices({super.key});

  @override
  DicesState createState() => DicesState();
}

class DicesState extends State<Dices> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
// 現在の正面の面
  late ZVector _rotationStart;
  late ZVector _rotationEnd;

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーの初期化
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // アニメーションのリスナー
    _animationController.addListener(() {
      setState(() {});
    });

    _rotationStart = ZVector.zero;
    _rotationEnd = ZVector.zero;

    // アニメーション曲線
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  void _rollDice() {
    if (_animationController.isAnimating) return;

    // ランダムに次の正面の面を決定
    final random = Random();
    int nextFace = random.nextInt(20); // 0から19の面を選ぶ

    // 現在の回転を開始位置として設定
    _rotationStart = _rotationEnd;

    // 次の回転を決定
    _rotationEnd = getIcosahedronRotation(nextFace).add(
      x: 5 * pi * random.nextDouble(),
      y: 5 * pi * random.nextDouble(),
      z: 5 * pi * random.nextDouble(),
    );

    // アニメーションを開始
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotation =
        ZVector.lerp(_rotationStart, _rotationEnd, _animation.value);

    return GestureDetector(
      onTap: _rollDice,
      child: Container(
        color: Colors.black,
        child: ZIllustration(
          zoom: 1.5,
          children: [
            ZPositioned(
              rotate: rotation,
              child: Icosahedron(size: 100),
            ),
          ],
        ),
      ),
    );
  }

  // 各面の回転を取得
  ZVector getIcosahedronRotation(int face) {
    const tau = 2 * pi;
    return ZVector(
      (face % 5) * (tau / 5), // 面ごとの回転角度
      ((face ~/ 5) * tau / 4) % tau,
      0,
    );
  }
}

class Icosahedron extends StatelessWidget {
  final double size;

  const Icosahedron({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final vertices = _getIcosahedronVertices(size / 2);
    final faces = _getIcosahedronFaces();
    final colors = _generateColors(faces.length);

    return ZGroup(
      children: List.generate(faces.length, (index) {
        // 各面の頂点を取得
        final face = faces[index];
        final v1 = vertices[face[0]];
        final v2 = vertices[face[1]];
        final v3 = vertices[face[2]];

        return ZShape(
          stroke: 1,
          path: [
            ZMove.vector(v1),
            ZLine.vector(v2),
            ZLine.vector(v3),
          ],
          color: colors[index],
          fill: true,
        );
      }),
    );
  }

  // 面ごとの色を生成
  List<Color> _generateColors(int count) {
    final random = Random();
    return List.generate(count, (index) {
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  // 正二十面体の頂点を計算
  List<ZVector> _getIcosahedronVertices(double radius) {
    var phi = (1 + sqrt(5)) / 2; // 黄金比

    return [
      ZVector(-1 * radius, phi * radius, 0),
      ZVector(1 * radius, phi * radius, 0),
      ZVector(-1 * radius, -phi * radius, 0),
      ZVector(1 * radius, -phi * radius, 0),
      ZVector(0, -1 * radius, phi * radius),
      ZVector(0, 1 * radius, phi * radius),
      ZVector(0, -1 * radius, -phi * radius),
      ZVector(0, 1 * radius, -phi * radius),
      ZVector(phi * radius, 0, -1 * radius),
      ZVector(phi * radius, 0, 1 * radius),
      ZVector(-phi * radius, 0, -1 * radius),
      ZVector(-phi * radius, 0, 1 * radius),
    ];
  }

  // 正二十面体の各面を定義
  List<List<int>> _getIcosahedronFaces() {
    return [
      [0, 11, 5],
      [0, 5, 1],
      [0, 1, 7],
      [0, 7, 10],
      [0, 10, 11],
      [1, 5, 9],
      [5, 11, 4],
      [11, 10, 2],
      [10, 7, 6],
      [7, 1, 8],
      [3, 9, 4],
      [3, 4, 2],
      [3, 2, 6],
      [3, 6, 8],
      [3, 8, 9],
      [4, 9, 5],
      [2, 4, 11],
      [6, 2, 10],
      [8, 6, 7],
      [9, 8, 1],
    ];
  }
}
