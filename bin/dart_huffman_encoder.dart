import 'dart:math';

import 'huffman.dart';

String intToBinary(int x) {
  return (x > 1 ? intToBinary(x >> 1) : '') + (x % 2 == 0 ? '0' : '1');
}

List<T> randomDistribution<T>(List<Tuple<T, num>> tuples, int length,
    [int? seed]) {
  final _random = Random(seed);
  final probabilitySum = tuples.fold<num>(
    0,
    (sum, element) => sum + element.second,
  );
  final normalizedProbabilities =
      tuples.map<double>((tuple) => tuple.second / probabilitySum).toList();
  final accumulativeNormalizedDistribution = <double>[];
  for (int i = 0; i < normalizedProbabilities.length; i++) {
    if (i == 0) {
      accumulativeNormalizedDistribution.add(normalizedProbabilities.first);
      continue;
    }
    accumulativeNormalizedDistribution.add(
      accumulativeNormalizedDistribution.last + normalizedProbabilities[i],
    );
  }

  return List<T>.generate(length, (_) {
    final _p = _random.nextDouble();
    for (int i = 0; i < tuples.length - 1; i++) {
      if (_p > accumulativeNormalizedDistribution[i]) {
        continue;
      }
      return tuples[i].first;
    }
    return tuples.last.first;
  });
}

List<Tuple<T, double>> histogram<T>(List<T> data) {
  final dataFrequencies = <T, double>{};
  for (final element in data) {
    dataFrequencies[element] = (dataFrequencies[element] ?? 0) + 1;
  }
  return dataFrequencies.entries
      .map<Tuple<T, double>>(
          (entry) => Tuple<T, double>(entry.key, entry.value / data.length))
      .toList();
}

void main(List<String> arguments) {
  final symbols = [
    Tuple(1, .5),
    Tuple(2, .125),
    Tuple(3, .125),
    Tuple(4, .125),
    Tuple(5, .0625),
    Tuple(6, .0625),
  ];

  final dictionary = HuffmanDictionary(symbols);
  print('\n$dictionary\n');
  for (int i = 1; i < 10; i++) {
    final randomText = randomDistribution(symbols, i);
    final encodedText = dictionary.encode(randomText);
    final decodedText = dictionary.decode(encodedText);
    print('encodedText:\n$encodedText\ndecodedText:$decodedText\n');

  }
}
