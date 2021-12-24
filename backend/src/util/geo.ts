export function isWithinRadius(field: string, arg: string, radiusField: string): string {
  return `ST_DWithin(${field}, ST_SetSRID(ST_GeomFromGeoJSON(:${arg}), ST_SRID(${field})) ,:${radiusField})`;
}
