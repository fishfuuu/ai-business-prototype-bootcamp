// src/mocks/prototype-data.ts
// AI Prototype Data Contract for Lesson 03 - Lesson 10

export interface PrototypeOrder {
  id: string;
  customerName: string;
  totalAmount: number;
  status: 'PENDING' | 'PAID' | 'COMPLETED' | 'CANCELLED';
  createdAt: string;
}

export const prototypeOrders: PrototypeOrder[] = [
  {
    id: 'ORD-2026-001',
    customerName: '华东业务部',
    totalAmount: 1299.0,
    status: 'COMPLETED',
    createdAt: '2026-08-10 10:00:00'
  },
  {
    id: 'ORD-2026-002',
    customerName: '华南研发中心',
    totalAmount: 4500.5,
    status: 'PAID',
    createdAt: '2026-08-10 11:30:00'
  }
];

export default {
  orders: prototypeOrders
};
