enum SeatStatus {
  available,
  booked,
  female,
  selected,
}

class Seat {
  final int seatNumber;
  SeatStatus status;

  Seat({
    required this.seatNumber,
    required this.status,
  });
}
