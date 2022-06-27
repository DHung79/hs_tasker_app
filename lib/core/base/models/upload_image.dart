import 'dart:typed_data';
import '../../rest/models/rest_api_response.dart';

class UploadImage {
  String key;
  String? path;
  String name;

  String progress = '';
  String error = '';
  String url = '';
  ImageModel? model;
  Uint8List? imageData;

  UploadImage({
    required this.key,
    required this.name,
    this.path,
    this.imageData,
  });
}

class ImageModel extends BaseModel {
  final String _id;
  final String _url;
  final int _uploadType;

  ImageModel.fromJson(Map<String, dynamic> json)
      : _id = json['_id'] ?? '',
        _url = json['url'] ?? '',
        _uploadType = json['uploadType'];

  String get id => _id;
  String get url => _url;
  int get uploadType => _uploadType;
}

class ImageListModel extends BaseModel {
  final List<ImageModel> _data = [];

  ImageListModel.fromJson(Map<String, dynamic> json) {
    _data.addAll(BaseModel.mapList<ImageModel>(json: json, key: 'images'));
  }

  List<ImageModel> get records => _data;
}
