library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.AMEpkg.all;

entity AME_Architecture_netlist_wrapper is
	port ( cMV0_in, cMV1_in, cMV2_in: in motion_vector(1 downto 0);--Constructor motion vectors (0:h, 1:v)
		   START: in std_logic; --constructor's "START"
		   CU_h, CU_w: in std_logic_vector(6 downto 0);
		   clk, RST: in std_logic;
		   cREADY: out std_logic; --constructor's READY
		   VALID: in std_logic; --extimator's VALID
		   eMV0_in, eMV1_in, eMV2_in: in motion_vector(1 downto 0);--Extimator motion vectors (0:h, 1:v)
		   sixPar : in std_logic;
		   eIN_SEL : in std_logic; --extimator input selector: 0: from VTM, 1: form constructor
		   RefPel, CurPel: in slv_8(3 downto 0);
		   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		   MEM_RE: out std_logic; --Memory Read Enable
		   eREADY: out std_logic; --extimator's READY
		   eDONE: out std_logic;  --extimator's DONE
		   MV0_out, MV1_out, MV2_out: out motion_vector(1 downto 0); --Extimation result
		   --For the output checker
		   cComp_EN, cDONE, eComp_EN: out std_logic;
		   MVP0, MVP1, MVP2: out motion_vector(1 downto 0);
		   CurSAD: out std_logic_vector(17 downto 0);
		   D_Cur: out std_logic_vector(27 downto 0)
		);
end entity;

architecture structural of AME_Architecture_netlist_wrapper is

	component AME_Architecture is
	port ( cMV0_in, cMV1_in, cMV2_in: in std_logic_vector(21 downto 0);--Constructor motion vectors (0:h, 1:v)
		   START: in std_logic; --constructor's "START"
		   CU_h, CU_w: in std_logic_vector(6 downto 0);
		   clk, RST: in std_logic;
		   cREADY: out std_logic; --constructor's READY
		   VALID: in std_logic; --extimator's VALID
		   eMV0_in, eMV1_in, eMV2_in: in std_logic_vector(21 downto 0);--Extimator motion vectors (0:h, 1:v)
		   sixPar : in std_logic;
		   eIN_SEL : in std_logic; --extimator input selector: 0: from VTM, 1: form constructor
		   RefPel, CurPel: in std_logic_vector(31 downto 0);
		   RADDR_RefCu_x, RADDR_RefCu_y: out std_logic_vector(12 downto 0);
		   RADDR_CurCu_x, RADDR_CurCu_y: out std_logic_vector(5 downto 0);
		   MEM_RE: out std_logic; --Memory Read Enable
		   eREADY: out std_logic; --extimator's READY
		   eDONE: out std_logic;  --extimator's DONE
		   MV0_out, MV1_out, MV2_out: out std_logic_vector(21 downto 0); --Extimation result
		   --For the output checker
		   cComp_EN, cDONE, eComp_EN: out std_logic;
		   MVP0, MVP1, MVP2: out std_logic_vector(21 downto 0);
		   CurSAD: out std_logic_vector(17 downto 0);
		   D_Cur: out std_logic_vector(27 downto 0)
		);
	end component;

	signal cMV0_in_int, cMV1_in_int, cMV2_in_int: std_logic_vector(21 downto 0);--Constructor motion vectors (0:h, 1:v)
	signal eMV0_in_int, eMV1_in_int, eMV2_in_int: std_logic_vector(21 downto 0);
	signal RefPel_int, CurPel_int: std_logic_vector(31 downto 0);
	signal MV0_out_int, MV1_out_int, MV2_out_int: std_logic_vector(21 downto 0); --Extimation result
	signal MVP0_int, MVP1_int, MVP2_int: std_logic_vector(21 downto 0);

begin

	--cMV(0,1,2)_int
	cMV0_in_int(10 downto 0)<=cMV0_in(0);
	cMV0_in_int(21 downto 11)<=cMV0_in(1);
	cMV1_in_int(10 downto 0)<=cMV1_in(0);
	cMV1_in_int(21 downto 11)<=cMV1_in(1);
	cMV2_in_int(10 downto 0)<=cMV2_in(0);
	cMV2_in_int(21 downto 11)<=cMV2_in(1);

	--eMV(0,1,2)_int
	eMV0_in_int(10 downto 0)<=eMV0_in(0);
	eMV0_in_int(21 downto 11)<=eMV0_in(1);
	eMV1_in_int(10 downto 0)<=eMV1_in(0);
	eMV1_in_int(21 downto 11)<=eMV1_in(1);
	eMV2_in_int(10 downto 0)<=eMV2_in(0);
	eMV2_in_int(21 downto 11)<=eMV2_in(1);

	--RefPel_int
	RefPel_int(7 downto 0)<=RefPel(0);
	RefPel_int(15 downto 8)<=RefPel(1);
	RefPel_int(23 downto 16)<=RefPel(2);
	RefPel_int(31 downto 24)<=RefPel(3);

	--CurPel_int
	CurPel_int(7 downto 0)<=CurPel(0);
	CurPel_int(15 downto 8)<=CurPel(1);
	CurPel_int(23 downto 16)<=CurPel(2);
	CurPel_int(31 downto 24)<=CurPel(3);
	
	--MV(0,1,2)_out_int
	MV0_out(0)<=MV0_out_int(10 downto 0);
	MV0_out(1)<=MV0_out_int(21 downto 11);
	MV1_out(0)<=MV1_out_int(10 downto 0);
	MV1_out(1)<=MV1_out_int(21 downto 11);
	MV2_out(0)<=MV2_out_int(10 downto 0);
	MV2_out(1)<=MV2_out_int(21 downto 11);

	--MVP(0,1,2)_int
	MVP0(0)<=MVP0_int(10 downto 0);
	MVP0(1)<=MVP0_int(21 downto 11);
	MVP1(0)<=MVP1_int(10 downto 0);
	MVP1(1)<=MVP1_int(21 downto 11);
	MVP2(0)<=MVP2_int(10 downto 0);
	MVP2(1)<=MVP2_int(21 downto 11);

	AME_Architecture_netlist : AME_Architecture
	port map ( cMV0_in_int, cMV1_in_int, cMV2_in_int,
		   START,
		   CU_h, CU_w,
		   clk, RST,
		   cREADY,
		   VALID,
		   eMV0_in_int, eMV1_in_int, eMV2_in_int,
		   sixPar ,
		   eIN_SEL,
		   RefPel_int, CurPel_int,
		   RADDR_RefCu_x, RADDR_RefCu_y,
		   RADDR_CurCu_x, RADDR_CurCu_y,
		   MEM_RE,
		   eREADY,
		   eDONE,
		   MV0_out_int, MV1_out_int, MV2_out_int,
		   --For the output checker
		   cComp_EN, cDONE, eComp_EN,
		   MVP0_int, MVP1_int, MVP2_int,
		   CurSAD,
		   D_Cur
		);


end architecture structural;
