import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("components", () {
    var components =
        WindowsPath("C:\\foo\\bar\\..\\.\\bar").components().iterator;
    components.moveNext();
    expect(components.current, Prefix("C:"));
    components.moveNext();
    expect(components.current, RootDir(true));
    components.moveNext();
    expect(components.current, Normal("foo"));
    components.moveNext();
    expect(components.current, Normal("bar"));
    components.moveNext();
    expect(components.current, const ParentDir());
    components.moveNext();
    expect(components.current, const CurDir());
    components.moveNext();
    expect(components.current, Normal("bar"));
    expect(components.moveNext(), false);

    components = WindowsPath("C:\\").components().iterator;
    components.moveNext();
    expect(components.current, Prefix("C:"));
    components.moveNext();
    expect(components.current, RootDir(true));
    expect(components.moveNext(), false);

    components = WindowsPath("C:").components().iterator;
    components.moveNext();
    expect(components.current, Prefix("C:"));
    expect(components.moveNext(), false);

    components = WindowsPath("foo\\bar").components().iterator;
    components.moveNext();
    expect(components.current, Normal("foo"));
    components.moveNext();
    expect(components.current, Normal("bar"));
    expect(components.moveNext(), false);
  });

  test("filePrefix", () {
    expect(WindowsPath("foo.rs").filePrefixOpt().unwrap(), "foo");
    expect(WindowsPath("foo\\").filePrefixOpt().unwrap(), "foo");
    expect(WindowsPath(".foo").filePrefixOpt().unwrap(), ".foo");
    expect(WindowsPath(".foo.rs").filePrefixOpt().unwrap(), "foo");
    expect(WindowsPath("foo").filePrefixOpt().unwrap(), "foo");
    expect(WindowsPath("foo.tar.gz").filePrefixOpt().unwrap(), "foo");
    expect(WindowsPath("temp\\foo.tar.gz").filePrefixOpt().unwrap(), "foo");
    expect(
        WindowsPath("C:\\foo\\.tmp.bar.tar").filePrefixOpt().unwrap(), "tmp");
    expect(WindowsPath("").filePrefixOpt().isNone(), true);

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .filePrefixOpt()
            .unwrap(),
        "The Annual Report on the Health of the Parish of St");
  });

  test("fileStem", () {
    expect(WindowsPath("foo.rs").fileStemOpt().unwrap(), "foo");
    expect(WindowsPath("foo\\").fileStemOpt().unwrap(), "foo");
    expect(WindowsPath(".foo").fileStemOpt().unwrap(), ".foo");
    expect(WindowsPath(".foo.rs").fileStemOpt().unwrap(), ".foo");
    expect(WindowsPath("foo").fileStemOpt().unwrap(), "foo");
    expect(WindowsPath("foo.tar.gz").fileStemOpt().unwrap(), "foo.tar");
    expect(WindowsPath("temp\\foo.tar.gz").fileStemOpt().unwrap(), "foo.tar");
    expect(WindowsPath("").fileStemOpt().isNone(), true);

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .fileStemOpt()
            .unwrap(),
        "The Annual Report on the Health of the Parish of St");
  });

  test("parent", () {
    expect(
        WindowsPath("temp\\foo.rs").parentOpt().unwrap(), WindowsPath("temp"));
    expect(WindowsPath("foo\\").parentOpt().unwrap(), WindowsPath(""));
    expect(WindowsPath("C:\\foo\\").parentOpt().unwrap(), WindowsPath("C:\\"));
    expect(WindowsPath(".foo").parentOpt().unwrap(), WindowsPath(""));
    expect(WindowsPath(".foo.rs").parentOpt().unwrap(), WindowsPath(""));
    expect(WindowsPath("foo").parentOpt().unwrap(), WindowsPath(""));
    expect(WindowsPath("foo.tar.gz").parentOpt().unwrap(), WindowsPath(""));
    expect(WindowsPath("temp\\foo.tar.gz").parentOpt().unwrap(),
        WindowsPath("temp"));
    expect(WindowsPath("temp1\\temp2\\foo.tar.gz").parentOpt().unwrap(),
        WindowsPath("temp1\\temp2"));
    expect(WindowsPath("temp1\\temp2\\\\foo.tar.gz").parentOpt().unwrap(),
        WindowsPath("temp1\\temp2"));
    expect(WindowsPath("").parentOpt().isNone(), true);

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .parentOpt()
            .unwrap(),
        WindowsPath("\\Downloads"));
  });

  test("ancestors", () {
    var ancestors = WindowsPath("C:\\foo\\bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("C:\\foo\\bar"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("C:\\foo"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("C:\\"));
    expect(ancestors.moveNext(), false);

    // Relative WindowsPaths should work similarly but without drive letters
    ancestors = WindowsPath("..\\foo\\bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("..\\foo\\bar"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("..\\foo"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath(".."));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath(""));
    expect(ancestors.moveNext(), false);

    ancestors = WindowsPath("foo\\bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("foo\\bar"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("foo"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath(""));
    expect(ancestors.moveNext(), false);

    ancestors = WindowsPath("foo\\..").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("foo\\.."));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("foo"));

    ancestors = WindowsPath(
            "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
        .ancestors()
        .iterator;
    ancestors.moveNext();
    expect(
        ancestors.current,
        WindowsPath(
            "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("\\Downloads"));
    ancestors.moveNext();
    expect(ancestors.current, WindowsPath("\\"));
  });

  test("withExtension", () {
    expect(WindowsPath("foo").withExtension("rs"), WindowsPath("foo.rs"));
    expect(WindowsPath("foo.rs").withExtension("rs"), WindowsPath("foo.rs"));
    expect(WindowsPath("foo.tar.gz").withExtension("rs"),
        WindowsPath("foo.tar.rs"));
    expect(WindowsPath("foo.tar.gz").withExtension(""), WindowsPath("foo.tar"));
    expect(WindowsPath("foo.tar.gz").withExtension("tar.gz"),
        WindowsPath("foo.tar.tar.gz"));
    expect(WindowsPath("C:\\tmp\\foo.tar.gz").withExtension("tar.gz"),
        WindowsPath("C:\\tmp\\foo.tar.tar.gz"));
    expect(WindowsPath("tmp\\foo").withExtension("tar.gz"),
        WindowsPath("tmp\\foo.tar.gz"));
    expect(WindowsPath("tmp\\.foo.tar").withExtension("tar.gz"),
        WindowsPath("tmp\\.foo.tar.gz"));

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .withExtension(""),
        WindowsPath(
            "\\Downloads\\The Annual Report on the Health of the Parish of St"));
  });

  test("withFileName", () {
    expect(WindowsPath("foo").withFileName("bar"), WindowsPath("bar"));
    expect(WindowsPath("foo.rs").withFileName("bar"), WindowsPath("bar"));
    expect(WindowsPath("foo.tar.gz").withFileName("bar"), WindowsPath("bar"));
    expect(WindowsPath("C:\\tmp\\foo.tar.gz").withFileName("bar"),
        WindowsPath("C:\\tmp\\bar"));
    expect(
        WindowsPath("tmp\\foo").withFileName("bar"), WindowsPath("tmp\\bar"));
    expect(WindowsPath("C:\\var").withFileName("bar"), WindowsPath("C:\\bar"));

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .withFileName("dave"),
        WindowsPath("\\Downloads\\dave"));
  });

  test("extension", () {
    expect(WindowsPath("foo").extension(), "");
    expect(WindowsPath("foo.rs").extension(), "rs");
    expect(WindowsPath("foo.tar.gz").extension(), "gz");
    expect(WindowsPath("\\tmp\\foo.tar.gz").extension(), "gz");
    expect(WindowsPath("tmp\\foo").extension(), "");
    expect(WindowsPath(".foo").extension(), "");
    expect(WindowsPath("\\var").extension(), "");
    expect(WindowsPath("\\var..d").extension(), "d");
    expect(WindowsPath("\\..d").extension(), "d");

    expect(
        WindowsPath(
                "\\Downloads\\The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .extension(),
        " Mary Abbotts, Kensington, during the year 1874");
  });
}
