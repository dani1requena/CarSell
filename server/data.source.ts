import { DataSource, DataSourceOptions } from 'typeorm';


/*DB_HOST=localhost
DB_PORT=3306
DB_USER=CarManager
DB_PASSWORD=1234
DB_NAME=cochesanuncios*/

export const dbdatasource: DataSourceOptions = {
    type: 'mysql',
    host: 'localhost',  
    port: 3306,     
    username: 'CarManager',
    password: '1234',
    database: 'cochesanuncios',
    synchronize: true,
    entities: [__dirname + '/**/*.entity{.js,.ts}'],
    migrations: ['./data/*.ts'],
    migrationsTableName: "app_migrations"
};

const dataSource = new DataSource(dbdatasource)
export default dataSource