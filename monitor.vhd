library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.protocol_common.all;

entity monitor is
    port (
        clk   : in std_logic;
        data : in std_logic_vector(3 downto 0);
        ena : in std_logic;
        startp : in std_logic;
        endp : in std_logic;
        output_tran : out protocol_type
    );
end entity;



architecture monitor_architecture of monitor is

    signal temp_data : std_logic_vector(31 downto 0);

begin

    transmission : process
    begin

        if ena = '1' then
            
            output_tran.valid <= '0';
            output_tran.data <= (others => 'Z');
            temp_data <= (others => '0');

            report "start symbol receiver.";

            wait until falling_edge(startp);

            report "'startp' symbol received";

            for i in 0 to 2 loop
                wait until falling_edge(clk);
            end loop;

            for i in 0 to 7 loop
                temp_data(31 - (i*4) downto 28-(i*4)) <= data;
                
                report integer'image(i+1) & ". data fragment received";
                
                for t in 0 to 81 loop
                    wait until falling_edge(clk);
                end loop;
            end loop;

            report "full symbol received.";
            
            wait until falling_edge(endp);

            report "'endp' symbol received.";

            output_tran.data <= temp_data;
            output_tran.valid <= '1';
            
            report "output record created";
            
            for i in 0 to 24 loop
                wait until falling_edge(clk);
            end loop;
            
            report "ready to receive new symbol";

        else
            wait until falling_edge(clk);
        end if;

    end process;
    

end architecture;