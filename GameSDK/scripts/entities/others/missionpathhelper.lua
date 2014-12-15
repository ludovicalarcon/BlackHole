--------------------------------------------------------------------------
--	Crytek Source File.
-- 	Copyright (C), Crytek Studios, 2001-2010.
--------------------------------------------------------------------------
--	$Id$
--	$DateTime$
--	Description: Mission navigation path helper
--
--------------------------------------------------------------------------
--  History:
--  - 18:5:2010   : Created by Kevin Kirst
--------------------------------------------------------------------------

MissionPathHelper =
{
	Properties =
	{
		mission_MissionID = "",    -- Mission objective ID
	},

	Editor =
	{
		Model = "Editor/Objects/T.cgf",
		Icon = "TagPoint.bmp",
	},
}

--------------------------------------------------------------------------
function MissionPathHelper:OnPropertyChange()
	self:Reset();
end

--------------------------------------------------------------------------
function MissionPathHelper:OnReset()
	self:Reset();
end

--------------------------------------------------------------------------
function MissionPathHelper:OnSpawn()
	self:Reset();
end

--------------------------------------------------------------------------
function MissionPathHelper:OnDestroy()
end

--------------------------------------------------------------------------
function MissionPathHelper:Reset()

	if (self.Properties.mission_MissionID ~= "") then
		self.missionID = self.Properties.mission_MissionID;
	else
		self.missionID = self:GetName();
	end

	HUD.SetObjectivePathHelperEntity(self.missionID, self.id);

end

--------------------------------------------------------------------------
MissionPathHelper.FlowEvents =
{
	Inputs =
	{

	},

	Outputs =
	{

	},
}
