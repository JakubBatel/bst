import 'package:bst/bst.dart';

void main() {
  // Create tree and insert some initial values
  final tree = RBTree<int>((a, b) => a - b)
    ..insert(8)
    ..insert(5)
    ..insert(15)
    ..insert(12)
    ..insert(19)
    ..insert(9)
    ..insert(13)
    ..insert(23);

  // Get size (number of elements)
  final sizeBefore = tree.size;

  // Remove value
  tree.remove(19);
  tree.remove(5);

  assert(sizeBefore - 2 == tree.size);

  // Verify that tree contains value
  assert(tree.contains(8));
  assert(!tree.contains(5));

  // Prints 8, 9, 12, 13, 15, 23
  print(tree.inOrderTraversal());
}
