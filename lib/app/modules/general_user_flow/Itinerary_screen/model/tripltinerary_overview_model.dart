class Trip {
  final String id;
  final String destination;
  final String country;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final double budget;
  final String currency;
  final List<String> activities;
  final List<Accommodation> accommodations;
  final List<Transport> transports;

  Trip({
    required this.id,
    required this.destination,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.budget,
    required this.currency,
    List<String>? activities,
    List<Accommodation>? accommodations,
    List<Transport>? transports,
  })
      : activities = activities ?? [],
        accommodations = accommodations ?? [],
        transports = transports ?? [];

  // JSON conversion methods
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] ?? '',
      destination: json['destination'] ?? '',
      country: json['country'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
      duration: json['duration'] ?? 0,
      budget: (json['budget'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      activities: List<String>.from(json['activities'] ?? []),
      accommodations: (json['accommodations'] as List?)
          ?.map((e) => Accommodation.fromJson(e))
          .toList() ?? [],
      transports: (json['transports'] as List?)
          ?.map((e) => Transport.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'country': country,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'duration': duration,
      'budget': budget,
      'currency': currency,
      'activities': activities,
      'accommodations': accommodations.map((e) => e.toJson()).toList(),
      'transports': transports.map((e) => e.toJson()).toList(),
    };
  }
}

class Accommodation {
  final String id;
  final String name;
  final String type; // Hotel, Hostel, Airbnb, etc.
  final String address;
  final double price;
  final DateTime checkIn;
  final DateTime checkOut;
  final String bookingUrl;
  final String imagePath;

  Accommodation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.price,
    required this.checkIn,
    required this.checkOut,
    required this.bookingUrl,
    required this.imagePath,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      checkIn: DateTime.parse(json['checkIn'] ?? DateTime.now().toString()),
      checkOut: DateTime.parse(json['checkOut'] ?? DateTime.now().toString()),
      bookingUrl: json['bookingUrl'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'price': price,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'bookingUrl': bookingUrl,
      'imagePath': imagePath,
    };
  }
}

class Transport {
  final String id;
  final String type; // Flight, Train, Bus, etc.
  final String from;
  final String to;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String bookingUrl;
  final String provider;

  Transport({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.bookingUrl,
    required this.provider,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      departureTime: DateTime.parse(json['departureTime'] ?? DateTime.now().toString()),
      arrivalTime: DateTime.parse(json['arrivalTime'] ?? DateTime.now().toString()),
      price: (json['price'] ?? 0).toDouble(),
      bookingUrl: json['bookingUrl'] ?? '',
      provider: json['provider'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'from': from,
      'to': to,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'bookingUrl': bookingUrl,
      'provider': provider,
    };
  }
}

class Activity {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String time;
  final double duration;
  final double price;
  final String location;
  final bool isAdded;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
    required this.location,
    this.isAdded = false,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      time: json['time'] ?? '',
      duration: (json['duration'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      isAdded: json['isAdded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'time': time,
      'duration': duration,
      'price': price,
      'location': location,
      'isAdded': isAdded,
    };
  }

  Activity copyWith({bool? isAdded}) {
    return Activity(
      id: id,
      title: title,
      description: description,
      category: category,
      date: date,
      time: time,
      duration: duration,
      price: price,
      location: location,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}