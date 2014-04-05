class Evaluator extends Object
dependson(SQLProject_DLLAPI);

var private SQLProject_DLLAPI mDLLAPI;

function bool evaluateBool(string condition)
{
	return mDLLAPI.evaluate(condition);
}

DefaultProperties
{
	Begin Object Class=SQLProject_DLLAPI Name=DllApiInstance
	End Object
	mDLLAPI=DllApiInstance
}
