//
//  AddPlanViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

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
    
    func setNotification(date: Date) {
        //通知日時の設定
        var trigger: UNNotificationTrigger
        //noticficationtimeにdatepickerで取得した値をset
        let notificationTime = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        //現在時刻の取得
        let now = Date()
        //変数setDateに取得日時をDatecomponens型で代入
        let setDate = DateComponents(calendar: .current, year: notificationTime.year, month: notificationTime.month, day: notificationTime.day, hour: notificationTime.hour, minute: notificationTime.minute, second: notificationTime.second).date!
        //変数secondsに現在時刻と通知日時の差分の秒数を代入
        let seconds = setDate.seconds(from: now)
        //triggerに現在時刻から〇〇秒後の実行時間をset
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        //通知内容の設定
        let content = UNMutableNotificationContent()
        content.title = "\(String(describing: subjectTextField.text))をする時間です。"
        content.body = "\(String(describing: timeOneTextField.text))〜\(String(describing: timeTwoTextField.text))"
        content.sound = .default
        //ユニークIDの設定
        let identifier = NSUUID().uuidString
        //登録用リクエストの設定
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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

//引数で指定した日付との差分の秒数を返すextension
extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
