import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  test("ResultOnOptionExtension ok", () {
    Result<int, String> okResult = Ok(5);
    expect(okResult.ok(), Some(5));

    Result<int, String> errResult = Err("Error");
    expect(errResult.ok(), None);
  });

  test("OkOnOptionExtension ok", () {
    Ok<int, String> okResult = Ok(5);
    expect(okResult.ok(), Some(5));
  });

  test("ErrOnOptionExtension ok", () {
    Err<int, String> errResult = Err("Error");
    expect(errResult.ok(), None);
  });

  test("ResultOptionExtension transpose", () {
    Result<Option<int>, String> okSomeResult = Ok(Some(5));
    expect(okSomeResult.transpose(), Some(Ok(5)));

    Result<Option<int>, String> okNoneResult = Ok(None);
    expect(okNoneResult.transpose(), None);

    Result<Option<int>, String> errResult = Err("Error");
    expect(errResult.transpose(), Some(Err("Error")));
  });

  test("OptionResultExtension transpose", () {
    Option<Result<int, String>> someOkOption = Some(Ok(5));
    expect(someOkOption.transpose(), Ok(Some(5)));

    Option<Result<int, String>> someErrOption = Some(Err("Error"));
    expect(someErrOption.transpose(), Err("Error"));

    Option<Result<int, String>> noneOption = None;
    expect(noneOption.transpose(), Ok(None));
  });
}
