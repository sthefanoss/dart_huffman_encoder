import 'huffman.dart';

void main(List<String> arguments) {
  print(HuffmanDictionary(
    [
      Tuple('a1', 0.35),
      Tuple('a2', 0.3),
      Tuple('a3', 0.25),
      Tuple('a4', 0.1),
    ],
  ));
  print('\n');
  print(HuffmanDictionary(
    [
      Tuple('a1', 0.4),
      Tuple('a2', 0.2),
      Tuple('a3', 0.2),
      Tuple('a4', 0.1),
      Tuple('a5', 0.1),
    ],
  ));
  print('\n');
  print(HuffmanDictionary(
    [
      Tuple('a1', 0.2),
      Tuple('a2', 0.2),
      Tuple('a3', 0.25),
      Tuple('a4', 0.05),
      Tuple('a5', 0.15),
      Tuple('a6', 0.15),
    ],
  ));
}
