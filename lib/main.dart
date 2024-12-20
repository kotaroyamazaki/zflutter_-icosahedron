import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';

void main() => runApp(Dices());

class Dices extends StatefulWidget {
  @override
  _DicesState createState() => _DicesState();
}

class _DicesState extends State<Dices> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double zRotation = 0;
  int faceIndex = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addListener(() {
            setState(() {});
          });
  }

  void random() {
    zRotation = Random().nextDouble() * tau;
    faceIndex = Random().nextInt(20);
  }

  @override
  Widget build(BuildContext context) {
    final curvedValue = CurvedAnimation(
      curve: Curves.ease,
      parent: animationController,
    );

    return GestureDetector(
      onTap: () {
        if (animationController.isAnimating) {
          animationController.reset();
        } else {
          random();
          animationController.forward(from: 0);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: ZIllustration(
          zoom: 1.5,
          children: [
            ZGroup(
              children: List.generate(20, (index) {
                final isBadLuck = index == 0; // 大凶の面
                final color = isBadLuck ? Colors.red : Colors.green;

                // 正二十面体の面を配置
                final rotation = getIcosahedronFaceRotation(index);

                return ZPositioned(
                  rotate: rotation,
                  translate: ZVector.only(z: 100),
                  child: ZPolygon(
                    sides: 3, // 三角形
                    stroke: 1,
                    color: color,
                    radius: 50,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

// 正二十面体の各面の回転を計算
ZVector getIcosahedronFaceRotation(int index) {
  const tau = 2 * pi; // 1周の回転
  // 面ごとの回転（簡易的な設定、精度を上げる場合は座標データを使用）
  return ZVector.only(
    x: (index * tau / 20) % tau,
    y: ((index + 3) * tau / 20) % tau,
  );
}
