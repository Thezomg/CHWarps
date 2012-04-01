proc(_get_warp, @n,
    assign(@name, _warp_sanitize(@n))
    
    if(_warp_exists(@name),
        assign(@info, get_value(concat('entityreborn.chwarps.warps.', @name)))
        return(@info)
    )
    
    return(false)
)

proc(_get_warps,
    assign(@info, get_values('entityreborn.chwarps.warps'))
    
    return(@info)
)

proc(_delete_warp, @n,
    assign(@name, _warp_sanitize(@n))
    
    if(has_value(concat('entityreborn.chwarps.warps.', @name)),
        clear_value(concat('entityreborn.chwarps.warps.', @name))
        return(true)
    , # else
        return(false)
    )
)

proc(_set_warp, @n, @warp,
    assign(@name, _warp_sanitize(@n))
    console(@name)
    
    store_value(concat('entityreborn.chwarps.warps.', @name), @warp)
)

proc(_warp_exists, @name,
    if(not(has_value(concat('entityreborn.chwarps.warps.', _warp_sanitize(@name)))),
        return(false)
    )
    
    return(true)
)