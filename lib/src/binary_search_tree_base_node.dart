abstract class BinarySearchTreeBaseNode<E, Node extends BinarySearchTreeBaseNode<E, Node>> {
  final E value;

  Node? parent;
  Node? left;
  Node? right;

  bool get isLeftChild => identical(parent?.left, this);
  bool get isRightChild => identical(parent?.right, this);
  bool get isRoot => parent == null;

  BinarySearchTreeBaseNode(this.value);

  @override
  String toString() => value.toString();

  void setDataFrom(Node other);

  Node? successor() {
    if (right != null) {
      Node current = right!;
      while (current.left != null) {
        current = current.left!;
      }
      return current;
    }
    Node? current = this as Node;
    Node? ancestor = parent;
    while (ancestor != null && (current?.isRightChild ?? false)) {
      current = ancestor;
      ancestor = ancestor.parent;
    }
    return ancestor;
  }

  Node? predecessor() {
    if (left != null) {
      Node current = left!;
      while (current.right != null) {
        current = current.right!;
      }
      return current;
    }
    Node? current = this as Node;
    Node? ancestor = parent;
    while (ancestor != null && (current?.isLeftChild ?? false)) {
      current = ancestor;
      ancestor = ancestor.parent;
    }
    return ancestor;
  }

  Iterable<Node> inOrderTraversal() sync* {
    if (left != null) {
      yield* left!.inOrderTraversal();
    }
    yield this as Node;
    if (right != null) {
      yield* right!.inOrderTraversal();
    }
  }

  Iterable<Node> preOrderTraversal() sync* {
    yield this as Node;
    if (left != null) {
      yield* left!.inOrderTraversal();
    }
    if (right != null) {
      yield* right!.inOrderTraversal();
    }
  }

  Iterable<Node> postOrderTraversal() sync* {
    if (left != null) {
      yield* left!.inOrderTraversal();
    }
    if (right != null) {
      yield* right!.inOrderTraversal();
    }
    yield this as Node;
  }
}
