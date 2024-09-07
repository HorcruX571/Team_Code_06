import 'package:flutter/material.dart';
import '../data/bus_data.dart';
import 'select_seat_page.dart'; // Import the seat selection page

class BookingPage extends StatefulWidget {
  final String busId;

  const BookingPage({Key? key, required this.busId}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _gender;
  final List<String> _genders = ['Male', 'Female'];

  // Variables to store the input values for future use
  String? passengerName;
  int? passengerAge;
  String? passengerEmail;
  String? passengerPhone;
  String? selectedGender;

  BusInfo? _busInfo;

  @override
  void initState() {
    super.initState();
    _fetchBusInfo();
  }

  // Fetch the bus information based on busId
  void _fetchBusInfo() {
    final busDataList =
        busData.where((bus) => bus.busID.toString() == widget.busId).toList();
    if (busDataList.isNotEmpty) {
      setState(() {
        _busInfo = busDataList.first;
      });
    }
  }

  // Save the passenger's information in variables
  void _savePassengerInfo() {
    passengerName = _nameController.text;
    passengerAge = int.tryParse(_ageController.text);
    passengerEmail = _emailController.text;
    passengerPhone = _phoneController.text;
    selectedGender = _gender;
  }

  // Navigate to seat selection page and save passenger info
  void _navigateToSeatSelection() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      _savePassengerInfo(); // Save the passenger info
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectSeatPage(
            busId: widget.busId,
            passengerName: _nameController.text,
            passengerAge: int.parse(_ageController.text),
            source: _busInfo!.source,
            destination: _busInfo!.destination,
            date: _busInfo!.date,
          ),
        ),
      );
    }
  }

  // This is the missing _buildBusInfoCard method
  Widget _buildBusInfoCard() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bus Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bus ID: ${_busInfo!.busID}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'From: ${_busInfo!.source}',
                    style:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ),
                Expanded(
                  child: Text(
                    'To: ${_busInfo!.destination}',
                    style:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${_busInfo!.date}',
                    style:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Time: ${_busInfo!.time}',
                    style:
                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        centerTitle: true,
      ),
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
                  _busInfo != null
                      ? _buildBusInfoCard()
                      : const CircularProgressIndicator(),
                  const SizedBox(height: 30),
                  const Text(
                    'Passenger Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: 'Enter your age',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildGenderSelector(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contact Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email ID',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _navigateToSeatSelection,
                      child: const Text(
                        'SELECT SEAT',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100),
                        backgroundColor: Colors.white24,
                        side: const BorderSide(color: Colors.black54, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        hintStyle: const TextStyle(color: Colors.blueGrey),
        hintText: hint,
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
      ),
      items: _genders.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _gender = value;
        });
      },
      value: _gender,
    );
  }
}
