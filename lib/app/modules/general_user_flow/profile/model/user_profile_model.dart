

class UserProfileModel {
    final String? id;
    final String? fullName;
    final String? userName;
    final String? email;
    final dynamic phoneNumber;
    final String? password;
    final String? profileImage;
    final dynamic coverImage;
    final List<String>? tripsPlans;
    final String? age;
    final String? homeCountry;
    final String? passportCountry;
    final String? role;
    final String? status;
    final bool? isSocialLogin;
    final bool? emailVerified;
    final bool? isBlocked;
    final bool? isDeleted;
    final bool? isApproved;
    final bool? isProfileComplete;
    final bool? flightAlert;
    final bool? checkInReminders;
    final bool? delayUpdates;
    final bool? arriveAlerts;
    final bool? marketingEmails;
    final bool? passportAlert;
    final bool? pushNotifications;
    final bool? emailNotifications;
    final bool? newUserNotifications;
    final bool? tripMilestoneNotifications;
    final bool? userSuspensionNotifications;
    final int? lat;
    final int? lon;
    final dynamic suspendedUntil;
    final DateTime? lastLoginAt;
    final dynamic expirationOtp;
    final dynamic otp;
    final dynamic createdById;
    final dynamic fcmToken;
    final bool? onBoarding;
    final dynamic accountLink;
    final dynamic stripeAccountId;
    final dynamic customerId;
    final dynamic paymentMethodId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    UserProfileModel({
        this.id,
        this.fullName,
        this.userName,
        this.email,
        this.phoneNumber,
        this.password,
        this.profileImage,
        this.coverImage,
        this.tripsPlans,
        this.age,
        this.homeCountry,
        this.passportCountry,
        this.role,
        this.status,
        this.isSocialLogin,
        this.emailVerified,
        this.isBlocked,
        this.isDeleted,
        this.isApproved,
        this.isProfileComplete,
        this.flightAlert,
        this.checkInReminders,
        this.delayUpdates,
        this.arriveAlerts,
        this.marketingEmails,
        this.passportAlert,
        this.pushNotifications,
        this.emailNotifications,
        this.newUserNotifications,
        this.tripMilestoneNotifications,
        this.userSuspensionNotifications,
        this.lat,
        this.lon,
        this.suspendedUntil,
        this.lastLoginAt,
        this.expirationOtp,
        this.otp,
        this.createdById,
        this.fcmToken,
        this.onBoarding,
        this.accountLink,
        this.stripeAccountId,
        this.customerId,
        this.paymentMethodId,
        this.createdAt,
        this.updatedAt,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json["id"],
        fullName: json["fullName"],
        userName: json["userName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        profileImage: json["profileImage"],
        coverImage: json["coverImage"],
        tripsPlans: json["tripsPlans"] == null ? [] : List<String>.from(json["tripsPlans"]!.map((x) => x)),
        age: json["age"],
        homeCountry: json["homeCountry"],
        passportCountry: json["passportCountry"],
        role: json["role"],
        status: json["status"],
        isSocialLogin: json["isSocialLogin"],
        emailVerified: json["emailVerified"],
        isBlocked: json["isBlocked"],
        isDeleted: json["isDeleted"],
        isApproved: json["isApproved"],
        isProfileComplete: json["isProfileComplete"],
        flightAlert: json["flightAlert"],
        checkInReminders: json["checkInReminders"],
        delayUpdates: json["delayUpdates"],
        arriveAlerts: json["arriveAlerts"],
        marketingEmails: json["marketingEmails"],
        passportAlert: json["passportAlert"],
        pushNotifications: json["pushNotifications"],
        emailNotifications: json["emailNotifications"],
        newUserNotifications: json["newUserNotifications"],
        tripMilestoneNotifications: json["tripMilestoneNotifications"],
        userSuspensionNotifications: json["userSuspensionNotifications"],
        lat: json["lat"],
        lon: json["lon"],
        suspendedUntil: json["suspendedUntil"],
        lastLoginAt: json["lastLoginAt"] == null ? null : DateTime.parse(json["lastLoginAt"]),
        expirationOtp: json["expirationOtp"],
        otp: json["otp"],
        createdById: json["createdById"],
        fcmToken: json["fcmToken"],
        onBoarding: json["onBoarding"],
        accountLink: json["accountLink"],
        stripeAccountId: json["stripeAccountId"],
        customerId: json["customerId"],
        paymentMethodId: json["paymentMethodId"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "profileImage": profileImage,
        "coverImage": coverImage,
        "tripsPlans": tripsPlans == null ? [] : List<dynamic>.from(tripsPlans!.map((x) => x)),
        "age": age,
        "homeCountry": homeCountry,
        "passportCountry": passportCountry,
        "role": role,
        "status": status,
        "isSocialLogin": isSocialLogin,
        "emailVerified": emailVerified,
        "isBlocked": isBlocked,
        "isDeleted": isDeleted,
        "isApproved": isApproved,
        "isProfileComplete": isProfileComplete,
        "flightAlert": flightAlert,
        "checkInReminders": checkInReminders,
        "delayUpdates": delayUpdates,
        "arriveAlerts": arriveAlerts,
        "marketingEmails": marketingEmails,
        "passportAlert": passportAlert,
        "pushNotifications": pushNotifications,
        "emailNotifications": emailNotifications,
        "newUserNotifications": newUserNotifications,
        "tripMilestoneNotifications": tripMilestoneNotifications,
        "userSuspensionNotifications": userSuspensionNotifications,
        "lat": lat,
        "lon": lon,
        "suspendedUntil": suspendedUntil,
        "lastLoginAt": lastLoginAt?.toIso8601String(),
        "expirationOtp": expirationOtp,
        "otp": otp,
        "createdById": createdById,
        "fcmToken": fcmToken,
        "onBoarding": onBoarding,
        "accountLink": accountLink,
        "stripeAccountId": stripeAccountId,
        "customerId": customerId,
        "paymentMethodId": paymentMethodId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
