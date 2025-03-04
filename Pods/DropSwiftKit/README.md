# DropSwiftKit

[![CI Status](https://img.shields.io/travis/tusharvijay24/DropSwiftKit.svg?style=flat)](https://travis-ci.org/tusharvijay24/DropSwiftKit) [![Version](https://img.shields.io/cocoapods/v/DropSwiftKit.svg?style=flat)](https://cocoapods.org/pods/DropSwiftKit) [![License](https://img.shields.io/cocoapods/l/DropSwiftKit.svg?style=flat)](https://cocoapods.org/pods/DropSwiftKit) [![Platform](https://img.shields.io/cocoapods/p/DropSwiftKit.svg?style=flat)](https://cocoapods.org/pods/DropSwiftKit)

**DropSwiftKit** is a Swift library that provides a customizable dropdown menu component for iOS applications. It allows developers to present a list of actions in a sleek and user-friendly manner.

## Features

- [x] Customizable dropdown menu with icons and titles.
- [x] Multiple presentation styles: `.sheet` and `.dropdown`.
- [x] Easy integration with UIButton and other UI components.
- [x] Supports action handling with completion closures.

## Requirements

- iOS 11.0+
- Swift 5.0+

## Installation

### CocoaPods

DropSwiftKit is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your `Podfile`:

```ruby
pod 'DropSwiftKit', :git => 'https://github.com/tusharvijay24/DropSwiftKit.git'
```

Then, run:

```bash
pod install
```

## Usage

### Importing the Library

```swift
import DropSwiftKit
```

### Presenting a Dropdown Menu

To present a dropdown menu from a UIButton:

```swift
@IBAction func didTapOpenDropDown(_ sender: UIButton) {
    let actions = [
        DropdownAction(title: "Copy", icon: UIImage(systemName: "doc.on.doc")) {
            print("Copy Selected")
        },
        DropdownAction(title: "Favorite", icon: UIImage(systemName: "heart")) {
            print("Favorite Selected")
        },
        DropdownAction(title: "Duplicate", icon: UIImage(systemName: "plus.square.on.square")) {
            print("Duplicate Selected")
        },
        DropdownAction(title: "Hide", icon: UIImage(systemName: "eye.slash")) {
            print("Hide Selected")
        }
    ]
    
    DropdownLauncher.show(from: sender, actions: actions, style: .sheet)
}
```

### Presentation Styles

DropSwiftKit supports two presentation styles:

- `.sheet`: Presents the dropdown as a sheet from the bottom.
- `.dropdown`: Presents the dropdown as a popover from the sender view.

Example using `.dropdown` style:

```swift
DropdownLauncher.show(from: sender, actions: actions, style: .dropdown)
```

## Customization

You can customize the appearance of the dropdown menu by modifying the `DropdownAction` properties or by extending the library to fit your needs.

## Example Project

To see DropSwiftKit in action, clone the repository and run the example project:

```bash
git clone https://github.com/tusharvijay24/DropSwiftKit.git
cd DropSwiftKit/Example
pod install
open DropSwiftKit.xcworkspace
```

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

## Author

Tushar Vijayvargiya  
[tusharvijayvargiya24112000@gmail.com](mailto:tusharvijayvargiya24112000@gmail.com)

## License

DropSwiftKit is available under the MIT license. See the [LICENSE](https://github.com/tusharvijay24/DropSwiftKit/blob/main/LICENSE) file for more information.

