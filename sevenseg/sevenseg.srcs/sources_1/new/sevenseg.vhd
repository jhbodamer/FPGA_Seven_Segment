----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2025 02:17:57 PM
-- Design Name: 
-- Module Name: sevenseg - Behavioral
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
           --btn0 : in STD_LOGIC;
           --btn1 : in STD_LOGIC;
           digit : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0));
end sevenseg;

architecture Behavioral of sevenseg is
   
   --signal which tracks which digit and FSM state the cycle is on 
    type digit_labels is(
                first, second, third, fourth
                );
    signal current_digit : digit_labels;

begin
            -- Finite State Machine Process
            Main_Process: process (clk)
                begin   
                    if (rising_edge(clk)) then
                        case (current_digit) is
                            when first => 
                                led <= "01010100"; --letter  n
                                digit <= "1110"; -- right most digit
                                current_digit <= second;
                            when second => 
                                led <= "01110100"; -- letter h
                                digit <= "1101";
                                current_digit <= third;
                            when third => 
                                led <= "01011100"; -- letter o
                                digit <= "1011";
                                current_digit <= fourth;
                            when fourth => 
                                led <= "00011111"; -- letter J
                                digit <= "0111";
                                current_digit <= first;
                            when others => current_digit <= first;
                        end case;
                    end if;
               end process;

end Behavioral;
