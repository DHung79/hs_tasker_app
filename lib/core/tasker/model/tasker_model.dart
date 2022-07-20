import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';
import '../../user/user.dart';

class TaskerModel extends BaseModel {
  final String __id;
  final String _name;
  final String _email;
  final String _address;
  final String _phoneNumber;
  final String _gender;
  final String _avatar;
  final int _createdTime;
  final int _updatedTime;
  final int _receiveTime;
  final int _deleteTime;
  final bool _isDeleted;
  final int _numReview;
  final double _totalRating;
  final List<ReviewModel> _reviews = [];
  final List<MedalModel> _medals = [];
  final List<String> _totalTask = [];
  final List<String> _failTask = [];
  final List<String> _successTask = [];
  String _password;

  TaskerModel.fromJson(Map<String, dynamic> json)
      : __id = json['_id'] ?? '',
        _name = json['name'] ?? '',
        _email = json['email'] ?? '',
        _address = json['address'] ?? '',
        _phoneNumber = json['phoneNumber']?.toString() ?? '',
        _gender = json['gender'] ?? '',
        _avatar = json['avatar'] ?? '',
        _createdTime = json['created_time'] ?? 0,
        _updatedTime = json['updated_time'] ?? 0,
        _receiveTime = json['receive_time'] ?? 0,
        _deleteTime = json['delete_time'] ?? 0,
        _isDeleted = json['is_deleted'] ?? false,
        _numReview = json['num_review'] ?? 0,
        _totalRating = json['total_rating'] is int
            ? json['total_rating'].toDouble()
            : json['total_rating'] ?? 0,
        _password = '' {
    _reviews.addAll(BaseModel.mapList<ReviewModel>(
      json: json,
      key: 'comments',
    ));
    _medals.addAll(BaseModel.mapList<MedalModel>(
      json: json,
      key: 'medals',
    ));
    if (json['total_task'] != null) {
      final jsons = json['total_task'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _totalTask.add(item);
          }
        }
      }
    }
    if (json['fail_task'] != null) {
      final jsons = json['fail_task'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _failTask.add(item);
          }
        }
      }
    }
    if (json['success_task'] != null) {
      final jsons = json['success_task'];
      if (jsons is List<dynamic>) {
        for (var item in jsons) {
          if (item is String) {
            _successTask.add(item);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": __id,
        "name": _name,
        "email": _email,
        "address": _address,
        "phoneNumber": _phoneNumber,
        "gender": _gender,
        "avatar": _avatar,
        "created_time": _createdTime,
        "updated_time": _updatedTime,
        'receive_time': _receiveTime,
        'delete_time': _deleteTime,
        'is_deleted': _isDeleted,
        'num_review': _numReview,
        'total_rating': _totalRating,
        'comments': _reviews.map((e) => e.toJson()).toList(),
        'medals': _medals.map((e) => e.toJson()).toList(),
        'total_task': _totalTask,
        'fail_task': _failTask,
        'success_task': _successTask,
      };

  String get id => __id;
  String get name => _name;
  String get email => _email;
  String get address => _address;
  String get phoneNumber => _phoneNumber;
  String get gender => _gender;
  String get avatar => _avatar;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  int get receiveTime => _receiveTime;
  int get deleteTime => _deleteTime;
  bool get isDeleted => _isDeleted;
  int get numReview => _numReview;
  double get totalRating => _totalRating;
  List<ReviewModel> get reviews => _reviews;
  List<MedalModel> get medals => _medals;
  List<String> get totalTask => _totalTask;
  List<String> get failTask => _failTask;
  List<String> get successTask => _successTask;
  String get password => _password;
  set password(value) {
    _password = value;
  }
}

class EditTaskerModel extends EditBaseModel {
  String id = ''; // For editing
  String name = '';
  String email = '';
  String address = '';
  String phoneNumber = '';
  String gender = '';
  String password = '';
  String newPassword = '';

  EditTaskerModel.fromModel(TaskerModel? model) {
    id = model?.id ?? '';
    name = model?.name ?? '';
    email = model?.email ?? '';
    address = model?.address ?? '';
    phoneNumber = model?.phoneNumber ?? '';
    gender = model?.gender ?? 'Male';
    password = model?.password ?? '';
    newPassword = '';
  }

  Map<String, dynamic> toChangePasswordJson() {
    Map<String, dynamic> params = {
      'password': password,
      'new_password': newPassword,
    };
    return params;
  }

  Map<String, dynamic> toEditInfoJson() {
    Map<String, dynamic> params = {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
    return params;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };

    return params;
  }
}

class ListTaskerModel extends BaseModel {
  List<TaskerModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  ListTaskerModel.fromJson(Map<String, dynamic> parsedJson) {
    List<TaskerModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<TaskerModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<TaskerModel> get records => _data;
  Paging get meta => _metaData;
}

class MedalModel extends BaseModel {
  final String __id;
  final String _name;
  final int _total;

  MedalModel.fromJson(Map<String, dynamic> json)
      : __id = json['_id'] ?? '',
        _name = json['name'] ?? '',
        _total = json['total'] ?? 0;

  Map<String, dynamic> toJson() => {
        '_id': __id,
        'name': _name,
        'total': _total,
      };

  String get id => __id;
  String get name => _name;
  int get total => _total;
}

class ReviewModel extends BaseModel {
  final UserModel _user;
  final String _description;
  final double _rating;
  final String __id;

  ReviewModel.fromJson(Map<String, dynamic> json)
      : _user = BaseModel.map<UserModel>(
          json: json,
          key: 'user',
        ),
        _description = json['description'] ?? '',
        _rating = json['rating'] is int
            ? json['rating'].toDouble()
            : json['rating'] ?? 0,
        __id = json['_id'] ?? '';

  Map<String, dynamic> toJson() => {
        'user': _user.toJson(),
        'description': _description,
        'rating': _rating,
        '_id': __id,
      };

  UserModel get user => _user;
  String get comment => _description;
  double get rating => _rating;
  String get id => __id;
}