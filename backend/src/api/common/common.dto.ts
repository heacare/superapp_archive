import { Point } from 'geojson';

export class LocationDto {
  lat: number;
  lng: number;

  static fromPoint(pt: Point): LocationDto {
    return new LocationDto(pt.coordinates[0], pt.coordinates[1]);
  }

  constructor(lat: number, lng: number) {
    this.lat = lat;
    this.lng = lng;
  }
}
