//
//  LoginViewController.swift
//  InstantMessageDemo
//
//  Created by 游义男 on 15/7/29.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {




    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var serverTF: UITextField!
    
    //需要登入
    var requreLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //场景回退
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == self.doneButton{
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "wxserver")
            //配置自动登录
            NSUserDefaults.standardUserDefaults().setBool(self.autoLoginSwitch.on, forKey: "wxautologin")
            //用户同步配置
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //需要登入
            requreLogin = true
            
        }
    }

}
