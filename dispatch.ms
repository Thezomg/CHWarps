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
        msg('- ', color(green), '/chwarp create <name>', color(white), ': create a new warp.')
        msg('- ', color(green), '/chwarp delete <id>', color(white), ': delete a warp.')
        msg('- ', color(green), '/chwarp setaccess <name> <public|private>', color(white), ': set warp to public or private.')
        msg('- ', color(green), '/chwarp share <name> <player>', color(white), ': allow a player to bypass private warp status.')
        msg('- ', color(green), '/chwarp unshare <name> <player>', color(white), ': disallow a player to bypass private warp status.')
        msg('- ', color(green), '/chwarp list', color(white), ': list available public warps as well as warps shared to you.')
        return()
    )
    
    switch(to_lower(@first),
        'create',
            if(array_index_exists(@args, 0),
                _warp_create(@args[0])
            , # else
                die('Usage: /chwarp create <name>')
            ),
        'delete',
            die('Not implemented yet!'),
        'setaccess',
            if(array_index_exists(@args, 1),
                _warp_private(@args[0], @args[1])
            , # else
                die('Usage: /chwarp setaccess <name> <public|private>')
            ),
        'share',
            if(array_index_exists(@args, 2),
                _warp_share(@args[0], @args[1], true)
            , # else
                die('Usage: /chwarp share <name> <player>')
            ),
        'unshare',
            if(array_index_exists(@args, 2),
                _warp_share(@args[0], @args[1], false)
            , # else
                die('Usage: /chwarp unshare <name> <player>')
            ),
        'list',
            die('Not implemented yet!'),
        # default
            _warp_to(@first)
    )
)