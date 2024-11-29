# Mutex
***
`Mutex` is used to ensure that only one task can perform a critical section of code at a time.
`Mutex` uses a fifo model to prevent starvation.
e.g. Transactions -

```dart
class Account {
  int balance;

  Account(this.balance);
}

final mutex = Mutex();

Future<Result<(),Exception>> transfer(Account from, Account to, int amount) async {
  await mutex.withLock(() async {
    final fromBalance = from.balance;
    final toBalance = to.balance;

    if (fromBalance < amount) {
      return Err(Exception('Insufficient funds for transfer.'));
    }

    // Simulate some processing delay
    await Future.delayed(Duration(milliseconds: 100));

    from.balance = fromBalance - amount;
    to.balance = toBalance + amount;

    return Ok(());
  });
}

void main() async {
  final account1 = Account(100);
  final account2 = Account(50);

  await Future.wait([
    transfer(account1, account2, 30),
    transfer(account2, account1, 20),
  ]);
}
```

