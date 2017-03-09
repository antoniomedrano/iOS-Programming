//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Antonio Medrano on 3/6/17.
//  Copyright © 2017 Antonio Medrano. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    // var varName {} is a computed variable or computed property. It doesn't hold an explicit value, instead it calculates it each time its value is called
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
    }
    
    
    //MARK: Actions
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        print("Current text: \(textField.text)")
        print("Replacement text: \(string)")
        print("Index: \(range.location)")
        
        // SECOND TRY AT BRONZE CHALLENGE, this one works great!
        var checkValidString: String = String(textField.text!)

        checkValidString.insert(contentsOf: string.characters, at: checkValidString.index(checkValidString.startIndex, offsetBy: range.location))
        
        let checkValidDouble = Double(checkValidString)
        
        if checkValidDouble == nil, checkValidString != ".", checkValidString != "-", checkValidString != "-.",
            string != "", string != "+", string != "+." {
            return false
        } else {
            return true
        }

//        // FIRST TRY AT BRONZE CHALLENGE, works as long as the cursor is always at the far right
//        let checkValidString = String(textField.text! + string)
//        let checkValidDouble = Double(checkValidString!)
//
//        if checkValidDouble == nil, checkValidString != ".", checkValidString != "-", checkValidString != "-.", string != "" {
//            return false
//        } else {
//            return true
//        }
        
//        // ORIGINAL SOLUTION IN BOOK
//        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
//        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
//            return false
//        } else {
//            return true
//        }
    }
}
