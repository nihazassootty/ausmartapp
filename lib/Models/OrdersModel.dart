// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

OrdersModel ordersModelFromJson(String str) =>
    OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  OrdersModel({
    this.data,
  });

  List<Datum> data;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.commissionDetail,
    this.orderNote,
    this.orderStatus,
    this.track,
    this.id,
    this.vendor,
    this.vendorType,
    this.items,
    this.discount,
    this.paymentType,
    this.address,
    this.customer,
    this.totalPackingAmount,
    this.subTotalAmount,
    this.deliveryTip,
    this.branch,
    this.totalAmount,
    this.vendorTotalAmount,
    this.vendorCommissionTotal,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.deliveryBoy,
  });

  CommissionDetail commissionDetail;
  List<dynamic> orderNote;
  String orderStatus;
  List<Track> track;
  String id;
  Vendor vendor;
  String vendorType;
  List<Item> items;
  dynamic discount;
  String paymentType;
  Address address;
  String customer;
  dynamic totalPackingAmount;
  dynamic subTotalAmount;
  dynamic deliveryTip;
  String branch;
  dynamic totalAmount;
  dynamic vendorTotalAmount;
  double vendorCommissionTotal;
  String orderId;
  String createdAt;
  String updatedAt;
  dynamic v;
  String deliveryBoy;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        commissionDetail: json["commissionDetail"] == null
            ? null
            : CommissionDetail.fromJson(json["commissionDetail"]),
        orderNote: json["orderNote"] == null
            ? null
            : List<dynamic>.from(json["orderNote"].map((x) => x)),
        orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
        track: json["track"] == null
            ? null
            : List<Track>.from(json["track"].map((x) => Track.fromJson(x))),
        id: json["_id"] == null ? null : json["_id"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
        vendorType: json["vendorType"] == null ? null : json["vendorType"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        discount: json["discount"] == null ? null : json["discount"],
        paymentType: json["paymentType"] == null ? null : json["paymentType"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        customer: json["customer"] == null ? null : json["customer"],
        totalPackingAmount: json["totalPackingAmount"] == null
            ? null
            : json["totalPackingAmount"],
        subTotalAmount:
            json["subTotalAmount"] == null ? null : json["subTotalAmount"],
        deliveryTip: json["deliveryTip"] == null ? null : json["deliveryTip"],
        branch: json["branch"] == null ? null : json["branch"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        vendorTotalAmount: json["vendorTotalAmount"] == null
            ? null
            : json["vendorTotalAmount"],
        vendorCommissionTotal: json["vendorCommissionTotal"] == null
            ? null
            : json["vendorCommissionTotal"].toDouble(),
        orderId: json["orderId"] == null ? null : json["orderId"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        v: json["__v"] == null ? null : json["__v"],
        deliveryBoy: json["deliveryBoy"] == null ? null : json["deliveryBoy"],
      );

  Map<String, dynamic> toJson() => {
        "commissionDetail":
            commissionDetail == null ? null : commissionDetail.toJson(),
        "orderNote": orderNote == null
            ? null
            : List<dynamic>.from(orderNote.map((x) => x)),
        "orderStatus": orderStatus == null ? null : orderStatus,
        "track": track == null
            ? null
            : List<dynamic>.from(track.map((x) => x.toJson())),
        "_id": id == null ? null : id,
        "vendor": vendor == null ? null : vendor.toJson(),
        "vendorType": vendorType == null ? null : vendorType,
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
        "discount": discount == null ? null : discount,
        "paymentType": paymentType == null ? null : paymentType,
        "address": address == null ? null : address.toJson(),
        "customer": customer == null ? null : customer,
        "totalPackingAmount":
            totalPackingAmount == null ? null : totalPackingAmount,
        "subTotalAmount": subTotalAmount == null ? null : subTotalAmount,
        "deliveryTip": deliveryTip == null ? null : deliveryTip,
        "branch": branch == null ? null : branch,
        "totalAmount": totalAmount == null ? null : totalAmount,
        "vendorTotalAmount":
            vendorTotalAmount == null ? null : vendorTotalAmount,
        "vendorCommissionTotal":
            vendorCommissionTotal == null ? null : vendorCommissionTotal,
        "orderId": orderId == null ? null : orderId,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "__v": v == null ? null : v,
        "deliveryBoy": deliveryBoy == null ? null : deliveryBoy,
      };
}

class Address {
  Address({
    this.address,
    this.landmark,
    this.coordinates,
    this.formattedAddress,
    this.addressType,
  });

  String address;
  String landmark;
  List<double> coordinates;
  String formattedAddress;
  String addressType;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"] == null ? null : json["address"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        formattedAddress:
            json["formattedAddress"] == null ? null : json["formattedAddress"],
        addressType: json["addressType"] == null ? null : json["addressType"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "landmark": landmark == null ? null : landmark,
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates.map((x) => x)),
        "formattedAddress": formattedAddress == null ? null : formattedAddress,
        "addressType": addressType == null ? null : addressType,
      };
}

class CommissionDetail {
  CommissionDetail({
    this.type,
    this.commission,
    this.commissionAmount,
  });

  String type;
  dynamic commission;
  double commissionAmount;

  factory CommissionDetail.fromJson(Map<String, dynamic> json) =>
      CommissionDetail(
        type: json["type"] == null ? null : json["type"],
        commission: json["commission"] == null ? null : json["commission"],
        commissionAmount: json["commissionAmount"] == null
            ? null
            : json["commissionAmount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "commission": commission == null ? null : commission,
        "commissionAmount": commissionAmount == null ? null : commissionAmount,
      };
}

class Item {
  Item({
    this.id,
    this.name,
    this.maafosPrice,
    this.price,
    this.offerPrice,
    this.packingCharge,
    this.qty,
    this.type,
  });

  String id;
  String name;
  dynamic maafosPrice;
  dynamic price;
  dynamic offerPrice;
  dynamic packingCharge;
  dynamic qty;
  String type;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        maafosPrice: json["maafosPrice"] == null ? null : json["maafosPrice"],
        price: json["price"] == null ? null : json["price"],
        offerPrice: json["offerPrice"] == null ? null : json["offerPrice"],
        packingCharge:
            json["packingCharge"] == null ? null : json["packingCharge"],
        qty: json["qty"] == null ? null : json["qty"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "maafosPrice": maafosPrice == null ? null : maafosPrice,
        "price": price == null ? null : price,
        "offerPrice": offerPrice == null ? null : offerPrice,
        "packingCharge": packingCharge == null ? null : packingCharge,
        "qty": qty == null ? null : qty,
        "type": type == null ? null : type,
      };
}

class Track {
  Track({
    this.info,
    this.code,
    this.detail,
    this.asset,
    this.status,
    this.updated,
  });

  String info;
  String code;
  String detail;
  String asset;
  bool status;
  String updated;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        info: json["info"] == null ? null : json["info"],
        code: json["code"] == null ? null : json["code"],
        detail: json["detail"] == null ? null : json["detail"],
        asset: json["asset"] == null ? null : json["asset"],
        status: json["status"] == null ? null : json["status"],
        updated: json["updated"] == null ? null : json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "info": info == null ? null : info,
        "code": code == null ? null : code,
        "detail": detail == null ? null : detail,
        "asset": asset == null ? null : asset,
        "status": status == null ? null : status,
        "updated": updated == null ? null : updated,
      };
}

class Vendor {
  Vendor({
    this.storeLogo,
    this.storeBg,
    this.location,
    this.contactNumber,
    this.quickDelivery,
    this.storeStatus,
    this.addons,
    this.featured,
    this.rating,
    this.id,
    this.name,
    this.branch,
    this.type,
    this.openTime,
    this.closeTime,
    this.cuisine,
    this.commission,
    this.dCommission,
    this.sortOrder,
    this.avgCookingTime,
    this.avgPersonAmt,
    this.gst,
    this.fssai,
    this.user,
    this.storeBanner,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Store storeLogo;
  Store storeBg;
  Location location;
  dynamic contactNumber;
  bool quickDelivery;
  bool storeStatus;
  List<dynamic> addons;
  bool featured;
  dynamic rating;
  String id;
  String name;
  String branch;
  String type;
  String openTime;
  String closeTime;
  String cuisine;
  dynamic commission;
  dynamic dCommission;
  dynamic sortOrder;
  dynamic avgCookingTime;
  dynamic avgPersonAmt;
  String gst;
  String fssai;
  String user;
  List<dynamic> storeBanner;
  List<Category> category;
  String createdAt;
  String updatedAt;
  dynamic v;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        storeLogo: json["storeLogo"] == null
            ? null
            : Store.fromJson(json["storeLogo"]),
        storeBg:
            json["storeBg"] == null ? null : Store.fromJson(json["storeBg"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        contactNumber:
            json["contactNumber"] == null ? null : json["contactNumber"],
        quickDelivery:
            json["quickDelivery"] == null ? null : json["quickDelivery"],
        storeStatus: json["storeStatus"] == null ? null : json["storeStatus"],
        addons: json["addons"] == null
            ? null
            : List<dynamic>.from(json["addons"].map((x) => x)),
        featured: json["featured"] == null ? null : json["featured"],
        rating: json["rating"] == null ? null : json["rating"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        branch: json["branch"] == null ? null : json["branch"],
        type: json["type"] == null ? null : json["type"],
        openTime: json["openTime"] == null ? null : json["openTime"],
        closeTime: json["closeTime"] == null ? null : json["closeTime"],
        cuisine: json["cuisine"] == null ? null : json["cuisine"],
        commission: json["commission"] == null ? null : json["commission"],
        dCommission: json["dCommission"] == null ? null : json["dCommission"],
        sortOrder: json["sortOrder"] == null ? null : json["sortOrder"],
        avgCookingTime:
            json["avgCookingTime"] == null ? null : json["avgCookingTime"],
        avgPersonAmt:
            json["avgPersonAmt"] == null ? null : json["avgPersonAmt"],
        gst: json["gst"] == null ? null : json["gst"],
        fssai: json["fssai"] == null ? null : json["fssai"],
        user: json["user"] == null ? null : json["user"],
        storeBanner: json["storeBanner"] == null
            ? null
            : List<dynamic>.from(json["storeBanner"].map((x) => x)),
        category: json["category"] == null
            ? null
            : List<Category>.from(
                json["category"].map((x) => Category.fromJson(x))),
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "storeLogo": storeLogo == null ? null : storeLogo.toJson(),
        "storeBg": storeBg == null ? null : storeBg.toJson(),
        "location": location == null ? null : location.toJson(),
        "contactNumber": contactNumber == null ? null : contactNumber,
        "quickDelivery": quickDelivery == null ? null : quickDelivery,
        "storeStatus": storeStatus == null ? null : storeStatus,
        "addons":
            addons == null ? null : List<dynamic>.from(addons.map((x) => x)),
        "featured": featured == null ? null : featured,
        "rating": rating == null ? null : rating,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "branch": branch == null ? null : branch,
        "type": type == null ? null : type,
        "openTime": openTime == null ? null : openTime,
        "closeTime": closeTime == null ? null : closeTime,
        "cuisine": cuisine == null ? null : cuisine,
        "commission": commission == null ? null : commission,
        "dCommission": dCommission == null ? null : dCommission,
        "sortOrder": sortOrder == null ? null : sortOrder,
        "avgCookingTime": avgCookingTime == null ? null : avgCookingTime,
        "avgPersonAmt": avgPersonAmt == null ? null : avgPersonAmt,
        "gst": gst == null ? null : gst,
        "fssai": fssai == null ? null : fssai,
        "user": user == null ? null : user,
        "storeBanner": storeBanner == null
            ? null
            : List<dynamic>.from(storeBanner.map((x) => x)),
        "category": category == null
            ? null
            : List<dynamic>.from(category.map((x) => x.toJson())),
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "__v": v == null ? null : v,
      };
}

class Category {
  Category({
    this.status,
    this.id,
    this.category,
  });

  bool status;
  String id;
  String category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        status: json["status"] == null ? null : json["status"],
        id: json["_id"] == null ? null : json["_id"],
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "_id": id == null ? null : id,
        "category": category == null ? null : category,
      };
}

class Location {
  Location({
    this.type,
    this.formattedAddress,
    this.address,
    this.coordinates,
    this.landmark,
  });

  String type;
  String formattedAddress;
  String address;
  List<double> coordinates;
  String landmark;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"] == null ? null : json["type"],
        formattedAddress:
            json["formattedAddress"] == null ? null : json["formattedAddress"],
        address: json["address"] == null ? null : json["address"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        landmark: json["landmark"] == null ? null : json["landmark"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "formattedAddress": formattedAddress == null ? null : formattedAddress,
        "address": address == null ? null : address,
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates.map((x) => x)),
        "landmark": landmark == null ? null : landmark,
      };
}

class Store {
  Store({
    this.key,
    this.image,
  });

  String key;
  String image;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        key: json["key"] == null ? null : json["key"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "image": image == null ? null : image,
      };
}
