import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';
import '../../user/model/user_model.dart';

class TaskModel extends BaseModel {
  final String __id;
  final String _type;
  final int _date;
  final int _startTime;
  final int _endTime;
  final String _address;
  final String _distance;
  final String _stastus;
  final int _bill;
  final UserModel _user;
  final LocationModel _location;
  final int _createdTime;
  final int _updatedTime;

  TaskModel.fromJson(Map<String, dynamic> json)
      : __id = json['_id'] ?? '',
        _type = json['type'] ?? '',
        _date = json['date'],
        _startTime = json['start_time'],
        _endTime = json['end_time'],
        _address = json['address'] ?? '',
        _distance = json['distance'] ?? '',
        _stastus = json['status'] ?? '',
        _bill = json['bill'] ?? 0,
        _user = BaseModel.map<UserModel>(
          json: json,
          key: 'user',
        ),
        _location = BaseModel.map<LocationModel>(
          json: json,
          key: 'location_gps',
        ),
        _createdTime = json['created_time'],
        _updatedTime = json['updated_time'];

  Map<String, dynamic> toJson() => {
        "_id": __id,
        "type": _type,
        "date": _date,
        "start_time": _startTime,
        "estimate_time": _endTime,
        "address": _address,
        "distance": _distance,
        "status": _stastus,
        "bill": _bill,
        "user": _user.toJson(),
        "location_gps": _location.toJson(),
        "created_time": _createdTime,
        "updated_time": _updatedTime,
      };

  String get id => __id;
  String get type => _type;
  int get date => _date;
  int get startTime => _startTime;
  int get endTime => _endTime;
  String get address => _address;
  String get distance => _distance;
  String get status => _stastus;
  int get bill => _bill;
  UserModel get user => _user;
  LocationModel get location => _location;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
}

class LocationModel extends BaseModel {
  final double _lat;
  final double _long;

  LocationModel.fromJson(Map<String, dynamic> json)
      : _lat = json['lat'] ?? 0,
        _long = json['long'] ?? 0;

  Map<String, dynamic> toJson() => {
        "lat": _lat,
        "long": _long,
      };

  double get lat => _lat;
  double get long => _long;
}

class PostedUserModel extends BaseModel {
  final String __id;
  final String _name;
  final int _phoneNumber;
  final String _address;
  final String _email;

  PostedUserModel.fromJson(Map<String, dynamic> json)
      : __id = json['_id'] ?? '',
        _name = json['name'],
        _phoneNumber = json['phoneNumber'],
        _address = json['address'] ?? '',
        _email = json['email'];

  Map<String, dynamic> toJson() => {
        "_id": __id,
        "name": _name,
        "phoneNumber": _phoneNumber,
        "address": _address,
        "email": _email,
      };

  String get id => __id;
  String get name => _name;
  int get phoneNumber => _phoneNumber;
  String get address => _address;
  String get email => _email;
}

class EditTaskModel extends EditBaseModel {
  String id = ''; // For editing

  EditTaskModel.fromModel(TaskModel? model) {
    id = model?.id ?? '';
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
    };

    return params;
  }
}

class ListTaskModel extends BaseModel {
  List<TaskModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  ListTaskModel.fromJson(Map<String, dynamic> parsedJson) {
    List<TaskModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<TaskModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<TaskModel> get records => _data;
  Paging get meta => _metaData;
}
