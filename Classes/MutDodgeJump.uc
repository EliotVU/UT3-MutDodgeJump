// Coded by Eliot @ 2007-2008.
Class MutDodgeJump Extends UTMutator
	Config(MutDodgeJump);

var() config bool bAllowMultiDodge;
var array<Controller> DodgeJumpOwners;

Function ModifyPlayer( Pawn other )
{
	local DodgeJumpInfo A;
	local int i, j;

	if( Other.Controller.IsA('UTPlayerController') )
	{
		j = DodgeJumpOwners.Length;
		for( i = 0; i < j; i ++ )
		{
			if( Other.Controller == DodgeJumpOwners[i] )	// Player already has an dodgejump info actor.
			{
				Super.ModifyPlayer(Other);
				return;
			}
		}

		// Create one for this controller.
		DodgeJumpOwners[DodgeJumpOwners.Length] = Other.Controller;
		A = Spawn( Class'DodgeJumpInfo', Other.Controller );
		A.Mutator = Self;
	}
	Super.ModifyPlayer(Other);
}

// Worked without.
/*Function GetSeamlessTravelActorList( bool bToEntry, out array<Actor> ActorList )
{
	Super.GetSeamlessTravelActorList(bToEntry,ActorList);
	DodgeJumpOwners.Length = 0;
}*/

// Old method.
/*Function bool CheckReplacement( Actor Other )
{
	local DodgeJumpInfo A;

	if( Other.IsA('UTPlayerController') )
	{
		A = Spawn( Class'DodgeJumpInfo', Other );
		A.Mutator = Self;
	}
	return Super.CheckReplacement(Other);
}*/

DefaultProperties
{
	bAllowMultiDodge=False
	bExportMenuData=False
	GroupNames(0)="DodgeJump"
}
