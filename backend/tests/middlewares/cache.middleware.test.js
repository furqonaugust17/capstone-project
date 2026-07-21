'use strict';

const cacheMiddleware = require('../../src/middlewares/cache.middleware');
const redis = require('../../src/config/redis');

jest.mock('../../src/config/redis', () => ({
  redisClient: {
    get: jest.fn(),
    set: jest.fn().mockResolvedValue(),
  }
}));

describe('Cache Middleware', () => {
  let req, res, next;

  beforeEach(() => {
    req = { originalUrl: '/api/test' };
    res = {
      json: jest.fn(),
      send: jest.fn(),
      status: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
    jest.clearAllMocks();
  });

  it('should call next if REDIS_URL is not provided or redis is disconnected', async () => {
    // Assuming redis is exported but its status is checked via some internal or catch block
    redis.redisClient.get.mockRejectedValue(new Error('Redis disconnected'));
    
    const middleware = cacheMiddleware('test-prefix', 60);
    await middleware(req, res, next);
    
    expect(next).toHaveBeenCalled();
  });

  it('should return cached data if found in Redis', async () => {
    const cachedData = { data: 'some-data' };
    redis.redisClient.get.mockResolvedValue(JSON.stringify(cachedData));

    const middleware = cacheMiddleware('test-prefix', 60);
    await middleware(req, res, next);

    expect(redis.redisClient.get).toHaveBeenCalledWith('test-prefix:/api/test');
    expect(res.json).toHaveBeenCalledWith(cachedData);
    expect(next).not.toHaveBeenCalled();
  });

  it('should wrap res.json and store data in Redis if not cached', async () => {
    redis.redisClient.get.mockResolvedValue(null);

    const middleware = cacheMiddleware('test-prefix', 60);
    await middleware(req, res, next);

    expect(redis.redisClient.get).toHaveBeenCalledWith('test-prefix:/api/test');
    expect(next).toHaveBeenCalled();

    // Simulate calling res.json in the controller
    const responseData = { success: true };
    res.statusCode = 200; // Important for checking cache storage logic
    res.json(responseData);

    expect(redis.redisClient.set).toHaveBeenCalledWith(
      'test-prefix:/api/test',
      JSON.stringify(responseData),
      'EX',
      60
    );
  });
});
