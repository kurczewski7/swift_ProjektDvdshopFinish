//
//  ObliczViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 02.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class ObliczViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var naleznoscLabel: UILabel!
    @IBOutlet var walutySegment: UISegmentedControl!
    @IBOutlet var wartoscWalucieLabel: UILabel!
    @IBOutlet var kursLabel: UILabel!
    @IBOutlet var bankiPickerView: UIPickerView!
    @IBOutlet var numerTransakcjiLabel: UILabel! {
        didSet {
            kantor.setTransactionId()
            numerTransakcjiLabel.text="Transakcja: \(kantor.giveTransactionNumberTxt())"
        }
    }
    @IBOutlet var numerKontaLabel: UILabel! {
        didSet {
            numerKontaLabel.text=kantor.numerKonta
        }
    }
    
    @IBAction func zmianaWalutySegment(sender: UISegmentedControl) {
        wartoscWalucieLabel.text = kantor.giveValuteText(country: walutySegment.selectedSegmentIndex)
        kursLabel.text=kantor.giveKursText(country: walutySegment.selectedSegmentIndex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        kantor.policz(selectedDvd: database.zestawIcon)
        bankiPickerView.selectRow(2, inComponent: 0, animated: true)
        naleznoscLabel.text = kantor.giveValuteText(country: 0)  //String.init(format: "%7.2f zł", wynik)
        wartoscWalucieLabel.text = kantor.giveValuteText(country: 0)  //String.init(format: "%7.2f zł", wynik)
        
        kantor.setCurrencyRate(dolar: server.valuteExchange["USD"]!, euro: server.valuteExchange["EUR"]!)
        kantor.setDateOfRate(date: server.currentDay)
        kursLabel.text=kantor.giveKursText(country: 0)
        
        // Do any additional setup after loading the view.
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("----- prepare  ObliczViewController ------")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showBill" {
                let destinatonController = segue.destination as! BillViewController
            
                destinatonController.tranzactionNoTmp = kantor.giveTransactionNumberTxt()
                destinatonController.totalPriceTmp = naleznoscLabel.text!
                destinatonController.totalValuteTmp = wartoscWalucieLabel.text!
                destinatonController.isValute=walutySegment.selectedSegmentIndex != 0
            
            destinatonController.userTmp.fullName       = "Jan Matejko"
            destinatonController.userTmp.codeAndCity    = "00-950 Warszawa"
            destinatonController.userTmp.streetNo       = "Wrocławska 12 m 53"
            if  database.personbase.count>0 {
                destinatonController.userTmp.fullName    = database.personbase[0].firstName!+" "+database.personbase[0].lastName!
                destinatonController.userTmp.codeAndCity = database.personbase[0].postCode!+" "+database.personbase[0].cityName!
                destinatonController.userTmp.streetNo    = database.personbase[0].streetName!+" "+database.personbase[0].buildingNumer!+" "
                destinatonController.userTmp.streetNo   += (database.personbase[0].flatNumber==0) ? " " : "m "+String(database.personbase[0].flatNumber)
            }
        }
    }
    
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
    }
    // MARK: Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kantor.giveBankCount()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var allCodes=[String](kantor.urlBanku)
        //var kode=allCodes[row]
        return kantor.giveNameBank(nrBanku: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        kantor.numerBanku=row
    }

}
