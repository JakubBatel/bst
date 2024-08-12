import 'package:bst/src/binary_search_tree_base_node.dart';
import 'package:meta/meta.dart';

abstract class BinarySearchTreeBase<E, Node extends BinarySearchTreeBaseNode<E, Node>> {
  @protected
  Node? root;

  @protected
  int nodeCount = 0;

  @protected
  Comparator<E> comparator;

  bool get isEmpty => root == null;
  int get size => nodeCount;

  BinarySearchTreeBase([Comparator<E>? comparator]) : comparator = comparator ?? _defaultComparator {
    if (comparator == null && E is! Comparable<E>) {
      throw ArgumentError('Specify comparator or use E that implements Comparable<E>', 'comparator');
    }
  }

  bool contains(E value) => findNode(value) != null;

  Node? findNode(E value) {
    Node? currentNode = root;
    while (currentNode != null) {
      final cmp = comparator(value, currentNode.value);
      if (cmp == 0) {
        return currentNode;
      }
      if (cmp < 0) {
        currentNode = currentNode.left;
      } else {
        currentNode = currentNode.right;
      }
    }
    return null;
  }

  Node? insert(E value) {
    final newNode = createNodeForValue(value);
    Node? currentNodeParent;
    Node? currentNode = root;

    while (currentNode != null) {
      currentNodeParent = currentNode;
      final cmp = comparator(value, currentNode.value);
      if (cmp < 0) {
        currentNode = currentNode.left;
      } else if (cmp > 0) {
        currentNode = currentNode.right;
      } else {
        // Node already part of the tree
        return null;
      }
    }

    newNode.parent = currentNodeParent;
    if (currentNodeParent == null) {
      root = newNode;
    } else {
      final cmp = comparator(value, currentNodeParent.value);
      if (cmp < 0) {
        currentNodeParent.left = newNode;
      } else {
        currentNodeParent.right = newNode;
      }
    }

    nodeCount++;
    return newNode;
  }

  Node? remove(E value) {
    Node? z = findNode(value);
    if (z == null) {
      return null;
    }

    Node? x;
    Node? y = z;
    if (z.left == null) {
      x = z.right;
      _transplant(z, z.right);
    } else if (z.right == null) {
      x = z.left;
      _transplant(z, z.left);
    } else {
      y = _minimum(z.right);
      x = y?.right;
      if (identical(y?.parent, z)) {
        x?.parent = y;
      } else {
        _transplant(y, y?.right);
        y?.right = z.right;
        y?.right?.parent = y;
      }
      _transplant(z, y);
      y?.left = z.left;
      y?.left?.parent = y;
      y?.setDataFrom(z);
    }

    nodeCount--;
    return y;
  }

  Iterable<Node> inOrderTraversal() => root?.inOrderTraversal() ?? const Iterable.empty();

  Iterable<Node> preOrderTraversal() => root?.preOrderTraversal() ?? const Iterable.empty();

  Iterable<Node> postOrderTraversal() => root?.postOrderTraversal() ?? const Iterable.empty();

  @protected
  Node createNodeForValue(E value);

  Node? _minimum(Node? node) {
    while (node?.left != null) {
      node = node?.left;
    }
    return node;
  }

  void _transplant(Node? u, Node? v) {
    if (u?.parent == null) {
      root = v;
    } else if (u == u?.parent?.left) {
      u?.parent?.left = v;
    } else {
      u?.parent?.right = v;
    }
    if (v != null) {
      v.parent = u?.parent;
    }
  }

  static int _defaultComparator<E>(E a, E b) => (a as Comparable<E>).compareTo(b);
}
