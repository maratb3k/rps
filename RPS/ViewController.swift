//
//  ViewController.swift
//  RPS
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var winsLabel: UILabel!
    @IBOutlet var lossesLabel: UILabel!
    @IBOutlet var tiesLabel: UILabel!
    @IBOutlet var rockImg: UIImageView!
    @IBOutlet var paperImg: UIImageView!
    @IBOutlet var scissorsImg: UIImageView!
    @IBOutlet var choicesStack: UIStackView!
    @IBOutlet var roundNumLabel: UILabel!
    
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    var userChoice: String = "rock"
    var isManualMode: Bool = false
    var lastComputerChoice: String? = nil
    var lastAutoChoiceForUser: String? = nil
    var roundAmt: Int = 0
    var winner: String = "" // player/computer
    var isPlayingThreeRounds = false
    let images = [
        "paper",
        "rock",
        "scissors"
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choicesStack.isHidden = true
        roundNumLabel.isHidden = true
        
        let imgViews: [UIImageView] = [rockImg, paperImg, scissorsImg]

        for (index, img) in imgViews.enumerated() {
            img.tag = index
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choiceTapped(_:))))
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if isManualMode && isPlayingThreeRounds {

            guard userChoice != "" else {
                return
            }

            playRound()

            if roundAmt == 3 {
                showResultAlert()
            } else {
                roundAmt += 1
                roundNumLabel.text = "Round \(roundAmt)"
            }

            return
        }
        playRound()
    }
    
    func playRound() {
        var img1: String? = nil
        
        let img2 = getRandomChoiceDifferent(lastComputerChoice)
        imageView2.image = UIImage(named: img2)
        lastComputerChoice = img2
        
        if !isManualMode {
            img1 = getRandomChoiceDifferent(lastAutoChoiceForUser)
            imageView1.image = UIImage(named: img1!)
            lastAutoChoiceForUser = img1
        } else {
            img1 = userChoice
        }
        
        winner = getWinner(img1!, img2)
        updateScores(winner)
    }
    
    
    @objc func choiceTapped(_ sender: UITapGestureRecognizer) {
        guard let selected = sender.view as? UIImageView else { return }

        highlightSelected(selected)

        if selected == rockImg {
            userChoice = "rock"
        } else if selected == paperImg {
            userChoice = "paper"
        } else if selected == scissorsImg {
            userChoice = "scissors"
        }
        
        imageView1.image = UIImage(named: userChoice)
        
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isManualMode = false
            choicesStack.isHidden = true
        case 1:
            isManualMode = true
            choicesStack.isHidden = false
        default:
            break
        }
    }
    
    func getRandomChoiceDifferent(_ last: String?) -> String {
        var newChoice = images.randomElement()!
        while newChoice == last {
            newChoice = images.randomElement()!
        }
        return newChoice
    }
    
    func highlightSelected(_ selected: UIImageView) {
        let all = [rockImg!, paperImg!, scissorsImg!]

        for img in all {
            if img == selected {
                UIView.animate(withDuration: 0.15) {
                    img.layer.borderWidth = 4
                    img.layer.borderColor = UIColor.systemYellow.cgColor
                    img.layer.cornerRadius = 10
                    img.alpha = 1.0
                    img.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
            } else {
                UIView.animate(withDuration: 0.15) {
                    img.layer.borderWidth = 0
                    img.alpha = 0.4
                    img.transform = .identity
                }
            }
        }
    }
    
    func getWinner(_ img1: String, _ img2: String) -> String {
        switch (img1, img2) {
            case ("paper", "scissors"): return "computer"
            case ("scissors", "paper"): return "player"
            case ("paper", "rock"): return "player"
            case ("rock", "paper"): return "computer"
            case ("rock", "scissors"): return "player"
            case ("scissors", "rock"): return "computer"
            default: return "ties"
        }
    }
    
    func updateScores(_ winner: String) {
        if (winner == "computer") {
            losses += 1
        } else if (winner == "player") {
            wins += 1
        } else {
            ties += 1
        }
        
        winsLabel.text = "Wins: \(wins)"
        lossesLabel.text = "Losses: \(losses)"
        tiesLabel.text = "Ties: \(ties)"
    }
    
    
    @IBAction func play3RoundsBtn(_ sender: Any) {
        isPlayingThreeRounds = true
        roundAmt = 0
        roundNumLabel.isHidden = false
        
        if !isManualMode {
            for _ in 1...3 {
                playRound()
            }
            showResultAlert()
        }
    }
    
    func showResultAlert() {
        let alert = UIAlertController(
            title: "Серия завершена!",
            message: "Побед: \(wins)\nПоражений: \(losses)\nНичьих: \(ties)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
        
        isPlayingThreeRounds = false
        roundAmt = 0
        roundNumLabel.isHidden = true
    }
    
}

