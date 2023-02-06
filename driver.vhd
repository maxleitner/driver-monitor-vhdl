library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.protocol_common.all;


entity driver is
    port (
        clk   : in std_logic;
        input_tran : in protocol_type;
        data : out std_logic_vector(3 downto 0);
        ena : out std_logic;
        startp : out std_logic;
        endp : out std_logic
        
    );
end entity;

architecture driver_architecture of driver is

    signal temp_data : std_logic_vector(31 downto 0);
    

begin

    transmission : process
    begin
        if input_tran.valid = '1' then
            report "starting transmission";

            temp_data <= input_tran.data;
            ena <= '0';
            startp <= '0';
            endp <= '0'; 
            data <= (others => 'Z');
            wait until rising_edge(clk);
            ena <= '1';

            for i in 0 to 8 loop
                wait until rising_edge(clk);
            end loop;
            startp <= '1';
            wait until rising_edge(clk);
            startp <= '0';

            report "'startp' signal sent";

            for i in 0 to 1 loop
                wait until rising_edge(clk);
            end loop;

            for i in 0 to 7 loop
                data <= temp_data(31-(i*4) downto 28-(i*4));
                report integer'image(i+1) & ". data part sent";
                for t in 0 to 81 loop
                    wait until rising_edge(clk);
                end loop;
            end loop;

            report "full symbol sent";
            
            data <= (others => 'Z');
            
            for i in 0 to 6 loop
                wait until rising_edge(clk);
            end loop; 

            endp <= '1';
            wait until rising_edge(clk);
            endp <= '0';
            
            report "'endp' signal sent.";

            for i in 0 to 14 loop
                wait until rising_edge(clk);
            end loop; 
            
            ena <= '0';

            for i in 0 to 9 loop
                wait until rising_edge(clk);
            end loop;
            
            report "ready to send new symbol";
        else
            wait until rising_edge(clk);
        end if;
    end process;

    
    

end architecture;