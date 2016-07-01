//
//  AnswerComposer.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

class AnswerComposer: UIView {

    lazy var textView: UITextView = {
        
        let textView = UITextView(frame: CGRectMake(10.0,
            10.0,
            CGRectGetWidth(UIScreen.mainScreen().bounds) - 90.0,
            40.0))
        
        textView.textColor = UIColor.darkGrayColor()
        textView.backgroundColor = UIColor.lightGrayColor()
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        
        let sendButton = UIButton(type: .Custom)
        
        sendButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 70.0,
            10.0,
            60.0,
            40.0)
        
        sendButton.backgroundColor = UIColor.lightGrayColor()

        sendButton.setTitle("Send",
                            forState: .Normal)
        sendButton.addTarget(self,
                             action: #selector(sendButtonPressed(_:)),
                             forControlEvents: .TouchUpInside)
        
        return sendButton
    }()
    
    convenience init() {
        
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(colorLiteralRed: 0.9,
                                       green: 0.9,
                                       blue: 0.9,
                                       alpha: 1.0)
        
        addSubview(sendButton)
        addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override var inputAccessoryView: UIView {
        
        get{
            
            return self
        }
    }
    
    func sendButtonPressed(sender: UIButton) {
        
        textView.resignFirstResponder()
        textView.text = ""
    }
}
