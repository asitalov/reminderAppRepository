//
//  LabelViewController.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/14/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    
 let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scroller: UIScrollView!
    
    var labelText:NSString?
    var dict = NSMutableDictionary ()
    var delegate: newNote?
    
    func updateLabelText(newLabel: String) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Label"
        view.backgroundColor = UIColor .groupTableViewBackgroundColor()
        
        nameTextField.backgroundColor = UIColor .whiteColor()
        nameTextField.layer.borderColor = UIColor .whiteColor().CGColor
        //nameTextField.clearButtonMode = UITextFieldViewMode
        nameTextField.becomeFirstResponder()
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToPreviousView(sender: AnyObject) {
               presentingViewController!.dismissViewControllerAnimated(true, completion: nil)

    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if nameTextField.text == "Place title here"{
         nameTextField.text = ""
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
    
        nameTextField.resignFirstResponder()
        let theNewNote = New_Note ()
        
        if delegate != nil {
            delegate!.updateLabelText(nameTextField.text!)
        }
        
        if nameTextField.text == "" {
          
            theNewNote.labelText = "Place title here"
            
        } else {
            
            theNewNote.labelText = nameTextField.text!
            print("labeltext is  \(theNewNote.labelText)")
        }
        
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
     nameTextField.text = labelText as? String
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
