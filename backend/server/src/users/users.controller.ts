import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';

@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) { }

    @Get()
    getAllUsers(): Promise<User[]> {
        return this.usersService.findAll();
    }

    @Get(':id')
    getUserById(
        @Param('id', ParseIntPipe) id: number,
    ): Promise<User | null> {
        return this.usersService.findById(id);
    }
}
