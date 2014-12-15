-----------------------------------------------------------------------------------------------
--
--	SoundMood entity - to be attached to area
--	will set specified SoundMood settings when entering area
--  registers/updates/unregisters Presets and supports blending

SoundMoodVolume = {
	type = "SoundMoodVolume",

	Editor={
		Model="Editor/Objects/Sound.cgf",
		Icon="Sound.bmp",
	},

	Properties = {
		sSoundMoodName = "",
		OuterRadius = 2,
		bEnabled = 1,
	},

	bStarted = 0,
	bEnabled = 1,
  bIsNear = 0,
  bInside = 0,
}

function SoundMoodVolume:OnSpawn()
	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:OnLoad(table)
  self.bStarted = table.bStarted;
  self.bEnabled = table.bEnabled;
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:OnSave(table)
  table.bStarted = self.bStarted;
  table.bEnabled = self.bEnabled;
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:OnPropertyChange()
  self:SetSoundEffectRadius(self.Properties.OuterRadius);
  self.bEnabled = self.Properties.bEnabled;
  self.sSoundMoodName = self.Properties.sSoundMoodName;

  --System.Log("Property change SoundMood "..self.sSoundMoodName);
  if (self.Properties.bEnabled == 1 and (self.bIsNear == 1 or self.bInside == 1)) then
    self:RegisterSoundMood(nil);
    self:UpdateSoundMood(nil, 0, self.fFadeValue);
  else
    self:UnregisterSoundMood(nil);
  end
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:CliSrv_OnInit()
  self.bEnabled = self.Properties.bEnabled;
  self.bStarted = 0;
	self.sSoundMoodName = "";
	self:NetPresent(0);
  self.bIsNear = 0;
	self.bInside = 0;
	self.fFadeValue = 0;
	self:SetFlags(ENTITY_FLAG_VOLUME_SOUND,0);

	if (self.Initialized) then
		return
	end

	self:SetSoundEffectRadius(self.Properties.OuterRadius);
	self.Initialized=1;
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:OnShutDown()
	self:RegisterForAreaEvents(0);
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:RegisterSoundMood( player )
  if (self.bEnabled ~= 0) then
    --local Preset=ReverbPresetDB[self.Properties.reverbpresetReverbPreset];
    -- local test=nil + 1;  -- for testing unless lua debugger works
    --if (self.Properties.sSoundMood) then
	  --System.Log("Register SoundMood "..self.Properties.sSoundMoodName);
	  --System.Log("Preset "..Preset.nEnvironment);
	    if (self.bStarted == 0) then
	      Sound.RegisterSoundMood(self.Properties.sSoundMoodName);
    	  self.bStarted = 1;
        end;
    --end;
  end
end

----------------------------------------------------------------------------------------
function SoundMoodVolume:UnregisterSoundMood( player )

	--System.Log("Unregister SoundMood "..self.Properties.sSoundMood);
	if (self.bStarted ~= 0) then
	  --System.Log("Unregister SoundMood "..self.Properties.sSoundMood);
		Sound.UnregisterSoundMood(self.Properties.sSoundMoodName);
		self.bStarted = 0;

	end;

end

----------------------------------------------------------------------------------------
function SoundMoodVolume:UpdateSoundMood( player, fDistSq, fExternalFade )

  if (self.Properties.OuterRadius ~= 0) then

    --if (self.bStarted == 0) then
      --OnEnterNearArea(player, areaId);
    --end;

    --System.Log("Update SoundMood "..self.Properties.sSoundMoodName);

    if (fExternalFade == 0) then
    	if (fDistSq == 0) then
    		SoundMoodVolume.UnregisterSoundMood(self, player);
      elseif (self.bInside == 1 and self.fFadeValue ~= 1) then
      	Sound.UpdateSoundMood(self.Properties.sSoundMoodName, 1, 0);
    	  self.fFadeValue = 1;
    	  --System.Log("FADE proceed self fade"..self.fFadeValue);
	  	else
  			local fFade = 1 - (math.sqrt(fDistSq) / self.Properties.OuterRadius);
  	 		--System.Log("FADE proceed "..fFade);
  	 		if (fFade > 0) then
  	 			Sound.UpdateSoundMood(self.Properties.sSoundMoodName, fFade, 0);
    	  	self.fFadeValue = fFade;
     		end
    	end
    else
      Sound.UpdateSoundMood(self.Properties.sSoundMoodName, fExternalFade, 0);
      self.fFadeValue = fExternalFade;
    end
  end

end

----------------------------------------------------------------------------------------
function SoundMoodVolume:OnMove()
--	local newInsidePos = self:UpdateInSector(self.nBuilding,	self.nSector );
--	self.nBuilding = newInsidePos.x;
--	self.nSector = newInsidePos.y;
end

----------------------------------------------------------------------------------------
SoundMoodVolume.Server={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
}

----------------------------------------------------------------------------------------
SoundMoodVolume.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
    self:RegisterForAreaEvents(1);
		self:OnMove();
	end,

	OnShutDown=function(self)
    self:RegisterForAreaEvents(0);
	end,

	OnAudioListenerEnterNearArea = function(self,player, nAreaID,fFade )
    self.bIsNear = 1;
    self.bInside = 0;
    SoundMoodVolume.RegisterSoundMood(self,player);
	end,

	OnAudioListenerMoveNearArea = function(self,player, nAreaID,fFade,fDistsq )
    self.bIsNear = 1;
    self.bInside = 0;
    SoundMoodVolume.UpdateSoundMood(self, player, fDistsq, 0);
	end,

	OnAudioListenerEnterArea = function(self,player, nAreaID, fFade )
    self.bIsNear = 0;
    self.bInside = 1;
	  SoundMoodVolume.RegisterSoundMood(self,player);
    self.fFadeValue = 0; -- fake current value to make sure to enforce updating of fade value
	  SoundMoodVolume.UpdateSoundMood(self, player, 1, 0);
	end,

	OnAudioListenerProceedFadeArea = function(self, player, nAreaID, fExternalFade)
	  -- fExternalFade holds the fade value which was calculated by an inner, higher priority area
	  -- in the AreaManager to fade out the outer sound dependant on the biggest effect radius of all attached entities
    if (fExternalFade > 0) then
	  	self.bIsNear = 0;
      self.bInside = 1;
	  	SoundMoodVolume.RegisterSoundMood(self,player);
	  	SoundMoodVolume.UpdateSoundMood(self, player, 0, fExternalFade);
	  else
	  	SoundMoodVolume.UpdateSoundMood(self, player, 0, 0); -- this forces an un-register of this mood
	  end

	  self.fFadeValue = fExternalFade;
	end,

	OnAudioListenerLeaveArea = function(self)
    self.bIsNear = 1;
    self.bInside = 0;
	end,

	OnAudioListenerLeaveNearArea = function(self,player,areaId,fFade)
    self.bIsNear = 0;

    if (self.bInside ~= 1) then
	    SoundMoodVolume.UnregisterSoundMood(self, player);
	  end
	end,
}

----------------------------------------------------------------------------------------------------
function SoundMoodVolume:Event_Deactivate(sender)
  --System.Log("SMV: FG event - Deactivate");
  self.Properties.bEnabled = 0;
  self:OnPropertyChange();
end
----------------------------------------------------------------------------------------------------
function SoundMoodVolume:Event_Activate(sender)
  --System.Log("SMV: FG event - Activate");
  self.Properties.bEnabled = 1;
  self:OnPropertyChange();
end
----------------------------------------------------------------------------------------------------
function SoundMoodVolume:Event_Fade(sender, fFade)
  --System.Log("SMV: FG event - Fade"..tostring(fFade));
  self.fFadeValue = fFade;
  Sound.UpdateSoundMood(self.Properties.sSoundMoodName, self.fFadeValue, 0);
end


SoundMoodVolume.FlowEvents =
{
	Inputs =
	{
	  --SoundName = { SoundMoodVolume.Event_SoundName, "string" },
		--Enable = { SoundMoodVolume.Event_Enable, "bool" },
		Deactivate 	= { SoundMoodVolume.Event_Deactivate, "bool" },
		Activate   	= { SoundMoodVolume.Event_Activate, "bool" },
		Fade 				= { SoundMoodVolume.Event_Fade, "float" },
		--Volume = { SoundMoodVolume.Event_Volume, "float" },
	},
	Outputs =
	{
	},
}

