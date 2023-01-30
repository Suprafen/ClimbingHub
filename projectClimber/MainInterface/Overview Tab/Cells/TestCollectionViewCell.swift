//
//  TestCollectionViewCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 25.09.22.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StatisticsCollectionViewCell"

    
    //MARK: Initializers
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
}
