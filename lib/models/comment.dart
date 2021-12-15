class Comment {
  Comment({
    this.comment,
    this.id,
    this.placeId,
    this.photoUrl,
    this.userEmail,
    this.isApproved,

    // this.activities,
  });

  String comment;
  String id;
  String placeId;
  String photoUrl;
  String userEmail;
  String isApproved;

  //List<Activity> activities;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      comment: json["comment"],
      id: json["id"],
      userEmail: json["userEmail"],
      isApproved: json["isApproved"],
      placeId: json["placeId"],
      photoUrl: json["photoUrl"]);

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "id": id,
        "placeId": placeId,
        "userEmail": userEmail,
        "isApproved": isApproved,
        "photoUrl": photoUrl
      };
}
