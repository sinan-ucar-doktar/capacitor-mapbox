import { WebPlugin } from '@capacitor/core';

import type { CapacitorMapboxPlugin } from './definitions';

export class CapacitorMapboxWeb extends WebPlugin implements CapacitorMapboxPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
