// UI that interacts with the BLoC.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsBloc = BlocProvider.of<NewsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        children: [
          SearchBar(newsBloc),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsInitialState) {
                  return Center(child: Text('Enter a search query'));
                } else if (state is NewsLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NewsLoadedState) {
                  return NewsList(state.articles);
                } else if (state is NewsErrorState) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final NewsBloc newsBloc;

  SearchBar(this.newsBloc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                newsBloc.add(SearchNewsEvent(value));
              },
              decoration: InputDecoration(
                hintText: 'Search news...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // Trigger the search event
              newsBloc.add(SearchNewsEvent('Your Search Query'));
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<Article> articles;

  NewsList(this.articles);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return NewsBlock(article.title, article.description);
      },
    );
  }
}

class NewsBlock extends StatelessWidget {
  final String title;
  final String description;

  NewsBlock(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show popup page with news details
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(description),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}
