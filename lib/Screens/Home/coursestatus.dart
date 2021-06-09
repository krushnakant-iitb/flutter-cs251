///Class representing the status of a user wrt a course.
class Status {
  ///The id of the Course.
  int course;

  ///The status of a user wrt a course. (e.g. 'TA')
  String status;

  ///The Constructor
  Status(this.course, this.status);

  ///A Method for easy generation of a Status Object
  Status.generate(this.course, this.status);

  ///Provides a method to get data in the object from Json Format.
  factory Status.fromJson(dynamic json) {
    return Status.generate(
      json["course"] as int,
      json["status"] as String,
    );
  }
}
