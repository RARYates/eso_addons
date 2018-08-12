
local Lib3D = LibStub("Lib3D2")

function Harvest.Get3DPosition()
	local x,y,z = Lib3D:ComputePlayerRenderSpacePosition()
	if IsMounted() then y = y - 1 end -- approx horse height
	return x,y,z
end

-- the rest is internal stuff for testing and not used by the addon

function Harvest.GetCameraHeight()
	local x, z, y = Lib3D:GetCameraRenderSpacePosition()
	return z
end
