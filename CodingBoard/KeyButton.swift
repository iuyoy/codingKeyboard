//
//  Button.swift
//  CodingBoard
//
//  Created by xy on 2018/3/8.
//  Copyright © 2018年 iuyyoy. All rights reserved.x
//

import UIKit
import Foundation

/*---------------------------Normal Button UI---------------------------*/
class NormalButton: UIControl {
    var fillColor: UIColor! //填充背景色
    var lowChar: String! //小写字母
    var upperChar: String! //大写
    var triChar: String! //符号

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.fillColor = UIColor.white//初始化为白色
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
    }
    convenience init(frame: CGRect, lowChar: String, upperChar: String = "", triChar: String = "") {
        self.init(frame: frame)
        self.lowChar = lowChar
        self.upperChar = upperChar
        self.triChar = triChar
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.addSubview(ClickKeyView(frame: self.bounds))

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for v in self.subviews {
           v.removeFromSuperview()
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    public func getText() -> String{
        return self.upperChar
    }
    
    override func draw(_ rect: CGRect) {

        let context:CGContext = UIGraphicsGetCurrentContext()!
        let backgroundcolor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        context.setFillColor(backgroundcolor.cgColor)
        let roundedRect:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0)
        context.fill(rect)
        self.fillColor.setFill()
        roundedRect.fill(with: CGBlendMode.normal, alpha: 1)

        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        let char_y_pos : CGFloat
        
        if shiftFlag != SHIFT_TYPE.shift_LOWERALWAYS && self.upperChar.count == 1{
            char_y_pos = drawCharacter(rect, character: self.upperChar, paragraphStyle: paragraphStyle, fontSize: 16.0, fontColor: UIColor.black)
        } else {
            char_y_pos = drawCharacter(rect, character: self.lowChar, paragraphStyle: paragraphStyle, fontSize: 16.0, fontColor: UIColor.black)
        }
        if self.triChar != ""{
            drawSymbol(rect, paragraphStyle: paragraphStyle, fontSize: 12.0, fontColor: UIColor.lightGray,char_y_pos: char_y_pos)
        }
    }
    /*---------------------------Draw character---------------------------*/
    func drawCharacter(_ rect: CGRect, character: String, paragraphStyle: NSMutableParagraphStyle, fontSize: CGFloat, fontColor: UIColor) -> CGFloat{
        let charAttr:NSDictionary = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
                                      NSAttributedStringKey.foregroundColor:fontColor,
                                      NSAttributedStringKey.paragraphStyle:paragraphStyle]
        let charSize = character.size(withAttributes: charAttr as? [NSAttributedStringKey : Any])
        let float_x_pos = (rect.size.width - charSize.width)/2
        let float_y_pos = (rect.size.height - charSize.height)/2
        let point_title = CGPoint(x: float_x_pos,y: float_y_pos)
        character.draw(at: point_title, withAttributes: charAttr as? [NSAttributedStringKey : Any])
        return float_y_pos
    }
    func drawSymbol(_ rect: CGRect, paragraphStyle: NSMutableParagraphStyle, fontSize: CGFloat, fontColor: UIColor, char_y_pos: CGFloat){
        let charAttr:NSDictionary = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
                                      NSAttributedStringKey.foregroundColor:fontColor,
                                      NSAttributedStringKey.paragraphStyle:paragraphStyle]
        let charSize = self.triChar.size(withAttributes: charAttr as? [NSAttributedStringKey : Any])
        let float_x_pos = (rect.size.width - charSize.width)/2
        let float_y_pos = char_y_pos - charSize.height*3/4
        let point_title = CGPoint(x: float_x_pos,y: float_y_pos)
        self.triChar.draw(at: point_title, withAttributes: charAttr as? [NSAttributedStringKey : Any])
    }
}
class ShiftButton: NormalButton{
    override func draw(_ rect: CGRect) {

        let context:CGContext = UIGraphicsGetCurrentContext()!
        let backgroundcolor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        context.setFillColor(backgroundcolor.cgColor)
        let roundedRect:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0)
        context.fill(rect)
        self.fillColor.setFill()
        roundedRect.fill(with: CGBlendMode.normal, alpha: 1)

        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        switch shiftFlag {
        case SHIFT_TYPE.shift_UPPERALWAYS:
            _ = drawCharacter(rect, character: "⇪", paragraphStyle: paragraphStyle, fontSize: 16.0, fontColor: UIColor.black)
            break
        case SHIFT_TYPE.shift_UPPERONCE:
            _ = drawCharacter(rect, character: self.lowChar, paragraphStyle: paragraphStyle, fontSize: 16.0, fontColor: UIColor.black)
            break
        default:
            _ = drawCharacter(rect, character: self.lowChar, paragraphStyle: paragraphStyle, fontSize: 16.0, fontColor: UIColor.black)
        }
    }
}
/*---------------------------Change button backgroundcolor when tap---------------------------*/
class ClickKeyView: UIView {
    var backgroundcolor:UIColor!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6.0
        self.alpha = 0.35
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
        self.backgroundcolor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
    }

    convenience init(frame: CGRect, backgroundcolor: UIColor){
        self.init(frame: frame)
        self.backgroundcolor = backgroundcolor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        let roundedRect:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0)

        context.setFillColor(self.backgroundcolor.cgColor)
        context.fill(rect)
        self.backgroundcolor.setFill()
        roundedRect.fill(with: CGBlendMode.softLight, alpha: 0.5)
    }
}
