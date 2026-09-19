class_name CombatDefs
extends Object

enum AttackType { LIGHT, HEAVY, THRUST, JUMP, SKILL }
enum GuardState { NONE, BLOCK, PERFECT }

const IFRAME_DODGE := 0.28
const STAMINA_REGEN := 28.0
const STAMINA_REGEN_DELAY := 0.85
const POISE_REGEN := 18.0
const PERFECT_GUARD_WINDOW := 0.12
