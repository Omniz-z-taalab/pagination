import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  PaginationBloc() : super(PaginationInitial()) {
    on<PaginationEvent>((event, emit) {
      if(event is getData){
        print('ddd');
        fetchData();
        emit(PaginationSuccess());
      }    });  }

    @override
    Stream<PaginationState> mapEventToState(PaginationEvent event) async* {
      if(event is getData){
        fetchData();
        emit(PaginationSuccess());
      }
  }
  List pop = [];
  int page = 1;

  String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  String imageUrl(String path)=>'$baseImageUrl$path';

 Future<void> fetchData() async {
   print('wwqqq');
   var url = Uri.parse(
       'https://api.themoviedb.org/3/movie/popular?api_key=740ca5e7fc5fd2770595d34f1ec7ca74&page=$page');
   var response = await http.get(url);
   print('qqqqqqqq');

   if (response.statusCode == 200) {
     var json = jsonDecode(response.body)['results'] as List;
     pop.addAll(json);
     page++;
     emit(PaginationSuccess());

   }
 }
}

