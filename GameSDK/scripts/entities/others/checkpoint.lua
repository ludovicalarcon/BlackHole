Checkpoint=
{
	Editor={
		Model="Editor/Objects/SpawnPointHelper.cgf",
		Icon="SavePoint.bmp",
	},
		
	type = "Checkpoint",

	Properties=
	{
		sFilename="TestCheckpoint",
		fLastLoadTime=0, --this is necessary to prevent saving directly after loading
	},
}


----------------------------------------------------------------------------------------------------
function Checkpoint:OnPropertyChange()
end


----------------------------------------------------------------------------------------------------
function Checkpoint:OnInit()
end

----------------------------------------------------------------------------------------------------
function Checkpoint:OnReset()
end

-----------------------------------------------------------------------------------

function Checkpoint:Event_SaveCheckpoint()
	local fCurTime = System.GetCurrTime();
	--don't save the checkpoint right after you loaded into it!
	if(fCurTime - self.Properties.fLastLoadTime  > 0.5) then 
		local success = Game.SaveCheckpoint(self.id, self.Properties.sFilename);
		if(success == true) then
			self:ActivateOutput("CheckpointSaved", true);
		end
	end
end;

-----------------------------------------------------------------------------------

function Checkpoint:Event_LoadCheckpoint()
	local success = Game.LoadCheckpoint(self.Properties.sFilename);
	if(success == false) then
		System.Log("Failed loading checkpoint %s", self.Properties.sFilename);
	end
end;

-----------------------------------------------------------------------------------

function Checkpoint:Event_OnLoadCheckpoint()
	self.Properties.fLastLoadTime = System.GetCurrTime(); --this is necessary to prevent saving directly after loading
	self:ActivateOutput("CheckpointLoaded", true);
end;

-----------------------------------------------------------------------------------

Checkpoint.FlowEvents =
{
	Inputs =
	{
		SaveCheckpoint = { Checkpoint.Event_SaveCheckpoint, "bool" },
		LoadCheckpoint = { Checkpoint.Event_LoadCheckpoint, "bool" },
	},
	Outputs =
	{
		CheckpointSaved = "bool",
		CheckpointLoaded = "bool",
	},
}