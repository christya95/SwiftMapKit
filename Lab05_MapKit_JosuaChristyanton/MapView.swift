//
//  MapView.swift
//  Lab05_MapKit_JosuaChristyanton
//
//  Created by Josua Christyanton on 2022-10-18.
//

import SwiftUI
import MapKit
import CoreLocation

// wrapper to host MKMapView in SwiftUI
struct MapView: UIViewRepresentable
{
    // properties
    @ObservedObject var locationManager: LocationManager
    var annotations: [MKAnnotation]
    var spanKm = 1.0  // default region span in km
    
    // return instance of UIView
    func makeUIView(context: Context) -> MKMapView
    {
        let mapView = MKMapView()
        
        // configure the map
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        // set delegate
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    // update UIView
    func updateUIView(_ uiView: MKMapView, context: Context)
    {
        print("updateUIView")
        updateMap(uiView) //instance of current view is uiView
    }
    
    // create coordinator
    func makeCoordinator() -> MapViewCoordinator
    {
        return MapViewCoordinator(self)
    }
    
    func updateMap(_ uiView: MKMapView)
    {
        // display the current user location if userTracking is on
        if locationManager.userTracking
        {
            let coord = locationManager.location.coordinate
            let center = CLLocationCoordinate2D(latitude: coord.latitude,
                                                longitude: coord.longitude)
            let span = MKCoordinateSpan(latitudeDelta: spanKm/111.111,
                                        longitudeDelta: spanKm/111.111)
            let region = MKCoordinateRegion(center: center, span: span)
            uiView.setRegion(region, animated: true)
        }
        // display the pin annotations if exists
        else
        {
            uiView.removeAnnotations(uiView.annotations) // remove prev annotations
            for annotation in annotations
            {
                uiView.addAnnotation(annotation)
                uiView.setCenter(annotation.coordinate, animated: true)
            }
        }
    }
}


// coordinator (delegate) to communicate with SwiftUI
class MapViewCoordinator: NSObject, MKMapViewDelegate
{
    // properties
    let mapView: MapView
    
    init(_ mapView: MapView)
    {
        self.mapView = mapView
    }
    
    
    // delegates for MKMapViewDelegate
    // It is used to draw polyline overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        // if overlay is polyline, return MKPolylineRenderer
        if let polyline = overlay as? MKPolyline
        {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer(overlay:overlay)
    }
}

