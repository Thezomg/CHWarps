proc(_warp_dispatch, @args,
    # Parse the incoming command, depending on it's first
    # word.
    
    # Called with empty command?
    ifelse(array_index_exists(@args, 0),
        assign(@first, @args[0]) # pop first item
        array_remove(@args, 0)
    , # else
        msg('The following commands are available:')
        msg('- ', color(green), '/chwarp', color(white), ': show this message')
        msg('- ', color(green), '/chwarp [p]create <name>', color(white), ': create a new warp. Private if pcreate is used.')
        msg('- ', color(green), '/chwarp delete <id>', color(white), ': delete a warp.')
        msg('- ', color(green), '/chwarp setaccess <name> <public|private>', color(white), ': set warp to public or private.')
        msg('- ', color(green), '/chwarp welcome <name> [message]', color(white), ': set warp\'s welcome message.')
        msg('- ', color(green), '/chwarp share <name> <player>', color(white), ': allow a player to bypass private warp status.')
        msg('- ', color(green), '/chwarp unshare <name> <player>', color(white), ': disallow a player to bypass private warp status.')
        msg('- ', color(green), '/chwarp list', color(white), ': list available public warps as well as warps shared to you.')
        return()
    )
    
    switch(to_lower(@first),
        'update',
            # HIDDEN FEECHUR!
            _warp_update()
            die(concat(color(green), 'Any outdated warps were updated.')),
        array('create', 'pcreate'),
            if(array_index_exists(@args, 0),
                _warp_create(@args[0], equals_ic(@first, 'pcreate'))
            , # else
                die('Usage: /chwarp [p]create <name>')
            ),
        'delete',
            if(array_index_exists(@args, 0),
                _warp_delete(@args[0])
            , # else
                die('Usage: /chwarp delete <name>')
            ),
        'setaccess',
            if(array_index_exists(@args, 1),
                _warp_private(@args[0], @args[1])
            , # else
                die('Usage: /chwarp setaccess <name> <public|private>')
            ),
        'welcome',
            ifelse(equals(length(@args), 1),
                _warp_message(@args[0], ''),
            gt(length(@args), 1),
                _warp_message(@args[0], array_implode(@args))
            , # else
                die('Usage: /chwarp welcome <name> [message]')
            ),
        'share',
            if(array_index_exists(@args, 1),
                _warp_share(@args[0], @args[1], true)
            , # else
                die('Usage: /chwarp share <name> <player>')
            ),
        'unshare',
            if(array_index_exists(@args, 1),
                _warp_share(@args[0], @args[1], false)
            , # else
                die('Usage: /chwarp unshare <name> <player>')
            ),
        'list',
            _warp_list()
            return(),
        # default
            _warp_to(@first)
    )
)