import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'model/data/dummys_repository.dart';
import 'model/response/movies_response.dart';

class GridPage extends StatelessWidget {
  // 2-2. 메인화면 - 그리드 화면 주석처리
  // final List<Movie> movies = DummysRepository.loadDummyMovies();

  // 2-2. 메인화면 - 그리드 화면 변수 선언 및 생성자 parameter 로직 반영
  final List<Movie> movies;
  GridPage(this.movies);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (9 / 16),
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => _buildGridItem(context, index: index),
    );
  }

  Widget _buildGridItem(BuildContext context, {@required int index}) {
    Movie movie = movies[index];

    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Image.network(
                    movie.thumb,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: _buildGradeImage(movie.grade),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            FittedBox(
              child: Text(
                movie.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
                '${movie.reservationGrade}위(${movie.userRating}) / ${movie.reservationRate}%'),
            SizedBox(height: 8),
            Text('${movie.date}'),
          ],
        ),
      ),

      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailPage(movies[index].id),
          ),
        );
      },
    );
  }

  Widget _buildGradeImage(int grade) {
    switch (grade) {
      case 0:
        return Image.asset("assets/ic_allages.png");
      case 12:
        return Image.asset("assets/ic_12.png");
      case 15:
        return Image.asset("assets/ic_15.png");
      case 19:
        return Image.asset("assets/ic_19.png");
      default:
        return null;
    }
  }
}