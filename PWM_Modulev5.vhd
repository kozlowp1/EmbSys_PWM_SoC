library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PWM_Modulev5 is 
port(  
  
 Clk : IN std_logic;
 nReset : IN std_logic;
 Address : IN std_logic_vector (2 DOWNTO 0);
 ChipSelect : IN std_logic;
 Read : IN std_logic;
 Write : IN std_logic;
 ReadData : OUT std_logic_vector (7 DOWNTO 0);
 WriteData : IN std_logic_vector (7 DOWNTO 0);
 PWMout:  out std_logic

);
end PWM_Modulev5;

architecture behav of PWM_Modulev5 is         
  signal pre_count: unsigned(7 downto 0);
  signal period: unsigned(7 downto 0);
  signal dutyCycle: unsigned(7 downto 0);
  signal polarity: unsigned(7 downto 0);
  TYPE State_type IS (zero, one);  
	SIGNAL State : State_Type;  
  --for the counter purpose
  signal count: integer:=0;
  signal tmp : std_logic := '1';
  signal enable : std_logic;
begin
    

PROCESS (enable, nReset) 
  BEGIN 
    If (nReset = '0') THEN            -- Upon reset, set the state to A
	State <= one;
	pre_count <= (others => '0');
--	period <= (others => '0'); 
--	dutyCycle <= (others => '0'); 
--	polarity <= (others => '0');

    
    elsIF rising_edge(enable) THEN    -- if there is a rising edge of the

	CASE State IS

		WHEN zero => --(to_integer(unsigned(a)) < to_integer(unsigned(b)))
			IF pre_count > dutyCycle and pre_count < period THEN
				PWMout <= '0';
				pre_count <= pre_count + 1;
				--State <= zero;
			Elsif pre_count >= period THEN
				PWMout <= '1';
				pre_count <= (others => '0');
				State <= one;
			Else
				State <= one;
			END IF;
		WHEN one => 
			IF pre_count < dutyCycle THEN 
				PWMout <= '1';
				pre_count <= pre_count + 1;
				--State <= one;
			elsIF pre_count = dutyCycle THEN 
				PWMout <= '0';
				pre_count <= pre_count + 1;
			ELSE 
				PWMout <= '0';
				State <= zero;
				pre_count <= pre_count + 1;
			END IF; 

		WHEN others =>
			null;
	END CASE; 
    END IF; 
  END PROCESS;



Divider:
process(clk,nReset)
begin
	if(nReset='0') then
	count<=0;
	tmp<='1';
	elsif(clk'event and clk='1') then
	count <=count+1;
		if (count = 200) then
			tmp <= NOT tmp;
			count <= 0;
		end if;
	end if;
enable <= tmp;
end process;



pRegWr:
process(Clk,nReset)
begin
If (nReset = '0') THEN            -- Upon reset, set the state to A
	--pre_count <= (others => '0');
	period <= (others => '0'); 
	dutyCycle <= (others => '0'); 
	polarity <= (others => '0');
	elsif rising_edge(Clk) then
	if ChipSelect = '1' and Write = '1' then -- Write cycle
		case Address(2 downto 0) is
			when "010" => period <= unsigned(WriteData);
			when "011" => dutyCycle <= unsigned(WriteData);
			when "100" => polarity <= unsigned(WriteData);
			--when "101" => pre_count <= unsigned(WriteData);
			when others => null;
		end case;
	end if;
end if;
end process pRegWr;

pRegRd:
process(Clk)
begin
if rising_edge(Clk) then
	ReadData <= (others => '0'); -- default value
	if ChipSelect = '1' and Read = '1' then -- Read cycle
		case Address(2 downto 0) is
		when "001" => ReadData <= std_logic_vector(dutyCycle);
		when "010" => ReadData <= std_logic_vector(polarity);
		when "100" => ReadData <= std_logic_vector(period);
		when others => null;
	end case;
	end if;
end if;
end process pRegRd;

end behav;
