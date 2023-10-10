class AddressModel: Codable {
    
    var type: String
    var latitude: Double
    var longitude: Double
    var title: String
    var description: String
    var buildingNumber: String
    var apartmentNumber: String
    var floor: String
    var district: String
    
    // Varsayılan başlatıcı
    init() {
        self.type = AddressTypes.home.rawValue
        self.latitude = 0.0
        self.longitude = 0.0
        self.title = ""
        self.description = ""
        self.buildingNumber = ""
        self.apartmentNumber = ""
        self.floor = ""
        self.district = ""
    }
    
    func getAllData() -> [String: Any] {
        return  [
            "type": type,
            "latitude": latitude,
            "longitude": longitude,
            "title": title,
            "description": description,
            "buildingNumber": buildingNumber,
            "apartmentNumber": apartmentNumber,
            "floor": floor,
            "district": district
        ]
    }
}
