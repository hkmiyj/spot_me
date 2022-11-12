class twitterApi {
  List<Data>? data;
  Includes? includes;

  twitterApi({this.data, this.includes});

  twitterApi.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    includes = json['includes'] != null
        ? new Includes.fromJson(json['includes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.includes != null) {
      data['includes'] = this.includes!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? username;
  String? location;
  Entities? entities;
  bool? verified;
  String? description;
  String? url;
  String? profileImageUrl;
  bool? protected;
  String? pinnedTweetId;
  String? createdAt;

  Data(
      {this.id,
      this.name,
      this.username,
      this.location,
      this.entities,
      this.verified,
      this.description,
      this.url,
      this.profileImageUrl,
      this.protected,
      this.pinnedTweetId,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    location = json['location'];
    entities = json['entities'] != null
        ? new Entities.fromJson(json['entities'])
        : null;
    verified = json['verified'];
    description = json['description'];
    url = json['url'];
    profileImageUrl = json['profile_image_url'];
    protected = json['protected'];
    pinnedTweetId = json['pinned_tweet_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['location'] = this.location;
    if (this.entities != null) {
      data['entities'] = this.entities!.toJson();
    }
    data['verified'] = this.verified;
    data['description'] = this.description;
    data['url'] = this.url;
    data['profile_image_url'] = this.profileImageUrl;
    data['protected'] = this.protected;
    data['pinned_tweet_id'] = this.pinnedTweetId;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Entities {
  Url? url;
  Description? description;

  Entities({this.url, this.description});

  Entities.fromJson(Map<String, dynamic> json) {
    url = json['url'] != null ? new Url.fromJson(json['url']) : null;
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.url != null) {
      data['url'] = this.url!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    return data;
  }
}

class Url {
  List<Urls>? urls;

  Url({this.urls});

  Url.fromJson(Map<String, dynamic> json) {
    if (json['urls'] != null) {
      urls = <Urls>[];
      json['urls'].forEach((v) {
        urls!.add(new Urls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.urls != null) {
      data['urls'] = this.urls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Urls {
  int? start;
  int? end;
  String? url;
  String? expandedUrl;
  String? displayUrl;

  Urls({this.start, this.end, this.url, this.expandedUrl, this.displayUrl});

  Urls.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    url = json['url'];
    expandedUrl = json['expanded_url'];
    displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['url'] = this.url;
    data['expanded_url'] = this.expandedUrl;
    data['display_url'] = this.displayUrl;
    return data;
  }
}

class Description {
  List<Hashtags>? hashtags;

  Description({this.hashtags});

  Description.fromJson(Map<String, dynamic> json) {
    if (json['hashtags'] != null) {
      hashtags = <Hashtags>[];
      json['hashtags'].forEach((v) {
        hashtags!.add(new Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hashtags != null) {
      data['hashtags'] = this.hashtags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hashtags {
  int? start;
  int? end;
  String? tag;

  Hashtags({this.start, this.end, this.tag});

  Hashtags.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['tag'] = this.tag;
    return data;
  }
}

class Includes {
  List<Tweets>? tweets;

  Includes({this.tweets});

  Includes.fromJson(Map<String, dynamic> json) {
    if (json['tweets'] != null) {
      tweets = <Tweets>[];
      json['tweets'].forEach((v) {
        tweets!.add(new Tweets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tweets != null) {
      data['tweets'] = this.tweets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tweets {
  String? id;
  String? text;

  Tweets({this.id, this.text});

  Tweets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
