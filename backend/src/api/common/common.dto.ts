import { Type } from 'class-transformer';
import { IsNumber } from 'class-validator';
import { Point } from 'geojson';

export class LocationDto {
  @Type(() => Number)
  @IsNumber()
  lat: number;

  @Type(() => Number)
  @IsNumber()
  lng: number;

  static fromPoint(pt: Point): LocationDto {
    return new LocationDto(pt.coordinates[0], pt.coordinates[1]);
  }

  toPoint(): Point {
    if (typeof this.lng !== 'number' || typeof this.lat !== 'number') throw new Error('Invalid Point');
    return {
      type: 'Point',
      coordinates: [this.lat, this.lng],
    };
  }

  constructor(lat: number, lng: number) {
    this.lat = lat;
    this.lng = lng;
  }
}