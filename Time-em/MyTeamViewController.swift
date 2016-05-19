//
//  MyTeamViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 18/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MyTeamViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

        @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchTeamList()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTeamList() {
            let api = ApiRequest()
            api.getTeamDetail("2", TimeStamp: "", view: self.view)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "programmaticCell"
        var cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        for view: UIView in UITableViewCell().contentView.subviews {
            if (view is UIView) {
                view.removeFromSuperview()
            }
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}
