package com.sinanucar.plugins.mapbox;

import android.content.Intent;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CapacitorMapbox")
public class CapacitorMapboxPlugin extends Plugin {

    private CapacitorMapbox implementation = new CapacitorMapbox();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void buildMap(Plugin call){

    }

    @PluginMethod
    public void destroyMap(Plugin call){

    }
    
    @PluginMethod
    public void flyTo(Plugin call){

    }
    
    @PluginMethod
    public void addPolygon(Plugin call){

    }
    
    @PluginMethod
    public void updatePolygon(Plugin call){

    }
    
    @PluginMethod
    public void addLineString(Plugin call){

    }
    
    @PluginMethod
    public void updateLineString(Plugin call){

    }
    
    @PluginMethod
    public void addMapListener(Plugin call){

    }
    
    @PluginMethod
    public void addOverlayImage(Plugin call){

    }
    
    @PluginMethod
    public void addOrUpdateMarker(Plugin call){

    }
    
    @PluginMethod
    public void centerMapByBounds(Plugin call){

    }
}
