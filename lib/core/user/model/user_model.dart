import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';

class UserModel extends BaseModel {
  final bool _admin;
  final bool _security;
  final bool _superadmin;
  final String _lang;
  final String __id;
  final int _createdTime;
  final String _fullName;
  final String _email;
  final String _phoneNumber;
  final String _gender;
  final String _address;
  String _password;

  UserModel.fromJson(Map<String, dynamic> json)
      : _admin = json['admin'] ?? false,
        _security = json['security'] ?? false,
        _superadmin = json['superadmin'] ?? false,
        _lang = json['lang'] ?? '',
        __id = json['_id'] ?? '',
        _password = '',
        _createdTime = json['created_time'],
        _fullName = json['fullname'] ?? '',
        _email = json['email'] ?? '',
        _phoneNumber = json['phone_number'] ?? '',
        _gender = json['gender'] ?? '',
        _address = json['address'] ?? '' {
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
        'admin': _admin,
        'security': _security,
        'superadmin': _superadmin,
        'lang': _lang,
        '_id': __id,
        'created_time': _createdTime,
        'fullname': _fullName,
        'email': _email,
        'phone_number': _phoneNumber,
        'gender': _gender,
        'address': _address,
        // 'modules': _modules.map((e) => e.toJson()).toList(),
        // 'roles': _roles.map((e) => e.toJson()).toList(),
      };

  bool get isAdmin => _admin;
  bool get isSecurity => _security;
  bool get isSuperadmin => _superadmin;
  String get lang => _lang;
  String get id => __id;
  int get createdTime => _createdTime;
  String get fullName => _fullName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get gender => _gender;
  String get address => _address;
  String get password => _password;
  set password(value) {
    _password = value;
  }
  // List<ModuleModel> get modules => _modules;
  // List<RoleModel> get roles => _roles;
}

class EditUserModel extends EditBaseModel {
  String id = ''; // For editing
  String lang = '';
  String email = '';
  String fullName = '';
  String password = '';
  String address = '';
  String phoneNumber = '';
  String gender = '';
  bool admin = false;
  bool security = false;

  EditUserModel.fromModel(UserModel? user) {
    id = user?.id ?? '';
    lang = user?.lang ?? '';
    email = user?.email ?? '';
    fullName = user?.fullName ?? '';
    password = '';
    address = user?.address ?? '';
    phoneNumber = user?.phoneNumber ?? '';
    gender = user?.gender ?? 'Male';
    admin = user?.isAdmin ?? false;
    security = user?.isSecurity ?? false;
  }

  Map<String, dynamic> toEditInfoJson() {
    Map<String, dynamic> params = {
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
    };
    if (lang.isNotEmpty) {
      params['lang'] = lang;
    }
    return params;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
    };
    if (lang.isNotEmpty) {
      params['lang'] = lang;
    }
    return params;
  }
}

class UserListModel extends BaseModel {
  List<UserModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  UserListModel.fromJson(Map<String, dynamic> parsedJson) {
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
