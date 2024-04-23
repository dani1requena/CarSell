import { Session } from 'express-session';

export interface CustomSession extends Session {
  userId: number; 
}