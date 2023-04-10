//
//  ViewController.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2021/12/29.
//

import UIKit

class ViewController1: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var membersList = [String]()
    var membersListKey:String = ""
    var changedMembersListKey:String = ""
    var membersListFolder: Dictionary<String,[String]> = ["＋新規リスト作成":[]]
    var membersListKeyFolder = [String]()
    var insertMember:String = ""
    var editCount:Int = 0
    //アプリ内にデータを保存する仕組み
    let userDefaults=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新規メンバーリスト"
        
        self.editButtonItem.title = "編集"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let storedDictionary = userDefaults.object(forKey: "storedData") as? Dictionary<String,[String]>{
            membersListFolder = storedDictionary
        }
        
        membersListKeyFolder = Array(membersListFolder.keys)

        //UserDefaultsに保存されている内容を削除
        //userDefaults.removeObject(forKey: "storedData")
        //editbuttonで複数選択可能にする
        tableView.allowsMultipleSelectionDuringEditing = true
        
        self.membersNumLabel.text = String(membersList.count)+"人"
    }
    
    //ページを戻るSegueの設定
    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        let view0 = segue.source as! ViewController0
        membersList = view0.valuesMembersList
        membersListKey = view0.membersListKey
        membersListFolder = view0.membersListFolder
        membersListKeyFolder = view0.membersListKeyFolder
        if membersListKey == "" || membersListKey == "＋新規リスト作成" {
            self.title = "新規メンバーリスト"
        }
        else{
            self.title = membersListKey
        }
        self.tableView.reloadData()
        self.membersNumLabel.text = String(membersList.count)+"人"
    }

    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title:"追加",message:"入力してください",preferredStyle:UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            self.editCount += 1
            if let textField = alertController.textFields?.first {
                self.insertMember = textField.text!
                if self.membersList.contains(self.insertMember) == true{
                    self.checkSameNameAlert()
                }
                else{
                    self.membersList.insert(self.insertMember,at:0)
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                    self.membersNumLabel.text=String(self.membersList.count)+"人"
                }
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let Title = membersList[indexPath.row]
        cell.textLabel?.text = Title
        return cell
    }
    
    //セルの削除機能
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            self.editButtonItem.title = "削除"
        }
        else{
            self.editButtonItem.title = "編集"
            self.deleteRows()
            self.membersNumLabel.text = String(membersList.count)+"人"
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
    
    func checkSameNameAlert(){
        let alert = UIAlertController(title: "入力内容についてのエラー", message:  "同一の入力内容は追加できません。変更してください。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkSameListNameAlert(){
        let alert = UIAlertController(title: "入力内容に関するエラー", message: "既に同一のリスト名が利用されています。変更してください。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func saveMembersList_and_toViewController2(){
        if membersListKey == "" {
            self.saveMembersListAlert()
        }
        else if membersListKey == "＋新規リスト作成"{
            self.saveMembersListAlert()
        }
        else{
            if membersListFolder[membersListKey]!.count == membersList.count {
                for member in membersList{
                    if membersListFolder[membersListKey]!.contains(member) == true {
                        if editCount > 0{
                            self.saveChangedMembersListAlert()
                        }
                    }
                    else{
                        self.saveChangedMembersListAlert()
                    }
                }
            }
            else if !(membersListFolder[membersListKey]!.count == membersList.count) {
                self.saveChangedMembersListAlert()
            }
            self.performSegue(withIdentifier: "next1", sender: nil)
        }
    }
    
    func saveMembersListAlert(){
        let alert = UIAlertController(title: "新規メンバーリストの保存", message: "新規メンバーリストを保存しますか？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "はい", style: .default) { (action) in
            self.addKeyName_and_AddDictionaryAlert()
        }
        let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "next1", sender: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    var newListName:String = ""
    //var alertTextField : UITextField?
    func addKeyName_and_AddDictionaryAlert(){
        let alertController = UIAlertController(title:"メンバーリスト名", message:"メンバーリスト名を入力してください", preferredStyle:UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            if let textField = alertController.textFields!.first {
                if self.membersListKey == "＋新規リスト作成" {
                    self.membersListFolder.removeValue(forKey: self.membersListKey)
                    self.membersListKey = textField.text!
                    if self.membersListKey == "＋新規リスト作成"{
                        self.unavailableMembersListKeyAlert()
                    }
                    else if self.membersListKeyFolder.contains(self.membersListKey) == true{
                        self.checkSameListNameAlert()
                    }
                    else{
                        self.membersListFolder.updateValue(self.membersList, forKey: self.membersListKey)
                        UserDefaults.standard.set(self.membersListFolder, forKey:"storedData")
                        self.performSegue(withIdentifier: "next1", sender: nil)
                    }
                }
                else{
                    self.newListName = textField.text!
                    if self.newListName == "＋新規リスト作成"{
                        self.unavailableMembersListKeyAlert()
                    }
                    else if self.membersListKeyFolder.contains(self.newListName) == true{
                        self.checkSameListNameAlert()
                    }
                    else{
                        self.newListName = textField.text!
                        //membersListFolderの更新
                        self.membersListFolder.updateValue(self.membersList, forKey: self.newListName)
                        UserDefaults.standard.set(self.membersListFolder, forKey:"storedData")
                        self.performSegue(withIdentifier: "next1", sender: nil)
                    }
                }
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveChangedMembersListAlert(){
        let alert = UIAlertController(title: "メンバーリストの変更を保存", message: "変更されたメンバーリストを保存しますか？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "はい", style: .default) { (action) in
            self.changeMembersListAlert()
        }
        let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "next1", sender: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func changeMembersListAlert(){
        let alert = UIAlertController(title: "メンバーリスト名の変更", message: "メンバーリスト名を変更しますか？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "はい", style: .default) { (action) in
            self.changeMembersListTextFieldAlert()
        }
        let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
            self.membersListFolder.updateValue(self.membersList, forKey: self.membersListKey)
            UserDefaults.standard.set(self.membersListFolder, forKey:"storedData")
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "next1", sender: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func changeMembersListTextFieldAlert(){
        let alertController = UIAlertController(title:"メンバーリスト名の入力", message:"メンバーリスト名を入力してください。", preferredStyle:UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            if let textField = alertController.textFields!.first {
                self.changedMembersListKey = textField.text!
                //membersListFolderの更新
                if self.changedMembersListKey == "＋新規リスト作成"{
                    self.unavailableMembersListKeyAlert()
                }
                else if self.membersListKeyFolder.contains(self.changedMembersListKey) == true{
                    self.checkSameNameAlert()
                }
                else{
                    self.membersListFolder.updateValue(self.membersList, forKey: self.changedMembersListKey)
                    self.membersListFolder.removeValue(forKey: self.membersListKey)
                    UserDefaults.standard.set(self.membersListFolder, forKey:"storedData")
                    self.performSegue(withIdentifier: "next1", sender: nil)
                }
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func unavailableMembersListKeyAlert(){
        let alert = UIAlertController(title: "リスト名に関するエラー", message: "このリスト名は利用できません。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView0=segue.destination as? ViewController0
        let nextView1 = segue.destination as? ViewController2
        nextView0?.membersListFolder = membersListFolder
        nextView1?.membersList = membersList.reversed()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if membersList.count <= 0{
        }
        else{
            editCount = 0
            self.saveMembersList_and_toViewController2()
        }
    }
    

    @IBOutlet weak var membersNumLabel: UILabel!
    
    @IBAction func listFolderButton(_ sender: Any) {
        if let storedDictionary = userDefaults.object(forKey: "storedData") as? Dictionary<String,[String]>{
            membersListFolder = storedDictionary
        }
        editCount = 0
        self.performSegue(withIdentifier: "next0", sender: nil)
    }
    
}

