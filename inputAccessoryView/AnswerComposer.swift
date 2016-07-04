//
//  AnswerComposer.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

import PureLayout

class AnswerComposer: UIView {

    lazy var separatorView: UIView = {
       
        var separatorView = UIView()
        
        separatorView.backgroundColor = UIColor.lightGrayColor()
        
        return separatorView
    }()
    
    lazy var textView: UITextView = {
        
        let textView = UITextView.newAutoLayoutView()
        
        textView.textColor = UIColor.darkGrayColor()
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFontOfSize(10.0)
        textView.tintColor = UIColor.darkGrayColor()
        
        textView.backgroundColor = UIColor(colorLiteralRed: 0.98,
                                           green: 0.98,
                                           blue: 0.98,
                                           alpha: 1.0)
        
        textView.textContainerInset = UIEdgeInsetsMake(4.0,
                                                       0.0,
                                                       5.0,
                                                       0.0)
        
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        
        let sendButton = UIButton.newAutoLayoutView()
        
        sendButton.setTitle("Send",
                            forState: .Normal)
        
        sendButton.addTarget(self,
                             action: #selector(sendButtonPressed(_:)),
                             forControlEvents: .TouchUpInside)
        
        sendButton.setTitleColor(UIColor.blackColor(),
                                 forState: .Normal)
        
        sendButton.titleLabel!.font = UIFont.systemFontOfSize(10.0)
        sendButton.backgroundColor = UIColor.yellowColor()
        
        return sendButton
    }()
    
    convenience init() {
        
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        addSubview(sendButton)
        addSubview(textView)
        addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Important code to kept the AnswerComposer on screen after dismissing the keyboard the first time.
    // Without this two overrided functions the AnswerComposer will go out of screen with the keyboard.
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
    
    //MARK: - UpdateConstraints
    
    override func updateConstraints() {
        
        separatorView.autoPinEdgeToSuperviewEdge(.Top)
        
        separatorView.autoPinEdgeToSuperviewEdge(.Right)
        
        separatorView.autoPinEdgeToSuperviewEdge(.Left)
        
        separatorView.autoSetDimension(.Height,
                                       toSize: 1.0)
        
        /*-----------------------*/
        
        textView.autoPinEdgeToSuperviewEdge(.Top,
                                            withInset: 5.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Bottom,
                                            withInset: 5.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Left,
                                            withInset: 14.0)

        textView.autoPinEdgeToSuperviewEdge(.Right,
                                            withInset: 68.0)

        /*-----------------------*/
        
        sendButton.autoSetDimension(.Width,
                                    toSize: 43.0)
        
        sendButton.autoSetDimension(.Height,
                                    toSize: 23.0)
        
        sendButton.autoPinEdgeToSuperviewEdge(.Right,
                                              withInset: 10.0)
        
        sendButton.autoPinEdgeToSuperviewEdge(.Bottom,
                                              withInset: 5.0)
        
        /*-----------------------*/

        super.updateConstraints()
    }
}

extension AnswerComposer: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        return true
    }
}
