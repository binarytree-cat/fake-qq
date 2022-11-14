class User {
  String userID;
  String username;
  String password;
  String imagePath;
  User(this.userID, this.username, this.password, this.imagePath);
}

class ChatUser{
  String name;
  String imagePath;
  String lastMessage;
  ChatUser(this.name, this.imagePath, this.lastMessage);
}