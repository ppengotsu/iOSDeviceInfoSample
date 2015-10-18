//
//  ViewController.swift
//  iOSDeviceInfoSample
//
//  Created by ppengotsu on 2015/10/14.
//  Copyright © 2015年 ppengotsu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var getScreenShotButton: UIButton?
    @IBOutlet var osGenerationLabel: UILabel?
    @IBOutlet var deviceNameLabel: UILabel?
    @IBOutlet var deviceInfoLabel: UILabel?
    @IBOutlet var screenSizeLabel: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        renewDataForDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - 表示更新
    /**
    表示用データ更新
    */
    func renewDataForDisplay(){
        
        //OSごとに色表示
        renewBackgroundOSColor()
        
        //OS世代
        osGenerationLabel!.text = "\(osGeneration())"
        
        //デバイス名
        deviceNameLabel!.text = deviceName()
        
        //デバイス情報
        deviceInfoLabel!.text = "DeviceInfo:  " + deviceInfoString()
        
        //スクリーンサイズ
        screenSizeLabel!.text = "ScreenSize:  " + screenSizeString()
    }
    
    /**
    OSバージョンごとの背景色にする
    */
    func renewBackgroundOSColor(){
        let osVersion = osGeneration()
        switch osVersion{
            case "8":
                self.view.backgroundColor = UIColor(red:0.0,green:0.5,blue:1.0,alpha:1.0)
            break
            
            case "9":
                self.view.backgroundColor = UIColor(red:0.9,green:0.0,blue:0.5,alpha:1.0)
            break
            
            case "10":
                self.view.backgroundColor = UIColor(red:0.8,green:0.8,blue:0.8,alpha:1.0)
            break
            
            case "11":
                self.view.backgroundColor = UIColor(red:0.2,green:0.5,blue:0.2,alpha:1.0)
            break
        default:
            break
        }
    }
    
    
    // MAKR: - ボタンアクション
    /**
    スクリーンショット取得ボタン押した時
    
    :param: sender 
    */
    @IBAction func tappedGetScrennShotButton(sender:AnyObject){
        
        getScreenShotButton?.hidden = true//ボタンを非表示にする
        
        let image: UIImage = screenShotImage()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
        
        let alert:UIAlertController = UIAlertController(title: "完了", message: "スクリーンショット保存しました。", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        getScreenShotButton?.hidden = false//ボタン表示
        
        
        
    }
    
    
    
    // MARK: - データ取得周り
    
    func screenShotImage() -> UIImage {
        let rect = self.view.bounds;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        self.view.layer.renderInContext(context)
        
        let screenshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return screenshotImage
        
        
    }
    
    
    func deviceName() -> String{
        return  UIDevice.currentDevice().name
    }
    
    
    /**
    デバイス情報取得
    
    :returns:
    */
    func deviceInfoString() -> String{
        let platform = platformString();
        let deviceVersion = UIDevice.currentDevice().systemVersion
        
        return platform + " (" + deviceVersion + ")"
    }
    
    /**
    OSの世代取得(例:9.0.2なら9となる)
    
    :returns:
    */
    func osGeneration() -> String{
        //let deviceVersion = "11.0.0.1"
        let deviceVersion = UIDevice.currentDevice().systemVersion
        let osGenerationString = deviceVersion.characters.split(".").map{ String($0) }
        
        return osGenerationString[0]
    }
    
    /**
    スクリーンサイズ取得。横x縦
    
    :returns:
    */
    func screenSizeString() -> String{
        let screenSize: CGSize = UIScreen.mainScreen().nativeBounds.size
        return  "\(screenSize.width)x\(screenSize.height)"
    }
    
    
    /**
    プラットフォーム名取得
    
    :returns:
    */
    func platformString() -> String{
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](count: size, repeatedValue: 0)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String.fromCString(machine)! // 例: iPad3,1
    }
    
    //MARK: - その他

}

