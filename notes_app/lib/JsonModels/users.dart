class Users {
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final String profilepicUrl; // New attribute

  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    this.profilepicUrl = '', // Default value
  });

  // Convert Map to Users
  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["usrId"],
    usrName: json["usrName"],
    usrPassword: json["usrPassword"],
    profilepicUrl: json["profilepic_url"] ?? '', // Handle default value
  );

  // Convert Users to Map
  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usrName": usrName,
    "usrPassword": usrPassword,
    "profilepic_url": profilepicUrl, // Include new attribute
  };
}
