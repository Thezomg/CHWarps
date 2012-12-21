# gets the warps data called for : returns <array> : expects <warp_name>
proc(_get_warp, @n,
    @name = _warp_sanitize(@n)
        @info = get_value('entityreborn.chwarps.warps.'. @name)
        return(@info)
)

# gets all warps : returns <array>
proc(_get_warps,
    @info = get_values('entityreborn.chwarps.warps')
    return(@info)
)

# deletes warp from persistance : returns <null> : expects <warp_name>
proc(_delete_warp, @n,
    @name = _warp_sanitize(@n)
    clear_value('entityreborn.chwarps.warps.'. @name)
)

# stores the warp in persistance with data provided : returns <null> : expects <warp_name>, <warp_data>
proc(_set_warp, @n, @warp,
    @name = _warp_sanitize(@n)
    store_value('entityreborn.chwarps.warps.'. @name, @warp)
)

# checks if warp exists : returns <boolean> : expects <warp_name>
proc(_warp_exists, @name,
    if(!has_value('entityreborn.chwarps.warps.'. _warp_sanitize(@name))) {
        return(false)
    } else {
        return(true)
    }
)

# checks the permissions for chwarps : returns <boolean> : expects <permission>, [<player>]
proc(_warp_perm, @perm, @p = player(),
    @perm = 'chwarps.'. @perm

    if(has_permission(@p, @perm)) {
        return(true)
    } else {
        return(false)
    }
)