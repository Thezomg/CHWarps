#CHWarps

>Warp system made with MethodScript in the bukkit plugin [CommandHelper][1]

CHWarps permissions is mainly by owner.

**Commands**

 - /warp [p]create <name> - create a new warp. Private if *pcreate* is used at current location.
 - /warp set <name> - alias for /warp create.
 - /warp delete <name> - delete a warp.
 - /warp public <name> - set warp to public.
 - /warp private <name> - set warp to private.
 - /warp welcome <name> [message] - set warp's welcome message.
 - /warp invite <name> <player> - allow a player to bypass private warp status.
 - /warp uninvite <name> <player> - disallow a player to bypass private warp status.
 - /warp list - list available public warps as well as warps shared to you.

**Permissions**

 - chwarps.admin - bypass warps as if you were the owner.
 - chwarps.create - gives ability to use */warp create*.
  - chwarps.warp
 - chwarps.warp - give ability to even use any warps
 - chwarps.sign.create - give ability to make warp signs
 - chwarps.sign.use - give ability to use warp signs
  - chwarps.warp

[1]: http://wiki.sk89q.com/wiki/CommandHelper