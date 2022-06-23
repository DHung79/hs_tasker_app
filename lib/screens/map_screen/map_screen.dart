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
  String _searchString = '';
  Marker? _selectedPlate;

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
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
              child: snapshot.hasData
                  ? _buildContent(snapshot)
                  : const JTIndicator(),
            );
          }),
    );
  }

  Widget _buildContent(AsyncSnapshot<TaskerModel> snapshot) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
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
              markers: {
                if (_selectedPlate != null) _selectedPlate!,
              },
              onLongPress: (value) {
                setState(() {
                  _selectedPlate = Marker(
                    markerId: const MarkerId('selectedPlate'),
                    position: value,
                  );
                });
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
              SvgIcons.arrowBackIos,
              size: 24,
              color: AppColor.black,
            ),
            onPressed: () => navigateTo(workingTaskRoute),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                initialValue: _searchString,
                style: TextStyle(color: AppColor.black),
                decoration: InputDecoration(
                  errorStyle: AppTextTheme.subText(AppColor.others1),
                  filled: true,
                  fillColor: AppColor.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: AppColor.text7,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: AppColor.text7,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  suffixIconColor: AppColor.black,
                  suffixIcon: Container(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: TextButton(
                      child: SvgIcon(
                        SvgIcons.close,
                        color: AppColor.black,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchString = '';
                        });
                      },
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchString = value;
                  });
                },
              ),
            ),
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
            onPressed: () {
              if (_selectedPlate != null) {
                logDebug(_selectedPlate!.position);
              } else {
                logDebug('Chưa chọn vị trí');
              }
            },
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
