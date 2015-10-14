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
        
        //OS世代
        osGenerationLabel!.text = "\(osGeneration())"
        
        //デバイス名
        deviceNameLabel!.text = deviceName()
        
        //デバイス情報
        deviceInfoLabel!.text = "DeviceInfo:  " + deviceInfoString()
        
        //スクリーンサイズ
        screenSizeLabel!.text = "ScreenSize:  " + screenSizeString()
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
        let systemName = UIDevice.currentDevice().localizedModel
        let deviceVersion = UIDevice.currentDevice().systemVersion
        
        return systemName + " (" + deviceVersion + ")"
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
    
    //MARK: - その他


}

