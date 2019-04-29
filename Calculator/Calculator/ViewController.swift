//
//  ViewController.swift
//  Calculator
//
//  Created by Vlad on 4/26/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var resultPanelLabel: UILabel!
    var isEntered = false
    var isDouble = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSing = Operation.none
    
    var currentInput:Double{
        get{
            return Double(resultPanelLabel.text!)!
        }
        set{
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray.count == 2 && valueArray[1] == "0"{
                resultPanelLabel.text = valueArray[0]
            }
            else{
                resultPanelLabel.text = value
            }
            isEntered = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resultPanelLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4)
    }
    
    //MARK: Number pressed
    @IBAction func numbers(_ sender: UIButton) {
        let number = sender.currentTitle!
        if isEntered{
            if resultPanelLabel.text!.count < 13{
                resultPanelLabel.text! += number
            }
        }else{
            if number == "0"{
                resultPanelLabel.text! = number
                isEntered = false
            }
            else{
                resultPanelLabel.text! = number
                isEntered = true
            }
        }
    }
    //MARK: Two operands operations
    @IBAction func twoOperandsSignPresed(_ sender: UIButton) {
        firstOperand = currentInput
        isEntered = false
        isDouble = false
    }
    @IBAction func divideButtonPressed() {
        operationSing = .div
    }
    @IBAction func muitiplyButtonPressed() {
        operationSing = .mult
    }
    @IBAction func subtractButtonPressed() {
        operationSing = .sub
    }
    @IBAction func addButtonPressed() {
        operationSing = .add
    }
    private func operateWithTwoOperands(operate: (Double, Double)->Double){
        currentInput = operate(firstOperand, secondOperand)
        isEntered = false
    }
    
    //MARK: Single operations
    @IBAction func equalitySingPressed(_ sender: UIButton) {
        secondOperand = currentInput
        isDouble = false
        switch operationSing {
        case .add:
            operateWithTwoOperands {$0 + $1}
        case .sub:
            operateWithTwoOperands {$0 - $1}
        case .mult:
            operateWithTwoOperands {$0 * $1}
        case .div:
            if secondOperand == 0{
                evokeAlert(title: "Error", message: "Division by zero", style: .actionSheet)
                break
            }
            operateWithTwoOperands {$0 / $1}
        default:
            break
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        resultPanelLabel.text = "0"
        isEntered = false
        isDouble = false
        operationSing = .none
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput *= -1
    }
    @IBAction func persentButtonPressed(_ sender: UIButton) {
        currentInput /= 100
        isEntered = false
    }
    @IBAction func squareRootButtonPressed(_ sender: UIButton) {
        if currentInput < 0 {
            evokeAlert(title: "Error", message: "Number is less than zero", style: .alert)
        }
        else{
            currentInput = sqrt(currentInput)
        }
    }
    
    @IBAction func pointButtonPressed(_ sender: UIButton) {
        if isEntered && !isDouble{
            resultPanelLabel.text! += "."
            isDouble = true
        }else if !isEntered && !isDouble{
            resultPanelLabel.text! = "0.0"
            isDouble = true
        }
    }
    //MARK: alert
    func evokeAlert(title: String, message: String, style: UIAlertController.Style){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "ok", style: .default) { (action) in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

