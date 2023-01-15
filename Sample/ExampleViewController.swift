// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import ABStackKit

final class ExampleViewController: UIViewController {
    var onViewSelection: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the stack view
        let stackView = StackView(frame: view.frame)
        stackView.delegate = self

        // embedd to controller's view
        view.addSubview(stackView)
        view.addEdgeAnchors(onView: stackView)
        
        // add a tap gesture to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnStackView(_:)))
        tapGesture.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapOnStackView(_ sender: UITapGestureRecognizer) {
        onViewSelection?()
    }
}

extension ExampleViewController: StackViewEmbeddable {
    func willConfigure(_ stackView: StackView) {
        stackView.spacing = 9
        stackView.axis = .vertical
        stackView.animDuration = 0.99
        stackView.clockRadian = 0.09
        stackView.alignment = .center
        stackView.backgroundColor = .red
        stackView.distribution = .equalSpacing
        stackView.scrollView.showsVerticalScrollIndicator = false
    }
    
    func numberOfChildViews() -> Int {
        return 6
    }
    
    func childViewForIndex(_ index: Int) -> UIView {
        let childView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height/4))
        childView.backgroundColor = .blue
        childView.isUserInteractionEnabled = true
        
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
    
    func didScrollToChildView(_ view: UIView, index: Int) {
        print("Scrolled on ChildView \(index+1)")
    }
}


