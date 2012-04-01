# entityreborn.warps
#     +-<warp> array
#     |   +-<name> string
#     |        +-<location> vector
#     |        +-<name> string
#     |        +-<facing> vector
#     |        +-<owner> string
#     |        +-<isprivate> boolean
#     |        +-<sharedto> array
#     |              +-<player> string
#     |              +-<player> string
#     |              +-...
#     |
#     +-options

include('util.ms')
include('dispatch.ms')

proc(_warp_sanitize, @n,
    return(reg_replace('[^0-9a-zA-Z-.]', '_', to_lower(@n)))
)

proc(_warp_delete, @n,
    assign(@name, _warp_sanitize(@n))
    
    if(_warp_exists(@name),
        assign(@warp, _get_warp(@name))
        
        if(or(
        equals_ic(@warp['owner'], player()),
        equals_ic(player(), '~console')),
            _delete_warp(@name)
            msg(color(green), 'Warp deleted.')
        , # else
            msg(color(red), 'You don\'t own this warp!')
        )
    , # else
        msg(color(red), 'No warp with this id exists!')
    )
)

proc(_warp_list,
    # Get a list of warps, sensitive to if the warp
    # is accessible by the user or not.
    
    assign(@warps, _get_warps())
    assign(@player, to_lower(player()))
    
    msg('Warps you have access to:')
    
    foreach(@warps, @warp,
        # User must be owner or shared, or warp must be
        # public to be displayed.
        
        if(or(
        equals(@warp['isprivate'], false),
        equals_ic(@warp['owner'], @player),
        array_contains(@warp['sharedto'], @player),
        equals(@player, '~console')),
            # x) WarpName
            msg('-' @warp['name'])
        )
    )
)

proc(_warp_update, 
    assign(@warps, _get_warps())
    
    foreach(@warps, @warp,
        # User must be owner or shared, or warp must be
        # public to be displayed.
        
        if(not(array_index_exists(@warp, 'welcome')),
            assign(@warp['welcome'], 'Welcome to' @warp['name'])
        )
        
        _set_warp(@warp['name'], @warp)
    )
)

proc(_warp_create, @n, assign(@private, false),
    assign(@name, _warp_sanitize(@n))
    
    # Don't create a warp if this name is occupied.
    if(not(_warp_exists(@name)),
        # Set the data for this warp.
        # Default to private warps.
        
        assign(@warp, array())
        array_set(@warp, 'owner', player())
        array_set(@warp, 'location', ploc())
        array_set(@warp, 'facing', pfacing())
        array_set(@warp, 'sharedto', array())
        array_set(@warp, 'isprivate', @private)
        array_set(@warp, 'welcome', 'Welcome to' @n)
        array_set(@warp, 'name', @n)
        
        _set_warp(@name, @warp)
        msg(concat(color(green), 'Warp created successfully!'))
    , # else
        msg(concat(color(red), 'This warp already exists!'))
    )
)

proc(_warp_welcome, @n, @message,
    assign(@name, _warp_sanitize(@n))
    
    if(_warp_exists(@name),
        assign(@warp, _get_warp(@name))
        
        # Must be owner to change this.
        if(to_lower(player()) != @warp['owner'] &&
        player() != '~console',
            die(concat(color(red), 'You do not own this warp!'))
        )
        
        # Change the private bit.
        array_set(@warp, 'welcome', @message)
        _set_warp(@name, @warp)
        
        # Notify.
        die(concat(color(green), 'Welcome message changed.'))
    , # else
        die(concat(color(red), 'This warp doesn\'t exist!'))
    )
)

proc(_warp_private, @n, @private,
    assign(@name, _warp_sanitize(@n))
    assign(@player, to_lower(player()))
    
    if(_warp_exists(@name),
        assign(@warp, _get_warp(@name))
        
        # Must be owner to change this.
        if(@player != @warp['owner'] &&
        @player == '~console',
            die(concat(color(red), 'You do not own this warp!'))
        )
        
        # Change the private bit.
        array_set(@warp, 'isprivate', @private)
        _set_warp(@name, @warp)
        
        # Notify.
        if(@private,
            die(concat(color(green), @name 'is now private.'))
        , # else
            die(concat(color(green), @name 'is now public.'))
        )
    , # else
        die(concat(color(red), 'This warp doesn\'t exist!'))
    )
)

proc(_warp_share, @n, @p, assign(@s, true),
    # Share or unshare a (private) warp.
    assign(@player, to_lower(@p))
    assign(@name, _warp_sanitize(@n))
    
    # Allow only true/false.
    switch(@s,
        array(true, false),
            assign(@shared, @s),
        die('Invalid option.')
    )
    
    if(_warp_exists(@name),
        assign(@warp, _get_warp(@name))
        # Make sure the player is the warp's owner.
        if(player() == @warp['owner'] ||
        player() == '~console',
            if(@shared,
                # Have a cookie.
                
                if(!array_contains(@warp['sharedto'], @player),
                    # Only add if the player isn't already in the list.
                    
                    array_push(@warp['sharedto'], @player)
                    _set_warp(@name, @warp)
                    
                    die(concat(color(green), 'Player granted access.'))
                , # else
                    # Player already on list.
                    
                    die(concat(color(red), 'That player already has access to this warp!'))
                )
            , # else
                # NO WARP 4 U!
                
                if(array_contains(@warp['sharedto'], @player),
                    assign(@i, 0)
                    
                    # Need to loop thru the whole list due to no array_remove_value (yet!).
                    foreach(@warp['sharedto'], @item, 
                        if(@item == @player,
                            array_remove(@warp['sharedto'], @i)
                            _set_warp(@name, @warp)
                            
                            die(concat(color(green), 'Player removed from access.'))
                        , # else
                            inc(@i)
                        )
                    )
                , # else
                    # Player is already denied.
                    
                    die(concat(color(red), 'This player does not have access to this warp!'))
                )
            )
        , # else
            die(concat(color(red), 'This is not your warp to modify!'))
        )
    , # else
        die(concat(color(red), 'This warp doesn\'t exist!'))
    )
)

proc(_warp_to, @n,
    assign(@name, _warp_sanitize(@n))
    
    if(_warp_exists(@name),
        # Grab the info
        assign(@info, _get_warp(@name))
        assign(@shared, @info['sharedto'])
        assign(@player, to_lower(player()))
        
        # Make sure the user has perms to go here!
        if(or(
        equals_ic(@info['owner'], @player), 
        equals(@info['isprivate'], false),
        array_contains(@shared, @player)),
            # Poof.
            pfacing(player(), @info['facing'][0], @info['facing'][1])
            set_ploc(player(), @info['location'])
            
            if(and(
            is_string(@info['welcome']),
            not(equals(@info['welcome'], ''))),
                die(@info['welcome'])
            )
        , # else
            die(concat(color(red), 'You do not have permission to visit this warp.'))
        )
    , # else
        die(concat(color(red), 'This warp does not exist!'))
    )
)