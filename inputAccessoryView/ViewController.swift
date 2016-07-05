//
//  ViewController.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

let AnswerComposerHeight: CGFloat = 30.0

class ViewController: UIViewController {

    //MARK: - Accessors

    var tableViewBottomConstraint: NSLayoutConstraint?
    
    var lastKeyboardHeight: CGFloat = 0.0
    
    var isKeyboardHidding = false
    
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
        
        /*
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(keyboardFrameWillChange:)
         name:UIKeyboardWillChangeFrameNotification
         object:nil];
         
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(keyboardWillHide:)
         name:UIKeyboardWillHideNotification
         object:nil];
         */
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
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
        
        if tableViewBottomConstraint == nil {
            
            tableViewBottomConstraint = tableView.autoPinEdgeToSuperviewEdge(.Bottom,
                                                                             withInset: AnswerComposerHeight)
        }
    }
    
    //MARK: - RegisterCells

    func registerCells() {
        
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    // MARK: - NotificationActions
    
    func keyboardWillShow(notification: NSNotification) {
        
        if !isKeyboardHidding {
            
            let keyboardInfo = notification.userInfo as? [String : AnyObject]
            
            if let keyboardFrameBegin = keyboardInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                
                let keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue()
                
                tableViewBottomConstraint?.constant = -CGRectGetHeight(keyboardFrameBeginRect)
                
                lastKeyboardHeight = CGRectGetHeight(keyboardFrameBeginRect)
                
                tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                                  y: tableView.contentOffset.y + lastKeyboardHeight)
            }
        }
        else {
            
            isKeyboardHidding = false
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        tableViewBottomConstraint?.constant = -lastInputAccessoryViewHeight
        
        isKeyboardHidding = true

        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x,
                                          y: tableView.contentOffset.y - lastKeyboardHeight)
        
        lastKeyboardHeight = lastInputAccessoryViewHeight
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
        
        tableViewBottomConstraint?.constant = -lastKeyboardHeight
    }
}
