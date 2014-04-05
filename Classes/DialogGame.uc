Class DialogGame extends UDKGame;

var private DialogueHandler dHandler;
var private SQLProject_DatabaseMgr dbmgr;
var private DialogPlayerController player;
var private Dialogue_NPC_Controller currentDialogueActor;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return default.class;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	dbmgr.initDatabase(self);
	dHandler.init(self, dbmgr.getDLLAPI(), dbmgr.mDialogueDatabaseIdx, dbmgr);
	player = DialogPlayerController(GetALocalPlayerController());
}

function initiateDialogue(Dialogue_NPC_Pawn NPC)
{
	dHandler.selectSet(NPC.NPC_Name);
	MainHUD(WorldInfo.GetALocalPlayerController().myHUD).showDialogue();
	dHandler.getNode(NPC.startNode);
	MainHUD(WorldInfo.GetALocalPlayerController().myHUD).populateDialogue(dHandler.body, dHandler.responses);
	MainHUD(WorldInfo.GetALocalPlayerController().myHUD).dialogueHUD.dHandler = dHandler;
	currentDialogueActor = Dialogue_NPC_Controller(NPC.Controller);
}

function findAndLoadNextNode(int index)
{
	dHandler.getNode(dHandler.responses[index].ID);
}

exec function give(String itemName)
{
	`log("GAVE ITEM"@itemName);
}

exec function float getPlayerStat(String stat)
{
	local string statStmt;
	local float result;
	local SQLProject_DLLAPI mDLLAPI;
	mDLLAPI = dbmgr.getDLLAPI();
	statStmt = "SELECT value FROM gameplay_stats WHERE stat = ?";
	mDLLAPI.SQL_selectDatabase(dbmgr.mGameplayDatabaseIdx);
	mDLLAPI.SQL_prepareStatement(statStmt);
	mDLLAPI.SQL_bindValueString(1, stat);
	mDLLAPI.SQL_executeStatement();
	mDLLAPI.SQL_nextResult();
	mDLLAPI.SQL_getFloatVal("value", result);
	`log("GOT STAT - " $ result);
	return result;
}

exec function setPlayerStat(String stat, int amount)
{
	updateSymbol(stat, amount);
}

exec function addToPlayerStat(String stat, float amount)
{
	local float newval;
	newval = getPlayerStat(stat) + amount;
	UpdateSymbol(stat, newval);
}

exec function announce(String announcement)
{
	`log(announcement);
}

exec function endDialogue()
{
	MainHUD(WorldInfo.GetALocalPlayerController().myHUD).dialogueHUD.clearDialogue();
	MainHUD(WorldInfo.GetALocalPlayerController().myHUD).dialogueHUD.Close(false);
}

exec function triggerDialogueEvent(String message)
{
	local Sequence GameSeq;
	local array<SequenceObject> AllSeqEvents;
	local int i;

	GameSeq = WorldInfo.GetGameSequence();
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_DialogueEvent',true,AllSeqEvents);
		for(i = 0; i < AllSeqEvents.Length; i++)
		{
			`log("EXECUTING DIALOGUE EVENT:"$message);
			SeqEvent_DialogueEvent(AllSeqEvents[i]).message = message;
			SeqEvent_DialogueEvent(AllSeqEvents[i]).CheckActivate(WorldInfo, DialogGame(WorldInfo.Game).currentDialogueActor.Pawn);
		}
	}
}

exec function setStartNode(int newStartNode)
{
	Dialogue_NPC_Pawn(currentDialogueActor.Pawn).startNode = newStartNode;
}

exec function updateToken(string token, string newValue)
{
	dbmgr.getDLLAPI().updateToken(token, newValue, dbmgr.mGameplayDatabaseIdx);
	dbmgr.getDLLAPI().SQL_saveDatabase(dbmgr.mUserCodeRelPathUDKGame $ dbmgr.mDataRootPath $ dbmgr.mDefaultGameplayDB);
}

exec function updateSymbol(string symbol, float newValue)
{
	dbmgr.getDLLAPI().updateSymbol(symbol, newValue, dbmgr.mGameplayDatabaseIdx);
	dbmgr.getDLLAPI().SQL_saveDatabase(dbmgr.mUserCodeRelPathUDKGame $ dbmgr.mDataRootPath $ dbmgr.mDefaultGameplayDB);
}

defaultproperties
{
	PlayerControllerClass=class'DialogProj.DialogPlayerController'
	HUDType=class'DialogProj.MainHUD'

	Begin Object Class=DialogueHandler Name=HandlerInstance
	End Object
	dHandler = HandlerInstance

	Begin Object Class=SQLProject_DatabaseMgr Name=mgrInstance
	End Object
	dbmgr = mgrInstance
}