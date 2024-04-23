import { User } from "src/users/user.entity"
import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn} from "typeorm"

@Entity({name:'cars'})
export class Car{
    @PrimaryGeneratedColumn()
    id: number

    @Column({ nullable: true })
    photo: string

    @Column()
    brand: string

    @Column()
    kilometer: number

    @Column()
    horsepower: number
    
    @Column()
    authorId: number;

    @Column({type: 'datetime', default: ()=> 'CURRENT_TIMESTAMP'})
    createdAt: Date

    @ManyToOne(() => User, user => user.posts)
    @JoinColumn({ name: 'authorId' })
    author: User
}