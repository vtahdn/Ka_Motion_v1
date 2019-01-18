//
//  Snitch.swift
//  Ka_Motion_v1
//
//  Created by Viet Asc on 1/18/19.
//  Copyright © 2019 Viet Asc. All rights reserved.
//

import UIKit

let pi = Double.pi
let speed = 10.0

class Snitch: UIImageView {
    
    var radian = 0.0
    
    // Snitch hits the wall
    lazy var hitTheWall = { () -> Bool in
        
        let x = self.center.x
        let y = self.center.y
        if let width = self.superview?.layer.bounds.width, let height = self.superview?.layer.bounds.height {
            
            if x <= width/2 + 15 && ( y >= height/2 - 15 && y <= height/2 + 50) {
                return true
            }
            
        }
        return false
        
    }
    
    // Snitch comes to the destination.
    lazy var came = { () -> Bool in
        
        let x = self.center.x
        let y = self.center.y
        if let width = self.superview?.layer.bounds.width, let height = self.superview?.layer.bounds.height {
            
            if x <= width/4 + 15 && y >= height - width/4 - 15 {
                return true
            }
        }
        return false
        
    }
    
    lazy var update = { () -> String in
        
        let radian = self.radian
        if radian >= pi/2 && radian <= pi {
            let scale = abs( (radian - pi/2) / (pi - pi/2) )
            self.center = CGPoint(x: self.center.x + CGFloat(speed * scale), y: self.center.y - CGFloat(speed * (1 - scale)))
        } else if radian > -pi && radian < -pi/2 {
            let scale = abs( (radian + pi/2) / (pi - pi/2) )
             self.center = CGPoint(x: self.center.x + CGFloat(speed * scale), y: self.center.y - CGFloat(speed * (1 - scale)))
        } else if radian >= -pi/2 && radian <= 0 {
            let scale = abs( radian / (pi/2) )
            self.center = CGPoint(x: self.center.x - CGFloat(speed * (1 - scale)), y: self.center.y + CGFloat(speed * scale))
        } else {
            let scale = abs( radian / (pi/2) )
            self.center = CGPoint(x: self.center.x - CGFloat(speed * (1 - scale)), y: self.center.y - CGFloat(speed * scale))
        }
        if self.came() {
            self.removeFromSuperview()
            return "yey"
        } else {
            guard let bounds = self.superview?.bounds else { return "move" }
            if self.center.x <= 15 || self.center.y <= 15 || self.center.x >= bounds.width - 15 || self.center.y >= bounds.height - 15 || self.hitTheWall() {
                self.removeFromSuperview()
                return "hit"
            }
        }
        return "move"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "SnitchWing")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
