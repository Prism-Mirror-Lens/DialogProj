class ScriptHandler extends Object;

var GameInfo ginfo;

function evalScript(string script)
{
	local array<string> scriptlines;
	local int i;
	scriptlines = SplitString(script, "\n", true);
	for(i = 0; i < scriptlines.Length; i++)
	{
		ginfo.ConsoleCommand(scriptlines[i], true);
	}
}

//exec functions are defined in the game class

DefaultProperties
{
}
