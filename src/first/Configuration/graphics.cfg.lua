local config = {}

config.bullet_render_distance = 512;
config.bullet_renderer = "stc"; -- neo, stc
config.bullet_size = 0.1;
--only used for stc
config.bullet_rotaion_speed = 4;

config.bullet_hit_sparks = 16;

function config.set(key, value)
    config[key] = value
end

function config.get(key)
    return config[key]
end

return config