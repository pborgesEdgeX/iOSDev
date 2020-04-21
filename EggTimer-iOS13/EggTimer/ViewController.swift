//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var progress = Progress(totalUnitCount: 10)
    var player: AVAudioPlayer!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func hardnessPressed(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        let time = selectHardness(getSoftness: hardness)
        
        switch hardness {
        case "Soft":
            execTime(time: time)
           
        case "Medium":
            execTime(time: time)
            
        case "Hard":
            execTime(time: time)
            
        default:
            totalTime = 0
        }
        print("\(time) minutes")
    }
    
    var countdownTimer: Timer!
    var progressTimer: Timer!
    var totalTime = 0

    func execTime(time: Int){
        countdownTimer?.invalidate()
        progressTimer?.invalidate()
        progress =  Progress(totalUnitCount: Int64(time * 60))
        progressView.progress = 0.0
        progress.completedUnitCount = 0
        totalTime = time * 60
        startTimer()
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        /* progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.progress.isFinished == false else {
                timer.invalidate()
                return
            }
            
            self.progress.completedUnitCount += 1
            self.progressView.setProgress(Float(self.progress.fractionCompleted), animated: true)
            self.progressLabel.text = "\(Int(self.progress.fractionCompleted * 100)) %"
            
        } */
       }

    
    @objc func updateTime() {
        
        timerLabel.text = "\(timeFormatted(totalTime))"
        titleLabel.text = "Timer has Started..."
           if totalTime != 0 {
               totalTime -= 1
               progress.completedUnitCount += 1
               progressView.setProgress(Float(self.progress.fractionCompleted), animated: true)
               progressLabel.text = "\(Int(self.progress.fractionCompleted * 100)) %"
            
           } else {
               playSound()
               titleLabel.text = "Done"
               endTimer()
           }
       }

       func endTimer() {
           countdownTimer.invalidate()
       }

       func timeFormatted(_ totalSeconds: Int) -> String {
           let seconds: Int = totalSeconds % 60
           let minutes: Int = (totalSeconds / 60) % 60
           //     let hours: Int = totalSeconds / 3600
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "rooster", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }

    func selectHardness(getSoftness: String) -> Int{
        switch getSoftness {
        case "Soft":
            return 5
        case "Medium":
            return 7
        case "Hard":
            return 12
        default:
            return 0
        }
    }
}
