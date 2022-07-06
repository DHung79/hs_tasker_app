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
  final int _typeHome;
  final List<ToDoModel> _checkList = [];
  final bool _isDeleted;
  final int _deletedTime;
  final int _createdTime;
  final int _updatedTime;
  final int _totalPrice;
  final List<String> _listPicturesBefore = [];
  final List<String> _listPicturesAfter = [];

  TaskModel.fromJson(Map<String, dynamic> json)
      : _location = BaseModel.map<LocationModel>(
          json: json,
          key: 'location_gps',
        ),
        _user = BaseModel.map<UserModel>(
          json: json,
          key: 'posted_user',
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
        _status = json['status'] ?? 0,
        _language = json['language'] ?? 0,
        _failureReason = json['failure_reason'] ?? 0,
        _typeHome = json['type_home'] ?? 0,
        _isDeleted = json['is_deleted'] ?? false,
        _deletedTime = json['deleted_time'] ?? 0,
        _createdTime = json['created_time'] ?? 0,
        _updatedTime = json['updated_time'] ?? 0,
        _totalPrice = json['total_price'] ?? 0 {
    _checkList.addAll(BaseModel.mapList<ToDoModel>(
      json: json,
      key: 'check_list',
    ));
    if (json['list_pictures_before'] != null) {
      final jsons = json['list_pictures_before'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _listPicturesBefore.add(item);
          }
        }
      }
    }
    if (json['list_pictures_after'] != null) {
      final jsons = json['list_pictures_after'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _listPicturesAfter.add(item);
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
        'list_pictures_before': _listPicturesBefore,
        'list_pictures_after': _listPicturesAfter,
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
  int get typeHome => _typeHome;
  List<ToDoModel> get checkList => _checkList;
  bool get isDeleted => _isDeleted;
  int get deletedTime => _deletedTime;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  int get totalPrice => _totalPrice;
  List<String> get listPicturesBefore => _listPicturesBefore;
  List<String> get listPicturesAfter => _listPicturesAfter;
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

class ToDoModel extends BaseModel {
  final String _name;
  final bool _status;

  ToDoModel.fromJson(Map<String, dynamic> json)
      : _name = json['name'] ?? '',
        _status = json['status'] ?? false;

  Map<String, dynamic> toJson() => {
        "name": _name,
        "status": _status,
      };

  String get name => _name;
  bool get status => _status;
}

class EditToDoModel extends EditBaseModel {
  String name = '';
  bool status = false;

  EditToDoModel.fromModel(ToDoModel? model) {
    name = model?.name ?? '';
    status = model?.status ?? false;
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "status": status,
      };
}

class EditTaskModel extends EditBaseModel {
  String id = ''; // For editing
  List<EditToDoModel> checkList = [];
  EditTaskModel.fromModel(TaskModel? model) {
    id = model?.id ?? '';
    List<EditToDoModel> _checkList = [];
    for (var c in model?.checkList ?? []) {
      _checkList.add(EditToDoModel.fromModel(c));
    }
    checkList = _checkList;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
      'check_list': checkList.map((e) => e.toJson()).toList(),
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
