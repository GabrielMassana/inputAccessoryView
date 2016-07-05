//
//  AnswerComposer.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

import PureLayout

let GlyphLinePadding: CGFloat = 3.0

let MaxNumberOfLines: Int = 5

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
                                                       2.0,
                                                       0.0)
        
        textView.layoutManager.delegate = self;

        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        textView.scrollEnabled = false

        textView.clipsToBounds = true
        
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
    
    var textViewHeight: NSLayoutConstraint?
    
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
        
        clipsToBounds = true
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
        
//        textView.autoPinEdgeToSuperviewEdge(.Top,
//                                            withInset: 3.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Bottom,
                                            withInset: 0.0)
        
        textView.autoPinEdgeToSuperviewEdge(.Left,
                                            withInset: 14.0)

        textView.autoPinEdgeToSuperviewEdge(.Right,
                                            withInset: 68.0)

//        if textViewHeight == nil {
//            
//            textView.autoSetDimension(.Height, toSize: intrinsicContentSize().height)
//        }
        
//        for (NSLayoutConstraint *constraint in self.constraints) {
//            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
//                self.heightConstraint = constraint;
//                break;
//            }
//        }
        
        for constraint in self.constraints {
            
            if constraint.firstAttribute == .Height {
                
                textViewHeight = constraint
            }
        }
        
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
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        print("layout: \(intrinsicContentSize())")
        
        textViewHeight?.constant = intrinsicContentSize().height
        
        let numberLines: Int = Int((intrinsicContentSize().height / (textView.font!.lineHeight + GlyphLinePadding)))
        
        print(numberLines)
        
        if numberLines > MaxNumberOfLines {
            
            textViewHeight?.constant = (textView.font!.lineHeight + GlyphLinePadding) * CGFloat(MaxNumberOfLines)
        }
        
        print(textViewHeight)
    }
    
    override func intrinsicContentSize() -> CGSize {
    
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.max))
        
//        let numberLines: Int = Int((textSize.height / (textView.font!.lineHeight + GlyphLinePadding)))
//
        var size = CGSizeZero
//
//        if numberLines > 5 {
//            
//            size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
//        }
//        else {
        
            size = CGSize(width: UIViewNoIntrinsicMetric, height: textSize.height)
//        }
//
//        print(size)
        
        return size
    }
    
//    override func intrinsicContentSize() -> CGSize {
//
//        var size = CGSizeZero
//
//        size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
//
//        print(size)
//
//        return size
//    }
}

extension AnswerComposer: UITextViewDelegate {
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
//        let textSize = self.textView.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.max))
//        let numberLines: Int = Int((textSize.height / (self.textView.font!.lineHeight + GlyphLinePadding)))
//        
//        print("numberLines \(numberLines)")
//        self.textView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)

//        if numberLines <= 5 {
        
            // Re-calculate intrinsicContentSize when text changes
            invalidateIntrinsicContentSize()
//        }
    }
}

extension AnswerComposer: NSLayoutManagerDelegate {
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        
        return GlyphLinePadding
    }
}
