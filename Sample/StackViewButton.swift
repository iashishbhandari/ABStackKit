// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import ABStackKit

class StackViewButton: UIButton {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setBackgroundImage(UIImage.image(size: bounds.size), for: .normal)
        let stackView = StackView(frame: bounds)
        stackView.delegate = self
        self.addSubview(stackView)
        self.addEdgeAnchors(onView: stackView)
    }
}

extension StackViewButton: StackViewEmbeddable {
    func willConfigure(_ stackView: StackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 27
    }
    
    func numberOfChildViews() -> Int {
        return 9
    }
    
    func childViewForIndex(_ index: Int) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width/3, height: bounds.height/9))
        v.backgroundColor = .randomColor
        v.isUserInteractionEnabled = true
        let lblNumber = UILabel()
        lblNumber.text = "\(index+1)"
        lblNumber.textColor = .white
        v.addSubview(lblNumber)
        v.addCenterXYAnchors(onView: lblNumber)
        return v
    }
    
    func didSelectChildView(_ view: UIView, index: Int) {
        view.backgroundColor = .randomColor
    }
    
    func didScrollToChildView(_ view: UIView, index: Int) {
        print("Scrolled on ChildView \(index+1)")
    }
}
