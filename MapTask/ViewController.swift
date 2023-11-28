import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestAlwaysAuthorization()
        mapView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            if startLocation == nil {
                // Set start location on first tap
                startLocation = location
                addAnnotation(at: coordinate, title: "Start", subtitle: nil)
            } else if endLocation == nil {
                // Set end location on second tap
                endLocation = location
                addAnnotation(at: coordinate, title: "End", subtitle: nil)
                
                // Calculate and show distance
                if let start = startLocation, let end = endLocation {
                    let distance = start.distance(from: end)
                    showAlert(with: "Distance: \(distance) meters")
                }
            }
        }
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D, title: String, subtitle: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.askToChangeStartPoint()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func askToChangeStartPoint() {
        let alert = UIAlertController(title: "Change Start Point", message: "Do you want to change the Start Point?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // Handle changing start point logic here
            self.resetLocations()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func resetLocations() {
        startLocation = nil
        endLocation = nil
        mapView.removeAnnotations(mapView.annotations)
    }
}
