import 'dart:math';

class InvalidSymbolException implements Exception {}

class Tuple<F, S> {
  final F first;

  final S second;

  const Tuple(this.first, this.second);

  @override
  String toString() => '($first,$second)';
}

class HuffmanDictionary<T> {
  final double dataEntropy;

  final double meanLength;

  double get efficiency => dataEntropy / meanLength;

  final _HuffmanNode<T> root;

  final Map<T, String> _symbolToCodeMap;

  final Map<String, T> _codeToSymbolMap;

  const HuffmanDictionary._({
    required this.root,
    required Map<T, String> symbolToCodeMap,
    required Map<String, T> codeToSymbolMap,
    required this.dataEntropy,
    required this.meanLength,
  })  : _symbolToCodeMap = symbolToCodeMap,
        _codeToSymbolMap = codeToSymbolMap;

  factory HuffmanDictionary(List<Tuple<T, num>> input) {
    final sortedInputByFrequency = [...input]..sort(_tupleComparator<T>);
    final inputAsLeaves = sortedInputByFrequency.map(_tupleMapper<T>).toList();
    final root = _findRootByMinimumVariance(inputAsLeaves);
    final symbolToCodeMap = <T, String>{};
    final codeToSymbolMap = <String, T>{};
    double meanLength = 0;
    double entropy = 0;
    double probabilitySum = input.fold<double>(0, (sum, p) => sum + p.second);
    root.forEachLeafNode((leaf, code) {
      final normalizedProbability = leaf.frequency / probabilitySum;
      symbolToCodeMap[leaf.value] = code;
      codeToSymbolMap[code] = leaf.value;
      meanLength += code.length * normalizedProbability;
      entropy -= normalizedProbability * log(normalizedProbability) / ln2;
    });

    return HuffmanDictionary<T>._(
      root: root,
      symbolToCodeMap: symbolToCodeMap,
      codeToSymbolMap: codeToSymbolMap,
      dataEntropy: entropy,
      meanLength: meanLength,
    );
  }

  static int _tupleComparator<T>(Tuple a, Tuple b) {
    return b.second.compareTo(a.second);
  }

  static _HuffmanNode<T> _tupleMapper<T>(Tuple<T, num> tuple) {
    return _HuffmanNode<T>.leaf(tuple.first, tuple.second);
  }

  static _HuffmanNode<T> _findRootByMinimumVariance<T>(
    List<_HuffmanNode<T>> nodes,
  ) {
    while (nodes.length > 2) {
      final last = nodes.removeLast();
      final secondToLast = nodes.removeLast();
      final newBranch = _HuffmanNode<T>.branch(secondToLast, last);
      int i = nodes.indexWhere((v) => v.frequency <= newBranch.frequency);
      nodes.insert(i, newBranch);
    }

    return _HuffmanNode<T>.branch(nodes.first, nodes.last);
  }

  T? operator [](String key) => _codeToSymbolMap[key];

  String encode(List<T> data) {
    String buffer = '';
    for (final element in data) {
      buffer += _symbolToCodeMap[element]!;
    }
    return buffer;
  }

  List<T> decode(String byteCode) {
    final decodedData = <T>[];
    int bufferStart = 0;
    int bufferEnd = 1;
    while (true) {
      final buffer = byteCode.substring(bufferStart, bufferEnd);
      final maybeCode = _codeToSymbolMap[buffer];
      if (maybeCode == null) {
        bufferEnd++;
        continue;
      }
      decodedData.add(maybeCode);
      if (bufferEnd == byteCode.length) {
        return decodedData;
      }
      bufferStart = bufferEnd;
      bufferEnd = bufferStart;
    }
  }

  @override
  String toString() {
    return '$runtimeType('
        '${<String, dynamic>{
      'table': _codeToSymbolMap,
      'meanSymbolLength': meanLength,
      'dataEntropy': dataEntropy,
      'efficiency': efficiency,
    }}';
  }
}

abstract class _HuffmanNode<T> {
  factory _HuffmanNode.leaf(
    T value,
    num frequency,
  ) =>
      _HuffmanLeafNode<T>(value, frequency);

  factory _HuffmanNode.branch(
    _HuffmanNode<T> leftNode,
    _HuffmanNode<T> rightNode,
  ) =>
      _HuffmanBranchNode<T>(leftNode, rightNode);

  num get frequency;

  T operator [](String key);

  void forEachLeafNode(
    void Function(_HuffmanLeafNode<T> leaf, String code) callback, [
    String carry = '',
  ]);
}

class _HuffmanLeafNode<T> implements _HuffmanNode<T> {
  const _HuffmanLeafNode(this.value, this.frequency);

  final T value;

  @override
  final num frequency;

  @override
  T operator [](String key) {
    return value;
  }

  @override
  void forEachLeafNode(
    void Function(_HuffmanLeafNode<T>, String) callback, [
    String carry = '',
  ]) =>
      callback(this, carry);
}

class _HuffmanBranchNode<T> implements _HuffmanNode<T> {
  const _HuffmanBranchNode(this.leftNode, this.rightNode);

  final _HuffmanNode<T> leftNode;

  final _HuffmanNode<T> rightNode;

  @override
  num get frequency {
    return leftNode.frequency + rightNode.frequency;
  }

  @override
  T operator [](String key) {
    final nextKey = key.substring(1, key.length);
    return key[0] == '0' ? leftNode[nextKey] : rightNode[nextKey];
  }

  @override
  void forEachLeafNode(
    void Function(_HuffmanLeafNode<T>, String) callback, [
    String carry = '',
  ]) {
    leftNode.forEachLeafNode(callback, carry + '0');
    rightNode.forEachLeafNode(callback, carry + '1');
  }
}
