local selected_or_hovered = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then
        paths[1] = tostring(tab.current.hovered.url)
    end
    return paths
end)

return {
    entry = function()
        ya.manager_emit("escape", { visual = true })

        local urls = selected_or_hovered()
        if #urls == 0 then
            return ya.notify { title = "Dragon", content = "No file selected", level = "warn", timeout = 5 }
        end

        local status, err = Command("/Users/charles_chx/.cargo/bin/ripdrag"):arg("-x"):args(urls):spawn()
        if not status then
            ya.notify {
                title = "Ripdrag",
                content = string.format("Ripdrag failed to start: %s", err),
                level = "error",
                timeout = 5,
            }
        end
    end,
}
