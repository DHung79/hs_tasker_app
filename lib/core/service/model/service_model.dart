 import '../../base/models/common_model.dart';
import '../../rest/models/rest_api_response.dart';

class ServiceModel extends BaseModel {
  final String __id;
  final String _name;
  final bool _isActive;
  final int _optionType;
  final List<TranslationModel> _translations = [];
  final List<OptionModel> _options = [];
  final List<PaymentModel> _payments = [];
  final String _image;
  final int _createdTime;
  final int _updatedTime;

  ServiceModel.fromJson(Map<String, dynamic> json)
      : __id = json['_id'] ?? '',
        _name = json['name'] ?? '',
        _image = json['image'] ?? '',
        _isActive = json['is_active'] ?? false,
        _optionType = json['option_type'] ?? 0,
        _createdTime = json['created_time'] ?? 0,
        _updatedTime = json['updated_time'] ?? 0 {
    _translations.addAll(BaseModel.mapList<TranslationModel>(
      json: json,
      key: 'translation',
    ));
    _options.addAll(BaseModel.mapList<OptionModel>(
      json: json,
      key: 'options',
    ));
    _payments.addAll(BaseModel.mapList<PaymentModel>(
      json: json,
      key: 'payments',
    ));
  }

  Map<String, dynamic> toJson() => {
        '_id': __id,
        'name': _name,
        'image': _image,
        'is_active': _isActive,
        'created_time': _createdTime,
        'updated_time': _updatedTime,
        'translation': _translations.map((e) => e.toJson()).toList(),
        'options': _options.map((e) => e.toJson()).toList(),
      };

  String get id => __id;
  String get name => _name;
  String get image => _image;
  bool get isActive => _isActive;
  int get optionType => _optionType;
  int get createdTime => _createdTime;
  int get updatedTime => _updatedTime;
  List<TranslationModel> get translations => _translations;
  List<OptionModel> get options => _options;
}

class EditServiceModel extends EditBaseModel {
  String id = ''; // For editing
  String name = '';
  String image = '';
  bool isActive = false;
  int createdTime = 0;
  int updatedTime = 0;
  List<TranslationModel> translations = [];
  List<OptionModel> options = [];
  List<OptionModel> payments = [];

  EditServiceModel.fromModel(ServiceModel? model) {
    id = model?.id ?? '';
    name = model?.name ?? '';
    image = model?.image ?? '';
    isActive = model?.isActive ?? false;
    createdTime = model?.createdTime ?? 0;
    updatedTime = model?.updatedTime ?? 0;
    translations = model?.translations ?? [];
    options = model?.options ?? [];
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> params = {
      'name': name,
      'image': image,
      'is_active': isActive,
      'translations': translations,
      'options': options,
      'payments': payments,
    };

    return params;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'id': id,
      'name': name,
      'image': image,
      'is_active': isActive,
      'translations': translations,
      'options': options,
      'payments': payments,
    };
    return params;
  }
}

class ListServiceModel extends BaseModel {
  List<ServiceModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  ListServiceModel.fromJson(Map<String, dynamic> parsedJson) {
    List<ServiceModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<ServiceModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<ServiceModel> get records => _data;
  Paging get meta => _metaData;
}

class PaymentModel extends BaseModel {
  final String _name;
  final bool _isActive;
  final String __id;

  PaymentModel.fromJson(Map<String, dynamic> json)
      : _name = json['name'] ?? '',
        _isActive = json['is_active'],
        __id = json['_id'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': _name,
        'is_active': _isActive,
        '_id': __id,
      };
  String get name => _name;
  bool get isActive => _isActive;
  String get id => __id;
}

class TranslationModel extends BaseModel {
  final String _language;
  final String _name;
  final String __id;

  TranslationModel.fromJson(Map<String, dynamic> json)
      : _language = json['language'] ?? '',
        _name = json['name'] ?? '',
        __id = json['_id'] ?? '';

  Map<String, dynamic> toJson() => {
        'language': _language,
        'name': _name,
        '_id': __id,
      };

  String get language => _language;
  String get name => _name;
  String get id => __id;
}

class OptionModel extends BaseModel {
  final String _name;
  final int _price;
  final int _quantity;
  final String _note;
  final String __id;

  OptionModel.fromJson(Map<String, dynamic> json)
      : _name = json['name'] ?? '',
        _price = json['price'] ?? 0,
        _quantity = json['quantity'] ?? 0,
        _note = json['note'] ?? '',
        __id = json['_id'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': _name,
        'price': _price,
        'quantity': _quantity,
        'note': _note,
        '_id': __id,
      };
  String get name => _name;
  int get price => _price;
  int get quantity => _quantity;
  String get note => _note;
  String get id => __id;
}
