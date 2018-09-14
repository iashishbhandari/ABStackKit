// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

@available(iOS 9.0, *)
open class StackViewController: UIViewController {
    
    open var stackView: StackView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        stackView = StackView(frame: view.frame)
        stackView.delegate = self
        view.addSubview(stackView)
        view.addEdgeAnchors(onView: stackView)
    }
}

extension StackViewController: StackViewEmbeddable {
    
    open func willConfigure(_ stackView: StackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }
    
    open func numberOfChildViews() -> Int {
        return 0
    }
    
    open func childViewForIndex(_ index: Int) -> UIView {
        return UIView(frame: .zero)
    }
    
    open func didSelectChildView(_ view: UIView, index: Int) {}
    
    open func didScrollToChildView(_ view: UIView, index: Int) {}
}
