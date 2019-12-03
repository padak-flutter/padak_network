import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'model/data/dummys_repository.dart';
import 'model/response/movies_response.dart';

class ListPage extends StatelessWidget {
  // 2-2. 메인화면 - 변수 선언 및 생성자 parameter 로직 반영
  final List<Movie> movies;
  ListPage(this.movies);

  @override
  Widget build(BuildContext context) {
    // 2-2. 메인화면 - 리스트 화면 주석처리
    // final List<Movie> movies = DummysRepository.loadDummyMovies();

    return ListView.separated(
      separatorBuilder: (_, index) => Divider(color: Colors.grey),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: _buildItem(movies[index]),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailPage(movies[index].id),
              ),
            );
          },
        );

      },
    );
  }

  Widget _buildDummyItem() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
              'http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg',
              height: 120),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '신과함께-죄와벌',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    _buildGradeImage(12),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text('평점 : 139'),
                    SizedBox(width: 10),
                    Text('예매순위 : 1'),
                    SizedBox(width: 10),
                    Text('예매율 : 35.5')
                  ],
                ),
                SizedBox(height: 10),
                Text('개봉일 : 2017-12-20')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Movie movie) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
              movie.thumb,
              height: 120),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    _buildGradeImage(movie.grade),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text('평점 : ${movie.userRating / 2}'),
                    SizedBox(width: 10),
                    Text('예매순위 : ${movie.reservationGrade}'),
                    SizedBox(width: 10),
                    Text('예매율 : ${movie.reservationRate}')
                  ],
                ),
                SizedBox(height: 10),
                Text('개봉일 : ${movie.date}')
              ],
            ),
          )
        ],
      ),
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
