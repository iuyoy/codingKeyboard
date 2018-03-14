//
//  KeyboardViewController.swift
//  CodingBoard
//
//  Created by xy on 2018/3/8.
//  Copyright © 2018年 iuyyoy. All rights reserved.
//

import UIKit

//Shift type
enum SHIFT_TYPE {
    case shift_LOWERALWAYS
    case shift_UPPERONCE
    case shift_UPPERALWAYS
}

//Keyboard type
enum KEYBOARD_TYPE {
    case alphabet
    // case number
}
//Shift flag
var shiftFlag:SHIFT_TYPE = SHIFT_TYPE.shift_LOWERALWAYS

class KeyboardViewController: UIInputViewController {

    var boardView:BoardView!
    var timer: Timer!// for long press deletion

    var shiftButton: NormalButton!
    let screenWidth = UIScreen.main.bounds.size.width

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.isMultipleTouchEnabled = false
        self.view.isExclusiveTouch = true

        // Draw the keyboard
        let height = keyboardHeight()
        self.boardView = BoardView(frame:CGRect(x: 0, y: 0, width: screenWidth, height: height))
        self.bindKey()
        self.view.addSubview(self.boardView)
    }

    func bindKey(){
        for buttonView in self.boardView.allButton {
            switch(buttonView.getText()) {
            case "return":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapReturn), for: .touchUpInside)
            case "space":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapSpace), for: .touchUpInside)
            case "tab":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapTab), for: .touchUpInside)
            case "shift":
                shiftButton = buttonView
                let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(KeyboardViewController.longTapShift))
                buttonView.addGestureRecognizer(longTapRecognizer)
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapShift), for: .touchUpInside)
            case "delete":
                let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(KeyboardViewController.longTapDelete))
                buttonView.addGestureRecognizer(longTapRecognizer)
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapDelete), for: .touchUpInside)
            case "next":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapNext), for: .touchUpInside)
            case "left":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapLeft), for: .touchUpInside)
            case "right":
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapRight), for: .touchUpInside)
            default:
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapCharacter), for: .touchUpInside)
                buttonView.addTarget(self, action: #selector(KeyboardViewController.didTapTriChar), for: .touchUpOutside)

            }
        }
    }

    /*---------------------------Tap character key---------------------------*/
    @objc
    func didTapCharacter(sender: NormalButton){
        let proxy = textDocumentProxy
        if shiftFlag != SHIFT_TYPE.shift_LOWERALWAYS && sender.upperChar != "" {
            proxy.insertText(sender.upperChar)
            if shiftFlag == SHIFT_TYPE.shift_UPPERONCE {
                shiftFlag = SHIFT_TYPE.shift_LOWERALWAYS
                redrawButtons()
            }
        }else{
            proxy.insertText(sender.lowerChar)
        }
    }
    /*---------------------------Slide to input symbol---------------------------*/
    @objc
    func didTapTriChar(sender: NormalButton){
        if sender.triChar != ""{
            textDocumentProxy.insertText(sender.triChar)
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

    /*---------------------------Tap shift key---------------------------*/
    @objc
    func didTapShift(){
        if shiftFlag == SHIFT_TYPE.shift_LOWERALWAYS{
            shiftFlag = SHIFT_TYPE.shift_UPPERONCE
        }else{
            shiftFlag = SHIFT_TYPE.shift_LOWERALWAYS
        }
        redrawButtons()
    }
    @objc
    func didLongTapShift(){
        if shiftFlag != SHIFT_TYPE.shift_UPPERALWAYS{
            shiftFlag = SHIFT_TYPE.shift_UPPERALWAYS
        }else{
            shiftFlag = SHIFT_TYPE.shift_LOWERALWAYS
        }
        redrawButtons()
    }
    /*---------------------------Long Tap shift key---------------------------*/
    @objc
    func longTapShift(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(KeyboardViewController.didLongTapShift), userInfo: nil, repeats: false)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
    /*---------------------------Tap delete key---------------------------*/
    @objc
    func didTapDelete(){ textDocumentProxy.deleteBackward() }
    /*---------------------------Long Tap delete key---------------------------*/
    @objc
    func longTapDelete(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(KeyboardViewController.didTapDelete), userInfo: nil, repeats: true)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
    /*---------------------------Tap left key---------------------------*/
    @objc
    func didTapLeft(){ textDocumentProxy.adjustTextPosition(byCharacterOffset: -1) }
    /*---------------------------Tap right key---------------------------*/
    @objc
    func didTapRight(){ textDocumentProxy.adjustTextPosition(byCharacterOffset: 1) }
    /*---------------------------Tap next key---------------------------*/
    @objc
    func didTapNext(){ advanceToNextInputMode() }
    func redrawButtons(){
        for buttonView in boardView.allButton{
            buttonView.setNeedsDisplay();
        }
    }
    /*--------------------------Set the keyboardHeight---------------------------*/
    func keyboardHeight()->CGFloat {
        let height:CGFloat
//        let screenHeight = UIScreen.main.bounds.size.height
        switch screenWidth {
        // portrait screen
        case 320:
            height = 216.0
        case 375:
            // height = 264.0 //216.0
            height = 240.0
        case 414:
            height = 240.0
        case 768:
            height = 264.0
        case 1024:
            height = 352.0
        // landscape screen
        case 480:
            height = 162.0
        case 568:
            height = 162.0
        case 667:
            height = 162.0
        case 736:
            height = 162.0
        default:
            height = 240.0
        }
        let heightConstraint = NSLayoutConstraint(item:self.view, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.notAnAttribute, multiplier:0.0, constant: height)
        self.view.addConstraint(heightConstraint)
        return height
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
