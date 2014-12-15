Script.ReloadScript( "Scripts/Entities/Boids/Chickens.lua" );

Turtles =
{
	Properties = 
	{
		Boid = 
		{
			object_Model = "Objects/characters/animals/reptiles/turtle/red_eared_slider.cdf",
		},
		Movement =
		{
			SpeedMin = 0.2,
			SpeedMax = 0.5,
			MaxAnimSpeed = 2,
		},
	},
	Sounds =
	{
		"Sounds/environment:boids:idle_turtle",    -- idle
		"Sounds/environment:boids:scared_turtle",  -- scared
		"Sounds/environment:boids:scared_turtle",  -- die
		"Sounds/environment:boids:scared_turtle",  -- pickup
		"Sounds/environment:boids:scared_turtle",  -- throw
	},
	Animations =
	{
		"walk_loop",  -- walking
		"idle3",      -- idle1
		"scared",     -- scared anim
		"idle3",      -- idle3
		"pickup",     -- pickup
		"throw",      -- throw
	},
	Editor =
	{
		Icon = "bug.bmp"
	},
}

MakeDerivedEntityOverride( Turtles,Chickens )

function Turtles:OnSpawn()
	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
end

function Turtles:GetFlockType()
	return Boids.FLOCK_TURTLES;
end