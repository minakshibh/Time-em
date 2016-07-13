

import Foundation






class widgetsViewController: UIViewController {
      private let reuseIdentifier = "WidgetCell"
    var selectedWidgets : NSMutableArray = []
    
    @IBOutlet var widgetCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        if NSUserDefaults.standardUserDefaults().valueForKey("selectedWidgets") != nil {
            let data:NSData = NSUserDefaults.standardUserDefaults().valueForKey("selectedWidgets") as! NSData
            
            selectedWidgets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableArray
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    @IBAction func backBtn(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: {})
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
        self.navigationController?.popViewControllerAnimated(true)
        let selectedWidgetsData:NSData = NSKeyedArchiver.archivedDataWithRootObject(selectedWidgets)

        NSUserDefaults.standardUserDefaults().setObject(selectedWidgetsData, forKey: "selectedWidgets")

    }
}

extension widgetsViewController : UICollectionViewDataSource {
    
    //1
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //3
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! widgetsCell
        //2
        if indexPath.row == 0 {
            cell.widgetLabel.backgroundColor = UIColor(red: 99/255.0, green: 192/255.0, blue: 112/255.0, alpha: 1.0)
        }
        else if indexPath.row == 1{
            cell.widgetLabel.backgroundColor = UIColor(red: 184/255.0, green: 63/255.0, blue: 58/255.0, alpha: 1.0)
        }else{
            cell.widgetLabel.backgroundColor = UIColor(red: 81/255.0, green: 179/255.0, blue: 206/255.0, alpha: 1.0)
        }
        //3
        cell.widgetLabel.text = "Label \(indexPath.row)"
        cell.widgetLabel?.textAlignment = NSTextAlignment.Center
        
        
        if selectedWidgets.count>0 {
           
            if selectedWidgets.containsObject("\(indexPath.row)") {
              cell.checkBoxImg.hidden = false
            }else{
              
            }
        }
        

        
        
        return cell
    }
    
}
extension widgetsViewController : UICollectionViewDelegate {
    
     func collectionView(collectionView: UICollectionView,
                                 didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! widgetsCell
        
        if cell.checkBoxImg.hidden == true {
            cell.checkBoxImg.hidden = false
            print(selectedWidgets)
            selectedWidgets.addObject("\(indexPath.row)")
        }else{
            cell.checkBoxImg.hidden = true
            print(selectedWidgets)
            selectedWidgets.removeObject("\(indexPath.row)")
        }
        
}
}