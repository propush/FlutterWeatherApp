import 'dart:convert';

import 'package:weather_app/base/repository/base_network_repository.dart';
import 'package:weather_app/weather/exception/weather_exception.dart';
import 'package:weather_app/weather/vo/city_vo.dart';
import 'package:weather_app/weather/vo/weather_vo.dart';

class WeatherRepository extends BaseNetworkRepository {
  static const cityFetchLimit = 10;

  Future<CurrentWeatherVO> fetchCurrentWeather(String location) async {
    print('Getting weather for $location');
    final uri = Uri.parse(Uri.encodeFull(
        '${BaseNetworkRepository.baseUrl}/data/2.5/weather?q=$location&units=metric&appid=${BaseNetworkRepository.apiKey}'));
    print('URI: $uri');
    final response = await client.get(uri, headers: headers);
    checkResponseOrThrow(
        response,
        () => WeatherErrorFetchingException(
            message:
                'Bad response received from ${BaseNetworkRepository.baseUrl}: ${response.body}'));
    return CurrentWeatherVO.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<List<CityVO>> fetchLocations(String location) async {
    print('Getting cities for $location');
    final uri = Uri.parse(Uri.encodeFull(
        '${BaseNetworkRepository.baseUrl}/geo/1.0/direct?q=$location&limit=${WeatherRepository.cityFetchLimit}&appid=${BaseNetworkRepository.apiKey}'));
    print('URI: $uri');
    final response = await client.get(uri, headers: headers);
    checkResponseOrThrow(
        response,
        () => WeatherErrorFetchingException(
            message:
                'Bad response received from ${BaseNetworkRepository.baseUrl}: ${response.body}'));
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
        .map((e) => CityVO.fromJson(e))
        .toList(growable: false);
  }
}

class StubWeatherRepository extends WeatherRepository {
  static const cityFetchLimit = 10;

  @override
  Future<CurrentWeatherVO> fetchCurrentWeather(String location) async {
    print('Getting weather for $location');
    await Future.delayed(const Duration(seconds: 3));
    return CurrentWeatherVO.fromJson(jsonDecode(
        '{"coord":{"lon":-0.1257,"lat":51.5085},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"base":"stations","main":{"temp":280.34,"feels_like":275.45,"temp_min":278.87,"temp_max":281.21,"pressure":1000,"humidity":51},"visibility":10000,"wind":{"speed":10.8,"deg":260,"gust":18.52},"clouds":{"all":68},"dt":1645205783,"sys":{"type":2,"id":2019646,"country":"GB","sunrise":1645168144,"sunset":1645204807},"timezone":0,"id":2643743,"name":"$location","cod":200}'));
  }

  @override
  Future<List<CityVO>> fetchLocations(String location) async {
    print('Getting cities for $location');
    await Future.delayed(const Duration(seconds: 3));
    return (jsonDecode(
                '[{"name":"Moscow","local_names":{"so":"Moskow","pl":"Moskwa","kk":"Мәскеу","cs":"Moskva","fa":"مسکو","nn":"Moskva","hi":"मास्को","vo":"Moskva","sc":"Mosca","ht":"Moskou","eu":"Mosku","fi":"Moskova","lg":"Moosko","uk":"Москва","tl":"Moscow","br":"Moskov","yo":"Mọsko","mg":"Moskva","ru":"Москва","ce":"Москох","et":"Moskva","az":"Moskva","yi":"מאסקווע","ak":"Moscow","am":"ሞስኮ","sq":"Moska","zu":"IMoskwa","gn":"Mosku","io":"Moskva","cv":"Мускав","gv":"Moscow","st":"Moscow","ro":"Moscova","tg":"Маскав","tk":"Moskwa","cy":"Moscfa","en":"Moscow","mr":"मॉस्को","pt":"Moscou","te":"మాస్కో","wa":"Moscou","ps":"مسکو","eo":"Moskvo","se":"Moskva","jv":"Moskwa","na":"Moscow","bn":"মস্কো","sg":"Moscow","bg":"Москва","mt":"Moska","cu":"Москъва","el":"Μόσχα","wo":"Mosku","tt":"Мәскәү","bi":"Moskow","av":"Москва","fr":"Moscou","ml":"മോസ്കോ","lt":"Maskva","sv":"Moskva","ia":"Moscova","kw":"Moskva","dz":"མོསི་ཀོ","feature_name":"Moscow","is":"Moskva","gl":"Moscova - Москва","hy":"Մոսկվա","nb":"Moskva","fy":"Moskou","de":"Moskau","hu":"Moszkva","li":"Moskou","sl":"Moskva","hr":"Moskva","ur":"ماسکو","fo":"Moskva","ku":"Moskow","sk":"Moskva","os":"Мæскуы","ty":"Moscou","id":"Moskwa","mk":"Москва","my":"မော်စကိုမြို့","be":"Масква","no":"Moskva","da":"Moskva","za":"Moscow","it":"Mosca","ta":"மாஸ்கோ","ch":"Moscow","mn":"Москва","ca":"Moscou","ba":"Мәскәү","bs":"Moskva","an":"Moscú","gd":"Moscobha","ab":"Москва","ms":"Moscow","tr":"Moskova","ko":"모스크바","ln":"Moskú","ascii":"Moscow","ss":"Moscow","ky":"Москва","iu":"ᒨᔅᑯ","es":"Moscú","ug":"Moskwa","kv":"Мӧскуа","oc":"Moscòu","vi":"Mát-xcơ-va","uz":"Moskva","nl":"Moskou","kn":"ಮಾಸ್ಕೋ","co":"Moscù","mi":"Mohikau","he":"מוסקווה","sw":"Moscow","ar":"موسكو","ka":"მოსკოვი","ie":"Moskwa","la":"Moscua","ga":"Moscó","dv":"މޮސްކޯ","su":"Moskwa","th":"มอสโก","zh":"莫斯科","lv":"Maskava","kl":"Moskva","ja":"モスクワ","sm":"Moscow","ay":"Mosku","kg":"Moskva","qu":"Moskwa","af":"Moskou","bo":"མོ་སི་ཁོ།","sr":"Москва","sh":"Moskva"},"lat":55.7504461,"lon":37.6174943,"country":"RU","state":"Moscow"},{"name":"Moscow","local_names":{"ru":"Москва","en":"Moscow"},"lat":46.7323875,"lon":-117.0001651,"country":"US","state":"Idaho"},{"name":"Moscow","lat":45.071096,"lon":-69.891586,"country":"US","state":"Maine"},{"name":"Moscow","lat":35.0619984,"lon":-89.4039612,"country":"US","state":"Tennessee"},{"name":"Moscow","lat":39.5437014,"lon":-79.0050273,"country":"US","state":"Maryland"}]')
            as List)
        .map((e) => CityVO.fromJson(e))
        .toList(growable: false);
  }
}
