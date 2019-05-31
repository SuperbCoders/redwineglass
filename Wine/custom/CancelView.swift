//
//  CancelView.swift
//  Wine
//
//  Created by toxa on 5/4/19.
//  Copyright © 2019 gbsoftware. All rights reserved.
//

import UIKit

protocol CancelViewDelegate: class {
    func didDeleteItems(date:Date)
}

class CancelView: UIView, NibLoadable {

    var items = [WineRecordItem]()
    
    weak var delegate:CancelViewDelegate?

    @IBOutlet weak var deleteConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    private var bgView: UIView?
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews(){

        var temp = [WineType:Int]()
        let list: [WineType] = [ .white, .red, .rose, .sparking, .elsee ]
        
        for (_, type) in list.enumerated() {
            let a = items.filter({ $0.wineType == type })
            if a.count > 0 {
                temp[type] = a.count
            }
        }

        let size = CGSize(width: self.bounds.width, height: 104.0)
        var y:CGFloat = 0
        
        for (_, item) in list.enumerated() {
            if temp[item] != nil {
                let cancelViewItem = CancelViewItem.loadFromNib()
                cancelViewItem.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
                cancelViewItem.wineDesc.text = "Drunk wine"
                cancelViewItem.wineName.text = item.name
                cancelViewItem.wineCount.text = "\( temp[item]! )"
                cancelViewItem.wineImage.image = item.imageBG
                contentView.addSubview(cancelViewItem)
                
                y += size.height
            }
        }
        
        if temp.keys.count > 1 {
            contentViewHeightContraint.constant = contentViewHeightContraint.constant +  size.height * CGFloat( (temp.keys.count - 1) )
            deleteConstraint.constant = deleteConstraint.constant + size.height * CGFloat( (temp.keys.count - 1) )
        }
        
        contentView.bringSubviewToFront(deleteButton)
        
    }
    
    func showCancelView(parent:UIView){
        bgView = UIView()
        bgView!.frame = self.bounds
        bgView!.backgroundColor = UIColor.hex("405360")
        bgView!.alpha = 0.0
        
        parent.addSubview(bgView!)
        parent.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.bgView!.alpha = 0.75
            self.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        }

    }
    

    @IBAction func deleteAction(_ sender: Any) {
        if let f = items.first{
            delegate?.didDeleteItems(date: f.date)
        }
        dismissView()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismissView()
    }
    
    private func dismissView(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bgView!.alpha = 0.0
            self.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height)
        }) { (_) in
            self.removeFromSuperview()
            self.bgView!.removeFromSuperview()
        }
        
    }
    
}
