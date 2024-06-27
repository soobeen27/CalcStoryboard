//
//  ViewController.swift
//  CalcStoryboard
//
//  Created by Soo Jang on 6/26/24.
//

import UIKit

class ViewController: UIViewController {

    var expression = "0" {
        didSet {
            Buttons.operators.forEach {
                if expression == $0 {
                    expression = "0"
                }
            }
            numLabel.text = expression
        }
    }
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
    }
    func setButtons() {
        for index in 0..<buttons.count {
            buttons[index].setTitle(Buttons.texts[index], for: .normal)
            buttons[index].layer.cornerRadius = buttons[index].frame.height / 2
        }

        buttons.forEach {
            $0.addTarget(self, action: #selector(btnsTapped), for: .touchDown)
        }
    }
    @objc
    func btnsTapped(_ sender: UIButton) {
        guard let input = sender.titleLabel?.text else { return }
        if expression.prefix(1) == "0" {
            expression.removeFirst()
        }
        switch input {
        case "AC":
            expression = "0"
        case "=":
            if Buttons.operators.contains(String(expression.last ?? " ")) {
                expression.removeLast()
            }
            let calcExp = expression.replacingOccurrences(of: Buttons.multiplMark, with: "*").replacingOccurrences(of: Buttons.divisionMark, with: "/")
            guard let result = calculate(expression: calcExp) else { return }
            expression = String(result)
        case _ where Buttons.operators.contains(input):
            if Buttons.operators.contains(String(expression.last ?? " ")) {
                expression.removeLast()
            }
            expression.append(input)
        default:
            expression.append(input)
        }
    }
    func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
}
// MARK: Model
struct Buttons {
    private init() {}
    static let multiplMark = "×"
    static let divisionMark = "÷"
    static let texts = ["7", "8", "9", "+", "4", "5", "6", "-", "1", "2", "3", multiplMark, "AC", "0", "=", divisionMark]
    static let orrangeBtns = ["+", "-", divisionMark, multiplMark, "AC", "="]
    static let operators = ["+", "-", divisionMark, multiplMark]
}
