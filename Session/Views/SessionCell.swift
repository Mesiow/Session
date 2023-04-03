//
//  SessionCell.swift
//  Session
//
//  Created by Mesiow on 3/29/23.
//

import UIKit

class SessionCell: UICollectionViewCell {
    
    var title : UILabel = UILabel();
    var bgColor : UIColor!

    override init(frame: CGRect) {
        super.init(frame: frame);
        title.textColor = UIColor.white;
        
        contentView.addSubview(title);
        contentView.layer.cornerRadius = 15;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        //position label within the cell
        title.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 15.0, height: 50);
    }
    
    func setBackgroundColor(_ color : UIColor){
        self.contentView.backgroundColor = color;
    }
}
