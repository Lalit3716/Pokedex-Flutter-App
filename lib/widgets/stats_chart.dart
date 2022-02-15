import 'package:flutter/material.dart';

class PokeStatsChart extends StatelessWidget {
  final dynamic stats;

  const PokeStatsChart({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Hp",
                value: stats['hp'] ?? 0,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Attack",
                value: stats['attack'] ?? 0,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Defense",
                value: stats['defense'] ?? 0,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Sp. Attack",
                value: stats['special-attack'] ?? 0,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Sp. Defense",
                value: stats['special-defense'] ?? 0,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: PokeStatBar(
                label: "Speed",
                value: stats['speed'] ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokeStatBar extends StatelessWidget {
  final String label;
  final int? value;
  final maxValue = 255;

  const PokeStatBar({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
          child: FittedBox(
            child: Text("$value"),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.18,
          width: 15,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                ),
              ),
              FractionallySizedBox(
                heightFactor: value! / maxValue,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        FittedBox(
          child: Text(label),
        ),
      ],
    );
  }
}
