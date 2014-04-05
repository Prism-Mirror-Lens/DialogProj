class MainHUD extends UTHUDBase;

var GFxDialogueHUD dialogueHUD;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	dialogueHUD = new class'DialogProj.GFxDialogueHUD';
	dialogueHUD.PlayerOwner = PlayerOwner;
	dialogueHUD.Init(LocalPlayer(PlayerOwner.Player));
}

function showDialogue()
{
	dialogueHUD.Start();
}

exec function showMenu()
{
	dialogueHUD.Close(true);
}

singular event Destroyed()
{
	if( dialogueHUD != none)
	{
		dialogueHUD.Close(true);
		dialogueHUD = none;
	}
}


function populateDialogue(String body, array<ResponseStruct> responses)
{
	dialogueHUD.populateDialogue(body, responses);
}

function Vector2d GetMouseCoords()
{
	local Vector2d mousePos;

	mousePos.X = dialogueHUD.MouseX;
	mousePos.Y = dialogueHUD.MouseY;

	return mousePos;
}

DefaultProperties
{
	bShowHUD = false
}
