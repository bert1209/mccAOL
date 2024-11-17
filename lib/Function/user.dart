class user{
  int UserID;
  String Username;
  String Email;
  String Password;
  int Role;

  user({
    required this.UserID,
    required this.Username,
    required this.Email,
    required this.Password,
    required this.Role,
});

  factory user.fromJson(Map<String, dynamic> json) => user(
    UserID: json["UserID"] as int,
    Username: json["Username"].toString(),
    Email: json["Email"].toString(),
    Password: json["Password"].toString(),
    Role: json["Role"] as int,
  );
}