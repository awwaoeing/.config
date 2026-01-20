-- Yazi 初始化配置

-- 自定义 linemode：显示文件和文件夹大小（带单位）
function Linemode:size()
	local size = self._file:size()
	return ui.Line(size and ya.readable_size(size) or "-")
end

-- full-border 插件配置 - 添加完整边框
require("full-border"):setup({
	type = ui.Border.ROUNDED, -- 圆角边框样式
})

-- searchjump 插件配置
require("searchjump"):setup({
	unmatch_fg = "#b2a496",
	match_str_fg = "#000000",
	match_str_bg = "#73AC3A",
	first_match_str_fg = "#000000",
	first_match_str_bg = "#73AC3A",
	label_fg = "#EADFC8",
	label_bg = "#BA603D",
	only_current = false, -- 是否只在当前目录搜索
	show_search_in_statusbar = false,
	auto_exit_when_unmatch = false,
	enable_capital_label = true, -- 启用大写字母标签
})

-- 发送文件到 Yoink 的函数
function Yoink()
	local h = cx.active.current.hovered
	if not h then
		return
	end

	ya.manager_emit("shell", {
		"open -a Yoink \"" .. tostring(h.url) .. "\" &",
		confirm = false,
		block = false,
	})
end

-- 发送选中文件到 Yoink
function YoinkSelected()
	local files = {}
	for _, url in pairs(ya.selected()) do
		table.insert(files, tostring(url))
	end

	if #files == 0 then
		-- 如果没有选中，使用当前文件
		local h = cx.active.current.hovered
		if h then
			table.insert(files, tostring(h.url))
		end
	end

	if #files == 0 then
		return
	end

	for _, file in ipairs(files) do
		ya.manager_emit("shell", {
			"open -a Yoink \"" .. file .. "\" &",
			confirm = false,
			block = false,
		})
	end
end
