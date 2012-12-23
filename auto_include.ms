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
    return(reg_replace('[^0-9a-zA-Z.]', '_', to_lower(@n)))
)

proc(_warp_delete, @n,
    @name = _warp_sanitize(@n)
    @player = to_lower(player())
    
    if(_warp_exists(@name)) {
        @warp = _get_warp(@name)
        
        if(
        @warp['owner'] == @player ||
        player() == '~console' ||
        _warp_perm('admin')) {
            _delete_warp(@name)
            msg(color(green). 'Warp deleted.')
        } else {
            msg(color(red). 'You don\'t own this warp!')
        }
    } else {
        msg(color(red). 'No warp with this id exists!')
    }
)

proc(_warp_list,
    # Get a list of warps, sensitive to if the warp
    # is accessible by the user or not.
    
    @warps = _get_warps()
    @player = to_lower(player())
    
    msg('Warps you have access to:')
    
    foreach(@warps, @warp) {
        # User must be owner or shared, or warp must be
        # public to be displayed.
        
        if(
        @warp['isprivate'] == false ||
        @warp['owner'] == @player ||
        array_contains(@warp['sharedto'], @player) ||
        @player == '~console' ||
        _warp_perm('admin')) {
            # - WarpName
            msg('-' @warp['name'])
        }
    }
)

proc(_warp_update,
    @warps = _get_warps()
    
    foreach(@warps, @warp,
        if(!array_index_exists(@warp, 'welcome')) {
            @warp['welcome'] = 'Welcome to' @warp['name']
        }
        @warp['owner'] = to_lower(@warp['owner'])

        _set_warp(@warp['name'], @warp)
    )
)

proc(_warp_create, @n, assign(@private, false),
    @name = _warp_sanitize(@n)
    
    if(player() == '~console') {
        die(color('red'). 'Player context is required.')
    }

    if(
    !_warp_perm('create')) {
        die(color('red'). 'You don\'t have proper permissions.')
    }

    if(
    is_null(@name) ||
    @name == '') {
        die(color(red). 'You must specify a name!')
    }
    
    # Don't create a warp if this name is occupied.
    if(!_warp_exists(@name)) {
        # Set the data for this warp.
        # Default to private warps.
        
        @warp = array()
        @warp['owner'] = to_lower(player())
        @warp['location'] = ploc()
        @warp['facing'] = pfacing()
        @warp['sharedto'] = array()
        @warp['isprivate'] = @private
        @warp['welcome'] = ('Welcome to' @n)
        @warp['name'] = @n
        
        _set_warp(@name, @warp)
        msg(color(green). 'Warp created successfully!')
    } else {
        msg(color(red). 'This warp already exists!')
    }
)

proc(_warp_welcome, @n, @message,
    @name = _warp_sanitize(@n)
    @player = to_lower(player())

    if(_warp_exists(@name)) {
        @warp = _get_warp(@name)
        
        # Must be owner to change this.
        if(!(@player == @warp['owner'] ||
        player() == '~console' ||
        _warp_perm('admin'))) {
            die(color(red). 'You do not own this warp!')
        }
        
        # Change the message
        @warp['welcome'] = @message
        _set_warp(@warp['name'], @warp)
        
        # Notify.
        die(color(green). 'Welcome message changed.')
    } else {
        die(color(red). 'This warp doesn\'t exist!')
    }
)

proc(_warp_private, @n, @private,
    @name = _warp_sanitize(@n)
    @player = to_lower(player())
    
    if(_warp_exists(@name)) {
        @warp = _get_warp(@name)
        
        # Must be owner to change this.
        if(!(@player == @warp['owner'] ||
        @player == '~console' ||
        _warp_perm('admin'))) {
            die(color(red). 'You do not own this warp!')
        }
        
        # Change the private bit.
        @warp['isprivate'] = @private
        _set_warp(@warp['name'], @warp)
        
        # Notify.
        if(@private) {
            die(color(green). @warp['name'] 'is now private.')
        } else {
            die(color(green). @warp['name'] 'is now public.')
        }
    } else {
        die(color(red). 'This warp doesn\'t exist!')
    }
)

proc(_warp_share, @n, @p, @s = true,
    # Share or unshare a (private) warp.
    @player = to_lower(@p)
    @name = _warp_sanitize(@n)
    
    # Allow only true/false.
    switch(@s,
        array(true, false),
            assign(@shared, @s),
        die('Invalid option.')
    )
    
    if(_warp_exists(@name)) {
        @warp = _get_warp(@name)

        # Must be owner to change this.
        if(!(to_lower(player()) == @warp['owner'] ||
        player() == '~console' ||
        _warp_perm('admin'))) {
            die(color(red). 'You do not own this warp!')
        }

        if(@shared) {
            if(!array_contains(@warp['sharedto'], @player)) {
                # Only add if the player isn't already in the list.
                    
                array_push(@warp['sharedto'], @player)
                _set_warp(@name, @warp)
                    
                die(color(green). 'Player granted access.')
            } else {
                # Player already on list.        
                die(color(red). 'That player already has access to this warp!')
            }
        } else {    
            # remove player from shared list
            if(array_contains(@warp['sharedto'], @player)) {
                array_remove_values(@warp['sharedto'], @player)
                _set_warp(@name, @warp)
                die(color(green). 'Player removed from access.')
            } else {
                # Player is already denied.
                die(color('red'). 'This Player did not have access to this warp!')
            }
        }
    } else {
        die(color(red). 'This warp doesn\'t exist!')
    }
)

proc(_warp_to, @n,
    @name = _warp_sanitize(@n)
    
    if(_warp_exists(@name)) {
        # Grab the info
        @info = _get_warp(@name)
        @shared = @info['sharedto']
        @player = to_lower(player())
        
        # Make sure the user has perms to go here!
        if((
        @info['owner'] == @player ||
        @info['isprivate'] == false ||
        array_contains(@shared, @player) ||
        _warp_perm('admin')) && _warp_perm('warp')) {
            # Poof.
            pfacing(player(), @info['facing'][0], @info['facing'][1])
            set_ploc(player(), @info['location'])
            
            if(
            is_string(@info['welcome']) &&
            !@info['welcome'] == '') {
                msg(colorize(@info['welcome']))
            }
        } else {
            die(color(red). 'You do not have permission to visit this warp.')
        }
    } else {
        die(color(red). 'This warp does not exist!')
    }
)
