# Development

记录开发过程中的相关事项

## Overview

### Preview Errors

1. Debug SwiftData width Previews
> how to delete all data about previews to make app works


### Build Errors

1. SwiftData Debug on MacOS When Schema Changed and not migration plan

```swift
func destroyPersistentStore() {
    #if DEBUG
        guard ProcessInfo.processInfo.environment["RESET_SWIFTDATA"] == "1"
        else {
            return
        }
        let storeURL = URL.applicationSupportDirectory.appending(
            path: "default.store"
        )
        // 删除主文件及关联文件
        let shmURL = storeURL.appendingPathExtension("shm")
        let walURL = storeURL.appendingPathExtension("wal")
        [storeURL, shmURL, walURL].forEach { url in
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    #endif
}
```

### CodeSign Failed

1. resource fork, Finder information, or similar detritus not allowed

    ```
    resource fork, Finder information, or similar detritus not allowed
    Command CodeSign failed with a nonzero exit code
    ```
    
    workaroud: 
    ```bash
    xattr -cr <path_to_app_bundle>
    ```
    
    [reason link](https://developer.apple.com/library/archive/qa/qa1940/_index.html)

