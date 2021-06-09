///This class is a structure holding data connected with a message.
class Message {
  ///The id of the Message
  int id;

  ///Indicates if the message is sent or not
  String sent;

  ///The text of the message
  String message;

  ///Indicates if the message is to be sent to TAs or Students
  String to;

  ///Id of the course to which the message concerns
  int course;

  ///The Id of User who sent the message
  int by;

  ///List of ids of users who read the message
  List<int> read_by;

  ///The Name of User who sent the message
  String from_username;

  ///Indicates If the message is sent by professor or TA
  bool is_proffessor;

  ///Name of the course the message is associated with
  String course_name;

  ///The Constructor of a Message
  Message({
    this.id,
    this.sent,
    this.message,
    this.to,
    this.course,
    this.by,
    this.read_by,
    this.from_username,
    this.is_proffessor,
    this.course_name,
  });

  ///Function to facilitate generating a message
  Message.generate(
    this.id,
    this.sent,
    this.message,
    this.to,
    this.course,
    this.by,
    this.read_by,
    this.from_username,
    this.is_proffessor,
    this.course_name,
  );

  ///Provides method to get data in class from Json Format.
  factory Message.fromJson(dynamic json) {
    return Message.generate(
      json["id"] as int,
      json["sent"] as String,
      json["message"] as String,
      json["to"] as String,
      json["course"] as int,
      json["by"] as int,
      json["read_by"].cast<int>() as List<int>,
      json["from_username"] as String,
      json["is_professor"] as bool,
      json["course_name"] as String,
    );
  }
}
