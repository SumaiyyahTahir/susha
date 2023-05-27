import 'package:firebase_susha/firebase_susha.dart';
import 'package:firestore_susha/firestore_susha.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<Shoe>>? _getShoes;
  late Future<User?> getUser;
  late User user;
  late String uid;

  String? _selectedFilter = 'none';
  String? _selectedColor;
  String? _selectedPrice;

  List<String> colorOptions = ['Black', 'White', 'Yellow', 'Blue', 'Red'];

  List<String> priceOptions = [
    'Less than Rs. 3000',
    'Rs. 3000 - Rs. 5000',
    'Rs. 5000 - Rs. 10000',
    'Greater than Rs. 10000',
  ];

  Color _getColorFromName(String colorName) {
    // Map the color name to the respective color
    switch (colorName) {
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Black/White':
        return Colors.black54;
      case 'Yellow':
        return Colors.yellow;
      case 'Blue':
        return Colors.blue;
      case 'Red':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeUser();
    _getShoes = ShoeFirestoreService().getAvailableShoes();
  }

  Future<void> initializeUser() async {
    uid = AuthService.firebase().currentUser?.uid ?? "";
    getUser = UserFirestoreService().getUser(uid);
    user = (await getUser)!;
  }

  void _toggleSelected(String shoeId) async {
    if (user.id != "") {
      if (user.favShoes.contains(shoeId)) {
        await UserFirestoreService().removeFromFavorites(user.id, shoeId);
      } else {
        await UserFirestoreService().addToFavorites(user.id, shoeId);
      }
    }

    await initializeUser();
    setState(() {});
  }

  void _openColorFilterScreen() {
    // Open color filter screen or prompt user for color selection
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Color Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: colorOptions.map((color) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _selectedColor == color
                      ? _getColorFromName(color)
                      : Colors.transparent,
                  child: Icon(
                    Icons.check,
                    color: _selectedColor == color ? Colors.white : Colors.grey,
                  ),
                ),
                title: Text(
                  color,
                ),
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openPriceFilterScreen() {
    // Open price filter screen or prompt user for price range selection
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Price Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: priceOptions.map((price) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _selectedPrice == price
                      ? Colors.grey
                      : Colors.transparent,
                  child: Icon(
                    Icons.check,
                    color: _selectedPrice == price ? Colors.white : Colors.grey,
                  ),
                ),
                title: Text(price),
                onTap: () {
                  setState(() {
                    _selectedPrice = price;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuthProvider().logOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (route) => false);
          },
        ),
        actions: <Widget>[
          if (_selectedFilter != "none")
            IconButton(
              icon: const Icon(Icons.filter_list_off),
              onPressed: () {
                setState(() {
                  _selectedFilter = 'none';
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Apply Filter'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Color Filter'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'color';
                            });
                            Navigator.of(context).pop();
                            _openColorFilterScreen();
                          },
                        ),
                        ListTile(
                          title: const Text('Price Filter'),
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'price';
                            });
                            Navigator.of(context).pop();
                            _openPriceFilterScreen();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Welcome to SuSha!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder<List<Shoe>>(
              future: _getShoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final List<Shoe>? shoes = snapshot.data;
                if (shoes == null || shoes.isEmpty) {
                  return const Center(
                    child: Text('No available shoes.'),
                  );
                }

                List<Shoe> filteredShoes = shoes;

                if (_selectedFilter == 'none') {
                  // dont filter them
                } else if (_selectedFilter == 'color' &&
                    _selectedColor != null) {
                  filteredShoes = filteredShoes
                      .where((shoe) => shoe.color == _selectedColor)
                      .toList();
                } else if (_selectedFilter == 'price' &&
                    _selectedPrice != null) {
                  switch (_selectedPrice) {
                    case 'Less than Rs. 3000':
                      filteredShoes = filteredShoes
                          .where((shoe) => double.parse(shoe.price) < 3000)
                          .toList();
                      break;
                    case 'Rs. 3000 - Rs. 5000':
                      filteredShoes = filteredShoes
                          .where((shoe) =>
                              double.parse(shoe.price) >= 3000 &&
                              double.parse(shoe.price) <= 5000)
                          .toList();
                      break;
                    case 'Rs. 5000 - Rs. 10000':
                      filteredShoes = filteredShoes
                          .where((shoe) =>
                              double.parse(shoe.price) >= 5000 &&
                              double.parse(shoe.price) <= 10000)
                          .toList();
                      break;
                    case 'Greater than Rs. 10000':
                      filteredShoes = filteredShoes
                          .where((shoe) => double.parse(shoe.price) > 10000)
                          .toList();
                      break;
                  }
                }

                return GridView.count(
                  crossAxisCount: 2, // Number of columns
                  children: List.generate(filteredShoes.length, (index) {
                    final shoe = filteredShoes[index];
                    final isSelected = user.favShoes.contains(shoe.productId);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          itemInfo,
                          arguments: shoe.productId,
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'logotag2',
                                child: Image.network(shoe.imageUrl),
                              ),
                            ),
                            ListTile(
                              title: Text(shoe.model),
                              subtitle: Text(
                                shoe.description,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isSelected
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isSelected ? Colors.red : null,
                                ),
                                onPressed: () {
                                  _toggleSelected(shoe.productId);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
