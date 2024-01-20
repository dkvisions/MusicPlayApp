//
//  CommonData.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import UIKit
import NVActivityIndicatorView


class CommonData: NSObject {

    static let shared = CommonData()
    private var activityView: NVActivityIndicatorView!
    private var blackView = UIView()
    
    var openMusicPlayer:(([MusicModelElement], Int) -> ()) = {_,_  in }
    
    
    override init() {
        super.init()
        
        customizeActivityIndicator()
       
    }
    
    //--------------------------------------------------------------
    
    
    private func customizeActivityIndicator() {
        blackView.backgroundColor = .black.withAlphaComponent(0.7)
        activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityView.type = .ballScaleRippleMultiple
        activityView.color = UIColor.white
    
        blackView.addSubview(activityView)
        addCenterConstraints(activityView, blackView)
    }
    
    
    //--------------------------------------------------------------
    
    func addActivity(view: UIView) {
        DispatchQueue.main.async { [self] in
            view.addSubview(blackView)
            blackView.frame = view.bounds
            activityView.startAnimating()
        }
    }
    
    func removeActivity() {
        
        DispatchQueue.main.async { [self] in
            activityView.stopAnimating()
            blackView.removeFromSuperview()
        }
       
    }
    
    
    
    //--------------------------------------------------------------
    func addCenterConstraints(_ child: UIView,_ parent: UIView) {
        
        child.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint(item: child, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: child, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
    }
    
}





extension UIViewController {
    
    static var identifier: String {
        "\(self)"
    }
    
}



enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -15), color: color, opacity: opacity, radius: radius)
        }
    }

    private func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}



//On the top of your swift
  extension UIImage {
      
      func getPixelColor(pos: CGPoint) -> UIColor? {
          
          
          if let pixelData = self.cgImage?.dataProvider?.data {
              let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
              
              let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
              
              let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
              let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
              let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
              let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
              
              return UIColor(red: r, green: g, blue: b, alpha: a)
          }
          
          return nil
      }
  }

