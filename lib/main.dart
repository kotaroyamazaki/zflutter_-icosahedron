import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

void main() => runApp(Dices());

class Dices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('正二十面体ダイス')),
        body: Center(
          child: ZIllustration(
            zoom: 1.5,
            children: [
              Icosahedron(
                size: 200,
                goodColor: Colors.green,
                badColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Icosahedron extends StatelessWidget {
  final double size;
  final Color goodColor;
  final Color badColor;

  const Icosahedron({
    super.key,
    required this.size,
    required this.goodColor,
    required this.badColor,
  });

  @override
  Widget build(BuildContext context) {
    final vertices = _getIcosahedronVertices(size / 2);
    final faces = _getIcosahedronFaces();

    return ZGroup(
      children: List.generate(faces.length, (index) {
        final isBadLuck = index == 0; // 1面だけ大凶
        final color = isBadLuck ? badColor : goodColor;

        // 各面の頂点を取得
        final face = faces[index];
        final v1 = vertices[face[0]];
        final v2 = vertices[face[1]];
        final v3 = vertices[face[2]];

        return ZShape(
          stroke: 1,
          path: [
            ZMove.vector(v1), // v1はZVector型
            ZLine.vector(v2), // v2はZVector型
            ZLine.vector(v3), // v3はZVector型
          ],
          color: color,
          fill: true,
        );
      }),
    );
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
