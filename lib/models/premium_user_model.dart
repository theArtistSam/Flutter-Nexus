import 'package:nexus/models/user_model.dart';

class PremiumUserModel extends UserModel {
  List<Card>? billingInfos;
  String? subscriptionPlan;
  String? startDate;
  String? lastPaymentDate;

  PremiumUserModel({
    String? userId,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    AccountStatus? accountStatus,
    String? profilePic,
    String? backgroundPic,
    String? biography,
    Guides? guides,
    AppCustomization? appCustomization,
    this.billingInfos,
    this.subscriptionPlan,
    this.startDate,
    this.lastPaymentDate,
  }) : super(
          userId: userId,
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          accountStatus: accountStatus,
          profilePic: profilePic,
          backgroundPic: backgroundPic,
          biography: biography,
          guides: guides,
          appCustomization: appCustomization,
        );

  PremiumUserModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['billing_infos'] != null) {
      billingInfos = <Card>[];
      json['billing_infos'].forEach((v) {
        billingInfos!.add(Card.fromJson(v));
      });
    }
    subscriptionPlan = json['subscription_plan'];
    startDate = json['start_date'];
    lastPaymentDate = json['last_payment_date'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (billingInfos != null) {
      data['billing_infos'] = billingInfos!.map((v) => v.toJson()).toList();
    }
    data['subscription_plan'] = subscriptionPlan;
    data['start_date'] = startDate;
    data['last_payment_date'] = lastPaymentDate;
    return data;
  }
}

class Card {
  String? name;
  String? cardNumber;
  String? cvv;
  String? expiryDate;
  bool? isActivated;

  Card(
      {this.name,
      this.cardNumber,
      this.cvv,
      this.expiryDate,
      this.isActivated});

  Card.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cardNumber = json['card_number'];
    cvv = json['cvv'];
    expiryDate = json['expiry_date'];
    isActivated = json['is_activated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['card_number'] = cardNumber;
    data['cvv'] = cvv;
    data['expiry_date'] = expiryDate;
    data['is_activated'] = isActivated;
    return data;
  }
}
