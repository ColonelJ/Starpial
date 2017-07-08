?>>>AGDA
-- definition of Existential Type
data ∃ {A : Set} (B : A → Set) : Set where
     _,_ : (x₁ : A) → B x₁ → ∃ \(x : A) → B x


-- left projection
p : {A : Set} {B : A → Set} → (∃ \(x : A) → B x) → A
p {A} {B} (a , b) = a

-- right projection
q : {A : Set} {B : A → Set} → (c : ∃ \(x : A) → B x) → B (p c)
q {A} {B} (a , b) = b


axiom-of-choice : {A : Set} {B : A → Set} {C : (x : A) → B x → Set}
  → (∀(x : A) → ∃ \(y : (B x)) → C x y)
  → ∃ \(f : ∀(x : A) → B x) → ∀(x : A) → C x (f x)
axiom-of-choice {A} {B} {C} z = f , g
  where
    f : ∀(x : A) → B x
    f x = p (z x)
    g : ∀(x : A) → C x (f x)
    g x = q (z x)
<<<?

?\ Definition of Existential type
?@exists?[`?A?set #B?[A => set] {#x?A => (B(x))}]
@Exists:`?A `@B #x?A #y?[B(x)] {x, y}?![exists[#x?A B(x)]]

?\ Left projection
@p?[`?A `@B exists[#x?A B(x)] => A]:#{x, y} x

?\ Right projection
@q?[`?A `@B #c?[exists[#x?A B(x)]] => B(p(c))]:#{x, y} y

@axiom_of_choice?[`?A?set `?B?[A => set] `?C?[#x?A B(x) => set]
                  [#x?A => exists[#y?[B(x)] C(x, y)]]
                  => exists[#f?[#x?A => B(x)] [#x?A => C(x, f(x))]]]:
    `?A?set `?B?[A => set] `?C?[#x?A B(x) => set] #z
    Exists(f, g)
    @f?[#x?A B(x)]:#x p(z(x))
    @g?[#x?A C(x, f(x))]:#x q(z(x))
