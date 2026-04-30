import 'package:get/get.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/tripltinerary_overview_model.dart';

class TripController extends GetxController {
  // Observables
  Rx<Trip> currentTrip = Trip(
    id: '1',
    destination: 'Rome',
    country: 'Italy',
    startDate: DateTime(2025, 3, 16),
    endDate: DateTime(2025, 3, 28),
    duration: 5,
    budget: 880.00,
    currency: 'USD',
  ).obs;

  RxInt selectedTabIndex = 0.obs;
  RxList<Activity> suggestedActivities = <Activity>[].obs;
  RxList<Activity> selectedActivities = <Activity>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Create accommodations list
    final accommodations = [
      Accommodation(
        id: '1',
        name: 'Hostelworld',
        type: 'Hostel',
        address: 'Via della Penitenza 19, Rome',
        price: 150.00,
        checkIn: DateTime(2025, 3, 16),
        checkOut: DateTime(2025, 3, 28),
        bookingUrl: 'https://hostelworld.com',
        imagePath: 'assets/images/rome.png',
      ),
      Accommodation(
        id: '2',
        name: 'Airbnb',
        type: 'Apartment',
        address: 'Via Nazionale, Rome',
        price: 280.00,
        checkIn: DateTime(2025, 3, 16),
        checkOut: DateTime(2025, 3, 28),
        bookingUrl: 'https://airbnb.com',
        imagePath: 'assets/images/airbnb.png',
      ),
      Accommodation(
        id: '3',
        name: 'Booking.com',
        type: 'Hotel',
        address: 'Via del Corso, Rome',
        price: 420.00,
        checkIn: DateTime(2025, 3, 16),
        checkOut: DateTime(2025, 3, 28),
        bookingUrl: 'https://booking.com',
        imagePath: 'assets/images/hotel.png',
      ),
    ];

    // Create transports list
    final transports = [
      Transport(
        id: '1',
        type: 'Flight',
        from: 'Your City',
        to: 'Rome',
        departureTime: DateTime(2025, 3, 16, 10, 0),
        arrivalTime: DateTime(2025, 3, 16, 20, 30),
        price: 450.00,
        bookingUrl: 'https://skyscanner.com',
        provider: 'Skyscanner',
      ),
      Transport(
        id: '2',
        type: 'Bus',
        from: 'Rome Airport',
        to: 'City Center',
        departureTime: DateTime(2025, 3, 16, 21, 0),
        arrivalTime: DateTime(2025, 3, 16, 22, 30),
        price: 15.00,
        bookingUrl: 'https://flixbus.com',
        provider: 'FlixBus',
      ),
    ];

    // Create new trip with mutable lists
    currentTrip.value = Trip(
      id: '1',
      destination: 'Rome',
      country: 'Italy',
      startDate: DateTime(2025, 3, 16),
      endDate: DateTime(2025, 3, 28),
      duration: 5,
      budget: 880.00,
      currency: 'USD',
      accommodations: accommodations,
      transports: transports,
    );

    // Sample activities
    suggestedActivities.addAll([
      Activity(
        id: '1',
        title: 'Colosseum Tour',
        description: 'Explore the iconic Colosseum with a guided tour',
        category: 'Historical',
        date: DateTime(2025, 3, 17),
        time: '09:00 AM',
        duration: 2.5,
        price: 25.00,
        location: 'Colosseum, Rome',
      ),
      Activity(
        id: '2',
        title: 'Vatican City Tour',
        description: 'Visit the Vatican Museums and Sistine Chapel',
        category: 'Religious',
        date: DateTime(2025, 3, 18),
        time: '10:00 AM',
        duration: 4.0,
        price: 35.00,
        location: 'Vatican City',
      ),
      Activity(
        id: '3',
        title: 'Trevi Fountain Visit',
        description: 'See the stunning Trevi Fountain and throw a coin',
        category: 'Cultural',
        date: DateTime(2025, 3, 19),
        time: '05:00 PM',
        duration: 1.5,
        price: 0.00,
        location: 'Trevi Fountain',
      ),
      Activity(
        id: '4',
        title: 'Roman Forum Walk',
        description: 'Walk through the historic Roman Forum',
        category: 'Historical',
        date: DateTime(2025, 3, 20),
        time: '08:00 AM',
        duration: 2.0,
        price: 15.00,
        location: 'Roman Forum',
      ),
      Activity(
        id: '5',
        title: 'Italian Cooking Class',
        description: 'Learn to cook authentic Italian pasta',
        category: 'Food & Drink',
        date: DateTime(2025, 3, 21),
        time: '02:00 PM',
        duration: 3.0,
        price: 75.00,
        location: 'Via del Corso',
      ),
    ]);
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void addActivity(Activity activity) {
    final updatedActivity = activity.copyWith(isAdded: true);
    selectedActivities.add(updatedActivity);
    
    // Update suggested list
    final index = suggestedActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      suggestedActivities[index] = updatedActivity;
    }
  }

  void removeActivity(String activityId) {
    selectedActivities.removeWhere((a) => a.id == activityId);
    
    // Update suggested list
    final index = suggestedActivities.indexWhere((a) => a.id == activityId);
    if (index != -1) {
      suggestedActivities[index] = suggestedActivities[index].copyWith(isAdded: false);
    }
  }

  void addAccommodation(Accommodation accommodation) {
    if (!currentTrip.value.accommodations.any((a) => a.id == accommodation.id)) {
      currentTrip.value.accommodations.add(accommodation);
      currentTrip.refresh(); // Notify listeners
    }
  }

  void addTransport(Transport transport) {
    if (!currentTrip.value.transports.any((t) => t.id == transport.id)) {
      currentTrip.value.transports.add(transport);
      currentTrip.refresh(); // Notify listeners
    }
  }

  double getTotalCost() {
    double total = 0;
    total += currentTrip.value.accommodations.fold(0, (sum, a) => sum + a.price);
    total += currentTrip.value.transports.fold(0, (sum, t) => sum + t.price);
    total += selectedActivities.fold(0, (sum, a) => sum + a.price);
    return total;
  }

  String formatDate(DateTime date) {
    return AppDateFormatter.format(date);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}