import { Entity, Column, PrimaryGeneratedColumn, OneToOne, JoinColumn, OneToMany } from 'typeorm';
import { Profile } from './profile_user.entity';
import { Car } from 'src/posts/Car.entity';

@Entity({name: 'users'})
export class User{
    @PrimaryGeneratedColumn()
    id: number

    @Column({unique:true})
    username: string

    @Column()
    password: string

    @Column()
    email: string

    @Column({type: 'datetime', default: () => 'CURRENT_TIMESTAMP'})
    createdAt: Date
    
    @OneToOne(() => Profile)
    @JoinColumn()
    profile: Profile

    @OneToMany(() => Car, post => post.author)
    posts: Car[]
}