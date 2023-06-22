

class MeetingDetail {
  String ? id;
  String ? hostId;
  String ? hostName;

  MeetingDetail({this.id, this.hostId, this.hostName});

  MeetingDetail.fromJson(dynamic json){
    id = json["id"];
    hostId = json["hostId"];
    hostName = json["hostName"];
  }
}