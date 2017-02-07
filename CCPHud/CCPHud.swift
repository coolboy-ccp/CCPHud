//
//  CCPHud.swift
//  YQHome
//
//  Created by 储诚鹏 on 17/1/17.
//  Copyright © 2017年 chengpeng.chu. All rights reserved.
//

import UIKit
import SnapKit

func mainBounds() -> CGRect {
    return UIScreen.main.bounds
}

func mainSize() -> CGSize {
    return mainBounds().size
}

func mainWidth() -> CGFloat {
    return mainSize().width
}

func mainHeight() -> CGFloat {
    return mainSize().height
}

//------相对于iPhone6布局

func adaption(width w : CGFloat) -> CGFloat {
    return  w * (mainWidth() / 375)
}

func adaption(height h : CGFloat) -> CGFloat {
    return  h * (mainHeight() / 667)
}

extension UIColor {
    public class func rgba(_ colors : Array<CGFloat>) -> UIColor {
        var color : UIColor = UIColor.clear
        guard ((colors.count == 1) || (colors.count == 3) || (colors.count == 4) || (colors.count == 2)) else {
            return color;
        }
        let subColors = colors.map {$0 / 255.0}
        switch colors.count {
        case 1:
            color = UIColor(red: subColors[0], green: subColors[0], blue: subColors[0], alpha: 1.0)
            break
        case 2:
            color = UIColor(red: subColors[0], green: subColors[0], blue: subColors[0], alpha: subColors[1] * 255)
            break
        case 3:
            color = UIColor(red: subColors[0], green: subColors[1], blue: subColors[2], alpha: 1.0)
            break
        case 4:
            color = UIColor(red: subColors[0], green: subColors[1], blue: subColors[2], alpha: subColors[3] * 255)
            break
        default:
            break
        }
        return color
    }
    
    class var mainColor : UIColor {
        get {
            return UIColor.rgba([196,58,62])
        }
    }
    
    class var textDarkColor : UIColor {
        get {
            return UIColor.rgba([60])
        }
    }
    
    class var textLightColor : UIColor {
        get {
            return UIColor.rgba([150])
        }
    }
}

extension UIView {
    @discardableResult
    func removeAllSubviews() -> Any {
        return  self.subviews.map({$0.removeFromSuperview()})
    }
}

class CCPHud: UIView {
    
    //更新进度条进度
    var updataProgress:((Float)->Void)?
    //是否在隐藏后移除
    var isRemoveOnHide : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     *0:小菊花
     *1:进度条
     */
    func waitHud(_ type:Int = 0) {
        self.removeAllSubviews()
        self.isHidden = false
        let hudV = UIView.init(frame: mainBounds())
        hudV.backgroundColor = UIColor.rgba([10,0.7])
        self.addSubview(hudV)
        for i in 0..<2 {
            let la = UILabel.init(frame: mainBounds())
            la.text = "CCPHud"
            la.textAlignment = .center
            la.font = UIFont.init(name: "Papyrus", size: adaption(height: 35))
            la.textColor = UIColor.white
            hudV.addSubview(la)
            if i == 1 {
                la.textColor = UIColor.mainColor
                let maskL = CALayer.init()
                maskL.bounds = CGRect.init(x: 0, y: 0, width: adaption(width: 200), height: adaption(height: 800))
                maskL.backgroundColor = UIColor.white.cgColor
                la.layer.mask = maskL
                waitAni(maskL)
            }
        }
        if type == 0 {
            activity(hudV)
        }
        else {
            progressView(hudV)
        }
    }
    
    //小菊花
    private func activity(_ supV:UIView) {
        let indView = UIActivityIndicatorView.init()
        indView.activityIndicatorViewStyle = .whiteLarge
        supV.addSubview(indView)
        indView.frame = CGRect.init(x: (mainWidth() - adaption(width: 150)) / 2, y: adaption(height: 300), width: adaption(width: 150), height: adaption(width: 150))
        print(indView.frame)
        indView.startAnimating()
    }
    
    //进度条
    private func progressView(_ supV:UIView) {
        let progressV = UIProgressView.init()
        progressV.progress = 0
        updataProgress = {
            progressV.progress = $0
        }
        progressV.tintColor = UIColor.mainColor
        supV.addSubview(progressV)
        progressV.layer.cornerRadius = adaption(height: 3)
        progressV.layer.masksToBounds = true
        progressV.snp.makeConstraints({
            $0.centerX.equalTo(supV)
            $0.top.equalTo(adaption(height: 400))
            $0.size.equalTo(CGSize.init(width: adaption(width: 280), height: adaption(height: 6)))
        })
    }
    
    private func waitAni(_ wl:CALayer) {
        let ani = CABasicAnimation.init(keyPath: "position.x")
        ani.fromValue = -adaption(width: 130)
        ani.toValue = adaption(width: 400)
        ani.repeatCount = MAXFLOAT
        ani.duration = 2.0
        ani.autoreverses = true
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        wl.add(ani, forKey: nil)
    }
    
    
    //田淘 增加func
    
   

    class func showHudView(message:String,autoHiden:Bool){
        let hud = CCPHud.init(frame: mainBounds())
        hud.isRemoveOnHide = true
        UIApplication.shared.delegate?.window??.addSubview(hud)
        
        hud.isHidden = false
        hud.removeAllSubviews()
        let nsText : NSString = message as NSString
        let size = nsText.boundingRect(with: CGSize.init(width: adaption(width: 200), height: mainHeight() * 0.5), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: adaption(width: 16))], context: nil).size
        let labSize = CGSize.init(width: adaption(width: 220), height: size.height + adaption(height: 20))
        let hudV = UIView.init()
        hudV.backgroundColor = UIColor.rgba([10,0.8])
        hud.addSubview(hudV)
        hudV.snp.makeConstraints({
            $0.center.equalTo(hud)
            $0.size.equalTo(CGSize.init(width: adaption(width: 230), height: (labSize.height)))
        })
        hudV.layer.cornerRadius = adaption(height: 6)
        let la = UILabel.init()
        la.textAlignment = .center
        la.textColor = UIColor.white
        la.text = message
        la.font = UIFont.systemFont(ofSize: adaption(width: 16))
        la.numberOfLines = 0
        la.lineBreakMode = .byCharWrapping
        hudV.addSubview(la)
        la.snp.makeConstraints({
            $0.center.equalTo(hudV)
            $0.size.equalTo(labSize)
        })
        if(autoHiden){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                hud.hideHud()
            }
        }        
    }
    
    
    //提示hud
    func TextHud(_ delay:TimeInterval,text:String) {
        self.isHidden = false
        self.removeAllSubviews()
        let nsText : NSString = text as NSString
        let size = nsText.boundingRect(with: CGSize.init(width: adaption(width: 200), height: mainHeight() * 0.5), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: adaption(width: 16))], context: nil).size
        let labSize = CGSize.init(width: adaption(width: 220), height: size.height + adaption(height: 20))
        let hudV = UIView.init()
        hudV.backgroundColor = UIColor.rgba([10,0.8])
        self.addSubview(hudV)
        hudV.snp.makeConstraints({
            $0.center.equalTo(self)
            $0.size.equalTo(CGSize.init(width: adaption(width: 230), height: (labSize.height)))
        })
        hudV.layer.cornerRadius = adaption(height: 6)
        let la = UILabel.init()
        la.textAlignment = .center
        la.textColor = UIColor.white
        la.text = text
        la.font = UIFont.systemFont(ofSize: adaption(width: 16))
        la.numberOfLines = 0
        la.lineBreakMode = .byCharWrapping
        hudV.addSubview(la)
        la.snp.makeConstraints({
            $0.center.equalTo(hudV)
            $0.size.equalTo(labSize)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.hideHud()
        }
    }
    
    
    func hideHud() {
        self.isHidden = true
        if isRemoveOnHide {
           self.removeFromSuperview()
        }
    }

}
