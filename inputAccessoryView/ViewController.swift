//
//  ViewController.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

let AnswerComposerHeight: CGFloat = 45.0

class ViewController: UIViewController {
    
    //MARK: - Accessors
    
//    var lastKeyboardHeight: CGFloat = 0.0
    
    var lastInputAccessoryViewHeight: CGFloat = 0.0
    
    /// A table View to show the messages entered through the textView
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayoutView()
        
        tableView.dataSource = self
        
        // Important to allow pan down while dismissing the keyboard.
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        return tableView
    }()
    
    /// The UIView subview with a UITextView to enter text.
    /// This view will be returned as the inputAccessoryView
    lazy var answerComposer: AnswerComposer = {
        
        let frame = CGRect(x: 0.0,
                           y: CGRectGetHeight(UIScreen.mainScreen().bounds) - AnswerComposerHeight,
                           width: 320.0,
                           height: AnswerComposerHeight)
        
        let answerComposer = AnswerComposer(frame: frame)
        
        answerComposer.delegate = self
        
        return answerComposer
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        registerCells()
        
        updateViewConstraints()
        
        view.backgroundColor = UIColor.orangeColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    //MARK: - UIResponder
    
    override var inputAccessoryView: UIView? {
        
        return answerComposer
    }
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-----------------------*/
        
        tableView.autoPinEdgeToSuperviewEdge(.Top)
        
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }
    
    //MARK: - RegisterCells
    
    func registerCells() {
        
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    // MARK: - NotificationActions
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("*******-------******")
        
        print("keyboardWillShow start \(tableView.contentInset)")
        print("keyboardWillShow start \(tableView.contentOffset)")

        let keyboardInfo = notification.userInfo as? [String : AnyObject]
        
        if let keyboardFrameEnd = keyboardInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
        let keyboardFrameBegin = keyboardInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            let keyboardFrameEndRect = keyboardFrameEnd.CGRectValue()
            let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
            
            print("UIKeyboardFrameBeginUserInfoKey \(keyboardInfo?[UIKeyboardFrameBeginUserInfoKey])")
            print("UIKeyboardFrameEndUserInfoKey   \(keyboardInfo?[UIKeyboardFrameEndUserInfoKey])")

            print("EndRect: \(CGRectGetHeight(keyboardFrameEndRect))")
            print("contentOffset.y: \(tableView.contentOffset.y)")
            print("Height: \(lastInputAccessoryViewHeight)")
            print("new.y: \(tableView.contentOffset.y + CGRectGetHeight(keyboardFrameEndRect) - lastInputAccessoryViewHeight)")
            
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: CGRectGetHeight(keyboardFrameEndRect),
                                                  right: 0.0)
            
            let yChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y
            
            print("yChange \(yChange)")
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: tableView.contentOffset.y + yChange)
            

            
            
            print("keyboardWillShow finish \(tableView.contentInset)")
            print("keyboardWillShow finish \(tableView.contentOffset)")
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        
        // do here
        print("*** keyboardWillHide \(tableView.contentInset)")
        print("*** keyboardWillHide \(tableView.contentOffset)")
        
        print("*******-------******")
        
        print("*** keyboardWillHide start \(tableView.contentInset)")
        print("*** keyboardWillHide start \(tableView.contentOffset)")

        
        let keyboardInfo = notification.userInfo as? [String : AnyObject]
        
        if let keyboardFrameEnd = keyboardInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardFrameBegin = keyboardInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            let keyboardFrameEndRect = keyboardFrameEnd.CGRectValue()
            let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
            
            let keyboardHeightChange = CGRectGetHeight(keyboardFrameBeginRect) - CGRectGetHeight(keyboardFrameEndRect)
            
            print("*** Begin: \(CGRectGetHeight(keyboardFrameBeginRect))")
            print("*** End: \(CGRectGetHeight(keyboardFrameEndRect))")
            
            print("*** keyboardHeightChange: \(keyboardHeightChange)")
            
            
            
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: CGRectGetHeight(keyboardFrameEndRect),
                                                  right: 0.0)
            
            let yChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y
            
            print("yChange \(yChange)")
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: tableView.contentOffset.y + yChange)
            
            print("*** keyboardWillHide finish \(tableView.contentInset)")
            print("*** keyboardWillHide finish \(tableView.contentOffset)")
            
        }
        
        
    }
    
    // MARK: - Deinit
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension ViewController: UITableViewDataSource {
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self), forIndexPath: indexPath)
        
        cell.textLabel?.text = "textLabel"
        
        return cell
    }
}

extension ViewController: AnswerComposerDelegate {
    
    func didUpdatedInputAccessoryViewHeight(height: CGFloat) {
        
        lastInputAccessoryViewHeight = height
        
        print("+++++++ height: \(height)")
    }
}
