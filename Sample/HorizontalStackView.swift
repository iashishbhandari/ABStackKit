// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import ABStackKit

class HorizontalStackView: UIView {
    @IBOutlet weak var stackView: StackView!
    
    static func loadFromNIb() -> HorizontalStackView {
        if let v = UIView.loadViewFromNIB(name: "HorizontalStackView") as? HorizontalStackView {
            return v
        }
        return HorizontalStackView(frame: .zero)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        stackView.delegate = self
    }
}

extension HorizontalStackView: StackViewEmbeddable {
    func willConfigure(_ stackView: StackView) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 9
        stackView.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    }
    
    func numberOfChildViews() -> Int {
        return 9
    }
    
    func childViewForIndex(_ index: Int) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: stackView.bounds.width/2, height: stackView.bounds.height))
        v.backgroundColor = .randomColor
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
        print("Scrolled to ChildView \(index+1)")
    }
}
