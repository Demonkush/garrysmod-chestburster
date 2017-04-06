--[[-------------------------------------------------------------------------
Preset Maps and Data ( for Plug n Play )
---------------------------------------------------------------------------]]--
CHESTBURSTER.PresetMaps = {}
if !table.HasValue(CHESTBURSTER.PresetMapBlacklist,"css") then
	if file.Exists("maps/cs_assault.bsp","GAME") then
		print("[CHBU_DEBUG] CS:S maps verified, adding to preset list.")
		local CSS = {
		"cs_assault","cs_compound","cs_havana","cs_italy","cs_militia","cs_office",
		"de_aztec","de_cbble","de_chateau","de_dust","de_dust2","de_inferno",
		"de_nuke","de_piranesi","de_port","de_prodigy","de_tides","de_train"}
		table.Add(CHESTBURSTER.PresetMaps,CSS)
	end
end
if !table.HasValue(CHESTBURSTER.PresetMapBlacklist,"hl2dm") then
	if file.Exists("maps/dm_lockdown.bsp","GAME") then
		print("[CHBU_DEBUG] HL2:DM maps verified, adding to preset list.")
		local HL2DM = {
		"dm_lockdown","dm_overwatch","dm_powerhouse","dm_resistance","dm_runoff",
		"dm_steamlab","dm_underpass"}
		table.Add(CHESTBURSTER.PresetMaps,HL2DM)
	end
end
function CHESTBURSTER.PresetChangeMap()
	local nextmap = CHESTBURSTER.PresetMaps[math.random(1,#CHESTBURSTER.PresetMaps)]
	RunConsoleCommand("changelevel",nextmap)
end

function CHESTBURSTER.GetPresetSpawnData()
	local currentmap = game.GetMap()
	local function SortSpawnData()
		for a, b in pairs(CHESTBURSTER.PresetSpawnData) do
			if currentmap == b.map then return b.spawns end
		end
	end
	CHESTBURSTER.ChestSpawnTable = SortSpawnData()
end
CHESTBURSTER.PresetSpawnData = {}
CHESTBURSTER.PresetSpawnData[1] = {
	map="cs_assault",
	spawns={
		Vector(6965,7191,-531),Vector(7105,5315,-531),Vector(5272,4808,-831),Vector(5114,3791,-607),
		Vector(6677,3914,-607),Vector(6257,3943,-735),Vector(6511,5654,-863),Vector(4684,5524,-860),
		Vector(4889,4309,-867),Vector(5667,5713,-863),Vector(5352,7085,-991),Vector(4984,6565,-863)
	}
}
CHESTBURSTER.PresetSpawnData[2] = {
	map="cs_compound",
	spawns={
		Vector(1831,272,0),Vector(868,-1491,0),Vector(2218,-1513,8),Vector(2028,-631,0),
		Vector(1916,14,256),Vector(1263,1248,2),Vector(3297,-250,5),Vector(1881,2437,8),
		Vector(3218,1440,8),Vector(4090,1506,8),Vector(2015,-1496,16),Vector(415,31,0),
		Vector(2710,1161,5)
	}
}
CHESTBURSTER.PresetSpawnData[3] = {
	map="cs_havana",
	spawns={
		Vector(-216,-772,0),Vector(-335,94,16),Vector(-427,522,24),Vector(520,416,16),
		Vector(457,-330,32),Vector(-869,-57,16),Vector(791,651,256),Vector(180,1193,248),
		Vector(-277,597,240),Vector(671,33,240),Vector(817,628,256),Vector(739,1800,256),
		Vector(-478,1560,256)
	}
}
CHESTBURSTER.PresetSpawnData[4] = {
	map="cs_italy",
	spawns={
		Vector(570,-422,-159),Vector(-697,-1609,-239),Vector(-117,963,-159),Vector(-1240,1683,-151),
		Vector(-821,1119,0),Vector(234,2178,0),Vector(810,2404,128),Vector(-1052,-1954,-151)
	}
}
CHESTBURSTER.PresetSpawnData[5] = {
	map="cs_militia",
	spawns={
		Vector(354,512,-15),Vector(304,259,-15),Vector(444,-896,-171),Vector(957,971,-159),
		Vector(623,1235,-153),Vector(451,1814,-159),Vector(480,1800,-313),Vector(1911,1016,-317),
		Vector(668,-893,-323),Vector(492,490,-151),Vector(262,915,-151),Vector(1027,397,-151),
		Vector(1103,489,-23),Vector(1950,-2106,-159)
	}
}
CHESTBURSTER.PresetSpawnData[6] = {
	map="cs_office",
	spawns={
		Vector(1133,969,-159),Vector(637,537,-159),Vector(-488,154,-159),Vector(-1347,-1797,-335),
		Vector(119,-1699,-335),Vector(1083,-898,-159),Vector(1370,170,-159),Vector(1710,681,-159),
		Vector(1524,-497,-159),Vector(-1201,207,-326),Vector(-1592,-200,-239),Vector(-1200,562,-330),
		Vector(-511,578,-159),Vector(676,-1424,-279)
	}
}
CHESTBURSTER.PresetSpawnData[7] = {
	map="de_aztec",
	spawns={
		Vector(-394,-1078,-530),Vector(1906,1254,-535),Vector(478,690,-533),Vector(2580,280,-293),
		Vector(259,205,-223),Vector(-1033,-1090,-223),Vector(-1789,358,-221),Vector(-2816,-1261,-216),
		Vector(-2701,923,-318),Vector(-1683,-1152,-223),Vector(-291,-1487,-226)
	}
}
CHESTBURSTER.PresetSpawnData[8] = {
	map="de_cbble",
	spawns={
		Vector(-1040,2312,128),Vector(-2352,2309,0),Vector(-2287,227,-255),Vector(-2257,-2071,0),
		Vector(1067,-1663,0),Vector(-566,884,0),Vector(-16,1884,0),Vector(383,2305,-255),
		Vector(-3248,400,0),Vector(-2948,-458,3),Vector(-2735,-1791,48),Vector(-1475,1972,0),
		Vector(657,-154,0),Vector(-589,-1173,-127)
	}
}
CHESTBURSTER.PresetSpawnData[9] = {
	map="de_chateau",
	spawns={
		Vector(1531,1330,0),Vector(144,1172,0),Vector(-348,-42,0),Vector(584,-137,0),
		Vector(132,72,-39),Vector(1231,-166,-159),Vector(2948,581,-159),Vector(2957,1253,-1),
		Vector(2237,1228,0),Vector(713,1218,208),Vector(762,344,236),Vector(738,697,0),
		Vector(836,1199,0),Vector(998,2101,0),Vector(1449,2683,-7),Vector(1679,-525,-159),
		Vector(1550,2040,0)
	}
}
CHESTBURSTER.PresetSpawnData[10] = {
	map="de_dust",
	spawns={
		Vector(22,3143,-5),Vector(1653,3346,-127),Vector(-1521,3503,6),Vector(8,1340,32),
		Vector(661,-1678,64),Vector(-763,-673,0),Vector(-899,227,32),Vector(-1771,2833,32),
		Vector(615,3726,48),Vector(-1064,1604,-191),Vector(362,614,0),Vector(1970,1087,32),
		Vector(2356,425,0)
	}
}
CHESTBURSTER.PresetSpawnData[11] = {
	map="de_dust2",
	spawns={
		Vector(-2100,1141,32),Vector(-1916,2764,32),Vector(242,2291,-125),Vector(796,2540,96),
		Vector(649,475,2),Vector(-2030,-813,131),Vector(-1833,633,32),Vector(-1422,1137,32),
		Vector(1707,625,64),Vector(-1564,2642,1)
	}
}
CHESTBURSTER.PresetSpawnData[12] = {
	map="de_inferno",
	spawns={
		Vector(-630,701,-31),Vector(854,-120,90),Vector(-1636,360,-63),Vector(-1029,502,-39),
		Vector(732,2853,128),Vector(139,2491,160),Vector(52,3054,160),Vector(1943,2386,140),
		Vector(2361,2338,123),Vector(2593,1203,160),Vector(1051,-108,256),Vector(-122,600,64),
		Vector(-364,282,182),Vector(-322,-426,192),Vector(858,-661,97),Vector(2546,-140,80),
		Vector(2032,534,160)
	}
}
CHESTBURSTER.PresetSpawnData[13] = {
	map="de_nuke",
	spawns={
		Vector(-2663,-639,-416),Vector(36,-873,-415),Vector(689,84,-415),Vector(614,-957,-767),
		Vector(1567,-2208,-639),Vector(2301,-1573,-415),Vector(2011,-2272,-415),Vector(610,-620,-415),
		Vector(56,-872,-95),Vector(-11,-455,-171),Vector(1363,-2233,-415),Vector(392,-1640,-415),
		Vector(3357,-931,-351),Vector(1162,-926,-415),Vector(-1102,-1222,-379),Vector(711,840,-479),
		Vector(1204,-422,-415)
	}
}
CHESTBURSTER.PresetSpawnData[14] = {
	map="de_piranesi",
	spawns={
		Vector(-836,661,449),Vector(58,356,512),Vector(1275,176,369),Vector(1186,214,160),
		Vector(1738,1127,256),Vector(-1083,2248,144),Vector(-1680,2425,224),Vector(-540,1435,353),
		Vector(-238,-733,96),Vector(-2627,-178,152),Vector(-1349,1028,288),Vector(466,1267,64),
		Vector(1377,586,352),Vector(720,-151,96),Vector(151,-771,-66),Vector(-1592,-246,160),
		Vector(-864,-118,96),Vector(-580,538,193),Vector(-1153,1399,108)
	}
}
CHESTBURSTER.PresetSpawnData[15] = {
	map="de_port",
	spawns={
		Vector(-2396,-1327,512),Vector(-2852,1154,640),Vector(-2861,-1063,640),Vector(975,-3558,776),
		Vector(975,-1871,770),Vector(380,-1008,640),Vector(1251,496,448),Vector(1078,-210,448),
		Vector(1609,-474,448),Vector(2293,-684,512),Vector(1153,154,649),Vector(-1936,-366,512),
		Vector(-769,620,512),Vector(-1483,-387,512),Vector(-156,-745,512),Vector(-362,-1189,640),
		Vector(71,-2043,767),Vector(-2326,1602,512),Vector(2527,1438,512),Vector(-1543,938,512)
	}
}
CHESTBURSTER.PresetSpawnData[16] = {
	map="de_prodigy",
	spawns={
		Vector(2478,597,-383),Vector(97,490,-295),Vector(195,70,-255),Vector(339,-408,-207),
		Vector(593,-335,-305),Vector(905,-1482,-399),Vector(1737,-1269,-479),Vector(2008,-825,-479),
		Vector(1308,-1069,-287),Vector(1077,-770,-247),Vector(1969,-459,-287),Vector(1785,-52,-415),
		Vector(1988,-272,-415),Vector(1562,926,-383),Vector(982,563,-255)
	}
}
CHESTBURSTER.PresetSpawnData[17] = {
	map="de_tides",
	spawns={
		Vector(-1126,347,0),Vector(-1125,-1418,-122),Vector(-110,-1410,16),Vector(326,-1715,0),
		Vector(770,-1346,-88),Vector(705,21,-149),Vector(-280,1035,-112),Vector(-1090,831,-94),
		Vector(-1376,-424,-15),Vector(-1034,-1823,0),Vector(-917,-959,0),Vector(-1074,1179,-95),
		Vector(-772,156,-127)
	}
}
CHESTBURSTER.PresetSpawnData[18] = {
	map="de_train",
	spawns={
		Vector(1646,-1433,-323),Vector(1926,-895,-323),Vector(1311,514,-215),Vector(617,1581,-221),
		Vector(-688,995,-215),Vector(-1812,1623,-227),Vector(6,1682,-103),Vector(-182,399,-222),
		Vector(-269,69,-215),Vector(557,35,-215),Vector(470,-550,-221),Vector(664,-1134,-351),
		Vector(96,-1406,-351),Vector(832,-1416,-351),Vector(-843,130,16),Vector(-982,-1027,-151),
		Vector(112,-1727,-103),Vector(1659,-1719,-323),Vector(-724,813,40),Vector(1418,1574,-222),
		Vector(-884,1151,-215)
	}
}
CHESTBURSTER.PresetSpawnData[19] = {
	map="dm_lockdown",
	spawns={
		Vector(-3920,1495,0),Vector(-3606,2105,-3),Vector(-3024,2440,-2),Vector(-2988,3133,-0),
		Vector(-3968,2809,-1),Vector(-3342,1687,-2),Vector(-3507,3436,0),Vector(-3112,3920,0),
		Vector(-3591,4306,0),Vector(-3275,4595,128),Vector(-2484,4080,128),Vector(-2703,3087,128),
		Vector(-3901,6087,0),Vector(-2887,5286,0),Vector(-3629,5146,0),Vector(-4013,4531,0),
		Vector(-3123,4042,128)
	}
}
CHESTBURSTER.PresetSpawnData[20] = {
	map="dm_overwatch",
	spawns={
		Vector(6596,6545,192),Vector(7410,6309,192),Vector(6605,6300,192),Vector(6135,6577,384),
		Vector(6354,6326,384),Vector(7385,6312,384),Vector(5362,7147,-3),Vector(7906,7577,0),
		Vector(7567,6588,0),Vector(5869,5745,4),Vector(7396,6660,0),Vector(6308,6582,0),
		Vector(6588,6314,0),Vector(5728,6284,0),Vector(5835,7257,0),Vector(6380,6689,384)
	}
}
CHESTBURSTER.PresetSpawnData[21] = {
	map="dm_powerhouse",
	spawns={
		Vector(-0,493,32),Vector(419,463,32),Vector(671,34,32),Vector(887,-898,32),
		Vector(1193,-1477,32),Vector(421,-1761,32),Vector(-33,-2036,32),Vector(-404,-2583,32),
		Vector(90,-2534,32),Vector(-115,-2538,192),Vector(-545,-2073,192),Vector(-1445,-1049,192),
		Vector(-630,-887,192),Vector(-635,288,192),Vector(37,273,136),Vector(-544,-74,32),
		Vector(-568,-968,32),Vector(-853,-75,32),Vector(-59,-47,32),Vector(945,-772,192),
		Vector(55,-1368,196),Vector(322,-2008,192),Vector(-65,-2527,480),Vector(488,-1513,480),
		Vector(-143,-1552,192)
	}
}
CHESTBURSTER.PresetSpawnData[22] = {
	map="dm_resistance",
	spawns={
		Vector(452,-242,-1215),Vector(-434,-886,-1213),Vector(-332,1666,-1215),Vector(359,1970,-1135),
		Vector(631,1502,-1135),Vector(-261,883,-1341),Vector(-569,-97,-1215),Vector(171,299,-1215),
		Vector(629,489,-1215),Vector(380,1167,-1215),Vector(177,-931,-1208),Vector(-371,1891,-1215),
		Vector(-66,-196,-951)
	}
}
CHESTBURSTER.PresetSpawnData[23] = {
	map="dm_runoff",
	spawns={
		Vector(10430,2833,-255),Vector(9813,2552,-255),Vector(10285,1877,-255),Vector(10601,1522,-255),
		Vector(9811,1700,-255),Vector(7983,527,-255),Vector(11081,4014,-255),Vector(11869,4079,-463),
		Vector(11493,2430,-475),Vector(11863,1339,-471),Vector(10717,1203,-476),Vector(8033,1457,-408),
		Vector(9130,820,-483),Vector(8250,3607,-474),Vector(7252,3776,-439),Vector(11046,2841,-255),
		Vector(9604,3848,-491),Vector(7717,4188,-419),Vector(10898,1813,-255),Vector(10449,2411,-255)
	}
}
CHESTBURSTER.PresetSpawnData[24] = {
	map="dm_steamlab",
	spawns={
		Vector(-1245,2508,888),Vector(-1066,1949,888),Vector(-1799,1538,800),Vector(-2379,1441,716),
		Vector(-3034,1916,888),Vector(-2762,2831,888),Vector(-2674,2269,1016),Vector(-2089,2401,1032),
		Vector(-1779,2076,1032),Vector(-1439,3348,1016),Vector(-1803,3035,888),Vector(-2316,3026,888),
		Vector(-2453,1519,1032),Vector(-1764,1480,1146),Vector(-2005,2127,1164),Vector(-3620,1580,780)
	}
}
CHESTBURSTER.PresetSpawnData[25] = {
	map="dm_underpass",
	spawns={
		Vector(-172,-1524,-431),Vector(-24,-1021,-179),Vector(-7,-1826,8),Vector(-773,-370,8),
		Vector(-1063,-645,-399),Vector(-122,-2424,-431),Vector(-1041,-2361,-311),Vector(-288,-2231,6),
		Vector(-708,-1607,0),Vector(459,-1378,0),Vector(211,-486,320),Vector(260,-211,160),
		Vector(-421,-868,-139),Vector(-627,-869,-493),Vector(-786,-2490,-431)
	}
}