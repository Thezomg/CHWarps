proc(_warp_dispatch, @input,
    # Parse the incoming command, depending on it's first
    # word.
    
    # Called with empty command?
    assign(@match, reg_match('^\\s*([^ ]+)(\\s+(.*)\\s*)?$', @input))
    if(@match,
        assign(@first, to_lower(@match[1]))
        assign(@args, @match[3])
    , # else
        msg('The following commands are available:')
        msg('- ', color(green), '/warp', color(white), ': show this message')
        msg('- ', color(green), '/warp [p]create <name>', color(white), ': create a new warp. Private if pcreate is used.')
        msg('- ', color(green), '/warp set <name>', color(white), ': alias for /warp create.')
        msg('- ', color(green), '/warp delete <id>', color(white), ': delete a warp.')
        msg('- ', color(green), '/warp public <name>', color(white), ': set warp to public.')
        msg('- ', color(green), '/warp private <name>', color(white), ': set warp to private.')
        msg('- ', color(green), '/warp welcome <name> [message]', color(white), ': set warp\'s welcome message.')
        msg('- ', color(green), '/warp invite <name> <player>', color(white), ': allow a player to bypass private warp status.')
        msg('- ', color(green), '/warp uninvite <name> <player>', color(white), ': disallow a player to bypass private warp status.')
        msg('- ', color(green), '/warp list', color(white), ': list available public warps as well as warps shared to you.')
        return()
    )
    
    switch(@first,
        'update',
            # HIDDEN FEECHUR!
            _warp_update()
            die(concat(color(green), 'Any outdated warps were updated.')),
            
        array('set', 'create', 'pcreate'),
            assign(@args, reg_match('^(.+)$', @args))
            
            if(@args,
                _warp_create(@args[1], @first == 'pcreate')
            , # else
                die('Usage: /warp [[p]create|set] <name>')
            ),
            
        'delete',
            assign(@args, reg_match('^(.+)$', @args))
            
            if(@args,
                _warp_delete(@args[1])
            , # else
                die('Usage: /warp delete <name>')
            ),
            
        'public',
            assign(@args, reg_match('^(.+)$', @args))
            
            if(@args,
                _warp_private(@args[1], false)
            , # else
                die('Usage: /warp public <name>')
            ),
            
        'private',
            assign(@args, reg_match('^(.+)$', @args))
            
            if(@args,
                _warp_private(@args[1], true)
            , # else
                die('Usage: /warp private <name>')
            ),
            
        'welcome',
            assign(@args, reg_match('^(.*?)\\s+([^ ]+)$', @args))
            
            if(@args,
                _warp_welcome(@args[1], @args[2])
            , # else
                die('Usage: /warp welcome <name> [message]')
            ),
            
        'invite',
            assign(@args, reg_match('^(.*?)\\s+([^ ]+)$', @args))
            
            if(@args,
                _warp_share(@args[1], @args[2], true)
            , # else
                die('Usage: /warp invite <name> <player>')
            ),
            
        'uninvite',
            assign(@args, reg_match('^(.*?)\\s+([^ ]+)$', @args))
            
            if(@args,
                _warp_share(@args[1], @args[2], false)
            , # else
                die('Usage: /warp uninvite <name> <player>')
            ),
            
        'list',
            _warp_list()
            return(),
        # default
            _warp_to(@input)
    )
)