//
//  SessionCell.swift
//  Session
//
//  Created by Mesiow on 3/29/23.
//

import UIKit

class SessionCell: UICollectionViewCell {
    
    var title : UILabel = UILabel();
    var hours : UILabel = UILabel();
    var bgColor : UIColor!

    override init(frame: CGRect) {
        super.init(frame: frame);
        
       
       /* let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.frame;
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 15
        blurEffectView.clipsToBounds = true
        contentView.backgroundColor = .clear;
        contentView.addSubview(blurEffectView);*/
    
        
        title.textColor = UIColor.white;
        hours.textColor = UIColor.white;
        contentView.addSubview(title);
        contentView.addSubview(hours);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //position label within the cell
        title.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 15.0, height: 50);
        hours.frame = CGRect(x: 10, y: 40, width: contentView.frame.width - 15.0, height: 50);
        hours.font = UIFont.boldSystemFont(ofSize: 25.0)
        
    }
    
    func setBackgroundColor(_ color : UIColor){
        self.contentView.backgroundColor = color;
    }
    
    func setBackgroundGradient(_ colors : [CGColor]) {
        let layer = CAGradientLayer();
        layer.colors = colors;
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.frame = contentView.frame;
        layer.cornerRadius = 15;
        layer.zPosition = -1;
        
        contentView.layer.addSublayer(layer);
    }
}
