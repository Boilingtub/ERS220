library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3_comb is
port (
	S : in std_logic_vector(2 downto 0);
	LPB,RPB,D: in std_logic;
	N : out std_logic_vector(2 downto 0);
	Dn : out std_logic
);
end lab3_comb;

architecture lab3_arc of lab3_comb is
	signal A,B,C,E,F,K,J,V,W,X,Y,Z,T,S2,S1,S0,L,R: std_logic;
begin
	S0 <= S(0);
	S1 <= S(1);
	S2 <= S(2);
	L <= LPB;
	R <= RPB;
  A <= S2;
  B <= S1;
  C <= S0;
  E <= L;
  F <= R;


-- Dn <= ( 
--	(S0 and D and not(L) and not(R)) or 
--	(S1 and D and not(L) and not(R)) or
--	(S2 and D and not(L) and not(R)) or
--	(S2 and S1 and S0 and L and not(R))
--  );
--N(0) <= (	
--		(not(S0) and not(L) and not(R)) or
--		(not(S2) and not(S1) and not(s0) and not(R)) or
--		(S2 and S1 and S0 and L and not(R))
--	); 
--N(1) <= (
--		(not(S1) and S0 and not(D) and not(L) and not(R)) or
--		(S1 and not(S0) and not(D) and not(L) and not(R)) or
--		(S1 and S0 and D and not(L) and not(R)) or
--		(S2 and S1 and S0 and L and not(R)) or
--		(S2 and not(S1) and not(S0) and D and not(L) and not(R))
--	);
--N(2) <= (
--		(S2 and not(S1) and not(D) and not(L) and not(R)) or
--		(S2 and S0 and D and not(L) and not(R)) or
--		(S2 and S1 and not(S0) and not(L) and not(R) ) or
--		(S2 and S1 and S0 and L and not(R)) or	
--		(not(S2) and S1 and S0 and not(D) and not(L) and not(R))
--	);

--K <= (A and B and C and E and not(F));
-- J <= (not(E) and not(F));
--
-- Dn <= (
--       K or ((D and J) and (A or B or C))
--     );
--
-- N(0) <= (
--         K or (not(C) and  ( (not(A) and not(B) and not(F)) or J))
--       ); 
-- N(1) <= (
--          (J and (
--           (not(B) and C and not(D)) or
--           (B and not(C) and not(D)) or
--           (B and C and D) or
--           (A and not(B) and not(C) and D) 
--           )) or K
--         );
-- N(2) <= (
--          K or (J and ( (B and C and not(D)) or A))
--        );
  
---  V <= (B xor C);
-- W <= ((A xor B) and not(V));
-- X <= not( ( not(A) and not(B) and not(C) ) or F );
-- Y <= ( X and (D or E) );
-- Z <= not(E or F);
--
-- N(2) <= (
--           ( Z and ( (not(D) and W) or (A and V) )) or Y
--         );
-- N(1) <= (
--           ( Z and ( (D and V) or (D and W)) ) or Y
--         );
-- N(0) <= (
--           not(A or B or C or F) or (not(C) and Z) or (X and E)
--         );
-- Dn <= (
--         ((D and Z) and (A or V or (not(A) and B and C))) or Y
--       );


Y <= (S1 xor S0);
X <= ((S2 xor S1) and not(Y));
Z <= not(not(S2 and S1 and S0) or R);
W <= Z and (L or D);
T <= not(L or R);

N(2) <= (
          (T and ( (not(D) and X) or (S2 and Y) )) or W
        );
N(1) <= (
          (T and ( (not(D) and Y) or (D and X))) or W 
        );
N(0) <= (
          not(S2 or S1 or S0 or R) or (not(S0) and T) or (Z and L)
        );
Dn <= (
        (T and D and (S2 or Y or (not(S2) and S1 and S0))) or W
      );



end lab3_arc;
