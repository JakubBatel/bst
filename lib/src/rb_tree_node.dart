import 'package:bst/src/binary_search_tree_base_node.dart';

class RBTreeNode<E> extends BinarySearchTreeBaseNode<E, RBTreeNode<E>> {
  bool black;

  RBTreeNode(super.value) : black = false;

  @override
  void setDataFrom(RBTreeNode<E> other) {
    black = other.black;
  }
}

extension RBTreeNodeColor on RBTreeNode? {
  bool get isBlack => this?.black ?? true;
  bool get isRed => !isBlack;
}
