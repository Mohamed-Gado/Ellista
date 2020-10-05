class Bill {
  final String id;
  final double totalPrice;
  final Map<String, dynamic> names;
  final Map<String, dynamic> quantity;
  final Map<String, dynamic> prices;
  final DateTime time;

  Bill({
    this.id,
    this.totalPrice,
    this.names,
    this.quantity,
    this.prices,
    this.time,
  });
}
