# capacitor-mapbox

mapbox plugin for capacitorjs

## Install

```bash
npm install capacitor-mapbox
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`buildMap(...)`](#buildmap)
* [`destroyMap(...)`](#destroymap)
* [`flyTo(...)`](#flyto)
* [`addPolygon(...)`](#addpolygon)
* [`updatePolygon(...)`](#updatepolygon)
* [`addLineString(...)`](#addlinestring)
* [`updateLineString(...)`](#updatelinestring)
* [`addMapListener(...)`](#addmaplistener)
* [`addOverlayImage(...)`](#addoverlayimage)
* [`addOrUpdateMarker(...)`](#addorupdatemarker)
* [`centerMapByBounds(...)`](#centermapbybounds)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### buildMap(...)

```typescript
buildMap(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### destroyMap(...)

```typescript
destroyMap(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### flyTo(...)

```typescript
flyTo(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### addPolygon(...)

```typescript
addPolygon(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### updatePolygon(...)

```typescript
updatePolygon(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### addLineString(...)

```typescript
addLineString(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### updateLineString(...)

```typescript
updateLineString(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### addMapListener(...)

```typescript
addMapListener(listenerName: string, callbackFn: MapListenerCallback) => Promise<CallbackID>
```

| Param              | Type                                                                |
| ------------------ | ------------------------------------------------------------------- |
| **`listenerName`** | <code>string</code>                                                 |
| **`callbackFn`**   | <code><a href="#maplistenercallback">MapListenerCallback</a></code> |

**Returns:** <code>Promise&lt;string&gt;</code>

--------------------


### addOverlayImage(...)

```typescript
addOverlayImage(options: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### addOrUpdateMarker(...)

```typescript
addOrUpdateMarker(props: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param       | Type                                 |
| ----------- | ------------------------------------ |
| **`props`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### centerMapByBounds(...)

```typescript
centerMapByBounds(props: { [key: string]: any; }) => Promise<{ status: boolean; }>
```

| Param       | Type                                 |
| ----------- | ------------------------------------ |
| **`props`** | <code>{ [key: string]: any; }</code> |

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### Type Aliases


#### MapListenerCallback

<code>(data: any, err?: any): void</code>


#### CallbackID

<code>string</code>

</docgen-api>
