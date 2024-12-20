import 'dart:math';
import 'package:flutter/material.dart';
import 'package:risky_dice/widgets/icosahedron.dart';
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
