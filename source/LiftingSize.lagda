Martin Escardo 24th January 2019

Size matters.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import SpartanMLTT

module LiftingSize (𝓣 : Universe) where

open import UF-Subsingletons hiding (⊥)
open import UF-Resizing
open import UF-Equiv
open import UF-Univalence
open import UF-FunExt
open import UF-UA-FunExt
open import UF-EquivalenceExamples
open import Lifting 𝓣
open import LiftingIdentityViaSIP

\end{code}

As one can see from the definition of 𝓛, we have that 𝓛 lives in a
universe strictly higher than that of X in general:

\begin{code}

the-universe-of-𝓛 : {X : 𝓤 ̇} → universe-of (𝓛 X) ≡ 𝓣 ⁺ ⊔ 𝓤
the-universe-of-𝓛 = refl

\end{code}

However, if the argument is in 𝓣 ⁺ ⊔ 𝓤, then the size doesn't
increase:

\begin{code}

𝓛-universe-preservation : {X : 𝓣 ⁺ ⊔ 𝓤 ̇} → universe-of (𝓛 X) ≡ universe-of X
𝓛-universe-preservation = refl

\end{code}

In particular, after the first application of 𝓛, further applications
don't increase the size:

\begin{code}

the-universe-of-𝓛𝓛 : {X : 𝓤 ̇} → universe-of (𝓛(𝓛 X)) ≡ universe-of (𝓛 X)
the-universe-of-𝓛𝓛 = refl

\end{code}

As a particular case of the above, if 𝓣 and 𝓤 are the same universe,
then the first application of 𝓛 has its result in the next universe 𝓣⁺.

\begin{code}

the-universe-of-𝓛' : {X : 𝓣 ̇} → universe-of (𝓛 X) ≡ 𝓣 ⁺
the-universe-of-𝓛' = refl

\end{code}

But if 𝓤 is taken to be the successor 𝓣 ⁺ of 𝓣 then it is preserved by 𝓛:

\begin{code}

the-universe-of-𝓛⁺ : {X : 𝓣 ⁺ ̇} → universe-of (𝓛 X) ≡ universe-of X
the-universe-of-𝓛⁺ = refl

\end{code}

With weak propositional resizing (any proposition of any universe has
a logically equivalent copy in any universe), 𝓛 preserves all
universes except the first, i.e., all successor universes 𝓤 ⁺.

\begin{code}

𝓛-resize : is-univalent 𝓣 → is-univalent 𝓤 → Propositional-resizing
         → (X : 𝓤 ⁺ ̇) → (𝓛 X) has-size (𝓤 ⁺)
𝓛-resize {𝓤} ua ua' ρ X = L , e
 where
  L : 𝓤 ⁺ ̇
  L = Σ \(P : 𝓤 ̇) → (P → X) × is-prop P
  e : L ≃ 𝓛 X
  e = qinveq φ (γ , γφ , φγ)
   where
    φ : L → 𝓛 X
    φ (P , f , i) = resize ρ P i , f ∘ from-resize ρ P i , resize-is-a-prop ρ P i
    γ : 𝓛 X → L
    γ (Q , g , j) = resize ρ Q j , g ∘ from-resize ρ Q j , resize-is-a-prop ρ Q j
    φγ : (l : 𝓛 X) → φ (γ l) ≡ l
    φγ (Q , g , j) = ⋍-gives-≡ 𝓣 ua (a , b)
     where
      a : resize ρ (resize ρ Q j) (resize-is-a-prop ρ Q j) ≃ Q
      a = qinveq (from-resize ρ Q j ∘ from-resize ρ (resize ρ Q j) (resize-is-a-prop ρ Q j))
                 (to-resize ρ (resize ρ Q j) (resize-is-a-prop ρ Q j) ∘ to-resize ρ Q j ,
                 (λ r → resize-is-a-prop ρ (resize ρ Q j) (resize-is-a-prop ρ Q j) _ r) ,
                 (λ q → j _ q))
      b : g ∘ from-resize ρ Q j ∘ from-resize ρ (resize ρ Q j) (resize-is-a-prop ρ Q j) ≡ g ∘ eqtofun a
      b = ap (g ∘_) (dfunext (funext-from-univalence ua) (λ r → j _ (eqtofun a r)))
    γφ : (m : L) → γ (φ m) ≡ m
    γφ (P , f , i) = ⋍-gives-≡ 𝓤 ua' (a , b)
     where
      a : resize ρ (resize ρ P i) (resize-is-a-prop ρ P i) ≃ P
      a = qinveq (from-resize ρ P i ∘ from-resize ρ (resize ρ P i) (resize-is-a-prop ρ P i))
                 (to-resize ρ (resize ρ P i) (resize-is-a-prop ρ P i) ∘ to-resize ρ P i ,
                 (λ r → resize-is-a-prop ρ (resize ρ P i) (resize-is-a-prop ρ P i) _ r) ,
                 (λ q → i _ q))
      b : f ∘ from-resize ρ P i ∘ from-resize ρ (resize ρ P i) (resize-is-a-prop ρ P i) ≡ f ∘ eqtofun a
      b = ap (f ∘_) (dfunext (funext-from-univalence ua') (λ r → i _ (eqtofun a r)))

\end{code}

TODO. The above proof can be simplified.

NB. With a more careful treatment everywhere (including the structure
of identity principle), we can relax the assumption that 𝓣 and 𝓤 are
univalent to the assumption that 𝓣 satisfies propositional and
functional extensionality. But this is probably not worth the trouble,
as it would imply developing a copy of the SIP with this different
assumption.

Added 8th Feb 2019.

\begin{code}

𝓛-resize₀ : Ω-resizing₀ 𝓣 → (X : 𝓣 ̇) → (𝓛 X) has-size 𝓣
𝓛-resize₀ ω₀ X = (Σ \(p : Ω₀) → up p holds → X) , ≃-comp d e
 where
  Ω₀ : 𝓤₀ ̇
  Ω₀ = pr₁ ω₀

  up : Ω₀ → Ω 𝓣
  up = eqtofun (pr₂ ω₀)

  up-is-equiv : is-equiv up
  up-is-equiv = eqtofun-is-an-equiv (pr₂ ω₀)

  d : (Σ \(p : Ω₀) → up p holds → X) ≃ (Σ \(p : Ω 𝓣) → p holds → X)
  d = Σ-change-of-variables (λ p → p holds → X) up up-is-equiv

  e : (Σ \(p : Ω 𝓣) → p holds → X) ≃ 𝓛 X
  e = qinveq (λ {((P , i) , f) → P , f , i})
             ((λ {(P , f , i) → (P , i) , f}) ,
              (λ _ → refl) ,
              (λ _ → refl))
\end{code}
