# Development

记录开发过程中的相关事项

## Overview

### Preview Errors

1. Debug SwiftData width Previews
> how to delete all data about previews to make app works


### Build Errors

1. SwiftData Debug on MacOS When Schema Changed
> how to delete all data about swiftdata to make app works

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

