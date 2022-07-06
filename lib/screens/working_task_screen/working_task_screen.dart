import 'package:flutter/material.dart';
import 'package:hs_tasker_app/routes/route_names.dart';
import 'package:hs_tasker_app/screens/working_task_screen/components/warning_dialog.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/base/models/upload_image.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/cancel_task_dialog.dart';
import '../../widgets/contact_dialog.dart';
import '../../widgets/jt_task_detail.dart';
import '../../core/task/task.dart';
import '../../main.dart';
import '../../widgets/display_date_time.dart';
import '../../widgets/jt_indicator.dart';
import '../../widgets/jt_toast.dart';
import '../../widgets/open_google_map.dart';
import '../layout_template/content_screen.dart';

class WorkingTaskScreen extends StatefulWidget {
  final String id;
  const WorkingTaskScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<WorkingTaskScreen> createState() => _WorkingTaskScreenState();
}

class _WorkingTaskScreenState extends State<WorkingTaskScreen> {
  final _pageState = PageState();
  final _scrollController = ScrollController();
  bool _showList = true;
  final _taskBloc = TaskBloc();
  final List<UploadImage> _beforeImages = [];
  final List<UploadImage> _afterImages = [];
  @override
  void initState() {
    JTToast.init(context);
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    _taskBloc.fetchDataById(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      pageState: _pageState,
      onUserFetched: (user) => setState(() {}),
      appBarHeight: 0,
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<TaskerModel> snapshot) {
            return PageContent(
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child:
                  snapshot.hasData ? _toDoPage(snapshot) : const JTIndicator(),
            );
          }),
    );
  }

  Widget _toDoPage(AsyncSnapshot<TaskerModel> snapshot) {
    return StreamBuilder(
      stream: _taskBloc.taskData,
      builder: (context, AsyncSnapshot<ApiResponse<TaskModel?>> snapshot) {
        if (snapshot.hasData) {
          final task = snapshot.data!.model!;

          return Scaffold(
            backgroundColor: AppColor.shade1,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: _appBar(task),
            ),
            body: _buildContent(task),
          );
        }
        return const JTIndicator();
      },
    );
  }

  Widget _appBar(TaskModel task) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0.16,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(maxWidth: 40),
                color: AppColor.transparent,
                highlightColor: AppColor.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 0, 24),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: AppColor.black,
                    ),
                  ),
                ),
                onPressed: () {
                  navigateTo(homeRoute);
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 24.5, 10, 16.5),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 39),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Công việc sắp tới',
                            style: AppTextTheme.subText(AppColor.primary1),
                          ),
                        ),
                        Text(
                          task.service.name,
                          style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 16, 16),
            child: AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(minHeight: 40),
                color: AppColor.shade1,
                borderRadius: BorderRadius.circular(50),
                highlightColor: AppColor.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Hủy công việc',
                    style: AppTextTheme.mediumHeaderTitle(AppColor.others1),
                  ),
                ),
                onPressed: () {
                  _cancelTaskDialog(task);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TaskModel task) {
    return LayoutBuilder(
      builder: (context, size) {
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _taskDetails(task),
              ),
              _buildJobDetail(task),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildResults(task),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _customerContact(task),
              ),
              _actions(
                task: task,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _customerContact(TaskModel task) {
    return Container(
      color: AppColor.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: ClipOval(
              child: task.user.avatar.isNotEmpty
                  ? Image.network(
                      task.user.avatar,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/logo.png",
                      width: 44,
                      height: 44,
                    ),
            ),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Khách hàng',
                      style: AppTextTheme.subText(AppColor.primary1),
                    ),
                  ),
                  Text(
                    task.user.name,
                    style: AppTextTheme.mediumBodyText(AppColor.black),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(minHeight: 44),
                color: AppColor.primary2,
                borderRadius: BorderRadius.circular(50),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgIcon(
                    SvgIcons.message,
                    size: 24,
                    color: AppColor.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Liên lạc',
                      style: AppTextTheme.mediumHeaderTitle(
                        AppColor.white,
                      ),
                    ),
                  ),
                ]),
                onPressed: () {
                  _showContact(task);
                }),
          ),
        ],
      ),
    );
  }

  Widget _taskDetails(TaskModel task) {
    final date = formatFromInt(
      value: task.date,
      context: context,
      displayedFormat: 'dd/MM/yyyy',
    );
    final startTime = formatFromInt(
      value: task.startTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    final endTime = formatFromInt(
      value: task.endTime,
      context: context,
      displayedFormat: 'HH:mm',
    );
    return Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Thời gian và địa điểm làm việc',
              style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: JTTaskDetail.taskDetailBox(
              svgIcon: SvgIcons.locationOutline,
              headerTitle: 'Địa chỉ',
              contentTitle: task.address,
              boxColor: AppColor.shade2,
              button: AppButtonTheme.fillRounded(
                constraints: const BoxConstraints(minHeight: 44),
                color: AppColor.shade5,
                borderRadius: BorderRadius.circular(50),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgIcon(
                    SvgIcons.navigation,
                    size: 24,
                    color: AppColor.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Chỉ đường',
                      style: AppTextTheme.mediumHeaderTitle(
                        AppColor.white,
                      ),
                    ),
                  ),
                ]),
                onPressed: () {
                  openMap(
                    lat: double.tryParse(task.location.lat)!,
                    long: double.tryParse(task.location.long)!,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: JTTaskDetail.taskDetail(
              svgIcon: SvgIcons.time,
              headerTitle: 'Thời gian làm',
              contentTitle: '$date, từ $startTime đến $endTime',
              backgroundColor: AppColor.shade2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: JTTaskDetail.taskDetail(
              svgIcon: SvgIcons.home2,
              headerTitle: 'Loại nhà',
              contentTitle: getHomeType(task.typeHome),
              backgroundColor: AppColor.shade2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetail(TaskModel task) {
    return Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Chi tiết công việc',
              style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: JTTaskDetail.taskDetail(
              svgIcon: SvgIcons.notebook,
              headerTitle: 'Ghi chú',
              contentTitle: task.note,
              backgroundColor: AppColor.shade2,
            ),
          ),
          if (task.checkList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: JTTaskDetail.taskDetailList(
                svgIcon: SvgIcons.listCheck,
                headerTitle: 'Danh sách kiểm tra',
                contentList: _jobList(task),
                backgroundColor: AppColor.shade2,
                showList: _showList,
                onTap: () {
                  setState(() {
                    _showList = !_showList;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  _jobList(TaskModel task) {
    final _editModel = EditTaskModel.fromModel(task);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          for (var item in _editModel.checkList)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                constraints: const BoxConstraints(minHeight: 24),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        checkColor: AppColor.white,
                        activeColor: AppColor.shade9,
                        value: item.status,
                        onChanged: (value) {
                          setState(() {
                            item.status = value!;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        item.name,
                        style: AppTextTheme.mediumBodyText(
                          AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildResults(TaskModel task) {
    return Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Kết quả thực tế',
              style: AppTextTheme.mediumHeaderTitle(AppColor.primary1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Bạn cần phải chụp trước khi bắt đầu và sau khi kết thúc công việc',
              style: AppTextTheme.normalText(AppColor.black),
            ),
          ),
          _buildImages(
            title: 'Trước',
            task: task,
            images: _beforeImages,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildImages(
              title: 'Sau',
              task: task,
              images: _afterImages,
              isBefore: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages({
    required String title,
    required List<UploadImage> images,
    required TaskModel task,
    bool isBefore = true,
  }) {
    return LayoutBuilder(builder: (context, size) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  title,
                  style: AppTextTheme.mediumHeaderTitle(AppColor.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 100,
                  width: size.maxWidth,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AppButtonTheme.outlineRounded(
                          constraints: const BoxConstraints(
                            minHeight: 100,
                            minWidth: 100,
                          ),
                          color: AppColor.white,
                          outlineColor: AppColor.black,
                          borderRadius: BorderRadius.circular(4),
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: AppColor.black,
                          ),
                          onPressed: () {
                            _pickImage(isBefore: isBefore);
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, index) {
                            final image = images[index];
                            final isLast = index != images.length - 1;
                            return Padding(
                              padding: EdgeInsets.only(right: isLast ? 16 : 0),
                              child: Stack(
                                children: [
                                  Image.memory(
                                    image.imageData!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgIcon(
                                            SvgIcons.close,
                                            color: AppColor.primary1,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          images.remove(image);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  _pickImage({bool isBefore = true}) async {
    List<XFile>? imagesPicked = [];
    final ImagePicker _picker = ImagePicker();
    imagesPicked = await _picker.pickMultiImage();
    if (imagesPicked != null) {
      final images = imagesPicked.map((image) async {
        final imageType = image.path.split(".").last;
        if (imageType != 'webp') {
          return UploadImage(
            key: '${DateTime.now().millisecondsSinceEpoch}-${image.name}',
            name: image.name,
            path: image.path,
            imageData: await image.readAsBytes(),
          );
        }
      }).toList();
      for (var i in images) {
        final image = await i;
        if (image != null) {
          setState(() {
            if (isBefore) {
              _beforeImages.add(image);
            } else {
              _afterImages.add(image);
            }
          });
        }
      }
    }
  }

  _showContact(TaskModel task) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return ContactDialog(user: task.user);
        });
  }

  _cancelTaskDialog(TaskModel task) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          return CancelTaskDialog(
              task: task,
              contentHeader: Text(
                'Bạn có chắc chắn hủy công việc?',
                style: AppTextTheme.normalText(AppColor.black),
              ),
              accountBalances: '${task.totalPrice} VND',
              onConfirmed: () {
                _cancelTask(task);
              });
        });
  }

  _cancelTask(TaskModel task) {
    _taskBloc
        .cancelTask(task.id)
        .then((value) => navigateTo(homeRoute))
        .onError((ApiError error, stackTrace) {
      JTToast.errorToast(message: showError(error.errorCode, context));
    }).catchError(
      (error, stackTrace) {
        JTToast.errorToast(message: error.toString());
        logDebug('error $error');
      },
    );
  }

  Widget _actions({
    required TaskModel task,
  }) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        color: AppColor.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: JTTaskDetail.taskDetail(
                headerTitle: 'Tổng tiền',
                contentTitle: task.totalPrice.toString(),
                svgIcon: SvgIcons.dollar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 51),
              child: Container(
                height: 52,
                width: size.maxWidth,
                color: AppColor.white,
                child: AppButtonTheme.fillRounded(
                  constraints: const BoxConstraints(minHeight: 52),
                  color: AppColor.shade9,
                  highlightColor: AppColor.shade9,
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgIcon(
                        SvgIcons.checkCircleOutline,
                        color: AppColor.white,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Hoàn thành công việc',
                          style: AppTextTheme.headerTitle(AppColor.white),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (_beforeImages.isEmpty || _afterImages.isEmpty) {
                      _warningDialog();
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Colors.black12,
                        builder: (BuildContext context) {
                          return _finishJobDialog(task);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _warningDialog() {
    return showModalBottomSheet(
        isDismissible: false,
        barrierColor: AppColor.transparent,
        backgroundColor: AppColor.transparent,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        builder: (context) {
          return const WarningDialog();
        });
  }

  _finishJobDialog(TaskModel task) {
    return JTConfirmDialog(
      headerTitle: 'Kết thúc công việc',
      contentText: 'Bạn có chắc chắn kết thúc công việc?',
      actionField: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
        child: Column(
          children: [
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(
                minHeight: 52,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppColor.primary2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    SvgIcons.checkCircleOutline,
                    color: AppColor.white,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Xác nhận',
                      style: AppTextTheme.headerTitle(AppColor.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _completeTask(task);
              },
            ),
            const SizedBox(height: 16),
            AppButtonTheme.fillRounded(
              constraints: const BoxConstraints(
                minHeight: 52,
              ),
              borderRadius: BorderRadius.circular(4),
              color: AppColor.shade1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    SvgIcons.close,
                    color: AppColor.black,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Hủy bỏ',
                      style: AppTextTheme.headerTitle(AppColor.black),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _completeTask(TaskModel task) {
    _taskBloc
        .uploadListImage(
      id: task.id,
      filesPath: _beforeImages.map((e) => e.path!).toList(),
    )
        .then((value) {
      _taskBloc
          .uploadListImage(
        id: task.id,
        isBefore: false,
        filesPath: _afterImages.map((e) => e.path!).toList(),
      )
          .then((value) {
        _taskBloc.completeTask(id: task.id).then((value) {
          AuthenticationBlocController().authenticationBloc.add(GetUserData());
          navigateTo(homeRoute);
          JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
        }).onError((ApiError error, stackTrace) {
          JTToast.errorToast(message: showError(error.errorCode, context));
        }).catchError(
          (error, stackTrace) {
            logDebug('catchError: $error');
          },
        );
      }).onError((ApiError error, stackTrace) {
        JTToast.errorToast(message: 'Ảnh không đúng định dạng');
      }).catchError(
        (error, stackTrace) {
          logDebug('catchError: $error');
        },
      );
    }).onError((ApiError error, stackTrace) {
      JTToast.errorToast(message: 'Ảnh không đúng định dạng');
    }).catchError(
      (error, stackTrace) {
        logDebug('catchError: $error');
      },
    );
  }

  _fetchDataOnPage() {}
}
