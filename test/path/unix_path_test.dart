import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("components", () {
    var components = UnixPath("/foo/bar/.././bar").components().iterator;
    components.moveNext();
    expect(components.current, RootDir(false));
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

    components = UnixPath("/").components().iterator;
    components.moveNext();
    expect(components.current, RootDir(false));
    expect(components.moveNext(), false);

    components = UnixPath("foo/bar").components().iterator;
    components.moveNext();
    expect(components.current, Normal("foo"));
    components.moveNext();
    expect(components.current, Normal("bar"));
    expect(components.moveNext(), false);
  });

  test("filePrefix", () {
    expect(UnixPath("foo.rs").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath("foo/").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath(".foo").filePrefixOpt().unwrap(), ".foo");
    expect(UnixPath(".foo.rs").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath("foo").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath("foo.tar.gz").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath("temp/foo.tar.gz").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath("/foo/.tmp.bar.tar").filePrefixOpt().unwrap(), "tmp");
    expect(UnixPath("").filePrefixOpt().isNone(), true);

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .filePrefixOpt()
            .unwrap(),
        "The Annual Report on the Health of the Parish of St");
  });

  test("fileStem", () {
    expect(UnixPath("foo.rs").fileStemOpt().unwrap(), "foo");
    expect(UnixPath("foo/").filePrefixOpt().unwrap(), "foo");
    expect(UnixPath(".foo").fileStemOpt().unwrap(), ".foo");
    expect(UnixPath(".foo.rs").fileStemOpt().unwrap(), ".foo");
    expect(UnixPath("foo").fileStemOpt().unwrap(), "foo");
    expect(UnixPath("foo.tar.gz").fileStemOpt().unwrap(), "foo.tar");
    expect(UnixPath("temp/foo.tar.gz").fileStemOpt().unwrap(), "foo.tar");
    expect(UnixPath("").fileStemOpt().isNone(), true);

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .fileStemOpt()
            .unwrap(),
        "The Annual Report on the Health of the Parish of St");
  });

  test("parent", () {
    expect(UnixPath("temp/foo.rs").parentOpt().unwrap(), UnixPath("temp"));
    expect(UnixPath("foo/").parentOpt().unwrap(), UnixPath(""));
    expect(UnixPath("/foo/").parentOpt().unwrap(), UnixPath("/"));
    expect(UnixPath(".foo").parentOpt().unwrap(), UnixPath(""));
    expect(UnixPath(".foo.rs").parentOpt().unwrap(), UnixPath(""));
    expect(UnixPath("foo").parentOpt().unwrap(), UnixPath(""));
    expect(UnixPath("foo.tar.gz").parentOpt().unwrap(), UnixPath(""));
    expect(UnixPath("temp/foo.tar.gz").parentOpt().unwrap(), UnixPath("temp"));
    expect(UnixPath("temp1/temp2/foo.tar.gz").parentOpt().unwrap(),
        UnixPath("temp1/temp2"));
    expect(UnixPath("temp1/temp2//foo.tar.gz").parentOpt().unwrap(),
        UnixPath("temp1/temp2"));
    expect(UnixPath("").parentOpt().isNone(), true);

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .parentOpt()
            .unwrap(),
        UnixPath("/Downloads"));
  });

  test("ancestors", () {
    var ancestors = UnixPath("/foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("/foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("/foo"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("/"));
    expect(ancestors.moveNext(), false);

    ancestors = UnixPath("../foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("../foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("../foo"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath(".."));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath(""));
    expect(ancestors.moveNext(), false);

    ancestors = UnixPath("foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("foo"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath(""));
    expect(ancestors.moveNext(), false);

    ancestors = UnixPath("foo/..").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("foo/.."));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("foo"));

    ancestors = UnixPath(
            "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
        .ancestors()
        .iterator;
    ancestors.moveNext();
    expect(
        ancestors.current,
        UnixPath(
            "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("/Downloads"));
    ancestors.moveNext();
    expect(ancestors.current, UnixPath("/"));
  });

  test("withExtension", () {
    expect(UnixPath("foo").withExtension("rs"), UnixPath("foo.rs"));
    expect(UnixPath("foo.rs").withExtension("rs"), UnixPath("foo.rs"));
    expect(UnixPath("foo.tar.gz").withExtension("rs"), UnixPath("foo.tar.rs"));
    expect(UnixPath("foo.tar.gz").withExtension(""), UnixPath("foo.tar"));
    expect(UnixPath("foo.tar.gz").withExtension("tar.gz"),
        UnixPath("foo.tar.tar.gz"));
    expect(UnixPath("/tmp/foo.tar.gz").withExtension("tar.gz"),
        UnixPath("/tmp/foo.tar.tar.gz"));
    expect(UnixPath("tmp/foo").withExtension("tar.gz"),
        UnixPath("tmp/foo.tar.gz"));
    expect(UnixPath("tmp/.foo.tar").withExtension("tar.gz"),
        UnixPath("tmp/.foo.tar.gz"));

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .withExtension(""),
        UnixPath(
            "/Downloads/The Annual Report on the Health of the Parish of St"));
  });

  test("withFileName", () {
    expect(UnixPath("foo").withFileName("bar"), UnixPath("bar"));
    expect(UnixPath("foo.rs").withFileName("bar"), UnixPath("bar"));
    expect(UnixPath("foo.tar.gz").withFileName("bar"), UnixPath("bar"));
    expect(
        UnixPath("/tmp/foo.tar.gz").withFileName("bar"), UnixPath("/tmp/bar"));
    expect(UnixPath("tmp/foo").withFileName("bar"), UnixPath("tmp/bar"));
    expect(UnixPath("/var").withFileName("bar"), UnixPath("/bar"));

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .withFileName("dave"),
        UnixPath("/Downloads/dave"));
  });

  test("extension", () {
    expect(UnixPath("foo").extension(), "");
    expect(UnixPath("foo.rs").extension(), "rs");
    expect(UnixPath("foo.tar.gz").extension(), "gz");
    expect(UnixPath("/tmp/foo.tar.gz").extension(), "gz");
    expect(UnixPath("tmp/foo").extension(), "");
    expect(UnixPath(".foo").extension(), "");
    expect(UnixPath("/var").extension(), "");
    expect(UnixPath("/var..d").extension(), "d");
    expect(UnixPath("/..d").extension(), "d");

    expect(
        UnixPath(
                "/Downloads/The Annual Report on the Health of the Parish of St. Mary Abbotts, Kensington, during the year 1874")
            .extension(),
        " Mary Abbotts, Kensington, during the year 1874");
  });

  //************************************************************************//

  test("Option UnixPath", () {
    final optionUnixPath = Option.of(UnixPath("UnixPath"));
    switch (optionUnixPath) {
      case Some(v: final _):
        break;
      default:
        fail("Should be Some");
    }
    final Option<String> optionString = Option.of("string");
    switch (optionString) {
      case Some(v: final _):
        break;
      default:
        fail("Should be Some");
    }
  });
}
