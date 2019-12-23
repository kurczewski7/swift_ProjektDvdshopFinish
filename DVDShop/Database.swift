//
//  Database.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 06.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit
import CoreData
// var exercises = [Filmsbase]()
class Database {
    // bufor wyjściowy tabeli danych Filmsbase
    var flimsbaseFull = [Filmsbase]()
    var personbase = [Personbase]()
    
    var zestawIcon: [Icon] = []
    var listaUlubionych: [Int] = []
    var totalPrice: Double = 0.0
    
    var isFilterOn: Bool = true
    var isAscending: Bool = true
    var filmsbaseFilter: [Int]=[50,50,50,50,1,1,1,1,0,0]
    var liczbaRekordow: (accesableRecords: Int, allRecords:Int)=(0,0)
    var managedContext: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Filmsbase> = Filmsbase.fetchRequest()
    var feachPersonRequest: NSFetchRequest<Personbase> = Personbase.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
    var filmCount: Int
    {
        get { return isFilterOn ? filmsbaseFilter.count: flimsbaseFull.count }
        
    }
    
    init(){
        let personRek: PersonRekord
        print("Ilość rekordów,  allRecords=\(policzRecords().allRecords),accesableRecords=\(policzRecords().accesableRecords)")
        if(policzRecords().allRecords==0) && policzRecords().accesableRecords==0
        {
            print("Dodanie rekordów,  allRecords=\(policzRecords().allRecords),accesableRecords=\(policzRecords().accesableRecords)")
        }
        loadData()
        
        // fill person rekord
        personRek.firstName="Jan "
        personRek.lastName="Nowak"
        personRek.postCode="00-950"
        personRek.cityName="Warszawa"
        personRek.streetName="Mazowiecka"
        personRek.buildingNumer="12A"
        personRek.flatNumber=55
        loadPersonData()
        addOneRecordPerson(person: personRek)
       
        
         fillLikeList()
    }
    func loadData(){
        print("loadData  Start flimsbaseFull.count=\(flimsbaseFull.count)")
        do {            flimsbaseFull = try managedContext.fetch(fetchRequest)
        } catch {       print("Nie można załadować danych \(error.localizedDescription)")    }
        print("loadData End  personbase.count=\(personbase.count)")
    }
    func loadPersonData(){
        print("loadData  Start personbase.count=\(personbase.count)")
        do {            personbase = try managedContext.fetch(feachPersonRequest)
        } catch {       print("Nie można załadować danych \(error.localizedDescription)")    }
        print("loadData End  flimsbaseFull.count=\(flimsbaseFull.count)")
    }

    func createDatabaseRow(rek:  UserRekord, currentPictureName pictName: String )
    {
        let dbRow = Filmsbase(context: managedContext)
        dbRow.title = rek.title
        dbRow.price = kantor.stringToDouble(value: rek.price)
        dbRow.actors = rek.actors
        dbRow.filmDirector = rek.filmDirector
        dbRow.filmDescription = rek.description
        dbRow.type = rek.type
        dbRow.youtubeUrl = rek.youtubeUrl
        dbRow.filmId = rek.filmId
        dbRow.pictureName = pictName
        dbRow.isLiked = rek.isLiked
        print("rek.filmId:\(rek.filmId)")
        
        let image = rek.filmImage
        let imgData = image.jpegData(compressionQuality: 1)
        dbRow.filmImage=imgData! as NSData as Data
        saveDatabase()
    }
    
    func saveDatabase(){
        do { try self.managedContext.save()
            print("-----Dane zapisano-----")
        } catch {   print("!!!!!!    Nie mogę zapisać danych \(error.localizedDescription)")  }
    }
    
    func addDataToBase()
    {
        var currentFilm: UserRekord
        var currentPictureName: String = ""
        
        for i in 0..<setup.obrazki.count
        {
            let dane = filmList.give(row: i)            
            currentFilm.title           = dane.title
            currentFilm.actors          = dane.actors
            currentFilm.description     = dane.description
            currentFilm.filmDirector    = dane.filmDirector
            currentFilm.filmId          = dane.filmId
            currentFilm.filmImage       = dane.filmImage
            currentFilm.isLiked         = dane.isLiked
            currentFilm.price           = dane.price
            currentFilm.type            = dane.type
            currentFilm.youtubeUrl      = dane.youtubeUrl    //"WyHv2WqkPCQ"
            currentPictureName = filmList.giveCurrentPictureName(row: i)
        
            print("i=\(i),tytul=\(currentFilm.title),\(setup.tytuly[i])")
            createDatabaseRow(rek: currentFilm, currentPictureName: currentPictureName)
        }
    }
    
    func addOneRecordPerson(person rek: PersonRekord) {
        if personbase.count < 1 {
            let dbRow = Personbase(context: managedContext)
            dbRow.firstName     = rek.firstName
            dbRow.lastName      = rek.lastName
            dbRow.postCode      = rek.postCode
            dbRow.cityName      = rek.cityName
            dbRow.streetName    = rek.streetName
            dbRow.buildingNumer = rek.buildingNumer
            dbRow.flatNumber    = Int16(rek.flatNumber)
            saveDatabase()
        }
    }
    
    func changePerson(person data: PersonRekord){
        if( personbase.count)>0 {
            personbase[0].firstName     = data.firstName
            personbase[0].lastName      = data.lastName
            personbase[0].postCode      = data.postCode
            personbase[0].cityName      = data.cityName
            personbase[0].streetName    = data.streetName
            personbase[0].buildingNumer = data.buildingNumer
            personbase[0].flatNumber    = Int16(data.flatNumber)
        }
        saveDatabase()
    }
    
    func addDataToBaseFromWeb(dvds: [Dvd])
    {
        var currentFilm: UserRekord
        var currentPictureName: String = ""
        
        for i in 0..<setup.obrazki.count
        {
            if dvds.count>0 {
            currentFilm.title           = dvds[i].title
            currentFilm.actors          = dvds[i].actors
            currentFilm.description     = dvds[i].filmDescription
            currentFilm.filmDirector    = dvds[i].filmDirector
            currentFilm.filmId          = dvds[i].filmId
            currentFilm.filmImage       = UIImage(data: dvds[i].filmImageData!)!
            currentFilm.isLiked         = dvds[i].isLiked
            currentFilm.price           = dvds[i].price
            currentFilm.type            = dvds[i].type
            currentFilm.youtubeUrl      = dvds[i].youtubeUrl
            currentPictureName          = dvds[i].filmImageName
            
            print("i=\(i),tytul=\(currentFilm.title),\(setup.tytuly[i])")
            createDatabaseRow(rek: currentFilm, currentPictureName: currentPictureName)
            }
        }
    }
    
    func policzRecords() -> (accesableRecords: Int, allRecords: Int)
    {
        let accesableRecords = Filmsbase.accessibilityElementCount()
        print("Liczba dostępnych rekordów w bazie \(accesableRecords)")
        let allRecords = ( isFilterOn ? filmsbaseFilter.count: flimsbaseFull.count)
        print("Liczba wszystkich rekordów w bazie \(allRecords) flimsbaseFull.count=\(flimsbaseFull.count)")
        liczbaRekordow.allRecords=allRecords
        liczbaRekordow.accesableRecords=accesableRecords
        return (accesableRecords: accesableRecords, allRecords:allRecords)
    }
    
    func deleteTableBase()
    {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do { try managedContext.execute(deleteRequest) }
        catch { print("Nie można zapisać danych \(error.localizedDescription)")}
    }
    func setupDataFromAssets()    {
        let liczba=policzRecords()
        if liczba.allRecords == 0 {
            addDataToBase()        }
    }
    func setupDataFromInternet()
    {
        // funkcja rozwojowa
    }
    func getFilm(row: Int) -> Filmsbase{
         return  flimsbaseFull[row]
    }
    func fetchFilmbase(){
        
    }
    func fillFilterData(field: TypeFilterFields, seekValue: String) -> [Int] {
        var newFiltrList: [Int]=[]
    print("fillFilterData  flimsbaseFull.count=\(flimsbaseFull.count)")
        
       
        let start=0
        let end=flimsbaseFull.count
        var pos=0
        filmsbaseFilter.removeAll()
        
        for i in start..<end {
            pos = isAscending ? i : end-i-1
            if checkFilm(currentFilm: flimsbaseFull[pos], field: field, seekValue: seekValue) {
                 newFiltrList.append(pos)
            }
        }
        
        
        for i in 0..<filmsbaseFilter.count {
            print("\(i)  \(filmsbaseFilter[i])  \(flimsbaseFull[filmsbaseFilter[i]].title ?? "brak")  \(flimsbaseFull[filmsbaseFilter[i]].type ?? "brak")  \(flimsbaseFull[filmsbaseFilter[i]].actors ?? "brak")")
        }
        return newFiltrList
    }

    func getPhisicalRow(row: Int, onFilter: Bool = false) -> Int{
        return onFilter ? filmsbaseFilter[row] : row
    }
    func getImageDataFromDb(phisicalRow: Int) -> Data {
        return flimsbaseFull[phisicalRow].filmImage! as Data
    }
    
    func getUIImageFromDb(cuurrentPhoto: NSData) -> UIImage {
        return UIImage(data: cuurrentPhoto as Data)!
    }
    
    func checkFilm(currentFilm: Filmsbase, field: TypeFilterFields, seekValue: String) -> Bool{
        var warunek:Bool = false
        switch field {
            case .tytul  : warunek = kantor.isInString(currentFilm.title!,  seekValue: seekValue)
            case .aktorzy: warunek = kantor.isInString(currentFilm.actors!, seekValue: seekValue)
            case .gatunek: warunek = kantor.isInString(currentFilm.type!,   seekValue: seekValue)
            case .cenaDo : warunek = currentFilm.price <= kantor.stringToDouble(value: seekValue)
        }
        return  warunek
    }
    func checkDatabaseStatus(){
        loadData()
    
        print("------------------")
        print("|                 |")
        print("| Rekordów:\(flimsbaseFull.count)")
        print("|                 |")
        print("-------------------")
        if flimsbaseFull.count==0{
           addDataToBase()
           loadData()
        }
        if flimsbaseFull.count > setup.obrazki.count {
            deleteTableBase()
            addDataToBase()
            loadData()
        }
    }
    func setCheckRecord(phisicalRow row: Int, value v: Bool){
        if row < flimsbaseFull.count{
            flimsbaseFull[row].isLiked = v
        }
    
    }
    func fillLikeList() {
       var likedList: [Int] = []
       var totalPrice: Double = 0.0
       for i in 0..<flimsbaseFull.count {
            if(flimsbaseFull[i].isLiked){
               likedList.append(i)
               totalPrice += flimsbaseFull[i].price
            }
         }
         listaUlubionych=likedList
         self.totalPrice=totalPrice
        }
    
    func fillIkonList() {
        var ikonList: [Icon] = []
        for i in 0..<flimsbaseFull.count {
            if(flimsbaseFull[i].isLiked){
                ikonList.append(Icon(name: flimsbaseFull[i].pictureName!, title: flimsbaseFull[i].title!, price: flimsbaseFull[i].price, isFeatured: true))
            }
        }
        zestawIcon = ikonList
    }
    
    func refreshTotalPrice(){
        var totalPrice: Double = 0.0
        for i in 0..<flimsbaseFull.count {
            if(flimsbaseFull[i].isLiked){
                totalPrice += flimsbaseFull[i].price
            }
        }
        self.totalPrice=totalPrice
        kantor.setTotalPrice(totalPrice: self.totalPrice)
    }

//------------------------
    func setFilter(field: TypeFilterFields, seekValue: String){
    }

    func feachExercises(){
        let fetchRequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Filmsbase")
        let sortDescriptor=NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors=[sortDescriptor]
    }
}
    
