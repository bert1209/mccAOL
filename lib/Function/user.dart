class user {
  String UserID;
  String Username;
  String Email;
  String Password;
  int Role;
  int UserMoney;
  String token;

  user({
    required this.UserID,
    required this.Username,
    required this.Email,
    required this.Password,
    required this.Role,
    required this.UserMoney,
    required this.token,
  });

  factory user.fromJson(Map<String, dynamic> json) => user(
        UserID: json["UserID"].toString(),
        Username: json["Username"].toString(),
        Email: json["Email"].toString(),
        Password: json["Password"].toString(),
        Role: json["Role"] as int,
        UserMoney: json["UserMoney"] as int,
        token: json["token"].toString(),
      );
}

class banboo {
  int BanbooID;
  String BanbooName;
  int BanbooHP;
  int BanbooATK;
  int BanbooDEF;
  int BanbooImpact;
  int BanbooCRate;
  int BanbooCDmg;
  int BanbooPRatio;
  int BanbooAMastery;
  String BanbooRank;
  String BanbooImage;
  String BanbooDescription;
  int BanbooPrice;
  int BanbooLevel;
  int ElementID;
  String Element;

  banboo({
    required this.BanbooID,
    required this.BanbooName,
    required this.BanbooHP,
    required this.BanbooATK,
    required this.BanbooDEF,
    required this.BanbooImpact,
    required this.BanbooCRate,
    required this.BanbooCDmg,
    required this.BanbooPRatio,
    required this.BanbooAMastery,
    required this.BanbooRank,
    required this.BanbooImage,
    required this.BanbooDescription,
    required this.BanbooPrice,
    required this.BanbooLevel,
    required this.ElementID,
    required this.Element,
  });
  factory banboo.fromJson(Map<String, dynamic> json) => banboo(
        BanbooID: json["BanbooID"] as int,
        BanbooName: json["BanbooName"].toString(),
        BanbooHP: json["BanbooHP"] as int,
        BanbooATK: json["BanbooATK"] as int,
        BanbooDEF: json["BanbooDEF"] as int,
        BanbooImpact: json["BanbooImpact"] as int,
        BanbooCRate: json["BanbooCRate"] as int,
        BanbooCDmg: json["BanbooCDmg"] as int,
        BanbooPRatio: json["BanbooPRatio"] as int,
        BanbooAMastery: json["BanbooAMastery"] as int,
        BanbooRank: json["BanbooRank"].toString(),
        BanbooImage: json["BanbooImage"].toString(),
        BanbooDescription: json["BanbooDescription"].toString(),
        BanbooPrice: json["BanbooPrice"] as int,
        BanbooLevel: json["BanbooLevel"] as int,
        ElementID: json["ElementID"] as int,
        Element: json["Element"].toString(),
      );
}
