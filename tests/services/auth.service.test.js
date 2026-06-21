const authService = require('../../src/modules/auth/auth.service');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

jest.mock('bcrypt');
jest.mock('jsonwebtoken');

describe('Auth Service', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('login', () => {
    it('should throw an error if user is not found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      await expect(authService.login('test@example.com', 'password123')).rejects.toThrow('Invalid email or password');
    });

    it('should throw an error if password does not match', async () => {
      const mockUser = {
        id: '123',
        email: 'test@example.com',
        passwordHash: 'hashedpassword',
      };
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      bcrypt.compare.mockResolvedValue(false);

      await expect(authService.login('test@example.com', 'wrongpassword')).rejects.toThrow('Invalid email or password');
    });

    it('should return tokens and user info on successful login', async () => {
      const mockUser = {
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        passwordHash: 'hashedpassword',
        role: 'USER',
      };
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      bcrypt.compare.mockResolvedValue(true);
      
      jwt.sign
        .mockReturnValueOnce('mockAccessToken')
        .mockReturnValueOnce('mockRefreshToken');

      prismaMock.refreshToken.deleteMany.mockReturnValue({ catch: jest.fn() });
      prismaMock.refreshToken.create.mockResolvedValue({});

      const result = await authService.login('test@example.com', 'correctpassword');

      expect(result).toHaveProperty('accessToken');
      expect(result).toHaveProperty('refreshToken');
      expect(result.user).toEqual({ id: '123', username: 'testuser', email: 'test@example.com', role: 'USER' });
    });
  });

  describe('register', () => {
    it('should throw an error if email or username already exists', async () => {
      prismaMock.user.findFirst.mockResolvedValue({ id: '123' });

      const data = { username: 'testuser', email: 'test@example.com', password: 'password123' };
      await expect(authService.register(data)).rejects.toThrow('Email or username already exists');
    });

    it('should successfully register a new user', async () => {
      prismaMock.user.findFirst.mockResolvedValue(null);
      bcrypt.hash.mockResolvedValue('hashedpassword');
      prismaMock.user.create.mockResolvedValue({
        id: '123',
        username: 'newuser',
        email: 'new@example.com',
        role: 'USER',
        passwordHash: 'hashedpassword',
      });

      const data = { username: 'newuser', email: 'new@example.com', password: 'password123' };
      const result = await authService.register(data);

      expect(result).toEqual({
        id: '123',
        username: 'newuser',
        email: 'new@example.com',
        role: 'USER',
      });
      expect(prismaMock.user.create).toHaveBeenCalledWith(expect.objectContaining({
        data: expect.objectContaining({ username: 'newuser' }),
      }));
    });
  });
});
