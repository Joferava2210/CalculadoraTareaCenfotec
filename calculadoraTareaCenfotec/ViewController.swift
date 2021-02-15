//
//  ViewController.swift
//  calculadoraTareaCenfotec
//
//  Created by Felipe Ramirez Vargas on 10/2/21.
//  Copyright © 2021 com.framirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultadoLabel: UILabel!
    @IBOutlet var numero0: UIButton!
    @IBOutlet var numero1: UIButton!
    @IBOutlet var numero2: UIButton!
    @IBOutlet var numero3: UIButton!
    @IBOutlet var numero4: UIButton!
    @IBOutlet var numero5: UIButton!
    @IBOutlet var numero6: UIButton!
    @IBOutlet var numero7: UIButton!
    @IBOutlet var numero8: UIButton!
    @IBOutlet var numero9: UIButton!
    @IBOutlet var botonAC: UIButton!
    @IBOutlet var botonMasMenos: UIButton!
    @IBOutlet var botonPorcentaje: UIButton!
    @IBOutlet var botonResultado: UIButton!
    @IBOutlet var botonSuma: UIButton!
    @IBOutlet var botonResta: UIButton!
    @IBOutlet var botonMultiplicacion: UIButton!
    @IBOutlet var botonDivision: UIButton!
    @IBOutlet var botonDecimal: UIButton!
    
    private var total: Double = 0
    private var temporal: Double = 0
    private var estaRealizandoOperacion = false
    private var decimal = false
    private var operacion: TipoOperacion = .ninguno
    
    private let decimalSeparator = Locale.current.decimalSeparator!
    private let longitudMaxima = 9
    private let totalAGuardar = "total"
    
    //Begin Credits to Github autor
    private enum TipoOperacion {
        case ninguno, suma, resta, multiplicacion, division, porcentaje
    }
    
    private let formateador: NumberFormatter = {
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
    
    private let formateadorTotal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    private let formateadorAMostrar: NumberFormatter = {
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
    
    private let formateadorCientifico: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    //End Credits to GitHub Autor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        botonDecimal.setTitle(decimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: totalAGuardar)
        
        mostrarResultado()
    }
    
    
    @IBAction func botonDecimalAction(_ sender: UIButton) {
        let temp = formateadorTotal.string(from: NSNumber(value: temporal))!
        if resultadoLabel.text?.contains(decimalSeparator) ?? false || (!estaRealizandoOperacion && temp.count >= longitudMaxima) {
            return
        }
        resultadoLabel.text = resultadoLabel.text! + decimalSeparator
        decimal = true
    }
    
    @IBAction func botonMasMenosAction(_ sender: UIButton) {
        temporal = temporal * (-1)
        resultadoLabel.text = formateadorAMostrar.string(from: NSNumber(value: temporal))
    }
    
    @IBAction func botonPorcentajeAction(_ sender: UIButton) {
        if operacion != .porcentaje {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .porcentaje
        mostrarResultado()
    }
    
    @IBAction func botonDivisionAction(_ sender: UIButton) {
        if operacion != .ninguno {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .division
    }
    
    @IBAction func botonMultiplicacionAction(_ sender: UIButton) {
        if operacion != .ninguno {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .multiplicacion
    }
    
    @IBAction func botonRestaAction(_ sender: UIButton) {
        if operacion != .ninguno {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .resta
    }
    
    @IBAction func botonSumaAction(_ sender: UIButton) {
        if operacion != .ninguno {
            mostrarResultado()
        }
        estaRealizandoOperacion = true
        operacion = .suma
    }
    
    @IBAction func botonResultadoAction(_ sender: UIButton) {
        mostrarResultado()
    }
    
    @IBAction func botonACAction(_ sender: UIButton) {
        limpiar()
    }
    
    @IBAction func botonNumeroAction(_ sender: UIButton) {
        botonAC.setTitle("C", for: .normal)
        var temp = formateadorTotal.string(from: NSNumber(value: temporal))!
        if !estaRealizandoOperacion && temp.count >= longitudMaxima {
            return
        }
        
        temp = formateadorTotal.string(from: NSNumber(value: temporal))!
        
        if estaRealizandoOperacion {
            total = total == 0 ? temporal : total
            resultadoLabel.text = ""
            temp = ""
            estaRealizandoOperacion = false
        }
        
        if decimal {
            temp = "\(temp)\(decimalSeparator)"
            decimal = false
        }
        let numero = sender.tag
        temporal = Double(temp + String(numero))!
        resultadoLabel.text = formateadorAMostrar.string(from: NSNumber(value: temporal))
    }
    
    private func limpiar() {
        if operacion == .ninguno {
            total = 0
        }
        operacion = .ninguno
        botonAC.setTitle("AC", for: .normal)
        if temporal != 0 {
            temporal = 0
            resultadoLabel.text = "0"
        } else {
            total = 0
            mostrarResultado()
        }
    }
    
    private func mostrarResultado(){
        switch operacion {
        case .ninguno:
            break
        case .suma:
            total = total + temporal
            break
        case .resta:
            total = total - temporal
            break
        case .multiplicacion:
            total = total * temporal
            break
        case .division:
            total = total / temporal
            break
        case .porcentaje:
            temporal = temporal / 100
            total = temporal
            break
        }
        
        if let totalTemp = formateadorTotal.string(from: NSNumber(value: total)), totalTemp.count > longitudMaxima {
            resultadoLabel.text = formateadorCientifico.string(from: NSNumber(value: total))
        } else {
            resultadoLabel.text = formateadorAMostrar.string(from: NSNumber(value: total))
        }
        
        operacion = .ninguno
                
        UserDefaults.standard.set(total, forKey: totalAGuardar)
        
    }
    
        

}

