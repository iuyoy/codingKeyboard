//
//  BoardView.swift
//  CodingBoard
//
//  Created by xy on 2018/3/8.
//  Copyright © 2018年 iuyyoy. All rights reserved.
//

import UIKit
import Foundation

class BoardView : UIView {

    var buttonTitles = [[[String]]]()
    var allButton = [NormalButton]() //字母按键

//    let buttonSizeGet = ButtonSize.shared

    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonTitles = [[["1","1","!"],   ["2","2","@"], ["3","3","#"], ["4","4","$"], ["5","5","%"], ["6","6","^"], ["7","7","&"], ["8","8","*"], ["9","9","("], ["0","0",")"]],
                        [["q","Q","{"],   ["w","W","["], ["e","E","="], ["r","R","~"], ["t","T","|"], ["y","Y","\\"], ["u","U","-"], ["i","I","+"], ["o","O","]"], ["p","P","}"]],
                        [["Tab","",""],   ["a","A","'"], ["s","S","\""], ["d","D","`"], ["f","F",""], ["g","G",""], ["h","H","_"], ["j","J","/"], ["k","K",":"], ["l","L",";"]],
                        [["⇧","shift",""], ["z","Z","<"], ["x","X",","], ["c","C","!="], ["v","V",""], ["b","B",""], ["n","N","?"], ["m","M","."], ["o","O",">"], ["Del","delete",""]],
                        [["123","symbol",""],["🌐","next",""], ["⚙︎","config",""], ["Space","space",""], ["◀︎","left",""], ["▶︎","right",""], ["Return","ret",""]]]

        let keyboardWidth = frame.size.width

        /*---------------------------添加按钮---------------------------*/
        let buttonViews = createButtons(screenWidth: keyboardWidth)

        buttonViews.translatesAutoresizingMaskIntoConstraints = false

        self.layoutIfNeeded()

//        buttonSizeGet.setRowHeight([getOriginalHeight(buttonViews)])

        // self.getButtonViewSize()

        self.backgroundColor = UIColor(red: 209/255.0, green: 213/255.0, blue: 219/255.0, alpha: 1.0)
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*---------------------------绘制按键---------------------------*/
    func  createButtons(screenWidth:CGFloat) -> UIView{
        var buttonViews = [[NormalButton]]()
        let keyboardViews = UIView(frame: CGRect(x: 0, y: 0,width: screenWidth, height: 10))

        for buttons in buttonTitles {
            var subButtonViews = [NormalButton]()
            for titles in buttons{
                let tempButton =  createNormalButton(titles)
                allButton.append(tempButton)
                subButtonViews.append(tempButton)
                keyboardViews.addSubview(tempButton)
                self.addSubview(tempButton)
            }
           buttonViews.append(subButtonViews)
            // addfirstrowButtonConstraints(subButtonsView, mainView: keyboardRowView)

       }
       addButtonConstraints(buttonViews, mainView: self)

       return keyboardViews
    }

    /*---------------------------绘制字母的按键---------------------------*/
    func  createNormalButton(_ titles: [String]) -> NormalButton{
        let button = NormalButton(frame:CGRect(x: 0, y: 0.0, width: 0.0, height: 0.0), lowChar: titles[0], upperChar: titles[1], triChar: titles[2])
        return button
    }
    /*---------------------------Layout Controller---------------------------*/
    func addButtonConstraints(_ buttonViews: [[NormalButton]], mainView: UIView){
        for (i, subButtonViews) in buttonViews.enumerated() {
//            let width_muti = CGFloat(Float(buttonViews[0].count) / Float(subButtonViews.count))

            for (j, buttonView) in subButtonViews.enumerated() {
                var topConstraint : NSLayoutConstraint!
                var bottomConstraint : NSLayoutConstraint!
                var rightConstraint : NSLayoutConstraint!
                var leftConstraint : NSLayoutConstraint!
                var widthConstraint : NSLayoutConstraint!
                // key height
                let heightConstraint = NSLayoutConstraint(item: buttonView, attribute: .height, relatedBy: .equal, toItem: buttonViews[0][0], attribute: .height, multiplier: 1.0, constant: 0)
                // key width
                if buttonView.getText() == "space" {
                    widthConstraint = NSLayoutConstraint(item: buttonView, attribute: .width, relatedBy: .equal, toItem: buttonViews[0][0], attribute: .width, multiplier: 3, constant: 8)
                } else if buttonView.getText() == "ret" {
                    widthConstraint = NSLayoutConstraint(item: buttonView, attribute: .width, relatedBy: .equal, toItem: buttonViews[0][0], attribute: .width, multiplier: 2, constant: 4)
                } else {
                    widthConstraint = NSLayoutConstraint(item: buttonView, attribute: .width, relatedBy: .equal, toItem: buttonViews[0][0], attribute: .width, multiplier: 1.0, constant: 0)
                }
                // keys interval of top-and-bottom
                if i == 0 {
                    topConstraint = NSLayoutConstraint(item: buttonView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 1.0)
                }else{
                    let upperButton = buttonViews[i-1][0]
                    topConstraint = NSLayoutConstraint(item: buttonView, attribute: .top, relatedBy: .equal, toItem: upperButton, attribute: .bottom, multiplier: 1.0, constant: 3.0)
                }
                if i == buttonViews.count-1 {
                    bottomConstraint = NSLayoutConstraint(item: buttonView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: -1.0)
                }else{
                    let lowerButton = buttonViews[i+1][0]
                    bottomConstraint = NSLayoutConstraint(item: buttonView, attribute: .bottom, relatedBy: .equal, toItem: lowerButton, attribute: .top, multiplier: 1.0, constant: -3.0)
                }

                // keys interval of left-and-right
                if j == 0 {
                    leftConstraint = NSLayoutConstraint(item: buttonView, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 1.0)
                }
                else{
                    let prevtButton = subButtonViews[j-1]
                    leftConstraint = NSLayoutConstraint(item: buttonView, attribute: .left, relatedBy: .equal, toItem: prevtButton, attribute: .right, multiplier: 1.0, constant: 4.0)
                }
                if j == subButtonViews.count - 1 {
                    rightConstraint = NSLayoutConstraint(item: buttonView, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: -1.0)
                }
                else {
                    let nextButton = subButtonViews[j+1]
                    rightConstraint = NSLayoutConstraint(item: buttonView, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left,multiplier: 1.0, constant: -4.0)
                }

                mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint, widthConstraint, heightConstraint])

            }
        }
    }

    func updateViewConstraints() {
        updateViewConstraints()
        // Add custom view sizing constraints here
    }
}
