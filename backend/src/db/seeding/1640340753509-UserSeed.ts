import { MigrationInterface, QueryRunner } from 'typeorm';
import { AlcoholFrequency, Gender, MaritalStatus, Outlook, SmokingPacks } from 'src/api/user/onboarding.dto';
import { User } from 'src/api/user/user.entity';

/*
 *  Template generated with `npx typeorm migration:create --name UserSeed`
 */

// Test User
// JWT: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTY0MDM0MDk5NH0.XwcJ-lUFCHvOPnUrRQ6WAwdTsV-KYezKR9K3hmS6p2s
const AUTH_UID = 'EZK2g6LQaFaGzLEbUxQp3Rfzssl1';

export class UserSeed1640340753509 implements MigrationInterface {
  public async up({ connection }: QueryRunner): Promise<void> {
    console.log('Seeding users...');

    const user = new User();
    user.authId = AUTH_UID;
    user.level = 'filledv1';
    user.healthData = [{ data_type: 'Health Data Type', value: 'Value', unit: 'Unit' }];
    user.icon = null; // default icon

    // Onboarding data
    user.name = 'Test User';
    user.gender = Gender.Male;
    user.birthday = new Date();
    user.height = 1.8;
    user.weight = 100;
    user.country = 'SG';
    user.isSmoker = true;
    user.smokingPacksPerDay = SmokingPacks.LessOnePack;
    user.smokingYears = 10;
    user.alcoholFreq = AlcoholFrequency.NotAtAll;
    user.outlook = Outlook.Soulless;
    user.maritalStatus = MaritalStatus.Single;
    user.familyHistory = 'Family History';
    user.birthControl = 'Birth Control';

    connection.getRepository(User).create(user);
    await connection.getRepository(User).save(user);
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  public async down(queryRunner: QueryRunner): Promise<void> {
    // No need to implement
  }
}
