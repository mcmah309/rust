# RwLock
***
`RwLock` is used in critical sections to allow multiple concurrent read operations while ensuring that write operations are exclusive.
Dart being single threaded, means it is less common to need a `RwLock`, but they are still useful 
e.g. reading and writing to data sources or transactions. `RwLock` uses a fifo model to prevent starvation.

```dart
import 'dart:async';

class DataSource {
  final String name;
  DataSource(this.name);

  Future<String> read() async {
    print('Reading from $name');
    await Future.delayed(Duration(milliseconds: 100)); // Simulate delay
    return 'Data from $name';
  }

  Future<void> write(String data) async {
    print('Writing to $name: $data');
    await Future.delayed(Duration(milliseconds: 100)); // Simulate delay
  }
}

class DataManager {
  final List<DataSource> _dataSources;
  final RwLock _rwLock = RwLock();

  DataManager(this._dataSources);

  Future<List<String>> readFromAll() async {
    return await _rwLock.withReadLock(() async {
      final results = <String>[];
      for (var dataSource in _dataSources) {
        results.add(await dataSource.read());
      }
      return results;
    });
  }

  Future<void> writeToAll(String data) async {
    await _rwLock.withWriteLock(() async {
      for (var dataSource in _dataSources) {
        await dataSource.write(data);
      }
    });
  }
}

void main() async {
  final dataSources = [DataSource('DB1'), DataSource('DB2'), DataSource('DB3')];
  final manager = DataManager(dataSources);

  await Future.wait([
    manager.readFromAll().then((data) => print('Read: $data')),
    manager.readFromAll().then((data) => print('Read: $data')),
    manager.writeToAll('New Data'),
  ]);

  print('All operations completed');
}
```