class BarrierModel {
  final String barrier;

  BarrierModel({required this.barrier});

  factory BarrierModel.fromJson(Map<String, dynamic> json) {
    return BarrierModel(barrier: json['barrier']);
  }
}
