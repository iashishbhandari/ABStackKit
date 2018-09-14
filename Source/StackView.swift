// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

@available(iOS 9.0, *)
@IBDesignable public class StackView: UIView {
    
    fileprivate var isAnimated = false
    fileprivate var didSetConstraints = false
    fileprivate var childViewEndOffsets = [Int]()
    fileprivate var childViewNotifiedIndex: Int = -1
    fileprivate var scrollLastContentOffset: CGFloat = -1
    fileprivate var childViewRangeOffsets = [CountableClosedRange<Int>]()

    fileprivate var stackV: UIStackView = {
        let instance = UIStackView()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }()
    
    @IBInspectable public var animDuration: Double = 0 {
        didSet {
            isAnimated = (animDuration > 0)
        }
    }

    @IBInspectable public var spacing: CGFloat {
        get {
            return stackV.spacing
        }
        set {
            stackV.spacing = newValue
        }
    }
    
    @IBInspectable public var clockRadian: CGFloat = .pi*0 {
        didSet {
            scrollView.transform = scrollView.transform.rotated(by: clockRadian)
        }
    }
    
    weak public var delegate: StackViewEmbeddable? {
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
                }
                childViewNotifiedIndex = 0
            }
        }
    }
    
    public lazy var scrollView: UIScrollView = {
        let instance = UIScrollView(frame: .zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.layoutMargins = UIEdgeInsets.zero
        return instance
    }()
    
    public var axis: UILayoutConstraintAxis = .vertical {
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
    
    public var alignment: UIStackViewAlignment {
        get {
            return stackV.alignment
        }
        set {
            stackV.alignment = newValue
        }
    }
    
    public var distribution: UIStackViewDistribution {
        get {
            return stackV.distribution
        }
        set {
            stackV.distribution = newValue
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

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(stackV)
        setNeedsUpdateConstraints()
    }
    
    override public func updateConstraints() {
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
            }
            
            didSetConstraints = true
        }
    }
}

public protocol StackViewEmbeddable: class {
    func willConfigure(_ stackView: StackView) -> Void
    func numberOfChildViews() -> Int
    func childViewForIndex(_ index: Int) -> UIView
    func didSelectChildView(_ view: UIView, index: Int) -> Void
    func didScrollToChildView(_ view: UIView, index: Int) -> Void
}

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
        if index < stackV.arrangedSubviews.count {
            v.tag = index
            stackV.insertArrangedSubview(v, at: index)
        } else {
            v.tag = stackV.arrangedSubviews.count
            stackV.addArrangedSubview(v)
        }
        
        var value = 0
        switch axis {
        case .horizontal:
            value = Int(v.bounds.width)
            addSizeAnchors(onView: v, size: CGSize(width: v.bounds.width, height: min(v.bounds.height, bounds.height-layoutMargins.top-layoutMargins.bottom)))
        case .vertical:
            value = Int(v.bounds.height)
            addSizeAnchors(onView: v, size: CGSize(width: min(v.bounds.width, bounds.width-layoutMargins.left-layoutMargins.right), height: v.bounds.height))
        }
        
        if isAnimated {
            UIView.animate(withDuration: animDuration) {
                v.isHidden = false
            }
        }
        
        // For tracking scroll positions
        childViewEndOffsets.append(value)
        childViewRangeOffsets.append(0...0)
        if v.tag > 0 {
            childViewEndOffsets[v.tag] = value + Int(spacing) + childViewEndOffsets[v.tag - 1]
        }
        childViewRangeOffsets[v.tag] = (childViewEndOffsets[v.tag] - value)...childViewEndOffsets[v.tag]
    }
    
    public func removeChildView(_ view: UIView?) {
        guard let v = view else {
            return
        }
        if isAnimated {
            UIView.animate(withDuration: animDuration) {
                v.isHidden = true
            }
            resizeChildView(v, newSize: .zero)
        } else {
            resizeChildView(v, newSize: .zero)
        }
    }
    
    public func resizeChildView(_ view: UIView?, newSize: CGSize) {
        if let v = view {
            var delta = 0
            switch axis {
            case .horizontal:
                delta = Int(newSize.width - v.bounds.width)
            case .vertical:
                delta = Int(newSize.height - v.bounds.height)
            }
            recalculateChildViewOffsets(from: v.tag, delta: delta)
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
    
    private func recalculateChildViewOffsets(from index: Int, delta: Int) {
        guard index < self.childViewEndOffsets.count && index < self.childViewRangeOffsets.count else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            for i in index..<self.childViewEndOffsets.count {
                self.childViewEndOffsets[i] += delta
//                let oldKey = self.childViewOffsetIndexMap.keys()[i]
//                var newKey = 0...0
//                if i > 0 {
//                    newKey = self.childViewEndOffsets[i-1]...self.childViewEndOffsets[i]
//                } else {
//                    newKey = (self.childViewEndOffsets[i]-self.childViewEndOffsets[i])...self.childViewEndOffsets[i]
//                }
//                self.childViewOffsetIndexMap.switchKey(oldkey: oldKey, newKey: newKey, atIndex: i)
            }
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
                }
            }
        }
    }
    
    @objc private func onChildViewTap(_ sender: UITapGestureRecognizer?) {
        if let v = sender?.view {
            delegate?.didSelectChildView(v, index: v.tag)
        }
    }
}

extension StackView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetValue = 0
        var parity = true
        switch axis {
        case .horizontal:
            if (self.scrollLastContentOffset > scrollView.contentOffset.x) {
                // moving left
                parity = false
                offsetValue = Int(scrollView.contentOffset.x - scrollView.layoutMargins.right)
            }
            else if (self.scrollLastContentOffset < scrollView.contentOffset.x) {
                // moving right
                parity = true
                offsetValue = Int(scrollView.contentOffset.x + bounds.width - scrollView.layoutMargins.left)
            }
            // update the newly acquired position
            self.scrollLastContentOffset = scrollView.contentOffset.x
            
        case .vertical:
            if (self.scrollLastContentOffset > scrollView.contentOffset.y) {
                // moving up
                parity = false
                offsetValue = Int(scrollView.contentOffset.y - scrollView.layoutMargins.top)
            }
            else if (self.scrollLastContentOffset < scrollView.contentOffset.y) {
                // moving down
                parity = true
                offsetValue = Int(scrollView.contentOffset.y + bounds.height - scrollView.layoutMargins.bottom)
            }
            // update the newly acquired position
            self.scrollLastContentOffset = scrollView.contentOffset.y
        }
        
        if let index = getProximityIndex(offsetValue, parity: parity),
            index < stackV.arrangedSubviews.count {
            delegate?.didScrollToChildView(stackV.arrangedSubviews[index], index: index)
            childViewNotifiedIndex = index
        }
    }
    
    private func getProximityIndex(_ contentOffset: Int, parity: Bool) -> Int? {
        if childViewNotifiedIndex >= 0 && childViewNotifiedIndex < childViewRangeOffsets.count {
            var parityIndex = parity ? (childViewNotifiedIndex + 1) : (childViewNotifiedIndex - 1)
            while parityIndex >= 0 && parityIndex < childViewRangeOffsets.count {
                if childViewRangeOffsets[parityIndex] ~= contentOffset {
                    return parityIndex
                }
                parityIndex = parity ? (parityIndex + 1) : (parityIndex - 1)
            }
        }
        return nil
    }
}
