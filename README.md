# ABStackKit

Written in Swift 5, presenting a colourful scrollable StackView. Simply manage the lifecycle of the StackView via StackViewEmbeddable protocol or subclassing the StackViewController. Additionally if you need to colour its background or apply rotation on it or just use it on a portion of your view, this is the one library that you need. Only Swift compatible.


## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for both Swift and Objective-C. ABStackKit is available through CocoaPods. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To install it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

target 'TargetName' do
    pod "ABStackKit"
end
```
Then, run the following command:

```bash
$ pod install
```

## Usage
### Sample Code (Swift)

```swift
import ABStackKit

// setup the stack view
let stackView = StackView(frame: view.frame)
stackView.delegate = self

// embedd to your controller's view
view.addSubview(stackView)
view.addEdgeAnchors(onView: stackView)

// implement methods from StackViewEmbeddable protocol
func willConfigure(_ stackView: StackView) {
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = 9
    stackView.animDuration = 0.99
    stackView.clockRadian = .pi/99
    stackView.backgroundColor = .red
    stackView.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
}
    
func numberOfChildViews() -> Int {
    return 6
}
    
func childViewForIndex(_ index: Int) -> UIView {
    let childView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height/2))
    childView.backgroundColor = .blue
    
    let lblNumber = UILabel()
    lblNumber.text = "View \(index+1)"
    lblNumber.textColor = .white
    childView.addSubview(lblNumber)
    childView.addCenterXYAnchors(onView: lblNumber)
    
    return childView
}

func didSelectChildView(_ view: UIView, index: Int) {
    if let height = view.constraint(withIdentifier: ConstraintTag.H)?.constant {
	    view.constraint(withIdentifier: ConstraintTag.H)?.constant = height/2
	    UIView.animate(withDuration: 0.25) {
	        view.superview?.layoutIfNeeded()
	    }
    }
}

func didScrollToChildView(_ view: UIView, index: Int) {}

// ...
```

## Communication

If you see a way to improve the project :

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an [issue][].
- If you **have a feature request**, open an [issue][].
- If you **want to contribute**, submit a [pull request].

Recommend following [GitHub Swift Style Guide][]

Thanks! :v:

[issue]: https://github.com/iashishbhandari/ABStackKit/issues
[pull request]: https://github.com/iashishbhandari/ABStackKit/pulls
[GitHub Swift Style Guide]: https://github.com/github/swift-style-guide

## Author

Ashish Bhandari, ashishbhandariplus@gmail.com

## License

ABStackKit is available under the MIT license. See the [`LICENSE`](LICENSE) file for more info.
