import 'individual_bar.dart';

class BarData{
  final double sunNo;
  final double monNo;
  final double tueNo;
  final double wedNo;
  final double thuNo;
  final double friNo;
  final double satNo;

  BarData({required this.sunNo,
    required this.monNo,
    required this.tueNo,
    required this.wedNo,
    required this.thuNo,
    required this.friNo,
    required this.satNo});

  List<IndividualBar> barData= [];

  void initializeBarData() {
    barData = [
// sun
      IndividualBar(x: 0, y: sunNo),
// mon
      IndividualBar(x: 1, y: monNo),
// tue
      IndividualBar(x: 2, y: tueNo),
// wed
      IndividualBar(x: 3, y: wedNo),
// thur
      IndividualBar(x: 4, y: thuNo),
// fri
      IndividualBar(x: 5, y: friNo),
// sat
      IndividualBar(x: 6, y: satNo),
    ];
  }
}