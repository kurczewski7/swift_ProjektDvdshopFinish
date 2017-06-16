//
//  AdresatViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 07.06.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class AdresatViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var postCodeTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var buildingNoTextField: UITextField!
    @IBOutlet var flatNoTextField: UITextField!
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        saveChanges()
    }
    
    @IBAction func saveChangesBarButton(_ sender: UIBarButtonItem) {
        saveChanges()
    }
    func saveChanges()
    {
        let rec: PersonRekord
        rec.firstName = firstNameTextField.text!
        rec.lastName = lastNameTextField.text!
        rec.postCode = postCodeTextField.text!
        rec.cityName = cityTextField.text!
        rec.streetName = streetTextField.text!
        rec.buildingNumer = buildingNoTextField.text!
        rec.flatNumber = Int(flatNoTextField.text  ?? "0")!
        database.changePerson(person: rec)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if database.personbase.count>0 {
            let rec=database.personbase[0]
            firstNameTextField.text=rec.firstName
            lastNameTextField.text=rec.lastName
            postCodeTextField.text=rec.postCode
            cityTextField.text=rec.cityName
            streetTextField.text=rec.streetName
            buildingNoTextField.text=rec.buildingNumer
            flatNoTextField.text=kantor.intToString(Int(rec.flatNumber))
            
            self.flatNoTextField.delegate=self
        }

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField:  UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
