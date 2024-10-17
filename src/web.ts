import { CallbackID, WebPlugin } from '@capacitor/core';

import type { CapacitorMapboxPlugin, MapListenerCallback } from './definitions';

export class CapacitorMapboxWeb extends WebPlugin implements CapacitorMapboxPlugin {
  flyTo(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("flyTo", options);
    return Promise.reject("Required a native device");
  }
  updatePolygon(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("updatePolygon", options);
    return Promise.reject("Required a native device");
  }
  updateLineString(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("updateLineString", options);
    return Promise.reject("Required a native device");
  }
  addOverlayImage(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
      console.log("addOverlayImage", options);
      return Promise.reject("Required a native device");
  }
  addLineString(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("addLineString", options);
    return Promise.reject("Required a native device");
  }
  centerMapByBounds(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("centerMapByBounds", options);
    return Promise.reject("Required a native device");
  }
  addPolygon(options: { [key: string]: any; }): Promise<{ status: boolean; }> {
    console.log("addPolygon", options);
    return Promise.reject("Required a native device");
  }
  addMapListener(listenerName: string, callbackFn: MapListenerCallback): Promise<CallbackID> {
    console.log("addMapListener", listenerName,callbackFn);
    return Promise.reject("Required a native device");
  }
  // addOverlayImage(imageUrl: string): Promise<{ status: boolean; }> {
  //   console.log("addOverlayImage", imageUrl);
  //   return Promise.reject("Required a native device");
  // }
  addOrUpdateMarker(props: { [key: string]: any }): Promise<{ status: boolean; }> {
    console.log("addOrUpdateMarker", props);
    return Promise.reject("Required a native device");
  }
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async buildMap(options: { [key: string]: any }): Promise<{ status: boolean, map: any }> {
    console.log("buildMap", options);
    return Promise.reject("Required a native device");
  }
  async destroyMap(options: { [key: string]: any }): Promise<{ status: boolean, map: any }> {
    console.log("destroyMap", options);
    return Promise.reject("Required a native device");
  }
}
