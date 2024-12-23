# Env

Env introduces [Env](https://pub.dev/documentation/rust/latest/rust/Env-class.html) for handling the environment. It works like `Platform`,
except it is cross-platform (also works on web), since it is independent of `dart:io`, and has additional methods.

```dart
void main(){
    if(Env.isWeb) {
        print("On web, doing nothing.");
    }
    else if(Env.isLinux || Env.isMacOs) {
        Env.currentDirectory = "/";
        print("Moved current directory to root");
    }
    ...
}
```