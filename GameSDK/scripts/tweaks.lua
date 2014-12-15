---------------------------------------------------------------------------------------------
-- Tweak Menu
-- Separated out from tweak system 21/11/2006, Matthew Jack
---------------------------------------------------------------------------------------------
-- Paste this line into the console window to reload the tweaks file.
-- #Script.ReloadScript("Scripts/Tweaks.lua")

--
Script.ReloadScript("Scripts/TweakSystem.lua");
Script.ReloadScript("Scripts/TweaksConfig.lua");

-- Silhouette Mode state
Tweaks.State.SilhouetteModeChanged = nil;
Tweaks.State.SilhouetteModeChangeNow = nil;
Tweaks.State.SilhouetteModeTimerUp = 0.0;
Tweaks.State.SilhouetteModeTimerDown = 0.0;


-- Create/replace the main table of Tweaks
Tweaks.Menus.Main =
{
  MENU = "Main Menu",

	-- The Tweak menu configuration Tweaks
	tMenuTweaks,
	
}

if (Tweaks.Scratchpad.MOTD) then
	Tweaks.Menus.Main["MOTD"] =  
	--- Harmless fun
	{
		NAME = "Message of the day: ",
		LUA = "Dummy",
		NOSAVE = true,
		EVALUATOR = function()
			local timeTable = System.GetLocalOSTime();
			local sec = timeTable.sec;
			local day = timeTable.wday;
			local message = "   Difficult takes a day...loading takes a week...";
			sec = sec % (string.len(message)-1) ;
			local result = string.sub( message, sec) .. string.sub( message, 1, sec+1);
			return result;
		end,
	}
end;

-- evgeny, 9 Dec 2009: ScriptBind_Game.cpp|h of both C1 and C2 don't contain such a method -- commenting out
-- if (Game.IsX360()) then
-- 	Tweaks.Menus.Main["X360Launcher"] =  
-- 	{
-- 		NAME = "Return to X360 Launcher",
-- 		LUA = "Dummy",
-- 		NOSAVE = true,
-- 		EVALUATOR = function() return ""; end,
-- 		INCREMENTER = function()
-- 			if (Game.RebootX360) then 
-- 				Game.RebootX360(); 
-- 			end;
-- 		end,
-- 	}
-- end;

Tweaks.Scratchpad.RELOAD = true;
