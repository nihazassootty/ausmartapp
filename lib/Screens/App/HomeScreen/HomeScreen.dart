import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maafos/Commons/AppConstants.dart';
import 'package:maafos/Commons/ColorConstants.dart';
import 'package:maafos/Commons/SnackBar.dart';
import 'package:maafos/Commons/TextStyles.dart';
import 'package:maafos/Commons/zerostate.dart';
import 'package:maafos/Components/ActiveMessageCard.dart';
import 'package:maafos/Components/BannerCard.dart';
import 'package:maafos/Components/CartBottomCard.dart';
import 'package:maafos/Providers/GetDataProvider.dart';
import 'package:maafos/Providers/GroceryProvider.dart';
import 'package:maafos/Providers/PopularProvider.dart';
import 'package:maafos/Providers/StoreProvider.dart';
import 'package:maafos/Screens/App/Address.dart';
import 'package:maafos/Screens/App/HomeScreen/BottomNav.dart';
import 'package:maafos/Screens/App/HomeScreen/CategoryScreen.dart';
import 'package:maafos/Screens/App/HomeScreen/NearbyScreen.dart';
import 'package:maafos/Screens/App/HomeScreen/PopularScreen.dart';
import 'package:maafos/Screens/App/HomeScreen/QuickScreen.dart';
import 'package:maafos/Screens/App/HomeScreen/RecommendedScreen.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  Future _check() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return showSnackBar(
          duration: Duration(milliseconds: 10000),
          context: context,
          message: "Please Enable Location Permission");
    }
    if (permission == LocationPermission.denied) {
      LocationPermission newpermission = await Geolocator.requestPermission();
      if (newpermission == LocationPermission.deniedForever ||
          newpermission == LocationPermission.denied) {
        openAppSettings();
        return showSnackBar(
            duration: Duration(milliseconds: 10000),
            context: context,
            message: "Please Enable Location Permission");
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var addresses =
          await Geocoder.google(googleAPI).findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude),
      );
      var check = {
        "address": 'Current Location',
        "latitude": position.latitude,
        "longitude": position.longitude,
        "fullAddress": addresses.first.addressLine
      };
      Provider.of<GetDataProvider>(context, listen: false)
          .setCustomerLocation(check);
      Provider.of<StoreProvider>(context, listen: false).fetchStores(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<GroceryProvider>(context, listen: false).fetchGrocery(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<PopularProvider>(context, listen: false).fetchCategory();
    }
    if (permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var addresses = await Geocoder.google(googleAPI)
          .findAddressesFromCoordinates(
              Coordinates(position.latitude, position.longitude));
      var check = {
        "address": 'Current Location',
        "latitude": position.latitude,
        "longitude": position.longitude,
        "fullAddress": addresses.first.addressLine
      };

      Provider.of<GetDataProvider>(context, listen: false)
          .setCustomerLocation(check);
      Provider.of<StoreProvider>(context, listen: false).fetchStores(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<GroceryProvider>(context, listen: false).fetchGrocery(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<PopularProvider>(context, listen: false).fetchCategory();
    }
    if (permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var addresses = await Geocoder.google(googleAPI)
          .findAddressesFromCoordinates(
              Coordinates(position.latitude, position.longitude));
      var check = {
        "address": 'Current Location',
        "latitude": position.latitude,
        "longitude": position.longitude,
        "fullAddress": addresses.first.addressLine
      };

      Provider.of<GetDataProvider>(context, listen: false)
          .setCustomerLocation(check);
      Provider.of<StoreProvider>(context, listen: false).fetchStores(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<GroceryProvider>(context, listen: false).fetchGrocery(
          latitude: position.latitude,
          longitude: position.longitude,
          context: context);
      Provider.of<PopularProvider>(context, listen: false).fetchCategory();
    }
  }

  Future _refreshStores() async {
    final customer = Provider.of<GetDataProvider>(context, listen: false);
    Provider.of<StoreProvider>(context, listen: false).fetchStores(
        latitude: customer.latitude,
        longitude: customer.longitude,
        context: context);
    Provider.of<GroceryProvider>(context, listen: false).fetchGrocery(
        latitude: customer.latitude,
        longitude: customer.longitude,
        context: context);
    Provider.of<PopularProvider>(context, listen: false).fetchCategory();
  }

  Future _loadMoreStores() async {
    final customer = Provider.of<GetDataProvider>(context, listen: false);
    final store = Provider.of<StoreProvider>(context, listen: false);
    if (store.isPagination)
      Provider.of<StoreProvider>(context, listen: false).loadMoreStores(
          latitude: customer.latitude, longitude: customer.longitude);
  }

  @override
  void initState() {
    final customer = Provider.of<GetDataProvider>(context, listen: false);
    if (customer.currentAddress == 'Current Location') _check();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreStores();
      }
    });
    super.initState();
    // initializeFCM();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     print('notification:${message.notification.title}');
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: new AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.0),
          ),
        ),
        backgroundColor: kPinkColor,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Icon(Icons.menu),
        // ),
        title: SvgPicture.asset(
          "assets/svg/logowhite.svg",
          height: 20,
        ),
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              height: 150.0,
              width: 30.0,
              child: new IconButton(
                icon: new Icon(
                  Icons.notifications_active_outlined,
                  color: kWhiteColor,
                ),
                onPressed: null,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigation(
                        index: 1,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search for hotels and dishes',
                          style: kTextgrey,
                        ),
                        Icon(
                          Icons.search,
                          size: 20,
                          color: kGreyLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0, 55, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Consumer<GetDataProvider>(
                          builder: (context, details, child) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapAddress(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: kPinkColor,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      details.fullAddress,
                                      style: kText143,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: cartBottomCard(),
      body: Consumer<StoreProvider>(
        builder: (context, data, child) => RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => _refreshStores(),
          child: data.isServicable
              ? SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/123.png',
                              width: 180,
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: SvgPicture.asset(
                                'assets/svg/whatsapp.svg',
                                height: 22,
                                color: const Color(0xff444444),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        QuickScreen(),
                        SizedBox(
                          height: 20,
                        ),
                        MessageCard(data: data.store.branch?.activeMessage),
                        SizedBox(
                          height: 20,
                        ),
                        PopularScreen(),
                        BannerScreen(),
                        SizedBox(
                          height: 20,
                        ),
                        CategoryScreen(),
                        SizedBox(
                          height: 20,
                        ),
                        RecommendedScreen(),
                        SizedBox(
                          height: 20,
                        ),
                        NearbyScreen(),
                      ],
                    ),
                  ),
                )
              : data.errorCode == 100
                  ? zerostate(
                      size: 220,
                      icon: 'assets/svg/noavailable.svg',
                      head: 'Wish We Were Here!',
                      sub: "We don't currently deliver here yet.",
                    )
                  : zerostate(
                      size: 140,
                      icon: 'assets/svg/noservice.svg',
                      head: 'Dang!',
                      sub: "We are currently under maintenance",
                    ),
        ),
      ),
    );
  }
}
