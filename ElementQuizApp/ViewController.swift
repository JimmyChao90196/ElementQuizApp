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
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    var elementList = [ "Carbon", "Gold", "Chlorine", "Sodium"]
    var fixedList = [String]()
    
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
                
            case .quiz:
                setupQuiz()
            }
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
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mode = .flashCard
    }
    
    func updateUI() {
        
        let elementName = elementList[currentIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName)
            modeSelector.selectedSegmentIndex = 0
        case .quiz:
            updateQuizUI(elementName)
            modeSelector.selectedSegmentIndex = 1
        }
    }
    
    func updateFlashCardUI(_ elementName: String) {
        
        textField.isHidden = true
        textField.resignFirstResponder()
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
        
        answerLabel.text = "?"
        
        if state == .answer {
            answerLabel.text = elementList[currentIndex]
        } else {
            answerLabel.text = "?"
        }
        
        switch state {
        case .question:
            answerLabel.text = "?"
        default:
            answerLabel.text = elementList[currentIndex]
        }
    }
    
    func updateQuizUI(_ elementName: String) {
        
        textField.isHidden = false
        showAnswerButton.isHidden = true
        
        if currentIndex == (elementList.count - 1) {
            nextButton.setTitle("ShowScore", for: .normal)
        } else {
            nextButton.setTitle("Next question", for: .normal)
        }
        
        switch state {
        case .question:
            answerLabel.text = "?"
            textField.text = ""
            textField.becomeFirstResponder()
            textField.isEnabled = true
            
            // Button
            nextButton.isEnabled = false
            
        case .answer:
            textField.resignFirstResponder()
            textField.isEnabled = false
            if answerIsCorrect {
                answerLabel.text = "✅"
            } else {
                answerLabel.text = "❌ the correct answer is\(elementName)"
            }
            
            // Button
            nextButton.isEnabled = true
            
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
            displayScoreAlert()
            
            // Button
            nextButton.isEnabled = false
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
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
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
    
    // MARK: Show alert -
    private func displayScoreAlert() {
        let alert = UIAlertController(
            title: "Quiz score",
            message: "YOur score is \(correctAnswerCount) out of \(elementList.count)",
            preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: scoreAlertDismissed(_:))
        
        present(alert, animated: true)
    }
    
    private func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    // MARK: Setup initial state for each mode -
    private func setupFlashCards() {
        fixedList = elementList
        state = .question
        currentIndex = 0
    }
    
    private func setupQuiz() {
        elementList = fixedList.shuffled()
        state = .question
        currentIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
    }
}
