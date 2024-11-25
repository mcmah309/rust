// ignore_for_file: avoid_types_as_parameter_names

import 'package:rust/rust.dart';
import 'package:test/test.dart';

main() {
  test("arrayWindows", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var windows = slice.arrayWindows(2);
    expect(windows, [
      [1, 2],
      [2, 3],
      [3, 4],
      [4, 5]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.arrayWindows(2);
    expect(windows, [
      [2, 3],
      [3, 4]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    windows = slice.arrayWindows(5);
    expect(windows, [
      [1, 2, 3, 4, 5]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.arrayWindows(5);
    expect(windows, []);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(() => slice.arrayWindows(0), throwsA(isA<Panic>()));
    expect(() => slice.arrayWindows(-1), throwsA(isA<Panic>()));
  });

  test("asChunks", () {
    var list = [1, 2, 3, 4, 5];
    var slice = list.slice();
    var (chunks, remainder) = slice.asChunks(2);
    expect(chunks, [
      [1, 2],
      [3, 4]
    ]);
    expect(remainder, [5]);
    list = [1, 2, 3, 4];
    slice = list.slice();
    (chunks, remainder) = slice.asChunks(2);
    expect(chunks, [
      [1, 2],
      [3, 4]
    ]);
    expect(remainder, []);
    list = [];
    slice = list.slice();
    (chunks, remainder) = slice.asChunks(2);
    expect(chunks, []);
    expect(remainder, []);
    list = [1];
    slice = list.slice();
    (chunks, remainder) = slice.asChunks(2);
    expect(chunks, []);
    expect(remainder, [1]);
    (chunks, remainder) = slice.asChunks(1);
    expect(chunks, [
      [1]
    ]);
    expect(remainder, []);
    expect(() => slice.asChunks(0), throwsA(isA<Object>()));
    expect(() => slice.asChunks(-1), throwsA(isA<Object>()));
  });

  test("asRchunks", () {
    var list = [1, 2, 3, 4, 5];
    var slice = list.slice();
    var (remainder, chunks) = slice.asRchunks(2);
    expect(chunks, [
      [2, 3],
      [4, 5]
    ]);
    expect(remainder, [1]);
    list = [1, 2, 3, 4];
    slice = list.slice();
    (remainder, chunks) = slice.asRchunks(2);
    expect(chunks, [
      [1, 2],
      [3, 4]
    ]);
    expect(remainder, []);
    list = [];
    slice = list.slice();
    (remainder, chunks) = slice.asRchunks(2);
    expect(chunks, []);
    expect(remainder, []);
    list = [1];
    slice = list.slice();
    (remainder, chunks) = slice.asRchunks(2);
    expect(chunks, []);
    expect(remainder, [1]);
    (remainder, chunks) = slice.asRchunks(1);
    expect(chunks, [
      [1]
    ]);
    expect(remainder, []);
    expect(() => slice.asRchunks(0), throwsA(isA<Object>()));
    expect(() => slice.asRchunks(-1), throwsA(isA<Object>()));
  });

  test('binarySearch and partitionPoint', () {
    Slice<num> s = [0, 1, 1, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55].slice();
    expect(s.binarySearch(13), Ok(9));
    expect(s.binarySearch(4), Err(7));
    expect(s.binarySearch(100), Err(13));

    var r = s.binarySearch(1);
    expect(r, anyOf([Ok(1), Ok(2), Ok(3), Ok(4)]));

    int low = s.partitionPoint((x) => x < 1);
    expect(low, 1);

    int high = s.partitionPoint((x) => x <= 1);
    expect(high, 5);

    r = s.binarySearch(1);
    expect(r is Ok ? range(low, high).contains(r.unwrap()) : false, true);

    expect(s.slice(0, low).every((x) => x < 1), true);
    expect(s.slice(low, high).every((x) => x == 1), true);
    expect(s.slice(high).every((x) => x > 1), true);

    expect(s.partitionPoint((x) => x < 11), 9);
    expect(s.partitionPoint((x) => x <= 11), 9);
    expect(s.binarySearch(11), Err(9));
  });

  test('binarySearchBy and partitionPoint', () {
    Slice<num> s = [0, 1, 1, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55].slice();

    expect(s.binarySearchBy((x) => x.compareTo(13)), Ok(9));
    expect(s.binarySearchBy((x) => x.compareTo(4)), Err(7));
    expect(s.binarySearchBy((x) => x.compareTo(100)), Err(13));

    var r = s.binarySearchBy((x) => x.compareTo(1));
    expect(r, anyOf([Ok(1), Ok(2), Ok(3), Ok(4)]));

    int low = s.partitionPoint((x) => x < 1);
    expect(low, 1);

    int high = s.partitionPoint((x) => x <= 1);
    expect(high, 5);

    r = s.binarySearchBy((x) => x.compareTo(1));
    expect(r is Ok ? range(low, high).contains(r.unwrap()) : false, true);

    expect(s.slice(0, low).every((x) => x < 1), true);
    expect(s.slice(low, high).every((x) => x == 1), true);
    expect(s.slice(high).every((x) => x > 1), true);

    expect(s.partitionPoint((x) => x < 11), 9);
    expect(s.partitionPoint((x) => x <= 11), 9);
    expect(s.binarySearch(11), Err(9));
  });

  test('binarySearchByKey and partitionPoint', () {
    Slice<(int, int)> s = [
      (0, 0),
      (2, 1),
      (4, 1),
      (5, 1),
      (3, 1),
      (1, 2),
      (2, 3),
      (4, 5),
      (5, 8),
      (3, 13),
      (1, 21),
      (2, 34),
      (4, 55)
    ].asSlice();

    expect(s.binarySearchByKey(13, (x) => x.$2), Ok(9));
    expect(s.binarySearchByKey(4, (x) => x.$2), Err(7));
    expect(s.binarySearchByKey(100, (x) => x.$2), Err(13));

    var r = s.binarySearchByKey(1, (x) => x.$2);
    expect(r, anyOf([Ok(1), Ok(2), Ok(3), Ok(4)]));

    int low = s.partitionPoint((x) => x.$2 < 1);
    expect(low, 1);

    int high = s.partitionPoint((x) => x.$2 <= 1);
    expect(high, 5);

    r = s.binarySearchByKey(1, (x) => x.$2);
    expect(r is Ok ? range(low, high).contains(r.unwrap()) : false, true);

    expect(s.slice(0, low).every((x) => x.$2 < 1), true);
    expect(s.slice(low, high).every((x) => x.$2 == 1), true);
    expect(s.slice(high).every((x) => x.$2 > 1), true);

    expect(s.partitionPoint((x) => x.$2 < 11), 9);
    expect(s.partitionPoint((x) => x.$2 <= 11), 9);
    expect(s.binarySearchByKey(11, (x) => x.$2), Err(9));
  });

  test("chunkBy", () {
    var list = [1, 1, 1, 3, 3, 2, 2, 2];
    var slice = list.asSlice();
    var iter = slice.chunkBy((num1, num2) => num1 == num2);
    expect(iter.next().unwrap(), [1, 1, 1]);
    expect(iter.next().unwrap(), [3, 3]);
    expect(iter.next().unwrap(), [2, 2, 2]);
    expect(iter.next().isNone(), true);
  });

  test("chunks", () {
    var list = [1, 2, 3, 4, 5];
    var slice = list.slice();
    var chunks = slice.chunks(2).toList();
    expect(chunks, [
      [1, 2],
      [3, 4],
      [5]
    ]);
    list = [1, 2, 3, 4];
    slice = list.slice();
    chunks = slice.chunks(2).toList();
    expect(chunks, [
      [1, 2],
      [3, 4]
    ]);
    list = [];
    slice = list.slice();
    chunks = slice.chunks(2).toList();
    expect(chunks, []);
    list = [1];
    slice = list.slice();
    chunks = slice.chunks(2).toList();
    expect(chunks, [
      [1]
    ]);
    chunks = slice.chunks(1).toList();
    expect(chunks, [
      [1]
    ]);
    expect(() => slice.chunks(0), throwsA(isA<Panic>()));
    expect(() => slice.chunks(-1), throwsA(isA<Panic>()));
  });

  test("copyFromSlice", () {
    var srcList = [1, 2, 3, 4, 5];
    var dstList = [6, 7, 8, 9, 10];
    var src = Slice(srcList, 0, 5);
    var dst = Slice(dstList, 0, 5);
    dst.copyFromSlice(src);
    expect(dstList, [1, 2, 3, 4, 5]);

    srcList = [1, 2, 3, 4, 5];
    dstList = [6, 7, 8, 9, 10];
    src = Slice(srcList, 0, 5);
    dst = Slice(dstList, 1, 4);
    expect(() => dst.copyFromSlice(src), throwsA(isA<Panic>()));

    srcList = [1, 2, 3, 4, 5];
    dstList = [6, 7, 8, 9, 10];
    src = Slice(srcList, 1, 5);
    dst = Slice(dstList, 0, 4);
    dst.copyFromSlice(src);
    expect(dstList, [2, 3, 4, 5, 10]);

    srcList = [1, 2, 3, 4, 5];
    dstList = [6, 7, 8, 9, 10];
    src = Slice(srcList, 0, 4);
    dst = Slice(dstList, 1, 5);
    dst.copyFromSlice(src);
    expect(dstList, [6, 1, 2, 3, 4]);
  });

  test("copyWithin", () {
    var slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    slice.copyWithin(2, 5, 0); // [3, 4, 5]
    expect(slice.toList(), [3, 4, 5, 4, 5, 6, 7, 8, 9, 10]);

    slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    slice.copyWithin(1, 4, 6, sInc: false, enInc: true); // [3, 4, 5]
    expect(slice.toList(), [1, 2, 3, 4, 5, 6, 3, 4, 5, 10]);

    slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    expect(() => slice.copyWithin(10, 12, 0), throwsA(isA<Panic>()));
    expect(() => slice.copyWithin(-1, 3, 0), throwsA(isA<Panic>()));
    expect(() => slice.copyWithin(2, 5, 10), throwsA(isA<Panic>()));

    slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    slice.copyWithin(0, 3, 1); // [1, 2, 3]
    expect(slice.toList(), [1, 1, 2, 3, 5, 6, 7, 8, 9, 10]);

    slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    slice.copyWithin(3, 6, 0); // [4, 5, 6]
    expect(slice.toList(), [4, 5, 6, 4, 5, 6, 7, 8, 9, 10]);

    slice = Slice([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    slice.copyWithin(4, 5, 0); // [5]
    expect(slice.toList(), [5, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });

  test("endsWith", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.endsWith([4, 5].asSlice()), true);
    expect(slice.endsWith([3, 4, 5].asSlice()), true);
    expect(slice.endsWith([2, 3, 4, 5].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4, 5].asSlice()), true);
    expect(slice.endsWith([0, 1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4].asSlice()), false);
    expect(slice.endsWith([2, 3, 4].asSlice()), false);
    expect(slice.endsWith([3, 4].asSlice()), false);
    expect(slice.endsWith([4].asSlice()), false);
    expect(slice.endsWith([5].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.endsWith([3, 4].asSlice()), true);
    expect(slice.endsWith([2, 3, 4].asSlice()), true);
    expect(slice.endsWith([1, 2, 3, 4].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([0, 1, 2, 3, 4, 5].asSlice()), false);
    expect(slice.endsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);
  });

  test("getMany", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.getMany(Arr.constant(const [0, 1, 2])).unwrap(), [1, 2, 3]);
    expect(slice.getMany(Arr.constant(const [0, 1, 2, 3, 4])).unwrap(),
        [1, 2, 3, 4, 5]);
    expect(slice.getMany(Arr.constant(const [1, 3])).unwrap(), [2, 4]);
    expect(slice.getMany(Arr.constant(const [])).unwrap(), []);
    expect(slice.getMany(Arr.constant(const [0, 1, 2, 3, 4, 5])).unwrapErr(),
        GetManyError$IndexOutOfBounds());
    expect(slice.getMany(Arr.constant(const [0, 1, 6])).unwrapErr(),
        GetManyError$IndexOutOfBounds());
    expect([].asSlice().getMany(Arr.constant(const [0])).unwrapErr(),
        GetManyError$IndexOutOfBounds());
    expect([].asSlice().getMany(Arr.constant(const [])).unwrap(), []);
    expect([1].asSlice().getMany(Arr.constant(const [])).unwrap(), []);
  });

  test("getManyUnchecked", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.getManyUnchecked(Arr.constant(const [0, 1, 2])), [1, 2, 3]);
    expect(slice.getManyUnchecked(Arr.constant(const [0, 1, 2, 3, 4])),
        [1, 2, 3, 4, 5]);
    expect(slice.getManyUnchecked(Arr.constant(const [1, 3])), [2, 4]);
    expect(slice.getManyUnchecked(Arr.constant(const [])), []);
  });

  test("isSorted", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSorted(), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSorted(), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSorted(), true);
  });

  test("isSortedBy", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSortedBy((a, b) => a.compareTo(b)), true);
  });

  test("isSortedByKey", () {
    var list = <num>[1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.isSortedByKey((num) => num), true);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 6);
    expect(slice.isSortedByKey((num) => num), false);

    list = [1, 2, 3, 4, 5, 3];
    slice = Slice(list, 0, 5);
    expect(slice.isSortedByKey((num) => num), true);
  });

  test("lastChunk", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.lastChunk(2), Some([4, 5]));

    slice = Slice(list, 1, 4);
    expect(slice.lastChunk(2), Some([3, 4]));

    slice = Slice(list, 0, 5);
    expect(slice.lastChunk(5), Some([1, 2, 3, 4, 5]));

    slice = Slice(list, 1, 4);
    expect(slice.lastChunk(5), None);

    list = [];
    slice = list.asSlice();
    expect(slice.lastChunk(1), None);
    expect(slice.lastChunk(0), Some([]));
  });

  test("partitionDedup", () {
    var slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].asSlice();
    var (dedup, duplicates) = slice.partitionDedup();
    expect(slice.toList(), [1, 2, 3, 2, 1, 2, 3, 1]);
    expect(dedup.toList(), [1, 2, 3, 2, 1]);
    expect(duplicates.toList(), [2, 3, 1]);

    slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].slice(2, 7);
    (dedup, duplicates) = slice.partitionDedup();
    expect(slice.toList(), [2, 3, 2, 1, 3]);
    expect(dedup.toList(), [2, 3, 2, 1]);
    expect(duplicates.toList(), [3]);

    slice = <num>[].asSlice();
    (dedup, duplicates) = slice.partitionDedup();
    expect(dedup.toList(), []);
    expect(duplicates.toList(), []);

    slice = <num>[1].asSlice();
    (dedup, duplicates) = slice.partitionDedup();
    expect(dedup.toList(), [1]);
    expect(duplicates.toList(), []);
  });

  test("partitionDedupBy", () {
    var sliceStr = ["foo", "Foo", "BAZ", "Bar", "bar", "baz", "BAZ"].asSlice();
    var (dedupStr, duplicatesStr) =
        sliceStr.partitionDedupBy((a, b) => a.eqIgnoreCase(b));
    expect(dedupStr, ["foo", "BAZ", "Bar", "baz"]);
    expect(duplicatesStr, ["bar", "Foo", "BAZ"]);

    var slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].asSlice();
    var (dedup, duplicates) = slice.partitionDedupBy((a, b) => a == b);
    expect(slice.toList(), [1, 2, 3, 2, 1, 2, 3, 1]);
    expect(dedup.toList(), [1, 2, 3, 2, 1]);
    expect(duplicates.toList(), [2, 3, 1]);

    slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].slice(2, 7);
    (dedup, duplicates) = slice.partitionDedupBy((a, b) => a == b);
    expect(slice.toList(), [2, 3, 2, 1, 3]);
    expect(dedup.toList(), [2, 3, 2, 1]);
    expect(duplicates.toList(), [3]);

    slice = <num>[].asSlice();
    (dedup, duplicates) = slice.partitionDedupBy((a, b) => a == b);
    expect(dedup.toList(), []);
    expect(duplicates.toList(), []);

    slice = <num>[1].asSlice();
    (dedup, duplicates) = slice.partitionDedupBy((a, b) => a == b);
    expect(dedup.toList(), [1]);
    expect(duplicates.toList(), []);
  });

  test("partitionDedupByKey", () {
    var slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].asSlice();
    var (dedup, duplicates) = slice.partitionDedupByKey<num>((a) => a);
    expect(slice.toList(), [1, 2, 3, 2, 1, 2, 3, 1]);
    expect(dedup.toList(), [1, 2, 3, 2, 1]);
    expect(duplicates.toList(), [2, 3, 1]);

    slice = <num>[1, 2, 2, 3, 3, 2, 1, 1].slice(2, 7);
    (dedup, duplicates) = slice.partitionDedupByKey<num>((a) => a);
    expect(slice.toList(), [2, 3, 2, 1, 3]);
    expect(dedup.toList(), [2, 3, 2, 1]);
    expect(duplicates.toList(), [3]);

    slice = <num>[].asSlice();
    (dedup, duplicates) = slice.partitionDedupByKey<num>((a) => a);
    expect(dedup.toList(), []);
    expect(duplicates.toList(), []);

    slice = <num>[1].asSlice();
    (dedup, duplicates) = slice.partitionDedupByKey<num>((a) => a);
    expect(dedup.toList(), [1]);
    expect(duplicates.toList(), []);
  });

  test("rchunks", () {
    var list = [1, 2, 3, 4, 5];
    var slice = list.slice();
    var chunks = slice.rchunks(2).toList();
    expect(chunks, [
      [4, 5],
      [2, 3],
      [1]
    ]);
    list = [1, 2, 3, 4];
    slice = list.slice();
    chunks = slice.rchunks(2).toList();
    expect(chunks, [
      [3, 4],
      [1, 2]
    ]);
    list = [];
    slice = list.slice();
    chunks = slice.rchunks(2).toList();
    expect(chunks, []);
    list = [1];
    slice = list.slice();
    chunks = slice.rchunks(2).toList();
    expect(chunks, [
      [1]
    ]);
    chunks = slice.rchunks(1).toList();
    expect(chunks, [
      [1]
    ]);
    expect(() => slice.rchunks(0), throwsA(isA<Panic>()));
    expect(() => slice.rchunks(-1), throwsA(isA<Panic>()));
  });

  test("rotateLeft", () {
    Slice<String> slice = ['a', 'b', 'c', 'd', 'e', 'f'].asSlice();
    slice.rotateLeft(2);
    expect(slice, ['c', 'd', 'e', 'f', 'a', 'b']);

    slice = ['a', 'b', 'c', 'd', 'e', 'f'].asSlice();
    slice.slice(1, 5).rotateLeft(1);
    expect(slice, ['a', 'c', 'd', 'e', 'b', 'f']);

    Slice<int> slice2 = [1, 2, 3, 4, 5].asSlice();
    slice2.rotateLeft(3);
    expect(slice2, [4, 5, 1, 2, 3]);
  });

  test("rotateRight", () {
    Slice<String> slice = ['a', 'b', 'c', 'd', 'e', 'f'].asSlice();
    slice.rotateRight(2);
    expect(slice, ['e', 'f', 'a', 'b', 'c', 'd']);

    slice = ['a', 'b', 'c', 'd', 'e', 'f'].asSlice();
    slice.slice(1, 5).rotateRight(1);
    expect(slice, ['a', 'e', 'b', 'c', 'd', 'f']);

    Slice<int> slice2 = [1, 2, 3, 4, 5].asSlice();
    slice2.rotateRight(3);
    expect(slice2, [3, 4, 5, 1, 2]);
  });

  test("reverse", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    slice.reverse();
    expect(list, [5, 4, 3, 2, 1]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    slice.reverse();
    expect(list, [1, 4, 3, 2, 5]);
  });

  test("takeStart", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeStart(3);
    expect(taken, [1, 2, 3]);
    expect(list, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeStart(3);
    expect(taken, [2, 3, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });

  test("takeEnd", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeEnd(3);
    expect(taken, [3, 4, 5]);
    expect(list, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeEnd(3);
    expect(taken, [2, 3, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });

  test("takeFirst", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeFirst();
    expect(taken, 1);
    expect(slice, [2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    taken = slice.takeFirst();
    expect(taken, 2);
    expect(slice, [3, 4]);
  });

  test("takeLast", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var taken = slice.takeLast();
    expect(taken, 5);
    expect(slice, [1, 2, 3, 4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice, [2, 3, 4]);
    taken = slice.takeLast();
    expect(taken, 4);
    expect(slice, [2, 3]);

    slice[1] = 10;
    expect(list, [1, 2, 10, 4, 5]);
  });

  test("rsplit", () {
    var list = [11, 22, 33, 0, 44, 55];
    var slice = Slice(list, 0, 6);
    var iter = slice.rsplit((num) => num == 0);
    expect(iter.next().unwrap(), [44, 55]);
    expect(iter.next().unwrap(), [11, 22, 33]);
  });

  test("rsplitAt", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var rsplit = slice.rsplitAt(2);
    expect(rsplit.$1, [1, 2, 3]);
    expect(rsplit.$2, [4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    rsplit = slice.rsplitAt(2);
    expect(rsplit.$1, [2]);
    expect(rsplit.$2, [3, 4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    rsplit = slice.rsplitAt(5);
    expect(rsplit.$1, []);
    expect(rsplit.$2, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    rsplit = slice.rsplitAt(0);
    expect(rsplit.$1, [1, 2, 3, 4, 5]);
    expect(rsplit.$2, []);
  });

  test("rsplitOnce", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().rsplitOnce((num) => num == 2).unwrap().$1, [1, 2, 3]);
    expect(list.asSlice().rsplitOnce((num) => num == 2).unwrap().$2, [4]);
    expect(list.asSlice().rsplitOnce((num) => num == 0).isNone(), true);
    expect(list.asSlice().rsplitOnce((num) => num == 1).unwrap().$1, []);
    expect(
        list.asSlice().rsplitOnce((num) => num == 1).unwrap().$2, [2, 3, 2, 4]);
    expect(
        list.asSlice().rsplitOnce((num) => num == 4).unwrap().$1, [1, 2, 3, 2]);
    expect(list.asSlice().rsplitOnce((num) => num == 4).unwrap().$2, []);
  });

  test("rsplitn", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).rsplitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().isNone(), true);

    iter = Slice(list, 0, 4).rsplitn(1, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40, 33, 20]);

    iter = Slice(list, 0, 4).rsplitn(2, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [10, 40, 33]);

    iter = Slice(list, 0, 4).rsplitn(5, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [33]);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), []);
    expect(iter.next().isNone(), true);

    list = [10, 40, 30, 20, 60, 50];
    iter = Slice(list, 0, 6).rsplitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [50]);
    expect(iter.next().unwrap(), [10, 40, 30, 20]);

    list = [];
    iter = Slice(list, 0, 0).rsplitn(2, (p0) => true);
    expect(iter.next().unwrap(), []);

    list = [1, 2, 3];
    iter = Slice(list, 0, 0).rsplitn(0, (p0) => true);
    expect(iter.next().isNone(), true);
    expect(() => Slice(list, 0, 3).rsplitn(-1, (p0) => true),
        throwsA(isA<Panic>()));
  });

  test("sortUnstable", () {
    var list = [5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstable();
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstable();
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstable();

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstable();
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("sortUnstableBy", () {
    var list = [5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstableBy((a, b) => a.compareTo(b));

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstableBy((a, b) => a.compareTo(b));
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("sortUnstableByKey", () {
    var list = <num>[5, 4, 3, 2, 1];
    var slice = Slice(list, 0, 5);
    slice.sortUnstableByKey((num) => num);
    expect(list, [1, 2, 3, 4, 5]);

    list = [5, 4, 3, 2, 1];
    slice = Slice(list, 1, 4);
    slice.sortUnstableByKey((num) => num);
    expect(list, [5, 2, 3, 4, 1]);

    var doubleList = [5.0, 4.0, 3.0, 2.0, 1.0];
    var doubleSlice = Slice(doubleList, 0, 5);
    doubleSlice.sortUnstableByKey<num>((num) => num);

    var stringList = ["b", "a", "d", "c", "e"];
    var stringSlice = Slice(stringList, 0, 5);
    stringSlice.sortUnstableByKey((str) => str);
    expect(stringList, ["a", "b", "c", "d", "e"]);
  });

  test("split", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).split((num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);
  });

  test("splitAt", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var split = slice.splitAt(2);
    expect(split.$1, [1, 2]);
    expect(split.$2, [3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    split = slice.splitAt(2);
    expect(split.$1, [2, 3]);
    expect(split.$2, [4]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    split = slice.splitAt(5);
    expect(split.$1, [1, 2, 3, 4, 5]);
    expect(split.$2, []);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    split = slice.splitAt(0);
    expect(split.$1, []);
    expect(split.$2, [1, 2, 3, 4, 5]);
  });

  test("splitFirst", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitFirst().unwrap().$1, 1);
    expect(list.asSlice().splitFirst().unwrap().$2, [2, 3, 2, 4]);
    list = [1];
    expect(list.asSlice().splitFirst().unwrap().$1, 1);
    expect(list.asSlice().splitFirst().unwrap().$2, []);
    list = [];
    expect(list.asSlice().splitFirst().isNone(), true);
  });

  test("splitInclusive", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).splitInclusive((num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40, 33]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);
  });

  test("splitLast", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitLast().unwrap().$1, 4);
    expect(list.asSlice().splitLast().unwrap().$2, [1, 2, 3, 2]);
    list = [1];
    expect(list.asSlice().splitLast().unwrap().$1, 1);
    expect(list.asSlice().splitLast().unwrap().$2, []);
    list = [];
    expect(list.asSlice().splitLast().isNone(), true);
  });

  test("splitOnce", () {
    var list = [1, 2, 3, 2, 4];
    expect(list.asSlice().splitOnce((num) => num == 2).unwrap().$1, [1]);
    expect(list.asSlice().splitOnce((num) => num == 2).unwrap().$2, [3, 2, 4]);
    expect(list.asSlice().splitOnce((num) => num == 0).isNone(), true);
    expect(list.asSlice().splitOnce((num) => num == 1).unwrap().$1, []);
    expect(
        list.asSlice().splitOnce((num) => num == 1).unwrap().$2, [2, 3, 2, 4]);
    expect(
        list.asSlice().splitOnce((num) => num == 4).unwrap().$1, [1, 2, 3, 2]);
    expect(list.asSlice().splitOnce((num) => num == 4).unwrap().$2, []);
  });

  test("splitn", () {
    var list = [10, 40, 33, 20];
    var iter = Slice(list, 0, 4).splitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20]);
    expect(iter.next().isNone(), true);

    iter = Slice(list, 0, 4).splitn(1, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40, 33, 20]);

    iter = Slice(list, 0, 4).splitn(2, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [40, 33, 20]);

    iter = Slice(list, 0, 4).splitn(5, (num) => num % 5 == 0);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), []);
    expect(iter.next().unwrap(), [33]);
    expect(iter.next().unwrap(), []);
    expect(iter.next().isNone(), true);

    list = [10, 40, 30, 20, 60, 50];
    iter = Slice(list, 0, 6).splitn(2, (num) => num % 3 == 0);
    expect(iter.next().unwrap(), [10, 40]);
    expect(iter.next().unwrap(), [20, 60, 50]);

    list = [];
    iter = Slice(list, 0, 0).splitn(2, (p0) => true);
    expect(iter.next().unwrap(), []);

    list = [1, 2, 3];
    iter = Slice(list, 0, 0).splitn(0, (p0) => true);
    expect(iter.next().isNone(), true);
    expect(
        () => list.asSlice().splitn(-1, (p0) => true), throwsA(isA<Panic>()));
  });

  test("startsWith", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.startsWith([1, 2].asSlice()), true);
    expect(slice.startsWith([1, 2, 3].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4, 5].asSlice()), true);
    expect(slice.startsWith([1, 2, 3, 4, 5, 6].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 4, 6].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 5].asSlice()), false);
    expect(slice.startsWith([1, 2, 4].asSlice()), false);
    expect(slice.startsWith([1, 3].asSlice()), false);
    expect(slice.startsWith([2].asSlice()), false);
    expect(slice.startsWith([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.startsWith([2, 3].asSlice()), true);
    expect(slice.startsWith([2, 3, 4].asSlice()), true);
    expect(slice.startsWith([2, 3, 4, 5].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 5, 6].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 6].asSlice()), false);
    expect(slice.startsWith([2, 3, 5].asSlice()), false);
    expect(slice.startsWith([2, 4].asSlice()), false);
    expect(slice.startsWith([3].asSlice()), false);
    expect(slice.startsWith([2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()), false);
  });

  test("stripPrefix", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.stripPrefix(<int>[].asSlice()).unwrap(), [1, 2, 3, 4, 5]);
    expect(slice.stripPrefix([1].asSlice()).unwrap(), [2, 3, 4, 5]);
    expect(slice.stripPrefix([1, 2].asSlice()).unwrap(), [3, 4, 5]);
    expect(slice.stripPrefix([1, 2, 3].asSlice()).unwrap(), [4, 5]);
    expect(slice.stripPrefix([1, 2, 3, 4].asSlice()).unwrap(), [5]);
    expect(slice.stripPrefix([1, 2, 3, 4, 5].asSlice()).unwrap(), []);
    expect(slice.stripPrefix([1, 2, 3, 4, 5, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 2, 4].asSlice()).isNone(), true);
    expect(slice.stripPrefix([1, 3].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2].asSlice()).isNone(), true);
    expect(
        slice.stripPrefix([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()).isNone(),
        true);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.stripPrefix(<int>[].asSlice()).unwrap(), [2, 3, 4]);
    expect(slice.stripPrefix([2, 3].asSlice()).unwrap(), [4]);
    expect(slice.stripPrefix([2, 3, 4].asSlice()).unwrap(), []);
    expect(slice.stripPrefix([2, 3, 4, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 4, 5, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripPrefix([2, 5].asSlice()).isNone(), true);
  });

  test("stripSuffix", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    expect(slice.stripSuffix(<int>[].asSlice()).unwrap(), [1, 2, 3, 4, 5]);
    expect(slice.stripSuffix([5].asSlice()).unwrap(), [1, 2, 3, 4]);
    expect(slice.stripSuffix([4, 5].asSlice()).unwrap(), [1, 2, 3]);
    expect(slice.stripSuffix([3, 4, 5].asSlice()).unwrap(), [1, 2]);
    expect(slice.stripSuffix([2, 3, 4, 5].asSlice()).unwrap(), [1]);
    expect(slice.stripSuffix([1, 2, 3, 4, 5].asSlice()).unwrap(), []);
    expect(slice.stripSuffix([0, 1, 2, 3, 4, 5].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 2, 3, 4, 6].asSlice()).isNone(), true);
    expect(slice.stripSuffix([0, 2, 3, 5].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 2, 4].asSlice()).isNone(), true);
    expect(slice.stripSuffix([1, 3].asSlice()).isNone(), true);
    expect(slice.stripSuffix([2].asSlice()).isNone(), true);
    expect(
        slice.stripSuffix([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].asSlice()).isNone(),
        true);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(slice.stripSuffix(<int>[].asSlice()).unwrap(), [2, 3, 4]);
    expect(slice.stripSuffix([4].asSlice()).unwrap(), [2, 3]);
    expect(slice.stripSuffix([3, 4].asSlice()).unwrap(), [2]);
    expect(slice.stripSuffix([2, 3, 4].asSlice()).unwrap(), []);
  });

  test("swap", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    slice.swap(0, 4);
    expect(list, [5, 2, 3, 4, 1]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    slice.swap(0, 2);
    expect(list, [1, 4, 3, 2, 5]);
  });

  test("swapWithSlice", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var other = Slice([6, 7, 8, 9, 10], 0, 5);
    slice.swapWithSlice(other);
    expect(list, [6, 7, 8, 9, 10]);
    expect(other, [1, 2, 3, 4, 5]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    var otherList = [6, 7, 8, 9, 10];
    other = Slice(otherList, 2, 5);
    slice.swapWithSlice(other);
    expect(list, [1, 8, 9, 10, 5]);
    expect(slice, [8, 9, 10]);
    expect(otherList, [6, 7, 2, 3, 4]);
    expect(other, [2, 3, 4]);
  });

  test("windows", () {
    var list = [1, 2, 3, 4, 5];
    var slice = Slice(list, 0, 5);
    var windows = slice.windows(2).map((e) => e.toList()).toList();
    expect(windows, [
      [1, 2],
      [2, 3],
      [3, 4],
      [4, 5]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.windows(2).map((e) => e.toList()).toList();
    expect(windows, [
      [2, 3],
      [3, 4]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 0, 5);
    windows = slice.windows(5).map((e) => e.toList()).toList();
    expect(windows, [
      [1, 2, 3, 4, 5]
    ]);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    windows = slice.windows(4).map((e) => e.toList()).toList();
    expect(windows, []);

    list = [1, 2, 3, 4, 5];
    slice = Slice(list, 1, 4);
    expect(() => slice.windows(0), throwsA(isA<Panic>()));
    expect(() => slice.windows(-1), throwsA(isA<Panic>()));
  });

  group("List tests", () {
    test("equality", () {
      Slice<int> slice = Slice([1, 2, 3, 4], 0, 4);
      expect(slice, equals([1, 2, 3, 4]));
      expect([1, 2, 3, 4], equals(slice));
      Slice<int> slice2 = Slice([1, 2, 3, 4], 1, 3);
      expect(slice2, equals([2, 3]));
      expect([2, 3], equals(slice2));
      Slice<int> slice3 = Slice([2, 3], 0, 2);
      expect(slice2, equals(slice3));
      expect(slice3, equals(slice2));
    });

    test("add", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.add(5);
      expect(slice, equals([1, 2, 3, 4, 5]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.add(10);
      expect(slice, equals([2, 3, 10]));
      expect(list, equals([1, 2, 3, 10, 4]));
    });

    test("addAll", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.addAll([5, 6]);
      expect(slice, equals([1, 2, 3, 4, 5, 6]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.addAll([5, 6]);
      expect(slice, equals([2, 3, 5, 6]));
      expect(list, equals([1, 2, 3, 5, 6, 4]));
    });

    test("clear", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.clear();
      expect(slice, equals([]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.clear();
      expect(slice, equals([]));
      expect(list, equals([1, 4]));
    });

    test("fillRange", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.fillRange(1, 3, 10);
      expect(slice, equals([1, 10, 10, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.fillRange(0, 2, 10);
      expect(slice, equals([10, 10]));
      expect(list, equals([1, 10, 10, 4]));
    });

    test("first", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1);
      slice.first = 10;
      expect(slice.first, 10);
      expect(list, equals([1, 10, 3, 4]));
    });

    test("getRange", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      final range = slice.getRange(0, 2);
      expect(range, equals([2, 3]));
    });

    test("indexOf", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      expect(slice.indexOf(2), 0);
      expect(slice.indexOf(3), 1);
      expect(slice.indexOf(4), -1);

      expect(slice.indexOf(2, 1), -1);
      expect(slice.indexOf(3, 1), 1);
      expect(slice.indexOf(4, 1), -1);
    });

    test("indexWhere", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      expect(slice.indexWhere((num) => num == 2), 0);
      expect(slice.indexWhere((num) => num == 3), 1);
      expect(slice.indexWhere((num) => num == 4), -1);

      expect(slice.indexWhere((num) => num == 2, 1), -1);
      expect(slice.indexWhere((num) => num == 3, 1), 1);
      expect(slice.indexWhere((num) => num == 4, 1), -1);
    });

    test("insert", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.insert(1, 10);
      expect(slice, equals([1, 10, 2, 3, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.insert(1, 10);
      expect(slice, equals([2, 10, 3]));
      expect(list, equals([1, 2, 10, 3, 4]));
    });

    test("insertAll", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.insertAll(1, [10, 20]);
      expect(slice, equals([1, 10, 20, 2, 3, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.insertAll(1, [10, 20]);
      expect(slice, equals([2, 10, 20, 3]));
      expect(list, equals([1, 2, 10, 20, 3, 4]));
    });

    test("last", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 2);
      slice.last = 10;
      expect(slice.last, 10);
      expect(list, equals([1, 10, 3, 4]));
    });

    test("lastIndexOf", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      expect(slice.lastIndexOf(2), 0);
      expect(slice.lastIndexOf(3), 1);
      expect(slice.lastIndexOf(4), -1);

      expect(slice.lastIndexOf(2, 1), -1);
      expect(slice.lastIndexOf(3, 1), 1);
      expect(slice.lastIndexOf(4, 1), -1);
    });

    test("lastIndexWhere", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      expect(slice.lastIndexWhere((num) => num == 2), 0);
      expect(slice.lastIndexWhere((num) => num == 3), 1);
      expect(slice.lastIndexWhere((num) => num == 4), -1);

      expect(slice.lastIndexWhere((num) => num == 2, 1), -1);
      expect(slice.lastIndexWhere((num) => num == 3, 1), 1);
      expect(slice.lastIndexWhere((num) => num == 4, 1), -1);
    });

    test("set length", () {
      expect(() => [1].slice().length = 5, throwsA(isA<Panic>()));
    });

    test("set length", () {
      expect(() => [1].slice().length = 5, throwsA(isA<Panic>()));
    });

    test("remove", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      bool isRemoved = slice.remove(2);
      expect(isRemoved, true);
      expect(slice, equals([1, 3, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      isRemoved = slice.remove(2);
      expect(isRemoved, true);
      expect(slice, equals([3]));
      expect(list, equals([1, 3, 4]));
      isRemoved = slice.remove(4);
      expect(isRemoved, false);
    });

    test("removeAt", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.removeAt(1);
      expect(slice, equals([1, 3, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.removeAt(1);
      expect(slice, equals([2]));
      expect(list, equals([1, 2, 4]));
    });

    test("removeLast", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.removeLast();
      expect(slice, equals([1, 2, 3]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.removeLast();
      expect(slice, equals([2]));
      expect(list, equals([1, 2, 4]));
    });

    test("removeRange", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.removeRange(1, 3);
      expect(slice, equals([1, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.removeRange(0, 2);
      expect(slice, equals([]));
      expect(list, equals([1, 4]));
    });

    test("removeWhere", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.removeWhere((num) => num % 2 == 0);
      expect(slice, equals([1, 3]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.removeWhere((num) => num % 2 == 0);
      expect(slice, equals([3]));
      expect(list, equals([1, 3, 4]));
    });

    test("replaceRange", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.replaceRange(1, 3, [10, 20]);
      expect(slice, equals([1, 10, 20, 4]));
      var list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.replaceRange(0, 2, [10, 20]);
      expect(slice, equals([10, 20]));
      expect(list, equals([1, 10, 20, 4]));
      list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      slice.replaceRange(1, 2, [10, 20, 30, 40]);
      expect(slice, equals([2, 10, 20, 30, 40]));
      expect(list, equals([1, 2, 10, 20, 30, 40, 4]));
    });

    test("retainWhere", () {
      Slice<int> slice = [1, 2, 3, 4].slice();
      slice.retainWhere((num) => num % 2 == 0);
      expect(slice, equals([2, 4]));
      final list = [1, 2, 3, 4];
      slice = list.slice(1, 3);
      expect(slice, equals([2, 3]));
      slice.retainWhere((num) => num % 2 == 0);
      expect(slice, equals([2]));
      expect(list, equals([1, 2, 4]));
    });

    test("reversed", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      final reversed = slice.reversed.toList();
      expect(reversed, equals([3, 2]));
    });

    test("setAll", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      slice.setAll(0, [10, 20]);
      expect(slice, equals([10, 20]));
      expect(list, equals([1, 10, 20, 4]));
    });

    test("replaceRange", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      slice.replaceRange(0, 2, [10, 20]);
      expect(slice, equals([10, 20]));
      expect(list, equals([1, 10, 20, 4]));
    });

    test("shuffle", () {
      final list = [1, 2, 3, 4, 5, 6];
      final slice = list.slice(1, 4);
      slice.shuffle();
      expect(slice, containsAll([2, 3, 4]));
      expect(list.slice(0, 1), equals([1]));
      expect(list.slice(4), equals([5, 6]));
    });

    test("sort", () {
      final list = [5, 4, 3, 2, 1];
      final slice = list.slice(1, 4);
      slice.sort();
      expect(slice, equals([2, 3, 4]));
      expect(list, equals([5, 2, 3, 4, 1]));
    });

    test("sublist", () {
      final list = [1, 2, 3, 4];
      final slice = list.slice(1, 3);
      final sublist = slice.sublist(1);
      expect(sublist, equals([3]));
    });
  });
}
