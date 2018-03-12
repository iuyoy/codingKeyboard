//
//  KeyboardViewController.swift
//  CodingBoard
//
//  Created by xy on 2018/3/8.
//  Copyright © 2018年 iuyyoy. All rights reserved.
//

import UIKit

//定义枚举类型标注shift按键所单击的次数
enum SHIFT_TYPE {
    case shift_LOWERALWAYS
    case shift_UPPERONCE
    case shift_UPPERALWAYS
}

//定义枚举类型标注当前键盘类型
enum KEYBOARD_TYPE {
    case alphabet //字母键盘
    case number //数字键盘
}
//定义一个全局的变量，标注单击shift按键的次数
var shiftFlag:SHIFT_TYPE = SHIFT_TYPE.shift_LOWERALWAYS

class KeyboardViewController: UIInputViewController {

    var boardView:BoardView!//字母键盘
//    var timer:Timer!//用于长按删除
//    var deleteTime:Double!
    var keyboardType:KEYBOARD_TYPE!

    let screenWidth = UIScreen.main.bounds.size.width

    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardType = KEYBOARD_TYPE.alphabet
//        self.view.translatesAutoresizingMaskIntoConstraints = false
//        self.deleteTime = 0.0
        let _expandedHeight = CGFloat(264)
        let _heightConstraint = NSLayoutConstraint(item:self.view, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.notAnAttribute, multiplier:0.0, constant: _expandedHeight)
        self.view.addConstraint(_heightConstraint)
        self.view.isMultipleTouchEnabled = false
        self.view.isExclusiveTouch = true
        self.putKeyboardToView()
    }
    /*-----------------将所需键盘上屏----------------*/
    func putKeyboardToView() {

//        self.boardView = BoardView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(keyboardHeight())))
        self.boardView = BoardView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(264)))

        self.bindKey()
        self.view.addSubview(self.boardView)

    }
    func bindKey(){
        for buttonView in self.boardView.allButton {
            switch(buttonView.getText()) {
            case "return":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapReturn), for: .touchUpInside)
                break
            case "space":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapSpace), for: .touchUpInside)
                break
            case "tab":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapTab), for: .touchUpInside)
                break
            case "delete":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapDelete), for: .touchUpInside)
                break
            case "next":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapNext), for: .touchUpInside)
                break
            case "left":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapLeft), for: .touchUpInside)
                break
            case "right":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapRight), for: .touchUpInside)
                break
            default:
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapCharacter), for: .touchUpInside)
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapTriChar), for: .touchUpOutside)
                break


            }
        }
    }

    /*---------------------------Tap character key---------------------------*/
    @objc
    func didTapCharacter(sender: NormalButton){
        let proxy = textDocumentProxy
        if shiftFlag == SHIFT_TYPE.shift_UPPERALWAYS && sender.upperChar != "" {
            proxy.insertText(sender.upperChar)
        }else{
            proxy.insertText(sender.lowChar)
        }
    }
    /*---------------------------Slide to input symbol---------------------------*/
    @objc
    func didTapTriChar(sender: NormalButton){
        let proxy = textDocumentProxy
        if sender.triChar != ""{
            proxy.insertText(sender.triChar)
        }
    }
    /*---------------------------Tap return key---------------------------*/
    @objc
    func didTapReturn(){ textDocumentProxy.insertText("\n") }
    /*---------------------------Tap space key---------------------------*/
    @objc
    func didTapSpace(){ textDocumentProxy.insertText(" ") }
    /*---------------------------Tap tab key---------------------------*/
    @objc
    func didTapTab(){ textDocumentProxy.insertText("    ") }
    /*---------------------------Tap delete key---------------------------*/
    @objc
    func didTapDelete(){ textDocumentProxy.deleteBackward() }
    /*---------------------------Tap left key---------------------------*/
    @objc
    func didTapLeft(){ textDocumentProxy.adjustTextPosition(byCharacterOffset: -1) }
    /*---------------------------Tap right key---------------------------*/
    @objc
    func didTapRight(){ textDocumentProxy.adjustTextPosition(byCharacterOffset: 1) }
    /*---------------------------Tap next key---------------------------*/
    @objc
    func didTapNext(){ advanceToNextInputMode() }

    /*--------------------------Set the keyboardHeight---------------------------*/
    func keyboardHeight()->Float {
        var keyboardheight:Float

        switch screenWidth {
        case 320:
            keyboardheight = 216.0
            break
        case 375:
            keyboardheight = 216.0
            break
        case 414:
            keyboardheight = 226.0
            break
        case 480:
            keyboardheight = 162.0
            break
        case 568:
            keyboardheight = 162.0
            break
        case 667:
            keyboardheight = 162.0
            break
        case 736:
            keyboardheight = 162.0
            break
        case 768:
            keyboardheight = 264.0
            break
        case 1024:
            keyboardheight = 352.0
            break
        default:
            keyboardheight = 216.0
            break
        }
        return keyboardheight
    }

    /*--------------------------System auto generation---------------------------*/
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated
//    }
//
//    override func textWillChange(_ textInput: UITextInput?) {
//        // The app is about to change the document's contents. Perform any preparation here.
//    }
//
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        // Add custom view sizing constraints here
//    }
}
