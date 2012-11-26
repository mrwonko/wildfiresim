--[[
TreeType{
	name = "test";
	image = "trees/test.png";
	scorched = "stump";
	
	--old things
	mass = 60000,
	humidity = 0.5,
	area = 90,
	absorption = 0.94,
	heatCapacity = 2.2,
	ignitionTemperature = 510, --800?
	heizwert = 10,
	massLossRate = 1000, --mass per second when burning
	--new things
	burnDuration = 30;
	ignitionTemperature = 500;
	burnTemperature = 1000;
	heatConstant = 1e-10;
}
--]]

TreeType{
	name = "Nadelbaum";
	image = "trees/nadel.png";
	scorched = "stump";
	burnDuration = 15;
	ignitionTemperature = 500;
	burnTemperature = 1000;
	heatConstant = 1e-10;
}

TreeType{
	name = "Laubbaum";
	image = "trees/laub.png";
	scorched = "stump";
	burnDuration = 30;
	ignitionTemperature = 800;
	burnTemperature = 1000;
	heatConstant = 1e-10;
}

TreeType{
	name = "stump";
	image = "trees/stump.png";
	incombustible = true;
}