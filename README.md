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
