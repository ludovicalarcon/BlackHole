ANIMATIONPACK={

	AVAILABLE = {

		Basic = "Scripts/AI/Packs/Animation/Basic.lua",
	}
}



function ANIMATIONPACK:LoadAll()
	
	for name,filename in pairs(self.AVAILABLE) do	
--		AI.LogEvent("Preloading animationPack "..name)
		Script.ReloadScript(filename);
	end
end