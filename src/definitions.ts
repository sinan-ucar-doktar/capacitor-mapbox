export interface CapacitorMapboxPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
