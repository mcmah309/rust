# Env

Env introduces `Env` for handling the environment. It works like `Platform`,
except it is cross-platform (also works on web), since it is independent of `dart:io`, and has additional methods.

```dart
void main(){
    if(Env.isWeb) {
        print("On web, doing nothing.");
    }
    else if(Env.isLinux || Env.isMacOs) {
        Env.setCurrentDirectory = "/";
        print("Moved current directory to root");
    }
    ...
}
```