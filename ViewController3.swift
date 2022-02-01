//
//  ViewController3.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2021/12/31.
//

import UIKit

class ViewController3: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var createGroupTableView: UITableView!
    @IBOutlet weak var groupMembersPicker: UIPickerView!
    @IBOutlet weak var okButton: UIButton!
    
    var membersList=[String]()
    var groupNameList=[String]()
    var groupMembersList=[[String]]()
    var emptyList=[String]()
    var groupNum:Int=0
    var member:String=""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(groupNum)
        // Do any additional setup after loading the view.
        groupMembersPicker.delegate=self
        groupMembersPicker.dataSource=self
        
        okButton.setTitle("セルの設置", for: .normal)
        
        for _ in 0..<groupNum{
            groupMembersList.append(emptyList)
        }
        
        self.editButtonItem.title="編集"
        self.navigationItem.rightBarButtonItem=self.editButtonItem
        //editbuttonで複数選択可能にする
        createGroupTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return membersList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return membersList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        member=membersList[row]
    }
    
    //tableViewに表示するCellの数と表示内容
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return groupMembersList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text=groupMembersList[indexPath.section][indexPath.row]
        return cell
    }
    
    //tableViewを区切るsectionの設定
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupNameList.count
    }
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupNameList[section]
    }
    
    //セクションの色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemGray5
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            self.editButtonItem.title="並び替え"
        }
        else{
            self.editButtonItem.title="編集"
            self.shuffleArray()
        }
        createGroupTableView.isEditing = editing
    }
    //Cellの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //スワイプdeleteの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            groupMembersList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at:[indexPath as IndexPath] ,with: UITableView.RowAnimation.automatic)
            groupMembersList[indexPath.section].insert("", at: indexPath.row)
        }
        self.createGroupTableView.reloadData()
        print(groupMembersList)
    }
    
    var shuffleCell=""
    func shuffleArray(){
        //selectedIndexPathには[ [0, 1], [1, 0], [2, 0], [2, 1]]のように選択された二次元配列のセクション番号とrow番号が入る
        guard let selectedIndexPaths=self.createGroupTableView.indexPathsForSelectedRows else{
            return
        }
        if selectedIndexPaths.count==2{
            let i=selectedIndexPaths[0]
            let j=selectedIndexPaths[1]
            shuffleCell=groupMembersList[i.section][i.row]
            groupMembersList[i.section][i.row]=groupMembersList[j.section][j.row]
            groupMembersList[j.section][j.row]=shuffleCell
        }
        else if selectedIndexPaths.count<2{
            let alert = UIAlertController(title: "並び替え選択についてのエラー", message: "2つに限定してください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "並び替え選択についてのエラー", message: "2つより多く選んでいます。2つに限定してください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        self.createGroupTableView.reloadData()
        print(selectedIndexPaths)
        print(groupMembersList)
    }
    
    var nilCellIndexPath=[IndexPath]()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nilCellIndexPath.count==1{
            nilCellIndexPath.removeAll()
            nilCellIndexPath.insert(indexPath, at: 0)
        }
        else{
            nilCellIndexPath.insert(indexPath, at: 0)
        }
        print(nilCellIndexPath)
    }
    
    func insertCell(){
        for i in 0..<groupNum{
            for _ in 0..<membersList.count/groupNum{
                groupMembersList[i].append("")
            }
        }
        if !(membersList.count%groupNum==0){
            for j in 0..<membersList.count%groupNum{
                groupMembersList[j].append("")
            }
        }
        createGroupTableView.reloadData()
        print(groupMembersList)
    }
    
    func setCell2(){
        for i in 0..<groupNum{
            if groupMembersList[i].contains(member)==true{
                member=""
            }
            else{
                okButton.setTitle("既に追加済み", for: .normal)
            }
        }
        if !(member==""){
            okButton.setTitle("追加", for: .normal)
            groupMembersList[nilCellIndexPath[0].section][nilCellIndexPath[0].row]=member
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        _ = sender as! UIButton
        if groupMembersList[0].count==0{
            self.insertCell()
        }
        else if nilCellIndexPath.count==0{
            let alert = UIAlertController(title: "選択してください", message: "セルをタップしてください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            okButton.setTitle("追加", for: .normal)
            self.setCell2()
            createGroupTableView.reloadData()
        }
    }
    
    var membersList2=[String]()
    var member2:String=""
    var groupNum2:Int=0
    var divIndex:Int=0
    func removemembersArray2(){
        membersList2=membersList
        for i in 0..<membersList.count{
            member2=membersList[i]
            for j in 0..<groupNum{
                if groupMembersList[j].contains(member2)==true{
                    let index=membersList2.firstIndex(where:{ $0==member2})
                    membersList2.remove(at:index!)
                }
            }
        }
        print(membersList2)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if groupMembersList[0].count==0{
        }
        else{
            self.removemembersArray2()
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView3=segue.destination as! ViewController4
        nextView3.groupNum=groupNum
        nextView3.groupMembersList=groupMembersList
        nextView3.groupNameList=groupNameList
        nextView3.membersList2=membersList2
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
