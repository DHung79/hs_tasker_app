import 'package:hs_tasker_app/core/user/model/user_model.dart';

import '../../authentication/models/status.dart';
import '../../logger/logger.dart';
import '../../service/service.dart';
import '../../tasker/model/tasker_model.dart';

class ApiError implements Exception {
  String _errorCode = '';
  String _errorMessage = '';

  ApiError.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson?['error_code'] != null) {
      _errorCode = parsedJson?['error_code']?.toString() ?? '';
    }
    _errorMessage = parsedJson?['error_message'] ?? '';
  }

  String get errorCode => _errorCode;
  String get errorMessage => _errorMessage;

  @override
  String toString() {
    return _errorMessage;
  }
}

class ApiResponse<T> {
  ApiError? _error;
  T? _model;

  ApiResponse(T? m, ApiError? e) {
    _model = m;
    _error = e;
  }

  ApiError? get error => _error;
  T? get model => _model;
}

class BaseModel {
  static T fromJson<T extends BaseModel>(Map<String, dynamic> json) {
    // Models
    // if (T == AccountModel) {
    //   return AccountModel.fromJson(json) as T;
    // }
    // if (T == AccountListModel) {
    //   return AccountListModel.fromJson(json) as T;
    // }
    if (T == Status) {
      return Status.fromJson(json) as T;
    }
    if (T == UserModel) {
      return UserModel.fromJson(json) as T;
    }
    if (T == ListUserModel) {
      return ListUserModel.fromJson(json) as T;
    }
    if (T == TaskerModel) {
      return TaskerModel.fromJson(json) as T;
    }
    if (T == ListTaskerModel) {
      return ListTaskerModel.fromJson(json) as T;
    }
    if (T == ServiceModel) {
      return ServiceModel.fromJson(json) as T;
    }
    if (T == ListServiceModel) {
      return ListServiceModel.fromJson(json) as T;
    }

    if (T == CategoryModel) {
      return CategoryModel.fromJson(json) as T;
    }
    if (T == TranslationModel) {
      return TranslationModel.fromJson(json) as T;
    }
    if (T == OptionsModel) {
      return OptionsModel.fromJson(json) as T;
    }
    if (T == UnitModel) {
      return UnitModel.fromJson(json) as T;
    }

    logError("Unknown BaseModel class: $T");
    throw Exception("Unknown BaseModel class: $T");
  }

  static List<T> mapList<T extends BaseModel>({
    required Map<String, dynamic> json,
    required String key,
    String defaultKey = '_id',
  }) {
    final _results = <T>[];
    if (json[key] != null && json[key] is List<dynamic>) {
      for (var val in json[key]) {
        if (val is String) {
          _results.add(BaseModel.fromJson<T>({defaultKey: val}));
        } else if (val is Map<String, dynamic>) {
          _results.add(BaseModel.fromJson<T>(val));
        } else {
          _results.add(BaseModel.fromJson<T>({}));
        }
      }
    }
    return _results;
  }

  static T listDynamic<T extends BaseModel>(List<dynamic> list) {
    // if (T == ListRoleModel) {
    //   return ListRoleModel.listDynamic(list) as T;
    // }

    logError("Unknown BaseModel class: $T");
    throw Exception("Unknown BaseModel class: $T");
  }

  static T map<T extends BaseModel>({
    required Map<String, dynamic> json,
    required String key,
    String defaultKey = '_id',
  }) {
    if (json.containsKey(key)) {
      final _val = json[key];
      if (_val is String) {
        return BaseModel.fromJson<T>({defaultKey: _val});
      } else if (_val is Map<String, dynamic>) {
        return BaseModel.fromJson<T>(_val);
      }
    }
    return BaseModel.fromJson({});
  }
}

class EditBaseModel {
  static T fromModel<T extends EditBaseModel>(BaseModel model) {
    if (T == EditServiceModel) {
      return EditServiceModel.fromModel(model as ServiceModel) as T;
    }
    // if (model is EditRoleModel) {
    //   return EditRoleModel.fromModel(model as RoleModel) as T;
    // }
    // if (T == EditVehicleModel) {
    //   return EditVehicleModel.fromModel(model as VehicleEventModel) as T;
    // }
    // if (T == EditFaceRoleModel) {
    //   return EditFaceRoleModel.fromModel(model as FaceUserModel) as T;
    // }
    logError("Unknown EditBaseModel class: $T");
    throw Exception("Unknown EditBaseModel class: $T");
  }

  static Map<String, dynamic> toCreateJson(EditBaseModel model) {
    if (model is EditServiceModel) {
      return model.toCreateJson();
    }
    // if (model is EditUserModel) {
    //   return model.toCreateJson();
    // }
    // if (model is EditRoleModel) {
    //   return model.toCreateJson();
    // }
    return {};
  }

  static Map<String, dynamic> toEditProfileJson(EditBaseModel model) {
    if (model is EditUserModel) {
      return model.toEditProfileJson();
    }
    return {};
  }

  static Map<String, dynamic> toEditJson(EditBaseModel model) {
    if (model is EditServiceModel) {
      return model.toEditJson();
    }
    if (model is EditUserModel) {
      return model.toEditJson();
    }
    if (model is EditTaskerModel) {
      return model.toEditJson();
    }
    return {};
  }
}
