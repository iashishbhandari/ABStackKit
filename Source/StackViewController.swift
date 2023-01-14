// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

open class StackViewController: UIViewController, StackViewEmbeddable {
    open var stackView: StackView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        stackView = StackView(frame: view.frame)
        stackView.delegate = self
        view.addSubview(stackView)
        view.addEdgeAnchors(onView: stackView)
    }

    open func willConfigure(_ stackView: StackView) {
        // override this method to configure your StackView
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }
    
    open func numberOfChildViews() -> Int {
        // override this method to provide the number of child views
        return 0
    }
    
    open func childViewForIndex(_ index: Int) -> UIView {
        // override this method to provide the child view at index
        return UIView(frame: .zero)
    }
    
    open func didSelectChildView(_ view: UIView, index: Int) {
        // override this method to perform any action at the indexed child view when gets selected on your StackView
    }
    
    open func didScrollToChildView(_ view: UIView, index: Int) {
        // override this method to perform any action at the indexed child view when gets scrolled on your StackView
    }
}
