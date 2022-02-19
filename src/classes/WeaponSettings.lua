export type Settings = {
    RoundsPerMinute: number,
	BulletSpeed: number,
	BulletDamage: number,
    HeadshotMultiplier: number,
    
    MagazineSize: number,
    SpareAmmo: number,

    TagPower: number,		            -- slows down enemy by this percent
    FallOffPercentage: number,		    -- inversed
    PEN_Armor: number,		            -- the percent that the enemy gets
    PEN_Material: number,			    -- 1 == 100%
    WalkSpeed: number,		            -- out of 250

    Automatic: boolean,		            -- automatic fire
    Burst: boolean,		                -- burst fire

    Shotgun: boolean,		            -- shotgun mode/ overrides everything from the previous 2
    ShotgunPellets: number,		        -- number of pellets

    Tactical: boolean,		            -- tactical mode
    LockOnEmpty: boolean,		        -- lock on empty

    ScopeEnabled: boolean,		        -- scope mode
    ScopeFieldOfView: number,		    -- in degrees
    ScopeDeamp: number,		            -- 1 == 100% recoil or 0.5 == 50% recoil

    CycleTime: number,
    InnacuracyFire: number,
    RecoveryTimeStand: number,
    Pattern: table,

    Deploy: number,
    ClipReady: number,
    FireReady: number,

    --client animations

    Client_Equip: number,
    Client_Idle: number,
    Client_Inspect: number,

    Client_EmptyEquip: number,
    Client_EmptyIdle: number,
    Client_EmptyInspect: number,

    Client_Fire: number,
    Client_Reload: number,
    Client_TacReload: number,

    Client_ShotgunReload: number,
    Client_ShotgunClipIn: number,

    --server animations

    Server_Equip: number,
    Server_Idle: number,
    Server_Inspect: number,

    Server_EmptyEquip: number,
    Server_EmptyIdle: number,
    Server_EmptyInspect: number,

    Server_Fire: number,
    Server_Reload: number,
    Server_TacReload: number,

    Server_ShotgunReload: number,
    Server_ShotgunClipIn: number,
}

local module = {}

return module