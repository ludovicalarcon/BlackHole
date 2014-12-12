FogVolume =
{
	type = "FogVolume",

	Properties =
	{
		bActive = 1, --[0,1,1,"If true, fog volume will be enabled."]
		eiVolumeType = 0, --[0,1,1,"Specifies the volume type. The following types are currently supported: 0 - Ellipsoid, 1 - Cube."
		Size = { x = 1, y = 1, z = 1 },
		color_Color = { x = 1, y = 1, z = 1 },
		fHDRDynamic = 0, --[-10,20,0.01,"Specifies how much brighter than the default 255,255,255 white the fog is."]
		bUseGlobalFogColor = 0, --[0,1,1,"If true, the Color property is ignored. Instead, the current global fog color is used."]
		GlobalDensity = 1.0, --[0,1000,1,"Controls the density of the fog. The higher the value the more dense the fog and the less you'll be able to see objects behind or inside the fog volume."]
		DensityOffset = 0.0, --[-1000,1000,1,"Offset fog density, used in conjunction with the GlobalDensity parameter."]
		NearCutoff = 0.0,  --[0,2,0.1,"Stop rendering the object, depending on camera distance to object."]
		FallOffDirLong = 0.0, --[0,360,1,"Controls the longitude of the world space fall off direction of the fog. 0 represents East, rotation is counter-clockwise."]
		FallOffDirLati = 90.0, --[0,360,1,"Controls the latitude of the world space fall off direction of the fog. 90 lets the fall off direction point upwards in world space."]
		FallOffShift = 0.0, --[-100,100,0.1,"Controls how much to shift the fog density distribution along the fall off direction in world units (m)."]
		FallOffScale = 1.0, --[-100,100,0.01,"Scales the density distribution along the fall off direction. Higher values will make the fog fall off more rapidly and generate thicker fog layers along the negative fall off direction."]
		SoftEdges = 1.0, --[0,1,0.01,"Specifies a factor that is used to soften the edges of the fog volume when viewed from outside."
	},

	Fader = 
	{
		fadeTime = 0.0,
		fadeToValue = 0.0,
	},

	Editor = 
	{
		Model = "Editor/Objects/invisiblebox.cgf",
		Icon = "FogVolume.bmp",
		ShowBounds = 1,
	},
}


function FogVolume:OnSpawn()
	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
	self:SetFlags(ENTITY_FLAG_NO_PROXIMITY, 0);
end

-------------------------------------------------------
function FogVolume:InitFogVolumeProperties()
	--System.Log( "FogVolume:InitFogVolumeProperties" )
	local props = self.Properties;
	self:LoadFogVolume( 0, self.Properties );
end;

-------------------------------------------------------
function FogVolume:CreateFogVolume()
	--System.Log( "FogVolume:CreateFogVolume" )
	self:InitFogVolumeProperties()
	self.active = true;
end

-------------------------------------------------------
function FogVolume:DeleteFogVolume()
	--System.Log( "FogVolume:DeleteFogVolume" )
	self:FreeSlot( 0 );
	self.active = false;
end

-------------------------------------------------------
function FogVolume:OnInit()
	self.active = false;
	if( self.Properties.bActive == 1 ) then
		self:CreateFogVolume();
	end
end

-------------------------------------------------------
function FogVolume:CheckMove()
end

-------------------------------------------------------
function FogVolume:OnShutDown()
end

-------------------------------------------------------
function FogVolume:OnPropertyChange()
	--System.Log( "FogVolume:OnPropertyChange" )
	if( self.Properties.bActive == 1 ) then
		self:CreateFogVolume();
	else
		self:DeleteFogVolume();
	end
end

-------------------------------------------------------
-- optimization for common animated trackview properties, to avoid fully recreating everything on every animated frame
function FogVolume:OnPropertyAnimated( name )
	local changeTakenCareOf = false;
	if (name=="GlobalDensity") then
		self:FadeGlobalDensity(0, 0, self.Properties.GlobalDensity);  -- using fade with 0 time as there is not a 'set' function.
		changeTakenCareOf = true;
	end
	return changeTakenCareOf;
end


-------------------------------------------------------
function FogVolume:OnReset()
	self.active = false;
	if( self.Properties.bActive == 1 ) then
		self:CreateFogVolume();
	end
end

-------------------------------------------------------
-- Hide Event
-------------------------------------------------------
function FogVolume:Event_Hide()
	self:DeleteFogVolume();
	BroadcastEvent(self, "Hide");
end

-------------------------------------------------------
-- Show Event
-------------------------------------------------------
function FogVolume:Event_Show()
	self:CreateFogVolume();
	BroadcastEvent(self, "Show");
end

-------------------------------------------------------
-- Fade Event
-------------------------------------------------------
function FogVolume:Event_Fade()
	--System.Log("Do Fading");
	self:FadeGlobalDensity(0, self.Fader.fadeTime, self.Fader.fadeToValue);
end

-------------------------------------------------------
-- Fade Time Event
-------------------------------------------------------
function FogVolume:Event_FadeTime(i, time)
	--System.Log("Fade time "..tostring(time));
	self.Fader.fadeTime = time;
end

-------------------------------------------------------
-- Fade Value Event
-------------------------------------------------------
function FogVolume:Event_FadeValue(i, val)
	--System.Log("Fade val "..tostring(val));
	self.Fader.fadeToValue = val;
end

-------------------------------------------------------
-- Serialization
-------------------------------------------------------

function FogVolume:OnLoad(table)
	if(self.active and not table.active) then
		self:DeleteFogVolume();
	elseif(not self.active and table.active) then
		self:CreateFogVolume();
	end
	self.active = table.active;
end

-------------------------------------------------------

function FogVolume:OnSave(table)
	table.active = self.active;
end

-------------------------------------------------------

FogVolume.FlowEvents =
{
	Inputs =
	{
		Hide  = { FogVolume.Event_Hide, "bool" },
		Show  = { FogVolume.Event_Show, "bool" },
		x_Time  = { FogVolume.Event_FadeTime, "float" },
		y_Value = { FogVolume.Event_FadeValue, "float" },
		z_Fade  = { FogVolume.Event_Fade, "bool" },
	},
	Outputs =
	{
		Hide = "bool",
		Show = "bool",
	},
}
