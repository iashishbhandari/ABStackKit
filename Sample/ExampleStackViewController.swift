// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import ABStackKit

class ExampleStackViewController: StackViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnStackView(_:)))
        tapGesture.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapOnStackView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func willConfigure(_ stackView: StackView) {
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.animDuration = 0.27
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    }
    
    override func numberOfChildViews() -> Int {
        return 9
    }
    
    override func childViewForIndex(_ index: Int) -> UIView {
        let childView = UIView(frame: CGRect(x: 0, y: 0, width: Int(arc4random_uniform(UInt32(view.bounds.width))), height: Int(arc4random_uniform(UInt32(view.bounds.height)))))
        childView.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        
        let lblNumber = UILabel()
        lblNumber.text = "\(index+1)"
        lblNumber.textColor = .white
        lblNumber.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        childView.addSubview(lblNumber)
        childView.addCenterXYAnchors(onView: lblNumber)

        return childView
    }
    
    override func didSelectChildView(_ view: UIView, index: Int) {
        stackView.resizeChildView(view, newSize: CGSize(width: view.bounds.size.height, height: view.bounds.size.width))
    }
    
    override func didScrollToChildView(_ view: UIView, index: Int) {
        print("Scrolled on ChildView \(index)")
    }
}
