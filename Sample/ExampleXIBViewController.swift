// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import ABStackKit


class ExampleXIBViewController: UIViewController {
    @IBOutlet weak var stackView: StackView!
    
    typealias BarButtonSelector = (_ title: String?) -> Void
    var onBarButtonSelection: BarButtonSelector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnStackView(_:)))
        tapGesture.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func tapOnBarButton(_ sender: Any) {
        onBarButtonSelection?((sender as? UIBarButtonItem)?.title)
    }
    
    @objc private func tapOnStackView(_ sender: UITapGestureRecognizer) {
        stackView.backgroundColor = .randomColor
    }
}

extension ExampleXIBViewController: StackViewEmbeddable {
    func willConfigure(_ stackView: StackView) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    }
    
    func numberOfChildViews() -> Int {
        return 5
    }
    
    func childViewForIndex(_ index: Int) -> UIView {
        switch index {
        case 1:
            let childView = HorizontalStackView.loadFromNIb()
            childView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: childView.bounds.height)
            return childView
            
        case 3:
            let childView = StackViewButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2))
            return childView
            
        default:
            let childView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height/2))
            childView.backgroundColor = .blue
            
            let lblNumber = UILabel()
            lblNumber.text = "View \(index+1)"
            lblNumber.textColor = .white
            childView.addSubview(lblNumber)
            childView.addCenterXYAnchors(onView: lblNumber)
            
            return childView
        }
    }
    
    func didSelectChildView(_ view: UIView, index: Int) {
        view.backgroundColor = .randomColor
    }
    
    func didScrollToChildView(_ view: UIView, index: Int) {
        print("Scrolled on ChildView \(index+1)")
    }
}
