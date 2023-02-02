import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
String imageUrl(String path)=>'$baseImageUrl$path';

class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  List pop = [];
  int page = 1;
  ScrollController scrollController = ScrollController();
  bool isLoadMore = false;

  Future<void> fetchData() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=740ca5e7fc5fd2770595d34f1ec7ca74&page=$page');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['results'] as List;
      setState(() {
        pop.addAll(json);
      });
    }
  }

  @override
  void initState() {
    fetchData();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        page++;
        await fetchData();

        setState(() {
          isLoadMore = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.count(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1 / 2.2,
                crossAxisSpacing: 5,
                crossAxisCount: 2,
                children: List.generate(
                  isLoadMore ? pop.length+2 : pop.length,
                      (index){
                    if(index >= pop.length)
                    {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else
                    {
                      return Column(
                        children: [
                          Container(
                            width: 300.0,
                            height: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    imageUrl(pop[index]['poster_path'].toString())
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            pop[index]['overview'].toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Colors.white
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

