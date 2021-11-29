import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

@Injectable()
export class UserService {
  constructor(@InjectRepository(User) private users: Repository<User>) {}

  async findOne(id: number): Promise<User> {
    return await this.users.findOne(id);
  }

  async findOrCreate(authId: string): Promise<User> {
    const user = await this.users.findOne({ authId });
    if (user !== undefined) return user;
    return await this.users.save(User.uninit(authId));
  }
}
