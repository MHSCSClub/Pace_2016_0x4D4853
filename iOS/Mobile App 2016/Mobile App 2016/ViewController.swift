//
//  ViewController.swift
//  API
//
//  Created by Jack Phillips on 3/4/16.
//  Copyright © 2016 Mamaroneck High School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var userNameInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let udid = File.readFile("UDID")
        print(udid)
        //File.writeFile("jack.txt", data: "Jack is so cool")
       
        //ServerConnection.postFile(NSData(contentsOfURL: NSURL(fileURLWithPath: File.getFilePath("jack.txt")))!, url: "\(Constants.baseURL)filetest.php", completion: OnFinish);
        
       
        //let params = ["name":"cool", "name2":"Jack Phillips"]
        //ServerConnection.postRequest(params, url: "\(Constants.baseURL)test.php", completion: Done)
        //ServerConnection.getRequest("http://108.30.55.167/Pace_2016_0x4D4853/Backend/api/test/sdsd", completion: OnFinish)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func registerAccount(sender: AnyObject) {
        ServerConnection.postRequest(["username":userNameInput.text!, "password":passwordInput.text!], url: "\(Constants.baseURL)/Pace_2016_0x4D4853/Backend/api/caretaker/register", completion: finishRegister)
    }
    
    @IBAction func login(sender: AnyObject) {
        ServerConnection.postRequest(["username":userNameInput.text!, "password":passwordInput.text!], url: "\(Constants.baseURL)/Pace_2016_0x4D4853/Backend/api/caretaker/login", completion: finishLogin)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func OnFinish (data: NSData) {
        print(NSString(data: data, encoding: NSUTF8StringEncoding));
    }
    
    func finishRegister(data: NSData) {
        print(NSString(data: data, encoding: NSUTF8StringEncoding));
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let status = json["status"] as? String {
                if (status == "success"){
                    print("success")
                    ServerConnection.postRequest(["username":userNameInput.text!, "password":passwordInput.text!], url: "\(Constants.baseURL)/Pace_2016_0x4D4853/Backend/api/caretaker/login", completion: finishLogin)
                }
            }
        }
        catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func finishLogin(data: NSData) {
        print(NSString(data: data, encoding: NSUTF8StringEncoding));
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let status = json["status"] as? String {
                if (status == "success"){
                    if let data = json["data"] as? [String: AnyObject]{
                        if let authcode = data["authcode"] as? String {
                            Constants.saveAuthCode(authcode)
                            Constants.saveType("caregiver")
                            ServerConnection.postRequest(["uiud": File.readFile("UDID")], url: "\(Constants.baseURL)/Pace_2016_0x4D4853/Backend/api/caretaker/device?authcode=\(authcode)", completion: OnFinish)
                            print(authcode)
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.performSegueWithIdentifier("goToMain", sender: self)
                            }
                            
                        }
                    }
                }
            }
        }
        catch {
            print("error serializing JSON: \(error)")
        }
    }
    func Done (data: NSData) {
        print(NSString(data: data, encoding: NSUTF8StringEncoding));
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let data = json["data"] as? [[String: AnyObject]]{
                for info in data{
                    if let name = info["name"] as? String{
                        print("Name is \(name)");
                    }
                }
            }
        }
        catch {
            print("error serializing JSON: \(error)")
        }
        
        
        
        
        
        
    }
    
    
    
}

