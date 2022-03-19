class InvalidSymbolException implements Exception {}

class Tuple<F, S> {
  final F first;

  final S second;

  const Tuple(this.first, this.second);
}

class HuffmanDictionary<T> {
  final _HuffmanNode<T> root;

  const HuffmanDictionary._(this.root);

  factory HuffmanDictionary(List<Tuple<T, num>> input) {
    final sortedInputByFrequency = [...input]..sort(_tupleComparator<T>);
    final inputAsLeaves = sortedInputByFrequency.map(_tupleMapper<T>).toList();
    final root = _findRootByMinimumVariance(inputAsLeaves);
    return HuffmanDictionary<T>._(root);
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

  T operator [](String key) {
    try {
      return root[key];
    } catch (_) {
      throw InvalidSymbolException();
    }
  }

  @override
  String toString() => root.toStringRecursive('');
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

  String toStringRecursive(String carry);
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
  String toStringRecursive(String carry) {
    return value.toString() + ' | ' + carry;
  }
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
  String toStringRecursive(String carry) {
    return leftNode.toStringRecursive(carry + '0') +
        '\n' +
        rightNode.toStringRecursive(carry + '1');
  }
}
