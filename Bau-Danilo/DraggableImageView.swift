//
//  DraggableImageView.swift
//  GiocoMatematica
//
//  Created by Danilo on 10/10/2018.
//  Copyright © 2018 UominiEDonne. All rights reserved.
//

import UIKit

class DraggableImageView : UIImageView {
    var dragStartPositionRelativeToCenter : CGPoint?
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        self.isUserInteractionEnabled = true   //< w00000t!!!1
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(nizer:))))
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func corresponding(charr : String) -> Int{
        switch(charr){
        case "k": return 0;
        case "h": return 1;
        case "da": return 2;
        case "u": return 3;
        case "d": return 4;
        case "c": return 5;
        default: return 6;
        }
    }
    
    @objc func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.began {
            let locationInView = nizer.location(in: superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            
            return
        }
        
        let locationInView = nizer.location(in: superview)
        
        
        
        var width = UIScreen.main.bounds.width
        var height = UIScreen.main.bounds.height
        if nizer.state == UIGestureRecognizerState.ended{
            dragStartPositionRelativeToCenter = nil
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            
            if(locationInView.y < height / 100 * 85 && locationInView.y > height / 100 * 61){
                var x = width / 9
                for i in 0...6{
                    if(CGFloat(locationInView.x) >= x - width / 1000 * 4 && CGFloat(locationInView.x) <= x + width / 1000 * 4){
                        self.center = CGPoint(x: x,
                                              y: height / 100 * 73)
                        if(corresponding(charr : arrayChar[i]) == self.tag){
                            risposte[self.tag] = true
                        }
                        return
                    }
                    x += (width * 13 / 100)
                }
            }
            
            self.center = CGPoint(x: width / 4 + width / 10 * CGFloat(self.tag),
                                  y: height / 10 * 3)
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.center = CGPoint(x: locationInView.x,
                                  y: locationInView.y)
        }
    }

}
