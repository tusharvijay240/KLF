# 🛠 Toastify - A Customizable Toast Library for Swift

[![CI Status](https://img.shields.io/travis/tusharvijay24/Toastify.svg?style=flat)](https://travis-ci.org/tusharvijay24/Toastify)
[![Version](https://img.shields.io/cocoapods/v/Toastify.svg?style=flat)](https://cocoapods.org/pods/Toastify)
[![License](https://img.shields.io/cocoapods/l/Toastify.svg?style=flat)](https://cocoapods.org/pods/Toastify)
[![Platform](https://img.shields.io/cocoapods/p/Toastify.svg?style=flat)](https://cocoapods.org/pods/Toastify)


Toastify is a lightweight and customizable **toast notification library** for iOS, built in Swift. It allows you to display toast messages anywhere in your app with full customization.

---

## 📌 Features
✅ Simple and easy to use  
✅ Fully customizable (text, background color, duration, position)  
✅ Works as an **independent floating view**  
✅ Supports multiple positions: **Top, Middle, Bottom**  
✅ Supports animations  
✅ No interference with UI interactions  

---

## 📥 Installation
### Using CocoaPods
To install **Toastify**, add the following line to your `Podfile`:

```ruby
pod 'Toastify', :git => 'https://github.com/tusharvijay24/Toastify.git'
```

Then, run:

```sh
pod install
```

---

## 🚀 How to Use
### 1️⃣ Import Toastify
```swift
import Toastify
```

---

### 2️⃣ Show a Basic Toast
```swift
ToastifyManager.shared.showMessage("Hello, Toastify!")
```

---

### 3️⃣ Customize Toast Appearance
```swift
ToastifyManager.shared.showMessage(
    "Custom Toast Message",
    duration: 3.0,
    backgroundColor: .blue,
    textColor: .white,
    position: .middle
)
```

---

### 4️⃣ Using ToastConfig for More Customization
```swift
let toastConfig = ToastConfig(
    message: "This is a custom toast!",
    duration: 2.5,
    backgroundColor: .black,
    textColor: .white,
    position: .bottom,
    animation: true
)

ToastifyManager.shared.showToast(config: toastConfig)
```

---

## 📌 Toast Positions
You can position the toast in **four different locations**:

| Position      | Description |
|--------------|-------------|
| `.top`       | Displays the toast at the top |
| `.middle`    | Displays the toast in the center |
| `.bottom`    | Displays the toast at the bottom |

Example:
```swift
ToastifyManager.shared.showMessage(
    "Toast at the top!",
    position: .top
)
```

---

## 📦 Example Usage in ViewController
```swift
import UIKit
import Toastify

class ViewController: UIViewController {
    @IBOutlet weak var txtTesting: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapTest(_ sender: UIButton) {
        if txtTesting.text != "" {
            // Do nothing
        } else {
            ToastifyManager.shared.showMessage(
                "Please enter text before proceeding!",
                duration: 3.0,
                backgroundColor: .red,
                textColor: .white,
                position: .aboveBottom
            )
        }
    }
}
```

---

## 📄 License
Toastify is available under the **MIT License**. See the `LICENSE` file for more details.

