import 'dart:convert';

import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import 'comment_page.dart';
import 'model/data/dummys_repository.dart';
import 'model/response/comments_response.dart';
import 'model/response/movie_response.dart';
import 'model/widget/star_rating_bar.dart';

// 3-1. 상세화면 - 라이브러리 임포트
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String movieId;

  DetailPage(this.movieId);

  @override
  State<StatefulWidget> createState() {
    return _DetailState(movieId);
  }
}

class _DetailState extends State<DetailPage> {
  String movieId;
  String _movieTitle = '';
  MovieResponse _movieResponse;
  CommentsResponse _commentsResponse;

  _DetailState(String movieId){
    this.movieId = movieId;
  }

  @override
  Widget build(BuildContext context) {
    // 3-1. 상세화면 - 영화 상세 정보 더미 주석 처리
    // _movieResponse = DummysRepository.loadDummyMovie(movieId);

    // 3-2. 상세화면 - 한줄평 목록 더미 주석 처리
    // _commentsResponse = DummysRepository.loadComments(movieId);

    return Scaffold(
        appBar: AppBar(
          // 3-1. 상세화면 - title 수정
          title: Text(_movieTitle),
        ),
        body: _buildContents()
    );
  }

  // 3-1. 상세화면 - initState() 작성
  @override
  void initState() {
    super.initState();
    _requestMovie();
  }

  // 3-1. 상세화면 - 영화 상세 데이터 받아오기1
  void _requestMovie() async {
    setState(() {
      _movieResponse = null;
      // 3-2. 상세화면 - 한줄평 변수 선언
      _commentsResponse = null;
    });
    final movieResponse = await _getMovieResponse();
    // 3-2. 상세화면 - 한줄평 목록 요청
    final commentsResponse = await _getCommentsResponse();
    setState(() {
      // 3-2. 상세화면 - 한줄평 목록 갱신
      _commentsResponse = commentsResponse;
      _movieResponse = movieResponse;
      _movieTitle = movieResponse.title;
    });
  }

  // 3-1. 상세화면 - 영화 상세 데이터 받아오기2
  Future<MovieResponse> _getMovieResponse() async {
    final response = await http.get(
        'http://52.79.87.95:3003/movie?id=${widget.movieId}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final movieResponse = MovieResponse.fromJson(jsonData);
      return movieResponse;
    }
    return null;
  }

  Widget _buildContents() {
    // 3-1. 상세화면 - 영화 상세 정보 데이터가 비었을 경우에 대한 분기 처리
    Widget contentsWidget;

    if (_movieResponse == null) {
      contentsWidget = Center(child: CircularProgressIndicator());
    } else {
      contentsWidget = SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            _buildMovieSummary(),
            _buildMovieSynopsis(),
            _buildMovieCast(),
            _buildComment(),
          ],
        ),
      );
    }
    return contentsWidget;
  }

  // 3-2. 상세화면 - 영화 한줄평 목록 받아오기
  Future<CommentsResponse> _getCommentsResponse() async {
    final response =
    await http.get('http://52.79.87.95:3003/comments?movie_id=${widget.movieId}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final movieResponse = CommentsResponse.fromJson(jsonData);
      return movieResponse;
    }
    return null;
  }

  Widget _buildMovieSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.network(_movieResponse.image, height: 180),
            SizedBox(width: 10),
            _buildMovieSummaryTextColumn(),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildReservationRate(),
            _buildVerticalDivider(),
            _buildUserRating(),
            _buildVerticalDivider(),
            _buildAudience(),
          ],
        ),
      ],
    );
  }

  Widget _buildMovieSummaryTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _movieResponse.title,
          style: TextStyle(fontSize: 22),
        ),
        Text(
          '${_movieResponse.date} 개봉',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '${_movieResponse.genre} / ${_movieResponse.duration}분',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildReservationRate() {
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              '예매율',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
                '${_movieResponse.reservationGrade}위 ${_movieResponse.reservationRate.toString()}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildUserRating() {
    return Column(
      children: <Widget>[
        Text(
          '평점',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text("${_movieResponse.userRating / 2}"),
      ],
    );
  }

  Widget _buildAudience() {
    final numberFormatter = NumberFormat.decimalPattern();
    return Column(
      children: <Widget>[
        Text(
          '누적관객수',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(numberFormatter.format(_movieResponse.audience)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey,
    );
  }

  Widget _buildMovieSynopsis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '줄거리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, top: 10, bottom: 5),
          child: Text(_movieResponse.synopsis),
        ),
      ],
    );
  }

  Widget _buildMovieCast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '감독/출연',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, top: 10, bottom: 5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '감독',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(_movieResponse.director),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Text(
                    '출연',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(_movieResponse.actor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 10,
          color: Colors.grey.shade400,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '한줄평',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.create),
                color: Colors.blue,
                onPressed: () => _presentCommentPage(context),
              )
            ],
          ),
        ),
        _buildCommentListView()
      ],
    );
  }

  Widget _buildCommentListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(10.0),
      itemCount: _commentsResponse.comments.length,
      itemBuilder: (_, index) =>
          _buildItem(comment: _commentsResponse.comments[index]),
    );
  }

  Widget _buildItem({@required Comment comment}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.person_pin,
            size: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(comment.writer),
                  SizedBox(width: 5),
                  StarRatingBar(
                    rating: comment.rating,
                    isUserInteractionEnabled: false,
                    size: 20,
                  ),
                ],
              ),
              Text(_convertTimeStampToDataTime(comment.timestamp)),
              SizedBox(height: 5),
              Text(comment.contents)
            ],
          )
        ],
      ),
    );
  }

  String _convertTimeStampToDataTime(int timestamp) {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  void _presentCommentPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommentPage(
        _movieResponse.title,
        _movieResponse.id,
      ),
    ));
  }
}