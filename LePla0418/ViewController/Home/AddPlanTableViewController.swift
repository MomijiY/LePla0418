//
//  AddPlanViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlanTableViewController: UITableViewController{

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    private let model = PlanUserDefaultsModel()
    var timePicker: UIDatePicker = UIDatePicker()

    private var dataSource: [AddPlan] = [AddPlan]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configureTextField()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func savePlan(_ sender: UIBarButtonItem) {
        savePlan()
    }
    
    @objc func doneOne() {
        timeOneTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
    }
    
    @objc func doneTwo() {
        timeTwoTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker.date))"
    }

    @objc func done() {
        subjectTextField.endEditing(true)
    }
    @objc func conDone() {
        contentTextView.endEditing(true)
    }
}

extension AddPlanTableViewController: UITextFieldDelegate, UITextViewDelegate  {
    func configureTextField() {
        timeOneTextField.delegate = self
        timeTwoTextField.delegate = self
        subjectTextField.delegate = self
        contentTextView.delegate = self
    }
}

extension AddPlanTableViewController {
    func savePlan() {
//        guard let timeOne = timeOneTextField.text,
//            let timeTwo = timeTwoTextField.text,
//            let subject = subjectTextField.text,
//            let content = contentTextView.text else { return }
//
//        let plan = AddPlan(timeOne: timeOne, timeTwo: timeTwo, subject: subject, content: content)
//        if let storedPlan = model.loadMemos() {
//            var newPlans = storedPlan
//            newPlans.append(plan)
//            model.saveMemos(newPlans)
//        } else {
//            model.saveMemos([plan])
//        }
//        navigationController?.popViewController(animated: true)
        
        let realm = try! Realm()
        
        try! realm.write{
            let events = [Event(value: ["time1": timeOneTextField.text,
                                        "time2": timeTwoTextField.text,
                                        "subject": subjectTextField.text,
                                        "content": contentTextView.text])]
            realm.add(events)
            print("書き込み中")
        }
        print("書き込み完了")
        navigationController?.popViewController(animated: true)
    }
}

extension AddPlanTableViewController {
    
    func configurePicker() {
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.timeZone = NSTimeZone.local
        timePicker.locale = Locale.current
        timeOneTextField.inputView = timePicker
        timeTwoTextField.inputView = timePicker
        
        //MARK: done button
        let width = view.frame.size.width
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: self,
                                        action: nil)
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(done))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        
        
        let conToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        
        let conSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: self,
                                        action: nil)
        
        let conDoneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(conDone))
        conToolbar.setItems([conSpaceItem, conDoneItem], animated: true)
        
        
        let oneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        
        let oneSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: self,
                                        action: nil)
        
        let oneDoneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(doneOne))
        oneToolbar.setItems([oneSpaceItem, oneDoneItem], animated: true)
        
        
        let twoToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        
        let twoSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: self,
                                        action: nil)
        
        let twoDoneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(doneTwo))
        twoToolbar.setItems([twoSpaceItem, twoDoneItem], animated: true)
        
        timeOneTextField.inputAccessoryView = oneToolbar
        timeTwoTextField.inputAccessoryView = twoToolbar
        subjectTextField.inputAccessoryView = toolbar
        contentTextView.inputAccessoryView = conToolbar
    }
}
