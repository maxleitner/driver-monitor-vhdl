library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.protocol_common.all;

entity driver_monitor_tb is
end;

architecture bench of driver_monitor_tb is

  component driver
      port (
      clk : in std_logic;
      input_tran : in protocol_type;
      data : out std_logic_vector(3 downto 0);
      ena : out std_logic;
      startp : out std_logic;
      endp : out std_logic
    );
  end component;

  component monitor
    port (
    clk : in std_logic;
    data : in std_logic_vector(3 downto 0);
    ena : in std_logic;
    startp : in std_logic;
    endp : in std_logic;
    output_tran : out protocol_type
    );
  end component;

  -- Clock period
  constant clk_period : time := 3 ns;
  signal endsim : boolean := false;
  -- Generics

  -- Ports
  signal clk : std_logic;
  signal input_tran : protocol_type;
  signal data : std_logic_vector(3 downto 0);
  signal ena : std_logic;
  signal startp : std_logic;
  signal endp : std_logic;
  signal output_tran : protocol_type;

begin

   

  driver_inst : driver
    port map (
      clk => clk,
      input_tran => input_tran,
      data => data,
      ena => ena,
      startp => startp,
      endp => endp
    );

  monitor_inst : monitor
    port map (
      clk => clk,
      data => data,
      ena => ena,
      startp => startp,
      endp => endp,
      output_tran => output_tran
    );

    
  clk_process : process
  begin
  clk <= '1';
  wait for clk_period/2;
  clk <= '0';
  wait for clk_period/2;
  if endsim=true then
    wait;
  end if;
  end process clk_process;

  stimulation : process 
  begin
    
    input_tran.valid <= '1';
    input_tran.data <= "10110101001010110101001010101001";
    
    wait for 1000 * clk_period;
    endsim <= true;
    wait;
  end process;

end;
