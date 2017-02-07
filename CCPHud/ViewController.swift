//
//  ViewController.swift
//  CCPHud
//
//  Created by 储诚鹏 on 17/2/7.
//  Copyright © 2017年 chengpeng.chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let waitHud = CCPHud.init(frame: mainBounds())
    let progressHud = CCPHud.init(frame: mainBounds())
    let textHud = CCPHud.init(frame: mainBounds())
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(waitHud)
        view.addSubview(progressHud)
        view.addSubview(textHud)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAction(_ sender: UIButton) {
        var progress : Float = 0
        
        switch sender.tag {
        case 101:
            waitHud.waitHud()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: { 
                self.waitHud.TextHud(1.5, text: "success")
            })
            break
        case 102:
            progressHud.waitHud(1)
            if timer != nil {
                timer?.invalidate()
            }
            //ios10.0+
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (timer) in
                progress += 0.01
                self.progressHud.updataProgress!(progress)
                if progress >= 0.99 {
                    timer.invalidate()
                    self.progressHud.TextHud(1.5, text: "success")
                }
            })
            break
        case 103:
            textHud.TextHud(1.5, text: "ccp hud")
            break
        default:
            break
        }
    }

}

