class UserModel {
  String? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? startDate;
  AccountStatus? accountStatus;
  String? profilePic;
  String? backgroundPic;
  String? biography;
  Guides? guides;
  AppCustomization? appCustomization;

  UserModel({
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.accountStatus,
    this.profilePic,
    this.backgroundPic,
    this.biography,
    this.startDate,
    this.guides,
    this.appCustomization,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    startDate = json["start_date"];
    userId = json['user_id'];
    email = json['email'];

    firstName = json['first_name'];
    lastName = json['last_name'];
    accountStatus = json['account_status'] != null
        ? AccountStatus.fromJson(json['account_status'])
        : null;
    profilePic = json['profile_pic'];
    backgroundPic = json['background_pic'];
    biography = json['biography'];
    guides = json['guides'] != null ? Guides.fromJson(json['guides']) : null;
    appCustomization = json['app_customization'] != null
        ? AppCustomization.fromJson(json['app_customization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["start_date"] = startDate;
    data['user_id'] = userId;
    data['email'] = email;

    data['first_name'] = firstName;
    data['last_name'] = lastName;
    if (accountStatus != null) {
      data['account_status'] = accountStatus!.toJson();
    }
    data['profile_pic'] = profilePic;
    data['background_pic'] = backgroundPic;
    data['biography'] = biography;
    if (guides != null) {
      data['guides'] = guides!.toJson();
    }
    if (appCustomization != null) {
      data['app_customization'] = appCustomization!.toJson();
    }
    return data;
  }
}

class AccountStatus {
  bool? isPremium;
  bool? isDeactivated;

  AccountStatus({this.isPremium, this.isDeactivated});

  AccountStatus.fromJson(Map<String, dynamic> json) {
    isPremium = json['is_premium'];
    isDeactivated = json['is_deactivated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_premium'] = isPremium;
    data['is_deactivated'] = isDeactivated;
    return data;
  }
}

class Guides {
  List<String>? viewedGuides;

  Guides({this.viewedGuides});

  Guides.fromJson(Map<String, dynamic> json) {
    viewedGuides = json['viewed_guides'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viewed_guides'] = viewedGuides;
    return data;
  }
}

class AppCustomization {
  bool? isDark;
  NotificationSettings? notificationSettings;

  AppCustomization({this.isDark, this.notificationSettings});

  AppCustomization.fromJson(Map<String, dynamic> json) {
    isDark = json['is_dark'];
    notificationSettings = json['notification_settings'] != null
        ? NotificationSettings.fromJson(json['notification_settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_dark'] = isDark;
    if (notificationSettings != null) {
      data['notification_settings'] = notificationSettings!.toJson();
    }
    return data;
  }
}

class NotificationSettings {
  bool? communityNotisEnabled;
  bool? appNotisEnabled;

  NotificationSettings({this.communityNotisEnabled, this.appNotisEnabled});

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    communityNotisEnabled = json['community_notis_enabled'];
    appNotisEnabled = json['app_notis_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['community_notis_enabled'] = communityNotisEnabled;
    data['app_notis_enabled'] = appNotisEnabled;
    return data;
  }
}
