class ChatModel {
  int? userId;
  String? messageId;
  String? message;
  String? sendTime;
  bool? seenStatus;
  ChatModel({
    this.userId,
    this.message,
    this.sendTime,
    this.seenStatus,
    this.messageId,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        messageId = json['messageId'],
        message = json['message'],
        sendTime = json['sendTime'],
        seenStatus = json['seenStatus'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'messageId': messageId,
        'message': message,
        'sendTime': sendTime,
        'seenStatus': seenStatus,
      };
}
