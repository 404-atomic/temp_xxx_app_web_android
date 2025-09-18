# 环境

| Tool     | Version   | Notes                                |
|----------|-----------|--------------------------------------|
| Gradle   | 8.0.2     | Kotlin 1.8.10, Groovy 3.0.13, Ant 1.10.11 |
| JVM      | 17.0.11   | JetBrains OpenJDK, 64-Bit            |
| OS       | Windows Server 2022 (amd64) | Kernel 10.0         |
| Java     | 17.0.11   | OpenJDK Runtime Environment          |
| Flutter  | 3.24.3    | Stable channel, Dart 3.5.3, DevTools 2.37.3 |

> 仅能在 `android\` 目录下运行才能正确编译生成 APK：
>
> ```sh
> build.bat
> ```
>

### 注意事项

`GeneratedPluginRegistrant` 会在执行 `flutter pub get` 时在构建目录中自动生成。  
如果源码中已经存在旧的 `src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java` 文件，编译器会错误地引用这个过时的文件，从而导致缺少 `io.flutter.Log` 和 `FlutterEngine` 等类的编译错误。  

**请不要运行 `flutter pub get`**，以避免生成该文件。  

如果不小心运行了 `flutter pub get`，请检查并删除以下路径下的文件：
```path 
src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java\
```