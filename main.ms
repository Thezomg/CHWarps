if(_warp_config('Warp Signs') == 'true') {
	msg(_warp_config('Warp Signs'))
	console('[CHWarps] Warp Signs enabled', false)
	# Warp signs - warping
	bind(player_interact, null, array(block: 68, button: 'right'), @event,
		@text = get_sign_text(@event['location'])

		if(@text[0] == color('yellow'). '[Warp]') {
		# Check if sign is a warp sign

			cancel()
			# Stops a block place

		@id = import('chwarps.sign.id.'. player())
			# Check if player is already waiting a timeout and stops it
			if(!(is_null(@id) || @id == '')) {
				clear_task(@id)
				@id = ''
			}

			if(_warp_perm('sign.use')) {
			# Player must have perm to use warp signs

				# Timeout to use warp
				if(!@text[2] == '') {
					@timeout = @text[2]
					msg('Warping to' @text[1] 'in' @timeout 'seconds.')
				} else {
					_warp_to(@text[1])
					die()
				}

				@timeout -= 1
				export('chwarps.sign.i.'. player(), @timeout)

				@id = set_interval(1000, closure(
					@id = import('chwarps.sign.id.'. player())
					@i = import('chwarps.sign.i.'. player())
					if(@i <= 10 && @i != 0) {
						msg('Warp in' @i 'Seconds')
					}
				
					# if ready to warp, Warp!
					if(@i <= 0) {
						clear_task(@id)
						_warp_to(@text[1])
					}
					@i -= 1
					export('chwarps.sign.i.'. player(), @i)
				))
					# export timer id so it cancel itself
					export('chwarps.sign.id.'. player(), @id)
			} else {
				die(color(red). 'You do not have permission to visit this warp.')
			}
		} else {
			die()
		}
	)
	
	# warp signs - Creating
	bind(sign_changed, null, array(1: '/\\[[Ww]arp\\]/'), @event,
		if(!_warp_perm('sign.create')) {
			cancel()
			die(color(red). 'You do not have permission to create warp signs.')
		} # Permission checking
		@text = @event['text']

		# checks if values are valid
		if(!_warp_exists(@text[1])) {
			modify_event(2, color('Dark_Red'). @text[1])
			modify_event(1, color('Dark_Red'). '[Warp]')
			die(color('Dark_red'). 'This warp does not exist!')
		} else {
			if(!(is_integral(@text[2]) || @text[2] == '')) {
				modify_event(3, color('Dark_Red'). @text[2])
				modify_event(1, color('Dark_Red'). '[Warp]')
				die(color('DarK_red'). 'That is not a correct parameter for line 3')
			}
		}
		#Format Sign
		modify_event(1, color('Yellow'). '[Warp]')
	)
} else {console('[CHWarps] Warp Signs are not enabled', false)}