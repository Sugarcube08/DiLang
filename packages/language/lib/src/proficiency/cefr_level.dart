enum CefrLevel {
  a1(code: 'A1', name: 'Beginner', numericOrder: 1),
  a2(code: 'A2', name: 'Elementary', numericOrder: 2),
  b1(code: 'B1', name: 'Intermediate', numericOrder: 3),
  b2(code: 'B2', name: 'Upper Intermediate', numericOrder: 4),
  c1(code: 'C1', name: 'Advanced', numericOrder: 5),
  c2(code: 'C2', name: 'Proficient', numericOrder: 6);

  final String code;
  final String name;
  final int numericOrder;

  const CefrLevel({
    required this.code,
    required this.name,
    required this.numericOrder,
  });

  bool isAtLeast(CefrLevel target) => numericOrder >= target.numericOrder;
}
