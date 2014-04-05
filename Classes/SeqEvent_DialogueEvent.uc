class SeqEvent_DialogueEvent extends SequenceEvent;

var String message;
var() String expectedMessage;
var bool canActivate;

event Activated()
{
	`log("DIALOGUE EVENT ACTIVATED");
	canActivate = (message == expectedMessage);
}



DefaultProperties
{
	ObjName="Dialogue Event"
	ObjCategory="Dialogue"
	bPlayerOnly=false
	MaxTriggerCount=0
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Message",bWriteable=false, propertyName=message)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Activated?",bWriteable=false, propertyName=canActivate)
}
