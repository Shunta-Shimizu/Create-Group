//
//  ViewController.swift
//  ToDolist
//
//  Created by 清水駿太 on 2021/12/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var todolist=[String]()
    let userDefaults=UserDefaults.standard
    
    //画面が呼ばれたときに動作する
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //データの読み込み
        if let storedToDoList=userDefaults.array(forKey: "todolist") as? [String]{
            todolist.append(contentsOf: storedToDoList)
        }
    }
    
    //Addボタンの動作
@IBAction func addbtnAction(_ sender: Any) {
        let alertController=UIAlertController(title:"ToDo追加",message:"ToDoを入力してください",preferredStyle:UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.todolist.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                //追加したtodoを保存
                self.userDefaults.set(self.todolist, forKey: "todolist")
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    //UITableViewに表示したいセルの数を教えるためのメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }
    
    //セルを生成して返却するメソッド,セルの数だけ呼び出される,セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellの取得
        let cell=tableView.dequeueReusableCell(withIdentifier:"todoCell", for: indexPath)
        let todoTitle=todolist[indexPath.row]
        cell.textLabel?.text=todoTitle
        return cell
    }
    
    //セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCell.EditingStyle.delete{
            todolist.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            //削除したことを保存
            userDefaults.set(todolist, forKey: "todolist")
        }
    }
}

