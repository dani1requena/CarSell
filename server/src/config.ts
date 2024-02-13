import {registerAs} from '@nestjs/config';
import * as dotenv from 'dotenv';

dotenv.config({ path: '.develop.env' });

export default registerAs ('config', () =>{
    return{
        JWT_SECRET: process.env.JWT_SECRET
    };
});