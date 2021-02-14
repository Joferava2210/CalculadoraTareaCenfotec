//
//  ViewController.swift
//  calculadoraTareaCenfotec
//
//  Created by Felipe Ramirez Vargas on 10/2/21.
//  Copyright © 2021 com.framirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var button0: UIButton!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var buttonAC: UIButton!
    @IBOutlet var buttonPlusMinus: UIButton!
    @IBOutlet var buttonPercent: UIButton!
    @IBOutlet var buttonResult: UIButton!
    @IBOutlet var buttonAddition: UIButton!
    @IBOutlet var buttonSubtract: UIButton!
    @IBOutlet var buttonMultiplication: UIButton!
    @IBOutlet var buttonDivision: UIButton!
    @IBOutlet var buttonDecimal: UIButton!
    
    private var total: Double = 0
    private var temporal: Double = 0
    private var estaRealizandoOperacion = false
    private var decimal = false
    private var operacion: OperationType = .none
    
    private let decimalSeparator = Locale.current.decimalSeparator!
    private let longitudMaxima = 9
    private let totalAGuardar = "total"
    
    //Begin Credits to MouroDev
    private enum OperationType {
        case none, addiction, substraction, multiplication, division, percent
    }
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    //End Credits to MouroDev
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        buttonDecimal.setTitle(decimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: totalAGuardar)
        
        mostrarResultado()
    }
    
    
    @IBAction func buttonDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temporal))!
        if resultLabel.text?.contains(decimalSeparator) ?? false || (!estaRealizandoOperacion && currentTemp.count >= longitudMaxima) {
            return
        }
        resultLabel.text = resultLabel.text! + decimalSeparator
        decimal = true
        sender.shine()
    }
    
    @IBAction func buttonPlusMinusAction(_ sender: UIButton) {
        temporal = temporal * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporal))
        sender.shine()
    }
    
    @IBAction func buttonPercentAction(_ sender: UIButton) {
        if operacion != .percent {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .percent
        mostrarResultado()
        sender.shine()
    }
    
    @IBAction func buttonDivisionAction(_ sender: UIButton) {
        if operacion != .none {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .division
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func buttonMultiplicationAction(_ sender: UIButton) {
        if operacion != .none {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func buttonSubtractAction(_ sender: UIButton) {
        if operacion != .none {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .substraction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func buttonAdditionAction(_ sender: UIButton) {
        if operacion != .none {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .addiction
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func buttonResultAction(_ sender: UIButton) {
        mostrarResultado()
        sender.shine()
    }
    
    @IBAction func buttonACAction(_ sender: UIButton) {
        limpiar()
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        buttonAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temporal))!
        if !estaRealizandoOperacion && currentTemp.count >= longitudMaxima {
            return
        }
        
        currentTemp = auxTotalFormatter.string(from: NSNumber(value: temporal))!
        
        if estaRealizandoOperacion {
            total = total == 0 ? temporal : total
            resultLabel.text = ""
            currentTemp = ""
            estaRealizandoOperacion = false
        }
        
        if decimal {
            currentTemp = "\(currentTemp)\(decimalSeparator)"
            decimal = false
        }
        let number = sender.tag
        temporal = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporal))
                
        sender.shine()
    }
    
    private func limpiar() {
        if operacion == .none {
            total = 0
        }
        operacion = .none
        buttonAC.setTitle("AC", for: .normal)
        if temporal != 0 {
            temporal = 0
            resultLabel.text = "0"
        } else {
            total = 0
            mostrarResultado()
        }
    }
    
    private func mostrarResultado(){
        switch operacion {
        case .none:
            break
        case .addiction:
            total = total + temporal
            break
        case .substraction:
            total = total - temporal
            break
        case .multiplication:
            total = total * temporal
            break
        case .division:
            total = total / temporal
            break
        case .percent:
            temporal = temporal / 100
            total = temporal
            break
        }
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > longitudMaxima {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operacion = .none
                
        UserDefaults.standard.set(total, forKey: totalAGuardar)
        
        print("TOTAL: \(total)")
    }
    
        

}

