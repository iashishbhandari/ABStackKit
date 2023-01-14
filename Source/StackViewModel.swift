// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


internal final class StackViewModel {
    
    var stackView: StackView
    var childViewEndOffsets: [Int]
    var childViewNotifiedIndex: Int
    var scrollLastContentOffset: CGFloat
    
    init(_ stackView: StackView) {
        self.stackView = stackView
        self.childViewEndOffsets = []
        self.childViewNotifiedIndex = 0
        self.scrollLastContentOffset = -1
    }

    func trackEndOffsets(forIndex index: Int, value: Int) {
        if index < stackView.arrangedSubviews.count {
            childViewEndOffsets.insert(value, at: index)
        } else {
            childViewEndOffsets.append(value)
        }
        if index > 0 {
            childViewEndOffsets[index] = value + childViewEndOffsets[index-1]
        }
    }
    
    func recalculateChildViewOffsets(fromIndex index: Int, delta: Int) {
        guard index < childViewEndOffsets.count else {
            return
        }
        for i in index..<childViewEndOffsets.count {
            childViewEndOffsets[i] += delta
        }
    }
    
    func childViewOffsetOnScrollView(_ scrollView: UIScrollView) {
        var offsetValue = 0
        var parity = true
        switch stackView.axis {
        case .horizontal:
            if (scrollLastContentOffset > scrollView.contentOffset.x) {
                // moving left
                parity = false
                offsetValue = Int(scrollView.contentOffset.x - scrollView.layoutMargins.right)
            }
            else if (scrollLastContentOffset < scrollView.contentOffset.x) {
                // moving right
                parity = true
                offsetValue = Int(scrollView.contentOffset.x + stackView.bounds.width - scrollView.layoutMargins.left)
            }
            // update the newly acquired position
            scrollLastContentOffset = scrollView.contentOffset.x
            
        case .vertical:
            if (scrollLastContentOffset > scrollView.contentOffset.y) {
                // moving up
                parity = false
                offsetValue = Int(scrollView.contentOffset.y - scrollView.layoutMargins.top)
            }
            else if (scrollLastContentOffset < scrollView.contentOffset.y) {
                // moving down
                parity = true
                offsetValue = Int(scrollView.contentOffset.y + stackView.bounds.height - scrollView.layoutMargins.bottom)
            }
            // update the newly acquired position
            scrollLastContentOffset = scrollView.contentOffset.y
        @unknown default:
            break
        }
        
        if let index = getProximityIndex(offsetValue, parity: parity),
            index < stackView.arrangedSubviews.count {
            stackView.delegate?.didScrollToChildView(stackView.arrangedSubviews[index], index: index)
            childViewNotifiedIndex = index
        }
    }
    
    private func getProximityIndex(_ contentOffset: Int, parity: Bool) -> Int? {
        if childViewNotifiedIndex >= 0 && childViewNotifiedIndex < childViewEndOffsets.count {
            var parityIndex = parity ? (childViewNotifiedIndex + 1) : (childViewNotifiedIndex - 1)
            while parityIndex >= 0 && parityIndex < childViewEndOffsets.count {
                if parityIndex > 0 {
                    if childViewEndOffsets[parityIndex-1]...childViewEndOffsets[parityIndex] ~= contentOffset {
                        return parityIndex
                    }
                } else {
                    if (childViewEndOffsets[parityIndex]-childViewEndOffsets[parityIndex])...childViewEndOffsets[parityIndex] ~= contentOffset {
                        return parityIndex
                    }
                }
                parityIndex = parity ? (parityIndex + 1) : (parityIndex - 1)
            }
        }
        return nil
    }
}
