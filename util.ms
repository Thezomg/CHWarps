proc(_get_warp, @n,
    assign(@name, to_lower(@n))
    
    if(_warp_exists(@name),
        assign(@info, get_value(concat('entityreborn.chwarps.warps.', @name)))
        return(@info)
    )
    
    return(false)
)

proc(_set_warp, @n, @warp,
    assign(@name, to_lower(@n))
    
    store_value(concat('entityreborn.chwarps.warps.', @name), @warp)
)

proc(_warp_exists, @name,
    if(not(has_value(concat('entityreborn.chwarps.warps.', to_lower(@name)))),
        return(false)
    )
    
    return(true)
)