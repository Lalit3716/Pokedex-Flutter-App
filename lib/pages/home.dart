import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';

import '../services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic _pokemons;
  int? _count;

  var options = {
    'gen': 0,
    'name': '',
    'limit': 20,
    'offset': 0,
    'order': 'asc',
    'sortBy': 'id'
  };

  _getPokemons() async {
    var pokemons = await getPokemons(
      gen: options["gen"] as int,
      limit: options["limit"] as int,
      offset: options["offset"] as int,
      name: options["name"] as String,
      order: options["order"] as String,
      sortBy: options["sortBy"] as String,
    );

    setState(() {
      _pokemons = pokemons["pokemons"];
      _count = pokemons["count"];
    });
  }

  _addPokemons(int offset) async {
    var pokemons = await getPokemons(
      gen: options["gen"] as int,
      limit: options["limit"] as int,
      offset: offset,
      name: options["name"] as String,
      order: options["order"] as String,
      sortBy: options["sortBy"] as String,
    );

    setState(() {
      _pokemons.addAll(pokemons["pokemons"]);
    });
  }

  _onSearch() {
    setState(() {
      _pokemons = null;
      _getPokemons();
    });
  }

  _onChange(Map<String, Object> options) {
    setState(() {
      this.options.addAll(options);
    });
  }

  _onReset() {
    setState(() {
      options = {
        'gen': 0,
        'name': '',
        'limit': 20,
        'offset': 0,
        'order': 'asc',
        'sortBy': 'id'
      };

      _pokemons = null;
      _getPokemons();
    });
  }

  @override
  void initState() {
    super.initState();

    _getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    if (_pokemons == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          SearchBar(
            onSubmitted: _onSearch,
            onChange: _onChange,
            onReset: _onReset,
            options: options,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: !_pokemons.isEmpty
                ? ListView.builder(
                    itemCount: _pokemons.length + 1 < _count
                        ? _pokemons.length + 1
                        : _count,
                    itemBuilder: (context, index) {
                      if (index == _pokemons.length &&
                          _pokemons.length < _count) {
                        if (_pokemons.length < _count) {
                          _addPokemons(_pokemons.length);
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListTile(
                          leading: Image.network(
                            _pokemons[index]["imgUrl"],
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                              _pokemons[index]["name"][0].toUpperCase() +
                                  _pokemons[index]["name"].substring(1),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Text(
                            "#" +
                                _pokemons[index]["id"]
                                    .toString()
                                    .padLeft(3, '0'),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/pokemon",
                                arguments: {
                                  "id": _pokemons[index]["id"],
                                  "name": _pokemons[index]["name"],
                                });
                          });
                    },
                  )
                : const Center(
                    child: Text("No results found"),
                  ),
          ),
        ],
      ),
    );
  }
}
