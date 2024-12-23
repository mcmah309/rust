@TestOn('vm')

import 'dart:io';

import 'package:rust/rust.dart';
import 'package:test/test.dart';

main() {
  test("exists", () async {
    var exists = await Fs.exists("/made/up/path".asPath());
    expect(exists.unwrap(), false);
    exists = await Fs.exists("test/fs/vm_test.dart".asPath());
    expect(exists.unwrap(), true);
  });

  test("metadata", () async {
    var metadata = await Fs.metadata("/made/up/path".asPath());
    expect(metadata.isOk(), true);
    expect(metadata.unwrap().type, FileSystemEntityType.notFound);

    metadata = await Fs.metadata("test/fs/vm_test.dart".asPath());
    expect(metadata.isOk(), true);
    expect(metadata.unwrap().type, FileSystemEntityType.file);
  });

  test("OpenOptions", () async {
    final openOptions = OpenOptions()
      ..append(true)
      ..read(true);
    RandomAccessFile file = await openOptions.open("test/fs/vm_test.dart".asPath()).unwrap();
    file.closeSync();
    openOptions.read(false);
    file = await openOptions.open("test/fs/vm_test.dart".asPath()).unwrap();
    file.closeSync();
    openOptions.create(true);
    file = await openOptions.open("test/fs/vm_test.dart".asPath()).unwrap();
    openOptions.createNew(true);
    var result = await openOptions.open("test/fs/vm_test.dart".asPath());
    expect(result.isErr(), true);
  });
}
