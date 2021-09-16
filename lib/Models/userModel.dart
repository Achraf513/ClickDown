class CustomUserFields {
  static final String id = "id";
  static final String username = "username";
  static final String email = "email";
  static final String picUrl = "picUrl";
}

class CustomUser {
  final String? id;
  final String username;
  final String email;
  final String picUrl;
  CustomUser({
    this.id,
    required this.username,
    required this.email,
    required this.picUrl,
  });

  Map<String, Object?> toJSON() {
    return {
      CustomUserFields.id: id,
      CustomUserFields.username: username,
      CustomUserFields.email: email,
      CustomUserFields.picUrl: picUrl,
    };
  }

  static CustomUser fromJson(Map<String, Object?> json) => CustomUser(
    id: json[CustomUserFields.id] as String?,
    username: json[CustomUserFields.username] as String,
    email: json[CustomUserFields.email] as String,
    picUrl: json[CustomUserFields.picUrl] as String,
  );

  CustomUser copy({
    String? id,
    String? username,
    String? email,
    String? picUrl,
  }) => CustomUser(
    id : id?? this.id,
    username : username?? this.username,
    email : email?? this.email,
    picUrl : picUrl?? this.picUrl,
  );

}
