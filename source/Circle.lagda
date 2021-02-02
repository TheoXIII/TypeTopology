Tom de Jong, 28 January 2020
\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import SpartanMLTT
open import UF-Base
open import Integers

open import UF-Embeddings
open import UF-Equiv hiding (_≅_)
open import UF-EquivalenceExamples
open import UF-Equiv-FunExt
open import UF-FunExt
open import UF-Lower-FunExt
open import UF-Subsingletons
open import UF-Subsingletons-FunExt
open import UF-Retracts

open import UF-PropTrunc
open import UF-Univalence
open import UF-UA-FunExt

open import UF-SIP -- Maybe use MGS-SIP?

module Circle
        (pt : propositional-truncations-exist)
        (ua : is-univalent 𝓤₀)
       where

-- TO DO: Move this somewhere

∙-is-equiv₁ : {X : 𝓤 ̇ } {x y : X} (p : x ≡ x)
            → is-equiv (λ (q : x ≡ y) → p ∙ q)
∙-is-equiv₁ {𝓤} {X} {x} {y} p =
 qinvs-are-equivs (λ q → p ∙ q) ((λ q → p ⁻¹ ∙ q) , η , ε)
  where
   ε : (q : x ≡ y) → p ∙ (p ⁻¹ ∙ q) ≡ q
   ε q = p ∙ (p ⁻¹ ∙ q) ≡⟨ (∙assoc p (p ⁻¹) q) ⁻¹                  ⟩
         (p ∙ p ⁻¹) ∙ q ≡⟨ ap (λ - → - ∙ q) ((right-inverse p) ⁻¹) ⟩
         refl ∙ q       ≡⟨ refl-left-neutral                       ⟩
         q              ∎
   η : (q : x ≡ y) → p ⁻¹ ∙ (p ∙ q) ≡ q
   η q = p ⁻¹ ∙ (p ∙ q) ≡⟨ (∙assoc (p ⁻¹) p q) ⁻¹            ⟩
         (p ⁻¹ ∙ p) ∙ q ≡⟨ ap (λ - → - ∙ q) (left-inverse p) ⟩
         refl ∙ q       ≡⟨ refl-left-neutral                 ⟩
         q              ∎

open PropositionalTruncation pt
open sip
open sip-with-axioms

Tℤ : 𝓤₁ ̇
Tℤ = Σ X ꞉ 𝓤₀ ̇ , Σ f ꞉ (X → X) , ∥ (X , f) ≡ (ℤ , succ-ℤ) ∥

base : Tℤ
base = (ℤ , succ-ℤ , ∣ refl ∣)

Tℤ-structure : 𝓤₀ ̇ → 𝓤₀ ̇
Tℤ-structure X = X → X

Tℤ⁻ : 𝓤₁ ̇
Tℤ⁻ = Σ X ꞉ 𝓤₀ ̇ , Tℤ-structure X

sns-data : SNS Tℤ-structure 𝓤₀
sns-data = (ι , ρ , θ)
 where
  ι : (X Y : Tℤ⁻) → ⟨ X ⟩ ≃ ⟨ Y ⟩ → 𝓤₀ ̇
  ι (X , f) (Y , g) (e , _) = e ∘ f ≡ g ∘ e
  ρ : (X : Tℤ⁻) → ι X X (≃-refl ⟨ X ⟩)
  ρ (X , f) = refl
  h : {X : 𝓤₀ ̇ } {f g : Tℤ-structure X}
    → canonical-map ι ρ f g ∼ id {𝓤₀} {f ≡ g}
  h refl = refl
  θ : {X : 𝓤₀ ̇} (f g : Tℤ-structure X)
    → is-equiv (canonical-map ι ρ f g)
  θ f g = equiv-closed-under-∼ _ _ (id-is-equiv (f ≡ g)) h

{-
_≃[Tℤ]_ : Tℤ → Tℤ → 𝓤₀ ̇
(X , f , _) ≃[Tℤ] (Y , g , _) = Σ e ꞉ (X → Y) , is-equiv e
                                              × (e ∘ f ≡ g ∘ e)
-}

_≅_ : Tℤ → Tℤ → 𝓤₀ ̇
(X , f , _) ≅ (Y , g , _) = Σ e ꞉ (X → Y) , is-equiv e
                                          × (e ∘ f ≡ g ∘ e)
{-



(base ≡ base) ≃ Σ e ꞉ (ℤ → ℤ) , is-equiv e
                             × (e ∘ succ-ℤ ≡ succ-ℤ e)
             ≃  Σ e ꞉ (ℤ → ℤ) , is-equiv e
                             × (e ∼ λ x → e 𝟎 +ℤ x)
             ≃  Σ e ꞉ (ℤ → ℤ) , is-equiv e
                             × (e ≡ λ x → e 𝟎 +ℤ x)
             ≃  Σ e ꞉ (ℤ → ℤ) , (e ∼ λ x → e 𝟎 +ℤ x)
             ≃ ℤ

-}

{-
characterization-of-Tℤ-≡' : (X Y : Tℤ)
                          → (X ≡ Y) ≃ (X ≃[Tℤ] Y)
characterization-of-Tℤ-≡' =
 characterization-of-≡-with-axioms ua
  sns-data
  (λ X f → ∥ (X , f) ≡ (ℤ , succ-ℤ) ∥)
  (λ X f → ∥∥-is-prop)
-}

characterization-of-Tℤ-≡ : (X Y : Tℤ)
                         → (X ≡ Y) ≃ (X ≅ Y)
characterization-of-Tℤ-≡ =
 characterization-of-≡-with-axioms ua
  sns-data
  (λ X f → ∥ (X , f) ≡ (ℤ , succ-ℤ) ∥)
  (λ X f → ∥∥-is-prop)

to-Tℤ-≡ : (X Y : Tℤ) → X ≅ Y → X ≡ Y
to-Tℤ-≡ X Y = ⌜ ≃-sym (characterization-of-Tℤ-≡ X Y) ⌝

{-
to-Tℤ-≡' : (X Y : Tℤ) → X ≃[Tℤ] Y → X ≡ Y
to-Tℤ-≡' X Y = ⌜ ≃-sym (characterization-of-Tℤ-≡' X Y) ⌝

_≃[Tℤ⁻]_ : Tℤ⁻ → Tℤ⁻ → 𝓤₀ ̇
(X , f) ≃[Tℤ⁻] (Y , g) = Σ e ꞉ (X → Y) , is-equiv e
                                  × (e ∘ f ≡ g ∘ e)
-}

loop : base ≡ base
loop = to-Tℤ-≡ base base (succ-ℤ , succ-ℤ-is-equiv , refl)

\end{code}

\begin{code}

fundamental-group-of-circle-is-ℤ : (base ≡ base) ≃ ℤ
fundamental-group-of-circle-is-ℤ =
 (base ≡ base)                                            ≃⟨ I   ⟩
 (Σ e ꞉ (ℤ → ℤ) , is-equiv e × (e ∘ succ-ℤ ≡ succ-ℤ ∘ e)) ≃⟨ II  ⟩
 (Σ e ꞉ (ℤ → ℤ) , is-equiv e × (e ∘ succ-ℤ ∼ succ-ℤ ∘ e)) ≃⟨ III ⟩
 (Σ e ꞉ (ℤ → ℤ) , (e ∘ succ-ℤ ∼ succ-ℤ ∘ e) × is-equiv e) ≃⟨ IV  ⟩
 (Σ e ꞉ (ℤ → ℤ) , (e ∘ succ-ℤ ∼ succ-ℤ ∘ e))              ≃⟨ V   ⟩
 ℤ                                                        ■
  where
   fe : funext 𝓤₀ 𝓤₀
   fe = univalence-gives-funext ua
   I   = characterization-of-Tℤ-≡ base base
   II  = Σ-cong (λ e → ×-cong (≃-refl (is-equiv e))
                              (≃-funext fe (e ∘ succ-ℤ) (succ-ℤ ∘ e)))
   III = Σ-cong (λ e → ×-comm)
   IV  = Σ-cong γ
    where
     γ : (e : ℤ → ℤ)
       → (e ∘ succ-ℤ ∼ succ-ℤ ∘ e) × is-equiv e
       ≃ (e ∘ succ-ℤ ∼ succ-ℤ ∘ e)
     γ e = qinveq pr₁ (ϕ , η , ε)
      where
       ϕ : e ∘ succ-ℤ ∼ succ-ℤ ∘ e
         → (e ∘ succ-ℤ ∼ succ-ℤ ∘ e) × is-equiv e
       ϕ c = (c , commute-with-succ-ℤ-equiv e c)
       η : ϕ ∘ pr₁ ∼ id
       η (i , c) = to-subtype-≡ (λ _ → being-equiv-is-prop' fe fe fe fe e) refl
       ε : pr₁ ∘ ϕ ∼ id
       ε _ = refl
   V   = ℤ-symmetric-induction fe (λ _ → ℤ) (λ _ → succ-ℤ-≃)

\end{code}

\begin{code}

Tℤ-≡-to-≃-of-carriers : {X Y : Tℤ} → X ≡ Y → ⟨ X ⟩ ≃ ⟨ Y ⟩
Tℤ-≡-to-≃-of-carriers p = pr₁ c , pr₁ (pr₂ c)
 where
  c = ⌜ characterization-of-Tℤ-≡ _ _ ⌝ p

yyy : {X Y : Tℤ} (p : X ≡ Y)
    → idtoeq ⟨ X ⟩ ⟨ Y ⟩ (ap ⟨_⟩ p) ≡ Tℤ-≡-to-≃-of-carriers p
yyy refl = refl

xxx : idtoeq ℤ ℤ (ap ⟨_⟩ loop) ≡ succ-ℤ-≃
xxx = idtoeq ℤ ℤ (ap ⟨_⟩ loop) ≡⟨ yyy loop ⟩
      Tℤ-≡-to-≃-of-carriers loop ≡⟨ refl ⟩
       pr₁ (ϕ loop) , pr₁ (pr₂ (ϕ loop)) ≡⟨ refl ⟩
       pr₁ (ϕ (ψ l)) , pr₁ (pr₂ (ϕ (ψ l))) ≡⟨ ap (λ - → pr₁ - , pr₁ (pr₂ -)) (s l) ⟩
       pr₁ l , pr₁ (pr₂ l) ∎
 where
  ϕ : base ≡ base → base ≅ base
  ϕ = ⌜ characterization-of-Tℤ-≡ base base ⌝
  ψ : base ≅ base → base ≡ base
  ψ = ⌜ ≃-sym (characterization-of-Tℤ-≡ base base) ⌝
  s : ϕ ∘ ψ ∼ id
  s = inverses-are-sections ϕ (⌜⌝-is-equiv (characterization-of-Tℤ-≡ base base))
  l : base ≅ base
  l = (succ-ℤ , succ-ℤ-is-equiv , refl)

module Tℤ-rec
        {A : 𝓤 ̇ }
        (fe : funext 𝓤 𝓤)
        {a : A}
        (p : a ≡ a)
       where

 Qₚ : (Σ X ꞉ 𝓤₀ ̇ , (X → X)) → 𝓤 ̇
 Qₚ (X , f) = Σ a' ꞉ A , Σ h ꞉ (X → a ≡ a') , ((x : X) → h (f x) ≡ p ∙ h x)

 Qₚ-base : 𝓤 ̇
 Qₚ-base = Qₚ (ℤ , succ-ℤ)

 Qₚ-base-is-singleton : is-singleton Qₚ-base
 Qₚ-base-is-singleton = equiv-to-singleton ϕ (singleton-types-are-singletons a)
  where
   ϕ : Qₚ-base ≃ singleton-type a
   ϕ = Σ-cong ψ
    where
     ψ : (a' : A)
       → (Σ h ꞉ (ℤ → a ≡ a') , ((z : ℤ) → h (succ-ℤ z) ≡ p ∙ h z))
       ≃ (a ≡ a')
     ψ a' = ℤ-symmetric-induction (lower-funext 𝓤 𝓤 fe)
             (λ (_ : ℤ) → a ≡ a') (λ (_ : ℤ) → g)
      where
       g : (a ≡ a') ≃ (a ≡ a')
       g = (λ q → p ∙ q) , (∙-is-equiv₁ p)

 cₚ-base : Qₚ-base
 cₚ-base = center (Qₚ-base-is-singleton)

 cₚ¹-base : A
 cₚ¹-base = pr₁ cₚ-base

 cₚ²-base : ℤ → a ≡ cₚ¹-base
 cₚ²-base = pr₁ (pr₂ (cₚ-base))

 cₚ³-base : (z : ℤ) → cₚ²-base (succ-ℤ z) ≡ p ∙ cₚ²-base z
 cₚ³-base = pr₂ (pr₂ (cₚ-base))

 ∥∥-rec-comp : {𝓤 𝓥 : Universe} {X : 𝓤 ̇ } {P : 𝓥 ̇ }
               (i : is-prop P) (f : X → P) (x : X)
             → ∥∥-rec i f ∣ x ∣ ≡ f x
 ∥∥-rec-comp i f x = i (∥∥-rec i f ∣ x ∣) (f x)

 Qₚ-is-singleton : ((X , f , t) : Tℤ)
                 → is-singleton (Qₚ (X , f))
 Qₚ-is-singleton (X , f , t) = ∥∥-rec (being-singleton-is-prop fe) γ t
  where
   γ : (X , f) ≡ (ℤ , succ-ℤ) → is-singleton (Qₚ (X , f))
   γ refl = Qₚ-base-is-singleton

 cₚ : ((X , f , _) : Tℤ) → Qₚ (X , f)
 cₚ (X , f , t) =
  ∥∥-rec (singletons-are-props (Qₚ-is-singleton (X , f , t)))
   (λ e → back-transport Qₚ e cₚ-base) t

{-
 cₚ-on-base : cₚ base ≡ cₚ-base
 cₚ-on-base = ∥∥-rec-comp (singletons-are-props (Qₚ-is-singleton base))
  (λ e → back-transport Qₚ e cₚ-base) refl
-}

 cₚ¹ : Tℤ → A
 cₚ¹ X = pr₁ (cₚ X)

{-
 cₚ¹-on-base : cₚ¹ base ≡ cₚ¹-base
 cₚ¹-on-base = ap pr₁ cₚ-on-base
-}

 cₚ² : (X : Tℤ) → (⟨ X ⟩ → a ≡ cₚ¹ X)
 cₚ² X = pr₁ (pr₂ (cₚ X))

{-
 cₚ²-on-base : cₚ² base ≡ back-transport (λ - → ℤ → a ≡ -) cₚ¹-on-base cₚ²-base
 cₚ²-on-base = {!!}
-}

 ⟨_⟩₂ : (X : Tℤ) → ⟨ X ⟩ → ⟨ X ⟩
 ⟨ (X , f , _) ⟩₂ = f

 cₚ³ : (X : Tℤ) → (x : ⟨ X ⟩)
     → cₚ² X (⟨ X ⟩₂ x) ≡ p ∙ cₚ² X x
 cₚ³ X = pr₂ (pr₂ (cₚ X))

 lemma : {X Y : Tℤ} (e : X ≡ Y) (x : ⟨ X ⟩)
       → ap cₚ¹ e
       ≡ (cₚ² X x) ⁻¹ ∙ cₚ² Y (⌜ idtoeq ⟨ X ⟩ ⟨ Y ⟩ (ap ⟨_⟩ e) ⌝ x)
 lemma {X} {Y} refl x =
  ap cₚ¹ refl                                  ≡⟨ refl ⟩
  refl                                         ≡⟨ left-inverse (cₚ² X x) ⁻¹ ⟩
  (cₚ² X x) ⁻¹ ∙ cₚ² X x                       ≡⟨ refl ⟩
  (cₚ² X x) ⁻¹ ∙ cₚ² X (⌜ idtoeq _ _ refl ⌝ x) ∎

 lemma' : ap cₚ¹ loop ≡
            (cₚ² base 𝟎) ⁻¹ ∙
            cₚ² base (⌜ idtoeq ⟨ base ⟩ ⟨ base ⟩ (ap ⟨_⟩ loop) ⌝ 𝟎)
 lemma' = lemma loop 𝟎

 kkkk : ap cₚ¹ loop ≡ (cₚ² base 𝟎) ⁻¹ ∙ (p ∙ (cₚ² base 𝟎))
 kkkk = ap cₚ¹ loop ≡⟨ lemma' ⟩
        cₚ² base 𝟎 ⁻¹ ∙
          cₚ² base (⌜ idtoeq ⟨ base ⟩ ⟨ base ⟩ (ap ⟨_⟩ loop) ⌝ 𝟎) ≡⟨ ap (λ - → cₚ² base 𝟎 ⁻¹ ∙ cₚ² base -) lemma'' ⟩
        cₚ² base 𝟎 ⁻¹ ∙ cₚ² base (succ-ℤ 𝟎) ≡⟨ ap (λ - → cₚ² base 𝟎 ⁻¹ ∙ -) (cₚ³ base 𝟎) ⟩
        cₚ² base 𝟎 ⁻¹ ∙ (p ∙ cₚ² base 𝟎) ∎
  where
   lemma'' : ⌜ idtoeq ⟨ base ⟩ ⟨ base ⟩ (ap ⟨_⟩ loop) ⌝ 𝟎 ≡ succ-ℤ 𝟎
   lemma'' = ap (λ - → ⌜ - ⌝ 𝟎) xxx

 lll : {X : 𝓤 ̇ } {x y : X} (q : x ≡ y) (p : x ≡ x)
     → transport (λ - → - ≡ -) q p ≡ q ⁻¹ ∙ (p ∙ q)
 lll refl p = (refl ⁻¹ ∙ (p ∙ refl) ≡⟨ refl              ⟩
               refl ⁻¹ ∙ p          ≡⟨ refl-left-neutral ⟩
               p                    ∎                     ) ⁻¹

 mmm : ap cₚ¹ loop ≡ transport (λ - → - ≡ -) (cₚ² base 𝟎) p
 mmm = ap cₚ¹ loop                            ≡⟨ kkkk ⟩
       cₚ² base 𝟎 ⁻¹ ∙ (p ∙ cₚ² base 𝟎)       ≡⟨ (lll (cₚ² base 𝟎) p) ⁻¹ ⟩
       transport (λ - → - ≡ -) (cₚ² base 𝟎) p ∎

\end{code}

\begin{code}

{-
module Tℤ-ind
        {A : Tℤ → 𝓤 ̇ }
--        (fe : funext 𝓤 𝓤)
        (a : A base)
        (p : transport A loop a ≡ a)
       where

 ⟨_⟩₂ : (X : Tℤ) → ⟨ X ⟩ → ⟨ X ⟩
 ⟨ (X , f , _) ⟩₂ = f

 szzz : (X : Tℤ) → ⟨ X ⟩ → base ≡ X
 szzz (X , f , t) x = to-Tℤ-≡ base (X , f , t) γ
  where
   γ : (ℤ , succ-ℤ , ∣ refl ∣) ≅ (X , f , t)
   γ = e , {!!} , {!!}
    where
     f⁻¹ : X → X
     f⁻¹ = {!!}
     e : ℤ → X
     e 𝟎       = f x
     e (pos n) = (f ^ (succ n)) x
     e (neg n) = (f⁻¹ ^ (succ n)) x

 Qₚ : Tℤ → 𝓤 ̇
 Qₚ X = Σ a' ꞉ A X ,
        Σ h ꞉ (⟨ X ⟩ → transport A {!!} a ≡ a')
      , ((x : ⟨ X ⟩) → h (⟨ X ⟩₂ x) ≡ {!!}) -- p ∙ h x)

-}

module _
        {A : 𝓤 ̇ }
        (fe  : funext 𝓤  𝓤)
        (fe₁ : funext 𝓤₁ 𝓤)
       where

 open Tℤ-rec {𝓤} {A} fe

 szzz : (X : Tℤ) → ⟨ X ⟩ → base ≡ X
 szzz (X , f , t) x = to-Tℤ-≡ base (X , f , t) γ
  where
   γ : (ℤ , succ-ℤ , ∣ refl ∣) ≅ (X , f , t)
   γ = e , {!!} , {!!}
    where
     f⁻¹ : X → X
     f⁻¹ = {!!}
     e : ℤ → X
     e 𝟎       = f x
     e (pos n) = (f ^ (succ n)) x

 -- Lemma 4.9
 qqqq : ((X , f , t) : Tℤ) (x : X)
      → szzz (X , f , t) (f x) ≡ loop ∙ szzz (X , f , t) x
 qqqq (X , f , t) x = {!!}

 universal-property : (Tℤ → A) ≃ (Σ a ꞉ A , a ≡ a)
 universal-property = qinveq ϕ (ψ , η , ε)
  where
   ϕ : (Tℤ → A) → (Σ a ꞉ A , a ≡ a)
   ϕ f = f base , ap f loop
   ψ : (Σ a ꞉ A , a ≡ a) → Tℤ → A
   ψ (a , p) = cₚ¹ p
   ε : ϕ ∘ ψ ∼ id
   ε (a , p) = (cₚ¹ p base , ap (cₚ¹ p) loop)                          ≡⟨ to-Σ-≡ (refl , (mmm p)) ⟩
               (cₚ¹ p base , transport (λ - → - ≡ -) (cₚ² p base 𝟎) p) ≡⟨ (to-Σ-≡ ((cₚ² p base 𝟎) , refl)) ⁻¹ ⟩
               (a , p)                                                 ∎
   η : ψ ∘ ϕ ∼ id
   -- We need Lemma 6.2.8 (uniqueness principle) of the HoTT Book here, which is proved using the induction principle.
   -- We won't prove the induction principle, but instead just prove this instance using the techniques of
   -- Bezem, Buchholtz, Grayson and Shulman.
   -- After all, the induction principle will have propositional computation rules which involve lots of transport.
   -- So, the universal property seems nicer anyway. Besides, according to the HoTT Book it is possible to derive
   -- the induction principle (with propositional computation rules) from the universal property. (We hope to do this with
   -- an abstract proof that avoids the complications of Tℤ and Bezem et al.)
   η f = dfunext fe₁ γ
    where
     γ : (Y : Tℤ) → cₚ¹ (ap f loop) Y ≡ f Y
     γ Y = ap pr₁ (singletons-are-props (Qₚ-is-singleton (ap f loop) Y) (cₚ (ap f loop) Y) f⁺)
      where
       f⁺ : Qₚ (ap f loop) (pr₁ Y , pr₁ (pr₂ Y))
       f⁺ = (f Y) , (e , tsss)
        where
         e : ⟨ Y ⟩ → f base ≡ f Y
         e y = ap f (szzz Y y)
         g : ⟨ Y ⟩ → ⟨ Y ⟩
         g = pr₁ (pr₂ Y)
         tsss : (y : ⟨ Y ⟩) → e (g y) ≡ ap f loop ∙ e y
         tsss y = e (g y)                     ≡⟨ refl ⟩
                  ap f (szzz Y (g y))         ≡⟨ ap (ap f) (qqqq Y y) ⟩
                  ap f (loop ∙ (szzz Y y))    ≡⟨ ap-∙ f loop (szzz Y y) ⟩
                  ap f loop ∙ ap f (szzz Y y) ≡⟨ refl ⟩
                  ap f loop ∙ e y             ∎

\end{code}
