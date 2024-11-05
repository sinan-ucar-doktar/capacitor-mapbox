package com.sinanucar.plugins.mapbox;

import android.annotation.SuppressLint;
import android.app.Fragment;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;

import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;
import com.mapbox.geojson.Point;
import com.mapbox.maps.CameraOptions;
import com.mapbox.maps.MapView;

public class MapboxModalViewActivity extends Fragment {
    public FrameLayout mainLayout;
    public FrameLayout frameContainerLayout;
    private String appResourcesPackage;
    private View view;
    private Button button;
    private Boolean modalIsMinimized = true;
    private MapView mapView;
    public MapView getMapView() {
        return mapView;
    }

    public void setMapView(MapView mapView) {
        this.mapView = mapView;
    }
    public double starterLatitude;
    public double starterLongitude;
    public double starterZoomLevel;
    public PluginCall call;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        appResourcesPackage = getActivity().getPackageName();

        // Inflate the layout for this fragment
        view = inflater.inflate(getResources().getIdentifier("mapbox_modal_view", "layout", appResourcesPackage), container, false);
        int height = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            height = getActivity().getWindowManager().getCurrentWindowMetrics().getBounds().height();
        }else{
            height = getActivity().getWindowManager().getDefaultDisplay().getHeight();
        }
        //view.getLayoutParams().height = (int) Math.round(height * 0.1);
        this.mapView = view.findViewById(R.id.mapboxView);
        this.button = view.findViewById(R.id.toggleButton);
        button.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                toggleHeight(v);
            }
        });
        View layout = view.findViewById(R.id.mapLinearLayout); // getActivity().findViewById(R.id.mapLinearLayout);
        layout.getLayoutParams().height = (int) Math.round(height * 0.1);
        this.buildMap();
        return view;
        // return super.onCreateView(inflater, container, savedInstanceState);
    }

    public void toggleHeight(View _view) {
        int height = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            height = getActivity().getWindowManager().getCurrentWindowMetrics().getBounds().height();
        }else{
            height = getActivity().getWindowManager().getDefaultDisplay().getHeight();
        }
        View layout = this.view.findViewById(R.id.mapLinearLayout); // getActivity().findViewById(R.id.mapLinearLayout);
        double heightFactor = modalIsMinimized ? 0.5 : 0.1;
        layout.getLayoutParams().height = (int) Math.round(height * heightFactor);
        this.button.setText(modalIsMinimized ? "^" : "-");
    }

    public void buildMap(){
        CameraOptions cameraOptions = new CameraOptions.Builder()
                .center(Point.fromLngLat(this.starterLongitude, this.starterLatitude))
                .zoom(this.starterZoomLevel)
                .bearing(0.0)
                .pitch(0.0)
                .build();
        this.mapView.getMapboxMap().setCamera(cameraOptions);

        JSObject ret = new JSObject();
        ret.put("status", true);
        this.call.resolve(ret);
    }
}
