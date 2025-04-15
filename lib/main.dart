// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Spoiler Alert',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var favorites = <String>[];

  void toggleFavorite(String movieUrl) {
    if (favorites.contains(movieUrl)) {
      favorites.remove(movieUrl);
    } else {
      favorites.add(movieUrl);
    }
    notifyListeners();
  }

  void removeFavorite(String movieUrl) {
    favorites.remove(movieUrl);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var selectedIndex = 0;
  bool _showTitle = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showTitle = true;
      });
    } else {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MovieGridPage(scrollController: _scrollController);
        break;
      case 1:
        page = FavoritesPage(scrollController: _scrollController);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 300),
        child: page,
      ),
    );

    return Scaffold(
      appBar: _showTitle
          ? AppBar(
              title: Text('Spoiler Alert'),
              centerTitle: true,
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.movie),
                        label: 'Movies',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.movie),
                        label: Text('Movies'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class MovieGridPage extends StatelessWidget {
  MovieGridPage({Key? key, required this.scrollController}) : super(key: key);

  final List<String> movieUrls = [
    'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    'https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZm9jYi00ZWE0LWE4NWQtMjQ2M2JiM2JlNzZmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_FMjpg_UX1000_.jpg',
    'https://m.media-amazon.com/images/I/81a6-mIEVPL._AC_UF1000,1000_QL80_.jpg',
    'https://m.media-amazon.com/images/M/MV5BMzU3YTY3NzEtNzJhZi00ZWI4LTk3NzUtMDYxZTUzZGNhNDdkXkEyXkFqcGdeQXVyMDM2NDM2MQ@@._V1_.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-x6p3mO7tJ7Q55n4X0-KjE9XpQe7jX2jK6w&usqp=CAU',
    'https://m.media-amazon.com/images/M/MV5BMjMxNjY2MDU1OV5BMl5BanBnXkEycC4wNDEyMw@@._V1_.jpg',
    'https://i.ebayimg.com/images/g/L3EAAOSwbs9i6y14/s-l1600.jpg',
    'https://upload.wikimedia.org/wikipedia/en/0/05/Up_%282009_film%29.jpg',
    'https://static.onecms.io/wp-content/uploads/sites/20/2023/07/20/the-lion-king-movie-poster.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw4IlE1kTj7_vjS-61X8MMr_eTN-3o-f2Xqw&usqp=CAU',
    'https://m.media-amazon.com/images/M/MV5BNjRmNDI5ODItN2FjZi00ZTZkLTg1MmEtMDI3ZDQ3OWU4NGJjXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg',
    'https://i.pinimg.com/736x/9f/5d/d1/9f5dd12cf1277b793263f4a33d5f01fd.jpg',
    'https://m.media-amazon.com/images/M/MV5BMDdmMTBiNzQtMDIzNi00NGZmLTkyNjEtYTVlNjQxNWNiNmZkXkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_.jpg',
    'https://i.ebayimg.com/images/g/p00AAOSw2pRh3bJ6/s-l1600.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp9h-37G8FfB0H5qU22E5k_y160Q-Zt6_yVw&usqp=CAU',
    'https://i.ytimg.com/vi/wJnUe-8N2kQ/maxresdefault.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv1l5m4K-p617m-WkX2t0g7q1M8M9Q_s4HNg&usqp=CAU',
    'https://m.media-amazon.com/images/M/MV5BMTg1MTY2MjczNV5BMl5BanBnXkFtZTgwMTk5NjIzMTI@._V1_.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1HnNgn9oQoK6T95w5H8Y5T7xJvWf3-B0oUw&usqp=CAU',
  ];

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MovieGridView(
            movieUrls: movieUrls, scrollController: scrollController),
      ),
    );
  }
}

class MovieGridView extends StatelessWidget {
  const MovieGridView(
      {super.key, required this.movieUrls, required this.scrollController});

  final List<String> movieUrls;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).size.width < 600 ? 2 : 3, // Responsive
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: movieUrls.length,
      itemBuilder: (context, index) {
        return MovieCard(movieUrl: movieUrls[index]);
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movieUrl});

  final String movieUrl;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var isFavorite = appState.favorites.contains(movieUrl);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Ink.image(
            image: NetworkImage(movieUrl),
            height: 250,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Movie Title',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      appState.toggleFavorite(movieUrl);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FavoriteMoviesGridView(
          movieUrls: appState.favorites,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class FavoriteMoviesGridView extends StatelessWidget {
  const FavoriteMoviesGridView(
      {super.key, required this.movieUrls, required this.scrollController});

  final List<String> movieUrls;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).size.width < 600 ? 2 : 3, // Responsive
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: movieUrls.length,
      itemBuilder: (context, index) {
        return MovieCard(movieUrl: movieUrls[index]);
      },
    );
  }
}