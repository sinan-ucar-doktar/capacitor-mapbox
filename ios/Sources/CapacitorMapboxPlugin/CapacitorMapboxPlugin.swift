import Capacitor
import CoreLocation
import Foundation
import MapboxMaps
import SwiftUI

/// Please read the Capacitor iOS Plugin Development Guide
/// here: https://capacitorjs.com/docs/plugins/ios
@objc(CapacitorMapboxPlugin)
public class CapacitorMapboxPlugin: CAPPlugin, CAPBridgedPlugin,
    UICollectionViewDelegate
{

    private var markerIcon =
        "iVBORw0KGgoAAAANSUhEUgAAACIAAAAjCAYAAADxG9hnAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAHaSURBVHgB7ZexTgJBGIQHY2EHlXaAjZ102JnwABY8AtY2voH4BpjYcxZWFmC0s+B6Ky1tBDsr7KQ7Z+XfsB7n3e4ehpjcl0z2Av/uzQ7/JgtQUFBQ8E+IoqgCHzhxQPWpFnKg5staU2rkOrkS/eSVOqXqDvNV/Si2Th+uyC6SUIt3Ugycye41n8ZzC65IpHqhG+opIaW+1LWj5d1PqDuZ+12f9r5Shhn1m7aoB+qRKlM16oDaTpgyo56pF+pNPjuiGtRxqVQK4GmkzWFATajr2Nc7VJPSp2EiZmdGjTJ+Is+7NDL+5VXYRAqcOKSZD8xTqGKxS8U7dY90ajIGaSYUG8jmQsZDuKPnXGUV2hjpUTqVMuypSv2YaYRZxZlGuIgyoXfUhD0NGc9tim0SUQyNxbcs6stYGAkt6u2MSLShmLBJRTfpbVaTOhkRdMQ2RnSTBrDE2oikMsY8lWpKqdmkQ6zaiGBzlHVvZB7ZPEYCLI5yUipmkwb4KyNylHUqjYQS5yb1MiL0ZNzD8lF2blJvI5JKiOWj7NWk3kYE8yjrVLyaNDfGRUhdfi6NC1EdHvgmotA738eiSUPXJs2N3E+nsXtpB+uAL+6ad1isi1gq7n8VVmymK2bqyMEXylp4/k0rr3MAAAAASUVORK5CYII="

    private var modalIsMinimized: Bool = false
    private var mainViewHeight: Double = 0
    private var mapCanvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    //    private var button: UIButton = {
    //        let button = UIButton(
    //            frame: CGRect(x: 30, y: 30, width: 30, height: 30))
    //        button.backgroundColor = UIColor.green
    //        button.setTitle("-", for: .normal)
    //        button.addTarget(
    //            self, action: #selector(buttonAction),
    //            for: .touchUpInside)
    //        return button
    //    }()

    private var minimizedConstraint: NSLayoutConstraint?
    private var fullScreenConstraint: NSLayoutConstraint?

    @objc func buttonAction(sender: UIButton!) {
        DispatchQueue.main.async {
            let heightFactor = self.modalIsMinimized ? 0.7 : 0.3
            let deactivateFactor = heightFactor == 0.3 ? 0.7 : 0.3
            print("heightFactor \(heightFactor)")
            let mainView = self.bridge?.viewController?.view
            if self.modalIsMinimized {
                self.minimizedConstraint!.isActive = false
                self.fullScreenConstraint!.isActive = true
            } else {
                self.minimizedConstraint!.isActive = true
                self.fullScreenConstraint!.isActive = false
            }
            //            self.mapCanvas.heightAnchor.constraint(
            //                equalToConstant: mainView!.bounds.height * deactivateFactor).isActive = false
            //            NSLayoutConstraint.deactivate([
            //
            //            ])
            //            self.mapCanvas.setNeedsUpdateConstraints()
            //            self.mapCanvas.layoutIfNeeded()
            //
            //            NSLayoutConstraint.activate([
            //                self.mapCanvas.heightAnchor.constraint(
            //                    equalToConstant: mainView!.bounds.height * heightFactor)
            //            ])
            //            self.mapCanvas.setNeedsUpdateConstraints()
            //            self.mapCanvas.layoutIfNeeded()

            self.modalIsMinimized = !self.modalIsMinimized
            sender.setTitle(self.modalIsMinimized ? "^" : "-", for: .normal)
        }
    }

    private var mapView: MapView?

    public static func jsName() -> String! {
        return "CapacitorMapbox"
    }

    public static func pluginMethods() -> [Any]! {
        return [
            CAPPluginMethod(
                name: "echo", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "buildMap", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "destroyMap", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "addPolygon", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "updatePolygon", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "addLineString", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "updateLineString", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "addMapListener", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "addOverlayImage", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "addOrUpdateMarker", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "flyTo", returnType: CAPPluginReturnPromise)
                as Any,
            CAPPluginMethod(
                name: "centerMapByBounds", returnType: CAPPluginReturnPromise)
                as Any,
        ]
    }

    public static func pluginId() -> String! {
        return "CapacitorMapboxPlugin"
    }

    public static func getMethod(_ methodName: String!) -> CAPPluginMethod! {
        switch methodName {
        case "echo":
            return CAPPluginMethod(
                name: "echo", returnType: CAPPluginReturnPromise)
            break
        case "buildMap":
            return CAPPluginMethod(
                name: "buildMap", returnType: CAPPluginReturnPromise)
            break
        case "destroyMap":
            return CAPPluginMethod(
                name: "destroyMap", returnType: CAPPluginReturnPromise)
            break
        case "addPolygon":
            return CAPPluginMethod(
                name: "addPolygon", returnType: CAPPluginReturnPromise)
            break
        case "updatePolygon":
            return CAPPluginMethod(
                name: "updatePolygon", returnType: CAPPluginReturnPromise)
            break
        case "addLineString":
            return CAPPluginMethod(
                name: "addLineString", returnType: CAPPluginReturnPromise)
            break
        case "updateLineString":
            return CAPPluginMethod(
                name: "updateLineString", returnType: CAPPluginReturnPromise)
            break
        case "addMapListener":
            return CAPPluginMethod(
                name: "addMapListener", returnType: CAPPluginReturnPromise)
            break
        case "addOverlayImage":
            return CAPPluginMethod(
                name: "addOverlayImage", returnType: CAPPluginReturnPromise)
            break
        case "addOrUpdateMarker":
            return CAPPluginMethod(
                name: "addOrUpdateMarker", returnType: CAPPluginReturnPromise)
            break
        case "flyTo":
            return CAPPluginMethod(
                name: "flyTo", returnType: CAPPluginReturnPromise)
            break
        case "centerMapByBounds":
            return CAPPluginMethod(
                name: "centerMapByBounds", returnType: CAPPluginReturnPromise)
            break

        default:
            return CAPPluginMethod(
                name: "echo", returnType: CAPPluginReturnPromise)
        }
    }

    public let identifier = "CapacitorMapboxPlugin"
    public let jsName = "CapacitorMapbox"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(
            name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "buildMap", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "destroyMap", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "addPolygon", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "updatePolygon", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "addLineString", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "updateLineString", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "addMapListener", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "addOverlayImage", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "addOrUpdateMarker", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "flyTo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(
            name: "centerMapByBounds", returnType: CAPPluginReturnPromise),
    ]
    private let implementation = CapacitorMapbox()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func clearViewBackground(view: UIView) {
        if view.subviews.count > 0 {
            view.subviews.forEach { subview in
                self.clearViewBackground(view: subview)
            }
        }
        view.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    //
    //    @objc func buildMapAsView(_ call: CAPPluginCall) {
    //        DispatchQueue.main.async {
    //            let mainView = self.bridge?.webView?.scrollView  // self.bridge?.viewController?.view
    //            self.clearViewBackground(view: mainView!)
    //            // mainView?.subviews.first?.backgroundColor = UIColor(white: 1, alpha: 0)
    //            //let screenSize: CGRect = UIScreen.main.bounds
    //            //let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
    //            //mainView!.addSubview(myView)
    //            //mainView!.sendSubviewToBack(myView)
    //            let mapView = MapView(frame: mainView!.bounds)
    //            let cameraOptions = CameraOptions(
    //                center:
    //                    CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
    //                zoom: 2, bearing: 0, pitch: 0)
    //            mapView.mapboxMap.setCamera(to: cameraOptions)
    //            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //
    //            //mainView!.addSubview(mapView)
    //            //.scrollView.sendSubviewToBack(customMapView.view)
    //            mainView!.addSubview(mapView)
    //            mainView!.sendSubviewToBack(mapView)
    //            call.resolve([
    //                "value": mapView
    //            ])
    //        }
    //    }

    @objc func buildMap(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let mainView = self.bridge?.viewController?.view
            self.mainViewHeight = mainView!.bounds.height
            self.modalIsMinimized = true
            //let screenSize: CGRect = UIScreen.main.bounds
            //let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width - 10, height: 10))
            mainView!.addSubview(self.mapCanvas)
            self.minimizedConstraint = self.mapCanvas.heightAnchor.constraint(
                equalToConstant: mainView!.bounds.height * 0.1)
            self.fullScreenConstraint = self.mapCanvas.heightAnchor.constraint(
                equalToConstant: mainView!.bounds.height * 0.7)
            self.minimizedConstraint!.isActive = true
            self.fullScreenConstraint!.isActive = false
            NSLayoutConstraint.activate([
                //  self.mapCanvas.centerXAnchor.constraint(equalTo: mainView!.centerXAnchor),
                //                self.mapCanvas.centerYAnchor.constraint(equalTo: mainView!.centerYAnchor),
                self.mapCanvas.widthAnchor.constraint(
                    equalToConstant: mainView!.bounds.width * 1),
                self.mapCanvas.bottomAnchor.constraint(
                    equalTo: mainView!.bottomAnchor),
            ])
            let rawZoomLevel = call.getFloat("zoom") ?? 12  // Float(0 as CGFloat)
            let zoomLevel = CGFloat(rawZoomLevel)
            let latitude = call.getDouble("latitude") ?? 0
            let longitude = call.getDouble("longitude") ?? 0
            self.mapView = MapView(frame: self.mapCanvas.bounds)
            let cameraOptions = CameraOptions(
                center: CLLocationCoordinate2D(
                    latitude: latitude, longitude: longitude), zoom: zoomLevel,
                bearing: 0, pitch: 0)
            self.mapView?.mapboxMap.setCamera(to: cameraOptions)
            self.mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.mapView?.ornaments.options.scaleBar.visibility = .hidden

            let button = UIButton(
                frame: CGRect(
                    x: (mainView?.bounds.width)! - 30, y: 0, width: 30,
                    height: 30))
            button.backgroundColor = UIColor.gray
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(self.modalIsMinimized ? "^" : "-", for: .normal)
            button.addTarget(
                self, action: #selector(self.buttonAction),
                for: .touchUpInside)

            self.mapCanvas.addSubview(self.mapView!)
            self.mapCanvas.insertSubview(button, aboveSubview: self.mapView!)

            do {
                //                let stringData = Data(base64Encoded: self.markerIcon)
                let uiImage = UIImage(named: "tractor-marker")  // UIImage(data: stringData!)
                //                else {
                //                          print("Error: couldn't create UIImage")
                //                          return
                //                      }
                try self.mapView?.mapboxMap.addImage(
                    uiImage!, id: "tractor_marker_image")
                let res = self.mapView?.mapboxMap.imageExists(
                    withId: "tractor_marker_image")
                //                print("image exist \(String(describing: res))")
            } catch let error {
                print("marker image add error")
                print(error.localizedDescription)
            }
            call.resolve([
                "status": true
            ])
        }
    }

    @objc func destroyMap(_ call: CAPPluginCall) {
        DispatchQueue.main.async {

            //            let mainView = self.bridge?.viewController?.view
            self.mapView?.removeFromSuperview()
            self.mapCanvas.removeFromSuperview()
            call.resolve(["status": true])
        }
    }

    @objc func addLineString(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let lineStringId = call.getString("lineStringId") ?? "lineStringId"
            let geojson = (call.getArray("geoJson") ?? []) as! [[Double]]
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {
                    var lineStringSource = GeoJSONSource(id: lineStringId)

                    //                var coordinates: Array<CLLocationCoordinate2D> = []
                    var wktStr = geojson.map { t in
                        return "\(t[0]) \(t[1])"
                    }.joined(separator: ", ")

                    var geometry = try Geometry(wkt: "LINESTRING (\(wktStr))")
                    var feature: Feature = Feature(geometry: geometry)
                    lineStringSource.data = .feature(feature)
                    var xxx: Source?
                    do {
                        xxx = try self.mapView?.mapboxMap.source(
                            withId: lineStringId)
                    } catch let error {
                        print("source bulunamadı \(lineStringId)")
                    }

                    if xxx != nil {
                        self.mapView?.mapboxMap.updateGeoJSONSource(
                            withId: lineStringId, data: lineStringSource.data!)
                    } else {
                        try self.mapView?.mapboxMap.addSource(lineStringSource)
                        var layer = LineLayer(
                            id: lineStringId, source: lineStringId)
                        layer.lineColor = .constant(
                            StyleColor.init(UIColor.white))
                        layer.lineWidth = .constant(5)
                        try self.mapView?.mapboxMap.addLayer(layer)
                    }
                    call.resolve(["status": true])
                } catch let error {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updateLineString(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let lineStringId = call.getString("lineStringId") ?? "lineStringId"
            let geojson = (call.getArray("geoJson") ?? []) as! [[Double]]
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {
                    var lineStringSource = GeoJSONSource(id: lineStringId)

                    var wktStr = geojson.map { t in
                        return "\(t[0]) \(t[1])"
                    }.joined(separator: ", ")

                    var geometry = try Geometry(wkt: "LINESTRING (\(wktStr))")
                    var feature: Feature = Feature(geometry: geometry)
                    lineStringSource.data = .feature(feature)
                    self.mapView?.mapboxMap.updateGeoJSONSource(
                        withId: lineStringId, data: lineStringSource.data!)
                    call.resolve(["status": true])
                    //                try self.mapView?.mapboxMap.addSource(lineStringSource)
                    //
                    //                var layer = LineLayer(id: lineStringId, source: lineStringId)
                    //                layer.lineColor = .constant(StyleColor.init(UIColor.white))
                    //                layer.lineWidth = .constant(5)
                    //                try self.mapView?.mapboxMap.addLayer(layer)
                } catch let error {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func addPolygon(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let polygonId = call.getString("polygonId") ?? "polygonId"
            let geojson = (call.getArray("geoJson") ?? []) as! [[[Double]]]
            let isErrorPolygon = call.getBool("isError", false)
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {
                    var polygonSource = GeoJSONSource(id: polygonId)

                    var wktStrArray: [String] = []
                    geojson.forEach { t in
                        var tempStr = t.map { j in
                            return "\(j[0]) \(j[1])"
                        }.joined(separator: ", ")
                        wktStrArray.append("((\(tempStr)))")
                    }
                    var wktStr =
                        "MULTIPOLYGON (\(wktStrArray.joined(separator: ", ")))"

                    var geometry = try Geometry(wkt: wktStr)
                    var feature: Feature = Feature(geometry: geometry)
                    polygonSource.data = .feature(feature)

                    var xxx: Source?
                    do {
                        xxx = try self.mapView?.mapboxMap.source(
                            withId: polygonId)
                    } catch let error {
                        print("source bulunamadı \(polygonId)")
                    }

                    if xxx != nil {

                        self.mapView?.mapboxMap.updateGeoJSONSource(
                            withId: polygonId, data: polygonSource.data!)
                    } else {
                        try self.mapView?.mapboxMap.addSource(polygonSource)
                        var layer = FillLayer(id: polygonId, source: polygonId)
                        if isErrorPolygon {
                            layer.fillColor = .constant(
                                StyleColor(
                                    red: 255, green: 0, blue: 0, alpha: 0.6)!
                            )
                            layer.fillOutlineColor = .constant(
                                StyleColor(
                                    red: 255, green: 0, blue: 0, alpha: 1)!)
                        } else {
                            layer.fillColor = .constant(
                                StyleColor(
                                    red: 142, green: 142, blue: 142, alpha: 0.6)!
                            )
                            layer.fillOutlineColor = .constant(
                                StyleColor(
                                    red: 142, green: 142, blue: 142, alpha: 1)!)
                        }
                        try self.mapView?.mapboxMap.addLayer(layer)
                    }
                    print("mapbox add polygon")
                    call.resolve(["status": true])
                } catch let error {
                    print(
                        "mapbox add polygon error \(error.localizedDescription)"
                    )
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updatePolygon(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let polygonId = call.getString("polygonId") ?? "polygonId"
            let geojson = (call.getArray("geoJson") ?? []) as! [[[Double]]]
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {
                    var polygonSource = GeoJSONSource(id: polygonId)

                    var wktStrArray: [String] = []
                    geojson.forEach { t in
                        var tempStr = t.map { j in
                            return "\(j[0]) \(j[1])"
                        }.joined(separator: ", ")
                        wktStrArray.append("(\(tempStr))")
                    }
                    var wktStr = wktStrArray.joined(separator: ", ")

                    var geometry = try Geometry(wkt: "POLYGON (\(wktStr))")
                    var feature: Feature = Feature(geometry: geometry)
                    polygonSource.data = .feature(feature)

                    self.mapView?.mapboxMap.updateGeoJSONSource(
                        withId: polygonId, data: polygonSource.data!)
                    call.resolve(["status": true])
                    //
                    //                try self.mapView?.mapboxMap.addSource(polygonSource)
                    //                var layer = FillLayer(id: polygonId, source: polygonId)
                    //                layer.fillColor = .constant(StyleColor(red: 142, green: 142, blue: 142, alpha: 0.6)!)
                    //                layer.fillOutlineColor = .constant(StyleColor(red: 142, green: 142, blue: 142, alpha: 1)!)
                    //
                    //                try self.mapView?.mapboxMap.addLayer(layer)
                } catch let error {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func addMapListener(_ call: CAPPluginCall) {

    }
    @objc func addOverlayImage(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                let imageUrl = call.getString("imageUrl") ?? ""
                let imageBounds = call.getArray("bounds", []) as! [[Double]]
                print("addOverlayImage")
                print(imageBounds)
                if imageUrl.isEmpty {
                    call.reject("image url not found")
                } else {
                    var imageLayerSource = ImageSource(id: "vraImage")
                    imageLayerSource.coordinates = imageBounds
                    print("imageUrl => ", imageUrl)
                    imageLayerSource.url = imageUrl
                    try self.mapView?.mapboxMap.addSource(imageLayerSource)
                    var rasterLayer = RasterLayer(
                        id: "vraImage", source: "vraImage")
                    rasterLayer.rasterResampling = .constant(
                        RasterResampling.nearest)
                    rasterLayer.visibility = .constant(Visibility.visible)

                    //rasterResampling(RasterResampling.nearest)
                    try self.mapView?.mapboxMap.addLayer(rasterLayer)
                    print("add image overlay")
                    call.resolve(["status": true])
                }
            } catch let error {
                print("add image overlay \(error.localizedDescription)")
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func addOrUpdateMarker(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                let markerCoordinates =
                    call.getArray("coordinates", []) as! [Double]
                //                let markerImage = call.getString(
                //                    "markerImage", "https://orbit-web.doktar.io/vra-marker.svg")
                let heading = call.getDouble("heading")

                let hasMarker = call.getBool("hasMarker", false)
                if markerCoordinates.count == 0 {
                    return call.reject("marker coordinates required")
                }
                let locationCoordinate = CLLocationCoordinate2D(
                    latitude: markerCoordinates[1],
                    longitude: markerCoordinates[0])
                var feature = Feature(geometry: Point(locationCoordinate))
                feature.properties = [
                    "icon_key": .string("tractor_marker_image")
                ]
                var source = GeoJSONSource(id: "tractor_marker")
                source.data = .feature(feature)
                var xxx: Source?
                do {
                    xxx = try self.mapView?.mapboxMap.source(
                        withId: "tractor_marker")
                } catch _ {
                    print("source bulunamadı tractor_marker")
                }
              
                if xxx != nil {
                    self.mapView?.mapboxMap.updateGeoJSONSource(
                        withId: "tractor_marker", data: source.data!)
                } else {
                    let imageExpression = Exp(.match) {
                        Exp(.get) { "icon_key" }
                        "tractor_marker_image"
                    }
                    try self.mapView?.mapboxMap.addSource(source)
                    var layer = SymbolLayer(
                        id: "tractor_marker", source: "tractor_marker")
                    layer.iconImage = .expression(imageExpression)
                    layer.iconAnchor = .constant(.center)
                    layer.iconAllowOverlap = .constant(false)
                    try self.mapView?.mapboxMap.addLayer(layer)
                }

            } catch let error {
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func flyTo(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                let rawCenter = call.getArray("center", []) as! [Double]
                let zoom = call.getInt("zoom", 20)
                let duration = call.getDouble("duration", 1)
                let centerCoordinate = CLLocationCoordinate2D(
                    latitude: rawCenter[1], longitude: rawCenter[0])
                let newCamera = CameraOptions(
                    center: centerCoordinate, zoom: CGFloat(zoom))
                try self.mapView?.camera.ease(to: newCamera, duration: 1)
            } catch let error {
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func centerMapByBounds(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                let bounds = (call.getArray("bounds") ?? []) as [[Double]]
                let cameraBounds = bounds.map { t in
                    return CLLocationCoordinate2DMake(t[1], t[0])
                }
                var wktStr = bounds.map { t in
                    return "\(t[0]) \(t[1])"
                }.joined(separator: ", ")

                var geometry = try Geometry(wkt: "Polygon ((\(wktStr)))")
                self.mapView?.mapboxMap.camera(
                    for: geometry, padding: .zero, bearing: 0, pitch: 0)
            } catch let error {
                call.reject(error.localizedDescription)
            }
        }
    }
}
