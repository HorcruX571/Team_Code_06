import 'package:flutter/material.dart';
import '../data/bus_data.dart'; // Assuming bus data is imported from another file

class SelectSeatPage extends StatefulWidget {
  final String busId;
  final String passengerName; // Passenger's name
  final int passengerAge; // Passenger's age
  final String source; // Source location
  final String destination; // Destination location
  final String date; // Date of the journey

  const SelectSeatPage({
    Key? key,
    required this.busId,
    required this.passengerName,
    required this.passengerAge,
    required this.source,
    required this.destination,
    required this.date,
  }) : super(key: key);

  @override
  _SelectSeatPageState createState() => _SelectSeatPageState();
}

class _SelectSeatPageState extends State<SelectSeatPage> {
  List<List<Seat?>> seatLayout = [];
  Seat? _selectedSeat; // To keep track of the currently selected seat

  @override
  void initState() {
    super.initState();
    _loadSeatData(); // Load seat data when page initializes
  }

  // Method to fetch bus data and generate seat layout
  void _loadSeatData() {
    BusInfo? bus = busData.firstWhere(
        (bus) => bus.busID.toString() == widget.busId,
        orElse: () => BusInfo(
            busID: 0,
            source: '',
            destination: '',
            date: '',
            time: '',
            capacity: 0));

    if (bus != null && bus.capacity > 0) {
      // Generate the seat layout based on the bus capacity
      int totalSeats = bus.capacity;
      int rows = (totalSeats / 4).ceil(); // 4 seats per row with an aisle
      seatLayout = List.generate(rows, (rowIndex) {
        // Simulating seat data
        return [
          Seat(
              status:
                  rowIndex % 2 == 0 ? SeatStatus.available : SeatStatus.booked),
          Seat(
              status:
                  rowIndex % 3 == 0 ? SeatStatus.female : SeatStatus.available),
          null, // Aisle
          Seat(
              status:
                  rowIndex % 2 == 0 ? SeatStatus.booked : SeatStatus.available),
          Seat(
              status:
                  rowIndex % 3 == 0 ? SeatStatus.female : SeatStatus.available),
        ];
      });
      setState(() {}); // Rebuild the UI with the new seat layout
    }
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus heading
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  child: Text(
                    'Select Your Seat for Bus ${widget.busId}',
                    style: const TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 25,
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
                const SizedBox(height: 20),
                // Passenger details
                _buildPassengerDetails(),
                const SizedBox(height: 20),
                // Seat layout (keep unchanged)
                seatLayout.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSeatLayout(),
                const SizedBox(height: 100), // To add some space above the FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Center the FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action for selecting a seat
        },
        label: const Text('Select Seat'),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  // Passenger details card
  Widget _buildPassengerDetails() {
    return SizedBox(
      width:
          double.infinity, // Ensure the box takes the full width of the screen
      child: Card(
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 8.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the text horizontally
            children: [
              const Text(
                '🚌 Passenger Details',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center the heading
              ),
              const SizedBox(height: 4), // Reduced space between elements
              Text(
                'Name: ${widget.passengerName}, Age: ${widget.passengerAge}',
                style: const TextStyle(
                    color: Colors.black87, fontSize: 14), // Reduced font size
                textAlign: TextAlign.center, // Center the text horizontally
              ),
              const SizedBox(height: 3), // Reduced space between lines
              Text(
                'Bus ID: ${widget.busId}',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 3),
              Text(
                'Route: ${widget.source} ➡️ ${widget.destination}',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                'Date: ${widget.date}',
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Seat layout code remains unchanged
  Widget _buildSeatLayout() {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Let parent scroll handle it
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 5 columns: 2 seats, aisle (null), 2 seats
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: seatLayout.length * 5, // Total items (5 per row)
      itemBuilder: (context, index) {
        int row = index ~/ 5; // Row index
        int col = index % 5; // Column index

        if (seatLayout[row][col] == null) {
          return const SizedBox.shrink(); // Aisle space
        }

        return GestureDetector(
          onTap: () => _selectSeat(row, col),
          child: _buildSeatIcon(seatLayout[row][col]!.status),
        );
      },
    );
  }

  // Build seat icon based on seat status (unchanged)
  Widget _buildSeatIcon(SeatStatus status) {
    Color color;
    IconData iconData = Icons.event_seat;

    switch (status) {
      case SeatStatus.available:
        color = Colors.green;
        break;
      case SeatStatus.booked:
        color = Colors.grey;
        break;
      case SeatStatus.female:
        color = const Color.fromARGB(255, 255, 96, 149);
        break;
      case SeatStatus.selected:
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  // Method to handle seat selection (unchanged)
  void _selectSeat(int row, int col) {
    setState(() {
      // Unselect the previously selected seat
      if (_selectedSeat != null) {
        _selectedSeat!.status = SeatStatus.available;
      }

      // Set the newly selected seat
      Seat? currentSeat = seatLayout[row][col];
      if (currentSeat != null && currentSeat.status == SeatStatus.available) {
        currentSeat.status = SeatStatus.selected;
        _selectedSeat = currentSeat;
      }
    });
  }
}

// Seat model for the seat layout
class Seat {
  SeatStatus status;
  Seat({required this.status});
}

enum SeatStatus { available, booked, female, selected }
