# Development

记录开发过程中的相关事项

## Overview


### Build Errors

1. SwiftData Debug on MacOS When Schema Changed


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

