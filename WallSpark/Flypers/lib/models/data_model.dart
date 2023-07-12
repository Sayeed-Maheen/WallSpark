class Data {
  Data({
    required this.imageId,
    required this.imageUrl,
    required this.thumbUrl,
    required this.color,
    required this.artistName,
    required this.tag,
    required this.viewCount
  });

  Data.fromJson(Map<String, Object?> json)
      : this(
    imageId: json['imageId']! as String,
    imageUrl: json['imageUrl']! as String,
    thumbUrl: json['thumbUrl']! as String,
    color: json['color']! as String,
    artistName: json['artistName']! as String,
    tag: json['tag']! as String,
    viewCount: json['viewCount']! as int,
  );

  final String imageId;
  final String imageUrl;
  final String thumbUrl;
  final String color;
  final String artistName;
  final String tag;
  final int viewCount;

  Map<String, Object?> toJson() {
    return {
      'imageUrl': imageUrl,
      'thumbUrl': thumbUrl,
      'color': color,
      'artistName': artistName,
      'tag': tag,
      'viewCount': viewCount,
    };
  }
}



class CategoryData {
  CategoryData({

    required this.imageUrl,
    required this.name,
  });

  CategoryData.fromJson(Map<String, Object?> json)
      : this(
    imageUrl: json['imageUrl']! as String,
    name: json['name']! as String,
  );

  final String imageUrl;
  final String name;

  Map<String, Object?> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
    };
  }
}


class BannerData {
  BannerData({
    required this.url,
  });

  BannerData.fromJson(Map<String, Object?> json)
      : this(
    url: json['url']! as String,
  );

  final String url;

  Map<String, Object?> toJson() {
    return {
      'url': url,
    };
  }
}



