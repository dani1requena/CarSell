// import { Injectable, NestMiddleware, UnauthorizedException } from '@nestjs/common';
// import { Request, Response, NextFunction } from 'express';
// import { AuthService } from './auth.service';

// @Injectable()
// export class AuthMiddleware implements NestMiddleware {
//   constructor(private readonly authService: AuthService) {} 

//   async use(req: Request, res: Response, next: NextFunction) {
//     try {
//       const { username, password } = req.body; 
//       const user = await this.authService.validateUser(username, password);
      
//       if (!user) {
//         throw new UnauthorizedException('Invalid credentials');
//       }

//       req.user = user;
//       next();
//     } catch (error) {
//       next(error); // Pasa el error al siguiente middleware para su manejo
//     }
//   }
// }