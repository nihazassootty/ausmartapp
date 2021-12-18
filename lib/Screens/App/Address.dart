import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maafos/Commons/AppConstants.dart';
import 'package:maafos/Commons/ColorConstants.dart';
import 'package:maafos/Commons/SnackBar.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Commons/validators.dart';
import 'package:maafos/Models/MapPredictionModel.dart';
import 'package:maafos/Providers/GetDataProvider.dart';
import 'package:maafos/Screens/App/ModalBottomsheets/SavedAddressmodal.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class MapAddress extends StatefulWidget {
  MapAddress({Key key}) : super(key: key);

  @override
  _MapAddressState createState() => _MapAddressState();
}

class _MapAddressState extends State<MapAddress> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController searchController = new TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController landmarkController = new TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  CameraPosition currentLocation = CameraPosition(
    target: LatLng(10.0261, 76.3125),
    zoom: 19,
  );
  bool mapLoading = true;
  bool confirm = false;
  bool loading = true;
  String addressType = '';
  Map address;

  List<PlacePredictions> placepredictionList = [];

  Future _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return showSnackBar(
          duration: Duration(milliseconds: 10000),
          context: context,
          message: 'Please Access Permission');
    }
    if (permission == LocationPermission.denied) {
      LocationPermission newpermission = await Geolocator.requestPermission();
      if (newpermission == LocationPermission.deniedForever ||
          newpermission == LocationPermission.denied) {
        return showSnackBar(
            duration: Duration(milliseconds: 10000),
            context: context,
            message: 'Please Access Permission');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var addresses = await Geocoder.google(googleAPI)
          .findAddressesFromCoordinates(Coordinates(
              currentLocation.target.latitude,
              currentLocation.target.longitude));
      var currentAddress = {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "smallAddress": addresses.first.featureName,
        "fullAddress": addresses.first.addressLine
      };

      setState(
        () {
          address = currentAddress;
          currentLocation = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 19,
          );
          loading = false;
          mapLoading = false;
        },
      );
    }
    if (permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var addresses = await Geocoder.google(googleAPI)
          .findAddressesFromCoordinates(Coordinates(
              currentLocation.target.latitude,
              currentLocation.target.longitude));
      var currentAddress = {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "smallAddress": addresses.first.featureName,
        "fullAddress": addresses.first.addressLine
      };

      setState(() {
        address = currentAddress;
        currentLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        loading = false;
        mapLoading = false;
      });
    }
  }

  Future _getNewLocation() async {
    var addresses = await Geocoder.google(googleAPI)
        .findAddressesFromCoordinates(Coordinates(
            currentLocation.target.latitude, currentLocation.target.longitude));
    var currentAddress = {
      "latitude": currentLocation.target.latitude,
      "longitude": currentLocation.target.longitude,
      "fullAddress": addresses.first.addressLine,
      "smallAddress": addresses.first.featureName,
    };
    setState(
      () {
        address = currentAddress;
        loading = false;
      },
    );
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    List coordinates = [address["latitude"], address["longitude"]];
    if (form.validate()) {
      Provider.of<GetDataProvider>(context, listen: false).addAddressData(
        {
          "address": addressController.text,
          "landmark": landmarkController.text,
          "coordinates": coordinates,
          "formattedAddress": address["fullAddress"],
          "addressType": addressType,
        },
        context,
      );

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            if (!mapLoading)
              GoogleMap(
                tiltGesturesEnabled: confirm ? false : true,
                rotateGesturesEnabled: confirm ? false : true,
                zoomGesturesEnabled: confirm ? false : true,
                scrollGesturesEnabled: confirm ? false : true,
                mapType: MapType.normal,
                initialCameraPosition: currentLocation,
                myLocationButtonEnabled: false,
                onCameraMove: (val) {
                  setState(() {
                    currentLocation = val;
                  });
                },
                onCameraIdle: () {
                  _getNewLocation();
                },
                onCameraMoveStarted: () {
                  if (loading == false) {
                    setState(() {
                      loading = true;
                    });
                  }
                },
              ),
            Center(
              child: SvgPicture.asset(
                "assets/svg/gps.svg",
                height: 50,
                color: kPinkColor,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x2FA0A0A0),
                          spreadRadius: 4,
                          blurRadius: 20)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select delivery location.',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                          color: kBlackColor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: kPinkColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                loading ? 'Loading..' : address["fullAddress"],
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (confirm)
                              Container(
                                height: 30,
                                color: kPinkColor,
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: Text(
                                    'CHANGE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      addressController.clear();
                                      landmarkController.clear();
                                      addressType = '';
                                      confirm = false;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      loading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey,
                                    width: 300,
                                    height: 14,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    color: Colors.black,
                                    width: 200,
                                    height: 12,
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                address["fullAddress"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Quicksand',
                                    color: kGreyLight,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOutSine,
                        child: Container(
                          child: !confirm
                              ? null
                              : Form(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: kNavBarTitle,
                                        controller: addressController,
                                        validator: nameValidator,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[140],
                                          border: kOutlineStyle,
                                          hintText: 'House / Flat / Floor No.',
                                          hintStyle: kText143,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        style: kNavBarTitle,
                                        controller: landmarkController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[140],
                                          border: kOutlineStyle,
                                          hintText: 'Landmark',
                                          hintStyle: kText143,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 15),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "Choose Address Type:",
                                                style: kText10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/svg/home2.svg",
                                                    width: 20,
                                                    height: 20,
                                                    color: kPinkColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Home',
                                                  style: TextStyle(
                                                      color: kBlackColor,
                                                      fontFamily: 'QuickSand',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Radio(
                                                    activeColor: kPinkColor,
                                                    value: 'Home',
                                                    groupValue: addressType,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        addressType = val;
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/svg/work.svg",
                                                    width: 20,
                                                    height: 20,
                                                    color: kPinkColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  'Work',
                                                  style: TextStyle(
                                                      color: kBlackColor,
                                                      fontFamily: 'QuickSand',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Radio(
                                                    activeColor: kPinkColor,
                                                    value: 'Work',
                                                    groupValue: addressType,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        addressType = val;
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Row(
                        children: [
                          confirm
                              ? Container()
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: kWhiteColor,
                                          elevation: 0,
                                          padding: EdgeInsets.all(10)),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: SavedAddress(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Saved Address',
                                        style: TextStyle(
                                            color: kPinkColor,
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPinkColor,
                                    elevation: 0.5,
                                    padding: EdgeInsets.all(13)),
                                onPressed: loading
                                    ? null
                                    : confirm
                                        ? () {
                                            validateAndSave();
                                          }
                                        : () {
                                            setState(() {
                                              confirm = true;
                                            });
                                          },
                                child: Text(
                                  loading
                                      ? 'Fetching Location'
                                      : confirm
                                          ? 'Save Address'
                                          : 'Confirm Location',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // constraints: BoxConstraints.tight(Size(30, 30)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 340,
                    height: 50,
                    // constraints: BoxConstraints.tight(Size(30, 30)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kWhiteColor,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        suffixIcon: Icon(
                          Icons.search,
                          color: kPinkColor,
                        ),
                        // filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        hintText: 'Search for your location',
                        hintStyle: kTextgrey,
                      ),
                      onChanged: (val) {
                        findPlace(val);
                      },
                    ),
                  ),
                ],
              ),
              // child: Container(
              //   constraints: BoxConstraints.tight(Size(30, 30)),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(60),
              //     color: Colors.white,
              //   ),
              //   child: IconButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     padding: EdgeInsets.zero,
              //     splashColor: Colors.white,
              //     highlightColor: Colors.white,
              //     icon: Icon(Icons.arrow_back),
              //     iconSize: 16,
              //   ),
              // ),
            ),
            Positioned(
              top: 60,
              child: placepredictionList.length != 0 &&
                      searchController.text.length >= 1
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return PredictionTile(
                              placePredictions: placepredictionList[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            thickness: 1,
                          ),
                          itemCount: placepredictionList.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length != 0) {
      var autoCompleteUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$googleAPI&sessiontoken=1234567890&components=country:in",
      );
      var res = await http.get(autoCompleteUrl);
      var result = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var predictions = result["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(
          () {
            placepredictionList = placesList;
          },
        );
      } else
        print("nothing found");
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  const PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    Icons.location_on,
                    size: 20,
                    color: kPinkColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  placePredictions.main_text,
                  overflow: TextOverflow.ellipsis,
                  style: kNavBarTitle1,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                placePredictions.secondary_text,
                overflow: TextOverflow.ellipsis,
                style: kNavBarTitle,
              ),
            )
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    var placeDetailsUrl = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleAPI",
    );

    var res = await http.get(placeDetailsUrl);
    var result = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (result["status"] == "OK") {
        print(result["result"]["formatted_address"]);
        print(result["result"]["geometry"]["location"]["lat"]);
        print(result["result"]["geometry"]["location"]["lng"]);
        // Address address = Address();
      }
    }
  }
}
