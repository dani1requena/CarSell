//NodeJs.processEnv

declare namespace NodeJS{
    interface ProcessEnv{
        HASH_SALT:number;
        JWT_SECRET: string;
    }
}