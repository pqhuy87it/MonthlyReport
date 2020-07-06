https://qiita.com/mshrwtnb/items/48fec048f55ad87121a7

struct Map {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }

    static func search(query: String, region: MKCoordinateRegion? = nil, completionHandler: @escaping (Result<[MKMapItem]>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        if let region = region {
            request.region = region
        }

        MKLocalSearch(request: request).start { (response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(response?.mapItems ?? []))
        }
    }
}

let coordinate = CLLocationCoordinate2DMake(35.6598051, 139.7036661) // 渋谷ヒカリエ
let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0) // 1km * 1km

Map.search(query: "コンビニ", region: region) { (result) in
    switch result {
    case .success(let mapItems):
        for map in mapItems {
            print("name: \(map.name ?? "no name")")
            print("coordinate: \(map.placemark.coordinate.latitude) \(map.placemark.coordinate.latitude)")
            print("address \(map.placemark.address)")
        }
    case .failure(let error):
        print("error \(error.localizedDescription)")
    }
}
