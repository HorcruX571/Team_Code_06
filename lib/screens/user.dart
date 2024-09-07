import 'package:bus_scheduling/widget/map_widget.dart';
import 'package:flutter/material.dart';
import 'dart:core'; // Optional, as dart:core is auto-included in Dart
import 'package:intl/intl.dart'; // For DateFormat
import '../data/bus_data.dart';
import 'booking_page.dart'; // Import the bus data

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<BusInfo> _filteredBuses = [];

  // Mock data for autocomplete suggestions (could be replaced with actual location data)
  final List<String> _suggestions = [
    'Lajpat Nagar',
    'Nehru Place',
    'Janakpuri',
    'India Gate',
    'New Delhi Railway Station',
    'Rohini',
    'Gurgaon',
    'Dwarka',
    'Connaught Place',
    'Noida',
    'Lajpat Nagar',
    'Karol Bagh',
    'Kashmere Gate',
    'Saket',
    'Vasant Kunj',
    'Sarojini Nagar',
    'Green Park',
    'Hauz Khas',
    'Ashok Vihar',
    'Pitam Pura',
    'Inderlok',
    'Rajouri Garden',
    'CP',
    'DLF Cyber City',
    'Faridabad',
    'South Ex',
    'Indirapuram',
    'DLF Phase 1',
    'Khan Market',
    'DLF Phase 2',
    'Pitampura',
    'DLF Cyber City',
    'Indirapuram',
  ];

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Search buses based on source, destination, and date/time (±30 minutes)
  void _searchBuses() {
    if (_selectedDate == null || _selectedTime == null) return;

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    TimeOfDay selectedTime = _selectedTime!;

    setState(() {
      _filteredBuses = busData.where((bus) {
        if (bus.source != _sourceController.text ||
            bus.destination != _destinationController.text) {
          return false;
        }

        // Check if the date matches
        if (bus.date != formattedDate) {
          return false;
        }

        // Check if time is within ±30 minutes
        TimeOfDay busTime =
            TimeOfDay.fromDateTime(DateFormat('HH:mm:ss').parse(bus.time));
        Duration difference = _timeDifference(busTime, selectedTime);

        return difference.inMinutes.abs() <= 30; // Allow ±30 minutes
      }).toList();
    });
  }

  // Function to calculate the difference between two times
  Duration _timeDifference(TimeOfDay time1, TimeOfDay time2) {
    final DateTime now = DateTime.now();
    final DateTime dateTime1 =
        DateTime(now.year, now.month, now.day, time1.hour, time1.minute);
    final DateTime dateTime2 =
        DateTime(now.year, now.month, now.day, time2.hour, time2.minute);
    return dateTime1.difference(dateTime2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Heading in a Container for better styling
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: const Text(
                      'Find Your Perfect Bus 🚌',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 228, 227, 227),
                        shadows: [
                          Shadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(3, 3))
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildAutocompleteField(
                      controller: _sourceController,
                      label: '🌍 Source',
                      suggestions: _suggestions),
                  const SizedBox(height: 20),
                  _buildAutocompleteField(
                      controller: _destinationController,
                      label: '🏙️ Destination',
                      suggestions: _suggestions),
                  const SizedBox(height: 20),

                  // Date Card
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: Colors.black45,
                    child: ListTile(
                      leading:
                          const Icon(Icons.date_range, color: Colors.blueGrey),
                      title: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : '📅 Select Date',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Time Card
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: Colors.black45,
                    child: ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.blueGrey),
                      title: Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : '⏰ Select Time',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () => _selectTime(context),
                    ),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _searchBuses,
                    child: const Text(
                      '🔍 Search Buses',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shadowColor: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Add the MapWidget below the search button
                  const MapWidget(),

                  const SizedBox(height: 30),
                  if (_filteredBuses.isNotEmpty) _buildBusList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required List<String> suggestions,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          controller: fieldTextEditingController,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.blueGrey),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on, color: Colors.blueGrey),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
            ),
          ),
        );
      },
    );
  }

  // Display list of buses
  Widget _buildBusList() {
    return Column(
      children: _filteredBuses.map((bus) {
        return Card(
          color: Colors.white.withOpacity(0.9),
          child: ListTile(
            leading: const Icon(Icons.directions_bus, color: Colors.blue),
            title: Text(
              'Bus ID: ${bus.busID}',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                'From ${bus.source} to ${bus.destination} | Available seats: ${bus.capacity}'),
            onTap: () {
              // Navigate to the booking page with the selected bus details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPage(
                    busId: bus.busID.toString(),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
