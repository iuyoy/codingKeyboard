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

    @IBOutlet var nextKeyboardButton: UIButton!
    var boardView:BoardView!//字母键盘
//    var timer:Timer!//用于长按删除
//    var deleteTime:Double!
    var keyboardType:KEYBOARD_TYPE!

    let screenWidth = UIScreen.main.bounds.size.width

    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardType = KEYBOARD_TYPE.alphabet
//        self.deleteTime = 0.0

        self.view.isMultipleTouchEnabled = false
        self.view.isExclusiveTouch = true
        self.putKeyboardToView()
    }
    /*-----------------将所需键盘上屏----------------*/
    func putKeyboardToView() {

        self.boardView = BoardView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(keyboardHeight())))
//        self.boardView = BoardView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(216)))

        self.bindKey()
        self.view.addSubview(self.boardView)

    }
    func bindKey(){
        for buttonView in self.boardView.allButton {
            switch(buttonView.getText()) {
            case "space":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapSpace), for: .touchUpInside)
                break
            case "delete":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapDelete), for: .touchUpInside)
                break
            case "next":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapNext), for: .touchUpInside)
                break
            default:
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapCharacter), for: .touchUpInside)
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapTriChar), for: .touchUpOutside)
                break


            }
        }
    }
    @objc
    func didTapCharacter(sender: NormalButton){
        let proxy = textDocumentProxy
        if shiftFlag == SHIFT_TYPE.shift_UPPERALWAYS && sender.upperChar != "" {
            proxy.insertText(sender.upperChar)
        }else{
            proxy.insertText(sender.lowChar)
        }
    }
    @objc
    func didTapTriChar(sender: NormalButton){
        let proxy = textDocumentProxy
        if sender.triChar != ""{
            proxy.insertText(sender.triChar)
        }
    }
    @objc
    func didTapSpace(){
        let proxy = textDocumentProxy
        proxy.insertText(" ")
    }
    @objc
    func didTapNext()
    {
        advanceToNextInputMode()
    }
    @objc
    func didTapDelete(){
        let proxy = textDocumentProxy
        proxy.deleteBackward()
    }
    /*-----------------开始触屏按键动作----------------*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    /*-----------------结束触屏按键动作----------------*/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

    /*--------------------------设置键盘高度---------------------------*/
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

//    override func textDidChange(_ textInput: UITextInput?) {
//        // The app has just changed the document's contents, the document context has been updated.
//
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
//    }
}
