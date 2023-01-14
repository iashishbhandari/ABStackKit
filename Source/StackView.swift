// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

@IBDesignable
public class StackView: UIView {
    
    @IBInspectable
    public var animDuration: Double = 0 {
        didSet {
            isAnimated = (animDuration > 0)
        }
    }

    @IBInspectable
    public var spacing: CGFloat {
        get {
            return stackV.spacing
        }
        set {
            stackV.spacing = newValue
        }
    }
    
    @IBInspectable
    public var clockRadian: CGFloat = .pi*0 {
        didSet {
            scrollView.transform = scrollView.transform.rotated(by: clockRadian)
        }
    }
    
    public weak var delegate: StackViewEmbeddable? {
        didSet {
            if stackV.arrangedSubviews.count == 0,
                let delegate = self.delegate {
                delegate.willConfigure(self)
                for index in 0..<delegate.numberOfChildViews() {
                    addChildView(delegate.childViewForIndex(index))
                }
                switch axis {
                case .horizontal:
                    scrollView.contentOffset.x = 0
                case .vertical:
                    scrollView.contentOffset.y = 0
                @unknown default:
                    break
                }
            }
        }
    }
    
    public lazy var scrollView: UIScrollView = {
        let instance = UIScrollView(frame: .zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.layoutMargins = UIEdgeInsets.zero
        return instance
    }()
    
    public var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackV.axis = axis
            if didSetConstraints {
                NSLayoutConstraint.deactivate(self.constraints)
                NSLayoutConstraint.deactivate(scrollView.constraints)
                NSLayoutConstraint.deactivate(stackV.constraints)
                didSetConstraints = false
                setNeedsUpdateConstraints()
            }
        }
    }
    
    public var alignment: UIStackView.Alignment {
        get {
            return stackV.alignment
        }
        set {
            stackV.alignment = newValue
        }
    }
    
    public var distribution: UIStackView.Distribution {
        get {
            return stackV.distribution
        }
        set {
            stackV.distribution = newValue
        }
    }
    
    public var arrangedSubviews: [UIView] {
        get {
            return stackV.arrangedSubviews
        }
    }
    
    public override var layoutMargins: UIEdgeInsets {
        get {
            return scrollView.layoutMargins
        }
        set {
            scrollView.layoutMargins = newValue
        }
    }
    
    private var isAnimated = false
    private var didSetConstraints = false
    private var viewModel: StackViewModel!
    private var stackV: UIStackView = {
        let instance = UIStackView()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }()
    
    // MARK: Life cycle methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = StackViewModel(self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewModel = StackViewModel(self)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(stackV)
        setNeedsUpdateConstraints()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        if !didSetConstraints {
            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            stackV.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackV.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            stackV.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            stackV.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            
            switch axis {
            case .horizontal:
                stackV.heightAnchor.constraintEqualTo(anchor: scrollView.heightAnchor, identifier: ConstraintTag.H).isActive = true
            case .vertical:
                stackV.widthAnchor.constraintEqualTo(anchor: scrollView.widthAnchor, identifier: ConstraintTag.W).isActive = true
            @unknown default:
                break
            }
            
            didSetConstraints = true
        }
    }
}

// MARK: Protocol managing the lifecycle of a StackView
public protocol StackViewEmbeddable: AnyObject {
    func childViewForIndex(_ index: Int) -> UIView
    
    func didSelectChildView(_ view: UIView, index: Int) -> Void
    
    func didScrollToChildView(_ view: UIView, index: Int) -> Void
    
    func numberOfChildViews() -> Int
    
    func willConfigure(_ stackView: StackView) -> Void
}

// MARK: Permitted operations on a StackView
extension StackView {
    public enum Position {
        case first
        case index(Int)
        case last
    }
    
    public func addChildView(_ view: UIView?, atIndex index: Int =         Int.max) {
        guard let v = view else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onChildViewTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        v.addGestureRecognizer(tapGesture)
        v.isHidden = isAnimated
        
        var value = 0
        switch axis {
        case .horizontal:
            value = Int(v.bounds.width)
            addSizeAnchors(onView: v, size: CGSize(width: v.bounds.width, height: min(v.bounds.height, bounds.height-layoutMargins.top-layoutMargins.bottom)))
        case .vertical:
            value = Int(v.bounds.height)
            addSizeAnchors(onView: v, size: CGSize(width: min(v.bounds.width, bounds.width-layoutMargins.left-layoutMargins.right), height: v.bounds.height))
        @unknown default:
            break
        }
        
        if index < stackV.arrangedSubviews.count {
            v.tag = index
            stackV.insertArrangedSubview(v, at: index)
            viewModel.trackEndOffsets(forIndex: index, value: value+Int(spacing))
            viewModel.recalculateChildViewOffsets(fromIndex: index+1, delta: value)
        } else {
            v.tag = stackV.arrangedSubviews.count
            stackV.addArrangedSubview(v)
            viewModel.trackEndOffsets(forIndex: v.tag, value: value+Int(spacing))
        }
        
        if isAnimated {
            UIView.animate(withDuration: animDuration) {
                v.isHidden = false
            }
        }
    }
    
    @objc private func onChildViewTap(_ sender: UITapGestureRecognizer?) {
        if let v = sender?.view {
            delegate?.didSelectChildView(v, index: v.tag)
        }
    }
    
    public func removeChildView(_ view: UIView?) {
        guard let v = view else {
            return
        }
        if isAnimated {
            UIView.animate(withDuration: animDuration) {
                v.isHidden = true
            }
        }
        resizeChildView(v, newSize: .zero)
    }
    
    public func resizeChildView(_ view: UIView?, newSize: CGSize) {
        if let v = view {
            var delta = 0
            switch axis {
            case .horizontal:
                delta = Int(newSize.width - v.bounds.width)
            case .vertical:
                delta = Int(newSize.height - v.bounds.height)
            @unknown default:
                break
            }
            viewModel.recalculateChildViewOffsets(fromIndex: v.tag, delta: delta)
            v.constraint(withIdentifier: ConstraintTag.W)?.constant = min(newSize.width, stackV.bounds.width)
            v.constraint(withIdentifier: ConstraintTag.H)?.constant = min(newSize.height, stackV.bounds.height)
            if isAnimated {
                UIView.animate(withDuration: animDuration) {
                    self.stackV.layoutIfNeeded()
                }
            }
        }
    }
    
    public func scrollToChildView(position: Position) {
        switch position {
        case .first:
            scrollToChildView(index: 0)
        case .index(let index):
            scrollToChildView(index: index)
        case .last:
            scrollToChildView(index: stackV.arrangedSubviews.count-1)
        }
    }
    
    private func scrollToChildView(index: Int) {
        if index < stackV.arrangedSubviews.count {
            let childView = stackV.arrangedSubviews[index]
            UIView.animate(withDuration: animDuration) {
                switch self.axis {
                case .horizontal:
                    self.scrollView.contentOffset.x = childView.frame.minX
                case .vertical:
                    self.scrollView.contentOffset.y = childView.frame.minY
                @unknown default:
                    break
                }
            }
        }
    }
    
    public func setCustomSpacing(_ spacing: CGFloat, atIndex index: Int) {
        if index > 0 && index < stackV.arrangedSubviews.count {
            stackV.setCustomSpacing(spacing, after: stackV.arrangedSubviews[index-1])
        }
    }
}

// MARK: Observing the scrollView on a StackView
extension StackView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.childViewOffsetOnScrollView(scrollView)
    }
}
