local config = {}

config.bullet_render_distance = 512;
config.bullet_renderer = "stc"; -- neo, stc
config.bullet_size = 0.1;
--only used for stc
config.bullet_rotaion_speed = 4;

config.muzzle_flash_enabled = true;
config.muzzle_flash_render_distance = 256;

config.muzzle_smoke_enabled = true;
config.muzzle_smoke_render_distance = 256;
config.muzzle_fire_enabled = true;
config.muzzle_fire_render_distance = 256;

function config.set(key, value)
    config[key] = value
end

function config.get(key)
    return config[key]
end

return config