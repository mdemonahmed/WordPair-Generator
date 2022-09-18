import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _RandomWordsPairs = <WordPair>[];

  final _SavedWordsPairs = <WordPair>{};

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if (item.isOdd) return const Divider();
        final index = item ~/ 2;
        if (index >= _RandomWordsPairs.length) {
          _RandomWordsPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_RandomWordsPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _SavedWordsPairs.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _SavedWordsPairs.remove(pair);
          } else {
            _SavedWordsPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _SavedWordsPairs.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: _buildList(),
    );
  }
}
