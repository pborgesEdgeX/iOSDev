//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var trackerLabel: UILabel!
    
    var quizBrain = QuizBrain()
    
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        timer?.invalidate()
        
        let userAnswer = sender.currentTitle!
        let getAnswer = quizBrain.checkAnswer(userAnswer)
        if  getAnswer {
            sender.backgroundColor = UIColor.green
            quizBrain.addScore()
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        print("index: \(quizBrain.questionIndex())")
        print("score: \(quizBrain.scoreResult())")
        if quizBrain.checkLastItem(){
             scoreLabel.text = "Score: \(quizBrain.scoreResult())"
            let seconds = 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.startTimer()
            }
            
            
        }
        else{
            startTimer()
        }
        quizBrain.nextQuestion()
        print("index_future: \(quizBrain.questionIndex())")
        print("score_future: \(quizBrain.scoreResult())")
        
        
    }
    
    func startTimer(){
           timer = Timer.scheduledTimer(timeInterval: 0.2, target:self, selector:#selector(updateUI), userInfo:nil, repeats: true)
       }
       
    @objc func updateUI(){
        questionLabel.text = quizBrain.getQuestionText()
        progressBar.progress = quizBrain.getProgress()
        trackerLabel.text = "\(quizBrain.questionNumber+1) out of \(quizBrain.quizCount()) questions"
        scoreLabel.text = "Score: \(quizBrain.scoreResult())"
        trueButton.backgroundColor = UIColor.clear
        falseButton.backgroundColor = UIColor.clear
        
    }
    


}

