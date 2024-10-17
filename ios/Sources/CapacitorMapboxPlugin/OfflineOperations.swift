//import MapboxMaps
//import MapboxCommon
//
//import Foundation
//
//@objc public class OfflineOperations: NSObject {
//    private var tileStore: TileStoreObserver?
//    
//    private var cancelables = Set<AnyCancelable>()
//    
//    private var downloads: [AnyCancelable] = []
//    private lazy var offlineManager: OfflineManager = {
//        return OfflineManager()
//    }()
//    private func downloadTileRegions() {
//           guard let tileStore = tileStore else {
//               preconditionFailure()
//           }
//
//           precondition(downloads.isEmpty)
//
//           let dispatchGroup = DispatchGroup()
//           var downloadError = false
//
//           // - - - - - - - -
//
//           // 1. Create style package with loadStylePack() call.
//           let stylePackLoadOptions = StylePackLoadOptions(glyphsRasterizationMode: .ideographsRasterizedLocally,
//                                                           metadata: ["tag": "my-outdoors-style-pack"])!
//
//           dispatchGroup.enter()
//           let stylePackDownload = offlineManager.loadStylePack(for: .outdoors, loadOptions: stylePackLoadOptions) { [weak self] progress in
//               // These closures do not get called from the main thread. In this case
//               // we're updating the UI, so it's important to dispatch to the main
//               // queue.
//               DispatchQueue.main.async {
//                   guard let stylePackProgressView = self?.stylePackProgressView else {
//                       return
//                   }
//
//                   self?.logger?.log(message: "StylePack = \(progress)", category: "Example")
//                   stylePackProgressView.progress = Float(progress.completedResourceCount) / Float(progress.requiredResourceCount)
//               }
//
//           } completion: { [weak self] result in
//               DispatchQueue.main.async {
//                   defer {
//                       dispatchGroup.leave()
//                   }
//
//                   switch result {
//                   case let .success(stylePack):
//                       self?.logger?.log(message: "StylePack = \(stylePack)", category: "Example")
//
//                   case let .failure(error):
//                       self?.logger?.log(message: "stylePack download Error = \(error)", category: "Example", color: .red)
//                       downloadError = true
//                   }
//               }
//           }
//
//           // - - - - - - - -
//
//           // 2. Create an offline region with tiles for the outdoors style
//           let outdoorsOptions = TilesetDescriptorOptions(styleURI: .outdoors,
//                                                          zoomRange: 0...16, tilesets: nil)
//
//           let outdoorsDescriptor = offlineManager.createTilesetDescriptor(for: outdoorsOptions)
//
//           // Load the tile region
//           let tileRegionLoadOptions = TileRegionLoadOptions(
//               geometry: .point(Point(tokyoCoord)),
//               descriptors: [outdoorsDescriptor],
//               metadata: ["tag": "my-outdoors-tile-region"],
//               acceptExpired: true)!
//
//           // Use the the default TileStore to load this region. You can create
//           // custom TileStores are are unique for a particular file path, i.e.
//           // there is only ever one TileStore per unique path.
//           dispatchGroup.enter()
//           let tileRegionDownload = tileStore.loadTileRegion(forId: tileRegionId,
//                                                             loadOptions: tileRegionLoadOptions) { [weak self] (progress) in
//               // These closures do not get called from the main thread. In this case
//               // we're updating the UI, so it's important to dispatch to the main
//               // queue.
//               DispatchQueue.main.async {
//                   guard let tileRegionProgressView = self?.tileRegionProgressView else {
//                       return
//                   }
//
//                   self?.logger?.log(message: "\(progress)", category: "Example")
//
//                   // Update the progress bar
//                   tileRegionProgressView.progress = Float(progress.completedResourceCount) / Float(progress.requiredResourceCount)
//               }
//           } completion: { [weak self] result in
//               DispatchQueue.main.async {
//                   defer {
//                       dispatchGroup.leave()
//                   }
//
//                   switch result {
//                   case let .success(tileRegion):
//                       self?.logger?.log(message: "tileRegion = \(tileRegion)", category: "Example")
//
//                   case let .failure(error):
//                       self?.logger?.log(message: "tileRegion download Error = \(error)", category: "Example", color: .red)
//                       downloadError = true
//                   }
//               }
//           }
//
//           // Wait for both downloads before moving to the next state
//           dispatchGroup.notify(queue: .main) {
//               self.downloads = []
//               self.state = downloadError ? .finished : .downloaded
//           }
//
//           downloads = [stylePackDownload, tileRegionDownload]
//           state = .downloading
//       }
//}
