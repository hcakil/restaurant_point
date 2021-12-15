import 'dart:math';

class MyUser {
  final String userID;
  String email;
  String userName;
  String profilURL;
  String interest;
  // DateTime createdAt;
  // DateTime updatedAt;
  int seviye;


  MyUser({this.userID, this.email});

  MyUser.name(
      {this.userID,
        this.email,
        this.interest,
        this.userName,
        this.profilURL,
        //  this.createdAt,
        // this.updatedAt,
        this.seviye});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName':
      userName ?? email.substring(0, email.indexOf("@")) + randomSayiUret(),
      "interest": interest ?? "0",
      'profilURL': profilURL ??
          'https://digitalpratix.com/wp-content/uploads/pexels-mentatdgt-1049622-365x365.jpg',
      //  'createdAt': createdAt ?? "",//FieldValue.serverTimestamp(),
      // 'updatedAt': updatedAt ?? "", //FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map["userID"],
        userName = map["userName"],
        email = map["email"],
        interest = map["interest"],
  //createdAt = (map["createdAt"] as Timestamp).toDate(),
  // updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        profilURL = map["profilURL"],
        seviye = map["seviye"];

  // MyUser.idVeResim({this.userID, this.profilURL});

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, interest: $interest, userName: $userName, profilURL: $profilURL,  seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
