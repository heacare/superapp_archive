import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Onboarding, Smoker } from './onboarding.dto';
import { User } from './user.entity';

@Injectable()
export class UserService {
  constructor(@InjectRepository(User) private users: Repository<User>) {}

  async findOne(id: number): Promise<User> {
    return await this.users.findOneOrFail(id);
  }

  async findOrCreate(authId: string): Promise<User> {
    const user = await this.users.findOne({ authId });
    if (user !== undefined) return user;
    return await this.users.save(User.uninit(authId));
  }

  async update(id: number, onboarding: Onboarding) {
    const smokingInfo: Partial<User> = {
      isSmoker: false,
      smokingPacksPerDay: null,
      smokingYears: null,
    };

    if (onboarding.smoking instanceof Smoker) {
      smokingInfo.isSmoker = onboarding.smoking.isSmoker;
      smokingInfo.smokingPacksPerDay = onboarding.smoking.packsPerDay;
      smokingInfo.smokingYears = onboarding.smoking.yearsSmoking;
    }

    this.users.update(id, {
      alcoholFreq: onboarding.alcoholFreq,
      name: onboarding.name,
      gender: onboarding.gender,
      birthday: onboarding.birthday,
      height: onboarding.height,
      weight: onboarding.weight,
      country: onboarding.country,
      outlook: onboarding.outlook,
      maritalStatus: onboarding.maritalStatus,
      familyHistory: onboarding.familyHistory,
      birthControl: onboarding.birthControl,
      ...smokingInfo,
    });
  }
}
