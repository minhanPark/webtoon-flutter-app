# webtoon_flutter_app

해당 url로 api를 갖고옵니다  
https://webtoon-crawler.nomadcoders.workers.dev

## 다트에서 패키지 설치법

[pub.dev 바로가기](https://pub.dev/) 여기서 패키지 설치할 수 있음.

```cmd
flutter pub add 패키지이름
```

해당 명령어로 패키지 설치가 가능하다.  
다운 받은 패키지에 네임스페이스를 줄 수도 있다.

```dart
import 'package:http/http.dart' as http;
```

기존에는 get(url)로만 접근했는데, 네임스페이스를 통해서 http.get 으로 접근하게 된다.

> 앱의 설정등이 담겨있는 pubspec.yaml 파일을 보면 dependencies에 설치한 패키지를 볼 수 있다.

## api 통신하기

http 패키지를 설치했으면 url(타입은 Uri)을 넣어주면 통신할 수 있다.

```dart
void getTodaysToons() async {
    final url = Uri.parse('$baseUrl$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }
```

일단 통신하려면 future 타입에 대해서 알아야 하는데 자바스크립트의 프로미스와 비슷한 애다. 데이터 값을 기다릴려면 await를 사용해야하고 await를 사용하려면 async를 사용해야한다.

## screen에서 데이터를 갖고오는 기초적인 방법

```dart
class _HomeScreenState extends State<HomeScreen> {
  List<WebtoonModel> webtoons = [];
  bool isLoading = true;

  void waitForWebtoons() async {
    webtoons = await ApiService.getTodaysToons();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitForWebtoons();
  }
}
```

1. StatefullWidget으로 변경시킨다.
2. 데이터를 담을 변수와 로딩상태를 표시할 변수를 만든다.
3. 데이터를 갖고오는 함수를 만든다(내부에서 await를 사용해서 데이터를 갖고오고, 로딩상태 변경 후 setState를 실행시킨다.)
4. initState를 정의해서 거기에서 3번 함수를 실행시킨다.

> 빌드보다 먼저 initState가 실행되고, waitForWebtoons가 실행되면서 데이터를 갖고온다. 가지고 오는 동안 build가 실행되고, 데이터가 도착한 뒤 setState가 실행되면서 build가 다시 실행된다.

## FutureBuilder

stateful위젯을 사용하지 않고도 데이터를 갖고와서 넣을 수 있다.  
바로 FutureBuilder를 사용하면 된다.

```dart
Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Text('There is a data');
          }
          return const Text('Loading....');
        },
      ),
    );
  }
```

간단하게 위에 같이 webtoons를 선언하고, future에 넣어주면 된다. 그리고 builder에서 context와 snapshot을 받는데, snapshot에는 데이터가 있는지 에러가 있는 지 등 데이터, 에러, 상태 등이 담겨져 있다

## ListView

기본적인 리스트뷰는 최적화가 안되어있다고 한다.

```dart
ListView.builder(
  itemCount: webtoons.length,
  itemBuilder: (context, index) {
    return Text(webtoons[index].title);
  }
)
```

이런식으로 사용하면 index를 통해서 어디까지 갖고왔는 지도 확인할 수 있고, 사용자의 화면에 맞게 갖고올 것이다.  
강의에선 ListView.separated를 사용했는데

```dart
separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 20,
                );
}
```

얘는 각각의 아이템 사이에 위젯을 넣을 수 있다.

## 사용자의 이벤트 감지

사용자들의 이벤트를 감지하는 위젯은 GestureDetector이다.
거기에 onTap을 사용해서 사용자의 터치를 감지할 수 있다.

```dart
GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true,
          ),
        );
      }
)
```

Navigator은 새롭게 페이지처럼 만들어준다. MaterialPageRoute로 위젯을 감싸서 전달해주면 된다.
새로 페이지를 만들어주는 것이기 때문에 **기존에 들어가있던 스카폴드를 다시 만들어줘야한다.**

## Hero 위젯

애니메이션 효과를 주는 위젯으로, 같은 태그(가령 id)를 사용하면 같은 위젯이 이동하는 것처럼 느껴지게 해준다.

## arguments가 있을 때 초기화

```dart
final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
```

홈 스크린에서는 위와 같이 데이터를 불러오고 해당 데이터에 FutureBuilder를 사용해서 데이터가 있을 때와 없을 때를 나눠서 표시해줬다.  
그러나 인수가 있는 애들은 저런식으로 초기화 할 수 없다.

```dart
class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatesEpisodeById(widget.id);
  }
}
```

stateless위젯에서 stateful위젯으로 변경하면서,
late 값을 주고 initState에서 값을 넣어준다.

> stateful 위젯에서 stateless위젯의 값에는 어떻게 접근할까? widget.id 형태로 접근할 수 있다.
