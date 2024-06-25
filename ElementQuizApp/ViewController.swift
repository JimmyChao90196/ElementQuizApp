//
//  ViewController.swift
//  ElementQuizApp
//
//  Created by JimmyChao on 2024/6/25.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let elementList = [ "Carbon", "Gold", "Chlorine", "Sodium"]
    
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }
    var state: State = .question

    var currentIndex = 0
    
    // Quiz property
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        
        let elementName = elementList[currentIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName)
        case .quiz:
            updateQuizUI(elementName)
        }
    }
    
    func updateFlashCardUI(_ elementName: String) {
        
        textField.isHidden = true
        textField.resignFirstResponder()
        
        answerLabel.text = "?"
        
        if state == .answer {
            answerLabel.text = elementList[currentIndex]
        } else {
            answerLabel.text = "?"
        }
    }
    
    func updateQuizUI(_ elementName: String) {
        
        textField.isHidden = false
        
        
        switch state {
        case .question:
            answerLabel.text = "?"
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
            if answerIsCorrect {
                answerLabel.text = "✅"
            } else {
                answerLabel.text = "❎"
            }
        }
    }
    @IBAction func switchModes(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        currentIndex += 1
        
        if currentIndex >= elementList.count {
            currentIndex = 0
        }
        
        state = .question
        
        updateUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let content = textField.text
        
        guard let content else { return true }
        
        if content == elementList[currentIndex] {
            answerIsCorrect = true
        } else {
            answerIsCorrect = false
        }
        
        state = .answer
        updateUI()
        
        return true
    }
}

