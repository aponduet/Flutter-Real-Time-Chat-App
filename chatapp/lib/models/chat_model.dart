class ChatModel {
  int? userId;
  String? userName;
  String? messageId;
  String? message;
  String? sendTime;
  bool? seenStatus;
  ChatModel({
    this.userId,
    this.userName,
    this.message,
    this.sendTime,
    this.seenStatus,
    this.messageId,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        messageId = json['messageId'],
        userName = json['userName'],
        message = json['message'],
        sendTime = json['sendTime'],
        seenStatus = json['seenStatus'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'messageId': messageId,
        'message': message,
        'sendTime': sendTime,
        'seenStatus': seenStatus,
      };
}
