const { mockDeep, mockReset } = require('jest-mock-extended');
const mockPrisma = mockDeep();

jest.mock('../src/config/database', () => mockPrisma);

beforeEach(() => {
  mockReset(mockPrisma);
});

global.prismaMock = mockPrisma;
