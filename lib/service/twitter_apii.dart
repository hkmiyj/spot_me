import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;
import 'package:spot_me/utils/const.dart';

class twitterApi {
  String profileImage =
      "https://pbs.twimg.com/profile_images/1249514033209724928/dNSyyenG_400x400.png";

  String postImage = "";
  String description = "";

  Future twitter() async {
    final twitter = v2.TwitterApi(bearerToken: twitter_bearerToken);
    try {
      final tweets = await twitter.tweetsService
          .lookupTweets(userId: "252829706", expansions: [
        v2.TweetExpansion.authorId,
        v2.TweetExpansion.attachmentsMediaKeys,
      ], tweetFields: [
        v2.TweetField.createdAt,
        v2.TweetField.attachments,
        v2.TweetField.entities,
      ], mediaFields: [
        v2.MediaField.mediaKey,
        v2.MediaField.previewImageUrl,
        v2.MediaField.url,
        v2.MediaField.type
      ], userFields: [
        v2.UserField.username,
        v2.UserField.entities,
        v2.UserField.profileImageUrl,
        v2.UserField.url
      ]);

      //final _tweets = twitterApi.fromJson(tweets.data);
      //print(tweets.data.elementAt(1).entities);
      //print(profileImage);
      /*twits twet = twits(
        profileImage: profileImage!,
        postImage: postImage!,
        description: description);
*/
      //DateTime? dateCreated = tweets.data.elementAt(0).createdAt;
      //twitterNews(profileImage,postImage,description);
      //print(tweets.includes);
      //print(tweets.includes!.media!.elementAt(1).key);
      return tweets;

      //postImage = tweets.includes!.media!.elementAt(0).url!;
      //description = tweets.data.elementAt(0).text;
    } on v2.TwitterException catch (e) {
      print(e);
    }
  }

  getTwitNews() async {
    final tweet = await twitter();
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Center(
          child: Text(
            "News",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        for (var i = 0; i < 5; i++)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        tweet.includes!.users!.first.profileImageUrl),
                  ),
                  title: Text(tweet.includes!.users!.first.name),
                  subtitle: Text("Via Twitter"),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    tweet.data.elementAt(i).text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  width: 900,
                  height: 250.0,
                  child: Ink.image(
                    image:
                        NetworkImage(tweet.includes!.media!.elementAt(i).url!),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
      ],
    );
  }

  /*ggetTwitNews() {
    final tweet = twitter();
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
            ),
            title: Text("MetMalaysia"),
            subtitle: Text("Via Twitter"),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              tweet.data.elementAt(0).text,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 200.0,
            child: Ink.image(
              image: NetworkImage(tweet.includes!.media!.elementAt(0).url!),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }*/
}
