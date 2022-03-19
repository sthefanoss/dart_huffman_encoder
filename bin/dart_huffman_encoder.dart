import 'encoders.dart';
import 'math.dart';

void main(List<String> arguments) {
  final symbols = [
    Tuple(1, .5),
    Tuple(2, .125),
    Tuple(3, .125),
    Tuple(4, .125),
    Tuple(5, .0625),
    Tuple(6, .0625),
  ];

  final maxValue = symbols.fold<int>(
    0,
    (value, current) => value = (current.first > value) ? current.first : value,
  );

  final binaryDictionary = IntBinaryDictionary(maxValue);

  final huffmanDictionary = HuffmanDictionary(symbols);
  print('\n$huffmanDictionary\n');

  final randomInput = randomDistribution(symbols, 1000);
  final encodedInputWithHuffman = huffmanDictionary.encode(randomInput);
  final encodedInputWithBinary = binaryDictionary.encode(randomInput);
  final decodedWithHuffman = huffmanDictionary.decode(encodedInputWithHuffman);
  final decodedWithBinary = binaryDictionary.decode(encodedInputWithBinary);
  print('input:\n $randomInput\n');
  print('Output from huffman compression:\n$encodedInputWithHuffman\n');
  print('Did huffman decode the data same as input?\n'
      '${listComparator(randomInput, decodedWithHuffman)}\n');
  print('Output from binary compression:\n$encodedInputWithBinary\n');
  print('Did binary decode the data same as input?\n'
      '${listComparator(randomInput, decodedWithBinary)}\n');
  print('size reduction with huffman compared to binary:'
      '${(100 * (encodedInputWithBinary.length - encodedInputWithHuffman.length) //
          / encodedInputWithBinary.length).toStringAsFixed(2)}%');
}

bool listComparator<T>(List<T> a, List<T> b) {
  if (a.length != b.length) {
    print('i fudeu');
    return false;
  }
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
