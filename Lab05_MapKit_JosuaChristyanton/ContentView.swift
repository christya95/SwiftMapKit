//
//  ContentView.swift
//  Lab05_MapKit_JosuaChristyanton
//
//  Created by Josua Christyanton on 2022-10-18.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View
{
    // properties
    @StateObject var locationManager = LocationManager()
    @State var pins: [MKAnnotation] = []
    @State var address = ""
    
    var body: some View
    {
        VStack {
            HStack {
                TextField("Enter address here!", text: $address)
                    .textFieldStyle(.roundedBorder)
                Button("Search")
                {
                    // do nothing if the address is empty
                    if address.isEmpty {
                        return
                    }
                    
                    // find location using forward geocoding
                    forwardGeocoding(address:address,
                                     completion:  {(location) in
                        if let location = location {
                            pins.removeAll()
                            
                            // move to the new location
                            let pin = MKPointAnnotation()
                            pin.coordinate = location.coordinate
                            pin.title = address
                            pins.append(pin)
                            locationManager.stopTracking()
                        }
                        else{
                            pins.removeAll()
                        }
                    })
                }
            }
        }.padding(8)
        MapView(locationManager: locationManager, annotations: pins) // not bi directional binding, so no $
    }
}

//=============================================================================
// convert address string to CLLocation
func forwardGeocoding(address: String,
                      completion: @escaping((CLLocation?) -> Void))
{
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
        if let error = error
        {
            print(error.localizedDescription)
            completion(nil) // pass nil location if failed
        }
        else
        {
            // pass the first location to the closure
            completion(placemarks?[0].location)
        }
    })
}



//=============================================================================
// convert CLLocation to address string
func reverseGeocoding(location: CLLocation,
                      completion: @escaping((CLPlacemark?) -> Void))
{
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
        if let error = error
        {
            print(error.localizedDescription)
            completion(nil) // pass null placemark
        }
        else
        {
            // pass the first placemark
            completion(placemarks?[0])
        }
    })
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
