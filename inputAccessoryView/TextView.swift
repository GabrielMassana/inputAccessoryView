//
//  TextView.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 04/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

protocol TextViewDelegate: NSObjectProtocol {
    
    func textDidChange(textView: UITextView)
}

class TextView: UITextView {

    weak var textViewDelegate: TextViewDelegate?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        setUpNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(textDidChange(_:)),
                                                         name: UITextViewTextDidChangeNotification,
                                                         object: self)
    }
    
    func textDidChange(textView: UITextView) {
        
        self.textViewDelegate?.textDidChange(self)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
