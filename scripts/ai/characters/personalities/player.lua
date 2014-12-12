-- AICharacter: Player INTERNAL



-- PLAYER CHARACTER SCRIPT

AICharacter.Player = {

	Class = UNIT_CLASS_LEADER,
	
	InitItems = function(self,entity)
	end,
	
	Constructor = function(self,entity)
		self:InitItems(entity);
		AI.ChangeParameter( entity.id, AIPARAM_COMBATCLASS, AICombatClasses.Infantry );
	end,
	
	AnyBehavior = {
	
		-----------------------------------
		-- Vehicles related - player should not be AI-enabling vehicle
		entered_vehicle = "",
		entered_vehicle_gunner = "",
	},
	
	PlayerIdle = {
		-----------------------------------
		-- Vehicles related - player should not be AI-enabling vehicle
		entered_vehicle = "",
		entered_vehicle_gunner = "",
		START_ATTACK = "PlayerAttack",
	},

	PlayerAttack = {
		entered_vehicle = "",
		entered_vehicle_gunner = "",
		OnLeaderActionCompleted = "PlayerIdle",
		OnLeaderActionFailed = "PlayerIdle",
	},
}
