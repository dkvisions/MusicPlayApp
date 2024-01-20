//
//  MusicListTableViewCell.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import UIKit
import SDWebImage

class MusicListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelTittle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imageLogo.layer.cornerRadius = 25
    }
    
    func configureCell(data: MusicModelElement) {
        
        let urlString = "\(RequestUrls.baseUrl)\(RequestUrls.coverImage.rawValue)\(data.cover)"
        imageLogo.sd_setImage(with: URL(string: urlString))
        labelTittle.text = data.name
        labelDescription.text = data.artist
    }
}
