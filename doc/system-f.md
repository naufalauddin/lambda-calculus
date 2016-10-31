# System F
System F is a typed variant of the Lambda Calculus. It is an extension to
another typed &lambda; known as the Simply Typed Lambda Calculus. Additionally,
System F introduces the concept of generic types, also called polymorphic
types [1].

In general, type systems aim to eliminate certain programming errors [3]. A good
type system should reject ill-typed programs, while not being too conservative--
that is, it accepts most valid programs. Many functional programming languages 
are based on type systems similar to System F, including Haskell 
(System FC [4]), and ML (Hindley-Milner [5]).

# Simple Types
In System F, all values must have a type. Simple types can either be actual 
types, or type variables. For example, suppose we have a Boolean type and 
valid values are true and false.

    true : Boolean
    false : Boolean

## Type Context
A typing context is a sequence mapping free variables to their types [2]. Given
a typing context &Gamma;, 

    Γ ⊢ t : T

can be read: under the assumptions &Gamma;, t has type T. When the context is
empty, we may omit &Gamma;.

    ⊢ t : T

To indicate we are adding a mapping to &Gamma;, we use the comma operator.

    Γ, t:T ⊢ v : V

# References
1. [System F](https://en.wikipedia.org/wiki/System_F). Wikipedia: The Free Encyclopedia
2. Types and Programming Languages. Benjamin C. Pierce
3. [Type system](https://en.wikipedia.org/wiki/Type_system). Wikipedia: The Free Encyclopedia
4. [System FC: equality constraints and coercions](https://ghc.haskell.org/trac/ghc/wiki/Commentary/Compiler/FC). GHC Developer Wiki
5. [Hindley-Milner type system](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system). Wikipedia: The Free Encyclopedia