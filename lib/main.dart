import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(PictionaryWordGenerator());

class PictionaryWordGenerator extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Pictioanry Word Generator',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData
        (
        primaryColor: Colors.pink,
      ),
      home: GenWords(),
    );
  }
}

class GenTokenState extends State<GenWords>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pictionary Word Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  final _biggerfont = const TextStyle(fontSize: 18.0);
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),

        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
          pair.asPascalCase,
          style:_biggerfont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );

  }
  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerfont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile
            .divideTiles(
          context: context,
          tiles: tiles,
        )
            .toList();
        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Saved words'),
          ),
          body: new ListView(children: divided),
        );
      },
    ),
    );
  }
}
class GenWords extends StatefulWidget
{
  @override
  GenTokenState createState() => new GenTokenState();
} 