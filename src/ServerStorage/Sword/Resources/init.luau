local Resources = {}
function Resources:GetResource(Name)
	return script:WaitForChild(Name)
end
return Resources

