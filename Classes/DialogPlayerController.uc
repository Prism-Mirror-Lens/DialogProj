class DialogPlayerController extends SimplePC;

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
	local vector cameraLoc;
	local rotator cameraRot;
	local Actor npc;
	local Vector hitLoc, hitNorm;

	if (Pawn != None)
	{
		// grab camera location/rotation for checking crosshairDist
		GetPlayerViewPoint(cameraLoc, cameraRot);

		//search first for pawns
		npc = Trace(hitLoc, hitNorm, cameraLoc+(Vector(cameraRot)*200), cameraLoc, true);
		if(Dialogue_NPC_Pawn(npc) != none)
		{
			DialogGame(WorldInfo.Game).initiateDialogue(Dialogue_NPC_Pawn(npc));
			return;
		}
		else
		{
			super.GetTriggerUseList(interactDistanceToCheck, crosshairDist, minDot, bUsuableOnly, out_useList);
		}
	}
}


DefaultProperties
{
}
