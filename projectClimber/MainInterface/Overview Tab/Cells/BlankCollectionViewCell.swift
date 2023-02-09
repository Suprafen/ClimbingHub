//
//  BlankCollectionViewCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 25.09.22.
//

import UIKit
@available (iOS 16, *)
class BlankCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BlankStatisticsCollectionViewCell"

    //MARK: Initializers
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError(" init?(coder: NSCoder) has not been implemented")
    }
    
}
