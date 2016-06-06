//
//  DistanceViewController.swift
//  easyUnit
//
//  Created by Wu on 2/23/16.
//  Copyright © 2016 Jiadong Wu. All rights reserved.
//

import UIKit

class LengthViewController: UIViewController,UITableViewDelegate,UITextFieldDelegate {
    
    var lengthUnitConverter = LengthUnitConverter.getInstance()
    
    @IBOutlet weak var currentUnitUILabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentValueUITextField: DecimalTextField!
    
    @IBOutlet weak var currentUnitCountryFlag: UIImageView!
    @IBOutlet weak var currentUnitName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCurrentUnit()
        tableView.tableFooterView = UIView()
        
        currentValueUITextField.delegate = currentValueUITextField
        
        // remove the navigation bar board
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCurrentUnit() {
        currentUnitUILabel.text = lengthUnitConverter.sourceUnit.symbol
        currentValueUITextField.text = NSString(format:"%.\(Config.getInstance().numberOfDigits)f", lengthUnitConverter.sourceValue) as String
        currentUnitCountryFlag.image = UIImage(named: lengthUnitConverter.sourceUnit.country.getString())
        currentUnitName.text = lengthUnitConverter.sourceUnit.name
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadCurrentUnit()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lengthUnitConverter.targetUnits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UnitCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LengthUnitCell") as! UnitCell
        let unit = lengthUnitConverter.targetUnits[indexPath.row]
        let value = lengthUnitConverter.convert(lengthUnitConverter.sourceUnit, target: unit, value: lengthUnitConverter.sourceValue)
        cell.loadCell(unit, value: value)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UnitCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! UnitCell?
        if let unit = cell?.unit {
            if let value = cell?.value {
                let newUnit = lengthUnitConverter.switchSourceUnit(unit, value: value)
                currentUnitUILabel.text = newUnit.symbol
                currentValueUITextField.text = NSString(format:"%.\(Config.getInstance().numberOfDigits)f", lengthUnitConverter.sourceValue) as String
                currentUnitCountryFlag.image = UIImage(named: newUnit.country.getString())
                currentUnitName.text = newUnit.name
                tableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UnitCell? = self.tableView.cellForRowAtIndexPath(indexPath) as! UnitCell?
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            if let unit = cell?.unit {
                lengthUnitConverter.delete(unit)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            return
        })
        
        deleteButton.backgroundColor = UIColor(red: 49/255, green: 60/255, blue: 69/255, alpha: 1.0)
        
        return [deleteButton]
    }
    
    
    // set the height of UITableViewCell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    @IBAction func UITextFieldValueInput(sender: UITextField) {
        if let text = sender.text {
            if !text.isEmpty {
                if let number = Double(text) {
                    lengthUnitConverter.sourceValue = number
                    tableView.reloadData()
                }
            }else{
                lengthUnitConverter.sourceValue = 1.0
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func UIButtonAddUnit(sender: UIBarButtonItem) {
        performSegueWithIdentifier("AddUnitFromLengthSegue", sender: self)
    }

    
}
