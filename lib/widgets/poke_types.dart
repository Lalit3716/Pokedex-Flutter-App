import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class PokeTypes extends StatelessWidget {
  final dynamic types;

  const PokeTypes({Key? key, required this.types}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Types',
            style: Theme.of(context).textTheme.headline5,
          ),
          Wrap(
            spacing: 10.0,
            children: types["types"]!.map<Widget>((type) {
              return Chip(
                label: Text(type, style: const TextStyle(color: Colors.white)),
                backgroundColor: TypeColors.getColor(type as String),
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Weaknesses',
            style: Theme.of(context).textTheme.headline5,
          ),
          Wrap(
            spacing: 10.0,
            children: types["weak_against"]!.map<Widget>((type) {
              return Chip(
                label: Text("${type[0]} ${type[1]}",
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: TypeColors.getColor(type[0] as String),
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Strong Against',
            style: Theme.of(context).textTheme.headline5,
          ),
          Wrap(
            spacing: 10.0,
            children: types["strong_against"]!.map<Widget>((type) {
              return Chip(
                label: Text("${type[0]} ${type[1]}",
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: TypeColors.getColor(type[0] as String),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
