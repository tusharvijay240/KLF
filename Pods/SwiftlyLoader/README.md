# SwiftlyLoader

[![CI Status](https://img.shields.io/travis/tusharvijay24/SwiftlyLoader.svg?style=flat)](https://travis-ci.org/tusharvijay24/SwiftlyLoader)
[![Version](https://img.shields.io/cocoapods/v/SwiftlyLoader.svg?style=flat)](https://cocoapods.org/pods/SwiftlyLoader)
[![License](https://img.shields.io/cocoapods/l/SwiftlyLoader.svg?style=flat)](https://cocoapods.org/pods/SwiftlyLoader)
[![Platform](https://img.shields.io/cocoapods/p/SwiftlyLoader.svg?style=flat)](https://cocoapods.org/pods/SwiftlyLoader)

## Example

To run the example project, clone the repo, and run:

```sh
git clone https://github.com/tusharvijay24/SwiftlyLoader.git
cd SwiftlyLoader/Example
pod install
open SwiftlyLoader.xcworkspace
```

## Requirements
- iOS 13.0+
- Swift 5.0+

## Installation

SwiftlyLoader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftlyLoader', :git => 'https://github.com/tusharvijay24/SwiftlyLoader.git'
```

Then run:
```sh
pod install
```

## Usage

### Import SwiftlyLoader
```swift
import SwiftlyLoader
```

### Show Loader
```swift
SwiftLoader.shared.show()
```

### Hide Loader
```swift
SwiftLoader.shared.hide()
```

### Custom Configuration
```swift
let config = SwiftlyLoaderConfig(
            indicatorColor: .red, indicatorSize: 80.0, loaderType: .lottie(animation: .infinityLine),
            containerSize: 100.0
        )
SwiftLoader.shared.show(config: customConfig)
```

## Author

tusharvijay24, tusharvijayvargiya24112000@gmail.com

## License

SwiftlyLoader is available under the MIT license. See the LICENSE file for more info.
