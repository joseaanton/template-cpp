workspace "solution"
	architecture "x64"
	startproject "main"
	configurations {
		"Debug",
		"Release"
	}

outputdir = "%{cfg.buildcfg}"

project "main"

	kind "ConsoleApp"
	language "C++"
	cppdialect "C++latest"
	staticruntime "Off" -- note 
	systemversion "10.0"
	toolset "v142"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("build/" .. outputdir .. "/%{prj.name}")

	-- disablewarnings { "4127" }

	files {
		"src/**.h",
		"src/**.cpp"
	}

	--pchheader "pch.h"
    --pchsource "main/src/pch.cpp"

	includedirs {
		"contrib"
	}
	
	-- libdis {}
	-- links {}

	filter "configurations:Debug" 
		defines "_DEBUG"
		symbols "Full"
		warnings "Extra"
		runtime "Debug"

	filter "configurations:Release" 
		defines "NDEBUG"
		optimize "Full"
        symbols "On" -- note
		runtime "Release"

-- añade EnableClangTidyCodeAnalysis
require('vstudio')

local function EnableClangTidyCodeAnalysis(prj)
	premake.w('<EnableClangTidyCodeAnalysis>true</EnableClangTidyCodeAnalysis>')
end

premake.override(premake.vstudio.vc2010.elements, "outputProperties", function(base, prj)
	local calls = base(prj)
	table.insertafter(calls, premake.vstudio.vc2010.targetExt, EnableClangTidyCodeAnalysis)
	return calls
end)
