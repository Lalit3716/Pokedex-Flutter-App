import 'dart:math';

Future<bool> catchPokemon(int catchRate) {
  const maxCatchRate = 255;
  final pct = (catchRate / maxCatchRate) * 100;

  final rand = Random().nextInt(100);
  final randDelay = 500 + Random().nextInt(2500 - 500);

  return Future.delayed(Duration(milliseconds: randDelay), () {
    return pct >= rand;
  });
}
