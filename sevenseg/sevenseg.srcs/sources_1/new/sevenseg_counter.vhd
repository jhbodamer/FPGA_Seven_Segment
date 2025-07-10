----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2025 02:41:09 PM
-- Design Name: 
-- Module Name: sevenseg_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenseg is
    Port ( 
            clk : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           btn1 : in STD_LOGIC;
           digit : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0));
end sevenseg;

architecture Behavioral of sevenseg is
   FUNCTION number_lookup ( --function for converting integer 0-9 into 8 bit bus signal corresponding to 1 character
        number_in : unsigned(3 downto 0)
        )
        return std_logic_vector is 
            variable character : std_logic_vector(7 downto 0);
        begin
            if number_in = 0 then character := "00111111";
            elsif number_in = 1 then character := "00000110";
            elsif number_in = 2 then character := "01011011";
            elsif number_in = 3 then character := "01001111";
            elsif number_in = 4 then character := "01100110";
            elsif number_in = 5 then character := "01101101";
            elsif number_in = 6 then character := "01111101";
            elsif number_in = 7 then character := "00000111";
            elsif number_in = 8 then character := "01111111";
            elsif number_in = 9 then character := "01100111";
            else character := "01100011";
            end if;
        return character;
   END number_lookup;
   --signal which tracks which digit and FSM state the cycle is on 
    type digit_labels is(
                first, second, third, fourth, none
                );
    signal current_digit : digit_labels; -- tracks which digit is currently active
    signal reduce_clk : unsigned(19 downto 0); -- counter to reduce frequency of clock
    signal reduce_clk_2: unsigned(2 downto 0); -- least significant digit increments at around 100hz so this is used to reduce the clock further
    signal counter0 : unsigned(3 downto 0); -- counts the first digit
    signal counter1 : unsigned(3 downto 0);
    signal counter2 : unsigned(3 downto 0);
    signal counter3 : unsigned(3 downto 0);
    signal counting_up : std_logic := '0'; -- tracks whether the counter should be actively increasing
begin
            -- Finite State Machine Process
            Main_Process: process (clk, btn0, btn1)
                begin 
                    if btn0 = '1' then -- reset button
                        counter0 <= x"0";
                        counter1 <= x"0";
                        counter2 <= x"0";
                        counter3 <= x"0";  
                        counting_up <= '0';
                        digit <= "1111";
                    elsif (rising_edge(clk)) then
                        if btn1 = '1' then counting_up <= '1'; end if; -- other button activates the counter
                        reduce_clk <= reduce_clk +1; -- increment clock reducing counter
                        if (reduce_clk = 250000) then 
                                case (current_digit) is
                                        when first => 
                                            led <= number_lookup(counter0); -- signal to leds provided by number_lookup function
                                            digit <= "1110"; -- right most digit
                                            current_digit <= second;
                                        when second => 
                                            led <= number_lookup(counter1); 
                                            digit <= "1101";
                                            current_digit <= third;
                                        when third => 
                                            led <= number_lookup(counter2); 
                                            digit <= "1011";
                                            current_digit <= fourth;
                                        when fourth => 
                                            led <= number_lookup(counter3); 
                                            digit <= "0111"; -- left most digit
                                            current_digit <= first;
                                        when none =>
                                            digit <= "1111"; -- because of common anode config this means no digits are activated
                                        when others => current_digit <= first;
                                    end case;
                                reduce_clk_2 <= reduce_clk_2 +1;
                                reduce_clk <= (others => '0'); -- resets clock reducing counter
                                 if (counting_up = '1' and reduce_clk_2 = 4) then-- only increment counter if counting up is true
                                 reduce_clk_2 <= "000";
                                    counter0 <= counter0 + 1; -- base 10 counting
                                    if counter0 = 10 then 
                                        counter0 <= (others => '0'); 
                                        counter1 <= counter1 + 1; end if;
                                    if counter1 = 10 then 
                                        counter1 <= (others => '0');
                                        counter2 <= counter2 + 1; end if;
                                    if counter2 = 10 then 
                                        counter2 <= (others => '0');
                                        counter3 <= counter3 +1; end if;
                                    if counter3 = 10 then
                                        counter3 <= (others => '0'); end if;
                                    
                                    
                               end if;
                         end if;
                    end if;
               end process;

end Behavioral;

