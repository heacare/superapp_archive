export interface OAuthInfo {
  client_id: string;
  redirect_uri: string;
  state?: string;
}

export interface AccessToken {
  access_token: string;
  workspace_id: string;
  workspace_name: string;
  workspace_icon: string;
  bot_id: string;
  owner:
    | {
        type: 'person';
        person: { email: string };
        name: string | null;
        avatar_url: string | null;
        id: string;
        object: 'user';
      }
    | { type: 'workspace'; workspace: true };
}
