import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToMany,
    JoinTable,
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';
import { Role } from '../../roles/role.entity';
@Entity('users')
export class User {
    @PrimaryGeneratedColumn('increment')
    id: number;

    @Column({ name: 'first_name', nullable: false })
    firstName: string;

    @Column({ name: 'middle_name', nullable: true })
    middleName?: string;

    @Column({ name: 'last_name', nullable: false })
    lastName: string;

    @Column({ unique: true })
    email: string;

    @Column({ nullable: true })
    phone?: string;

    @Column({ name: 'is_active', default: true })
    isActive: boolean;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @Column({ nullable: false })
    password: string;

    @ManyToMany(() => Role, { eager: false })
    @JoinTable({
        name: 'user_roles',
        joinColumn: { name: 'user_id', referencedColumnName: 'id' },
        inverseJoinColumn: { name: 'role_id', referencedColumnName: 'id' },
    })
    roles: Role[];
}
