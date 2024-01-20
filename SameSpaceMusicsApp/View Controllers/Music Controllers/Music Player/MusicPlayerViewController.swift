//
//  MusicPlayerViewController.swift
//  SameSpaceMusicsApp
//
//  Created by Aditya Vinay Juvekar on 20/01/24.
//

import UIKit
import FSPagerView

class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    @IBOutlet weak var viewProgressContainer: UIView!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var curentTime: UILabel!
    @IBOutlet weak var labelLastPlayTime: UILabel!
    
    
    @IBOutlet weak var imagePrivious: UIImageView!
    @IBOutlet weak var imagePlayPause: UIImageView!
    @IBOutlet weak var imageNext: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
