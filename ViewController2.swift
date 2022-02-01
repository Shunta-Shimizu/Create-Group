//
//  ViewController2.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2021/12/29.
//

import UIKit

class ViewController2: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var groupNumPicker: UIPickerView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupNameTableView: UITableView!
    
    var membersList=[String]()
    var pickerGroupNumArray=[Int]()
    var groupNum:Int=0
    var groupNameList=[String]()
    var groupNameCount:Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(membersList)
        // Do any additional setup after loading the view.
        
        groupNumPicker.delegate=self
        groupNumPicker.dataSource=self
        
        pickerGroupNumArray=([Int])(1...membersList.count)
        
    }
    
    //PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerGroupNumArray.count
    }
    
    //PickerViewの中身
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerGroupNumArray[row])
    }
    
    //PickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupNum=pickerGroupNumArray[row]
    }
    
    func insertGroupNameCell(){
        for _ in 0..<groupNum{
            groupNameList.append("")
        }
    }
    
    func setGroupNameCell(){
        for i in 0..<groupNum{
            if groupNameList[i]==""{
                groupNameList[i]=groupNameTextField.text!
                groupNameCount+=1
                break
            }
        }
    }
    
    @IBAction func groupNumButton(_ sender: Any) {
        groupNameList.removeAll()
        self.insertGroupNameCell()
        self.groupNameTableView.reloadData()
    }
    
    @IBAction func groupNameButton(_ sender: Any) {
        self.setGroupNameCell()
        self.groupNameTableView.reloadData()
        print(groupNameList)
    }
    
    //tableViewに表示するCellの数と表示内容
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNameList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         cell.textLabel?.text=groupNameList[indexPath.row]
         return cell
     }
    
    //Cellの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //スワイプdeleteの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            groupNameList.remove(at:indexPath.row)
            groupNameTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            groupNameList.insert("", at: indexPath.row)
            groupNameCount-=1
        }
        self.groupNameTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView2=segue.destination as! ViewController3
        nextView2.membersList=membersList
        nextView2.groupNameList=groupNameList
        nextView2.groupNum=groupNum
    }
    
    @IBAction func toNextButton(_ sender: Any) {
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
