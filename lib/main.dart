import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Card Game Homework 3'),
    );
  }
}

// Class exists to show card's state
class CardModel {
  final String frontOfCard;
  final String backOfCard;
  bool isFaceUp;
  bool areMatched;

  CardModel({
    required this.frontOfCard,
    required this.backOfCard,
    this.isFaceUp = false,
    this.areMatched = false,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
late List<AnimationController> controlFlipAnimation;
List<CardModel> cardDeck = [];
List<int> flippedCards = [];

@override
  void initState() {
    super.initState();
    inicializeAllcardDeck();
    controlFlipAnimation = List.generate(cardDeck.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

 @override
  void dispose() {
    for (var controller in controlFlipAnimation) {
      controller.dispose();
    }
    super.dispose();
  }

 void inicializeAllcardDeck() {
    List<String> frontOfCards = [
      '10_of_diamonds.png',
      '5_of_clubs.png',
      '8_of_clubs.png',
      'queen_of_diamonds.png',
      '2_of_diamonds.png',
      '2_of_clubs.png',
      'jack_of_diamonds.png',
      '10_of_hearts.png',
    ];

    cardDeck = List.generate(16, (index) {
      return CardModel(
        frontOfCard: frontOfCards[index % frontOfCards.length],
        backOfCard: 'back.png',
      );
    });
    cardDeck.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

      ),
    );
  }
}
