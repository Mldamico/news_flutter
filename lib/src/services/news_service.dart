import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_provider/src/models/category_model.dart';
import 'package:news_provider/src/models/news_models.dart';
import 'package:http/http.dart' as http;

const _URL_NEWS = 'newsapi.org';
const _APIKEY = '9dcff4450fbf4dbda514e643b4a080c6';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadLines();
    categories.forEach((element) {
      this.categoryArticles[element.name] = [];
    });
  }

  get selectedCategory => this._selectedCategory;

  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    print(valor);
    this.getArticleByCategory(valor);
    this.notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadLines() async {
    final uri = Uri.https(
        _URL_NEWS, '/v2/top-headlines', {'apiKey': _APIKEY, 'country': 'ar'});
    final resp = await http.get(uri);
    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticleByCategory(String categoria) async {
    if (categoryArticles[categoria].length > 0) {
      return this.categoryArticles[categoria];
    }
    final uri = Uri.https(_URL_NEWS, '/v2/top-headlines',
        {'apiKey': _APIKEY, 'country': 'ar', 'category': categoria});
    final resp = await http.get(uri);
    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[categoria].addAll(newsResponse.articles);
    notifyListeners();
  }
}
