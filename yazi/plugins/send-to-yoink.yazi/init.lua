-- Send files to Yoink plugin for Yazi

return {
	entry = function(_, job)
		local urls = {}
		for _, url in ipairs(job.args) do
			table.insert(urls, tostring(url))
		end

		if #urls == 0 then
			ya.notify {
				title = "Yoink",
				content = "没有选中文件",
				timeout = 3,
				level = "warn",
			}
			return
		end

		-- 构建命令
		local cmd = "open -a Yoink"
		for _, url in ipairs(urls) do
			cmd = cmd .. " " .. ya.quote(url)
		end

		-- 执行命令
		local status = os.execute(cmd .. " 2>/dev/null")

		if status == 0 then
			ya.notify {
				title = "Yoink",
				content = string.format("已发送 %d 个文件", #urls),
				timeout = 3,
				level = "info",
			}
		else
			ya.notify {
				title = "Yoink",
				content = "发送失败",
				timeout = 3,
				level = "error",
			}
		end
	end,
}
