Light =
{
	Properties =
	{
		_nVersion = -1,
		bActive = 1, --[0,1,1,"Turns the light on/off."]
		_bCheapLight = 0,
		bForceDisableCheapLight = 0, --[0,100,1,"Automatic memory optimization of lights, based on settings."]
		Radius = 10, --[0,100,1,"Specifies how far from the source the light affects the surrounding area."]
		Style =
		{
			nLightStyle = 0, --[0,48,1,"Specifies a preset animation for the light to play."]
			fAnimationSpeed = 1, --[0,100,0.1,"Specifies the speed at which the light animation should play."]
			nAnimationPhase = 0, --[0,100,1,"This will start the light style at a different point along the sequence."]
			bAttachToSun = 0, --[0,1,1,"When enabled, sets the Sun to use the Flare properties for this light."]
			lightanimation_LightAnimation = "",
			bTimeScrubbingInTrackView = 0,
			_fTimeScrubbed = 0,
		},
		Projector =
		{
			texture_Texture = "",
			bProjectInAllDirs = 0, --[0,1,1,"Makes the light project omni-directionally."]
			fProjectorFov = 90, --[0,160,1,"Specifies the Angle on which the light texture is projected."]
			fProjectorNearPlane = 0, --[0,100,0.1,"Set the near plane for the projector, any surfaces closer to the light source than this value will not be projected on."]
		},
		Color =
		{
			clrDiffuse = { x=1,y=1,z=1 },
			fDiffuseMultiplier = 1, --[0,100,0.1,"Control the strength of the diffuse color."]
			fSpecularMultiplier = 1, --[0,100,0.1,"Control the strength of the specular brightness."]
			fHDRDynamic = 0, --[0,100,0.1,"Specifies how much brighter than the default 255,255,255 white the light is."]
		},
		Options =
		{
			nCastShadows = 0,
			fShadowBias = 1, --[0,1000,1,"Moves the shadow cascade toward or away from the shadow-casting object."]
			fShadowSlopeBias = 1, --[0,1000,1,"Allows you to adjust the gradient (slope-based) bias used to compute the shadow bias."]
			fShadowResolutionScale = 1,
			bAffectsThisAreaOnly = 1, --[0,1,1,"Set this parameter to false to make light cast in multiple visareas."]
			bIgnoresVisAreas = 0, --[0,1,1,"Controls whether the light should respond to visareas."]
			bAmbient = 0, --[0,1,1,"Makes the light behave like an ambient light source, with no point of origin."]
			bFakeLight = 0, --[0,1,1,"Disables light projection, useful for lights which you only want to have Flare effects from."]
			bDeferredClipBounds = 0, --[0,1,1,"Specifies that the light is linked to a light box or light shape and to use the volume of the target area for clipping."]
			bDeferredLight = 1, -- [0,1,1,"Set light to be deferred or not. NOTE: e_DynamicLightsForceDeferred overrides this if set."]
			bIrradianceVolumes = 0, --[0,1,1,"Enable when used inside an Irradiance Volume."]
			bDisableX360Opto = 0, --[0,1,1,"Alternative rendering option for Xbox360 when using clipbound lights."]
			texture_deferred_cubemap = "",
			file_deferred_clip_geom = "",
			nShadowMinResPercent = 0, --[0,100,1,"Percentage of the shadow pool the light should use for its shadows."]
			fShadowUpdateMinRadius = 10, --[0,100,0.1,"Define the minimum radius from the light source to the player camera that the ShadowUpdateRatio setting will be ignored."]
			fShadowUpdateRatio = 1, --[0,10,0.01,"Define the update ratio for shadow maps cast from this light."]
			bFlareEnable = 1,
			flare_Flare = "",
			fFlareFOV = 360, --[0,360,1,"FOV for the flare."]
			SortPriority = 0,
			fAttenuationFalloffMax = 1, --[0,1,0.01,"Controls the light fall-off. This can only be used for Ambient lights."]
		},
		Shape =
		{
			bAreaLight = 0, --[0,1,1,"Used to turn the selected light entity into an Area Light."]
			bTextureReflection = 1, --[0,1,1,"Renders the texture in the reflection, as well as in the projection."]
			fDiffuseSoftness = 0.75, --[0,1,0.05,"Control the softness of the projected texture."]
			fPlaneWidth = 1, --[0,100,0.1,"Set the width of the Area Light shape."]
			fPlaneHeight = 1, --[0,100,0.1,"Set the height of the Area Light shape."]
			fLightFov = 180, --[0,180,1,"Control the size/shape of the cone or Field of View of the light projection."]
			texture_Texture = "",
			vFadeDimensionsLeft =0,
			vFadeDimensionsRight =0,
			vFadeDimensionsNear =0,
			vFadeDimensionsFar =0,
			vFadeDimensionsTop =0,
			vFadeDimensionsBottom =0,
		},
	},

	Editor =
	{
		Model="Editor/Objects/Light_Omni.cgf",
		Icon="Light.bmp",
		ShowBounds=0,
		AbsoluteRadius = 1,
		IsScalable = false;
	},

	_LightTable = {},
}

LightSlot = 1

function Light:OnInit()
	--self:NetPresent(0);
	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
	self:OnReset();
	self:CacheResources("Light.lua");
end

function Light:CacheResources(requesterName)
	local textureFlags = 0;
	if (self.Properties.Projector.bProjectInAllDirs ~= 0 and self.Properties.Options.bDeferredLight ~= 0) then
		textureFlags = eGameCacheResourceFlag_TextureReplicateAllSides;
	end
	Game.CacheResource(requesterName, self.Properties.Projector.texture_Texture, eGameCacheResourceType_Texture, textureFlags);
	Game.CacheResource(requesterName, self.Properties.Shape.texture_Texture, eGameCacheResourceType_Texture, 0);
	Game.CacheResource(requesterName, self.Properties.Options.texture_deferred_cubemap, eGameCacheResourceType_TextureDeferredCubemap, 0);
	Game.CacheResource(requesterName, self.Properties.Options.file_deferred_clip_geom, eGameCacheResourceType_StaticObject, 0);
end

function Light:OnShutDown()
	self:FreeSlot(LightSlot);
end

function Light:OnLoad(props)
	self:OnReset()
	self:ActivateLight(props.bActive)
end

function Light:OnSave(props)
	props.bActive = self.bActive
end

function Light:OnPropertyChange()
	self:OnReset();
	self:ActivateLight( self.bActive );
	if (self.Properties.Options.bDeferredClipBounds) then
		self:UpdateLightClipBounds(LightSlot);
	end
end

-- Optimization for common animated trackview properties, to avoid fully recreating everything on every animated frame
function Light:OnPropertyAnimated( name )
	local changeTakenCareOf = false;

	if (name=="fDiffuseMultiplier" or name=="fSpecularMultiplier" or name=="fHDRDynamic") then
		changeTakenCareOf = true;
		local Color = self.Properties.Color;
		local diffuse_mul = Color.fDiffuseMultiplier;
		local specular_multiplier = 1;
		local diffuse_color = { x=Color.clrDiffuse.x*diffuse_mul, y=Color.clrDiffuse.y*diffuse_mul, z=Color.clrDiffuse.z*diffuse_mul };
		if (diffuse_mul ~= 0) then
			specular_multiplier = Color.fSpecularMultiplier / diffuse_mul;
		end
		self:SetLightColorParams( LightSlot, diffuse_color, specular_multiplier, Color.fHDRDynamic );
	end

	return changeTakenCareOf;
end


function Light:OnSysSpecLightChanged()
	self:OnPropertyChange();
end

function Light:OnLevelLoaded()
	if (self.Properties.Options.bDeferredClipBounds) then
		self:UpdateLightClipBounds(LightSlot);
	end
end

function Light:OnReset()
	if (self.bActive ~= self.Properties.bActive) then
		self:ActivateLight( self.Properties.bActive );
	end
end

function Light:ActivateLight( enable )
	if (enable and enable ~= 0) then
		self.bActive = 1;
		self:LoadLightToSlot(LightSlot);
		self:ActivateOutput( "Active",true );
	else
		self.bActive = 0;
		self:FreeSlot(LightSlot);
		self:ActivateOutput( "Active",false );
	end
end

function Light:LoadLightToSlot( nSlot )
	local props = self.Properties;
	local Style = props.Style;
	local Projector = props.Projector;
	local Color = props.Color;
	local Options = props.Options;
	local Shape = props.Shape;

	local diffuse_mul = Color.fDiffuseMultiplier;
	local specular_mul = Color.fSpecularMultiplier;

	local lt = self._LightTable;
	lt.style = Style.nLightStyle;

	lt.attach_to_sun = Style.bAttachToSun;

	lt.anim_speed = Style.fAnimationSpeed;
	lt.anim_phase = Style.nAnimationPhase;
	lt.light_animation = Style.lightanimation_LightAnimation;
	lt.time_scrubbing_in_trackview = Style.bTimeScrubbingInTrackView;
	lt.time_scrubbed = Style._fTimeScrubbed;

	lt.cheapLight = props._bCheapLight;
	lt.radius = props.Radius;
	lt.diffuse_color = { x=Color.clrDiffuse.x*diffuse_mul, y=Color.clrDiffuse.y*diffuse_mul, z=Color.clrDiffuse.z*diffuse_mul };
	if (diffuse_mul ~= 0) then
		lt.specular_multiplier = specular_mul / diffuse_mul;
	else
		lt.specular_multiplier = 1;
	end

	lt.hdrdyn = Color.fHDRDynamic;
	lt.projector_texture = Projector.texture_Texture;
	lt.proj_fov = Projector.fProjectorFov;
	lt.proj_nearplane = Projector.fProjectorNearPlane;
	lt.cubemap = Projector.bProjectInAllDirs;
	lt.this_area_only = Options.bAffectsThisAreaOnly;
	lt.hasclipbound = Options.bDeferredClipBounds;
	lt.ignore_visareas = Options.bIgnoresVisAreas;
	lt.disable_x360_opto = Options.bDisableX360Opto;
	lt.fake = Options.bFakeLight;
	lt.deferred_light = Options.bDeferredLight;
	lt.irradiance_volumes = Options.bIrradianceVolumes;
	lt.ambient = props.Options.bAmbient;
	lt.indoor_only = 0;
	lt.cast_shadow = Options.nCastShadows;
	lt.shadow_bias = Options.fShadowBias;
	lt.shadow_slope_bias = Options.fShadowSlopeBias;
	lt.shadowResolutionScale = Options.fShadowResolutionScale;
	lt.deferred_cubemap = Options.texture_deferred_cubemap;
	lt.deferred_geom = Options.file_deferred_clip_geom;
	lt.shadowMinResolution = Options.nShadowMinResPercent;
	lt.shadowUpdate_MinRadius = Options.fShadowUpdateMinRadius;
	lt.shadowUpdate_ratio = Options.fShadowUpdateRatio;
	lt.flare_enable = Options.bFlareEnable;
	lt.flare_Flare = Options.flare_Flare;
	lt.flare_FOV = Options.fFlareFOV;

	lt.area_light = Shape.bAreaLight;
	lt.area_width = Shape.fPlaneWidth;
	lt.area_height = Shape.fPlaneHeight;
	lt.area_fov = Shape.fLightFov;
	lt.area_spec_tex = Shape.bTextureReflection;
	lt.area_diffuse_softness = Shape.fDiffuseSoftness;
	lt.reflection_texture = Shape.texture_Texture;

	lt.fade_dimensions_left = Shape.vFadeDimensionsLeft;
	lt.fade_dimensions_right = Shape.vFadeDimensionsRight;
	lt.fade_dimensions_near = Shape.vFadeDimensionsNear;
	lt.fade_dimensions_far = Shape.vFadeDimensionsFar;
	lt.fade_dimensions_top = Shape.vFadeDimensionsTop;
	lt.fade_dimensions_bottom = Shape.vFadeDimensionsBottom;

	lt.sort_priority = Options.SortPriority;
	lt.attenuation_falloff_max = Options.fAttenuationFalloffMax;

	lt.lightmap_linear_attenuation = 1;
	lt.is_rectangle_light = 0;
	lt.is_sphere_light = 0;
	lt.area_sample_number = 1;

	self:LoadLight( nSlot,lt );
end

function Light:Event_Enable()
	if (self.bActive == 0) then
		self:ActivateLight( 1 );
	end
end

function Light:Event_Disable()
	if (self.bActive == 1) then
		self:ActivateLight( 0 );
	end
end

function Light:NotifySwitchOnOffFromParent(wantOn)
  local wantOff = wantOn~=true;
	if (self.bActive == 1 and wantOff) then
		self:ActivateLight( 0 );
	elseif (self.bActive == 0 and wantOn) then
		self:ActivateLight( 1 );
	end
end

------------------------------------------------------------------------------------------------------
-- Event Handlers
------------------------------------------------------------------------------------------------------
function Light:Event_Active(sender, bActive)
	if (self.bActive == 0 and bActive == true) then
		self:ActivateLight( 1 );
	else
		if (self.bActive == 1 and bActive == false) then
			self:ActivateLight( 0 );
		end
	end
end

function Light:Event_Radius( sender, Radius )
	self.Properties.Radius = Radius;
	self:OnPropertyChange();
end

function Light:Event_DiffuseColor( sender, DiffuseColor )
	self.Properties.Color.clrDiffuse = DiffuseColor;
	self:OnPropertyChange();
end

function Light:Event_DiffuseMultiplier( sender, DiffuseMultiplier )
	self.Properties.Color.fDiffuseMultiplier = DiffuseMultiplier;
	self:OnPropertyChange();
end

function Light:Event_SpecularMultiplier( sender, SpecularMultiplier )
	self.Properties.Color.fSpecularMultiplier = SpecularMultiplier;
	self:OnPropertyChange();
end

function Light:Event_HDRDynamic( sender, HDRDynamic )
	self.Properties.Color.fHDRDynamic = HDRDynamic;
	self:OnPropertyChange();
end

------------------------------------------------------------------------------------------------------
-- Event descriptions
------------------------------------------------------------------------------------------------------
Light.FlowEvents =
{
	Inputs =
	{
		Active = { Light.Event_Active,"bool" },
		Enable = { Light.Event_Enable,"bool" },
		Disable = { Light.Event_Disable,"bool" },
		Radius = { Light.Event_Radius,"float" },
		DiffuseColor = { Light.Event_DiffuseColor,"vec3" },
		DiffuseMultiplier = { Light.Event_DiffuseMultiplier,"float" },
		SpecularMultiplier = { Light.Event_SpecularMultiplier,"float" },
		HDRDynamic = { Light.Event_HDRDynamic,"float" },
	},
	Outputs =
	{
		Active = "bool",
	},
}
