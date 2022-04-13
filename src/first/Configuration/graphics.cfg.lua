local config = {}

config.bullet_render_distance = 512;
config.bullet_renderer = "stc"; -- neo, stc

function config.set(key, value)
    config[key] = value
end

function config.get(key)
    return config[key]
end

return config