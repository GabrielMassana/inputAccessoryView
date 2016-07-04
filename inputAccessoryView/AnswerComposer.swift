//
//  AnswerComposer.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

import PureLayout

let GlyphLinePadding: CGFloat = 4.0

class AnswerComposer: UIView{

    var numberOfLines = 1
    
    lazy var separatorView: UIView = {
       
        var separatorView = UIView()
        
        separatorView.backgroundColor = UIColor.lightGrayColor()
        
        return separatorView
    }()
    
    lazy var textView: TextView = {
        
        let textView = TextView.newAutoLayoutView()
        
        textView.textColor = UIColor.darkGrayColor()
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFontOfSize(14.0)
        textView.tintColor = UIColor.darkGrayColor()
        textView.delegate = self
        
        textView.backgroundColor = UIColor(colorLiteralRed: 0.98,
                                           green: 0.98,
                                           blue: 0.98,
                                           alpha: 1.0)
        
        textView.textContainerInset = UIEdgeInsetsMake(GlyphLinePadding,
                                                       0.0,
                                                       5.0,
                                                       0.0)
        
        
        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        textView.scrollEnabled = false

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
        
        sendButton.titleLabel!.font = UIFont.systemFontOfSize(12.0)
        sendButton.backgroundColor = UIColor.yellowColor()
        
        return sendButton
    }()
    
    convenience init() {
        
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(sendButton)
        addSubview(textView)
        addSubview(separatorView)
        
        backgroundColor = UIColor.blueColor()

        autoresizingMask = UIViewAutoresizing.FlexibleHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendButtonPressed(sender: UIButton) {
        
        textView.resignFirstResponder()
        textView.text = ""
        numberOfLines = 1
        invalidateIntrinsicContentSize()
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
                                            withInset: 0.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Bottom,
                                            withInset: 0.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Left,
                                            withInset: 14.0)

        textView.autoPinEdgeToSuperviewEdge(.Right,
                                            withInset: 68.0)

        /*-----------------------*/
        
        sendButton.autoSetDimension(.Width,
                                    toSize: 43.0)
        
        sendButton.autoSetDimension(.Height,
                                    toSize: 21.0)
        
        sendButton.autoPinEdgeToSuperviewEdge(.Right,
                                              withInset: 10.0)
        
        sendButton.autoPinEdgeToSuperviewEdge(.Bottom,
                                              withInset: 0.0)
        
        /*-----------------------*/

        super.updateConstraints()
    }
    
    override func intrinsicContentSize() -> CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.max))
        return CGSize(width: bounds.width, height: textSize.height)
    }
}

extension AnswerComposer: UITextViewDelegate {
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        // Re-calculate intrinsicContentSize when text changes
        invalidateIntrinsicContentSize()
    }
}
