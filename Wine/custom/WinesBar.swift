//
//  WinesBar.swift
//  Wine
//
//  Created by toxa on 5/1/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

protocol WinesBarDelegate : class {
    func didDayTap(_ index: Int)
}

@IBDesignable
class WinesBar: UIView {

    private let scrollView =  UIScrollView()
    private var buttons = [UIView]()
    
    weak var delegate: WinesBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
//        layer.borderWidth = 1
//        scrollView.layer.borderWidth = 1
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    private func setupViews(){
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        
        var x:CGFloat = 10
        let y:CGFloat = 0
        let w:CGFloat = 216.0
        let h:CGFloat = 88.0
        let sp:CGFloat = 8.0
        
        let list: [WineType] = [ .white, .red, .rose, .sparking, .elsee ]
        
        for (index, item) in list.enumerated() {
            
            let textColor = index == 1 || index == 2 ? UIColor.hex("#FFFFFF") : UIColor.hex("#405360")
            
            let but = UIView()
            but.layer.cornerRadius = 20.0
//            but.layer.borderWidth = 0.5
            but.clipsToBounds = true
            but.backgroundColor = item.color
            but.frame = CGRect(x: x, y: y, width: w, height: h)
            but.tag = index
            scrollView.addSubview(but)
                        
            let titleLab = UILabel(frame: CGRect(x: 20, y: 22, width: w - 20, height: 24))
            titleLab.text = item.name //titles[index]
            titleLab.font = UIFont(name: "SFProText-Semibold", size: 18)
//            titleLab.layer.borderWidth = 0.5
            titleLab.textAlignment = .left
            titleLab.textColor = textColor
            but.addSubview(titleLab)
            
            let descLab = UILabel(frame: CGRect(x: 20, y: 49, width: w - 20, height: 24))
            descLab.text = item.desc //descriptions[index]
            descLab.font = UIFont(name: "SFProText-Regular", size: 14)
//            descLab.layer.borderWidth = 0.5
            descLab.textAlignment = .left
            descLab.textColor = textColor
            but.addSubview(descLab)
            
            but.dropShadow()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
            tap.numberOfTapsRequired = 1
            but.isUserInteractionEnabled = true
            but.addGestureRecognizer(tap)
            
            x += sp + w
        }
        
        scrollView.contentSize = CGSize(width: (w + sp) * CGFloat(list.count) + 10.0 , height: self.bounds.height)
    }
    
    @objc private func didTap(_ gest:UITapGestureRecognizer){
        if let view = gest.view{
            delegate?.didDayTap(view.tag)
        }
    }
    
}



