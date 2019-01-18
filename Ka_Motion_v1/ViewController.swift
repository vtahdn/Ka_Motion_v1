//
//  ViewController.swift
//  Ka_Motion_v1
//
//  Created by Viet Asc on 1/18/19.
//  Copyright © 2019 Viet Asc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var movementManager: CMMotionManager?
    var snitch: Snitch?
    var isStarted = true
    
    lazy var alert = { (_ message: String) in
        
        let alert = UIAlertController(title: "You got a message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { (action) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        self.movementManager!.stopAccelerometerUpdates()
        self.movementManager = nil
        self.snitch = nil
        
    }
    
    lazy var start = {
        
        if let movementManager = self.movementManager, let snitch = self.snitch {
            
            movementManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                let angle = atan2(data!.acceleration.x, data!.acceleration.y)
                snitch.radian = angle
                snitch.transform = CGAffineTransform(rotationAngle: CGFloat(angle + pi))
                if snitch.update() == "hit" {
                    self.alert("Boom! Your tank hit the wall.")
                } else if snitch.update() == "yey" {
                    self.alert("Yey! You came to your destination.")
                }
            })
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = view.layer.bounds.width
        let height = view.layer.bounds.height
        
        let wall = UIView(frame: CGRect(x: 0, y: height/2 + 10, width: width/2, height: 20))
        wall.backgroundColor = .black
        view.addSubview(wall)
        
        let destination = UIImageView()
        destination.backgroundColor = .black
        destination.frame = CGRect(x: 0, y: height - width/4, width: width/4, height: width/4)
        destination.layer.cornerRadius = width/8
        view.addSubview(destination)
        
        movementManager = CMMotionManager()
        snitch = Snitch(frame: CGRect(x: 100, y: 100, width: 135, height: 150))
        self.view.addSubview(snitch!)
        movementManager!.accelerometerUpdateInterval = 0.2
        start()
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if let movementManager = self.movementManager {
            if motion == .motionShake {
                if isStarted {
                    movementManager.stopAccelerometerUpdates()
                    isStarted = false
                } else {
                    start()
                    isStarted = true
                }
            }
        }
        
    }


}

