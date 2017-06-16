//
//  Kantor.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 04.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit
class Kantor  {
    var zloty: Double = 1.0
    var dolarKurs: Double
    var euroKurs: Double
    
    var dayOfCurrencyRate="(2017-06-12)"
    var totalPriceInZloty: Double = 0.0
    var numerKonta="58 1240 1112 1111 0010 0944 9739"
    var nrTransakcji: String="201703041655001234"
    //                        zł,   usd,  eur
    var kursyWalut: [Double]=[1.0, 3.86, 4.21]
    var urlBanku: [String]=["https://www.payu.pl","https://www.paypal.com/pl/home","https://www.pekao24.pl","http://www.mbank.com.pl","https://aliorbank.pl","https://moj.raiffeisenpolbank.com"]
    var nazwaBanku: [String]=["PayU","PayPal", "PKO","mBank","Alior","Raiffeisen polbank"]
    var numerBanku: Int = 2

    init(){
        self.dolarKurs=kursyWalut[1]
        self.euroKurs=kursyWalut[2]
    }
    init(dolarKurs: Double, euroKurs: Double)
    {
        self.dolarKurs=dolarKurs
        self.euroKurs=euroKurs
    }
    func setTotalPrice(totalPrice: Double){
        self.totalPriceInZloty=totalPrice
    }
    func giveValuteText(country: Int) -> String
        
    {
        var wynik = ""
        switch country {
            case 0: wynik=String.init(format: "%7.2f zł", totalPriceInZloty)
            case 1: wynik=String.init(format: "%7.2f $",  totalPriceInZloty / dolarKurs)
            case 2: wynik=String.init(format: "%7.2f €",  totalPriceInZloty / euroKurs)
            default: wynik=""
        }
        return wynik
    }
    func giveTotalPriceZlotyText() -> String
    {
        return doubleToString(totalPriceInZloty)+"zł"
    }
    
    func giveKursText(country: Int) -> String {
        var wynik = ""
    switch country {
        case 0: wynik=self.dayOfCurrencyRate   //String.init(format: "Kurs %5.2f", 1.0)
        case 1: wynik=String.init(format: "Kurs %5.2f za $",  dolarKurs)
        case 2: wynik=String.init(format: "Kurs %5.2f za €",  euroKurs)
        default: wynik=""
    }
    return wynik
    }
    func giveUrlBank(nrBanku: Int) -> String
    {
        return urlBanku[nrBanku]
    }
    func giveNameBank(nrBanku: Int) -> String
    {
        return nazwaBanku[nrBanku]
    }
    func giveBankCount() -> Int
    {
        return urlBanku.count
    }
    func giveCurrentBank() -> Int {
        return numerBanku
    }
    func setTransactionId()
    {
        nrTransakcji=""
        let date=Date()
        let calendar=Calendar.current
        let year=calendar.component(.year, from: date)
        let month=calendar.component(.month, from: date)
        let day=calendar.component(.day, from: date)
        let hour=calendar.component(.hour, from: date)
        let minute=calendar.component(.minute, from: date)
        let secunde=calendar.component(.second, from: date)

        let randomValue=arc4random_uniform(999)
        nrTransakcji=String.init(format: "%4d%02d%02d%02d%02d%02d%04d", year,month,day, hour,minute,secunde, randomValue)
    }
    func giveTransactionNumberTxt( ) -> String
    {
        return "\(nrTransakcji)"
    }
    func giveRandomInt(max: Int) -> Int {
        let value = arc4random_uniform(UInt32(max))
        return Int(value)
    }
    func intToString(_ value: Int) -> String {
        return String.init(format: "%6d", value).trimmingCharacters(in: .whitespaces)
    }
    func doubleToString(_ value: Double) -> String {
        return String.init(format: "%6.2f", value).trimmingCharacters(in: .whitespaces)
    }
    func stringToDouble(value: String) -> Double {
        return Double(value.trimmingCharacters(in: .whitespaces))!    
    }
    func isInString(_ value: String, seekValue: String) -> Bool {
        return (value.lowercased().range(of: seekValue.lowercased()) != nil ) ? true : false
    }
    
    
    func policz(selectedDvd: [Icon])  {
        var suma: Double = 0.0
        for i in 0..<selectedDvd.count {
            if selectedDvd[i].isFeatured {
                suma+=selectedDvd[i].price
            }
        }
        totalPriceInZloty=suma
    }
    
    func setTotalPriceTexeditAtrybute(totalPrice textField: UITextField){
        database.refreshTotalPrice()
        textField.isEnabled=false
        textField.isUserInteractionEnabled=false
        textField.backgroundColor = UIColor.clear
        textField.text=giveTotalPriceZlotyText()
    }
    func setCurrencyRate(dolar: Double, euro: Double) {
        self.dolarKurs=(dolar > 1.0) ? dolar :  kursyWalut[1]
        self.euroKurs=(euro  > 1.0) ? euro  :  kursyWalut[2]
    }
    func setDateOfRate(date: String) {
        self.dayOfCurrencyRate = (date == "") ? "": " (NBP "+date+")"
    }


//      database.fillIkonList()
//      kantor.policz(selectedDvd: database.zestawIcon)
    

}

