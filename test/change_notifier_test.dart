import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    ///The body of setUp method will run before each and every test
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test('Check initial values', () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'Title 1', content: 'Content of Test Article 1'),
      Article(title: 'Title 2', content: 'Content of Test Article 2'),
      Article(title: 'Title 3', content: 'Content of Test Article 3'),
    ];
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => articlesFromService);
    }

    test(
      'get articles using NewsService',
      () async {
        //Implementing getArticles method for mockNewsService
        // when(() => mockNewsService.getArticles())
        //     .thenAnswer((_) async => []); //arrange
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles(); //act
        verify(() => mockNewsService.getArticles()).called(1); //assert
      },
    );
    test(
      '''is loading, 
      sets articles to the ones from the service,
      stop loading''',
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future; //We await for the future only after the check
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
