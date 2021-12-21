//
//  ViewController.swift
//  Local Notification
//
//  Created by admin on 20/12/2021.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var lblTimerStatuse: UILabel!
    @IBOutlet weak var lblFinishedTime: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var lblLog: UILabel!
    
    @IBOutlet weak var startTimerBtn: UIButton!
    
    var minutesArray = ["5 Minutes","10 Minutes","15 Minutes",
                        "20 Minutes","25 Minutes","30 Minutes"]
    var logArray : [Log] = []
    var counter = -1
    var currentTimer = ""
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPickerView.delegate = self
        myPickerView.dataSource = self
        hideUItoReset()
        lblLog.isHidden = true
    }

    @IBAction func startTimerBtnPressed(_ sender: Any) {
        let time = getTime()
        let alert = UIAlertController(title: "\(time) min countdown", message: "After \(time) Minutes, you'll be notified. Turn your ringer on ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.creatTimer()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel current timer?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(alert: UIAlertAction!) in self.cancelCounter() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelCounter(){
        lblTimerStatuse.text = "\(currentTimer) Timer Cancelled"
        lblFinishedTime.isHidden = true
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are yiu sure it is a new day?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "New Day", style: .default, handler: {(alert: UIAlertAction!) in self.newDay()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func newDay(){
        lblTotalTime.text = "Total time: 0"
        hideUItoReset()
    }
    
    @IBAction func logBtnPressed(_ sender: Any) {
        if flag == 0 {
            lblTimerStatuse.isHidden = true
            lblFinishedTime.isHidden = true
            myPickerView.isHidden = true
            startTimerBtn.isHidden = true
            for log in logArray {
                lblLog.text! += " \(log.startedTime), \(log.finisiedTime), \(log.minutesReq) \n."
            }
            lblLog.isHidden = false
            flag = 1
        }else if flag != 0 {
            appearUIofTimer()
            myPickerView.isHidden = false
            startTimerBtn.isHidden = false
            lblLog.isHidden = true
            flag = 0
        }
    }
    
    func creatTimer(){
        // get time selected
        let time = getTime()
        counter = Int(time) ?? -1
        //create count down
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        //get current time
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.init(identifier: "Asia/Riyadh")
        let startedTime = formatter.string(from: currentTime)
        let finishedTime = formatter.string(from: currentTime.addingTimeInterval(Double(counter)*60))
        logArray.append(Log(startedTime: startedTime, finisiedTime: finishedTime, minutesReq: "\(time) Minutes"))
        
        // updateUIWithTime
        lblTotalTime.text = "Total time: \(time)"
        lblTimerStatuse.text = "\(time) minute timer set"
        lblFinishedTime.text = "work until: \(finishedTime)"
        appearUIofTimer()
    }
    
    @objc func updateCounter(){
        if counter >= 0 {
            lblTimeRemaining.text = "0 hours, \(counter) min"
            counter -= 1
        }
    }
    func getTime() -> String{
        let selectedtime = minutesArray[myPickerView.selectedRow(inComponent: 0)]
        currentTimer = selectedtime
        let endIndex = selectedtime.index(selectedtime.startIndex, offsetBy: 1)
        let time = String(selectedtime[selectedtime.startIndex...endIndex])
        return time
    }
    
    func hideUItoReset(){
        lblTimeRemaining.isHidden = true
        lblTimerStatuse.isHidden = true
        lblFinishedTime.isHidden = true
    }
    
    func appearUIofTimer(){
        lblTimeRemaining.isHidden = false
        lblTimerStatuse.isHidden = false
        lblFinishedTime.isHidden = false
    }

}

extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutesArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutesArray[row]
    }
    
}

struct Log {
    var startedTime:String
    var finisiedTime:String
    var minutesReq:String
}
