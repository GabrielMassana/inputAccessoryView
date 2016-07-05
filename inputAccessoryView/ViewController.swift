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

        return answerComposer
    }()
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.addSubview(tableView)
        
        registerCells()
        
        updateViewConstraints()
        
        view.backgroundColor = UIColor.orangeColor()
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
