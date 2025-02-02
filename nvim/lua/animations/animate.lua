local function animate(dashboard, alpha, frames, start_frame)
	local index = start_frame
	vim.fn.timer_start(100, function()
		dashboard.section.header.val = frames[index]
		alpha.redraw()
		index = (index % #frames) + 1
	end, { ["repeat"] = -1 })
end

return animate
