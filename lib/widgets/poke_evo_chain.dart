import 'package:flutter/material.dart';

class EvoChain extends StatelessWidget {
  final List<dynamic> evoChain;

  const EvoChain({Key? key, required this.evoChain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    evoChain.sort((p1, p2) => (p1["id"] as int).compareTo(p2["id"] as int));
    return Column(
      children: evoChain.map<Widget>((evo) => EvoChainItem(evo: evo)).toList(),
    );
  }
}

class EvoChainItem extends StatelessWidget {
  final dynamic evo;

  const EvoChainItem({Key? key, this.evo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.network(
              evo["imgUrl"],
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evo["name"][0].toUpperCase() + evo["name"].substring(1),
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                "#" + evo["id"].toString().padLeft(3, "0"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
