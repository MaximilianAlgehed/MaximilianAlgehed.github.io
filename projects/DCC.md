---
title: Embeddings and Encodings of the Dependency Core Caluclus
---

I've done some work on the Dependency Core Calulcus [[1]](../references/DCC.pdf).
I have two papers at the PLAS workshop in 2017 and 2018 both dealing with embedding
DCC in Haskell.

The first paper, "Embedding DCC in Haskell" presents an encoding of DCC in Haskell,
the paper can be found [here](../papers/DCC-plas2017.pdf) and the code is available on
[GitHub](https://github.com/MaximilianAlgehed/DCC). The main idea is to use Haskell
s type families (type level functions) to encode the type system restrictions which
ensure Information Flow Security in DCC.

My second paper on DCC simplifies the DCC type system by splitting the
complicated `bind` primitive into simpler `up` and `com` primitives.
I show in this paper that DCC is equivalent to the simplified, SDCC, calculus
by providing a bijection between the calculi. The paper can be found
[here](../papers/SDCC-plas2018.pdf), implementation and formalisation are
available on [GitHub](https://github.com/MaximilianAlgehed/SDCC).
