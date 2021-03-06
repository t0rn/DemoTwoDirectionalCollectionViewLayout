//
//  TwoDirectionalCollectionViewLayout.swift
//  DemoTwoDirectionalCollectionViewLayout
//
//  Created by Alexey Ivanov on 19.06.2018.
//

import UIKit
@IBDesignable
class TwoDirectionalCollectionViewLayout: UICollectionViewLayout {
    
    var numberOfColumns: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    
    @IBInspectable var itemSize: CGSize = CGSize(width: 60, height: 60)
    
    var contentSize: CGSize = .zero
    
    override func prepare() {
        guard let collectionView = collectionView,
        collectionView.numberOfSections > 0 else { return }
        
        
        if itemAttributes.count != collectionView.numberOfSections {
            makeItemAttributes(for: collectionView)
            return
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}



extension TwoDirectionalCollectionViewLayout {
    func makeItemAttributes(for collectionView: UICollectionView) {

        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            for index in 0..<numberOfColumns {
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            itemAttributes.append(sectionAttributes)
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
}












