//
//  ViewController.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/18.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

var toPin = String()

final class ImDateViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    // MARK: Properties
    
    var pin = true
    private var adddate: AddDate!
    private let model = UserDefaultsModel()
    private var dataSource: [AddDate] = [AddDate]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
    static func instance() -> ImDateViewController {
        let vc = UIStoryboard(name: "ImDateViewController", bundle: nil).instantiateInitialViewController() as! ImDateViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemos()
    }

}

// MARK: - Configure

extension ImDateViewController {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //中身のないセルの下線を消す
        tableView.tableFooterView = UIView()
        tableView.rowHeight = ImportantDayTableViewCell.rowHeight
        tableView.register(ImportantDayTableViewCell.nib, forCellReuseIdentifier: ImportantDayTableViewCell.reuseIdentifier)
    }
}

// MARK: - Model

extension ImDateViewController {
    
    private func loadMemos() {
        guard let memos = model.loadMemos() else { return }
        self.dataSource = memos
    }
}

// MARK: - TableView dataSource, delegate

extension ImDateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            alertLabel.isHidden = false
        } else {
            alertLabel.isHidden = true
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImportantDayTableViewCell.reuseIdentifier, for: indexPath) as! ImportantDayTableViewCell
        let selectionview = UIView()
        selectionview.backgroundColor = UIColor(red: 0/255, green: 187/255, blue: 255/255, alpha: 0.2)
        cell.selectedBackgroundView = selectionview
        let memo = dataSource[indexPath.row]
        cell.setupCell(title: memo.title, content: memo.content, date: memo.date)
        if UserDefaults.standard.bool(forKey: "Userpin") {
            cell.setUpPin(pin: "true")
        } else {
            cell.setUpPin(pin: "false")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let addDate = dataSource[indexPath.row]
        let vc = ImDetailViewController.instance(addDate)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //セルの削除許可を設定
    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //　スワイプで削除する関数
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let kStoredMemosKey: String = "kStoredMemosKey"
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //メモ削除
            dataSource.remove(at: indexPath.row)
            guard let data = try? JSONEncoder().encode(dataSource) else { return }
            UserDefaults.standard.set(data, forKey: kStoredMemosKey)

            self.tableView.reloadData()
        }
    }
    
    //スワイプでトップに固定する関数
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "トップに固定", handler: { (ctxAction, view, completionHandler) in
            print("スワイプされました。")
            //スワイプされたら元に戻る
            completionHandler(true)
        })
        action.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
