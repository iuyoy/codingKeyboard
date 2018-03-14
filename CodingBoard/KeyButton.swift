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
    var lowerChar: String! //lowercase character
    var upperChar: String! //optional uppercase character & the key judgement sign
    var triChar: String! //optional symbol

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
    }
    convenience init(frame: CGRect, lowerChar: String, upperChar: String = "", triChar: String = "") {
        self.init(frame: frame)
        self.lowerChar = lowerChar
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
        let backgroundColor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        context.setFillColor(backgroundColor.cgColor)
        let roundedRect:UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0)
        context.fill(rect)

        let fillColor: UIColor
        if upperChar.count == 1 {
            fillColor = UIColor.white
        } else {
            fillColor = UIColor(red: 175/255.0, green: 179/255.0, blue: 189/255.0, alpha: 1.0)
        }
        fillColor.setFill()
        roundedRect.fill(with: CGBlendMode.normal, alpha: 1)

        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center

        drawButton(rect, paragraphStyle: paragraphStyle, context: context )
    }
    /*---------------------------Draw button---------------------------*/
    func drawButton(_ rect: CGRect, paragraphStyle: NSMutableParagraphStyle, context: CGContext){
        if shiftFlag != SHIFT_TYPE.shift_LOWERALWAYS && self.upperChar.count == 1{
            drawCharacter(rect, character: self.upperChar, paragraphStyle: paragraphStyle, fontSize: 18.0, fontColor: UIColor.black)
        } else {
            drawCharacter(rect, character: self.lowerChar, paragraphStyle: paragraphStyle, fontSize: 18.0, fontColor: UIColor.black)
        }
        if self.triChar != ""{
            drawSymbol(rect, paragraphStyle: paragraphStyle, fontSize: 12.0, fontColor: UIColor.lightGray)
        }
    }
    /*---------------------------Draw character---------------------------*/
    func drawCharacter(_ rect: CGRect, character: String, paragraphStyle: NSMutableParagraphStyle, fontSize: CGFloat, fontColor: UIColor){
        let charAttr:NSDictionary = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
                                      NSAttributedStringKey.foregroundColor:fontColor,
                                      NSAttributedStringKey.paragraphStyle:paragraphStyle]
        let charSize = character.size(withAttributes: charAttr as? [NSAttributedStringKey : Any])
        let float_x_pos = (rect.size.width - charSize.width)/2
        let float_y_pos = (rect.size.height - charSize.height)/2
        let point_title = CGPoint(x: float_x_pos,y: float_y_pos)
        character.draw(at: point_title, withAttributes: charAttr as? [NSAttributedStringKey : Any])
    }
    func drawSymbol(_ rect: CGRect, paragraphStyle: NSMutableParagraphStyle, fontSize: CGFloat, fontColor: UIColor){
        let charAttr:NSDictionary = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),
                                      NSAttributedStringKey.foregroundColor:fontColor,
                                      NSAttributedStringKey.paragraphStyle:paragraphStyle]
        let charSize = self.triChar.size(withAttributes: charAttr as? [NSAttributedStringKey : Any])
//        let float_x_pos = (rect.size.width - charSize.width)/2
//        let float_y_pos = char_y_pos - charSize.height*3/4
        let float_x_pos = rect.size.width - charSize.width*2
        let float_y_pos = CGFloat(0)
        let point_title = CGPoint(x: float_x_pos, y: float_y_pos)
        self.triChar.draw(at: point_title, withAttributes: charAttr as? [NSAttributedStringKey : Any])
    }
}

/*---------------------------Shift Button UI---------------------------*/
class ShiftButton: NormalButton{
    override func drawButton(_ rect: CGRect, paragraphStyle: NSMutableParagraphStyle, context: CGContext){
        switch shiftFlag {
        case SHIFT_TYPE.shift_UPPERALWAYS:
            self.drawArrow(rect, context: context, strokeColor: UIColor.black, fillColor: UIColor.black, drawUnderline: true)
            break
        case SHIFT_TYPE.shift_UPPERONCE:
            drawArrow(rect, context: context, strokeColor: UIColor.black, fillColor: UIColor.black)
            break
        default:
            drawArrow(rect, context: context, strokeColor: UIColor.black, fillColor: UIColor.white)
        }
    }

    func drawArrow(_ rect: CGRect, context: CGContext, strokeColor: UIColor, fillColor: UIColor, drawUnderline: Bool = false) {
        let size:CGSize = rect.size

        let p1:CGPoint = CGPoint(x: size.width/2 - 7, y: size.height/2)
        let p2:CGPoint = CGPoint(x: size.width/2, y: size.height/2 - 7)
        let p3:CGPoint = CGPoint(x: size.width/2 + 7 , y: size.height/2)
        let p4:CGPoint = CGPoint(x: size.width/2 + 3.5, y: size.height/2)
        let p5:CGPoint = CGPoint(x: size.width/2 + 3.5, y: size.height/2 + 7)
        let p6:CGPoint = CGPoint(x: size.width/2 - 3.5, y: size.height/2 + 7)
        let p7:CGPoint = CGPoint(x: size.width/2 - 3.5, y: size.height/2)

        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(1.0)

        context.move(to: CGPoint(x: p1.x, y: p1.y))
        context.addLine(to: CGPoint(x: p2.x, y: p2.y))
        context.addLine(to: CGPoint(x: p3.x, y: p3.y))
        context.addLine(to: CGPoint(x: p4.x, y: p4.y))
        context.addLine(to: CGPoint(x: p5.x, y: p5.y))
        context.addLine(to: CGPoint(x: p6.x, y: p6.y))
        context.addLine(to: CGPoint(x: p7.x, y: p7.y))
        context.closePath()
        context.fillPath()

        if drawUnderline {
            context.setLineWidth(2.0)

            let p8:CGPoint = CGPoint(x: size.width/2 + 3.5, y: size.height/2 + 10)
            let p9:CGPoint = CGPoint(x: size.width/2 - 3.5, y: size.height/2 + 10)
            context.move(to: CGPoint(x: p8.x, y: p8.y))
            context.addLine(to: CGPoint(x: p9.x, y: p9.y))
            context.strokePath()
        }
    }

}

/*---------------------------Next Button UI---------------------------*/
class NextButton: NormalButton{
    override func drawButton(_ rect: CGRect, paragraphStyle: NSMutableParagraphStyle, context: CGContext){
        let size:CGSize = rect.size
        let r:CGFloat =  CGFloat(8) //radius
        let p1:CGPoint = CGPoint(x: rect.origin.x + size.width / 2, y: rect.origin.y + size.height / 2 ) //center of circle
        let p2:CGPoint = CGPoint(x: p1.x, y: p1.y - r * sqrt(2))
        let p3:CGPoint = CGPoint(x: p1.x, y: p1.y + r * sqrt(2))
        let p4:CGPoint = CGPoint(x: p1.x - r*3/4, y: p1.y)
        let p5:CGPoint = CGPoint(x: p1.x + r*3/4, y: p1.y)

        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1.0)

        //circle
        context.addArc(center: p1, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        context.strokePath()

        //top curve
        context.addArc(center: p2, radius: r, startAngle: CGFloat(Double.pi/4), endAngle: CGFloat(Double.pi * 3 / 4), clockwise: false)
        context.strokePath()

        //bottom curve
        context.addArc(center: p3, radius: r, startAngle: -CGFloat(Double.pi*3/4), endAngle: -CGFloat(Double.pi/4), clockwise: false)
        context.strokePath()

        //right curve
        context.addArc(center: p4, radius: r*5/4, startAngle: -atan(4/3), endAngle: atan(4/3), clockwise: false)
        context.strokePath()

        //left curve
        context.addArc(center: p5, radius: r*5/4, startAngle: CGFloat(Double.pi - atan(4/3)), endAngle: CGFloat(Double.pi + atan(4/3)), clockwise: false)
        context.strokePath()

        //line from top to down
        context.move(to: CGPoint(x: p1.x, y: p1.y - r))
        context.addLine(to: CGPoint(x: p1.x, y: p1.y + r))
        context.strokePath()

        //line from left to right
        context.move(to: CGPoint(x: p1.x - r, y: p1.y))
        context.addLine(to: CGPoint(x: p1.x + r, y: p1.y))
        context.strokePath()
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
