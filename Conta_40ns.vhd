----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2024 16:07:36
-- Design Name: 
-- Module Name: Conta_40ns - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Conta_40ns is
    generic (
        CLKIN_PERIOD : real := 8.000; -- input clock period (8ns)
        CLK_MULTIPLY : integer := 8; -- multiplier
        CLK_DIVIDE : integer := 1; -- divider
        CLKOUT0_DIV : integer := 8; -- serial clock divider
        CLKOUT1_DIV : integer := 40 -- pixel clock divider
    );
    port(
        clk_i : in std_logic; -- input clock
        clk0_o : out std_logic; -- serial clock
        clk1_o : out std_logic -- pixel clock
    ); 
end Conta_40ns;

architecture Behavioral of Conta_40ns is
    
    signal clkfbout: std_logic;
     
begin

    clock: PLLE2_BASE 
    generic map (
        clkin1_period => CLKIN_PERIOD,
        clkfbout_mult => CLK_MULTIPLY,
        clkout0_divide => CLKOUT0_DIV,
        clkout1_divide => CLKOUT1_DIV,
        divclk_divide => CLK_DIVIDE
    )
    port map(
        rst => '0',
        pwrdwn => '0',
        clkin1 => clk_i,
        clkfbin => clkfbout,
        clkfbout => clkfbout,
        clkout0 => clk0_o, -- pllclk0,
        clkout1 => clk1_o -- pllclk1
    );
    
end Behavioral;
