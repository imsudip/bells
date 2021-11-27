import 'dart:convert';
import 'dart:developer';

//import 'package:api_utils/api_utils.dart';
import 'package:bells/business/ringtone.dart';
import 'package:http/http.dart' as http;
import 'package:bells/business/ResponseModel.dart';

class Endpoints {
  static String url = "https://api-gateway.zedge.net/";
  static String trending(int page) {
    //page = (page - 1) * 48;
    var query = {
      "query":
          r"   query browse($input: BrowseAsUgcInput!) {      browseAsUgc(input: $input) {      ...browseContentItemsResource      }   }     fragment browseContentItemsResource on BrowseContentItems {    page    total    items {      ... on BrowseWallpaper {      id      contentType      title      description      tags      imageUrl      placeholderUrl      shareUrl      downloadCount      dateUploaded      licensed      profile {        avatarIconUrl        id        name        shareUrl      }    }    ... on BrowseRingtone {      id      contentType      title      description      tags      imageUrl      placeholderUrl      shareUrl      downloadCount      dateUploaded      licensed      profile {        avatarIconUrl        id        name        shareUrl      }      meta {        durationMs        previewUrl        gradientStart        gradientEnd      }      }    }  }  ",
      "variables": {
        "input": {
          "contentType": "RINGTONE",
          "page": page,
          "size": 24,
        }
      }
    };
    return json.encode(query);
  }

  static String searchWithQuery(String query, int page) {
    var queryMap = {
      "query":
          r"    query search($input: SearchAsUgcInput!) {      searchAsUgc(input: $input) {        ...browseContentItemsResource      }    }      fragment browseContentItemsResource on BrowseContentItems {    page    total    items {      ... on BrowseWallpaper {      id      contentType      title      description      tags      imageUrl      placeholderUrl      shareUrl      downloadCount      dateUploaded      licensed      profile {        avatarIconUrl        id        name        shareUrl      }    }    ... on BrowseRingtone {      id      contentType      title      description      tags      imageUrl      placeholderUrl      shareUrl      downloadCount      dateUploaded      licensed      profile {        avatarIconUrl        id        name        shareUrl      }      meta {        durationMs        previewUrl        gradientStart        gradientEnd      }      }    }  }  ",
      "variables": {
        "input": {
          "contentType": "RINGTONE",
          "keyword": query,
          "page": page,
          "size": 24
        }
      }
    };
    return json.encode(queryMap);
  }
}

var headers = {
  'Accept':
      "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
  "Accept-Encoding": "gzip, deflate, br",
  'Accept-Language': "en-US,en;q=0.5",
  'Host': "www.zedge.net",
  'User-Agent':
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0"
};

class RingtoneService {
  static Future<List<RingtoneModel>> getTrending(int page) async {
    print(Endpoints.trending(page));
    var response = await http.post(Endpoints.url,
        headers: {"Content-Type": "application/json"},
        body: Endpoints.trending(page));
    log(response.body);
    if (response.statusCode == 200)
      return (json.decode(response.body)["data"]["browseAsUgc"]["items"]
              as List)
          .map((i) => RingtoneModel.fromJson(i))
          .toList();
    else
      return [];
  }

  static Future<List<RingtoneModel>> getResults(String query, int page) async {
    var response = await http.post(Endpoints.url,
        headers: {"Content-Type": "application/json"},
        body: Endpoints.searchWithQuery(query, page));
    if (response.statusCode == 200)
      return (json.decode(response.body)["data"]["searchAsUgc"]["items"]
              as List)
          .map((i) => RingtoneModel.fromJson(i))
          .toList();
    else
      return [];
  }
}
