import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import '../../routes/route_names.dart';
import '../../widgets/jt_indicator.dart';
import '../layout_template/content_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _pageState = PageState();
  late GoogleMapController _mapController;

  final CameraPosition _location = const CameraPosition(
    target: LatLng(12.27873, 109.1998974),
    zoom: 12.0,
  );

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
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
              userSnapshot: snapshot,
              pageState: _pageState,
              onFetch: () {
                _fetchDataOnPage();
              },
              child: snapshot.hasData
                  ? _buildContent(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0.16,
      flexibleSpace: Row(
        children: [
          AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 56),
            color: AppColor.transparent,
            highlightColor: AppColor.white,
            child: SvgIcon(
              SvgIcons.arrowBack,
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () => navigateTo(workingTaskRoute),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AsyncSnapshot<TaskerModel> snapshot) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _appBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
              initialCameraPosition: _location,
              scrollGesturesEnabled: true,
              myLocationEnabled: true,
              indoorViewEnabled: true,
              trafficEnabled: true,
              onCameraMove: (location) {
                logDebug(location.zoom);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34),
            child: _actions(),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        height: 84,
        width: size.maxWidth,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppButtonTheme.fillRounded(
            constraints: const BoxConstraints(minHeight: 52),
            color: AppColor.primary2,
            highlightColor: AppColor.primary2,
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Chọn vị trí này',
                    style: AppTextTheme.headerTitle(AppColor.white),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
      );
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  _fetchDataOnPage() {}
}
