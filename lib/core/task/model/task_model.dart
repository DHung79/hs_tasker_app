import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';
import '../../service/service.dart';
import '../../tasker/tasker.dart';
import '../../user/model/user_model.dart';

class TaskModel extends BaseModel {
  final LocationModel _location;
  final UserModel _user;
  final TaskerModel _tasker;
  final ServiceModel _service;
  final String __id;
  final String _address;
  final String _estimateTime;
  final int _startTime;
  final int _endTime;
  final int _date;
  final String _note;
  final int _status;
  final int _language;
  final int _failureReason;
  final String _typeHome;
  final List<String> _checkList = [];
  final bool _isDeleted;
  final int _deletedTime;
  final int _createdTime;
  final int _updatedTime;
  final int _totalPrice;

  TaskModel.fromJson(Map<String, dynamic> json)
      : _location = BaseModel.map<LocationModel>(
          json: json,
          key: 'location_gps',
        ),
        _user = BaseModel.map<UserModel>(
          json: json,
          key: 'user',
        ),
        _tasker = BaseModel.map<TaskerModel>(
          json: json,
          key: 'tasker',
        ),
        _service = BaseModel.map<ServiceModel>(
          json: json,
          key: 'service',
        ),
        __id = json['_id'] ?? '',
        _address = json['address'] ?? '',
        _estimateTime = json['estimate_time'] ?? '',
        _startTime = json['start_time'] ?? 0,
        _endTime = json['end_time'] ?? 0,
        _date = json['date'] ?? 0,
        _note = json['note'] ?? '',
        _status = json['_status'] ?? 0,
        _language = json['language'] ?? 0,
        _failureReason = json['failure_reason'] ?? 0,
        _typeHome = json['type_home'] ?? '',
        _isDeleted = json['is_deleted'] ?? false,
        _deletedTime = json['deleted_time'] ?? 0,
        _createdTime = json['created_time'] ?? 0,
        _updatedTime = json['updated_time'] ?? 0,
        _totalPrice = json['total_price'] ?? 0 {
    if (json['check_list'] != null) {
      final jsons = json['check_list'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _checkList.add(item);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'location_gps': _location.toJson(),
        'posted_user': _user.toJson(),
        'tasker': _tasker.toJson(),
        'service': _service.toJson(),
        '_id': __id,
        'address': _address,
        'estimate_time': _estimateTime,
        'start_time': _startTime,
        'end_time': _endTime,
        'date': _date,
        'note': _note,
        'status': _status,
        'language': _language,
        'failure_reason': _failureReason,
        'type_home': _typeHome,
        'check_list': _checkList,
        'is_deleted': _isDeleted,
        'deleted_time': _deletedTime,
        'created_time': _createdTime,
        'updated_time': _updatedTime,
        'total_price': _totalPrice,
      };
  LocationModel get location => _location;
  UserModel get user => _user;
  TaskerModel get tasker => _tasker;
  ServiceModel get service => _service;
  String get id => __id;
  String get address => _address;
  String get estimateTime => _estimateTime;
  int get startTime => _startTime;
  int get endTime => _endTime;
  int get date => _date;
  String get note => _note;
  int get status => _status;
  int get language => _language;
  int get failureReason => _failureReason;
  String get typeHome => _typeHome;
  List<String> get checkList => _checkList;
  bool get isDeleted => _isDeleted;
  int get deletedTime => _deletedTime;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  int get totalPrice => _totalPrice;
}

class LocationModel extends BaseModel {
  final String _lat;
  final String _long;

  LocationModel.fromJson(Map<String, dynamic> json)
      : _lat = json['lat'] ?? '',
        _long = json['long'] ?? '';

  Map<String, dynamic> toJson() => {
        "lat": _lat,
        "long": _long,
      };

  String get lat => _lat;
  String get long => _long;
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
