//////This class is a structure holding data connected with a user
class User {
  ///Username of the user
  String username;

  ///The user_id
  int id;

  ///The Constructor
  User({
    this.id,
    this.username,
  });

  ///Function assisting in generating an instance of User.
  User.generate(
    this.id,
    this.username,
  );

  ///Provides a method to set data of the user class from Json Format.
  factory User.fromJson(dynamic json) {
    return User.generate(
      json["id"] as int,
      json["username"] as String,
    );
  }
}
