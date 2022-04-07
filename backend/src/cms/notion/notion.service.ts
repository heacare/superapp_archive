import fetch from 'node-fetch';
import { Injectable } from '@nestjs/common';
import { OAuthInfo, AccessToken } from './notion.entity';

const NOTION_BASE_URI = process.env.NOTION_BASE_URI || 'https://api.notion.com/v1';
const NOTION_CLIENT_ID = process.env.NOTION_CLIENT_ID || '056bcfe0-4c13-42d2-8c00-7bc9462ebdea';
const NOTION_CLIENT_SECRET = process.env.NOTION_CLIENT_SECRET || '';
const CMS_REDIRECT_URI = process.env.CMS_REDIRECT_URI || 'https://api.alpha.hea.care/cms/auth';

@Injectable()
export class NotionService {
  getOAuthInfo(): OAuthInfo {
    return { client_id: NOTION_CLIENT_ID, redirect_uri: CMS_REDIRECT_URI, state: '' };
  }
  async getAccessFromGrant(code: string): Promise<AccessToken> {
    const resp = await fetch(NOTION_BASE_URI + '/oauth/token', {
      method: 'post',
      headers: {
        authorization: `Basic ${btoa(NOTION_CLIENT_ID + ':' + NOTION_CLIENT_SECRET)}`,
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        grant_type: 'authorization_code',
        code,
        redirect_uri: CMS_REDIRECT_URI,
      }),
    });
    if (!resp.ok) {
      throw new Error('Unable to authorize');
    }
    return (await resp.json()) as AccessToken;
  }
}
