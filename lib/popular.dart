import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/pagination_bloc.dart';



class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  late PaginationBloc paginationBloc;
  ScrollController scrollController = ScrollController();
  bool isLoadMore = false;

  // int page = 0;

  @override
  void initState() {
    paginationBloc = BlocProvider.of<PaginationBloc>(context);
     paginationBloc.add(getData());
print('ssss');
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        setState(() async{
           paginationBloc.page++;
          await paginationBloc.fetchData();
        });


        setState(() {
          isLoadMore = false;
        });
      }
    });
    super.initState();
  }

@override
  void dispose() {
  // scrollController.dispose();
  super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // paginationBloc.add(getData());

    return  BlocProvider(
  create: (context) => PaginationBloc(),
  child: BlocConsumer<PaginationBloc, PaginationState>(
  listener: (context, state) {
    if(state is PaginationSuccess){
      print('wwwwwwwwww');
    }
  },
  builder: (context, state) {
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
                  isLoadMore ? paginationBloc.pop.length+2 : paginationBloc.pop.length,
                      (index){
                    if(index >= paginationBloc.pop.length)
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
                                    paginationBloc.imageUrl(paginationBloc.pop[index]['poster_path'].toString())
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                        paginationBloc.pop[index]['overview'].toString(),
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
  },
),
);
  }

}

