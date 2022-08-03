import 'package:rxdart/rxdart.dart';
import '../../../main.dart';
import '../../base/blocs/block_state.dart';
import '../../rest/api_helpers/api_exception.dart';
import '../notification.dart';

class NotificationBloc {
  final _repository = NotificationRepository();
  final _allDataFetcher =
      BehaviorSubject<ApiResponse<NotificationListModel?>>();
  final _getNotiBadges = BehaviorSubject<ApiResponse<NotificationModel?>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<NotificationListModel?>> get allData =>
      _allDataFetcher.stream;
  Stream<ApiResponse<NotificationModel?>> get getNotiBadges =>
      _getNotiBadges.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchAllData<NotificationListModel>(params: params);

      if (_allDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allDataFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  getTotalUnread() async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.getTotalUnread<NotificationModel>();

      if (_getNotiBadges.isClosed) return;
      if (data.error != null) {
        // Error exist
        _getNotiBadges.sink.addError(data.error!);
      } else {
        // Adding response data.
        _getNotiBadges.sink.add(data);
      }
    } on AppException catch (e) {
      _getNotiBadges.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<NotificationModel> readAllNoti() async {
    try {
      // Await response from server.
      final data = await _repository.readAllNoti<NotificationModel>();
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<NotificationModel> readNotiById({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository.readNotiById<NotificationModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  dispose() {
    _allDataFetcher.close();
    _getNotiBadges.close();
    _allDataState.close();
  }
}
