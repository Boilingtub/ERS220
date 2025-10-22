LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY line_nav_testbench  IS 
END ; 
 
ARCHITECTURE line_nav_testbench_arch OF line_nav_testbench IS
  SIGNAL Tl   :  STD_LOGIC  ; 
  SIGNAL X   :  STD_LOGIC  ; 
  SIGNAL Y   :  STD_LOGIC  ; 
  SIGNAL F   :  STD_LOGIC  ; 
  SIGNAL Tr   :  STD_LOGIC  ; 
  SIGNAL Z   :  STD_LOGIC  ; 
  SIGNAL St   :  STD_LOGIC  ; 
  SIGNAL C   :  STD_LOGIC  ; 
  SIGNAL S   :  STD_LOGIC  ; 
  SIGNAL W   :  STD_LOGIC  ; 
  COMPONENT line_nav  
    PORT ( 
      Tl  : out STD_LOGIC ; 
      X  : in STD_LOGIC ; 
      Y  : in STD_LOGIC ; 
      F  : out STD_LOGIC ; 
      Tr  : out STD_LOGIC ; 
      Z  : in STD_LOGIC ; 
      St  : out STD_LOGIC ; 
      C  : out STD_LOGIC ; 
      S  : out STD_LOGIC ; 
      W  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : line_nav  
    PORT MAP ( 
      Tl   => Tl  ,
      X   => X  ,
      Y   => Y  ,
      F   => F  ,
      Tr   => Tr  ,
      Z   => Z  ,
      St   => St  ,
      C   => C  ,
      S   => S  ,
      W   => W   ) ; 



-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 4 ms, Period = 4 us
  Process
	Begin
	 w  <= '0'  ;
	wait for 2 us ;
-- 2 us, single loop till start period.
	 w  <= '1'  ;
	wait for 2 us ;
-- dumped values till 4 us
	wait;
 End Process;


-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 4 us, Period = 2 us
  Process
	Begin
	 x  <= '0'  ;
	wait for 1 us ;
-- 1 us, single loop till start period.
	    x  <= '1'  ;
	   wait for 1 us ;
	    x  <= '0'  ;
	   wait for 1 us ;
-- 3 us, repeat pattern in loop.
	 x  <= '1'  ;
	wait for 1 us ;
-- dumped values till 4 us
	wait;
 End Process;


-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 4 us, Period = 1 us
  Process
	Begin
	 y  <= '0'  ;
	wait for 500 ns ;
-- 500 ns, single loop till start period.
	for Z in 1 to 3
	loop
	    y  <= '1'  ;
	   wait for 500 ns ;
	    y  <= '0'  ;
	   wait for 500 ns ;
-- 3500 ns, repeat pattern in loop.
	end  loop;
	 y  <= '1'  ;
	wait for 500 ns ;
-- dumped values till 4 us
	wait;
 End Process;


-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 4 us, Period = 500 ns
  Process
	Begin
	 z  <= '0'  ;
	wait for 250 ns ;
-- 250 ns, single loop till start period.
	for Z in 1 to 7
	loop
	    z  <= '1'  ;
	   wait for 250 ns ;
	    z  <= '0'  ;
	   wait for 250 ns ;
-- 3750 ns, repeat pattern in loop.
	end  loop;
	 z  <= '1'  ;
	wait for 250 ns ;
-- dumped values till 4 us
	wait;
 End Process;


-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 100 ns
  Process
	Begin
	s <= 'Z' ;
	 if s  /= ('0'  ) then 
		report " test case failed" severity error; end if;
	wait for 50 ns ;
-- 50 ns, single loop till start period.
	for Z in 1 to 9
	loop
	    if s  /= ('1'  ) then 
		report " test case failed" severity error; end if;
	   wait for 50 ns ;
	    if s  /= ('0'  ) then 
		report " test case failed" severity error; end if;
	   wait for 50 ns ;
-- 950 ns, repeat pattern in loop.
	end  loop;
	 if s  /= ('1'  ) then 
		report " test case failed" severity error; end if;
	wait for 50 ns ;
-- dumped values till 1 us
	s <= 'Z' ;
	wait;
 End Process;
END;
