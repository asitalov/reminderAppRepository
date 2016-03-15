//
//  TextViewViewController.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/14/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class TextViewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentTextView: UITextView!
    var labelContent = NSString()
    var delegate: newNote?
    let theNewNote = New_Note ()
    
//    
//    func updateLabelContext(newLabel: String){
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.title = "Content"
        view.backgroundColor = UIColor .groupTableViewBackgroundColor()
        contentTextView.becomeFirstResponder()
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)); numberToolbar.barStyle = UIBarStyle.Default
        
        numberToolbar.items = [
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "doneButtonTouched")]
        
        numberToolbar.sizeToFit();
        contentTextView.inputAccessoryView = numberToolbar
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        contentTextView.text = labelContent as? String
        
    }
    
    
    @IBAction func returnToPreviousView(sender: AnyObject) {
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func doneButtonTouched (){
        
        contentTextView.resignFirstResponder()
        
        if delegate != nil {
            delegate!.updateLabelContent(contentTextView.text!)
        }
        
        theNewNote.labelContent = contentTextView.text!
        print("labelContent is:  \(theNewNote.labelContent)")
        
        if contentTextView.text == "" {
            theNewNote.labelContent = "Content text"
        } else {
            theNewNote.labelContent = contentTextView.text!
        }
        
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {

        if contentTextView.text == "Content text" {
            contentTextView.text = ""
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
