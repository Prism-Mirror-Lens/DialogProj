class GFxDialogueHUD extends GFxProjectedUI;

var GFxObject dialogueBox,scrollbar;
var GFxClikWidget responsesBox;
var PlayerController PlayerOwner;
var float MouseX, MouseY;
var DialogueHandler dHandler;
var bool bShouldClose;

function populateDialogue(String body, array<ResponseStruct> responses, optional string lastResponse)
{
	local GFxObject temp;
	local GFxObject dp;
	local byte i;

	dp = CreateArray();

	for(i = 0; i < responses.Length; i++)
	{
		temp = CreateObject("Object");
		temp.SetString("label", responses[i].text);
		temp.SetFloat("index", i);
		dp.SetElementObject(i, temp);
	}

	responsesBox.SetFloat("rowCount", Clamp(responses.Length, 2, 10));

	lastResponse = "<br/><FONT COLOR=\"#FF0000\">"$lastResponse$"</FONT>";
	
	AddStringToBody(lastResponse $ chr(10) $ body);
	setDataProvider(dp);
}

function setDataProvider(GFxObject dp)
{
	ActionScriptVoid("_root.setDataProvider");
}

function AddStringToBody(string extraString)
{
	ActionScriptVoid("_root.AddStringToBody");
}

function WidgetInit(string WidgetName, string WidgetPath, GFxClikWidget Widget)
{
	switch(WidgetName)
	{
	case ("body"):
		dialogueBox = Widget;
		break;
	case ("responses"):
		responsesBox = Widget;
		break;
	case ("sb"):
		scrollbar = Widget;
		break;
	default:
		break;
	}
}

function clearDialogue()
{
	dialogueBox.SetString("htmlText", "");
}

function getNextNode(string idx)
{
	local string lastResponse;

	lastResponse = dHandler.responses[int(idx)].text;
	dHandler.getNode(dHandler.responses[int(idx)].ID);
	if(bMovieIsOpen)
		populateDialogue(dHandler.body, dHandler.responses, lastResponse);
}

function Init(optional LocalPlayer player)
{
	super.Init(player);
}

function AddCaptureKeys()
{
	AddCaptureKey('W');
    AddCaptureKey('A');
    AddCaptureKey('S');
    AddCaptureKey('D');
    AddCaptureKey('Spacebar');
    AddCaptureKey('T');
    AddCaptureKey('R');
    AddCaptureKey('Y');
    AddCaptureKey('X');
    AddCaptureKey('C');
    AddCaptureKey('Q');
	AddCaptureKey('Escape');
}

DefaultProperties
{
	MovieInfo=SwfMovie'DialogProjPkb.DialogueHUD'
	bEnableGammaCorrection = false
	bDisplayWithHudOff = false
	bAutoPlay = false
	bPauseGameWhileActive=false
	bIgnoreMouseInput=false
	bCaptureInput=true

	WidgetBindings.Add((WidgetName="body", WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="responses", WidgetClass=class'GFxClikWidget'))

	bShouldClose = false
}
