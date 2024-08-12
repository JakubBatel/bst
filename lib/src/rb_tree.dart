import 'package:bst/src/binary_search_tree_base.dart';
import 'package:bst/src/rb_tree_node.dart';

class RBTree<E> extends BinarySearchTreeBase<E, RBTreeNode<E>> {
  RBTree([super.comparator]);

  @override
  RBTreeNode<E> createNodeForValue(E value) => RBTreeNode(value);

  @override
  RBTreeNode<E>? insert(E value) {
    final newNode = super.insert(value);
    if (newNode != null) {
      _insertFixup(newNode);
    }
    return newNode;
  }

  @override
  RBTreeNode<E>? remove(E value) {
    final removedNode = super.remove(value);
    if (removedNode != null && removedNode.isBlack) {
      _removeFixup(removedNode);
    }
    return removedNode;
  }

  void _insertFixup(RBTreeNode<E>? z) {
    while (z != null && z.parent.isRed) {
      if (z.parent!.isLeftChild) {
        final y = z.parent!.parent?.right;
        if (y.isRed) {
          z.parent!.black = true;
          y?.black = true;
          z.parent!.parent?.black = false;
          z = z.parent!.parent;
        } else {
          if (z.isRightChild) {
            z = z.parent!;
            _leftRotate(z);
          }
          z.parent!.black = true;
          z.parent!.parent?.black = false;
          _rightRotate(z.parent!.parent);
        }
      } else {
        final y = z.parent!.parent?.left;
        if (y.isRed) {
          z.parent!.black = true;
          y!.black = true;
          z.parent!.parent?.black = false;
          z = z.parent!.parent;
        } else {
          if (z.isLeftChild) {
            z = z.parent!;
            _rightRotate(z);
          }
          z.parent!.black = true;
          z.parent!.parent?.black = false;
          _leftRotate(z.parent!.parent);
        }
      }
    }
    root!.black = true;
  }

  void _removeFixup(RBTreeNode<E>? x) {
    while (x != null && !identical(root, x) && x.isBlack) {
      RBTreeNode<E>? w;
      if (x.isLeftChild) {
        w = x.parent?.right;
        if (w.isRed) {
          w!.black = true;
          x.parent!.black = false;
          _leftRotate(x.parent!);
          w = x.parent!.right;
        }
        if ((w?.left).isBlack && (w?.right).isBlack) {
          w?.black = false;
          x = x.parent;
        } else {
          if ((w?.right).isBlack) {
            w?.left?.black = true;
            w?.black = false;
            _rightRotate(w);
            w = x.parent?.right;
          }
          w?.black = x.parent!.black;
          x.parent!.black = true;
          w?.right?.black = true;
          _leftRotate(x.parent!);
          x = root!;
        }
      } else {
        w = x.parent?.left;
        if (w.isRed) {
          w!.black = true;
          x.parent!.black = false;
          _rightRotate(x.parent!);
          w = x.parent!.left;
        }
        if ((w?.left).isBlack && (w?.right).isBlack) {
          w?.black = false;
          x = x.parent;
        } else {
          if ((w?.left).isBlack) {
            w?.right?.black = true;
            w?.black = false;
            _leftRotate(w);
            w = x.parent?.left;
          }
          w?.black = x.parent!.black;
          x.parent!.black = true;
          w?.left?.black = true;
          _rightRotate(x.parent!);
          x = root!;
        }
      }
    }
    x?.black = true;
  }

  void _leftRotate(RBTreeNode<E>? x) {
    if (x == null) {
      return;
    }

    final y = x.right;
    x.right = y?.left;
    y?.left?.parent = x;
    y?.parent = x.parent;

    if (x.parent == null) {
      root = y;
    } else {
      if (x.isLeftChild) {
        x.parent?.left = y;
      } else {
        x.parent?.right = y;
      }
    }
    y?.left = x;
    x.parent = y;
  }

  void _rightRotate(RBTreeNode<E>? x) {
    if (x == null) {
      return;
    }

    final y = x.left;
    x.left = y?.right;
    y?.right?.parent = x;
    y?.parent = x.parent;

    if (x.parent == null) {
      root = y;
    } else {
      if (x.isRightChild) {
        x.parent?.right = y;
      } else {
        x.parent?.left = y;
      }
    }
    y?.right = x;
    x.parent = y;
  }
}
