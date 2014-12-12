CTFBase = {
    Client = {},
    Server = {},
    Properties = {
		fileModelOverride	= "",
		ModelSubObject		= "main",
		Radius				= 10;
		teamName			= "";
    },
    Editor = {
	Icon		= "Item.bmp",
	IconOnTop	= 1,
    },
	HasFlag = false,
	InProximity = false,
	IsOpen = false,
}

--various constants
TIMER_ANIM_TRANSITION = 1;

CTFBase.DEFAULT_FILE_MODEL = "Objects/multiplayer/props/cw2_ctf_base/cw2_ctf_base.cdf";

function CTFBase.Server:OnInit()
	Log("CTFBase.Server.OnInit");
	if (not self.bInitialized) then
		self:OnReset();
		self.bInitialized = 1;
		self:SetViewDistRatio(255);			
	end;
	g_gameRules.game:SetTeam(g_gameRules.game:GetTeamId(self.Properties.teamName) or 0, self.id);
	self.inside = {};
end;

function CTFBase.Client:OnInit()
	Log("CTFBase.Client.OnInit");
	if (not self.bInitialized) then
		self:OnReset();
		self.bInitialized = 1;
		self:SetViewDistRatio(255);			
	end;
	self.inside = {};
end;

function CTFBase:OnReset()
	Log("CTFBase.OnReset");
	local fileModel = self.DEFAULT_FILE_MODEL;
	if (self.Properties.fileModelOverride and (self.Properties.fileModelOverride ~= "")) then
		Log("Override file model provided, using model '%s'", self.Properties.fileModelOverride);
		fileModel = self.Properties.fileModelOverride;
	end
	self:LoadObject(0, fileModel);

	local radius_2 = self.Properties.Radius / 2;

	local Min={x=-radius_2,y=-radius_2,z=-radius_2};
	local Max={x=radius_2,y=radius_2,z=radius_2};
	self:SetTriggerBBox(Min,Max);
	self:SetViewDistRatio(255);		

	self:Physicalize(0, PE_STATIC, { mass=0 });

	self:SetFlags(ENTITY_FLAG_ON_RADAR, 0);

	self:StartAnimation(0,"ctf_base_idle", 0, 0.4, 1.0, 1);
end;

----------------------------------------------------------------------------------------------------

function CTFBase:ObjectiveAttached(entityId, attach)
	Log("CTFBase:ObjectiveAttached");
	if (self.HasFlag ~= attach) then
		self.HasFlag = attach;

		local animName;
		if (attach) then
			self:SetAttachmentObject(0, "relay", entityId, -1, 0);
			animName = "ctf_base_powerup";
		else
			self:ResetAttachment(0, "relay");
			animName = "ctf_base_powerdown";
		end		
		local installed, duration = self:StartAnimation(0,animName, 0, 0.4, 1.0, 0);
		Log("CTFBase:ObjectiveAttached anim %s %d", animName, duration*1000);
		self:SetTimer(TIMER_ANIM_TRANSITION, duration*1000);
	end
end;

function CTFBase:SetInProximity(inProx)
	Log("CTFBase:SetInProximity");
	if (self.InProximity ~= inProx) then
		self.InProximity = inProx;

		if (self.HasFlag) then
			local animName;
			if (inProx) then
				animName = "ctf_base_open";
			else
				animName = "ctf_base_close";
			end		
			local installed, duration = self:StartAnimation(0,animName, 0, 0.4, 1.0, 0);
			Log("CTFBase:InProximity anim %s %d", animName, duration*1000);
			self:SetTimer(TIMER_ANIM_TRANSITION, duration*1000);
		end
	end
end;

function CTFBase.Client:OnTimer(timerId,mSec)
	Log("CTFBase:OnTimer %d", timerId);
	if (timerId == TIMER_ANIM_TRANSITION) then
		local idleAnimName;
		if (self.HasFlag) then
			if (self.InProximity) then
				idleAnimName = "ctf_base_openidle";
			else
				idleAnimName = "ctf_base_idle";
			end
		else
			idleAnimName = "ctf_base_powerdownidle";
		end
		Log("CTFBase:OnTimer anim %s", idleAnimName);
		self:StartAnimation(0,idleAnimName, 0, 0.4, 1.0, 1);
	end	
end;
