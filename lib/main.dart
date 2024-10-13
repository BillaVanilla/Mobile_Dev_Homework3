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

void flipCards(int index) {
    if (flippedCards.length < 2 && !cardDeck[index].isFaceUp && !cardDeck[index].areMatched) {
      setState(() {
        cardDeck[index].isFaceUp = true;
        flippedCards.add(index);
        controlFlipAnimation[index].forward(); // Animate card flip
      });

      if (flippedCards.length == 2) {
        checkIfMatched();
      }
    }
  }

  void checkIfMatched() async {
    await Future.delayed(const Duration(seconds: 1));

    if (cardDeck[flippedCards[0]].frontOfCard == cardDeck[flippedCards[1]].frontOfCard) {
      setState(() {
        cardDeck[flippedCards[0]].areMatched = true;
        cardDeck[flippedCards[1]].areMatched = true;
      });
    } else {
      setState(() {
        cardDeck[flippedCards[0]].isFaceUp = false;
        cardDeck[flippedCards[1]].isFaceUp = false;

        // Reverse the flip animation
        controlFlipAnimation[flippedCards[0]].reverse();
        controlFlipAnimation[flippedCards[1]].reverse();
      });
    }

    setState(() {
      flippedCards.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 5,
          ),
                    itemCount: cardDeck.length,
                     itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                flipCards(index);
              },
               child: AnimatedBuilder(
                animation: controlFlipAnimation[index],
                 builder: (context, child) {
                   final isCardFlipped = controlFlipAnimation[index].value >= 0.5;
                   return Transform(
                     transform: Matrix4.rotationY(controlFlipAnimation[index].value * 3.14),
                    alignment: Alignment.center,
                    child: isCardFlipped
                        ? buildCardFront(index)
                        : buildCardBack(index),
                   );
                 },
               ),
              );
            },
        ),
      ),
    );
  }

 Widget buildCardFront(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(cardDeck[index].frontOfCard),
          fit: BoxFit.fitHeight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget buildCardBack(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(cardDeck[index].backOfCard),
          fit: BoxFit.fitHeight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
