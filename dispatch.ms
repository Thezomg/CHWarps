proc(_warp_dispatch, @input,
    # Parse the incoming command, depending on it's first
    # word.

    # Called with empty command?

    @match = parse_args(@input)
    if(array_size(@match)) {
        @first = array_remove(@match, 0)
        @args = @match
    } else {
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
    }
    
    switch(@first,
        'update',

            _warp_update()
            die(color(green). 'Any outdated warps were updated.'),
            
        array('set', 'create', 'pcreate'),
            
            if(array_size(@args)) {
                _warp_create(array_implode(@args, ' '), @first == 'pcreate')
            } else {
                die('Usage: /warp [[p]create|set] <name>')
            },
            
        'delete',
            
            if(array_size(@args)) {
                @warp = _search_warp(@args)[0]
                _warp_delete(@warp)
            } else {
                die('Usage: /warp delete <name>')
            },
            
        'public',
            
            if(array_size(@args)) {
                @warp = _search_warp(@args)[0]
                _warp_private(@warp, false)
            } else {
                die('Usage: /warp public <name>')
            },
            
        'private',
            
            if(array_size(@args)) {
                @warp = _search_warp(@args)[0]
                _warp_private(@warp, true)
            } else {
                die('Usage: /warp private <name>')
            },
            
        'welcome',
            if(array_size(@args)) {
                @data = _search_warp(@args)
                @warp = @data[0]
                @id = @data[1]
                @message = array()
                foreach(@args, @key, @n) {
                    if(@key > @id) {
                        array_push(@message, @n)
                    }
                }
                _warp_welcome(@warp, array_implode(@message, ' '))
            } else {
                die('Usage: /warp welcome <name> [message]')
            },
            
        'invite',
            
            if(array_size(@args)) {
                @data = _search_warp(@args)
                @warp = @data[0]
                @id = @data[1]
                foreach(@args, @n) {
                    if(array_index(@args, @n) > @id) {
                    @player = @n
                    break()
                    }
                }
                _warp_share(@warp, @player, true)
            } else {
                die('Usage: /warp invite <name> <player>')
            },
            
        'uninvite',
            
            if(array_size(@args)) {
                @data = _search_warp(@args)
                @warp = @data[0]
                @id = @data[1]
                foreach(@args, @n) {
                    if(array_index(@args, @n) > @id) {
                    @player = @n
                    break()
                    }
                }
                _warp_share(@args[0], @args[1], false)
            } else {
                die('Usage: /warp uninvite <name> <player>')
            },
            
        'list',
            _warp_list(),
        # default
            _warp_to(@input)
    )
)