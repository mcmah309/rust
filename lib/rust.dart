/// rust comes with a variety of things in its core library.
/// However, if you had to manually import every single thing that you used,
/// it would be very verbose. This library exports everything for you.
library rust;

// array
export "src/array/array.dart";
export 'src/array/array_extensions.dart';

// cell
export 'src/cell/lazy_cell_async/lazy_cell_async.dart';
export 'src/cell/lazy_cell_async/non_nullable_lazy_cell_async.dart';
export 'src/cell/lazy_cell_async/nullable_lazy_cell_async.dart';
export 'src/cell/cell/cell.dart';
export 'src/cell/lazy_cell/lazy_cell.dart';
export 'src/cell/lazy_cell/non_nullable_lazy_cell.dart';
export 'src/cell/lazy_cell/nullable_lazy_cell.dart';
export 'src/cell/once_cell/once_cell.dart';
export 'src/cell/once_cell/non_nullable_once_cell.dart';
export 'src/cell/once_cell/nullable_once_cell.dart';

// convert
export 'src/convert/convert.dart';

// iter
export "src/iter/iterator.dart";

// ops
export 'src/ops/range_extensions.dart';
export 'src/ops/range.dart';
export 'src/ops/record_extensions.dart';

// option
export 'src/option/option.dart';

// panic
export 'src/panic/panic.dart';
export 'src/panic/unreachable.dart';

// path
export 'src/path/path.dart';

// result
export 'src/result/guard.dart';
export 'src/result/record_to_result_extensions.dart';
export 'src/result/result.dart';
export 'src/result/result_extensions.dart';

// slice
export 'src/slice/slice.dart';
export 'src/slice/errors.dart';

// str
export 'src/str/str.dart';

// sync
// Isolates not supported on web. https://dart.dev/language/concurrency#concurrency-on-the-web
export 'src/sync/isolate_channel.dart'
    if (dart.library.html) ''
    if (dart.library.js) '';
// Int64 accessor not supported by dart2js.
export 'src/sync/send_codec.dart'
    if (dart.library.html) ''
    if (dart.library.js) '';
export 'src/sync/channel.dart' hide ReceiverImpl;
export 'src/sync/mutex.dart';

// vec
export 'src/vec/vec_extensions.dart';
export 'src/vec/vec.dart';
