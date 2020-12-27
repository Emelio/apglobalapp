class Tracking {
  double latitude;
  double longitude;
  String id;
  double speed;
  String device;

  Tracking({this.latitude, this.longitude, this.id, this.speed, this.device});

  Tracking.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
    speed = json['speed'];
    device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['id'] = this.id;
    data['speed'] = this.speed;
    data['device'] = this.device;
    return data;
  }
}