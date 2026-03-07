--try to get rid of unknown sprites for player states
local states2 = {}
for i=S_THOK,S_JETFUMEFLASH--0,#states-1
	if states[i].sprite ~= SPR_UNKN
		states2[i] = {sprite = states[i].sprite, frame = states[i].frame}
	end
end

addHook("PostThinkFrame", do
	for i=S_THOK,S_JETFUMEFLASH--0,#states-1
		if states[i].sprite == SPR_UNKN and states2[i]
			states[i].sprite,states[i].frame = states2[i].sprite, states2[i].frame
		end
	end
end)