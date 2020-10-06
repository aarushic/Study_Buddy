import 'package:Study_Buddy/bloc/search/bloc.dart';
import 'package:Study_Buddy/models/user.dart';
import 'package:Study_Buddy/repositories/searchRepository.dart';
import 'package:Study_Buddy/ui/widgets/iconWidget.dart';
import 'package:Study_Buddy/ui/widgets/profile.dart';
import 'package:Study_Buddy/ui/widgets/userGender.dart';
import 'package:Study_Buddy/ui/widgets/userSubject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    //Position position = await Geolocator().getCurrentPosition();

    double location = await Geolocator().distanceBetween(37.785834,
        -122.406417, 37.785834, -122.406417);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(widget.userId),
          );
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          getDifference(_user.location);
          if (_user.location == null) {
            return Text(
              "No One Here",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          } else
            return profileWidget(
              padding: size.height * 0.04,
              photoHeight: size.height * 0.824,
              photoWidth: size.width * 0.95,
              photo: _user.photo,
              clipRadius: size.height * 0.04,
              containerHeight: size.height * 0.3,
              containerWidth: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: <Widget>[
                        
                        Expanded(
                          child: Text(
                            " " +
                                _user.name +
                                ", " +
                                _user.gender,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.05),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        userSubject(_user.subject),
                        Text(
                           " " +
                                _user.subject,
                                
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.04),
                        )
                      ],
                    ),
          
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          difference != null
                              ? (difference / 1000).floor().toString() +
                                  " km away"
                              : "0 away",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        iconWidget(EvaIcons.swapOutline, () {}, size.height * 0.04,
                            Colors.white),
                        iconWidget(Icons.clear, () {
                          _searchBloc
                              .add(PassUserEvent(widget.userId, _user.uid));
                        }, size.height * 0.08, Colors.yellow[300]),
                        iconWidget(FontAwesomeIcons.heart, () {
                          _searchBloc.add(
                            SelectUserEvent(
                                _currentUser.name,
                                _currentUser.photo,
                                widget.userId,
                                _user.uid),
                          );
                        }, size.height * 0.06, Colors.red[400]),
                        iconWidget(EvaIcons.options2, () {}, size.height * 0.04,
                            Colors.white)
                      ],
                    )
                  ],
                ),
              ),
            );
        } else
          return Container();
      },
    );
  }
}