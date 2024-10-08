import { registerPlugin } from '@capacitor/core';

import type { CapacitorMapboxPlugin } from './definitions';

const CapacitorMapbox = registerPlugin<CapacitorMapboxPlugin>('CapacitorMapbox', {
  web: () => import('./web').then((m) => new m.CapacitorMapboxWeb()),
});

export * from './definitions';
export { CapacitorMapbox };
