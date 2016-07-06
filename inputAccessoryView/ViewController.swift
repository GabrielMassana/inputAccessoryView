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
    
    /// A table View to show the messages entered through the textView.
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayoutView()
        
        tableView.dataSource = self
        
        // Important to allow pan down to dismiss the keyboard.
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        return tableView
    }()
    
    /// The UIView subclass with a UITextView and a UIButton to enter text.
    /// This subclass will be returned as the UIResponder inputAccessoryView.
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
        
        if let keyboardInfo = notification.userInfo as? [String : AnyObject],
            let keyboardFrameEndValue = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardFrameBeginValue = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            // CGRect from NSValue
            let keyboardFrameEndRect = keyboardFrameEndValue.CGRectValue()
            let keyboardFrameBeginRect = keyboardFrameBeginValue.CGRectValue()
            
            // Store contentOffset.y before changing contentInset. Sometimes get updated after updating contentInset.
            let contentOffsetY = tableView.contentOffset.y
            
            // Origin y change
            let keyboardOriginYChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y

            // Update contentInset and contentOffset to avoid jumps while sowing the keyboard
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: CGRectGetHeight(keyboardFrameEndRect),
                                                  right: 0.0)
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: contentOffsetY + keyboardOriginYChange)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardInfo = notification.userInfo as? [String : AnyObject],
            let keyboardFrameEndValue = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardFrameBeginValue = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            // CGRect from NSValue
            let keyboardFrameEndRect = keyboardFrameEndValue.CGRectValue()
            let keyboardFrameBeginRect = keyboardFrameBeginValue.CGRectValue()
            
            // Origin y change
            let keyboardOriginYChange = keyboardFrameBeginRect.origin.y - keyboardFrameEndRect.origin.y
            
            // Update contentInset and contentOffset to avoid jumps while sowing the keyboard
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                                  left: 0.0,
                                                  bottom: CGRectGetHeight(keyboardFrameEndRect),
                                                  right: 0.0)
            
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                              y: tableView.contentOffset.y + keyboardOriginYChange)
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
        
        return 21
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self), forIndexPath: indexPath)
        
        cell.textLabel?.text = "row: \(indexPath.row)"
        
        return cell
    }
}

extension ViewController: AnswerComposerDelegate {

}
