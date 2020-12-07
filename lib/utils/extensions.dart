import 'dart:math';

import 'package:TimeAverage/commands/average-command.dart';

extension Trig on num {
  num get toDegrees => this * 180 / pi;
  num get toRadians => this * pi / 180;
}
extension Pad on int {
  String zpl(int width) => toString().padLeft(width, '0');
}
extension IterableT<T> on Iterable<T> {
  Iterable<List<T>> zip(Iterable<T> other) {
    assert(length == other.length);
    return [
      for (int i = 0; i < length; i++) [elementAt(i), other.elementAt(i)]
    ];
  }
}
extension IterableNum on Iterable<num> {
  static final String _rangeInputSizeErrorMessage =
  '''The iterable upon which the "range" getter was invoked has invalid size.
       Make sure there are only 2 num elements in the iterable.''';

  ///Returns the sum of the elements as a BigInt to avoid overflow
  BigInt get sum => fold(BigInt.zero, (l, r) => l + BigInt.from(r));

  ///Returns the product of the elements as a BigInt to avoid overflow
  BigInt get product => fold(BigInt.one, (l, r) => l * BigInt.from(r));

  ///Returns the summary stats for this iterable. Stats include,
  ///sum, product, max, min, count, and range
  NumSummaryStatistics get stats => NumSummaryStatistics(this);

  ///returns an iterable containing all the ints in the given range, inclusive
  ///
  /// Notice that the input is `num` not `int`.
  Iterable<int> get range {
    if (length != 2) throw ArgumentError(_rangeInputSizeErrorMessage);
    var it = iterator;
    var start = (it..moveNext()).current;
    var end = (it..moveNext()).current;
    return [for (int i = start.ceil(); i <= end; i++) i];
  }
}