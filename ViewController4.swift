//
//  ViewController4.swift
//  CreateGroup
//
//  Created by 清水駿太 on 2021/12/31.
//

import UIKit

class ViewController4: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupNum:Int=0
    var groupMembersList=[[String]]()
    var groupNameList=[String]()
    var membersList2=[String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkNilCell()
        if !(sumNilCellCount==0){
            self.createGroup2()
            self.deleteNilCell()
        }
    }
    
    var cellCount:Int=0
    var nilCellCount:Int=0
    var sumCheckCount:Int=0
    var sumNilCellCount:Int=0
    var cellCountArray=[Int]()
    func checkNilCell(){
        sumCheckCount=0
        for i in 0..<groupNum{
            cellCount=0
            nilCellCount=0
            for j in 0..<groupMembersList[i].count{
                if !(groupMembersList[i][j]==""){
                    cellCount+=1
                }
                else{
                    nilCellCount+=1
                }
            }
            sumCheckCount+=cellCount
            sumNilCellCount+=nilCellCount
            cellCountArray.append(cellCount)
        }
        print(cellCountArray)
    }
    
    var maxCount:Int=0
    func createGroup2(){
        membersList2.shuffle()
        for i in 0..<groupNum{
            if maxCount<cellCountArray[i]{
                maxCount=cellCountArray[i]
            }
        }
        for j in 0..<groupNum{
            if cellCountArray[j]<maxCount{
                for _ in 0..<maxCount-cellCountArray[j]{
                    groupMembersList[j].append(membersList2[0])
                    membersList2.remove(at:0)
                }
            }
        }
        for k in 0..<groupNum{
            for l in 0..<membersList2.count{
                if l%groupNum==k{
                    groupMembersList[k].append(membersList2[l])
                }
            }
        }
        print(maxCount)
        print(membersList2)
        print(groupMembersList)
    }
    
    func deleteNilCell(){
        for i in 0..<groupNum{
            for _ in 0..<groupMembersList[i].count{
                if groupMembersList[i].contains("")==true{
                    let nilIndex=groupMembersList[i].firstIndex(where:{$0==""})
                    groupMembersList[i].remove(at:nilIndex!)
                }
            }
        }
        print(groupMembersList)
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
        let header=view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    
    var image=UIImage()
    func screenShot(){
        UIGraphicsBeginImageContextWithOptions(self.groupTableView.contentSize, false, UIScreen.main.scale)

        let savedContentOffset=self.groupTableView.contentOffset
        let savedFrame=self.groupTableView.frame
        let savedBackgroundColor=self.groupTableView.backgroundColor

        self.groupTableView.contentOffset=CGPoint(x:0,y:0)

        self.groupTableView.frame=CGRect(x:0, y:0,width:self.groupTableView.contentSize.width,height:self.groupTableView.contentSize.height)

        self.groupTableView.backgroundColor=UIColor.clear


        let tempView=UIView(frame:CGRect(x:0,y:0,width:self.groupTableView.contentSize.width,height:self.groupTableView.contentSize.height))

        let tempSuperView=self.groupTableView.superview
        self.groupTableView.removeFromSuperview()
        tempView.addSubview(self.groupTableView)

        tempView.layer.render(in:UIGraphicsGetCurrentContext()!)

        image=UIGraphicsGetImageFromCurrentImageContext()!

        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.groupTableView)

        self.groupTableView.contentOffset=savedContentOffset
        self.groupTableView.frame=savedFrame
        self.groupTableView.backgroundColor=savedBackgroundColor

        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
    }
    
    func alert(){
        let alert=UIAlertController(title: "スクリーンショット", message: "スクリーンショットを保存しました", preferredStyle: .alert)
        let ok=UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func screenShot(_ sender: Any) {
        self.screenShot()
        self.alert()
    }
    
    //コンテキスト開始
    //UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
    //viewを書き出す
    //self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
    // imageにコンテキストの内容を書き出す
    //let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    //コンテキストを閉じる
    //UIGraphicsEndImageContext()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
