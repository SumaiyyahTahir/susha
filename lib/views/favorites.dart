import 'package:firebase_susha/firebase_susha.dart';
import 'package:flutter/material.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:susha/constants/routes.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Future<List<Shoe>>? _getFavoriteShoes;
  late User user;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    String uid = AuthService.firebase().currentUser?.uid ?? "";
    User? fetchedUser = await UserFirestoreService().getUser(uid);
    setState(() {
      user = fetchedUser!;
      _getFavoriteShoes = _fetchFavoriteShoes();
    });
  }

  Future<List<Shoe>> _fetchFavoriteShoes() async {
    if (user.favShoes.isEmpty) {
      return [];
    }
    List<Shoe> favoriteShoes = await ShoeFirestoreService().getShoesByIds(user.favShoes);
    return favoriteShoes;
  }

  void _toggleSelected(String shoeId) async {
    if (user.id != "") {
      if (user.favShoes.contains(shoeId)) {
        await UserFirestoreService().removeFromFavorites(user.id, shoeId);
      } else {
        await UserFirestoreService().addToFavorites(user.id, shoeId);
      }
    }

    await initialize();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Favorites'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: FutureBuilder<List<Shoe>>(
            future: _getFavoriteShoes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error is: ${snapshot.error}'),
                );
              }

              List<Shoe>? favoriteShoes = snapshot.data;

              if (favoriteShoes == null || favoriteShoes.isEmpty) {
                return const Center(
                  child: Text('No favorite shoes.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: favoriteShoes.length,
                itemBuilder: (context, index) {
                  final shoe = favoriteShoes[index];
                  final isSelected = user.favShoes.contains(shoe.productId);

                  return Card(
                    child: ListTile(
                      leading: Image.network(shoe.imageUrl),
                      title: Text(shoe.model),
                      subtitle: Text(shoe.description),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected ? Icons.favorite : Icons.favorite_border,
                          color: isSelected ? Colors.red : null,
                        ),
                        onPressed: () {
                          _toggleSelected(shoe.productId);
                        },
                      ),
                      onTap: () {
                        // Handle shoe selection
                        
                        Navigator.of(context).pushNamed(
                          itemInfo,
                          arguments: shoe.productId,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
