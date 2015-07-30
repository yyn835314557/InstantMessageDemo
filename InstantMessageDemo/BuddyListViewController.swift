//
//  BuddyListViewController.swift
//  InstantMessageDemo
//
//  Created by 游义男 on 15/7/29.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import UIKit

class BuddyListViewController: UITableViewController ,ZtDl,XxDl{
    
    
    @IBAction func send(sender: UIBarButtonItem) {
    }
    @IBAction func log(sender: UIBarButtonItem) {
        //根据当前状态调整图片状态图片进行上下线操作
        if logged{
            //下线
            logoff()
            //图片改成离线
            sender.image = UIImage(named: "off")
        }else{
            //上线
            login()
            //图片更改成离线
            sender.image = UIImage(named: "on")
        
        }
    }
    @IBOutlet weak var mystatus: UIBarButtonItem!
    
    //未读消息数组
    var unreadList = [WXMessage]()
    
    //好友状态数组作为表格数据源
    var ztList = [ZhuangTai]()
    
    //已登入
    var logged = false
    
    //当前选择聊天的好友用户名
    var currentBuddyName = ""
    
    //自己离线
    func meOff() {
        self.logoff()
    }
    
    //收到离线或未读
    func newMsg(aMsg: WXMessage) {
        //如果消息有正文，isEmpty
        if (aMsg.body != ""){
            //则加入到未读消息组，通知表格刷新
            unreadList.append(aMsg)
            //控制表格刷新
            self.tableView.reloadData()
        }
    }
    
    //上线状态处理
    func isOn(zt: ZhuangTai) {
        //逐条查找
        for (index,oldzt) in enumerate(ztList) {
            //如果找到旧的用户状态
            if(zt.name == oldzt.name){
                //移除旧的状态
                ztList.removeAtIndex(index)
                //一旦找到了，就不找了，，退出循环
                break
            }
        }
        //添加新状态到状态数组
        ztList.append(zt)
        //通知表格刷新
        self.tableView.reloadData()
    }
    //下线状态处理
    func isOff(zt: ZhuangTai) {
        //逐条查找
        for (index,oldzt) in enumerate(ztList) {
            //如果找到旧的用户状态
            if(zt.name == oldzt.name){
                //更改旧的用户状态为，离线
                ztList[index].isOnline = false
                //一旦找到了，就不找了，，退出循环
                break
            }
        }
        //通知表格刷新
        self.tableView.reloadData()
    }
    
    
    //获取总代理
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    //登入
    func login(){
        //清空未读和状态数组
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        zdl().connect()
        // 修改导航栏图片
        mystatus.image = UIImage(named: "on")
        logged = true
        
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")

        //导航标题改成我的好友
        self.navigationItem.title = myID! + "的好友"
        
        //通知表格更新数据
        self.tableView.reloadData()
    }
    //登出
    func logoff(){
        zdl().disconnect()
        mystatus.image = UIImage(named: "off")
        logged = false
        
        //通知表格更新数据
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        //取自动登录
        let autologin = NSUserDefaults.standardUserDefaults().boolForKey("wxautologin")
        
        //如果配置了用户名和自动登录，开始登入
        if( myID != nil && autologin ){
            self.login()
            
        //其他情况条下跳转 登录视图
        }else{
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
        }
        //接管消息代理
        zdl().xxDl = self
        //接管状态代理
        zdl().ztDl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //表格有几个组
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

     //行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return ztList.count
    }

    //单元格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        
        // 好友状态
        let online = ztList[indexPath.row].isOnline
        
        // friend name
        let name = ztList[indexPath.row].name
        
        //未读消息的条数
        var unreads = 0
        // 查找相应的好友未读条数
        for msg in unreadList{
            if(name == msg.from){
                unreads++
            }
        }
        
        // 单元格的文本 bear@xiaoboswift.com(5)
        cell.textLabel?.text = name + "(\(unreads))"
        
        
        
        //根据状态切换单元格的图像
        if online{
            cell.imageView?.image = UIImage(named: "on")
        }else{
            cell.imageView?.image = UIImage(named: "off")
        }
        
        return cell
    }
    
    //选择单元格
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //保存好友用户名
        currentBuddyName = ztList[indexPath.row].name
        //跳转到聊天视图
        self.performSegueWithIdentifier("toChatSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //判断是否转到聊天界面
        if ( segue.identifier == "toChatSegue"){
            //取聊天视图控制器
            let dest = segue.destinationViewController as! ChatTableViewController
            
            //把当前单元格的用户名传给聊天视图
            dest.toBuddyName = currentBuddyName
            //把未读消息传给聊天视图
            for msg in unreadList{
                if msg.from == currentBuddyName {
                    //加入到聊天视图的消息组中
                    dest.msgList.append(msg)
                }
            }
            
            //把相应的未读消息从未读消息中移除
            removeValueFromArray(currentBuddyName, &unreadList)
            //刷新表格
            self.tableView.reloadData()
        }
    }

    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        //如果是登录界面的完成按钮点击了，开始登入
        let source = segue.sourceViewController as! LoginViewController
        if source.requreLogin{
            //注销前一个用户
            self.logoff()
            //登入现用户
            self.login()
        }
    }

}
