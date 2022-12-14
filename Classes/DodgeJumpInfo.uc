Class DodgeJumpInfo Extends Info;

var bool bCanMultiDodge;
var MutDodgeJump Mutator;
var UTPlayerController PC;

Replication
{
	if( bNetDirty && (Role == ROLE_Authority) && bNetInitial )
		bCanMultiDodge, PC;
}

Simulated Function Tick( float dt )
{
	local UTPawn Pawn;

	if( WorldInfo.NetMode != NM_Client )
	{
		if( PC == None );	// Send owner to client.
			PC = UTPlayerController(Owner);

		if( PC == None )	// Still none clean up...
		{
			LogInternal( "Destroying myself!", Name );
			Destroy();
			return;
		}

		if( bCanMultiDodge != Mutator.bAllowMultiDodge )
			bCanMultiDodge = True;
	}

	if( PC != None )
	{
		Pawn = UTPawn(PC.Pawn);
		if( Pawn != None )
		{
			if( Pawn.bDodging || PC.DoubleClickDir == DCLICK_Active )
			{
				Pawn.bReadyToDoubleJump = True;
				Pawn.bDodging = False;

				if( bCanMultiDodge )
				{
					// Clear any Direction moves.
					Pawn.CurrentDir = DCLICK_Done;				// Server
					PC.DoubleClickDir = DCLICK_Done;			// Client
					PC.ClearDoubleClick();						// Client
					if( UTPlayerInput(PC.PlayerInput) != None )
						UTPlayerInput(PC.PlayerInput).ForcedDoubleClick = DCLICK_Done;

					ServerResetJumps( Pawn );
				}
			}
		}
	}
}

// No idea if this would be still needed in ut3 but i don't wanna test 999x times to figure out :).
reliable Server Protected Simulated Function ServerResetJumps( UTPawn Pawn )
{
	Pawn.MultiJumpRemaining = Pawn.MaxMultiJump;
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=True
}
