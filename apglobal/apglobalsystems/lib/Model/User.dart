class User {
  String id;
  String fname;
  String lname;
  String email;
  Address address;
  int mobile;
  List<Devices> devices;
  int accessCode;
  Subscription subscription;
  String type;

  User(
      {this.id,
        this.fname,
        this.lname,
        this.email,
        this.address,
        this.mobile,
        this.devices,
        this.accessCode,
        this.subscription,
        this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    mobile = json['mobile'];
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
    accessCode = json['accessCode'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['mobile'] = this.mobile;
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    data['accessCode'] = this.accessCode;
    if (this.subscription != null) {
      data['subscription'] = this.subscription.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Address {
  String address1;
  String city;
  String state;
  String country;

  Address({this.address1, this.city, this.state, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}

class Devices {
  String device;
  String make;
  String model;
  String password;
  String year;
  String plate;
  String deviceType;
  Status status;

  Devices(
      {this.device,
        this.make,
        this.model,
        this.password,
        this.year,
        this.plate,
        this.deviceType,
        this.status});

  Devices.fromJson(Map<String, dynamic> json) {
    device = json['device'];
    make = json['make'];
    model = json['model'];
    password = json['password'];
    year = json['year'];
    plate = json['plate'];
    deviceType = json['deviceType'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device'] = this.device;
    data['make'] = this.make;
    data['model'] = this.model;
    data['password'] = this.password;
    data['year'] = this.year;
    data['plate'] = this.plate;
    data['deviceType'] = this.deviceType;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  String accident;
  String arm;
  String monitor;
  String overspeed;
  String movement;
  String power;
  String quickStop;
  String speed;

  Status(
      {this.accident,
        this.arm,
        this.monitor,
        this.overspeed,
        this.movement,
        this.power,
        this.quickStop,
        this.speed});

  Status.fromJson(Map<String, dynamic> json) {
    accident = json['accident'];
    arm = json['arm'];
    monitor = json['monitor'];
    overspeed = json['overspeed'];
    movement = json['movement'];
    power = json['power'];
    quickStop = json['quickStop'];
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accident'] = this.accident;
    data['arm'] = this.arm;
    data['monitor'] = this.monitor;
    data['overspeed'] = this.overspeed;
    data['movement'] = this.movement;
    data['power'] = this.power;
    data['quickStop'] = this.quickStop;
    data['speed'] = this.speed;
    return data;
  }
}

class Subscription {
  String paymentDate;
  String type;
  int commands;
  String expirationDate;

  Subscription(
      {this.paymentDate, this.type, this.commands, this.expirationDate});

  Subscription.fromJson(Map<String, dynamic> json) {
    paymentDate = json['paymentDate'];
    type = json['type'];
    commands = json['commands'];
    expirationDate = json['expirationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentDate'] = this.paymentDate;
    data['type'] = this.type;
    data['commands'] = this.commands;
    data['expirationDate'] = this.expirationDate;
    return data;
  }
}