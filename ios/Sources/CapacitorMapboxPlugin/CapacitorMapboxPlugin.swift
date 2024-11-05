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
            let heightFactor = self.modalIsMinimized ? 0.5 : 0.3
            let deactivateFactor = heightFactor == 0.3 ? 0.5 : 0.3
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

    @objc func buildMap(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let mainView = self.bridge?.viewController?.view
            self.mainViewHeight = mainView!.bounds.height
            self.modalIsMinimized = true
            mainView!.addSubview(self.mapCanvas)
            self.minimizedConstraint = self.mapCanvas.heightAnchor.constraint(
                equalToConstant: mainView!.bounds.height * 0.1)
            self.fullScreenConstraint = self.mapCanvas.heightAnchor.constraint(
                equalToConstant: mainView!.bounds.height * 0.5)
            self.minimizedConstraint!.isActive = true
            self.fullScreenConstraint!.isActive = false
            NSLayoutConstraint.activate([
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
            call.resolve([
                "status": true
            ])
        }
    }

    @objc func destroyMap(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.minimizedConstraint?.isActive = false
            self.fullScreenConstraint?.isActive = false
            self.mapView?.removeFromSuperview()
            self.mapCanvas.removeFromSuperview()
            call.resolve(["status": true])
        }
    }

    @objc func addLineString(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let lineStringId = call.getString("lineStringId", "lineStringId")
//            let wktType = call.getString("wktType", "LINESTRING")
            var geojson = call.getArray("geoJson", [])
            
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {
                    var lineStringSource = GeoJSONSource(id: lineStringId)
                    var geometry: Geometry? = nil

//                    if wktType == "LINESTRING" {
                        
                        let wktStr = geojson.map { t in
                            let temp = t as! [Double]
                            return "\(temp[0]) \(temp[1])"
                        }.joined(separator: ", ")
                        do{
                            geometry = try Geometry(wkt: "LINESTRING (\(wktStr))")
                        } catch _ {
                            print("error on create geometry")
                        }
//                    }
//                    else if wktType == "MULTILINESTRING" {
//                        var wktStr = ""
//                        var wktStrArray: [String] = []
//                        geojson.forEach{el in
//                            var tempCoords = (el as! [[Double]]).map {t in
//                                return "\(t[0]) \(t[1])"
//                            }.joined(separator: ", ")
//                            wktStrArray.append("(\(tempCoords)")
//                        }
//                        wktStr = wktStrArray.joined(separator: ", ")
//                        do{
//                            geometry = try Geometry(wkt: "MULTILINESTRING (\(wktStr))")
//                        } catch _ {
//                            print("error on create geometry")
//                        }
//                    }else{
//                        geometry = nil
//                    }
                    
                    if(geometry != nil){
                        let feature: Feature = Feature(geometry: geometry!)
                        lineStringSource.data = .feature(feature)
                        var xxx: Source?
                        do {
                            xxx = try self.mapView?.mapboxMap.source(
                                withId: lineStringId)
                        } catch _ {
                            print("source bulunamadı \(lineStringId)")
                        }
                        
                        if xxx != nil {
                            self.mapView?.mapboxMap.updateGeoJSONSource(
                                withId: lineStringId, data: lineStringSource.data!)
                        } else {
                            do{
                                try self.mapView?.mapboxMap.addSource(lineStringSource)
                            }catch _ {
                                
                            }
                            var layer = LineLayer(
                                id: lineStringId, source: lineStringId)
                            layer.lineColor = .constant(
                                StyleColor.init(UIColor.white))
                            layer.lineWidth = .constant(5)
                            do{
                                try self.mapView?.mapboxMap.addLayer(layer)
                            }catch _ {
                                
                            }
                        }
                        call.resolve(["status": true])
                    }
                } catch let error {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updateLineString(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let lineStringId = call.getString("lineStringId","lineStringId")
            let geojson = call.getArray("geoJson", []) as! [[Double]]
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
                } catch let error {
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func addPolygon(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            do{
             
            let polygonId = call.getString("polygonId", "polygonId")

            let imageUrl = call.getString("imageUrl", "")
//            let bounds = (call.getArray("bounds") ?? []) as! [Double]
                guard let geojson = call.getArray("geoJson", []) as? [[[Double]]] else { return }
            let hasIntersection = call.getBool("hasIntersect", false)
            let isErrorPolygon = call.getBool("isError", false)
            if geojson.count == 0 {
                return call.reject("geojson not found")
            } else {

                do {

                    var wktStrArray: [String] = []
                    geojson.forEach { t in
                        var tempStr = t.map { j in
                            return "\(j[0]) \(j[1])"
                        }.joined(separator: ", ")
                        wktStrArray.append("((\(tempStr)))")
                    }
                    var wktStr =
                        "MULTIPOLYGON (\(wktStrArray.joined(separator: ", ")))"
                    
                    var polygonSource = GeoJSONSource(id: polygonId)
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
                        if hasIntersection {
                            layer.fillColor = .constant(
                                StyleColor(
                                    red: 0, green: 255, blue: 0, alpha: 0.8)!
                            )
                            layer.fillOutlineColor = .constant(
                                StyleColor(
                                    red: 0, green: 255, blue: 0, alpha: 1)!)
                        }else{
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
                                    red: 142, green: 142, blue: 142,
                                    alpha: 0.6)!
                            )
                            layer.fillOutlineColor = .constant(
                                StyleColor(
                                    red: 142, green: 142, blue: 142,
                                    alpha: 1)!)
                        }}

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
            }catch let error{
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func updatePolygon(_ call: CAPPluginCall) {

        DispatchQueue.main.async {
            let id = call.getString("id")
            let processType = call.getString("type")
            if(id == nil){
                call.reject("id required")
            }else{
                do {
                    
                    var source = self.mapView?.mapboxMap.sourceExists(withId: id!)
                    if(source!){
                        var layer = self.mapView?.mapboxMap.layerExists(withId: id!)
                        if(layer!){
                            if(processType == "delete"){
                                do{
                                    try self.mapView?.mapboxMap.removeLayer(withId: id!)
                                }catch _ {}
                            }
                        }
                        if(processType == "delete"){
                            do{
                                try self.mapView?.mapboxMap.removeSource(withId: id!)
                            }catch _ {}
                        }
                        
                        call.resolve(["status": true])
                    }else{
                        call.resolve(["status": false, "message": "source not found"])
                    }
                    
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
                let imageUrl = call.getString("imageUrl", "")
                guard let imageBounds = call.getArray("bounds", []) as? [[Double]] else { return }
//                let imageBounds = call.getArray("bounds", []) as! [[Double]]
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

    var customPointAnnotation: PointAnnotation?
    @objc func addOrUpdateMarker(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
//                let markerCoordinates =
//                    call.getArray("coordinates", []) as! [Double]
                guard let markerCoordinates = call.getArray("coordinates", []) as? [Double] else { return }
                //                let markerImage = call.getString(
                //                    "markerImage", "https://orbit-web.doktar.io/vra-marker.svg")
                var heading = call.getDouble("heading") ?? 0
                heading = heading * -1
                let hasMarker = call.getBool("hasMarker", false)
                if markerCoordinates.count == 0 {
                    return call.reject("marker coordinates required")
                }
                let locationCoordinate = CLLocationCoordinate2D(
                    latitude: markerCoordinates[1],
                    longitude: markerCoordinates[0])
                let customImage = UIImage(named: "tractor-marker")
                if self.mapView?.mapboxMap.cameraState.bearing.isNaN == false {
                    let mapBearing = self.mapView?.mapboxMap.cameraState.bearing.toRadians().significand
                    heading = heading - mapBearing!
                }
                var feature = Feature(geometry: Point(locationCoordinate))
                feature.properties = [
                    "icon_key": .string("tractor_marker_image"),
                    "icon_rotation": .number(heading),
                ]
                var source = GeoJSONSource(id: "tractor_marker")
                source.data = .feature(feature)
                var previousSource: Source?
                var iconLayer: SymbolLayer?
                do {
                    previousSource = try self.mapView?.mapboxMap.source(
                        withId: "tractor_marker")

                } catch _ {
                    print("source bulunamadı tractor_marker")
                }


                if previousSource != nil {
                    self.mapView?.mapboxMap.updateGeoJSONSource(
                        withId: "tractor_marker", data: source.data!)
                    if iconLayer != nil {
                        //                        iconLayer?.iconRotate = .constant(heading)
                        do {
                           try self.mapView?.mapboxMap.setLayerProperty(for: "tractor_marker", property: "icon_rotate", value: heading)
                        } catch _ {
                            
                        }
                        
                        print(
                            "layer heading \(heading) - \(iconLayer?.iconRotate ?? .constant(-999))"
                        )
                    }
                } else {
                    try self.mapView?.mapboxMap.addImage(
                        UIImage(named: "tractor-marker")!,
                        id: "tractor_marker_image")
                    //                    let imageExpression = Exp(.match) {
                    //                        Exp(.get) { "icon_key" }
                    //                        "tractor_marker_image"
                    //                    }
                    let headingExp = Exp(.match) {
                        Exp(.get) { "icon_rotation" }
                        "heading_value"
                    }
                    try self.mapView?.mapboxMap.addSource(source)
                    var layer = SymbolLayer(
                        id: "tractor_marker", source: "tractor_marker")
                    layer.iconImage = .constant(.name("tractor_marker_image"))
                    layer.iconAnchor = .constant(.center)
                    layer.iconAllowOverlap = .constant(false)
                    layer.iconRotate = .expression(
                        Exp(.mod) {
                            Exp(.get) { "icon_rotation" }
                            heading
                        })
                    iconLayer?.iconRotationAlignment = .constant(
                        IconRotationAlignment(rawValue: "map"))
                    layer.iconAllowOverlap = .constant(true)
                    layer.iconSize = .constant(2)

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
//                let rawCenter = call.getArray("center", []) as! [Double]
                guard let rawCenter = call.getArray("center", []) as? [Double] else { return }
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
//                let bounds = (call.getArray("bounds") ?? []) as [[Double]]
                guard let bounds = call.getArray("bounds", []) as? [[Double]] else { return }
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
