//
//  ViewController.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2021/12/29.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var membersList=[String]()
    
    //アプリ内にデータを保存する仕組み
    let userDefaults=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        if let storedToDoList=userDefaults.array(forKey: "membersList") as? [String]{
            membersList.append(contentsOf: storedToDoList)
        }
        self.editButtonItem.title="編集"
        self.navigationItem.rightBarButtonItem=self.editButtonItem
        //editbuttonで複数選択可能にする
        tableView.allowsMultipleSelectionDuringEditing = true
        
        self.membersNumLabel.text=String(membersList.count)+"人"
    }

    @IBAction func addButton(_ sender: Any) {
        let alertController=UIAlertController(title:"追加",message:"入力してください",preferredStyle:UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.membersList.insert(textField.text!,at:0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                //追加したtodoを保存
                self.userDefaults.set(self.membersList, forKey: "membersList")
                self.membersNumLabel.text=String(self.membersList.count)+"人"
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    //UITableViewに表示したいセルの数を教えるためのメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersList.count
    }
    
    //セルを生成して返却するメソッド,セルの数だけ呼び出される,セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellの取得
        let cell=tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let Title=membersList[indexPath.row]
        cell.textLabel?.text=Title
        return cell
    }
    
    //セルの削除機能

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            self.editButtonItem.title="削除"
        }
        else{
            self.editButtonItem.title="編集"
            self.deleteRows()
            self.membersNumLabel.text=String(membersList.count)+"人"
        }
        tableView.isEditing = editing
    }
    
    private func deleteRows() {
        guard let selectedIndexPaths = self.tableView.indexPathsForSelectedRows else {
            return
        }
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        for indexPathList in sortedIndexPaths {
            membersList.remove(at: indexPathList.row) // 選択肢のindexPathから配列の要素を削除
        }
        // tableViewの行を削除
        tableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
        userDefaults.set(membersList, forKey: "membersList")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView=segue.destination as! ViewController2
        nextView.membersList=membersList.reversed()
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    @IBOutlet weak var membersNumLabel: UILabel!
    
}

