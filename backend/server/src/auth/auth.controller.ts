import {
    Body,
    Controller,
    Post,
    Get,
    UseGuards,
    Req,
    NotFoundException,
    Request,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { UsersService } from '../users/users.service';

@Controller('auth')
export class AuthController {
    constructor(
        private readonly authService: AuthService,
        private readonly usersService: UsersService,
    ) { }

    @Post('login')
    async login(
        @Body() body: { email: string; password: string },
    ) {
        const user = await this.authService.validateUser(
            body.email,
            body.password,
        );
        return this.authService.login(user);
    }

    @UseGuards(JwtAuthGuard)
    @Get('me')
    async getMe(@Request() req) {
        const userId = req.user.userId;

        const user = await this.usersService.findByIdWithRoles(userId);

        if (!user) {
            throw new NotFoundException('User not found');
        }

        const roleNames = user.roles?.map(r => r.name) ?? [];

        return user;
        roles: roleNames
    }
}