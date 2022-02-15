import 'package:flutter/material.dart';

import '../db/poke_db.dart';
import '../models/fav_pokemon.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FavPokemonDB _db = FavPokemonDB();
  List<FavPokemon> _pokemons = [];
  bool loading = true;

  void _loadFavPokemons() async {
    final List<FavPokemon> favPokemons = await _db.getAll();
    setState(() {
      _pokemons = favPokemons;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavPokemons();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      print('Loading...');
      return const Center(child: CircularProgressIndicator());
    } else if (_pokemons.isEmpty) {
      print('_pokemons is empty');
      return Center(
        child: Text(
          'You have not caught any Pokemon yet!',
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      print('_pokemons is not empty');
      print('Size: ${_pokemons.length}');
      print('First: ${_pokemons[0].name}');
      return ListView.builder(
        itemCount: _pokemons.length,
        itemBuilder: (BuildContext context, int index) {
          final FavPokemon pokemon = _pokemons[index];
          return ListTile(
            leading: Hero(
              tag: pokemon.id,
              child: Image.network(
                pokemon.imgUrl,
                width: 50,
                height: 50,
              ),
            ),
            title: Text(
              pokemon.nickname[0].toUpperCase() + pokemon.nickname.substring(1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "#" + pokemon.id.toString().padLeft(3, '0'),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                _db.delete(pokemon);
                setState(() {
                  _pokemons.remove(pokemon);
                });
              },
            ),
            onTap: () {
              Navigator.pushNamed(context, '/pokemon', arguments: {
                "id": pokemon.id,
                "name": pokemon.name,
              });
            },
          );
        },
      );
    }
  }
}
