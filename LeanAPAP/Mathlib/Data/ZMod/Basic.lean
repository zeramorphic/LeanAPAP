import Mathlib.Data.ZMod.Basic

open Fintype Function

namespace ZMod
variable {m n : ℕ}

section
variable {x y : ZMod n}

lemma cast_int_add : (cast (x + y : ZMod n) : ℤ) = (cast x + cast y) % n := by
  rw [← ZMod.coe_intCast, Int.cast_add, ZMod.intCast_zmod_cast, ZMod.intCast_zmod_cast]

lemma cast_int_mul : (cast (x * y : ZMod n) : ℤ) = cast x * cast y % n := by
  rw [← ZMod.coe_intCast, Int.cast_mul, ZMod.intCast_zmod_cast, ZMod.intCast_zmod_cast]

lemma cast_int_sub : (cast (x - y : ZMod n) : ℤ) = (cast x - cast y) % n := by
  rw [← ZMod.coe_intCast, Int.cast_sub, ZMod.intCast_zmod_cast, ZMod.intCast_zmod_cast]

lemma cast_int_neg : (cast (-x : ZMod n) : ℤ) = -cast x % n := by
  rw [← ZMod.coe_intCast, Int.cast_neg, ZMod.intCast_zmod_cast]

end

lemma val_one'' : ∀ {n}, n ≠ 1 → (1 : ZMod n).val = 1
  | 0, _ => rfl
  | 1, hn => by cases hn rfl
  | n + 2, _ =>
    haveI : Fact (1 < n + 2) := ⟨by simp⟩
    ZMod.val_one _

@[simp] protected lemma inv_one (n : ℕ) : (1⁻¹ : ZMod n) = 1 := by
  obtain rfl | hn := eq_or_ne n 1
  · exact Subsingleton.elim _ _
  · simpa [ZMod.val_one'' hn] using mul_inv_eq_gcd (1 : ZMod n)

lemma mul_val_inv (hmn : m.Coprime n) : (m * (m⁻¹ : ZMod n).val : ZMod n) = 1 := by
  obtain rfl | hn := eq_or_ne n 0
  · simp [m.coprime_zero_right.1 hmn]
  haveI : NeZero n := ⟨hn⟩
  rw [ZMod.natCast_zmod_val, ZMod.coe_mul_inv_eq_one _ hmn]

lemma val_inv_mul (hmn : m.Coprime n) : ((m⁻¹ : ZMod n).val * m : ZMod n) = 1 := by
  rw [mul_comm, mul_val_inv hmn]

variable {A : Type*} [AddCommGroup A]

lemma lift_injective {f : {f : ℤ →+ A // f n = 0}} :
    Injective (lift n f) ↔ ∀ i : ℤ, f.1 i = 0 → (i : ZMod n) = 0 := by
  simp only [← AddMonoidHom.ker_eq_bot_iff, eq_bot_iff, SetLike.le_def,
    ZMod.intCast_surjective.forall, ZMod.lift_coe, AddMonoidHom.mem_ker, AddSubgroup.mem_bot]

end ZMod

section Group
variable {α : Type*} [Group α] {n : ℕ}

--TODO: Fix additivisation
lemma pow_zmod_val_inv_pow (hn : (Nat.card α).Coprime n) (a : α) :
    (a ^ (n⁻¹ : ZMod (Nat.card α)).val) ^ n = a := by
  rw [← pow_mul', ← pow_mod_natCard, ← ZMod.val_natCast, Nat.cast_mul, ZMod.mul_val_inv hn.symm,
    ZMod.val_one_eq_one_mod, pow_mod_natCard, pow_one]

lemma pow_pow_zmod_val_inv (hn : (Nat.card α).Coprime n) (a : α) :
    (a ^ n) ^ (n⁻¹ : ZMod (Nat.card α)).val = a := by rw [pow_right_comm, pow_zmod_val_inv_pow hn]

end Group

section AddGroup
variable {α : Type*} [AddGroup α] {n : ℕ}

--TODO: Additivise
@[simp]
lemma nsmul_zmod_val_inv_nsmul (hn : (Nat.card α).Coprime n) (a : α) :
    n • (n⁻¹ : ZMod (Nat.card α)).val • a = a := by
  rw [← mul_nsmul', ← mod_natCard_nsmul, ← ZMod.val_natCast, Nat.cast_mul,
    ZMod.mul_val_inv hn.symm, ZMod.val_one_eq_one_mod, mod_natCard_nsmul, one_nsmul]

@[simp]
lemma zmod_val_inv_nsmul_nsmul (hn : (Nat.card α).Coprime n) (a : α) :
    (n⁻¹ : ZMod (Nat.card α)).val • n • a = a := by
  rw [nsmul_left_comm, nsmul_zmod_val_inv_nsmul hn]

attribute [to_additive (attr := simp) existing nsmul_zmod_val_inv_nsmul] pow_zmod_val_inv_pow
attribute [to_additive (attr := simp) existing zmod_val_inv_nsmul_nsmul] pow_pow_zmod_val_inv

end AddGroup
