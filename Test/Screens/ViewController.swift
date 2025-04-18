//
//  ViewController.swift
//  Test
//
//  Created by Apple on 11.04.25.
//

import UIKit

class ViewController: UIViewController {
    private let imageView: UIImageView = {
        let iv = UIImageView(frame: .init(x: 50, y: 300, width: 200, height: 200))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    var offset: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let myView = UIView(frame: .init(x: 50, y: 50, width: 300, height: 200))
        myView.clipsToBounds = true
        myView.backgroundColor = .systemPink
        myView.transform = CGAffineTransform(rotationAngle: .pi/4.0)
        let myView2 = UIView(frame: .init(x: 50, y: 50, width: 300, height: 200))
        myView2.backgroundColor = .systemMint
        
//        let imageView = UIImageView(frame: .init(x: 50, y: 300, width: 200, height: 200))
        imageView.image = UIImage(systemName: "pencil")
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        view.addSubview(myView)
        view.addSubview(imageView)
        myView.addSubview(myView2)
        print(myView.frame)
        print(myView.bounds)
        print(myView.center)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view == imageView {
            let location = touch.location(in: imageView)
            offset = location
            return
        }
        offset = nil
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: view)
        
        guard let offset = offset else {
            return
        }
        if touch.view == imageView {
            imageView.frame.origin.x = location.x - offset.x
            imageView.frame.origin.y = location.y - offset.y
        }
        
    }

}
