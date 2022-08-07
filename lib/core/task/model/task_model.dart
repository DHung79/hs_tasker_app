import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';
import '../../service/service.dart';
import '../../tasker/tasker.dart';
import '../../user/model/user_model.dart';

class TaskModel extends BaseModel {
  final AddressModel _address;
  final UserModel _user;
  final TaskerModel _tasker;
  final ServiceModel _service;
  final String __id;
  final String _estimateTime;
  final int _startTime;
  final int _endTime;
  final int _date;
  final String _note;
  final int _status;
  final int _language;
  final FailureReasonModel _failureReason;
  final int _typeHome;
  final List<ToDoModel> _checkList = [];
  final int _deletedTime;
  final int _createdTime;
  final int _updatedTime;
  final int _totalPrice;
  final List<String> _listPicturesBefore = [];
  final List<String> _listPicturesAfter = [];
  final OptionModel _selectedOption;
  final bool _userDeleted;
  final bool _taskerDeleted;

  TaskModel.fromJson(Map<String, dynamic> json)
      : _address = BaseModel.map<AddressModel>(
          json: json,
          key: 'address',
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
        _selectedOption = BaseModel.map<OptionModel>(
          json: json,
          key: 'selected_option',
        ),
        _failureReason = BaseModel.map<FailureReasonModel>(
          json: json,
          key: 'failure_reason',
        ),
        __id = json['_id'] ?? '',
        _estimateTime = json['estimate_time'] ?? '',
        _startTime = json['start_time'] ?? 0,
        _endTime = json['end_time'] ?? 0,
        _date = json['date'] ?? 0,
        _note = json['note'] ?? '',
        _status = json['status'] ?? 0,
        _language = json['language'] ?? 0,
        _typeHome = json['type_home'] ?? 0,
        _deletedTime = json['deleted_time'] ?? 0,
        _createdTime = json['created_time'] ?? 0,
        _updatedTime = json['updated_time'] ?? 0,
        _totalPrice = json['total_price'] ?? 0,
        _userDeleted = json['user_deleted'] ?? false,
        _taskerDeleted = json['tasker_deleted'] ?? false {
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
        'address': _address.toJson(),
        'posted_user': _user.toJson(),
        'tasker': _tasker.toJson(),
        'service': _service.toJson(),
        '_id': __id,
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
        'deleted_time': _deletedTime,
        'created_time': _createdTime,
        'updated_time': _updatedTime,
        'total_price': _totalPrice,
        'list_pictures_before': _listPicturesBefore,
        'list_pictures_after': _listPicturesAfter,
        'selected_option': _selectedOption.toJson(),
        'user_deleted': _userDeleted,
        'tasker_deleted': _taskerDeleted,
      };
  AddressModel get address => _address;
  UserModel get user => _user;
  TaskerModel get tasker => _tasker;
  ServiceModel get service => _service;
  String get id => __id;
  String get estimateTime => _estimateTime;
  int get startTime => _startTime;
  int get endTime => _endTime;
  int get date => _date;
  String get note => _note;
  int get status => _status;
  int get language => _language;
  FailureReasonModel get failureReason => _failureReason;
  int get typeHome => _typeHome;
  List<ToDoModel> get checkList => _checkList;
  int get deletedTime => _deletedTime;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  int get totalPrice => _totalPrice;
  List<String> get listPicturesBefore => _listPicturesBefore;
  List<String> get listPicturesAfter => _listPicturesAfter;
  OptionModel get selectedOption => _selectedOption;
  bool get userDeleted => _userDeleted;
  bool get taskerDeleted => _taskerDeleted;
}

class FailureReasonModel extends BaseModel {
  final UserModel? _user;
  final String _reason;

  FailureReasonModel.fromJson(Map<String, dynamic> json)
      : _user = BaseModel.map<UserModel>(
          json: json,
          key: 'user',
        ),
        _reason = json['reason'] ?? '';

  Map<String, dynamic> toJson() => {
        'posted_user': _user?.toJson(),
        'reason': _reason,
      };

  UserModel? get user => _user;
  String get reason => _reason;
}

class AddressModel extends BaseModel {
  String name;
  String lat;
  String long;
  String location;

  AddressModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        lat = json['lat'] ?? '',
        long = json['long'] ?? '',
        location = json['location'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': lat,
        'long': long,
        'location': location,
      };
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
