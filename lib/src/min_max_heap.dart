typedef Comparator<E> = int Function(E a, E b);

class MinMaxHeap<E> {
  final bool max;
  final List<E> _heap;
  final Comparator<E> _comparator;

  bool get isEmpty => _heap.isEmpty;

  E get first => _heap.first;

  const MinMaxHeap({this.max = false, Comparator<E>? comparator})
      : _heap = const [],
        _comparator = comparator ?? _defaultComparator,
        assert(comparator != null || E is Comparable<E>);

  void insert(E value) {
    _heap.add(value);
    _heapify();
  }

  void remove(E value) {
    final index = _locate(value);
    if (index == -1) {
      return;
    }
    _swap(index, 0);
    _heap.removeAt(0);
    _heapify();
  }

  bool contains(E value) => _locate(value) != -1;

  E? before(E value) {
    final index = _locate(value);
    // There is no parent for elements
    // - that are not in the heap
    // - that are the root element
    if (index <= 0) {
      return null;
    }
    return _heap[_getParentIndex(index)];
  }

  E? after(E value) {
    final index = _locate(value);
    // There is no next element for elements that are not in the heap
    if (index == -1) {
      return null;
    }
    final leftElement = _atIndexOrNull(_getLeftIndex(index));
    final rightElement = _atIndexOrNull(_getRightIndex(index));

    if (rightElement == null) {
      return leftElement;
    }
    if (leftElement == null) {
      return null;
    }
    final cmp = _comparator(leftElement, rightElement);
    if (cmp <= 0) {
      return leftElement;
    }
    return rightElement;
  }

  void _heapify() {
    var i = 0;
    while (i != 0) {
      final parentIndex = _getParentIndex(i);
      if (_comparator(_heap[i], _heap[_getParentIndex(i)]) >= 0) {
        return;
      }
      _swap(i, parentIndex);
      i = parentIndex;
    }
  }

  int _getParentIndex(int index) {
    return (index - 1) ~/ 2;
  }

  int _getLeftIndex(int index) {
    return 2 * index + 1;
  }

  int _getRightIndex(int index) {
    return 2 * index + 2;
  }

  E? _atIndexOrNull(int index) {
    if (index < 0 || index >= _heap.length) {
      return null;
    }
    return _heap[index];
  }

  void _swap(int indexA, int indexB) {
    E tmp = _heap[indexA];
    _heap[indexA] = _heap[indexB];
    _heap[indexB] = tmp;
  }

  int _locate(E value) {
    var i = 0;
    do {
      final elem = _heap[i];
      final comp = _comparator(elem, value);
      // Found the element
      if (comp == 0) {
        if (elem == value) {
          return i;
        }
        // Comparator and element comparison are different continue left
        i = _getLeftIndex(i);
      }
      if (comp < 0) {
        i = _getLeftIndex(i);
      }
      if (comp > 0) {
        i = _getRightIndex(i);
      }
    } while (i < _heap.length);
    return -1;
  }

  static int _defaultComparator<E>(E a, E b) => (a as Comparable<E>).compareTo(b);
}
