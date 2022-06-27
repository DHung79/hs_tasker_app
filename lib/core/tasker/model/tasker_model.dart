import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';

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
        _password = '';

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
