//
//  AppDelegate.swift
//  STWeiBo
//
//  Created by ST on 15/11/14.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

// 切换控制器通知
let STSwitchRootViewControllerKey = "STSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: STSwitchRootViewControllerKey, object: nil)

        
        self.setupStartUI()
        
        return true
    }

    
    private func setupStartUI () {
        
        print(UserAccount.loadAccount()?.expires_Date)
        
        // 0.设置导航条和工具条的外观，因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 2.创建根控制器
        window?.rootViewController = defaultContoller()
        window?.makeKeyAndVisible()
        
        print(isNewupdate())
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func switchRootViewController(notify: NSNotification){
        //        print(notify.object)
        if notify.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /**
     用于获取默认界面
     
     :returns: 默认界面
     */
    private func defaultContoller() ->UIViewController
    {
        // 1.检测用户是否登录
        if UserAccount.userLogin(){
            return isNewupdate() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }


    
    private func isNewupdate() -> Bool{
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        //        var temp = nil ?? "123"
        //        print(temp)
        
        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 3.比较当前版本号和以前版本号
        //   2.0                    1.0
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 3.1如果当前>以前 --> 有新版本
            // 3.1.1存储当前最新的版本号
            // iOS7以后就不用调用同步方法了
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        // 3.2如果当前< | ==  --> 没有新版本
        return false
    }
    
}


