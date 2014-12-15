AI.TacticalPositionManager.SDKGrunt = AI.TacticalPositionManager.SDKGrunt or {};

function AI.TacticalPositionManager.SDKGrunt:OnInit()

	AI.RegisterTacticalPointQuery({
		Name = "SDKGrunt_OpenCombat",
		{
			Generation =
			{
				grid_around_attentionTarget = 15,
			},
			Conditions =
			{
				canShoot_to_attentionTarget = true,
				min_distance_to_attentionTarget = 5,
				max_distance_to_attentionTarget = 15,
				isInNavigationMesh = true,
			},
			Weights =	-- must be present, even if empty
			{
			}
		}
	});

	AI.RegisterTacticalPointQuery({
		Name = "SDKGrunt_CoverToShootFrom",
		{
			Generation =
			{
				cover_from_attentionTarget_around_puppet = 15.0,
			},
			Conditions =
			{
				hasShootingPosture_to_attentionTarget = true,
				min_distance_to_attentionTarget = 5,
			},
			Weights =	-- must be present, even if empty
			{
			},
		}
	});

end
