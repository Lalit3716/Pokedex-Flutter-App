import 'package:flutter/material.dart';

import '../widgets/stats_chart.dart';
import '../widgets/poke_types.dart';
import '../widgets/poke_evo_chain.dart';
import '../widgets/move_list.dart';

import '../services/api.dart' show getPokemon;
import '../helpers/catch_pokemon.dart' show catchPokemon;
import '../db/poke_db.dart';
import '../models/fav_pokemon.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({Key? key}) : super(key: key);

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  dynamic _pokemon;
  bool _isCatching = false;

  final FavPokemonDB _db = FavPokemonDB();

  final TextEditingController _nicknameController = TextEditingController();

  _getPokemon({required int id, String name = ""}) async {
    var pokemon = await getPokemon(id: id, name: name);
    setState(() {
      _pokemon = pokemon;
    });
  }

  _onCatchTap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final catchRate = _pokemon["species"]["capture_rate"];
        final Color color;

        if (catchRate < 45) {
          color = Colors.red;
        } else if (catchRate < 150) {
          color = Colors.orange;
        } else {
          color = Colors.green;
        }

        return AlertDialog(
          title: const Text("Catch"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to catch ${_pokemon["name"]}?"),
              const SizedBox(height: 8),
              Text(
                "Catch rate: $catchRate",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                setState(() {
                  _isCatching = true;
                });
                bool result = await catchPokemon(catchRate);
                setState(() {
                  _isCatching = false;
                });
                Navigator.of(context).pop(result);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      if (val != null) {
        if (val) {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text(
                    "Caught!",
                    style: TextStyle(color: Colors.green),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Give your ${_pokemon["name"]} a nickname:"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(
                          labelText: "Nickname",
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Cool!"),
                      onPressed: () {
                        Navigator.of(ctx).pop(_nicknameController.text);
                      },
                    ),
                  ],
                );
              }).then((val) {
            String nickname = val;
            if (nickname.isEmpty) {
              nickname = _pokemon["name"];
            }
            FavPokemon favPokemon = FavPokemon(
              id: _pokemon["id"],
              name: _pokemon["name"],
              nickname: nickname,
              imgUrl: _pokemon["imgUrl"],
            );
            _db.insert(favPokemon);
          });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text(
                    "Failed",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text("${_pokemon["name"]} fled away!"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (_pokemon == null) {
      _getPokemon(id: args["id"], name: args["name"]);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "${args["name"][0].toUpperCase()}${args["name"].substring(1)}",
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          !_isCatching
              ? "${args["name"][0].toUpperCase()}${args["name"].substring(1)}"
              : "Catching ${args["name"][0].toUpperCase()}${args["name"].substring(1)}...",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "#" + "${_pokemon["id"]}".toString().padLeft(3, "0"),
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                _pokemon["name"][0].toUpperCase() +
                    _pokemon["name"].substring(1),
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.network(
                  _pokemon["imgUrl"],
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Description",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.amber,
                child: Text(
                  _pokemon["species"]["descriptions"][0]["description"]
                      .replaceAll(
                    "\n",
                    " ",
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onCatchTap,
                icon: const Icon(Icons.catching_pokemon),
                label: Text("Catch ${_pokemon["name"]}"),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Base Stats",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              PokeStatsChart(
                stats: _pokemon["stats"],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Info",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.lightBlueAccent,
                  ),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      Row(
                        children: [
                          const Text("Base Experience - "),
                          Text("${_pokemon["base_experience"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Height - "),
                          Text("${_pokemon["height"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Weight - "),
                          Text("${_pokemon["weight"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Generation - "),
                          Text(
                            "${_pokemon["species"]["generation_id"]}",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Catch Rate - "),
                          Text("${_pokemon["species"]["capture_rate"]}"),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text("Abilities - "),
                          Wrap(
                            spacing: 8.0,
                            children: _pokemon["abilities"]
                                .map<Widget>(
                                  (ability) => Chip(
                                    label: Text(
                                      ability["ability"]["name"],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.0,
                        children: [
                          const Text("Gender - "),
                          ..._pokemon["species"]["gender"]
                              .map<Widget>((gender) {
                            return Chip(
                                label: Text(gender),
                                avatar: gender == 'male'
                                    ? const Icon(Icons.male)
                                    : const Icon(Icons.female));
                          }).toList(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: PokeTypes(types: _pokemon["types"]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Evolutions",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              EvoChain(evoChain: _pokemon["species"]["evolution_chain"]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Moves",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              PokeMoveList(moves: _pokemon["moves"]),
            ],
          ),
        ),
      ),
    );
  }
}
