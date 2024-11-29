# Path

This library introduces path types for working with file paths in a structured
and type-safe manner, supporting Unix (POSIX) and Windows file systems. All Path types are extension
types of string, so they are zero runtime cost.

## Types

[Path](https://pub.dev/documentation/rust/latest/rust/Path-extension-type.html) - A platform 
dependent path type - uses `WindowPath` on windows and `UnixPath` on all other platforms.

[UnixPath](https://pub.dev/documentation/rust/latest/rust/UnixPath-extension-type.html) - A Unix path type.

[WindowsPath](https://pub.dev/documentation/rust/latest/rust/WindowsPath-extension-type.html) - A Windows path type.


### Basic Operations
Create a path and perform basic operations:

```dart
import 'package:rust/rust.dart';

void main() {
  var path = UnixPath('/foo/bar/baz.txt');

  print('File name: ${path.fileName()}'); // Output: baz.txt
  print('Extension: ${path.extension()}'); // Output: txt
  print('Is absolute: ${path.isAbsolute()}'); // Output: true

  var parent = path.parent();
  if (parent.isSome()) {
    print('Parent: ${parent.unwrap()}'); // Output: /foo/bar
  }

  var newPath = path.withExtension('md');
  print('New path with extension: $newPath'); // Output: /foo/bar/baz.md
}
```
### Extracting Components
Get the components of a path:
```dart
void main() {
  var path = UnixPath('/foo/bar/baz.txt');
  var components = path.components().toList();

  for (var component in components) {
    print(component); // Output: /, foo, bar, baz.txt
  }
}
```
### Ancestors
Retrieve all ancestors of a path:
```dart
void main() {
  var path = UnixPath('/foo/bar/baz.txt');

  for (var ancestor in path.ancestors()) {
    print(ancestor);
    // Output:
    // /foo/bar/baz.txt
    // /foo/bar
    // /foo
    // /
  }
}
```
### File System Interaction
Check if a path exists and get metadata:

```dart
void main() {
  var path = UnixPath('/foo/bar/baz.txt');

  if (path.existsSync()) {
    var metadata = path.metadataSync();
    print('File size: ${metadata.size}');
    print('Last modified: ${metadata.modified}');
  } else {
    print('Path does not exist.');
  }
}
```