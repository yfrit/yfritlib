local oldRequire = _G.require

function _G.require(path, current)
    --if received current, use it to modify the path
    if current then
        --replace everything in current after the last "." with path
        --e.g. ("Event", "EventSystem.Eventer") => "EventSystem.Event"
        path = current:reverse():gsub(".-%.", path:reverse() .. ".", 1):reverse()
    end

    --use pcall to call require
    local ok, module = pcall(oldRequire, path)
    if ok then
        return module
    else
        --if failed, replace the first "." with ".src."
        --e.g. "EventSystem.Event => "EventSystem.src.Event"
        return oldRequire(path:gsub("%.", ".src.", 1))
    end
end
