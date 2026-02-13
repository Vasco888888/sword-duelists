local RemoteEventCreator = {}
local Tool = script.Parent.Parent
function RemoteEventCreator:CreateRemoteEvent(Name)
	if Tool:FindFirstChild(Name) then
		warn("Conflicting item "..Name.." exists in "..Tool:GetFullName())
	end
	local RemoteEvent = Instance.new("RemoteEvent")
	RemoteEvent.Name = Name
	RemoteEvent.Parent = Tool
	return RemoteEvent
end
function RemoteEventCreator:CreateRemoteFunction(Name)
	if Tool:FindFirstChild(Name) then
		warn("Conflicting item "..Name.." exists in "..Tool:GetFullName())
	end
	local RemoteFunction = Instance.new("RemoteFunction")
	RemoteFunction.Name = Name
	RemoteFunction.Parent = Tool
	return RemoteFunction
end
function RemoteEventCreator:GetRemoteEvent(Name)
	return Tool:WaitForChild(Name)
end
function RemoteEventCreator:GetRemoteFunction(Name)
	return RemoteEventCreator:GetRemoteEvent(Name)
end
return RemoteEventCreator

