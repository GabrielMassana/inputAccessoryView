//
//  ViewController.swift
//  inputAccessoryView
//
//  Created by GabrielMassana on 01/07/2016.
//  Copyright © 2016 GabrielMassana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView(frame: UIScreen.mainScreen().bounds,
                                                 style: UITableViewStyle.Plain)
        
        tableView.dataSource = self

        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        return tableView
    }()
    
    lazy var answerComposer: AnswerComposer = {
       
        let answerComposer = AnswerComposer(frame: CGRectMake(0.0,
            CGRectGetHeight(UIScreen.mainScreen().bounds) - 60.0,
            CGRectGetWidth(UIScreen.mainScreen().bounds),
            60.0))
        
        return answerComposer
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.addSubview(tableView)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(answerComposer)
        
        answerComposer.textView.inputAccessoryView = answerComposer
        
        registerCells()
    }
    
    func registerCells() {
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
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
