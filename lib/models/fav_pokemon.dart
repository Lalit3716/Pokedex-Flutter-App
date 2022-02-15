class FavPokemon {
  final int id;
  final String name;
  final String nickname;
  final String imgUrl;

  FavPokemon({
    required this.id,
    required this.name,
    required this.nickname,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'imgUrl': imgUrl,
    };
  }

  @override
  String toString() {
    return 'FavPokemon{id: $id, name: $name, nickname: $nickname, imgUrl: $imgUrl}';
  }
}
