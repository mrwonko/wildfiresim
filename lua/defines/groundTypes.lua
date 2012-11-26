GroundType{
	--name = "test";
	name = "grass";
	image = "ground/test.png";
	scorched = "test_scorched";
	
	ignitionTemperature = 300;
	burnTemperature = 650;
	burnDuration = 10;--30*60;
	heatConstant = 1.2e-10;
	
	--[[
	mass = 20;
	massLossRate = 1;
	--]]
}

GroundType{
	name = "stroh";
	image = "ground/stroh.png";
	scorched = "test_scorched";
	
	ignitionTemperature = 200;
	burnTemperature = 650;
	burnDuration = 8;--30*60;
	heatConstant = 1.5e-10;
	
	--[[
	mass = 20;
	massLossRate = 1;
	--]]
}

GroundType{
	name = "erde";
	image = "ground/erde.png";
	incombustible = true;
}

GroundType{
	name = "test_scorched";
	image = "ground/test_scorched.png";
	incombustible = true;
}