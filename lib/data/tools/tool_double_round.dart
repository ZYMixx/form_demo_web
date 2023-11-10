class ToolDoubleRound {
  static double round({dynamic number, int length = 2}) {
    return double.parse(number.toStringAsFixed(length));
  }
}
