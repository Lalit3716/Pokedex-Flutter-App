import "package:flutter/material.dart";

class PokeMoveList extends StatefulWidget {
  final List<dynamic> moves;

  const PokeMoveList({Key? key, required this.moves}) : super(key: key);

  @override
  _PokeMoveListState createState() => _PokeMoveListState();
}

class _PokeMoveListState extends State<PokeMoveList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: widget.moves.map<Widget>((move) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.purple[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                "${move["move"]["name"]}",
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Power: ${move["move"]["power"]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Accuracy: ${move["move"]["accuracy"]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
