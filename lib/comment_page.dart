import 'dart:convert';

import "package:flutter/material.dart";

import 'model/response/comments_response.dart';
import 'model/widget/star_rating_bar.dart';

// 4-1. 한줄평 입력 - 라이브러리 임포트
import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  final String movieTitle;
  final String movieId;

  CommentPage(this.movieTitle, this.movieId);

  @override
  CommentPageState createState() => CommentPageState(movieTitle, movieId);
}

class CommentPageState extends State<CommentPage> {
  String movieTitle;
  String movieId;

  final scaffoldState = GlobalKey<ScaffoldState>();
  int _rating = 0;
  String _writer = "";
  String _contents = "";

  CommentPageState(String movieTitle, String movieId){
    this.movieTitle = movieTitle;
    this.movieId = movieId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('한줄평 작성'),
        actions: <Widget>[
          _buildSubmitButton(),
        ],
      ),
      body: WillPopScope(
        child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildMovieTitle(),
                  _buildUserRating(),
                  _buildHorizontalDivider(),
                  _buildNickNameInputForm(),
                  _buildCommentInputForm()
                ],
              ),
            )
        ),
        onWillPop: () {
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
      ),
    );
  }


  Widget _buildSubmitButton(){
    final sendIcon = Icon(
      Icons.send,
      color: Colors.white,
      size: 25,
    );

    return IconButton(
      icon: sendIcon,
      onPressed: () {
        if (_writer.isEmpty || _contents.isEmpty) {
          _showSnackBar('모든 정보를 입력해주세요.');
        } else {
          // 4-1. 한줄평 입력 - 서버 통신 로직 진행
          _postComment();
        }
      },
    );
  }

  // 4-1. 한줄평 입력 - Post 요청 코드 작성
  void _postComment() async {
    // (DateTime.now().millisecondsSinceEpoch.toDouble() / 1000).toInt() 와 같은 말입니다.
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble() ~/ 1000;
    final commentRequest = Comment(
      rating: _rating,
      movieId: widget.movieId,
      timestamp: currentTime,
      contents: _contents,
      writer: _writer,
    );
    final response = await http.post(
        'http://52.79.87.95:3003/comment',
        headers: {"Content-Type": "application/json"},
        body: json.encode(commentRequest.toMap()));
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      _showSnackBar('잠시 후 다시 시도해주세요.');
    }
  }

  Widget _buildMovieTitle(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        widget.movieTitle,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserRating(){
    return Column(
      children: <Widget>[
        StarRatingBar(
          onRatingChanged: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        Text((_rating / 2.0).toString())
      ],
    );
  }

  Widget _buildHorizontalDivider(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      width: double.infinity,
      height: 10,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildNickNameInputForm(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onChanged: (text) => _writer = text,
        maxLines: 1,
        maxLength: 20,
        decoration: InputDecoration(
          hintText: '닉네임을 입력해주세요',
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInputForm(){
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: TextField(
        onChanged: (text) => _contents = text,
        maxLines: null,
        maxLength: 100,
        decoration: InputDecoration(
          hintText: '한줄평을 작성해주세요',
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    scaffoldState.currentState.showSnackBar(snackBar);
  }
}