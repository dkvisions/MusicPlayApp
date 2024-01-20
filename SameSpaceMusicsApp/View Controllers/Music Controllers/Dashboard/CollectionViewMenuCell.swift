//
//  CollectionViewMenuCell.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 18/01/24.
//

import UIKit

class CollectionViewMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var viewIndication: UIView!
    @IBOutlet weak var lableMenuName: UILabel!
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        viewIndication.layer.cornerRadius = 3
    }
    
    func configureCell(_ menuName: String, _ selectedIndex: Int, _ indexPath: IndexPath) {
        lableMenuName.text = menuName
        
        let isSelected = selectedIndex == indexPath.row
        
        lableMenuName.font = UIFont.systemFont(ofSize: isSelected ? 16 : 15, weight:  isSelected ? .bold : .regular)
        viewIndication.backgroundColor =  selectedIndex == indexPath.row ? UIColor(named: "ColorBlackNWhite") : .clear
    }
}
