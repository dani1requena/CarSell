import {Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn, Index, Unique} from 'typeorm';
import { User } from './user.entity';

@Entity({name: 'profile_user'})
export class Profile{
    @PrimaryGeneratedColumn()
    id: number

    @Column()
    name: string

    @Column({nullable: true})
    lastname: string

    @Column()
    telephone: string

    @OneToOne(() => User)
    @JoinColumn()
    user: User
}
