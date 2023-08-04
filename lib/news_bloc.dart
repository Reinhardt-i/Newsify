// WIll define the events, states, and BLoC class in this file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'article_model.dart';

abstract class NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;

  SearchNewsEvent(this.query);
}

abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<Article> articles;

  NewsLoadedState(this.articles);
}

class NewsErrorState extends NewsState {
  final String message;

  NewsErrorState(this.message);
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is SearchNewsEvent) {
      yield NewsLoadingState();

      try {
        final articles = await _fetchNewsArticles(event.query);

        yield NewsLoadedState(articles);
      } catch (e) {
        yield NewsErrorState('Failed to load news');
      }
    }
  }

  Future<List<Article>> _fetchNewsArticles(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&apiKey=836e7db42eb24f68a30c5c5d20c42136'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Article> articles = (jsonData['articles'] as List)
          .map<Article>((data) => Article.fromJson(data))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
