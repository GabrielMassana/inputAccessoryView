//
//  AnswerComposer.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

import PureLayout

/// Constant to help text padding. Helps to do not overlap emojis.
let GlyphLinePadding: CGFloat = 3.0

/// The maximum number of lines for the text view.
let MaxNumberOfLines: Int = 5

protocol AnswerComposerDelegate: NSObjectProtocol {
    
    func didUpdatedInputAccessoryViewHeight(height: CGFloat)
}

class AnswerComposer: UIView {

    //MARK: - Accessors
    
    weak var delegate: AnswerComposerDelegate?
    
    var inputAccessoryViewHeight: NSLayoutConstraint?

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
    
    //MARK: - Init

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

        // Important to clip the view to the inputAccessoryView
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ButtonActions
    
    func sendButtonPressed(sender: UIButton) {
        
        textView.resignFirstResponder()
        textView.text = ""
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        separatorView.autoPinEdgeToSuperviewEdge(.Top)
        
        separatorView.autoPinEdgeToSuperviewEdge(.Right)
        
        separatorView.autoPinEdgeToSuperviewEdge(.Left)
        
        separatorView.autoSetDimension(.Height,
                                       toSize: 1.0)
        
        /*-----------------------*/
        
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

        // Search and store the inputAccessoryView Height constraint.
        if inputAccessoryViewHeight == nil {
            
            for constraint in self.constraints {
                
                if constraint.firstAttribute == .Height {
                    
                    inputAccessoryViewHeight = constraint
                }
            }
        }
        
        /*-----------------------*/

        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        let numberLines: Int = Int((intrinsicContentSize().height / (textView.font!.lineHeight + GlyphLinePadding)))
        
        var newInputAccessoryViewHeight: CGFloat = 0.0
        
        // Fix the inputAccessoryView Height if it is over 5 lines.
        if numberLines > MaxNumberOfLines {
            
            newInputAccessoryViewHeight = ((textView.font!.lineHeight + GlyphLinePadding) * CGFloat(MaxNumberOfLines)) + 5.5
        }
        else {
            
            newInputAccessoryViewHeight = intrinsicContentSize().height
        }
        
        delegate?.didUpdatedInputAccessoryViewHeight(newInputAccessoryViewHeight)
        
        inputAccessoryViewHeight?.constant = newInputAccessoryViewHeight
    }
    
    override func intrinsicContentSize() -> CGSize {
    
        // Calculate CGSize that will fit all the text
        let size = CGSize(width: textView.bounds.width,
                                  height: CGFloat.max)
        
        let textSize = textView.sizeThatFits(size)
        
        return CGSize(width: UIViewNoIntrinsicMetric,
                      height: textSize.height)
    }
}

extension AnswerComposer: UITextViewDelegate {
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
        // Force to recalculate intrinsicContentSize when text changes
        invalidateIntrinsicContentSize()
    }
}

extension AnswerComposer: NSLayoutManagerDelegate {
    
    //MARK: NSLayoutManagerDelegate
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        
        return GlyphLinePadding
    }
}
