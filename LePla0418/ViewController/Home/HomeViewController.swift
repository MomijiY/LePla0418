//
//  HomeViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class HomeViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    
    var time1: String!
    private let model = PlanUserDefaultsModel()
    private var dataSource: [AddPlan] = [AddPlan]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMemos()
    }
}

extension HomeViewController {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            self.view.layoutIfNeeded()
    }
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        let comp = Calendar.Component.weekday
        let todayweekday = NSCalendar.current.component(comp, from: NSDate() as Date)
        if weekday == 1 {   //日曜日
            if todayweekday == 1 {
                return UIColor.white
            } else {
                return UIColor.red
            }
        }
         if weekday == 7 {  //土曜日
            if todayweekday == 7 {
                return UIColor.white
            } else {
                return UIColor.blue
            }
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        let da = "\(year)/\(m)/\(d)"
        
        let realm = try! Realm()
        var results = realm.objects(Event.self)
        
        results = results.filter("date = '\(da)'")
        print(results)
        
        for ev in results {
            //Value of type 'Event' has no member 'date'
            if ev.time1 == time1 {
                //この後をどう書けばいいのか分からない
                let cell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.reuseIdentifier) as! PlanTableViewCell
                cell.setUpPlanCell(timeOne: <#T##String#>, timeTwo: <#T##String#>, subject: <#T##String#>, content: <#T##String#>)
                tableView.reloadData()
            }
        }
    }
}

extension HomeViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = PlanTableViewCell.rowHeight
        tableView.register(PlanTableViewCell.nib, forCellReuseIdentifier: PlanTableViewCell.reuseIdentifier)
    }
    
    private func loadMemos() {
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            alertLabel.isHidden = false
        } else {
            alertLabel.isHidden = true
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.reuseIdentifier, for: indexPath) as! PlanTableViewCell
        let memo = dataSource[indexPath.row]
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 0/255, green: 187/255, blue: 255/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        
        cell.setUpPlanCell(timeOne: memo.timeOne, timeTwo: memo.timeTwo, subject: memo.subject, content: memo.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let addPlan = dataSource[indexPath.row]
        let vc = PlanDetailViewController.instance(addPlan)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //セルの削除許可を設定
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //　スワイプで削除する関数
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let planStoredKey: String = "planStoredKey"
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //メモ削除
            dataSource.remove(at: indexPath.row)
            guard let data = try? JSONEncoder().encode(dataSource) else { return }
            UserDefaults.standard.set(data, forKey: planStoredKey)

            self.tableView.reloadData()
        }
    }
    
}

