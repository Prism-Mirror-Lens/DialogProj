class DialogueHandler extends Object;

var private Evaluator eval;
var private SQLProject_DLLAPI mDLLAPI;
var private ScriptHandler sHandler;
var private SQLProject_DatabaseMgr dbManager;

var private string dialoguePreparedSt;

var private int mDialogueDatabaseIdx;

var private string currentSetName;

//relate to the last gotten node
var string body;

struct ResponseStruct
{
	var string text;
	var int ID;
};

var array<ResponseStruct> responses; 

function init(GameInfo ginfo, SQLProject_DLLAPI anAPI, int index, SQLProject_DatabaseMgr dbMgr)
{
	mDLLAPI = anAPI;
	mDialogueDatabaseIdx = index;
	sHandler.ginfo = ginfo;
	dbManager = dbMgr;
}

function selectSet(string setName)
{
	local int id;
	currentSetName = setName;
	`log(mDLLAPI.SQL_selectDatabase(mDialogueDatabaseIdx));
	dialoguePreparedSt = "SELECT id FROM Dialogue_Sets WHERE name = '"$setName$"'";
	mDLLAPI.SQL_prepareStatement(dialoguePreparedSt);
	mDLLAPI.SQL_executeStatement();
	mDLLAPI.SQL_nextResult();
	mDLLAPI.SQL_getIntVal("ID", id);
	dialoguePreparedSt = "SELECT character, body, script, responses, mood FROM lines WHERE dialogue_set_ID ="@id@"AND id = ?";
	mDLLAPI.SQL_selectDatabase(mDialogueDatabaseIdx);
	mDLLAPI.SQL_prepareStatement(dialoguePreparedSt);
}

//fills out the body and response arrays, executes script
function getNode(int nodeID)
{
	local string responseTemp;
	local array<string> responseSplit;
	local int i;
	local ResponseStruct r;
	local int pos;
	local string nonText;
	local array<string> IDs;
	local bool conditionResult;
	local string script;
	local string tbody;

	responses.Length = 0;
	tbody = class'SQLProject_Defines'.static.initString(1024);
	body = class'SQLProject_Defines'.static.initString(1024);
	responseTemp = class'SQLProject_Defines'.static.initString(1024);
	script = class'SQLProject_Defines'.static.initString(500);

	SelectSet(currentSetName);

	mDLLAPI.SQL_bindValueInt(1, nodeID);
	mDLLAPI.SQL_executeStatement();
	mDLLAPI.SQL_nextResult();
	mDLLAPI.SQL_getStringVal("body", tbody);
	mDLLAPI.processBody(tbody, body);
	mDLLAPI.SQL_getStringVal("responses", responseTemp);
	`log(responseTemp);

	//process script
	mDLLAPI.SQL_getStringVal("script", script);
	sHandler.evalScript(script);

	//process responses
	responseSplit = SplitString(responseTemp, ";\n");
	for(i=0; i < responseSplit.Length; i++)
	{
		pos = Instr(Split(responseSplit[i], "\"", true), "\"");
		r.text = Mid(responseSplit[i], 1, pos);
		
		//if there is only one ID, simply get it and add it
		nonText = Mid(responseSplit[i], pos+3, Len(responseSplit[i])-1);
		IDs = SplitString(nonText, " ", true);
		if(IDs.Length == 1)
		{
			r.ID = int(IDs[0]);
			responses.AddItem(r);
			continue;
		}
		//otherwise, we need to do processing
		conditionResult = eval.evaluateBool(IDs[0]);
		if(conditionResult)
		{
			R.ID = int(IDs[1]);
		}
		else
		{
			if(IDs.Length == 3)
				R.ID = int(IDs[2]);
			else
				continue;
		}
		responses.AddItem(r);
	}
}

function array<string> getFullDialogueNode(int nodeID)
{
	local string character;
	local string locbody;
	local string script;
	local string locresponses;
	local string mood;
	local array<string> result;

	mDLLAPI.SQL_bindValueInt(1, nodeID);
	mDLLAPI.SQL_executeStatement();
	while(mDLLAPI.SQL_nextResult())
	{
		character = class'SQLProject_Defines'.static.initString(30);
			locbody = class'SQLProject_Defines'.static.initString(30);
		script = class'SQLProject_Defines'.static.initString(30);
			locresponses = class'SQLProject_Defines'.static.initString(30);
		mood = class'SQLProject_Defines'.static.initString(30);
		
			mDLLAPI.SQL_getStringVal("character", character);
			mDLLAPI.SQL_getStringVal("body", locbody);
			mDLLAPI.SQL_getStringVal("script", script);
			mDLLAPI.SQL_getStringVal("responses", locresponses);
			mDLLAPI.SQL_getStringVal("mood", mood);

		result.AddItem(character); result.AddItem(locbody); result.AddItem(script); result.AddItem(locresponses); result.AddItem(mood);
	}
	return result;
}

DefaultProperties
{
	Begin Object Class=Evaluator Name=EvaluatorInstance
	End Object
	eval = EvaluatorInstance
	
	Begin Object Class=ScriptHandler Name=SHandlerInstance
	End Object
	sHandler = sHandlerInstance;
}
