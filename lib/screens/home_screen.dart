import 'package:flutter/material.dart';
import 'package:webtoon_flutter_app/models/webtoon_model.dart';
import 'package:webtoon_flutter_app/services/api_service.dart';
import 'package:webtoon_flutter_app/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.green,
        title: const Text(
          "오늘의 툰s",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var webtoon = snapshot.data![index];
                      return Webtoon(
                        title: webtoon.title,
                        thumb: webtoon.thumb,
                        id: webtoon.id,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 40,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
