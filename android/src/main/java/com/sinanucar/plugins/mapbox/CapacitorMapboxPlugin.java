package com.sinanucar.plugins.mapbox;

import android.annotation.SuppressLint;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.mapbox.bindgen.DataRef;
import com.mapbox.bindgen.Value;
import com.mapbox.geojson.Feature;
import com.mapbox.geojson.FeatureCollection;
import com.mapbox.geojson.Geometry;
import com.mapbox.geojson.LineString;
import com.mapbox.geojson.MultiLineString;
import com.mapbox.geojson.MultiPolygon;
import com.mapbox.geojson.Point;
import com.mapbox.maps.CameraBoundsOptions;
import com.mapbox.maps.CameraOptions;
import com.mapbox.maps.CoordinateBounds;
import com.mapbox.maps.Image;
import com.mapbox.maps.MapView;
import com.mapbox.maps.MapboxStyleManager;
import com.mapbox.maps.Style;
import com.mapbox.maps.StyleObjectInfo;
import com.mapbox.maps.extension.style.StyleContract;
import com.mapbox.maps.extension.style.expressions.generated.Expression;
import com.mapbox.maps.extension.style.layers.generated.FillLayer;
import com.mapbox.maps.extension.style.layers.generated.LineLayer;
import com.mapbox.maps.extension.style.layers.generated.RasterLayer;
import com.mapbox.maps.extension.style.layers.generated.SymbolLayer;
import com.mapbox.maps.extension.style.layers.properties.generated.IconAnchor;
import com.mapbox.maps.extension.style.layers.properties.generated.RasterResampling;
import com.mapbox.maps.extension.style.layers.properties.generated.Visibility;
import com.mapbox.maps.extension.style.sources.generated.GeoJsonSource;
import com.mapbox.maps.extension.style.sources.generated.ImageSource;
import com.mapbox.maps.extension.style.sources.generated.ImageSourceKt;

import org.json.JSONArray;
import org.json.JSONException;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@CapacitorPlugin(name = "CapacitorMapbox")
public class CapacitorMapboxPlugin extends Plugin {

    private CapacitorMapbox implementation = new CapacitorMapbox();
    private MapboxModalViewActivity mapViewActivity;
    private String markerIcon =
            "iVBORw0KGgoAAAANSUhEUgAAACIAAAAjCAYAAADxG9hnAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAHaSURBVHgB7ZexTgJBGIQHY2EHlXaAjZ102JnwABY8AtY2voH4BpjYcxZWFmC0s+B6Ky1tBDsr7KQ7Z+XfsB7n3e4ehpjcl0z2Av/uzQ7/JgtQUFBQ8E+IoqgCHzhxQPWpFnKg5staU2rkOrkS/eSVOqXqDvNV/Si2Th+uyC6SUIt3Ugycye41n8ZzC65IpHqhG+opIaW+1LWj5d1PqDuZ+12f9r5Shhn1m7aoB+qRKlM16oDaTpgyo56pF+pNPjuiGtRxqVQK4GmkzWFATajr2Nc7VJPSp2EiZmdGjTJ+Is+7NDL+5VXYRAqcOKSZD8xTqGKxS8U7dY90ajIGaSYUG8jmQsZDuKPnXGUV2hjpUTqVMuypSv2YaYRZxZlGuIgyoXfUhD0NGc9tim0SUQyNxbcs6stYGAkt6u2MSLShmLBJRTfpbVaTOhkRdMQ2RnSTBrDE2oikMsY8lWpKqdmkQ6zaiGBzlHVvZB7ZPEYCLI5yUipmkwb4KyNylHUqjYQS5yb1MiL0ZNzD8lF2blJvI5JKiOWj7NWk3kYE8yjrVLyaNDfGRUhdfi6NC1EdHvgmotA738eiSUPXJs2N3E+nsXtpB+uAL+6ad1isi1gq7n8VVmymK2bqyMEXylp4/k0rr3MAAAAASUVORK5CYII=";
    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }
    public MapView mapView;


    @SuppressLint({"Lifecycle", "ResourceType"})
    @PluginMethod
    public void buildMap(PluginCall call){
        double zoomLevel = 0.0;
        double latitude = 0.0;
        double longitude = 0.0;
        try{
            zoomLevel = call.getDouble("zoom", 0.0);
            latitude = call.getDouble("latitude",0.0);
            longitude = call.getDouble("longitude",0.0);
        }catch (Exception ex){

        }

        this.mapViewActivity = new MapboxModalViewActivity();
        mapViewActivity.starterLatitude = latitude;
        mapViewActivity.starterLongitude = longitude;
        mapViewActivity.starterZoomLevel = zoomLevel;
        mapViewActivity.call = call;
        this.mapView = this.mapViewActivity.getMapView();

        bridge
                .getActivity()
                .runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                FrameLayout containerView = getBridge().getActivity().findViewById(R.id.map_frame_container);
                                if (containerView == null) {
                                    try{
                                        containerView = new FrameLayout(getActivity().getApplicationContext());
                                        containerView.setId(R.id.map_frame_container);

                                        ((ViewGroup) getBridge().getWebView().getParent()).addView(containerView);
                                        FragmentManager fragmentManager = getBridge().getActivity().getFragmentManager();
                                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                                        fragmentTransaction.add(containerView.getId(), mapViewActivity);
                                        fragmentTransaction.commit();
                                    }catch(Exception e){
                                        String ex = e.getMessage();
                                    }
                                }
                            }
                        }
                );
    }

    @PluginMethod
    public void destroyMap(PluginCall call){
        /**
         * ekledikten sonra kaldırırız artık.
         */
        FrameLayout containerView = getBridge().getActivity().findViewById(R.id.map_frame_container);
        if (containerView != null) {
            try{

                ((ViewGroup) getBridge().getWebView().getParent()).removeView(containerView);
//                FragmentManager fragmentManager = getBridge().getActivity().getFragmentManager();
//                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
//                fragmentTransaction.remove(containerView, mapViewActivity);
//                fragmentTransaction.commit();

                JSObject ret = new JSObject();
                ret.put("status", true);
                call.resolve(ret);
            }catch(Exception e){
                call.reject(e.getMessage());
            }
        }else{

            JSObject ret = new JSObject();
            ret.put("status", true);
            call.resolve(ret);
        }

    }
    
    @PluginMethod
    public void flyTo(PluginCall call){

        try {
        JSArray rawCenter = call.getArray("center");
        double zoom = call.getDouble("zoom", 20.0);
        int duration = call.getInt("duration", 1);

        CameraOptions cameraOptions = null;
            cameraOptions = new CameraOptions.Builder()
                    .center(Point.fromLngLat(rawCenter.getDouble(0), rawCenter.getDouble(1)))
                    .zoom(zoom)
                    .bearing(0.0)
                    .pitch(0.0)
                    .build();
        this.mapView.getMapboxMap().setCamera(cameraOptions);

            JSObject ret = new JSObject();
            ret.put("status", true);
            call.resolve(ret);
        } catch (JSONException e) {
            call.reject(e.getMessage());
        }
    }

    @PluginMethod
    public void addPolygon(PluginCall call){
        try {
            String polygonId = call.getString("polygonId", "polygonId");
            JSArray data = call.getArray("geoJson"); // Double[][][]
            boolean hasIntersection = call.getBoolean("hasIntersect", false);
            boolean isErrorPolygon = call.getBoolean("isError", false);
            List<MultiPolygon> multiPolygons = new ArrayList<>();
            if (data != null) {
                // Dizi boyutlarını al
                int firstDimension = data.length();
                List<List<Point>> firstArray = new ArrayList<>();
                for (int i = 0; i < firstDimension; i++) {
                    int secondDimension = ((JSONArray) data.get(i)).length();
                    List<Point> secondArray = new ArrayList<>();
                    for (int j = 0; j < secondDimension; j++) {
                        JSONArray thirdArray = ((JSONArray)((JSONArray) data.get(i)).get(j));
                        Point tempPoint = Point.fromLngLat(thirdArray.getDouble(0), thirdArray.getDouble(1));
                        secondArray.add(tempPoint);
                    }
//                    firstArray.add(secondArray);

                }
                MultiPolygon multiPolygon = MultiPolygon.fromLngLats(List.of(firstArray));
                GeoJsonSource geoJsonSource = new GeoJsonSource.Builder(polygonId).geometry(multiPolygon).build();

                List<StyleObjectInfo> styleSources = this.mapView.getMapboxMap().getStyleSources();
                boolean hasSource = false;
                for(StyleObjectInfo info : styleSources){
                    if(info.getId() == polygonId)
                        hasSource = true;
                }
                if(hasSource){
                    this.mapView.getMapboxMap().getStyle().updateGeoJSONSourceFeatures(polygonId, polygonId,
                        FeatureCollection.fromFeature(Feature.fromGeometry(multiPolygon)).features());
                }else {
                    geoJsonSource.bindTo(this.mapView.getMapboxMap().getStyle());
                    FillLayer fillLayer = new FillLayer(polygonId, polygonId);
                    if (hasIntersection) {
                        fillLayer.fillColor("#00FF00");
                        fillLayer.fillOutlineColor("#00FF00");
                    } else {
                        if (isErrorPolygon) {
                            fillLayer.fillColor("#FF0000");
                            fillLayer.fillOutlineColor("#FF0000");
                        } else {
                            fillLayer.fillColor("#8e8e8e");
                            fillLayer.fillOutlineColor("#8e8e8e");
                        }
                    }
                    fillLayer.bindTo(this.mapView.getMapboxMap().getStyle());
                }
                JSObject ret = new JSObject();
                ret.put("status", true);
                call.resolve(ret);
            } else {
                call.reject("Data is null");
            }
        } catch (Exception e) {
            call.reject(e.getMessage());
        }
    }

    @PluginMethod
    public void updatePolygon(PluginCall call){

    }
    
    @PluginMethod
    public void addLineString(PluginCall call){
        try {
            String lineStringId = call.getString("lineStringId","lineStringId");
            JSArray geojson = call.getArray("geoJson"); //  [[Double]]
            if(geojson == null){
                call.reject("geojson not found");
            }else{
                List<Point> pointList = new ArrayList<>();
                for (int i = 0; i < geojson.length(); i++) {
                    JSONArray tempItem = (JSONArray) geojson.get(i);
                    Point tempPoint = Point.fromLngLat(tempItem.getDouble(0), tempItem.getDouble(1));
                    pointList.add(tempPoint);
                }

                LineString lineString = LineString.fromLngLats(pointList);
                GeoJsonSource geoJsonSource = new GeoJsonSource.Builder(lineStringId).geometry(lineString).build();
                List<StyleObjectInfo> styleSources = this.mapView.getMapboxMap().getStyleSources();
                boolean hasSource = false;
                for(StyleObjectInfo info : styleSources){
                    if(info.getId() == lineStringId)
                        hasSource = true;
                }
                if(hasSource){
                    this.mapView.getMapboxMap().getStyle().updateGeoJSONSourceFeatures(lineStringId, lineStringId, FeatureCollection.fromFeature(Feature.fromGeometry(lineString)).features());
                }else{
                    geoJsonSource.bindTo(this.mapView.getMapboxMap().getStyle());
                    LineLayer lineLayer = new LineLayer(lineStringId, lineStringId);
                    lineLayer.lineColor("#FFFFFF");
                    lineLayer.lineWidth(5);
                    lineLayer.bindTo(this.mapView.getMapboxMap().getStyle());
                }
                JSObject ret = new JSObject();
                ret.put("status", true);
                call.resolve(ret);
            }
        } catch (Exception e) {
            call.reject(e.getMessage());
        }
    }
    
    @PluginMethod
    public void updateLineString(PluginCall call){

    }

    @PluginMethod
    public void addMapListener(PluginCall call){

    }

    @PluginMethod
    public void addOverlayImage(PluginCall call){
        try {
            String imageUrl = call.getString("imageUrl", "");
            JSArray imageBounds = call.getArray("bound"); //Double[][]
            if(imageUrl.isEmpty()){
                call.reject("image url not found");
            }else{
                if(imageBounds == null){
                    call.reject("image bounds not found");
                }else{
                    List<List<Double>> bounds = new ArrayList<>();
                    for (int i = 0; i < imageBounds.length(); i++) {
                        JSONArray tempItem = (JSONArray) imageBounds.get(i);
//                        Point tempPoint = Point.fromLngLat(tempItem.getDouble(0), tempItem.getDouble(1));
                        List<Double> tempArray = new ArrayList<>();
                        tempArray.add(tempItem.getDouble(0));
                        tempArray.add(tempItem.getDouble(1));
                        bounds.add(tempArray);
                    }
                    ImageSource imageSource = new ImageSource.Builder("vraImage").coordinates(bounds).url(imageUrl).build();
                    imageSource.bindTo(this.mapView.getMapboxMap().getStyle());
                    RasterLayer rasterLayer = new RasterLayer("vraImage","vraImage");
                    rasterLayer.rasterResampling(RasterResampling.NEAREST);
                    rasterLayer.visibility(Visibility.VISIBLE);
                    rasterLayer.bindTo(this.mapView.getMapboxMap().getStyle());
                }

                JSObject ret = new JSObject();
                ret.put("status", true);
                call.resolve(ret);
            }
        } catch (Exception e) {
            call.reject(e.getMessage());
        }
    }
    
    @PluginMethod
    public void addOrUpdateMarker(PluginCall call){
        try{
            JSArray markerCoords = call.getArray("coordinates");
            double heading = call.getDouble("heading", 35.0);
            boolean hasMarker = call.getBoolean("hasMarker");
            String sourceId = "tractor_marker";
            Point coordinate = Point.fromLngLat(markerCoords.getDouble(0), markerCoords.getDouble(1));

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("icon_key", "tractor_marker_image");
            jsonObject.addProperty("icon_rotation", (heading + 180));
            Feature feature = Feature.fromGeometry(coordinate, jsonObject, sourceId);
            GeoJsonSource source = new GeoJsonSource
                    .Builder(sourceId)
                    .feature(feature)
                    .build();
            List<StyleObjectInfo> styleSources = this.mapView.getMapboxMap().getStyleSources();
            boolean hasSource = false;
            for(StyleObjectInfo info : styleSources){
                if(info.getId() == sourceId)
                    hasSource = true;
            }
            if(hasSource){
                this.mapView.getMapboxMap()
                        .getStyle()
                        .updateGeoJSONSourceFeatures(
                                sourceId,
                                sourceId,
                                FeatureCollection.fromFeature(Feature.fromGeometry(coordinate)).features()
                        );

                for (StyleObjectInfo styleLayer : this.mapView.getMapboxMap().getStyleLayers()) {
                    if(styleLayer.getId() == sourceId) {
                        this.mapView.getMapboxMap().getStyle().setStyleLayerProperty(sourceId, "icon-rotate", Value.valueOf(heading));
                    }
                }

            }else{

                byte[] decodedBytes = Base64.decode(markerIcon, Base64.DEFAULT);
                DataRef dataRef = new DataRef(ByteBuffer.wrap(decodedBytes));
                Image image = new Image(35,35,dataRef);
                this.mapView.getMapboxMap().addImage("tractor_marker_image", image);
                SymbolLayer symbolLayer = new SymbolLayer(sourceId, sourceId);
                symbolLayer.iconImage("tractor_marker_image");
                symbolLayer.iconAnchor(IconAnchor.CENTER);
                symbolLayer.iconRotate(heading + 180);
                symbolLayer.bindTo(this.mapView.getMapboxMap().getStyle());
            }

            JSObject ret = new JSObject();
            ret.put("status", true);
            call.resolve(ret);
        } catch (Exception e) {
            call.reject(e.getMessage());
        }
    }
    
    @PluginMethod
    public void centerMapByBounds(PluginCall call){
        try {
            JSArray bounds = call.getArray("bounds");
            if(bounds == null){
                call.reject("bounds not found");
            }else{
                List<Double> rawNE = (List<Double>) bounds.get(1);
                List<Double> rawSW = (List<Double>) bounds.get(4);
                Point northEast = Point.fromLngLat(rawNE.get(0), rawNE.get(1));
                Point southWest = Point.fromLngLat(rawSW.get(0), rawSW.get(1));
                CoordinateBounds coordinateBounds = new CoordinateBounds(southWest, northEast);

                CameraBoundsOptions cameraOptions = new CameraBoundsOptions.Builder().bounds(coordinateBounds).build();
                this.mapView.getMapboxMap().setBounds(cameraOptions);

                JSObject ret = new JSObject();
                ret.put("status", true);
                call.resolve(ret);
            }
        } catch (Exception e) {
            call.reject(e.getMessage());
        }
    }
}
