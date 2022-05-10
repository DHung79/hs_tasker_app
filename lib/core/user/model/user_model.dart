import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';

class UserModel extends BaseModel {
  final List _roles;
  final String __id;
  final String _name;
  final String _email;
  final String _phoneNumber;
  final String _address;
  final String _authGoogleId;
  final bool _admin;
  final String _gender;
  final int _createdTime;
  final int _updatedTime;
  // String _password;

  UserModel.fromJson(Map<String, dynamic> json)
      : _roles = json['roles'] ?? [],
        __id = json['_id'] ?? '',
        _name = json['name'] ?? '',
        _email = json['email'] ?? '',
        _phoneNumber = json['phoneNumber'] ?? '',
        _address = json['address'] ?? '',
        _authGoogleId = json['authGoogleId'] ?? '',
        _admin = json['admin'] ?? false,
        _gender = json['gender'] ?? '',
        _createdTime = json['created_time'],
        // _password = '',
        _updatedTime = json['updated_time'] {
    // _roles.addAll(BaseModel.mapList<RoleModel>(
    //   json: json,
    //   key: 'roles',
    // ));
    // _modules.addAll(BaseModel.mapList<ModuleModel>(
    //   json: json,
    //   key: 'modules',
    // ));
  }

  Map<String, dynamic> toJson() => {
        'roles': _roles,
        '_id': __id,
        'name': _name,
        'email': _email,
        'phoneNumber': _phoneNumber,
        'address': _address,
        'authGoogleId': _authGoogleId,
        'admin': _admin,
        'gender': _gender,
        'created_time': _createdTime,
        'updated_time': _updatedTime,
      };

  List get roles => _roles;
  String get id => __id;
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get authGoogleId => _authGoogleId;
  bool get isAdmin => _admin;
  String get gender => _gender;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  // String get password => _password;
  // set password(value) {
  //   _password = value;
  // }
}

class EditUserModel extends EditBaseModel {
  String id = ''; // For editing
  String name = '';
  String password = '';
  String address = '';
  String phoneNumber = '';
  String gender = '';

  EditUserModel.fromModel(UserModel? user) {
    id = user?.id ?? '';
    name = user?.name ?? '';
    password = '';
    address = user?.address ?? '';
    phoneNumber = user?.phoneNumber ?? '';
    gender = user?.gender ?? 'Male';
  }

  Map<String, dynamic> toEditProfileJson() {
    Map<String, dynamic> params = {
      'name': name,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
    };
    return params;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
    };
    return params;
  }
}

class ListUserModel extends BaseModel {
  List<UserModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  ListUserModel.fromJson(Map<String, dynamic> parsedJson) {
    List<UserModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<UserModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<UserModel> get records => _data;
  Paging get meta => _metaData;
}
