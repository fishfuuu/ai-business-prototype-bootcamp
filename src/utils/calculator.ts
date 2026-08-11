// src/utils/calculator.ts
// Deterministic Calculation Engine (Zero AI Randomness / Locked by HOOK_LOCK_DETERMINISTIC_CALC)

export interface CalculationInput {
  unitPrice: number;
  quantity: number;
  discountRate?: number; // e.g. 0.9 for 10% off
}

export interface CalculationResult {
  subtotal: number;
  discountAmount: number;
  totalAmount: number;
}

/**
 * Deterministic total price calculation
 * @param input Calculation parameters
 * @returns CalculationResult 100% deterministic calculation
 */
export function calculateTotal(input: CalculationInput): CalculationResult {
  const price = Math.max(0, input.unitPrice || 0);
  const qty = Math.max(0, Math.floor(input.quantity || 0));
  const discount = Math.min(1, Math.max(0, input.discountRate ?? 1.0));

  const subtotal = Math.round(price * qty * 100) / 100;
  const totalAmount = Math.round(subtotal * discount * 100) / 100;
  const discountAmount = Math.round((subtotal - totalAmount) * 100) / 100;

  return {
    subtotal,
    discountAmount,
    totalAmount
  };
}

export default {
  calculateTotal
};
