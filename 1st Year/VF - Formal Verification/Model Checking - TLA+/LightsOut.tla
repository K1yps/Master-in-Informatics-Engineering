----------------------------- MODULE LightsOut -----------------------------

EXTENDS Naturals

CONSTANTS N

ASSUME N > 0

VARIABLE board

States == {"White", "Dark"}

pos == [0..N -> 0..N]

TypeOK == board \in [pos -> States]

Init == 





=============================================================================
\* Modification History
\* Last modified Thu May 19 13:36:40 WEST 2022 by k1yps
\* Created Wed May 18 10:16:54 WEST 2022 by k1yps
