// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import ABStackKit

// MARK: 1 - StackView embedded to XIB
class ExampleXIBViewController: UIViewController {
   
    @IBOutlet weak var stackView: StackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnStackView(_:)))
        tapGesture.numberOfTapsRequired = 1
        stackView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func tapOnStackView(_ sender: UITapGestureRecognizer) {
        stackView.axis = (stackView.axis == .vertical) ? .horizontal : .vertical
        for view in stackView.subviews {
            stackView.resizeChildView(view, newSize: CGSize(width: view.bounds.size.height, height: view.bounds.size.width))
        }
    }
    
    @IBAction func tapOnBarButton(_ sender: Any) {
        if let btn = sender as? UIBarButtonItem {
            switch btn.title {
            case "2":
                self.present(ExampleViewController(), animated: true, completion: nil)
            case "3":
                self.present(ExampleStackViewController(), animated: true, completion: nil)
            default: break
            }
        }
    }
}

extension ExampleXIBViewController: StackViewEmbeddable {
    
    func willConfigure(_ stackView: StackView) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.layoutMargins = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    }
    
    func numberOfChildViews() -> Int {
        return 6
    }
    
    func childViewForIndex(_ index: Int) -> UIView {
        let childView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height/2))
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
        stackView.resizeChildView(view, newSize: CGSize(width: view.bounds.height, height: view.bounds.width))
    }
    
    func didScrollToChildView(_ view: UIView, index: Int) {
        print("View \(index+1)")
        
    }
}

