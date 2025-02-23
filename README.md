# KMP-iOS

This project demonstrates how to use a **KMP (Kotlin Multiplatform) layer** to share code between **Android and iOS**. The shared code is written in **Kotlin** and compiled into an **.xcframework** for use in the iOS application.

By using this approach, we can **deliver a product with highly consistent behavior across platforms**, ensuring that the core logic remains the same while only platform-specific implementations are handled separately.

The **KMPModule** includes `VehicleObserver`, a **thread-safe** class where all functions are designed to be safely accessed from multiple threads.

The **MyVehicle** app integrates with the **KMPModule APIs** to display vehicle data.

## Generating the .xcframework

To generate the `.xcframework` from **KMPModule**, run the following commands:

```
./gradlew clean
./gradlew assembleXCFramework
```

The generated `.xcframework` will be located at: `/KMP-iOS-MyVehicle/KMPModule/build/xcframework/SharedKMP.xcframework`

## Using SharedKMP in MyVehicle (iOS App)

The `SharedKMP.xcframework` is expected to be located at: `../KMPModule/build/xcframework/SharedKMP.xcframework`

We can then **import `SharedKMP`** in the iOS project to access all the Kotlin APIs that we have implemented.

## Screenshot

![demo](https://github.com/user-attachments/assets/64102b27-3635-4b7a-a2d0-06dd28f53999)

