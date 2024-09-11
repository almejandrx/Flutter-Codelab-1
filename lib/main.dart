import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  
  var favorites = <WordPair>[];
  
  void toggleFavorite(WordPair pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
  switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
      break;
    case 1:
      page = FavoritesPage();
      break;
    case 2:
      page = Placeholder();
      break;
    case 3:
      page = AboutPage();
      break;    
    default:
      throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favoritos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Configuración')
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.info),
                      label: Text('Acerca de'))
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
        
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Acerca de la aplicación',
        style: TextStyle(
          fontSize: 28,
          color: Colors.black,
          letterSpacing: 1,
        ),),
        SizedBox(height: 10),
        Text('Aplicación de prueba para el codelab 1',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          letterSpacing: 1,
        ),),
      ]
    );
  }
}

class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favoritesList = appState.favorites;
    var oneFav = 'Tienes un total de ${appState.favorites.length} palabra favorita';
    final theme = Theme.of(context);

    if(appState.favorites.isEmpty) {
      return Center(
        child: Text('Aún no hay favoritos en la lista',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 1,
          ),),
        );
    }

    else if(appState.favorites.length == 1) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(oneFav,
              style: TextStyle(
                fontSize: 20, 
                color: Colors.black,
                letterSpacing: 1,
              ),),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(favoritesList.first.asString,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: theme.primaryColor,
              ),),
              SizedBox(width: 15),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  iconColor: WidgetStatePropertyAll(Colors.red.shade300),
                  iconSize: WidgetStatePropertyAll(25),              
                ),
                onPressed: () {
                  appState.toggleFavorite(favoritesList.first);
                },
                icon: Icon(Icons.delete),
                            ),
              ),
              SizedBox(height: 30),           
          ],          
        ),
        ] ,
        );
    }

    else {
      return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Text('Tienes un total de '
          '${appState.favorites.length} palabras favoritas',
            style: TextStyle(
              fontSize: 20, 
              color: Colors.black,
              letterSpacing: 1,
            ),),
        ),
        SizedBox(height: 10),
        for (var fav in favoritesList)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(fav.asString,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: theme.primaryColor,
              ),),
              SizedBox(width: 15),
              Container(
                width: 40,
                height: 40,              
                child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  iconColor: WidgetStatePropertyAll(Colors.red.shade300),
                  iconSize: WidgetStatePropertyAll(25),              
                ),
                onPressed: () {
                  appState.toggleFavorite(fav);
                },
                icon: Icon(Icons.delete),
                            ),
              ),
              SizedBox(height: 30),           
          ],          
        ),
        
      ],
    );

    }
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!. copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}