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
        print("ConversionViewController loaded its view.")
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //SILVER Challenge (Night Mode)
        // code credit: https://forums.bignerdranch.com/t/heres-my-silver-challenge-solution/11495
        let currentHour = Calendar.current.component(.hour, from: Date())
        print(currentHour)
        if currentHour > 19 || currentHour < 6 {
            //Change the background color to a darker color
            view.backgroundColor = UIColor.darkGray
        } else {
            //Change the color light again
            view.backgroundColor = UIColor.init(red: 245.0 / 255, green: 244.0 / 255, blue: 241.0 / 255, alpha: 1.0)
        }
    }
    
    
    //MARK: Actions
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
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
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        print("Current text: \(String(describing: textField.text))")
        print("Replacement text: \(string)")
        print("Index: \(range.location)")
        print("DecimalSeparator: \(decimalSeparator)")
        
        // Chapter 4 BRONZE CHALLENGE, also works internationally with different number formats!
        var proposedInputString: String = textField.text!

        proposedInputString.insert(contentsOf: string.characters,
                                at: proposedInputString.index(proposedInputString.startIndex, offsetBy: range.location))
        
        let proposedNumber = numberFormatter.number(from: proposedInputString)
        
        if proposedNumber == nil, string != "", proposedInputString != decimalSeparator,
            proposedInputString != "-", proposedInputString != "-\(decimalSeparator)" {
            return false
        } else {
            return true
        }
        
//        // ORIGINAL SOLUTION IN BOOK (including international number formatting from Chapter 7)
//        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
//        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
//        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
//            return false
//        } else {
//            return true
//        }
    }
}
