// class RingtoneApiResponse {
//   List<RingtoneModel> items;
//   Null navigation;

//   RingtoneApiResponse({this.items, this.navigation});

//   RingtoneApiResponse.fromJson(Map<String, dynamic> json) {
//     if (json['items'] != null) {
//       items = new List<RingtoneModel>();
//       json['items'].forEach((v) {
//         items.add(new RingtoneModel.fromJson(v));
//       });
//     }
//     navigation = json['navigation'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.items != null) {
//       data['items'] = this.items.map((v) => v.toJson()).toList();
//     }
//     data['navigation'] = this.navigation;
//     return data;
//   }
// }

// class RingtoneModel {
//   String id;
//   String contentType;
//   int downloadCount;
//   String title;
//   List<String> tags;
//   String authorId;
//   String authorName;
//   String authorAvatarUrl;
//   String shareUrl;
//   String thumbUrl;
//   String downloadReference;
//   int size;
//   int licenseType;
//   String audioUrl;
//   Gradient gradient;
//   int durationMs;
//   String audioVisualizationUrl;

//   RingtoneModel(
//       {this.id,
//       this.contentType,
//       this.downloadCount,
//       this.title,
//       this.tags,
//       this.authorId,
//       this.authorName,
//       this.authorAvatarUrl,
//       this.shareUrl,
//       this.thumbUrl,
//       this.downloadReference,
//       this.size,
//       this.licenseType,
//       this.audioUrl,
//       this.gradient,
//       this.durationMs,
//       this.audioVisualizationUrl});

//   RingtoneModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     contentType = json['contentType'];
//     downloadCount = json['downloadCount'];
//     title = json['title'];
//     tags = json['tags'].cast<String>();
//     authorId = json['authorId'];
//     authorName = json['authorName'];
//     authorAvatarUrl = json['authorAvatarUrl'];
//     shareUrl = json['shareUrl'];
//     thumbUrl = json['thumbUrl'];
//     downloadReference = json['downloadReference'];
//     size = json['size'];
//     licenseType = json['licenseType'];
//     audioUrl = json['audioUrl'];
//     gradient = json['gradient'] != null
//         ? new Gradient.fromJson(json['gradient'])
//         : null;
//     durationMs = json['durationMs'];
//     audioVisualizationUrl = json['audioVisualizationUrl'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['contentType'] = this.contentType;
//     data['downloadCount'] = this.downloadCount;
//     data['title'] = this.title;
//     data['tags'] = this.tags;
//     data['authorId'] = this.authorId;
//     data['authorName'] = this.authorName;
//     data['authorAvatarUrl'] = this.authorAvatarUrl;
//     data['shareUrl'] = this.shareUrl;
//     data['thumbUrl'] = this.thumbUrl;
//     data['downloadReference'] = this.downloadReference;
//     data['size'] = this.size;
//     data['licenseType'] = this.licenseType;
//     data['audioUrl'] = this.audioUrl;
//     if (this.gradient != null) {
//       data['gradient'] = this.gradient.toJson();
//     }
//     data['durationMs'] = this.durationMs;
//     data['audioVisualizationUrl'] = this.audioVisualizationUrl;
//     return data;
//   }
// }

// class Gradient {
//   String startColor;
//   Null centerColor;
//   String endColor;
//   int shape;
//   Null type;
//   int angle;

//   Gradient(
//       {this.startColor,
//       this.centerColor,
//       this.endColor,
//       this.shape,
//       this.type,
//       this.angle});

//   Gradient.fromJson(Map<String, dynamic> json) {
//     startColor = json['start_color'];
//     centerColor = json['center_color'];
//     endColor = json['end_color'];
//     shape = json['shape'];
//     type = json['type'];
//     angle = json['angle'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['start_color'] = this.startColor;
//     data['center_color'] = this.centerColor;
//     data['end_color'] = this.endColor;
//     data['shape'] = this.shape;
//     data['type'] = this.type;
//     data['angle'] = this.angle;
//     return data;
//   }
// }
