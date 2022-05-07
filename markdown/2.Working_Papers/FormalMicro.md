+10

# Formalizing Microeconomic Foundations

## Code Repository

[GitHub Repository](https://github.com/gregleo-econ/formal-microeconoimcs)

## About

This is a project to formalize the foundations of microeconomic theory in the [Lean](https://leanprover.github.io/) theorem prover. 

## What is Lean?

[Lean](https://leanprover.github.io/) is a programming language that implements a variation of dependent type theory. Lean has been used to formalize and validate a [huge variety of mathematics](https://leanprover-community.github.io/mathlib-overview.html).

A Lean proof looks very little like a normal "paper" proof. For instace, here is our proof of *Proposition 1.9 f* from Kreps' *Microeconomic Foundations I*. 

If $x \sim y$ and $y \sim z$ then $x \sim z$.

```
import tactic

section

parameters {A : Type} {R : A ? A ? Prop}

/- Defininig Complete Relations -/
def complete (R : A ? A ? Prop) : Prop :=
? x y, R x y ? R y x

/- Defininig Incomplete Relations -/
def incomplete (R : A ? A ? Prop) : Prop :=
? x y, ¬ (R x y ? R y x)

/- Defininig S the Strict Preference Relation-/
def S (a b : A) : Prop := R a b ? ¬ R b a

/- Defininig the Indifference Relation-/
def I (a b : A) : Prop := R a b ? R b a

/- 1.9 f -/
theorem propf [compR : complete R] [trnsR : transitive R][x : A][y : A][z : A]: (I x y ? I y z) ? I x z :=
begin
intro ixyandiyz,
cases ixyandiyz,
cases ixyandiyz_right, cases ixyandiyz_left,
constructor,
tauto,
tauto,
end
```


