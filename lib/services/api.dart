import 'dart:convert';

import "package:http/http.dart" as http;
import "./queries.dart";

const String apiUrl = "https://beta.pokeapi.co/graphql/v1beta";
const String imageUrl =
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork";

Future<dynamic> fetchGraphQL(
    {required String query,
    Map<String, dynamic>? variables,
    required String operationName}) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: json.encode({
      "query": query,
      "variables": variables,
      "operationName": operationName,
    }),
  );
  dynamic data = response.body;

  return jsonDecode(data)["data"];
}

Future<dynamic> getPokemons({
  required int gen,
  required String name,
  required int limit,
  required int offset,
  required String order,
  String sortBy = "id",
}) async {
  var data = await fetchGraphQL(
    query: getPokemonsQuery(sortBy, gen != 0),
    variables: {
      if (gen != 0) "gen": gen,
      "name": name,
      "limit": limit,
      "offset": offset,
      "order": order,
    },
    operationName: "getPokemons",
  );

  var count = data["aggregate"]["aggregate"]["count"];

  if (data.length == 0) {
    throw Exception("No results found for your search");
  }

  var transformedData = data["pokemons"].map((pokemon) {
    return {
      ...pokemon,
      "imgUrl": "$imageUrl/${pokemon["id"]}.png",
    };
  }).toList();

  return {"pokemons": transformedData, "count": count};
}

Future<dynamic> getPokemon({required id, String name = ""}) async {
  var data = await fetchGraphQL(
      query: getPokemonQuery(),
      variables: {"id": id, "name": name},
      operationName: "getPokemon");

  dynamic pokemon = data["pokemon"][0];

  List<dynamic> types = [];
  List<dynamic> weakAgainst = [];
  List<dynamic> strongAgainst = [];
  List<dynamic> gender = [];

  if (pokemon["species"]["gender_rate"] == null) {
    gender = ["undefined"];
  } else if (pokemon["species"]["gender_rate"] == 0) {
    gender = ["male"];
  } else if (pokemon["species"]["gender_rate"] == 8) {
    gender = ["female"];
  } else if (pokemon["species"]["gender_rate"] == -1) {
    gender = ["genderless"];
  } else {
    gender = ["male", "female"];
  }

  for (int i = 0; i < pokemon["types"].length; i++) {
    var type = pokemon["types"][i];

    types.add(type["type"]["name"]);

    for (int i = 0; i < type["type"]["damage_relations"].length; i++) {
      var damageRelation = type["type"]["damage_relations"][i];

      if (damageRelation["damage_factor"] == 200 ||
          damageRelation["damage_factor"] == 150) {
        if (!strongAgainst.contains(damageRelation["type"]["name"])) {
          strongAgainst.add([
            damageRelation["type"]["name"],
            damageRelation["damage_factor"] == 200 ? "2x" : "1.5x",
          ]);
        }
      } else {
        if (!weakAgainst.contains(damageRelation["type"]["name"])) {
          weakAgainst.add([
            damageRelation["type"]["name"],
            damageRelation["damage_factor"] == 0 ? "0x" : "0.5x",
          ]);
        }
      }
    }
  }

  var evoChain = pokemon["species"]["evolution_chain"]["species"];

  var seen = <String>{};
  List<dynamic> uniqueMoveList =
      pokemon["moves"].where((move) => seen.add(move["move"]["name"])).toList();

  var transformedData = {
    ...pokemon,
    "stats": {
      "hp": pokemon["stats"][0]["base_stat"],
      "attack": pokemon["stats"][1]["base_stat"],
      "defense": pokemon["stats"][2]["base_stat"],
      "special-attack": pokemon["stats"][3]["base_stat"],
      "special-defense": pokemon["stats"][4]["base_stat"],
      "speed": pokemon["stats"][5]["base_stat"],
    },
    "species": {
      ...(pokemon["species"] as Map),
      "evolution_chain": evoChain.map((species) {
        return {
          ...(species as Map),
          "imgUrl": "$imageUrl/${species["id"]}.png",
        };
      }).toList(),
      "gender": gender,
    },
    "types": {
      "types": types,
      "weak_against": weakAgainst,
      "strong_against": strongAgainst,
    },
    "moves": uniqueMoveList,
    "imgUrl": "$imageUrl/${pokemon["id"]}.png"
  };

  return transformedData;
}
