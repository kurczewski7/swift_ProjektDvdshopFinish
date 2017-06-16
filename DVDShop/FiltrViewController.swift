//
//  FiltrViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 08.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

var database=Database()
class FiltrViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var clickCount = 0
    // MARK: Outlets
    
    @IBAction func prestLogGesture(_ sender: Any) {
        clickCount += 1        
        if clickCount > 3 {
          print("UWAGA","Włączono tryb Administratora")
          startAdminModeButton.isUserInteractionEnabled = true
          startAdminModeButton.isHidden =  false
        }
    }
    
    @IBOutlet var presetLongPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var fleldSegmentControll: UISegmentedControl!
    @IBOutlet var typePickerData: UIPickerView!
    @IBOutlet var findValueTextField: UITextField!    
    @IBOutlet var startAdminModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("----- FiltrViewController ------")
        database.checkDatabaseStatus()
        database.loadData()
        database.setupDataFromAssets()
        typePickerData.selectRow(4, inComponent: 0, animated: true)
        findValueTextField.text = TypeOfFilm.sciencefiction.rawValue
        typePickerData.isUserInteractionEnabled=true
        findValueTextField.isUserInteractionEnabled=true
        
        startAdminModeButton.isUserInteractionEnabled = false
        startAdminModeButton.isHidden = true
        
        // Do any additional setup after loading the view.
        
        // Set return key to hide keyboard
        self.findValueTextField.delegate=self
        
    }
    // MARK: Action functions
    @IBAction func fieldSegmentAction(_ sender: UISegmentedControl) {
        findValueTextField.keyboardType = .namePhonePad
        findValueTextField.text=""
        typePickerData.isUserInteractionEnabled=false
        findValueTextField.isUserInteractionEnabled=true
        findValueTextField.returnKeyType = .done
        print("Selected segment \(fleldSegmentControll.selectedSegmentIndex)")
        findValueTextField.endEditing(false)
        switch fleldSegmentControll.selectedSegmentIndex
        {
            case 0: findValueTextField.text = typeOfFilm[typePickerData.selectedRow(inComponent: 0)].rawValue
                    findValueTextField.isUserInteractionEnabled=false
                    findValueTextField.placeholder = ""
                    typePickerData.isUserInteractionEnabled=true
                    typePickerData.isHidden=false
                    findValueTextField.isUserInteractionEnabled=true
            case 1: findValueTextField.placeholder="Wpisz szukany tytuł"
                    typePickerData.isHidden=true
            case 2: findValueTextField.placeholder="Wpisz szukanego aktora"
                    typePickerData.isHidden=true
            case 3: findValueTextField.placeholder="Wpisz maksymalną cenę"
                    findValueTextField.keyboardType = .decimalPad
                    typePickerData.isHidden=true
            
            default: findValueTextField.placeholder=""
        }
    }
    func textFieldShouldReturn(_ textField:  UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Picker View --------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfFilm.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return  typeOfFilm[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            findValueTextField.text=typeOfFilm[row].rawValue
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var  fieldType: TypeFilterFields
        if segue.identifier=="showSeek" {
            let destinatonController = segue.destination as! FindTableViewController
            
            switch fleldSegmentControll.selectedSegmentIndex {
                case 0: fieldType =  .gatunek
                case 1: fieldType =  .tytul
                case 2: fieldType =  .aktorzy
                case 3: fieldType =   .cenaDo
                default: fieldType = .tytul
            }
            destinatonController.fieldTypeTmp = fieldType
            destinatonController.fieldNameTmp=""
            destinatonController.seekValueTmp = findValueTextField.text!
            print("segue showSeek)")
        }
    }
}
