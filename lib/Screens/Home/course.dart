///This class is a structure holding data connected with a course.
class Course {
  ///The Unique Course id
  int id;

  ///The Course code.
  String code;

  ///Name of the Course.
  String name;

  ///The constructor of the course object.
  Course(this.name, this.code);

  ///Function to facilitate easy generation of a course.
  Course.generate(this.id, this.name, this.code);

  ///Provides a method to get data in class from Json Format.
  factory Course.fromJson(dynamic json) {
    return Course.generate(
        json["id"] as int, json["name"] as String, json["code"] as String);
  }
}
