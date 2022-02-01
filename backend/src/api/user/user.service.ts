import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuthUser } from '../auth/auth.strategy';
import { OnboardingDto } from './onboarding.dto';
import { User } from './user.entity';

@Injectable()
export class UserService {
  constructor(@InjectRepository(User) private users: Repository<User>) {}

  async findOne(user: AuthUser): Promise<User> {
    return await this.users.findOneOrFail(user.id);
  }

  async findOrCreate(authId: string): Promise<User> {
    const user = await this.users.findOne({ authId });
    if (user !== undefined) return user;
    return await this.users.save(User.uninit(authId));
  }

  async update(user: AuthUser, onboarding: OnboardingDto) {
    const smokingInfo: Partial<User> = {
      isSmoker: false,
      smokingPacksPerDay: null,
      smokingYears: null,
    };

    if (onboarding.smoking !== null) {
      smokingInfo.isSmoker = true;
      smokingInfo.smokingPacksPerDay = onboarding.smoking.packsPerDay;
      smokingInfo.smokingYears = onboarding.smoking.years;
    }

    this.users.update(user.id, {
      alcoholFreq: onboarding.alcoholFreq,
      level: 'filledv1',
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
