import Foundation
import MapboxMaps
import SwiftUI
import Capacitor
import CoreLocation

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorMapboxPlugin)
public class CapacitorMapboxPlugin: CAPPlugin, CAPBridgedPlugin {
    
    private var mapCanvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    
    public static func jsName() -> String! {
        return "CapacitorMapbox"
    }
    
    public static func pluginMethods() -> [Any]! {
        return [
            CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise) as Any,
            CAPPluginMethod(name: "buildMap", returnType: CAPPluginReturnPromise) as Any
        ]
    }
    
    public static func pluginId() -> String! {
        return "CapacitorMapboxPlugin"
    }
    
    public static func getMethod(_ methodName: String!) -> CAPPluginMethod! {
        switch methodName {
        case "echo":
            return CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
            break
        case "buildMap":
            return CAPPluginMethod(name: "buildMap", returnType: CAPPluginReturnPromise)
            break
        default:
            return CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
        }
    }
    
    public let identifier = "CapacitorMapboxPlugin"
    public let jsName = "CapacitorMapbox"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "buildMap", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = CapacitorMapbox()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func buildMap(_ call: CAPPluginCall) {
        DispatchQueue.main.async{
            let mainView = self.bridge?.viewController?.view
            
            let screenSize: CGRect = UIScreen.main.bounds
            //let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width - 10, height: 10))
            mainView!.addSubview(self.mapCanvas)
            NSLayoutConstraint.activate([
              //  self.mapCanvas.centerXAnchor.constraint(equalTo: mainView!.centerXAnchor),
              //  self.mapCanvas.centerYAnchor.constraint(equalTo: mainView!.centerYAnchor),
                self.mapCanvas.widthAnchor.constraint(equalToConstant: mainView!.bounds.width * 1),
                self.mapCanvas.heightAnchor.constraint(equalToConstant: mainView!.bounds.height * 0.7),
            ])
            let mapView = MapView(frame: self.mapCanvas.bounds)
            let cameraOptions = CameraOptions(center:
                CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
                zoom: 2, bearing: 0, pitch: 0)
            mapView.mapboxMap.setCamera(to: cameraOptions)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.mapCanvas.addSubview(mapView)
            
            call.resolve([
                "value": mapView
            ])
        }
    }
}
