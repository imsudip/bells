// To parse this JSON data, do
//
//     final ringtoneModel = ringtoneModelFromJson(jsonString);

import 'dart:convert';

List<RingtoneModel> ringtoneModelFromJson(String str) =>
    List<RingtoneModel>.from(
        json.decode(str).map((x) => RingtoneModel.fromJson(x)));

String ringtoneModelToJson(List<RingtoneModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RingtoneModel {
  RingtoneModel({
    this.id,
    this.contentType,
    this.title,
    this.description,
    this.tags,
    this.imageUrl,
    this.placeholderUrl,
    this.shareUrl,
    this.downloadCount,
    this.dateUploaded,
    this.licensed,
    this.profile,
    this.meta,
  });

  String id;
  String contentType;
  String title;
  String description;
  List<String> tags;
  String imageUrl;
  String placeholderUrl;
  String shareUrl;
  int downloadCount;
  String dateUploaded;
  bool licensed;
  Profile profile;
  Meta meta;

  factory RingtoneModel.fromJson(Map<String, dynamic> json) => RingtoneModel(
        id: json["id"],
        contentType: json["contentType"],
        title: json["title"],
        description: json["description"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        imageUrl: json["imageUrl"],
        placeholderUrl: json["placeholderUrl"],
        shareUrl: json["shareUrl"],
        downloadCount: json["downloadCount"],
        dateUploaded: json["dateUploaded"],
        licensed: json["licensed"],
        profile: Profile.fromJson(json["profile"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contentType": contentType,
        "title": title,
        "description": description,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "imageUrl": imageUrl,
        "placeholderUrl": placeholderUrl,
        "shareUrl": shareUrl,
        "downloadCount": downloadCount,
        "dateUploaded": dateUploaded,
        "licensed": licensed,
        "profile": profile.toJson(),
        "meta": meta.toJson(),
      };
}

class Meta {
  Meta({
    this.durationMs,
    this.previewUrl,
    this.gradientStart,
    this.gradientEnd,
  });

  int durationMs;
  String previewUrl;
  String gradientStart;
  String gradientEnd;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        durationMs: json["durationMs"],
        previewUrl: json["previewUrl"],
        gradientStart: json["gradientStart"],
        gradientEnd: json["gradientEnd"],
      );

  Map<String, dynamic> toJson() => {
        "durationMs": durationMs,
        "previewUrl": previewUrl,
        "gradientStart": gradientStart,
        "gradientEnd": gradientEnd,
      };
}

class Profile {
  Profile({
    this.avatarIconUrl,
    this.id,
    this.name,
    this.shareUrl,
  });

  String avatarIconUrl;
  String id;
  String name;
  String shareUrl;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        avatarIconUrl: json["avatarIconUrl"],
        id: json["id"],
        name: json["name"],
        shareUrl: json["shareUrl"],
      );

  Map<String, dynamic> toJson() => {
        "avatarIconUrl": avatarIconUrl,
        "id": id,
        "name": name,
        "shareUrl": shareUrl,
      };
}
