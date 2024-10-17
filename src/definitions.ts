import { CallbackID } from "@capacitor/core";

export interface CapacitorMapboxPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  buildMap(options: { [key: string]: any }): Promise<{ status: boolean }>;
  destroyMap(options: { [key: string]: any }): Promise<{ status: boolean }>;
  flyTo(options:{[key:string]: any}): Promise<{status: boolean}>;
  addPolygon(options: { [key: string]: any }): Promise<{ status: boolean }>;
  updatePolygon(options: { [key: string]: any }): Promise<{ status: boolean }>;
  addLineString(options: { [key: string]: any }): Promise<{ status: boolean }>;
  updateLineString(options: { [key: string]: any }): Promise<{ status: boolean }>;
  addMapListener(listenerName: string, callbackFn: MapListenerCallback): Promise<CallbackID>
  addOverlayImage(options: { [key: string]: any }): Promise<{ status: boolean }>
  addOrUpdateMarker(props: { [key: string]: any }): Promise<{ status: boolean }>
  centerMapByBounds(props: { [key: string]: any }): Promise<{ status: boolean }>
}

export type MapListenerCallback = (
  data: any | null,
  err?: any,
) => void;