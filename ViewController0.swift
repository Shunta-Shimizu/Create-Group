//
//  ViewController0.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2022/02/07.
//

import UIKit
import Collections

class ViewController0: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var listFolderTableView: UITableView!
    
    var membersListFolder: Dictionary<String,[String]> = Dictionary<String,[String]>()
    var membersListKeyFolder = [String]()
    var membersListKey:String = ""
    var valuesMembersList = [String]()
    var membersListFolderSection = [[String](),[]]
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.editButtonItem.title="編集"
        self.navigationItem.rightBarButtonItem=self.editButtonItem
        
        if let storedDictionary0 = userDefaults.object(forKey: "storedData") as? Dictionary<String,[String]>{
            membersListFolder = storedDictionary0
        }
        
        membersListKeyFolder = Array(membersListFolder.keys)
        
        if let index = membersListKeyFolder.firstIndex(where: {$0 == "＋新規リスト作成" }){
            membersListKeyFolder.remove(at: index)
            
        }
        membersListKeyFolder.insert("＋新規リスト作成",at:0)
        
        for listKey in membersListKeyFolder{
            if listKey == "＋新規リスト作成"{
                membersListFolderSection[0].append(listKey)
            }
            else{
                membersListFolderSection[1].append(listKey)
            }
        }
    }
    
    //セルの削除機能
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        listFolderTableView.allowsMultipleSelectionDuringEditing = true
        if editing{
            self.editButtonItem.title = "削除"
            
        }
        else{
            self.editButtonItem.title = "編集"
            self.deleteRows()
        }
        listFolderTableView.isEditing = editing
    }
    
    private func deleteRows() {
        guard let selectedIndexPaths = self.listFolderTableView.indexPathsForSelectedRows else {
            return listFolderTableView.allowsMultipleSelectionDuringEditing = false
        }
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        for indexPathList in sortedIndexPaths {
            membersListKey = membersListFolderSection[1][indexPathList.row]
            self.membersListFolderSection[1].remove(at: indexPathList.row)
            self.membersListFolder.removeValue(forKey: membersListKey)
        }
        // tableViewの行を削除
        listFolderTableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
        userDefaults.set(membersListFolder, forKey: "storedData")
        listFolderTableView.allowsMultipleSelectionDuringEditing = false
    }
    
    //tableViewを区切るsectionの設定
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return membersListFolderSection.count
    }
    
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "新規"
        }
        return "保存済み"
    }
    
    //セクションの色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemGray5
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //UITableViewに表示したいセルの数を教えるためのメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersListFolderSection[section].count
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if listFolderTableView.allowsMultipleSelectionDuringEditing == true && indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    //指定のCellを編集モードにできないようにする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if listFolderTableView.allowsMultipleSelectionDuringEditing == true && indexPath.section == 0 {
            return false
        }
        return true
    }
    //Cellを生成して返却するメソッド,セルの数だけ呼び出される,セルの中身を設定
    //Cellを選択できないようにする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellの取得
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        if listFolderTableView.allowsMultipleSelectionDuringEditing == false {
            let title = membersListFolderSection[indexPath.section][indexPath.row]
            cell.textLabel?.text = title
        }
        else {
            if indexPath.section == 0 {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listFolderTableView.allowsMultipleSelectionDuringEditing == false {
            membersListKey = membersListFolderSection[indexPath.section][indexPath.row]
            valuesMembersList = membersListFolder[membersListKey] ?? []
            listFolderTableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "next0return", sender: nil)
        }
    }
}
