import 'package:bst/bst.dart';
import 'package:test/test.dart';

int intComparator(a, b) => b - a;

void main() {
  RBTree makeLargerTree() => RBTree(intComparator)
    ..insert(8)
    ..insert(5)
    ..insert(15)
    ..insert(12)
    ..insert(19)
    ..insert(9)
    ..insert(13)
    ..insert(23);

  group('isEmpty tests', () {
    test('returns true for empty tree', () {
      expect(RBTree<int>(intComparator).isEmpty, isTrue);
    });

    test('returns false for non empty tree', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(1);
      expect(tree.isEmpty, isFalse);
    });
  });

  group('insert tests', () {
    test('insert root', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(1);
      expect(tree.size, equals(1));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1]));
    });

    test('insert multiple values', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(5);
      tree.insert(1);
      tree.insert(7);
      expect(tree.size, equals(3));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1, 5, 7]));
    });

    test('insert existing value twice', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(5);
      final firstNode = tree.insert(1);
      final secondNode = tree.insert(1);
      expect(firstNode, isNotNull);
      expect(secondNode, isNull);
      expect(tree.size, equals(2));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1, 5]));
    });

    test('re-balance tree case 2', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(15);
      tree.insert(5);
      tree.insert(20);
      tree.insert(1);
      expect(tree.size, equals(4));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1, 5, 15, 20]));
    });

    test('re-balance tree case 3 (left)', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(15);
      tree.insert(5);
      tree.insert(1);
      expect(tree.size, equals(3));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1, 5, 15]));
    });

    test('re-balance tree case 3 (right)', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(1);
      tree.insert(5);
      tree.insert(15);
      expect(tree.size, equals(3));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([1, 5, 15]));
    });

    test('re-balance tree case 4 (left)', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(15);
      tree.insert(5);
      tree.insert(10);
      expect(tree.size, equals(3));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([5, 10, 15]));
    });

    test('re-balance tree case 4 (right)', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(5);
      tree.insert(15);
      tree.insert(10);
      expect(tree.size, equals(3));
      expect(tree.inOrderTraversal().map((node) => node.value), orderedEquals([5, 10, 15]));
    });

    test('insert into large tree', () {
      final tree = makeLargerTree();
      final sizeBefore = tree.size;
      tree.insert(10);
      final sizeAfter = tree.size;
      expect(sizeAfter, equals(sizeBefore + 1));
    });
  });

  group('remove tests', () {
    test('remove root', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(1);
      expect(tree.size, equals(1));
    });

    test('remove parent with left child', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(2);
      tree.insert(1);
      tree.remove(1);
      expect(tree.size, equals(1));
    });

    test('remove parent with right child', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(1);
      tree.insert(2);
      tree.remove(1);
      expect(tree.size, equals(1));
    });

    test('remove parent with both children', () {
      final tree = RBTree<int>(intComparator);
      tree.insert(2);
      tree.insert(1);
      tree.insert(3);
      tree.remove(2);
      expect(tree.size, equals(2));
    });

    test('remove case 1', () {
      final tree = makeLargerTree()..insert(10);
      final sizeBefore = tree.size;
      tree.remove(19);
      final sizeAfter = tree.size;
      expect(sizeAfter, equals(sizeBefore - 1));
    });

    test('remove case 2', () {
      final tree = makeLargerTree()
        ..insert(10)
        ..remove(19)
        ..insert(1);
      final sizeBefore = tree.size;
      tree.remove(5);
      final sizeAfter = tree.size;
      expect(sizeAfter, equals(sizeBefore - 1));
    });

    test('remove case 3', () {
      final tree = makeLargerTree()
        ..insert(10)
        ..remove(19)
        ..insert(1)
        ..remove(5);
      final sizeBefore = tree.size;
      tree.remove(12);
      final sizeAfter = tree.size;
      expect(sizeAfter, equals(sizeBefore - 1));
    });
  });

  group('predecessor tests', () {
    test('returns null when no predecessor exists', () {
      final tree = RBTree<int>(intComparator);
      final node = tree.insert(1);
      expect(node!.predecessor(), isNull);
    });

    test('returns in order predecessor when exists', () {
      final tree = makeLargerTree();
      expect(tree.findNode(8)!.predecessor()?.value, equals(5));
      expect(tree.findNode(15)!.predecessor()?.value, equals(13));
      expect(tree.findNode(12)!.predecessor()?.value, equals(9));
      expect(tree.findNode(19)!.predecessor()?.value, equals(15));
      expect(tree.findNode(9)!.predecessor()?.value, equals(8));
      expect(tree.findNode(13)!.predecessor()?.value, equals(12));
      expect(tree.findNode(23)!.predecessor()?.value, equals(19));
    });
  });

  group('successor tests', () {
    test('returns null when no successor exists', () {
      final tree = RBTree<int>(intComparator);
      final node = tree.insert(1);
      expect(node!.successor(), isNull);
    });

    test('returns in order successor when exists', () {
      final tree = makeLargerTree();
      expect(tree.findNode(5)!.successor()?.value, equals(8));
      expect(tree.findNode(13)!.successor()?.value, equals(15));
      expect(tree.findNode(9)!.successor()?.value, equals(12));
      expect(tree.findNode(15)!.successor()?.value, equals(19));
      expect(tree.findNode(8)!.successor()?.value, equals(9));
      expect(tree.findNode(12)!.successor()?.value, equals(13));
      expect(tree.findNode(19)!.successor()?.value, equals(23));
    });
  });
}
